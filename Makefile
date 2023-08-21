DATECODE:=$(shell date -u "+%Y%m%d")
SHELL=/bin/bash

T_LIVE_ARCHS=i686 x86_64{,-musl}

T_PLATFORMS=rpi-{armv{6,7}l,aarch64}{,-musl} beaglebone{,-musl} cubieboard2{,-musl} odroid-c2{,-musl} GCP{,-musl} pinebookpro{,-musl}
T_ARCHS=i686 x86_64{,-musl} armv{6,7}l{,-musl} aarch64{,-musl}

T_SBC_IMGS=rpi-{armv{6,7}l,aarch64}{,-musl} beaglebone{,-musl} cubieboard2{,-musl} odroid-c2{,-musl} pinebookpro{,-musl}
T_CLOUD_IMGS=GCP{,-musl}

T_PXE_ARCHS=x86_64{,-musl}

LIVE_ARCHS:=$(shell echo $(T_LIVE_ARCHS))
LIVE_FLAVORS:=base enlightenment xfce mate cinnamon gnome kde lxde lxqt
ARCHS:=$(shell echo $(T_ARCHS))
PLATFORMS:=$(shell echo $(T_PLATFORMS))
SBC_IMGS:=$(shell echo $(T_SBC_IMGS))
CLOUD_IMGS:=$(shell echo $(T_CLOUD_IMGS))
PXE_ARCHS:=$(shell echo $(T_PXE_ARCHS))

ALL_LIVE_ISO=$(foreach arch,$(LIVE_ARCHS), $(foreach flavor,$(LIVE_FLAVORS),langitketujuh-live-$(arch)-$(DATECODE)-$(flavor).iso))
ALL_ROOTFS=$(foreach arch,$(ARCHS),langitketujuh-$(arch)-ROOTFS-$(DATECODE).tar.xz)
ALL_PLATFORMFS=$(foreach platform,$(PLATFORMS),langitketujuh-$(platform)-PLATFORMFS-$(DATECODE).tar.xz)
ALL_SBC_IMAGES=$(foreach platform,$(SBC_IMGS),langitketujuh-$(platform)-$(DATECODE).img.xz)
ALL_CLOUD_IMAGES=$(foreach cloud,$(CLOUD_IMGS),langitketujuh-$(cloud)-$(DATECODE).tar.gz)
ALL_PXE_ARCHS=$(foreach arch,$(PXE_ARCHS),langitketujuh-$(arch)-NETBOOT-$(DATECODE).tar.gz)

SUDO := sudo

REPOSITORY := https://repo-fastly.voidlinux.org/current
L7_REPOSITORY := https://repo-fatih.langitketujuh.id/current
XBPS_REPOSITORY := -r $(REPOSITORY) -r $(REPOSITORY)/musl -r $(REPOSITORY)/aarch64 -r $(L7_REPOSITORY) -r $(L7_REPOSITORY)/musl -r $(L7_REPOSITORY)/aarch64
COMPRESSOR_THREADS:=2

all:

checksum: dist
	cd distdir-$(DATECODE)/ && sha256 * > sha256sum.txt

distdir-$(DATECODE):
	mkdir -p distdir-$(DATECODE)

dist: distdir-$(DATECODE)
	mv langitketujuh*$(DATECODE)* distdir-$(DATECODE)/

live-iso-all: $(ALL_LIVE_ISO)

live-iso-all-print:
	@echo $(ALL_LIVE_ISO) | sed "s: :\n:g"

langitketujuh-live-%.iso:
	@[ -n "${CI}" ] && printf "::group::\x1b[32mBuilding $@...\x1b[0m\n" || true
	$(SUDO) ./build-x86-images.sh -r $(REPOSITORY) -t $*
	@[ -n "${CI}" ] && printf '::endgroup::\n' || true

rootfs-all: $(ALL_ROOTFS)

rootfs-all-print:
	@echo $(ALL_ROOTFS) | sed "s: :\n:g"

langitketujuh-%-ROOTFS-$(DATECODE).tar.xz:
	@[ -n "${CI}" ] && printf "::group::\x1b[32mBuilding $@...\x1b[0m\n" || true
	$(SUDO) ./mkrootfs.sh $(XBPS_REPOSITORY) -x $(COMPRESSOR_THREADS) $*
	@[ -n "${CI}" ] && printf '::endgroup::\n' || true

platformfs-all: $(ALL_PLATFORMFS)

platformfs-all-print:
	@echo $(ALL_PLATFORMFS) | sed "s: :\n:g"

.SECONDEXPANSION:
langitketujuh-%-PLATFORMFS-$(DATECODE).tar.xz: langitketujuh-$$(shell ./lib.sh platform2arch %)-ROOTFS-$(DATECODE).tar.xz
	@[ -n "${CI}" ] && printf "::group::\x1b[32mBuilding $@...\x1b[0m\n" || true
	$(SUDO) ./mkplatformfs.sh $(XBPS_REPOSITORY) -x $(COMPRESSOR_THREADS) $* langitketujuh-$(shell ./lib.sh platform2arch $*)-ROOTFS-$(DATECODE).tar.xz
	@[ -n "${CI}" ] && printf '::endgroup::\n' || true

images-all: platformfs-all images-all-sbc images-all-cloud

images-all-sbc: $(ALL_SBC_IMAGES)

images-all-sbc-print:
	@echo $(ALL_SBC_IMAGES) | sed "s: :\n:g"

images-all-cloud: $(ALL_CLOUD_IMAGES)

images-all-print:
	@echo $(ALL_SBC_IMAGES) $(ALL_CLOUD_IMAGES) | sed "s: :\n:g"

langitketujuh-%-$(DATECODE).img.xz: langitketujuh-%-PLATFORMFS-$(DATECODE).tar.xz
	@[ -n "${CI}" ] && printf "::group::\x1b[32mBuilding $@...\x1b[0m\n" || true
	$(SUDO) ./mkimage.sh -x $(COMPRESSOR_THREADS) langitketujuh-$*-PLATFORMFS-$(DATECODE).tar.xz
	@[ -n "${CI}" ] && printf '::endgroup::\n' || true

# Some of the images MUST be compressed with gzip rather than xz, this
# rule services those images.
langitketujuh-%-$(DATECODE).tar.gz: langitketujuh-%-PLATFORMFS-$(DATECODE).tar.xz
	@[ -n "${CI}" ] && printf "::group::\x1b[32mBuilding $@...\x1b[0m\n" || true
	$(SUDO) ./mkimage.sh -x $(COMPRESSOR_THREADS) langitketujuh-$*-PLATFORMFS-$(DATECODE).tar.xz
	@[ -n "${CI}" ] && printf '::endgroup::\n' || true

pxe-all: $(ALL_PXE_ARCHS)

pxe-all-print:
	@echo $(ALL_PXE_ARCHS) | sed "s: :\n:g"

langitketujuh-%-NETBOOT-$(DATECODE).tar.gz: langitketujuh-%-ROOTFS-$(DATECODE).tar.xz
	@[ -n "${CI}" ] && printf "::group::\x1b[32mBuilding $@...\x1b[0m\n" || true
	$(SUDO) ./mknet.sh langitketujuh-$*-ROOTFS-$(DATECODE).tar.xz
	@[ -n "${CI}" ] && printf '::endgroup::\n' || true

.PHONY: all checksum dist live-iso-all live-iso-all-print rootfs-all-print rootfs-all platformfs-all-print platformfs-all pxe-all-print pxe-all

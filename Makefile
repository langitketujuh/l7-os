GITVER := $(shell git rev-parse --short HEAD)
VERSION = 0.23.1
SHIN    += $(shell find -type f -name '*.sh.in')
SCRIPTS += $(SHIN:.sh.in=.sh)
DATECODE=$(shell date "+%Y%m%d")
SHELL=/bin/bash

T_PLATFORMS=rpi-{armv{6,7}l,aarch64}{,-musl} beaglebone{,-musl} cubieboard2{,-musl} odroid-c2{,-musl} GCP{,-musl} pinebookpro{,-musl}
T_ARCHS=i686 x86_64{,-musl} armv{6,7}l{,-musl} aarch64{,-musl}

T_SBC_IMGS=rpi-{armv{6,7}l,aarch64}{,-musl} beaglebone{,-musl} cubieboard2{,-musl} odroid-c2{,-musl} pinebookpro{,-musl}
T_CLOUD_IMGS=GCP{,-musl}

T_PXE_ARCHS=x86_64{,-musl}

T_MASTERDIRS=x86_64{,-musl} i686

ARCHS=$(shell echo $(T_ARCHS))
PLATFORMS=$(shell echo $(T_PLATFORMS))
SBC_IMGS=$(shell echo $(T_SBC_IMGS))
CLOUD_IMGS=$(shell echo $(T_CLOUD_IMGS))
PXE_ARCHS=$(shell echo $(T_PXE_ARCHS))
MASTERDIRS=$(shell echo $(T_MASTERDIRS))

ALL_ROOTFS=$(foreach arch,$(ARCHS),langitketujuh-$(arch)-ROOTFS-$(DATECODE).tar.xz)
ALL_PLATFORMFS=$(foreach platform,$(PLATFORMS),langitketujuh-$(platform)-PLATFORMFS-$(DATECODE).tar.xz)
ALL_SBC_IMAGES=$(foreach platform,$(SBC_IMGS),langitketujuh-$(platform)-$(DATECODE).img.xz)
ALL_CLOUD_IMAGES=$(foreach cloud,$(CLOUD_IMGS),langitketujuh-$(cloud)-$(DATECODE).tar.gz)
ALL_PXE_ARCHS=$(foreach arch,$(PXE_ARCHS),langitketujuh-$(arch)-NETBOOT-$(DATECODE).tar.gz)
ALL_MASTERDIRS=$(foreach arch,$(MASTERDIRS), masterdir-$(arch))

SUDO := sudo

XBPS_REPOSITORY := -r https://repo-default.voidlinux.org/current -r https://repo-default.voidlinux.org/current/nonfree -r https://repo-default.voidlinux.org/current/musl -r https://repo-default.voidlinux.org/current/musl/nonfree -r https://repo-default.voidlinux.org/current/aarch64 -r https://al.quds.repo.langitketujuh.id/current -r https://al.quds.repo.langitketujuh.id/current/musl

COMPRESSOR_THREADS=2

%.sh: %.sh.in
	 sed -e "s|@@MKLIVE_VERSION@@|$(VERSION) $(GITVER)|g" $^ > $@
	 chmod +x $@

all: $(SCRIPTS)

clean:
	-rm -f *.sh

.PHONY: clean

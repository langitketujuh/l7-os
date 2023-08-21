#!/bin/sh

set -eu

. ./lib.sh

PROGNAME=$(basename "$0")
ARCH=$(uname -m)
IMAGES="base kde-home kde-studio kde-dev kde-datasc sway-home sway-studio sway-dev sway-datasc"
TRIPLET=
DATE=$(date -u +%Y%m%d)
GEN=$(pwgen -sA 7 1)
REMOVE=
REPO=

# base packages
PKGS_BASE="$(grep '^[^#].' pkg/base.txt | xargs)"
PKGS_DESKTOP="$(grep '^[^#].' pkg/desktop.txt | xargs)"
PKGS_KDE="$(grep '^[^#].' pkg/kde.txt | xargs)"
PKGS_SWAY="$(grep '^[^#].' pkg/sway.txt | xargs)"
PKGS_NONFREE="$(grep '^[^#].' pkg/nonfree.txt | xargs)"

# gui apps packages
PKGS_HOME="$(grep '^[^#].' pkg/home.txt | xargs)"
PKGS_STUDIO="$(grep '^[^#].' pkg/studio.txt | xargs)"
PKGS_DEV="$(grep '^[^#].' pkg/dev.txt | xargs)"
PKGS_DATASC="$(grep '^[^#].' pkg/datasc.txt | xargs)"

# remove packages after install
PKGS_REMOVE="$(grep '^[^#].' pkg/remove.txt | xargs)"

# variant packages
# kde plasma
PKGS_KDE_HOME="$PKGS_BASE $PKGS_DESKTOP $PKGS_HOME $PKGS_KDE"
PKGS_KDE_STUDIO="$PKGS_KDE_HOME $PKGS_STUDIO"
PKGS_KDE_DEV="$PKGS_KDE_HOME $PKGS_DEV"
PKGS_KDE_DATASC="$PKGS_KDE_HOME $PKGS_DATASC"

# sway
PKGS_SWAY_HOME="$PKGS_BASE $PKGS_DESKTOP $PKGS_SWAY"
PKGS_SWAY_STUDIO="$PKGS_SWAY_HOME $PKGS_STUDIO"
PKGS_SWAY_DEV="$PKGS_SWAY_HOME $PKGS_DEV"
PKGS_SWAY_DATASC="$PKGS_SWAY_HOME $PKGS_DATASC"

help() {
    echo "${0#/*}: [-a arch] [-b base|kde-home|kde-studio|kde-dev|kde-datasc|sway-home|sway-studio|sway-dev|sway-datasc] [-d date] [-t arch-date-variant] [-r repo] [-R rmpkgs]" >&2
}

while getopts "a:b:d:t:hr:V" opt; do
case $opt in
    a) ARCH="$OPTARG";;
    b) IMAGES="$OPTARG";;
    d) DATE="$OPTARG";;
    h) help; exit 0;;
    r) REPO="-r $OPTARG $REPO";;
    R) REMOVE="$OPTARG";;
    t) TRIPLET="$OPTARG";;
    V) version; exit 0;;
    *) help; exit 1;;
esac
done
shift $((OPTIND - 1))

INCLUDEDIR=$(mktemp -d)
trap "cleanup" INT TERM

cleanup() {
    rm -r "$INCLUDEDIR"
}

build_variant() {
    variant="$1"
    shift
    IMG=langitketujuh-${variant}-${ARCH}-${DATE}-${GEN}.iso
    SERVICES="acpid dbus earlyoom ntpd ufw uuidd zramen"

    LIGHTDM_SESSION=''

    case $variant in
        base)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_BASE"
            else
                PKGS="$PKGS_BASE"
            fi
            SERVICES="$SERVICES dhcpcd wpa_supplicant acpid"
        ;;
        kde-home)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_KDE_HOME $PKGS_NONFREE"
            else
                PKGS="$PKGS_KDE_HOME"
            fi
            SERVICES="$SERVICES NetworkManager backlight bluetoothd bluez-alsa cupsd colord elogind sddm"
        ;;
        kde-studio)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_KDE_STUDIO $PKGS_NONFREE"
            else
                PKGS="$PKGS_KDE_STUDIO"
            fi
            SERVICES="$SERVICES NetworkManager backlight bluetoothd bluez-alsa cupsd colord elogind sddm"
        ;;
        kde-dev)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_KDE_DEV $PKGS_NONFREE"
                REMOVE="$PKGS_REMOVE"
            else
                >&2 echo "Not support architecture $ARCH"
                exit 1
            fi
            SERVICES="$SERVICES NetworkManager backlight bluetoothd bluez-alsa cupsd colord elogind sddm"
        ;;
        kde-datasc)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_KDE_DATASC $PKGS_NONFREE"
                REMOVE="$PKGS_REMOVE"
            else
                >&2 echo "Not support architecture $ARCH"
                exit 1
            fi
            SERVICES="$SERVICES NetworkManager backlight bluetoothd bluez-alsa cupsd colord elogind sddm"
        ;;
        sway-home)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_SWAY_HOME $PKGS_NONFREE"
            else
                PKGS="$PKGS_SWAY_HOME"
            fi
            SERVICES="$SERVICES dhcpcd iwd greetd polkitd"
        ;;
        sway-studio)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_SWAY_STUDIO $PKGS_NONFREE"
            else
                PKGS="$PKGS_SWAY_STUDIO"
            fi
            SERVICES="$SERVICES dhcpcd iwd greetd polkitd"
        ;;
        sway-dev)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_SWAY_DEV $PKGS_NONFREE"
            else
                >&2 echo "Not support architecture $ARCH"
                exit 1
            fi
            SERVICES="$SERVICES dhcpcd iwd greetd polkitd"
        ;;
        sway-datasc)
            if [ "$ARCH" = x86_64 ]; then
                PKGS="$PKGS_SWAY_DATASC $PKGS_NONFREE"
            else
                >&2 echo "Not support architecture $ARCH"
                exit 1
            fi
            SERVICES="$SERVICES dhcpcd iwd greetd polkitd"
        ;;
        *)
            >&2 echo "Unknown variant $variant"
            exit 1
        ;;
    esac

    if [ -n "$LIGHTDM_SESSION" ]; then
        mkdir -p "$INCLUDEDIR"/etc/lightdm
        echo "$LIGHTDM_SESSION" > "$INCLUDEDIR"/etc/lightdm/.session
    fi

    ./mklive.sh -a "$ARCH" -o "$IMG" -p "$PKGS" -R "$REMOVE" -S "$SERVICES" -I "$INCLUDEDIR" ${REPO} "$@"
}

if [ ! -x mklive.sh ]; then
    echo mklive.sh not found >&2
    exit 1
fi

if [ -x installer.sh ]; then
    MKLIVE_VERSION="$(PROGNAME='' version)"
    installer=$(mktemp)
    sed "s/@@MKLIVE_VERSION@@/${MKLIVE_VERSION}/" installer.sh > "$installer"
    install -Dm755 "$installer" "$INCLUDEDIR"/usr/bin/langitketujuh-install
    rm "$installer"
else
    echo installer.sh not found >&2
    exit 1
fi

if [ -n "$TRIPLET" ]; then
    VARIANT="${TRIPLET##*-}"
    REST="${TRIPLET%-*}"
    DATE="${REST##*-}"
    ARCH="${REST%-*}"
    build_variant "$VARIANT" "$@"
else
    for image in $IMAGES; do
        build_variant "$image" "$@"
    done
fi

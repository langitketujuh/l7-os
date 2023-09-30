#!/bin/sh

set -eu

. ./lib.sh

PROGNAME=$(basename "$0")
ARCH=$(uname -m)
IMAGES="base kde-home kde-studio"
TRIPLET=
REPO=
DATE=$(date -u +%Y%m%d)

help() {
    echo "$PROGNAME: [-a arch] [-b base|kde-home|kde-studio] [-d date] [-t arch-date-variant] [-r repo]" >&2
}

while getopts "a:b:d:t:hr:V" opt; do
case $opt in
    a) ARCH="$OPTARG";;
    b) IMAGES="$OPTARG";;
    d) DATE="$OPTARG";;
    h) help; exit 0;;
    r) REPO="-r $OPTARG $REPO";;
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
    IMG=langitketujuh-live-${ARCH}-${DATE}-${variant}.iso
    GRUB_PKGS="grub-i386-efi grub-x86_64-efi"
    LTS_PKGS="linux-lts linux-lts-headers"
    FW_PKGS="alsa-firmware linux linux-base linux-headers sof-firmware"
    TOOLS_PKGS="acpi age bluez chezmoi clinfo cryfs curl diffutils dracut dracut-network dracut-uefi earlyoom elogind encfs exfat-utils f2fs-tools fastfetch fig2dev fish-shell fontconfig gocryptfs gopass gptfdisk helix htop ifuse inetutils inxi iwd librsvg-utils libwebp-tools nano ntfs-3g ntp opendoas optipng pass pinentry pkg-config polkit rnnoise rsv sof-tools tmate tmux udisks2 ufw vim vpsm wget writerperfect xtools yank zramen"
    NONFREE_PKGS="void-repo-nonfree cnijfilter2"

    BASE_L7_PKGS="l7-repo l7-fish-shell l7-helix l7-opendoas l7-removed-packages l7-runit-void l7-shadow l7-tools"
    BASE_PKGS="dialog cryptsetup lvm2 mdadm xtools-minimal xmirror $GRUB_PKGS $LTS_PKGS $FW_PKGS $TOOLS_PKGS $NONFREE_PKGS $BASE_L7_PKGS"

    AC_PKGS="bsdtar 7zip 7zip-unrar unrar unzip xz zip zstd zutils"
    CODEC_PKGS="alsa-pipewire alsa-utils bluez-alsa gstreamer1-pipewire libjack-pipewire pipewire"
    BASEG_PKGS="android-tools android-udev-rules flatpak gnome-keyring wayclip wayland-utils xclip"
    XF86_PKGS="xf86-input-evdev xf86-input-joystick xf86-input-libinput xf86-input-mtrack xf86-input-synaptics xf86-input-vmmouse xf86-input-wacom"
    XORG_PKGS="xorg-minimal xorg-input-drivers xorg-video-drivers setxkbmap xauth font-misc-misc terminus-font dejavu-fonts-ttf orca"
    VULKAN_PKGS="Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers amdvlk libspa-vulkan mesa-vulkan-intel mesa-vulkan-overlay-layer mesa-vulkan-radeon vkBasalt"
    KDE_PKGS="appmenu-gtk3-module colord-kde ffmpegthumbs kde5 kdegraphics-thumbnailers kidentitymanagement kimageformats kio-gdrive ksuperkey libappindicator pinentry-qt plasma-applet-active-window-control plasma-disks plasma-firewall plasma-nm plasma-pa plasma-vault plasma-wayland-protocols qt5-imageformats qt6-wayland sddm konsole dolphin"
    KDEA_PKGS="ark dragon-player elisa gnupg2-scdaemon gwenview kamoso kcalc kcm-wacomtablet kde5-baseapps kdeconnect kfind kgpg kmediaplayer krdc krename krfb ktorrent kwalletmanager okular partitionmanager print-manager skanpage spectacle sweeper"
    FONT_PKGS="amiri-font font-adobe-source-code-pro font-adobe-source-sans-pro-v2 font-adobe-source-serif-pro font-awesome font-awesome5 font-awesome6 font-crosextra-caladea-ttf font-crosextra-carlito-ttf font-liberation-narrow-ttf noto-fonts-emoji ttf-opensans"
    PRINTER_PKGS="bluez-cups brother-brlaser cups cups-filters cups-pdf cups-pk-helper epson-inkjet-printer-escpr foomatic-db foomatic-db-nonfree gutenprint hplip system-config-printer system-config-printer-udev"
    DESKTOP_PKGS="firefox libreoffice libreoffice-kde qownnotes octoxbps corectrl inkscape gimp qpwgraph ssr"
    XDG_PKGS="xdg-desktop-portal xdg-desktop-portal-kde xdg-user-dirs"
    COSM_PKGS="papirus-icon-theme"

    KDE_L7_PKGS="l7-krunner l7-appmenu-gtk3-module l7-ark l7-baloo5 l7-base-files l7-breeze l7-breeze-gtk l7-breeze-icons l7-desktop-file-utils l7-gwenview l7-kate5 l7-kcmutils l7-konsole l7-kscreenlocker l7-kservice l7-kwin l7-plasma-desktop l7-plasma-framework l7-plasma-workspace-wallpapers l7-sddm l7-systemsettings"
    HOME_L7_PKGS="l7-dconf l7-papirus-icon-theme l7-site l7-wiki runit-backlight l7-export l7-gimp l7-inkscape l7-libreoffice l7-octoxbps l7-pipewire l7-qownnotes l7-ssr ccc isoimagewriter webapp-manager"
    HOME_PKGS="$AC_PKGS $CODEC_PKGS $BASEG_PKGS $XF86_PKGS $XORG_PKGS $VULKAN_PKGS $KDE_PKGS $KDEA_PKGS $FONT_PKGS $PRINTER_PKGS $DESKTOP_PKGS $XDG_PKGS $COSM_PKGS $KDE_L7_PKGS $HOME_L7_PKGS"

    STD_CODEC_PKGS="alsa-plugins-ffmpeg cdparanoia flac fluidsynth gst-plugins-ugly1 gstreamer-vaapi libspa-bluetooth libspa-jack mplayer opus-tools speex timidity twolame vorbis-tools vorbisgain wavpack"
    STD_PLUGIN_PKGS="gimp-lqr-plugin gmic gmic-gimp inkscape-generate-palette inkscape-incadiff inkscape-inx-pathops inkscape-nextgenerator"
    STD_AUDIO_PKGS="Carla ardour audacity cadence freepats jack_capture kid3 lmms python3-rdflib qtractor soundkonverter"
    STD_AUDIOP_PKGS="abGate artyfx invada-studio-plugins invada-studio-plugins-lv2 swh-lv2 x42-plugins"
    STD_VIDEOED_PKGS="obs handbrake kdenlive mediainfo mkvtoolnix-gui projectM"
    STD_ANIM_PKGS="goxel blender opentoonz synfigstudio"
    STD_PHOTOG_PKGS="Converseen digikam rawtherapee"
    STD_FONT_PKGS="font-inter google-fonts-ttf"
    STD_PROD_PKGS="LibreCAD freecad openscad"
    STD_LAY_PKGS="python3-tkinter scribus"
    STD_PAINT_PKGS="gmic-krita krita"
    STD_KEY_PKGS="screenkey slop"
    STD_FONTM_PKGS="fontforge"
    STD_PROMP_PKGS="qprompt"
    STD_PANO_PKGS="hugin"
    STD_GAME_PKGS="godot"
    STD_L7_PKGS="l7-ardour l7-audacity l7-blender l7-carla l7-godot l7-goxel l7-krita l7-openscad l7-opentoonz l7-scribus"

    STUDIO_PKGS="$STD_CODEC_PKGS $STD_PLUGIN_PKGS $STD_AUDIO_PKGS $STD_AUDIOP_PKGS $STD_VIDEOED_PKGS $STD_ANIM_PKGS $STD_PHOTOG_PKGS $STD_FONT_PKGS $STD_PROD_PKGS $STD_LAY_PKGS $STD_PAINT_PKGS $STD_KEY_PKGS $STD_FONTM_PKGS $STD_PROMP_PKGS $STD_PANO_PKGS $STD_GAME_PKGS $STD_L7_PKGS"

    SERVICES="sshd"

    LIGHTDM_SESSION=''

    case $variant in
        base)
            PKGS="$BASE_PKGS"
            SERVICES="$SERVICES dhcpcd wpa_supplicant acpid"
        ;;
        kde-home)
            PKGS="$BASE_PKGS $HOME_PKGS"
            SERVICES="$SERVICES NetworkManager bluetoothd bluez-alsa cupsd dbus earlyoom ntpd sddm ufw zramen"
        ;;
        kde-studio)
            PKGS="$BASE_PKGS $HOME_PKGS $STUDIO_PKGS"
            SERVICES="$SERVICES NetworkManager bluetoothd bluez-alsa cupsd dbus earlyoom ntpd sddm ufw zramen"
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

    ./mklive.sh -a "$ARCH" -o "$IMG" -p "$PKGS" -S "$SERVICES" -I "$INCLUDEDIR" ${REPO} "$@"
}

if [ ! -x mklive.sh ]; then
    echo mklive.sh not found >&2
    exit 1
fi

if [ -x installer.sh ]; then
    MKLIVE_VERSION="$(PROGNAME='' version)"
    installer=$(mktemp)
    sed "s/@@MKLIVE_VERSION@@/${MKLIVE_VERSION}/" installer.sh > "$installer"
    install -Dm755 "$installer" "$INCLUDEDIR"/usr/bin/langitketujuh-installer
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

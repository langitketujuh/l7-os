#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

SERVICEDIR=$NEWROOT/etc/sv
SERVICES="$(getarg live.services)"

for f in ${SERVICES}; do
        ln -sf /etc/sv/$f $NEWROOT/etc/runit/runsvdir/default/
done

dhcpcd=1
for f in connmand NetworkManager wicd; do
    if [ -e $SERVICEDIR/$f ]; then
        unset dhcpcd
    fi
done

# Enable all services by default... with some exceptions.
for f in $SERVICEDIR/*; do
    _service=${f##*/}
    case "${_service}" in
        acpid|adb|agetty-console|agetty-generic|agetty-hv*|agetty-serial|agetty-tty[SAU]*|agetty-tty3|agetty-tty4|agetty-tty5|agetty-tty6|alsa|avahi-daemon|boltd|colord|cups-browsed|dhcpcd-*|dmeventd|elogind|fancontrol|gpsd|iptables|ip6tables|isc-ntpd|lvmetad|mysqld|mdadm|pipewire|pipewire-pulse|pulseaudio|polkitd|rsyncd|rtkit|slapd|smartd|sshd|sulogin|svnserve|tcsd|wpa_supplicant) ;; # ignored
        dhcpcd) [ -n "$dhcpcd" ] && ln -sf ${f##$NEWROOT} $NEWROOT/etc/runit/runsvdir/default/;;
        *) ln -sf ${f##$NEWROOT} $NEWROOT/etc/runit/runsvdir/default/;;
    esac
done

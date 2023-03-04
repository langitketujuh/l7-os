#!/bin/sh -x
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

echo langitketujuh-live > ${NEWROOT}/etc/hostname

AUTOLOGIN=$(getarg live.autologin)
USERNAME=$(getarg live.user)
USERSHELL=$(getarg live.shell)
USERCOMMENT="LangitKetujuh Live"

[ -z "$USERNAME" ] && USERNAME=anon
[ -x $NEWROOT/bin/fish -a -z "$USERSHELL" ] && USERSHELL=/bin/fish
[ -z "$USERSHELL" ] && USERSHELL=/bin/bash

# Create /etc/default/live.conf to store USER.
echo "USERNAME=$USERNAME" >> ${NEWROOT}/etc/default/live.conf
chmod 644 ${NEWROOT}/etc/default/live.conf

if ! grep -q ${USERSHELL} ${NEWROOT}/etc/shells ; then
    echo ${USERSHELL} >> ${NEWROOT}/etc/shells
fi

# Create new user and remove password. We'll use autologin by default.
chroot ${NEWROOT} useradd -m -s $USERSHELL -c "$USERCOMMENT" -G _pipewire,audio,bluetooth,video,wheel -s $USERSHELL $USERNAME
chroot ${NEWROOT} passwd -d $USERNAME >/dev/null 2>&1

# Setup default root/user password (langitketujuh).
chroot ${NEWROOT} sh -c 'echo "root:langitketujuh" | chpasswd -c SHA512'
chroot ${NEWROOT} sh -c "echo "$USERNAME:langitketujuh" | chpasswd -c SHA512"

# Enable sudo permission by default.
if [ -f ${NEWROOT}/etc/sudoers ]; then
    echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD: ALL" > "${NEWROOT}/etc/sudoers.d/99-langitketujuh-live"
fi

if [ -d ${NEWROOT}/etc/polkit-1 ]; then
    # If polkit is installed allow users in the wheel group to run anything.
    cat > ${NEWROOT}/etc/polkit-1/rules.d/langitketujuh-live.rules <<_EOF
polkit.addAdminRule(function(action, subject) {
    return ["unix-group:wheel"];
});

polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
_EOF
    chroot ${NEWROOT} chown polkitd:polkitd /etc/polkit-1/rules.d/langitketujuh-live.rules
fi

if [ -n "$AUTOLOGIN" ]; then
    sed -i "s,GETTY_ARGS=\"--noclear\",GETTY_ARGS=\"--noclear -a $USERNAME\",g" ${NEWROOT}/etc/sv/agetty-tty1/conf
fi

#!/bin/sh

dialog --colors --keep-tite --no-shadow --no-mouse \
       --backtitle "\Zb\Z7LangitKetujuh installation -- https://langitketujuh.id/\Zn" \
       --cancel-label "Reboot" --aspect 20 \
       --menu "Select an Action:" 10 50 2 \
       "Install" "Run langitketujuh-install" \
       "Shell" "Run dash" \
       2>/tmp/netmenu.action

if [ ! $? ] ; then
    reboot -f
fi

case $(cat /tmp/netmenu.action) in
    "Install") /usr/bin/langitketujuh-install ; exec sh ;;
    "Shell") exec sh ;;
esac

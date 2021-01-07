## The LangitKetujuh Linux live maker and installer

GNU/Linux Musl distribution based on Voidlinux with KDE Desktop Environment. Rolling Release Stable, Light and Efficient. Lite edition for standard apps and Pro edition for the needs of designers, illustrators, animators and game designers.

#### System requirement:

- 2G RAM.
- CPU Dual core.
- 10G free diskspace.

#### Login:

    anon:langitketujuh
    root:langitketujuh

#### Clone repository

    $ git clone git@gitlab.com:langitketujuh/os.git
    
#### Sub module lite version

    $ git submodule add git@gitlab.com:langitketujuh/lite.git includedir/
    $ git submodule add git@gitlab.com:langitketujuh/pro.git includedir/
    
#### Install Dependencies

    $ xbps-install -S make liblz4 xbps qemu-user-static pwgen

#### Usage

    $ make

and then see the usage output:

    $ sudo sh langitketujuh.sh --help

#### Examples Build

Build a native live image musl edition:

    $ sudo sh langitketujuh.sh --lite-musl
    
Build a native live image glibc edition (not recommended):

    $ sudo sh langitketujuh.sh --lite-glibc

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

    $ git clone git@gitlab.com:langitketujuh/os.git --recursive

#### Install dependencies

    $ xbps-install -S make liblz4 xbps qemu-user-static pwgen

#### Usage

    $ cd os
    $ make

and then see the usage output:

    $ ./build.sh -h

#### Build current architecture

    $ ./build.sh -b lite
    $ ./build.sh -b pro

#### Build different architecture.

    $ ./build.sh -b lite -a x86_64
    $ ./build.sh -b lite -a i686
    $ ./build.sh -b pro -a x86_64-musl

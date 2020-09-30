## The LangitKetujuh Linux live maker and installer

#### Clone repository

    $ git clone git@gitlab.com:langitketujuh/os.git
    
#### Sub module lite version

    $ git submodule add git@gitlab.com:langitketujuh/lite.git includedir/lite/
    
#### Install Dependencies

    $ xbps-install -S make liblz4 xbps qemu-user-static

#### Usage

    $ make

and then see the usage output:

    $ sudo sh langitketujuh.sh help

#### Examples Build

Build a native live image musl edition:

    $ sudo sh langitketujuh.sh lite-musl
    
Build a native live image glibc edition (not recommended):

    $ sudo sh langitketujuh.sh lite-glibc

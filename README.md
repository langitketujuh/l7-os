## The LangitKetujuh Linux live maker and installer

#### Build Dependencies

 * make
 * liblz4
 * xbps
 * qemu-user-static


#### Clone repository

    $ git clone git@gitlab.com:langitketujuh/os.git
    
#### Sub module lite version

    $ git submodule add git@gitlab.com:langitketujuh/lite.git includedir/lite/
    
#### Usage

Type

    $ make

and then see the usage output:

    $ sudo sh langitketujuh.sh help


#### Examples

Build a native live image lite edition':

    # sudo sh langitketujuh.sh lite-musl
    
    # sudo sh langitketujuh.sh lite-glibc

## The LangitKetujuh Linux live maker and installer

#### Build Dependencies

 * make

#### Dependencies

 * Compression type for the initramfs image
   * liblz4 (for lz4, xz) (default)
 * xbps>=0.45
 * qemu-user-static binaries (for mkrootfs)


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

    # sudo sh langitketujuh.sh lite
    
Build a native live image pro edition':

    # sudo sh langitketujuh.sh pro

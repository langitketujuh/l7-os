## The LangitKetujuh Linux live maker and installer

GNU/Linux Musl distribution based on Voidlinux with KDE Desktop Environment. Rolling Release Stable, Light and Efficient. Lite edition for standard apps and Pro edition for the needs of designers, illustrators, animators and game designers.

#### System requirement:

- 2G RAM.
- CPU Dual core.
- 10G free diskspace.

#### Login:

| user | password      |
| :--- | :---          |
| anon | langitketujuh |
| root | langitketujuh |

#### Clone repository

```
git clone git@gitlab.com:langitketujuh/os.git --recursive
```

#### Install dependencies (root)

```
xbps-install -S git make liblz4 xbps qemu-user-static pwgen
```

#### Usage

```
cd os
make
```

and then see the usage output:

```
sudo ./build.sh -h
```

#### How to build iso (root)

##### Lite

```
sudo ./build.sh -b lite -a x86_64
sudo ./build.sh -b lite -a x86_64-musl
sudo ./build.sh -b lite -a i686
```

##### Pro

```
sudo ./build.sh -b pro -a x86_64
sudo ./build.sh -b pro -a x86_64-musl
sudo ./build.sh -b pro -a i686
```

---
THANKS TO:

- VOID LINUX & CONTRIBUTOR - https://github.com/void-linux/void-mklive

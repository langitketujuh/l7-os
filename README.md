## The LangitKetujuh Linux live maker and installer

GNU/Linux Musl distribution based on Voidlinux with KDE desktop environment. Rolling release stable, light and efficient. `home` edition for common users and `studio` edition for the needs of designers, illustrators, animators and game designers.

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
xbps-install -S git make liblz4 xbps qemu-user-static
```

#### Usage

```
cd os
make
```

and then see the usage output:

```
sudo ./mkl7.sh -h
```

#### How to build iso (root)

##### Lite

```
sudo ./mkl7.sh -b home -a x86_64
sudo ./mkl7.sh -b home -a x86_64-musl
sudo ./mkl7.sh -b home -a i686
```

##### Studio

```
sudo ./mkl7.sh -b studio -a x86_64
sudo ./mkl7.sh -b studio -a x86_64-musl
sudo ./mkl7.sh -b studio -a i686
```

---
##### Thanks To:

- VOID LINUX & CONTRIBUTOR - https://github.com/void-linux/void-mklive

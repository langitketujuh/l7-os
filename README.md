## The LangitKetujuh Linux live maker and installer

GNU/Linux distribution based on Voidlinux with KDE desktop environment.
Rolling release stable, light and efficient. `home` edition for common users
and `studio` edition for the needs of designers, illustrators, animators and
game designers.

#### System requirement:

* 2G RAM.
* CPU Dual core.
* 10G free diskspace for base, 20G for home or 40G for studio.

#### Login:

| user | password      |
| :--- | :---          |
| anon | langitketujuh |
| root | langitketujuh |

#### Clone repository

```
git clone git@gitlab.com:langitketujuh/l7-os.git --recursive
```

#### Install dependencies (root)

```
xbps-install -S git make liblz4 xbps qemu-user-static
```

#### Usage

```
cd l7-os
make
```

#### How to build iso (root)

##### x86_64

```
./build-x86-images.sh -a x86_64 -b base
./build-x86-images.sh -a x86_64 -b kde-home
./build-x86-images.sh -a x86_64 -b kde-studio
```

##### x86_64-musl

```
./build-x86-images.sh -a x86_64-musl -b base
./build-x86-images.sh -a x86_64-musl -b kde-home
./build-x86-images.sh -a x86_64-musl -b kde-studio
```

##### all images

```
./release.sh
```

---
##### Thanks To:

- [Void Linux & Contributor](https://github.com/void-linux/void-mklive)

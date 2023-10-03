#!/bin/bash

./build-x86-images.sh -a x86_64-musl -b kde-studio
./build-x86-images.sh -a x86_64-musl -b kde-home
./build-x86-images.sh -a x86_64 -b kde-studio
./build-x86-images.sh -a x86_64 -b kde-home

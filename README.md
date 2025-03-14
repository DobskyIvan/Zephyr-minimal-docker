# Zephyr minimal docker image

This repository contains a Dockerfile for building the Zephyr RTOS minimal development environment image.  

## Overview

Based on this [article](https://www.stefanocottafavi.com/zephyr-minimal-devenv/).

The docker image include toolchain for arm-zephyr-eabi, xtensa-espressif_esp32 and xtensa-espressif_esp32s3. Cmsis, hal_stm32 and hal_espressif modules(can be changed by editing west.yml)

A workspace topology looks like this:
```
┌────────────────────────────────────────┐
│             Docker container           │
├────────────────────────────────────────┤
│   ~/zephyrproject/                     │
│   │                                    │
│   ├── .west/                           │
│   │   └── config                       │
│   │                                    │
│   ├── zephyr/                          │
│   │   ├── west.yml                     │
│   │   └── [... other files ...]        │
│   │                                    │
│   ├── modules/                         │
│   │   ├── lib/                         │
│   │   └── [... other files ...]        │
│   │                                    │
│   ├── local_repo/                      │
│      ├── west.yml                      │
│      ├── [... other files ...]         │
├────────────────────────────────────────┤
│                Host PC                 │
├────────────────────────────────────────┤
│      │                                 │
│      └── .                             │
```
More info about topology [here](https://docs.zephyrproject.org/latest/develop/west/workspaces.html#t2-star-topology-application-is-the-manifest-repository)

## Installation

To build docker image:  
```console
docker build . -t zephyr_image
```
*Optionally, you can change the time zone value in the dockerfile (ENV TZ=...) and/or the necessary loadable modules in the ./share/west.yml file (import:).*

## Usage
### Build as in a virtual machine
```console
docker run --rm -it --name zephyr_container -v .:/root/zephyrproject/local_repo zephyr_image 
```
**You can copy west.yml on your host by:**
```console
docker cp zephyr_container:root/zephyrproject/local_repo/west.yml .\west.yml
```
**Edit west.ymal...**

**To push west.yml back in container:**
```console
docker cp .\west.yml zephyr_container:root/zephyrproject/local_repo/west.yml 
```
In the shell session, put some commands like these:  
```console
cd ~/zephyrproject/
```
```console
west update
```
```console
cd ~/zephyrproject/local_repo/share
```
```console
cp -r ~/zephyrproject/zephyr/samples/basic/blinky ./my_blinky
```
```console
west build --pristine=auto -b stm32_min_dev@blue my_blinky/ --build-dir my_blinky/artifacts/
```
If the build is successful, the artifacts will be in:
```console
ls -a my_blinky/artifacts/zephyr
```
(artifacts can be accessed from the host device)

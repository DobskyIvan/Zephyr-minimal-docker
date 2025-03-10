FROM ubuntu:latest

#SHELL ["/bin/bash", "-c"]

# for tzdata
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone # tzdata

RUN apt-get update && \
    apt-get --no-install-recommends -y install \
    wget \
    xz-utils \
    git \
    ssh \
    cmake \
    ninja-build \
    gperf \
    ccache \
    dfu-util \
    device-tree-compiler \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-tk \
    python3-wheel \
    file \
    make \
    gcc \
    gcc-multilib \
    g++-multilib \
    libsdl2-dev \
    libmagic1 && \
    apt-get clean

RUN cd && \
    wget --no-check-certificate https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.0/zephyr-sdk-0.17.0_linux-x86_64_minimal.tar.xz && \
    tar xf zephyr-sdk-0.17.0_linux-x86_64_minimal.tar.xz && \
    rm zephyr-sdk-0.17.0_linux-x86_64_minimal.tar.xz && \
    cd zephyr-sdk-0.17.0 && \
    wget --no-check-certificate https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.0/toolchain_linux-x86_64_arm-zephyr-eabi.tar.xz && \
    tar xf toolchain_linux-x86_64_arm-zephyr-eabi.tar.xz && \
    rm toolchain_linux-x86_64_arm-zephyr-eabi.tar.xz && \
    wget --no-check-certificate https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.0/toolchain_linux-x86_64_xtensa-espressif_esp32_zephyr-elf.tar.xz && \
    tar xf toolchain_linux-x86_64_xtensa-espressif_esp32_zephyr-elf.tar.xz && \
    rm toolchain_linux-x86_64_xtensa-espressif_esp32_zephyr-elf.tar.xz && \
    wget --no-check-certificate https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.0/toolchain_linux-x86_64_xtensa-espressif_esp32s3_zephyr-elf.tar.xz && \
    tar xf toolchain_linux-x86_64_xtensa-espressif_esp32s3_zephyr-elf.tar.xz && \
    rm toolchain_linux-x86_64_xtensa-espressif_esp32s3_zephyr-elf.tar.xz && \
    mkdir ~/zephyrproject && \
    mkdir ~/zephyrproject/local_repo

COPY ./share/west.yml /root/zephyrproject/local_repo

RUN pip install --break-system-packages --user west && \
    echo 'export PATH=~/.local/bin/:"$PATH"' >> ~/.bashrc && \
    . ~/.bashrc && \
    ~/.local/bin/west init -l --mf west.yml ~/zephyrproject/local_repo/ && \
    cd ~/zephyrproject/ && \
    ~/.local/bin/west update && \
    ~/.local/bin/west zephyr-export

RUN pip install --break-system-packages --user -r ~/zephyrproject/zephyr/scripts/requirements.txt

CMD bash 

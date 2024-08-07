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
    wget --no-check-certificate https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.8/zephyr-sdk-0.16.8_linux-x86_64_minimal.tar.xz && \
    tar xf zephyr-sdk-0.16.8_linux-x86_64_minimal.tar.xz && \
    rm zephyr-sdk-0.16.8_linux-x86_64_minimal.tar.xz && \
    cd zephyr-sdk-0.16.8 && \
    wget --no-check-certificate https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.8/toolchain_linux-x86_64_arm-zephyr-eabi.tar.xz && \
    tar xf toolchain_linux-x86_64_arm-zephyr-eabi.tar.xz && \
    rm toolchain_linux-x86_64_arm-zephyr-eabi.tar.xz && \
    mkdir ~/zephyrproject && \
    mkdir ~/zephyrproject/local_repo

COPY ./share/west.yml /root/zephyrproject/local_repo
    
RUN pip3 install --upgrade west && \
    echo 'export PATH=~/.local/bin/:"$PATH"' >> ~/.bashrc && \
    . ~/.bashrc

RUN west init -l --mf west.yml ~/zephyrproject/local_repo/ && \
    cd ~/zephyrproject/ && \
    west update && \
    west zephyr-export && \
    pip3 install --user -r ~/zephyrproject/zephyr/scripts/requirements.txt
    
CMD bash 

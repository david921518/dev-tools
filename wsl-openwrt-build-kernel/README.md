# Windows/WSL 环境下编译 OpenWrt 内核的工具

  本目录实现 Windows/WSL 环境下借助 OpenWrt 提供的预编译工具快速编译 Linux 内核的工具。

## 自述 (README)
| 语言 | 链接 |
|------|------|
| 中文 | [链接](https://github.com/david921518/dev-tools/blob/master/wsl-openwrt-build-kernel/README.md) |
| 英文 (English) | [链接](https://github.com/david921518/dev-tools/blob/master/wsl-openwrt-build-kernel/README.en.md) |

## 使用场景
在 Windows 中利用 WSL 子系统环境进行 OpenWrt 的开发

## 实现步骤

以编译 OpenWrt-23.05.4 的 x86_64 内核为例，讲解如何快速在 Windows/WSL 环境中编译调试 Linux 内核

### 1、Windows 10 以上系统中安装 WSL 支持

Windows 10 专业版、教育版以上系统，需要安装 WSL2 的支持

Windows 11 全系列版本都已支持 WSL2

### 2、安装 WSL/Ubuntu 22.04 镜像


### 3、在 WSL/Ubuntu 22.04 中安装编译预备工具
执行以下命令：

```bash
sudo apt update
sudo apt install build-essential clang flex bison g++ gawk \
gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev \
python3-distutils python3-setuptools rsync swig unzip zlib1g-dev file wget
sudo apt install bc
sudo apt install libelf-dev
```

其中，bc 包用于在 kernel 编译运行 make prepare 时统计行数

libelf-dev 包用于解决 "fatal error: gelf.h: No such file or directory" 的问题

### 4、从 OpenWrt 官方网站下载 SDK 工具包

本文以  OpenWrt-23.05.4 的 x86_64 内核为例，使用的下载链接为：

[Index of (root) / releases / 23.05.4 / targets / x86 / 64 /](https://downloads.openwrt.org/releases/23.05.4/targets/x86/64/)

[openwrt-sdk-23.05.4-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz](https://downloads.openwrt.org/releases/23.05.4/targets/x86/64/openwrt-sdk-23.05.4-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz)

将上述 SDK 包下载到本地工作目录，本例中本地工作目录为 /home/yuhui/wks/openwrt/

执行以下命令，解压 SDK 包：

```bash
tar Jvxf openwrt-sdk-23.05.4-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz
```


### 5、从 OpenWrt git 仓库获取 openwrt 构建系统的 23.05.4 版本代码

在工作目录 /home/yuhui/wks/openwrt/ 下，执行以下 git clone 命令：

```bash
git clone https://git.openwrt.org/openwrt/openwrt.git op-23.05.4
cd op-23.05.4
git checkout v23.05.4
```

### 6、获取 OpenWrt 官方配置

在工作目录 /home/yuhui/wks/openwrt/ 下，执行以下命令：

```bash
wget https://downloads.openwrt.org/releases/23.05.4/targets/x86/64/config.buildinfo
cp config.buildinfo op-23.05.4/.config
```

### 7、配置 linux

首先运行 [env_wsl.sh](https://github.com/david921518/dev-tools/blob/main/wsl-openwrt-build-kernel/env_wsl.sh) 配置 PATH

在工作目录 /home/yuhui/wks/openwrt/ 下，执行以下命令：

```bash
cd op-23.05.4/
make V=99 target/linux/prepare
```

接受默认配置，保存并退出


### 8、编译 linux

在工作目录 /home/yuhui/wks/openwrt/op-23.05.4/ 下，执行以下命令：

```bash
make V=99 target/linux/compile
```

等待编译结束


## 定制内核

在 OpenWrt 上运行 docker 时遇到一个问题：

```bash
failed to register layer: lsetxattr security.capability /usr/bin/ping: operation not supporte
```

在 [Docker pull fails - failed to register layer: operation not supported](https://forum.openwrt.org/t/docker-pull-fails-failed-to-register-layer-operation-not-supported/138253/63?page=2) 中提到需要在 kernel 中增加 CONFIG_EXT4_FS_POSIX_ACL=y 和 CONFIG_EXT4_FS_SECURITY=y 。

### 1、获取当前 kernel 配置

在当前运行的 OpenWrt 上加载 configs.ko ，通过 zcat /proc/config.gz 获取当前运行的 linux 内核配置。

[openwrt-23.05.4-x86_64-linux_config](https://github.com/david921518/dev-tools/blob/main/wsl-openwrt-build-kernel/openwrt-23.05.4-x86_64-linux_config)

### 2、修改 linux 内核配置并编译

[ext4_fs_posix_acl.diff](https://github.com/david921518/dev-tools/blob/main/wsl-openwrt-build-kernel/ext4_fs_posix_acl.diff)

[openwrt-23.05.4-x86_64-linux_config_david921518](https://github.com/david921518/dev-tools/blob/main/wsl-openwrt-build-kernel/openwrt-23.05.4-x86_64-linux_config_david921518)

使用上述 diff 文件修改当前 op-23.05.4/ 目录中的文件

复制 openwrt-23.05.4-x86_64-linux_config_david921518 到 op-23.05.4/build_dir/target-x86_64_musl/linux-x86_64/linux-5.15.162/.config

### 3、重新编译内核

在工作目录 /home/yuhui/wks/openwrt/ 下，执行以下命令：

```bash
cd op-23.05.4/
make V=99 target/linux/compile
```

### 4、测试新内核

[bzImage](https://github.com/david921518/dev-tools/blob/main/wsl-openwrt-build-kernel/bzImage)

[configs.ko](https://github.com/david921518/dev-tools/blob/main/wsl-openwrt-build-kernel/configs.ko)

在工作目录 /home/yuhui/wks/openwrt/ 下，执行以下命令：


## 参考资料

1、 [Build system setup WSL](https://openwrt.org/docs/guide-developer/toolchain/wsl)

2、 [Build system setup](https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem)

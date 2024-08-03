# OpenWrt 开启交换分区文件

  本目录实现 OpenWrt 环境下添加 swap 分区文件。

## 自述 (README)
| 语言 | 链接 |
|------|------|
| 中文 | [链接](https://github.com/david921518/dev-tools/blob/master/openwrt-swapon/README.md) |
| 英文 (English) | [链接](https://github.com/david921518/dev-tools/blob/master/openwrt-swapon/README.en.md) |

## 使用场景
为 OpenWrt 系统开启交换分区文件，增加运行空间

## 实现步骤

以编译 OpenWrt-23.05.4 的 x86_64 内核为例，讲解如何快速在 Windows/WSL 环境中编译调试 Linux 内核

### 1、安装 swap-utils

```bash
opkg update
opkg install swap-utils
```

### 2、创建交换分区文件

此处我们生成一个 1G 大小的交换分区文件

```bash
dd if=/dev/zero of=/etc/swapfile bs=1M count=1024
chmod 0600 /etc/swapfile
```

### 3、格式化交换分区文件

```bash
/usr/sbin/mkswap -f /etc/swapfile
```

### 4、启动交换分区文件

```bash
swapon /etc/swapfile
```

### 5、添加系统启动自动挂载

在文件 /etc/fstab 中添加以下条目

```bash
# <file system> <mount point> <type> <options> <dump> <pass>
/etc/swapfile swap swap defaults 0 0
```

在文件 /etc/rc.local 中添加以下条目

```bash
swapon -a
```


## 参考资料


# GitHub 分支合并工具

  本目录实现 GitHub 不同分支之间的自动合并功能，用于在不同的 git 分支间实现内容同步。

## 自述 (README)
| 语言 | 链接 |
|------|------|
| 中文 | [链接](https://gitcode.com/david921518/dev-tools/blob/gitcode/github-merge/README.md) |
| 英文 (English) | [链接](https://gitcode.com/david921518/dev-tools/blob/gitcode/github-merge/README.en.md) |

## 使用场景
gitee 仓库同步 github 仓库，并保持所有访问链接调整为指向 gitee 仓库的 URL

## 实现步骤

以本仓库为例，实现 gitee 同步 github 的仓库，并保证访问 gitee.com 网站时所有 URL 调整到指向 gitee.com 的仓库路径

### 1、github 上创建仓库

github 上创建仓库后，默认生成 main 的主分支

### 2、在 github 仓库上创建 gitee 分支

gitee 分支用于给 gitee.com 的仓库访问，此分支上所有指向 github.com 仓库的 URL 都将修改为指向 gitee.com 的仓库

### 3、在 gitee 上导入 github 的仓库

导入 github 仓库后，在 gitee 的“管理”页修改默认分支为 gitee

### 4、使用本工具完成 git 上 gitee 分支对 main 分支的同步

### 5、gitee 仓库定期同步 github 仓库


## 工作原理

1、 本地主机上建立两个工作目录，/main/ 目录保存 github 仓库的 main 分支，/gitee/ 目录保存 github 仓库的 gitee 分支；

2、 更新 /main/ 目录后，使用字符串替换工具将指向 github.com 的 URL 修改为指向 gitee.com 的 URL

3、 复制修改后的 /main/ 目录文件内容到 /gitee/ 目录中

4、 将 /gitee/ 目录中的内容推送到 github 仓库的 gitee 分支

5、 触发 gitee.com 上对应的仓库进行 github.com 的仓库同步动作，实现两个 git 仓库同步

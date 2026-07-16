# 快速开始

## 5 分钟设置指南

### 第 1 步：创建 GitHub 仓库

1. 登录 GitHub
2. 点击 "+" 号，选择 "New repository"
3. 仓库名称：`meatshell-mirror`
4. 描述：`Meatshell 项目的自动同步镜像`
5. 选择公开（Public）仓库
6. **不要**初始化任何文件
7. 点击 "Create repository"

### 第 2 步：克隆并配置

```bash
# 克隆仓库
git clone https://github.com/你的用户名/meatshell-mirror.git
cd meatshell-mirror

# 编辑工作流文件，上游仓库地址已配置为 jeff141/meatshell
```

### 第 3 步：推送并启用

```bash
git add .
git commit -m "配置上游仓库"
git push origin main
```

然后在 GitHub 仓库的 "Actions" 选项卡中启用工作流。

## 完成！

现在您的镜像仓库已经设置完成：

- ✅ 每天凌晨自动同步上游代码
- ✅ 自动同步新标签和版本
- ✅ 支持手动触发同步
- ✅ 自动创建 GitHub Release

## 下一步

- 查看 [SETUP.md](SETUP.md) 了解详细配置
- 查看 [EXAMPLE.md](EXAMPLE.md) 了解使用示例
- 查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何贡献

## 常见操作

### 手动同步

1. 进入 "Actions" 选项卡
2. 选择 "同步上游仓库"
3. 点击 "Run workflow"

### 查看同步历史

1. 进入 "Actions" 选项卡
2. 查看工作流运行记录

### 下载特定版本

1. 进入 "Releases" 页面
2. 选择需要的版本
3. 下载对应的二进制文件

## 需要帮助？

- 查看 [SETUP.md](SETUP.md) 的故障排除部分
- 创建 Issue 寻求帮助
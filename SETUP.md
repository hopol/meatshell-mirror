# 镜像仓库设置指南

本指南将帮助您快速设置和使用 Meatshell 镜像仓库。

## 前置条件

- GitHub 账户
- Git 安装在本地计算机
- 基本的命令行操作能力

## 快速开始

### 1. 创建 GitHub 仓库

1. 登录 GitHub
2. 点击右上角的 "+" 号，选择 "New repository"
3. 仓库名称建议：`meatshell-mirror`
4. 描述：`Meatshell 项目的自动同步镜像`
5. 选择公开（Public）仓库
6. **不要**初始化 README、.gitignore 或许可证（我们已经有了）
7. 点击 "Create repository"

### 2. 克隆仓库到本地

```bash
# 替换为你的 GitHub 用户名
git clone https://github.com/你的用户名/meatshell-mirror.git
cd meatshell-mirror
```

### 3. 配置上游仓库

编辑 `.github/workflows/sync.yml` 文件，找到以下行：

```yaml
run: |
  git remote add upstream https://github.com/jeff141/meatshell.git
  git fetch upstream
```

将上游仓库地址设置为 `jeff141/meatshell`。

### 4. 推送到 GitHub

```bash
git add .
git commit -m "配置上游仓库"
git push origin main
```

### 5. 启用 GitHub Actions

1. 进入仓库的 "Actions" 选项卡
2. 点击 "I understand my workflows, go ahead and enable them"
3. 工作流将按计划自动执行

## 高级配置

### 修改同步频率

默认每天凌晨 2 点执行同步。如需修改，编辑 `.github/workflows/sync.yml`：

```yaml
schedule:
  - cron: '0 2 * * *'  # 分 时 日 月 周
```

常用 cron 表达式：
- `0 2 * * *`：每天凌晨 2 点
- `0 */6 * * *`：每 6 小时
- `0 2 * * 1`：每周一凌晨 2 点
- `0 0 1 * *`：每月 1 号午夜

### 手动触发同步

1. 进入 "Actions" 选项卡
2. 选择 "同步上游仓库" 工作流
3. 点击 "Run workflow"
4. 等待执行完成

### 查看同步历史

在 "Actions" 选项卡中可以查看所有工作流运行记录，包括：
- 执行时间
- 执行状态
- 详细日志

## 故障排除

### 问题 1：同步失败

**可能原因**：
- 上游仓库地址错误
- 网络连接问题
- GitHub Actions 权限不足

**解决方法**：
1. 检查 `.github/workflows/sync.yml` 中的上游仓库地址
2. 确认网络可以访问 GitHub
3. 检查仓库的 Settings > Actions > General 权限设置

### 问题 2：标签未同步

**可能原因**：
- 上游没有新标签
- 标签格式不匹配

**解决方法**：
1. 手动触发同步工作流
2. 检查上游仓库是否有新标签

### 问题 3：GitHub Release 未创建

**可能原因**：
- 没有新标签需要发布
- Release 创建权限不足

**解决方法**：
1. 确认有新标签需要同步
2. 检查仓库的 Settings > Actions > General 权限设置

## 维护说明

### 定期检查

建议每月检查一次：
1. 同步是否正常运行
2. 是否有新的版本发布
3. 工作流是否有错误日志

### 更新工作流

如需修改同步逻辑，编辑 `.github/workflows/sync.yml` 文件，然后推送到仓库。

### 备份建议

虽然本项目本身就是备份，但建议：
1. 定期导出仓库
2. 保存重要标签的二进制文件
3. 记录关键版本信息

## 技术细节

### 工作流程

1. **定时触发**：GitHub Actions 按 cron 表达式执行
2. **代码同步**：使用 `git fetch` 和 `git merge` 获取最新代码
3. **标签同步**：检测并推送新标签
4. **版本发布**：根据标签创建 GitHub Release

### 权限要求

- `contents: write`：用于推送代码和创建 Release
- `actions: read`：用于查看工作流状态

### 存储考虑

- 代码历史会占用存储空间
- 长期运行可能需要清理旧的 Release
- GitHub 对公开仓库有存储限制

## 相关链接

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Git 官方文档](https://git-scm.com/doc)
- [语义化版本规范](https://semver.org/lang/zh-CN/)

## 获取帮助

如果遇到问题：
1. 查看本文档的故障排除部分
2. 检查 GitHub Actions 运行日志
3. 创建 Issue 寻求帮助
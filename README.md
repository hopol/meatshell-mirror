# Meatshell 镜像仓库

这是一个自动同步上游 [Meatshell](https://github.com/jeff141/meatshell) 项目的镜像仓库。

## 为什么需要这个项目？

GitHub 开源项目可能因维护调整、作者归档等原因出现仓库不可访问的情况，常规 Fork 方式无法持续跟进上游更新。本项目配置自动化同步流程，周期性完整同步上游代码及全量提交历史至本地托管仓库，建立可靠代码备份，规避上游仓库失效带来的代码丢失问题。

## 功能特点

- **自动同步**：每天凌晨自动检查上游仓库更新
- **标签同步**：自动同步上游发布的新版本标签
- **手动触发**：支持通过 GitHub Actions 手动触发同步
- **版本发布**：自动创建和更新 GitHub Release

## 工作原理

1. **定时触发**：通过 GitHub Actions 的 cron 调度器，每天凌晨 2 点自动执行
2. **代码同步**：使用 `git archive` 导出上游代码到 `upstream/` 目录
3. **标签同步**：自动检测并推送上游新发布的标签
4. **版本发布**：根据最新标签自动创建 GitHub Release

## 项目结构

```
meatshell-mirror/
├── .github/
│   └── workflows/
│       └── sync.yml          # GitHub Actions 工作流配置
├── upstream/                 # 上游代码同步目录
│   ├── .sync-info           # 同步信息记录
│   ├── src/                 # 源代码
│   ├── Cargo.toml           # Rust 配置
│   └── ...                  # 其他上游文件
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── SETUP.md
└── sync.sh
```

## 使用方法

### 1. 创建仓库

1. 在 GitHub 上创建新仓库（建议命名为 `meatshell-mirror`）
2. 将本项目代码克隆到本地

### 2. 配置上游仓库

编辑 `.github/workflows/sync.yml` 文件，将上游仓库地址替换为实际地址：

```yaml
run: |
  git remote add upstream https://github.com/jeff141/meatshell.git
  git fetch upstream
```

### 3. 推送到 GitHub

```bash
git init
git add .
git commit -m "初始化镜像仓库"
git remote add origin https://github.com/你的用户名/meatshell-mirror.git
git push -u origin main
```

### 4. 启用 GitHub Actions

1. 进入仓库的 "Actions" 选项卡
2. 点击 "I understand my workflows, go ahead and enable them"
3. 工作流将按计划自动执行

## 手动同步

如果需要立即同步，可以：

1. 进入 "Actions" 选项卡
2. 选择 "同步上游仓库" 工作流
3. 点击 "Run workflow"

## 配置说明

### 同步频率

默认每天凌晨 2 点执行同步。如需修改，编辑 `.github/workflows/sync.yml` 中的 cron 表达式：

```yaml
schedule:
  - cron: '0 2 * * *'  # 分 时 日 月 周
```

### 权限配置

确保仓库的 Settings > Actions > General 中：

- "Workflow permissions" 设置为 "Read and write permissions"
- "Allow GitHub Actions to create and approve pull requests" 已启用

### 完整标签同步（可选）

默认的 `GITHUB_TOKEN` 无法推送包含 workflow 文件变更的标签。如需完整同步所有标签：

1. 创建 Personal Access Token (PAT)：
   - 进入 GitHub **Settings** → **Developer settings** → **Personal access tokens** → **Fine-grained tokens**
   - 点击 **Generate new token**
   - 权限选择：**Repository access** → 选择本仓库，**Permissions** → **Contents** 设置为 **Read and write**
2. 将 PAT 添加到仓库 Secrets：
   - 进入仓库 **Settings** → **Secrets and variables** → **Actions**
   - 点击 **New repository secret**
   - 名称：`PAT_TOKEN`，值：上一步创建的 token
3. 修改工作流文件，将 `token: ${{ secrets.GITHUB_TOKEN }}` 改为 `token: ${{ secrets.PAT_TOKEN }}`

## 版本管理

- 上游的代码会同步到 `upstream/` 目录
- 标签会尽量同步，包含 workflow 文件变更的标签可能需要 PAT 才能推送
- 同步后会自动创建 GitHub Release

## 注意事项

1. **许可证**：请遵守上游项目的许可证要求
2. **更新频率**：默认每天同步一次，可根据需要调整
3. **存储空间**：长期同步会占用较多存储空间
4. **网络要求**：需要能够访问 GitHub

## 常见问题

### Q: 为什么同步失败？

A: 可能原因：
- 上游仓库地址错误
- 网络连接问题
- GitHub Actions 权限不足
- Git 身份未配置（已修复）

### Q: 如何查看同步历史？

A: 在 "Actions" 选项卡中可以查看所有工作流运行记录。

### Q: 上游代码保存在哪里？

A: 上游代码保存在 `upstream/` 目录中，包含完整的上游项目文件。每次同步会记录同步信息到 `upstream/.sync-info` 文件。

### Q: 如何查看同步状态？

A: 查看 `upstream/.sync-info` 文件，包含同步的提交哈希、时间和上游仓库地址。

### Q: 标签同步失败怎么办？

A: 包含 workflow 文件变更的标签无法用默认 `GITHUB_TOKEN` 推送，需要配置 Personal Access Token (PAT)。详见上方「完整标签同步」部分。代码同步不受影响。

### Q: 可以同步其他分支吗？

A: 可以，修改 `.github/workflows/sync.yml` 中的 `UPSTREAM_BRANCH` 变量即可。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。

## 致谢

- 感谢上游 [Meatshell](https://github.com/jeff141/meatshell) 项目的开发者
- 感谢 GitHub Actions 提供的自动化能力
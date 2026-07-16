# 使用示例

## 示例 1：首次设置

### 步骤 1：创建仓库

```bash
# 在 GitHub 上创建新仓库后，克隆到本地
git clone https://github.com/你的用户名/meatshell-mirror.git
cd meatshell-mirror
```

### 步骤 2：配置上游仓库

编辑 `.github/workflows/sync.yml`，修改上游仓库地址：

```yaml
run: |
  git remote add upstream https://github.com/jeff141/meatshell.git
  git fetch upstream
```

### 步骤 3：推送并启用

```bash
git add .
git commit -m "配置上游仓库"
git push origin main
```

然后在 GitHub 仓库的 "Actions" 选项卡中启用工作流。

## 示例 2：手动同步

### 场景：上游发布了紧急修复

1. 进入 GitHub 仓库的 "Actions" 选项卡
2. 选择 "同步上游仓库" 工作流
3. 点击 "Run workflow"
4. 等待执行完成

### 检查同步结果

```bash
# 本地拉取最新代码
git pull origin main

# 查看最新标签
git tag --sort=-version:refname | head -5
```

## 示例 3：查看同步历史

### 通过 GitHub 界面

1. 进入 "Actions" 选项卡
2. 查看工作流运行记录
3. 点击具体运行查看详细日志

### 通过命令行

```bash
# 查看最近的提交
git log --oneline -10

# 查看同步相关的提交
git log --grep="同步" --oneline
```

## 示例 4：处理同步冲突

### 场景：本地有自定义修改

如果本地有自定义修改，同步时可能会产生冲突：

```bash
# 查看冲突文件
git status

# 解决冲突后
git add .
git commit -m "解决同步冲突"
git push origin main
```

### 预防冲突

建议：
1. 不要直接修改 main 分支
2. 创建自定义分支进行修改
3. 定期同步上游代码

## 示例 5：使用同步的代码

### 下载特定版本

```bash
# 克隆仓库
git clone https://github.com/你的用户名/meatshell-mirror.git

# 切换到特定标签
cd meatshell-mirror
git checkout v1.0.0

# 或者下载特定版本的二进制文件
# 从 GitHub Release 页面下载
```

### 编译项目

```bash
# 如果是 Rust 项目
cargo build --release

# 如果是 Node.js 项目
npm install
npm run build

# 如果是 Python 项目
pip install -r requirements.txt
python setup.py install
```

## 示例 6：监控同步状态

### 创建状态徽章

在 README.md 中添加：

```markdown
![同步状态](https://github.com/你的用户名/meatshell-mirror/actions/workflows/sync.yml/badge.svg)
```

### 设置通知

1. 进入仓库的 "Settings" > "Notifications"
2. 配置邮件通知
3. 选择需要通知的事件

## 示例 7：备份重要版本

### 下载二进制文件

```bash
# 从 GitHub Release 下载
wget https://github.com/你的用户名/meatshell-mirror/releases/download/v1.0.0/meatshell-v1.0.0-linux-x86_64.tar.gz

# 解压
tar -xzf meatshell-v1.0.0-linux-x86_64.tar.gz
```

### 保存源代码

```bash
# 创建源代码归档
git archive --format=zip HEAD -o source-v1.0.0.zip
```

## 示例 8：多仓库管理

### 同步多个上游项目

可以创建多个镜像仓库，每个对应一个上游项目：

```bash
# 项目 1
meatshell-mirror/

# 项目 2
another-project-mirror/

# 项目 3
third-project-mirror/
```

### 统一管理

使用脚本批量管理：

```bash
#!/bin/bash
# sync-all.sh

REPOS=(
  "meatshell-mirror"
  "another-project-mirror"
  "third-project-mirror"
)

for repo in "${REPOS[@]}"; do
  echo "同步 $repo..."
  cd "$repo"
  git pull origin main
  cd ..
done
```

## 示例 9：自定义工作流

### 添加测试步骤

在 `.github/workflows/sync.yml` 中添加：

```yaml
- name: 运行测试
  run: |
    # 根据项目类型添加测试命令
    # 例如：cargo test
    # 或者：npm test
    echo "测试通过"
```

### 添加通知步骤

```yaml
- name: 发送通知
  if: failure()
  uses: actions/github-script@v6
  with:
    script: |
      github.rest.issues.create({
        owner: context.repo.owner,
        repo: context.repo.repo,
        title: '同步失败',
        body: '同步工作流执行失败，请检查日志。'
      })
```

## 示例 10：故障恢复

### 场景：上游仓库被删除

1. 本地仓库仍然保留所有代码
2. 检查最近的同步状态
3. 如果需要，可以从本地仓库创建新的上游

### 场景：同步中断

```bash
# 检查工作流状态
# 在 GitHub Actions 页面查看

# 手动触发同步
# 在 GitHub Actions 页面点击 "Run workflow"

# 或者本地手动同步
git fetch upstream
git merge upstream/main
git push origin main
```

## 总结

通过这个镜像仓库，您可以：

1. **安全备份**：即使上游删除，本地仍有完整代码
2. **自动同步**：定期获取最新更新
3. **版本管理**：跟踪所有发布版本
4. **灵活使用**：根据需要选择版本使用
5. **易于维护**：简单的配置和管理

希望这些示例对您有帮助！如有问题，请查看 [SETUP.md](SETUP.md) 或创建 Issue。
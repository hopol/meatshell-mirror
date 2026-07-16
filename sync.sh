#!/bin/bash
set -e

# 上游仓库配置
UPSTREAM_REPO="https://github.com/jeff141/meatshell.git"
UPSTREAM_BRANCH="main"
LOCAL_BRANCH="main"

echo "开始同步上游仓库..."

# 获取上游最新代码
echo "获取上游仓库更新..."
git fetch upstream

# 获取上游最新提交哈希
UPSTREAM_COMMIT=$(git rev-parse upstream/$UPSTREAM_BRANCH)
echo "上游最新提交: $UPSTREAM_COMMIT"

# 检查是否已有同步记录
SYNC_FILE="upstream/.sync-info"
if [ -f "$SYNC_FILE" ]; then
    LOCAL_SYNCED=$(head -n 1 "$SYNC_FILE")
    if [ "$LOCAL_SYNCED" = "$UPSTREAM_COMMIT" ]; then
        echo "本地已是最新版本，无需同步"
        exit 0
    fi
fi

# 清理旧的 upstream 目录（如果存在）
echo "清理旧的 upstream 目录..."
rm -rf upstream

# 使用 git archive 导出上游代码到 upstream 目录
echo "导出上游代码..."
mkdir -p upstream
git archive upstream/$UPSTREAM_BRANCH | tar -x -C upstream/

# 记录同步的提交哈希
echo "$UPSTREAM_COMMIT" > upstream/.sync-info
echo "同步时间: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" >> upstream/.sync-info
echo "上游仓库: $UPSTREAM_REPO" >> upstream/.sync-info

echo "代码同步完成"

# 提交更改
echo "提交更改..."
git add upstream/

if git diff --cached --quiet; then
    echo "没有新的更改需要提交"
    exit 0
fi

# 获取上游版本信息
UPSTREAM_VERSION=$(git describe --tags --abbrev=0 upstream/$UPSTREAM_BRANCH 2>/dev/null || echo "unknown")
UPSTREAM_COMMIT_SHORT=$(git rev-parse --short upstream/$UPSTREAM_BRANCH)

git commit -m "同步上游代码至 $UPSTREAM_VERSION ($UPSTREAM_COMMIT_SHORT)"

# 推送到本地仓库
echo "推送到本地仓库..."
git push origin $LOCAL_BRANCH

# 获取最新标签
echo "获取最新标签..."
git fetch upstream --tags

# 检查是否有新标签
NEW_TAGS=$(git tag --no-merged origin/$LOCAL_BRANCH)

if [ -n "$NEW_TAGS" ]; then
    echo "发现新标签: $NEW_TAGS"
    for tag in $NEW_TAGS; do
        echo "推送标签: $tag"
        git push origin "$tag"
    done
fi

echo "同步完成！"
echo "上游代码已保存到 upstream/ 目录"
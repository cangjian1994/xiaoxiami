#!/bin/bash
# 小虾米每日记忆体同步脚本 - W.O.C.
# 每天自动把 workspace 的 MD 文件同步到 GitHub
# Token 通过环境变量 XIAOXIAMI_GH_TOKEN 传入

set -e

WORKSPACE="/Users/openclaw/.openclaw/workspace"
REPO_DIR="/tmp/xiaoxiami-repo"
TOKEN="${XIAOXIAMI_GH_TOKEN}"
DATE=$(date +%Y-%m-%d)

if [ -z "$TOKEN" ]; then
    echo "❌ 错误：XIAOXIAMI_GH_TOKEN 环境变量未设置"
    exit 1
fi

echo "🦐⚡ [$DATE] 开始每日同步..."

# 检查仓库是否存在，不存在则克隆
if [ ! -d "$REPO_DIR" ]; then
    echo "克隆仓库..."
    git clone https://cangjian1994:$TOKEN@github.com/cangjian1994/xiaoxiami.git $REPO_DIR
fi

cd $REPO_DIR

# 更新远程 URL（确保 token 有效）
git remote set-url origin https://cangjian1994:$TOKEN@github.com/cangjian1994/xiaoxiami.git

# 拉取最新代码
git pull origin main || true

# 复制所有 MD 文件
cp $WORKSPACE/*.md . 2>/dev/null || true

# 提交变更
git add -A
if git diff --staged --quiet; then
    echo "✅ 没有变更，跳过提交"
else
    git config user.email "xiaoxiami@openclaw.local"
    git config user.name "小虾米"
    git commit -m "🦐⚡ 每日自动同步 [$DATE]"
    git push origin main
    echo "✅ 同步完成！"
fi

echo "🦐⚡ [$DATE] 同步结束"

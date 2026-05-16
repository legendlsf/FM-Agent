#!/usr/bin/env bash
# 测试 Claude Code 配置是否正确

set -euo pipefail

echo "=== FM-Agent Claude Code 配置测试 ==="
echo ""

# 设置环境变量
export ANTHROPIC_BASE_URL="https://cc-vibe.com"
export ANTHROPIC_AUTH_TOKEN="sk-fc1ef9bdb10b97093baa6b4eb0ea3c825352cfb7cf4c1db6061ee33175e9acf7"
export ANTHROPIC_API_KEY="$ANTHROPIC_AUTH_TOKEN"
export LLM_MODEL="claude-sonnet-4"

echo "1. 检查 claude 命令..."
if command -v claude &> /dev/null; then
    echo "   ✅ claude 命令已找到: $(which claude)"
else
    echo "   ❌ claude 命令未找到"
    exit 1
fi

echo ""
echo "2. 检查环境变量..."
echo "   ANTHROPIC_BASE_URL: $ANTHROPIC_BASE_URL"
echo "   ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY:0:20}..."
echo "   LLM_MODEL: $LLM_MODEL"

echo ""
echo "3. 测试 Claude Code 基本功能..."
echo "   运行命令: claude --print --model $LLM_MODEL -- 'Say Hello'"
echo ""

claude --print --model "$LLM_MODEL" -- "Say 'Hello, FM-Agent!' and nothing else."

echo ""
echo "=== 测试完成 ==="
echo ""
echo "如果上面显示了 'Hello, FM-Agent!'，说明配置正确。"
echo "现在可以运行 FM-Agent："
echo "  ./run_with_claude.sh /mnt/d/fm-agent-test/datafabric-layer1-pti"

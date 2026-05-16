#!/usr/bin/env bash
# FM-Agent runner script for Claude Code
# This script sets up environment variables and runs FM-Agent with Claude Code

set -euo pipefail

# 设置 Anthropic API 配置
export ANTHROPIC_BASE_URL="https://cc-vibe.com"
export ANTHROPIC_AUTH_TOKEN="sk-fc1ef9bdb10b97093baa6b4eb0ea3c825352cfb7cf4c1db6061ee33175e9acf7"
export ANTHROPIC_API_KEY="$ANTHROPIC_AUTH_TOKEN"  # Claude CLI 可能需要这个
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="1"
export CLAUDE_CODE_ATTRIBUTION_HEADER="0"

# 设置模型（Claude Code 使用简化的模型名）
export LLM_MODEL="claude-sonnet-4"

# 检查参数
if [ $# -lt 1 ]; then
    echo "Usage: $0 <project_directory>"
    echo ""
    echo "Example:"
    echo "  $0 /mnt/d/fm-agent-test/datafabric-layer1-pti"
    exit 1
fi

PROJECT_DIR="$1"

# 检查项目目录是否存在
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory does not exist: $PROJECT_DIR"
    exit 1
fi

# 检查 claude 命令是否可用
if ! command -v claude &> /dev/null; then
    echo "Error: 'claude' command not found."
    echo "Please install Claude Code CLI first."
    exit 1
fi

echo "=== FM-Agent with Claude Code ==="
echo "Project directory: $PROJECT_DIR"
echo "Model: $LLM_MODEL"
echo "API Base URL: $ANTHROPIC_BASE_URL"
echo ""

# 运行 FM-Agent
cd "$(dirname "$0")"
python3 main_claude.py "$PROJECT_DIR"

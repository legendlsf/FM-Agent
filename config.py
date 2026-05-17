import os

# Modified to support both OpenRouter and Anthropic API
# Date: 2026-05-16
# Changes: Added support for ANTHROPIC_AUTH_TOKEN and ANTHROPIC_BASE_URL environment variables

# 支持 Anthropic API 或 OpenRouter API
LLM_OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY") or os.environ.get("ANTHROPIC_AUTH_TOKEN", "")
LLM_OPENROUTER_API_BASE_URL = os.environ.get("ANTHROPIC_BASE_URL") or os.environ.get("OPENROUTER_BASE_URL", "https://openrouter.ai/api/v1")
LLM_MODEL = os.environ.get("LLM_MODEL", "claude-opus-4-7")

MAX_SPC_ITER = 5
GRANULARITY = 40
MAX_WORKERS = 10
OPENCODE_MAX_RETRIES = 5

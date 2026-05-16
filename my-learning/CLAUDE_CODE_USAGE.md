# FM-Agent Claude Code 适配版使用指南

## 概述

我已经将 FM-Agent 从 OpenCode 适配到 Claude Code。主要改动：

1. **替换 AI 代理**：OpenCode → Claude Code (`claude` 命令)
2. **命令格式适配**：使用 `claude --print --model <model> --append-system-prompt <instructions>`
3. **环境变量配置**：支持你的 Anthropic API 配置

## 文件说明

### 新增文件

1. **main_claude.py** - 适配 Claude Code 的主程序
   - 替换所有 `opencode` 调用为 `claude` 调用
   - 使用 `--append-system-prompt` 传递工作流指令
   - 保持原有的流水线逻辑不变

2. **run_with_claude.sh** - 启动脚本
   - 自动设置环境变量
   - 检查依赖
   - 运行 FM-Agent

### 修改文件

1. **config.py** - 配置文件
   - 支持从环境变量读取 Anthropic API 配置
   - 兼容 OpenRouter 和 Anthropic API

## 使用方法

### 快速开始

```bash
# 1. 进入 FM-Agent 目录
cd /mnt/d/fm-agent

# 2. 运行分析（使用测试项目）
./run_with_claude.sh /mnt/d/fm-agent-test/datafabric-layer1-pti
```

### 手动运行

如果你想手动控制环境变量：

```bash
# 设置环境变量
export ANTHROPIC_BASE_URL="https://cc-vibe.com"
export ANTHROPIC_AUTH_TOKEN="sk-fc1ef9bdb10b97093baa6b4eb0ea3c825352cfb7cf4c1db6061ee33175e9acf7"
export ANTHROPIC_API_KEY="$ANTHROPIC_AUTH_TOKEN"
export LLM_MODEL="claude-sonnet-4"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="1"
export CLAUDE_CODE_ATTRIBUTION_HEADER="0"

# 运行 FM-Agent
cd /mnt/d/fm-agent
python3 main_claude.py /path/to/your/project
```

## 核心改动说明

### 1. OpenCode vs Claude Code 命令对比

**OpenCode 原始命令**：
```bash
opencode run --model openrouter/claude-sonnet-4.6 \
  --file fm_agent/workflow_setup_extract.md \
  -- "Follow the instructions in the attached file."
```

**Claude Code 适配命令**：
```bash
claude --print \
  --model claude-sonnet-4 \
  --append-system-prompt "$(cat fm_agent/workflow_setup_extract.md)" \
  -- "Follow the instructions in the attached file."
```

### 2. 关键差异

| 特性 | OpenCode | Claude Code |
|------|----------|-------------|
| 模型格式 | `openrouter/claude-sonnet-4.6` | `claude-sonnet-4` |
| 文件传递 | `--file <path>` | `--append-system-prompt <content>` |
| 输出模式 | 默认交互 | `--print` 非交互 |
| 初始化 | `opencode run --command init` | 不需要（自动发现 CLAUDE.md）|

### 3. 工作流程保持不变

```
Stage 1: 初始化（跳过，Claude Code 自动发现 CLAUDE.md）
Stage 2: 理解代码库并生成 phases.json
Stage 3: 收集文件列表
Stage 4: 生成自顶向下层次
Stage 5: 并发生成函数规范并验证
```

## 预期输出

运行成功后，会在项目目录下生成 `fm_agent/` 目录：

```
<项目目录>/
└── fm_agent/
    ├── fm_agent.log                   # 完整日志
    ├── phases.json                    # 模块划分
    ├── extracted_functions/           # 提取的函数
    ├── spec_prompts/                  # 规范生成提示词
    ├── logic_verification_results/    # 验证结果
    └── bug_validation/                # Bug 报告
        ├── summary.json               # 汇总统计
        ├── <bug_id>.md                # 详细报告
        └── _probe_<bug_id>.py         # 测试脚本
```

## 测试项目说明

我已经为你准备了一个测试项目：

**路径**：`/mnt/d/fm-agent-test/datafabric-layer1-pti/`

**内容**：
- DataFabric 的 Layer 1 PTI 模块（约 1000 行代码）
- 包含文档解析、转换、索引逻辑
- 适合形式化验证

**预计成本**：$2-5（取决于模型和代码复杂度）

**预计时间**：10-30 分钟

## 故障排查

### 问题 1：claude 命令未找到

```bash
# 检查 claude 是否安装
which claude

# 如果未安装，检查 PATH
echo $PATH | grep -o "[^:]*claude[^:]*"
```

**解决方案**：确保 Claude Code CLI 已安装并在 PATH 中。

### 问题 2：API 认证失败

**症状**：日志中出现 401 或 403 错误

**解决方案**：
1. 检查 API key 是否正确
2. 检查 API base URL 是否可访问
3. 尝试手动测试：
   ```bash
   curl -H "Authorization: Bearer $ANTHROPIC_AUTH_TOKEN" \
        https://cc-vibe.com/v1/models
   ```

### 问题 3：phases.json 未生成

**症状**：Stage 2 失败，phases.json 不存在

**可能原因**：
1. Claude Code 没有正确理解工作流指令
2. 项目结构太复杂
3. API 调用失败

**解决方案**：
1. 查看 `fm_agent/fm_agent.log` 获取详细错误
2. 尝试更小的项目
3. 手动创建 phases.json（见下文）

### 问题 4：并发进程过多

**症状**：系统资源耗尽

**解决方案**：修改 `config.py` 中的 `MAX_WORKERS`：
```python
MAX_WORKERS = 3  # 降低并发数
```

## 手动创建 phases.json（应急方案）

如果 Stage 2 失败，你可以手动创建 `phases.json`：

```json
{
  "project": "datafabric-layer1-pti",
  "languages": ["python"],
  "file_extensions": ["py"],
  "phases": [
    {
      "phase": 1,
      "name": "PTI Pipeline",
      "description": "Parse, Transform, and Index documents",
      "modules": [
        {
          "name": "layer1_pti",
          "source_files": [
            "layer1_pti/parser.py",
            "layer1_pti/transformer.py",
            "layer1_pti/indexer.py"
          ]
        }
      ],
      "depends_on_phases": []
    }
  ]
}
```

保存到 `<项目目录>/fm_agent/phases.json`，然后重新运行。

## 性能优化建议

### 1. 减少代码量

只分析关键模块，不要一次性分析整个项目：

```bash
# 只分析 Layer 1
./run_with_claude.sh /home/lisf/datafabric/datafabric/layer1_pti
```

### 2. 调整粒度

修改 `config.py`：

```python
GRANULARITY = 40  # 每个代码块的行数（默认 40）
# 增大可以减少 API 调用次数，但可能降低准确性
```

### 3. 限制并发

```python
MAX_WORKERS = 5  # 并发工作线程（默认 10）
# 降低可以减少内存占用和 API 压力
```

## 与原版 OpenCode 的兼容性

如果你想切换回 OpenCode：

```bash
# 使用原版
python3 main.py /path/to/project

# 使用 Claude Code 版本
python3 main_claude.py /path/to/project
```

两个版本可以共存，互不影响。

## 下一步

1. **测试运行**：
   ```bash
   cd /mnt/d/fm-agent
   ./run_with_claude.sh /mnt/d/fm-agent-test/datafabric-layer1-pti
   ```

2. **查看结果**：
   ```bash
   # 查看日志
   tail -f /mnt/d/fm-agent-test/datafabric-layer1-pti/fm_agent/fm_agent.log
   
   # 查看 Bug 统计
   cat /mnt/d/fm-agent-test/datafabric-layer1-pti/fm_agent/bug_validation/summary.json
   ```

3. **分析 Bug 报告**：
   ```bash
   ls /mnt/d/fm-agent-test/datafabric-layer1-pti/fm_agent/bug_validation/*.md
   ```

## 技术支持

如果遇到问题：

1. 查看日志文件：`fm_agent/fm_agent.log`
2. 检查环境变量：`env | grep -E "ANTHROPIC|CLAUDE|LLM"`
3. 测试 Claude Code：`claude --print --model claude-sonnet-4 -- "Hello"`
4. 查看已生成的文件：`find fm_agent/ -type f`

## 总结

**优点**：
- ✅ 不需要安装 OpenCode、Bun、oh-my-opencode
- ✅ 使用你熟悉的 Claude Code
- ✅ 使用你的 Anthropic API 配置
- ✅ 保持原有流水线逻辑

**限制**：
- ⚠️ Claude Code 的并发能力可能不如 OpenCode
- ⚠️ 需要确保 Claude Code CLI 版本支持所需参数
- ⚠️ 首次运行建议使用小项目测试

**建议**：
- 从小项目开始（1000 行左右）
- 监控日志和 API 成本
- 根据结果调整配置参数

---

**文档版本**：v1.0  
**创建日期**：2026-05-16  
**适配者**：Hermes Agent

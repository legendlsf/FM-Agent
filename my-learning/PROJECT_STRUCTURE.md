# FM-Agent Claude Code 适配 - 最终项目结构

## 📁 项目结构

```
/mnt/d/fm-agent/                        # 主仓库（可推送到 fork）
├── main_claude.py                      # ✅ 新增：Claude Code 适配版主程序
├── config.py                           # ✏️ 修改：支持 Anthropic API
├── main.py                             # ✓ 保留：原版 OpenCode 主程序
├── install.sh                          # ✓ 保留：原版安装脚本
├── LICENSE                             # ✓ 保留：Apache 2.0 许可证
├── README.md                           # ✓ 保留：原版 README
├── .gitignore                          # ✏️ 修改：添加 my-learning/ 忽略
├── src/                                # ✓ 保留：所有核心模块（未修改）
│   ├── __init__.py
│   ├── extract.py
│   ├── reasoner.py
│   ├── verification.py
│   ├── llm_client.py
│   ├── parser.py
│   ├── prompts.py
│   ├── file_utils.py
│   ├── generate_topdown_layers.py
│   ├── generate_batch_prompts.py
│   └── run_batch_gen.py
├── md/                                 # ✓ 保留：所有工作流文档（未修改）
│   ├── system_prompt.md
│   ├── bug_validator.md
│   ├── workflow_setup_extract.md
│   ├── workflow_spec_step1_layers.md
│   └── workflow_spec_step4_batch.md
└── my-learning/                        # ❌ 不推送：个人学习资料
    ├── README.md                       # 目录说明
    ├── run_with_claude.sh              # 一键启动脚本
    ├── test_claude_config.sh           # 配置测试脚本
    ├── QUICK_REFERENCE.md              # 快速参考
    ├── CLAUDE_CODE_USAGE.md            # 详细使用指南
    ├── ADAPTATION_SUMMARY.md           # 适配总结
    ├── CONTRIBUTING.md                 # 贡献指南
    ├── GITHUB_SUBMISSION_GUIDE.md      # GitHub 提交指南
    ├── PROJECT_COMPLETION_SUMMARY.md   # 项目完成总结
    ├── fm-agent-学习资料.md            # FM-Agent 技术原理
    └── fm-agent-项目状态分析.md        # 项目评估报告

/mnt/d/fm-agent-test/                   # 测试项目目录（不在主仓库）
└── datafabric-layer1-pti/              # DataFabric Layer 1 测试模块
```

## 🎯 文件分类

### 可推送到 Fork 的文件（前向兼容）

**核心代码修改**：
- ✅ `main_claude.py` - 新增的 Claude Code 适配版本
- ✅ `config.py` - 修改以支持 Anthropic API（已添加修改说明）

**配置修改**：
- ✅ `.gitignore` - 添加 `my-learning/` 忽略规则

**保持不变**：
- ✅ `main.py` - 原版 OpenCode 版本（向后兼容）
- ✅ `src/` - 所有核心模块
- ✅ `md/` - 所有工作流文档
- ✅ `LICENSE` - Apache 2.0 许可证
- ✅ `README.md` - 原版 README
- ✅ `install.sh` - 原版安装脚本

### 不推送的文件（个人学习）

**my-learning/ 目录下的所有文件**：
- ❌ 测试脚本（run_with_claude.sh, test_claude_config.sh）
- ❌ 学习文档（所有 .md 文件）
- ❌ 个人笔记和资料

## 📝 Git 操作指南

### 查看可提交的修改

```bash
cd /mnt/d/fm-agent

# 查看状态（my-learning/ 应该被忽略）
git status

# 应该只看到：
# modified:   config.py
# modified:   .gitignore
# new file:   main_claude.py
```

### 提交到你的 Fork

```bash
# 1. 添加修改的文件
git add main_claude.py
git add config.py
git add .gitignore

# 2. 提交
git commit -m "feat: Add Claude Code CLI support

- Add main_claude.py: Adapted pipeline to use Claude Code CLI
- Modify config.py: Support Anthropic API configuration
- Update .gitignore: Ignore personal learning materials

This allows users to run FM-Agent with Claude Code CLI instead of OpenCode.
Maintains full backward compatibility with original OpenCode version."

# 3. 推送到你的 fork
git push origin main
```

### 验证 my-learning/ 被忽略

```bash
# 查看 git 状态
git status

# my-learning/ 不应该出现在输出中

# 查看 .gitignore
cat .gitignore | grep my-learning
# 应该看到：my-learning/
```

## 🚀 使用方式

### 方式 1：使用 Claude Code 版本

```bash
cd /mnt/d/fm-agent

# 使用 my-learning/ 中的脚本
./my-learning/run_with_claude.sh /path/to/project

# 或直接运行
export ANTHROPIC_BASE_URL="https://cc-vibe.com"
export ANTHROPIC_AUTH_TOKEN="your-token"
export LLM_MODEL="claude-sonnet-4"
python3 main_claude.py /path/to/project
```

### 方式 2：使用原版 OpenCode

```bash
cd /mnt/d/fm-agent

# 使用原版（如果安装了 OpenCode）
export OPENROUTER_API_KEY="your-key"
python3 main.py /path/to/project
```

## 📚 学习资料访问

所有学习资料都在 `my-learning/` 目录：

```bash
cd /mnt/d/fm-agent/my-learning

# 查看所有文档
ls *.md

# 快速参考
cat QUICK_REFERENCE.md

# 详细使用指南
cat CLAUDE_CODE_USAGE.md

# 技术学习
cat fm-agent-学习资料.md
```

## 🔄 前向兼容性保证

### 对原项目的兼容

1. **原版功能完全保留**
   - `main.py` 未修改
   - `src/` 目录未修改
   - `md/` 目录未修改

2. **新增功能独立**
   - `main_claude.py` 是独立文件
   - 不影响原版 OpenCode 使用
   - 用户可以选择使用哪个版本

3. **配置向后兼容**
   - `config.py` 支持原有的 `OPENROUTER_API_KEY`
   - 同时支持新的 `ANTHROPIC_AUTH_TOKEN`
   - 不会破坏现有配置

### 对你的 Fork 的影响

1. **可以安全推送**
   - 只推送核心代码修改
   - 不推送个人学习资料
   - 保持仓库整洁

2. **可以持续更新**
   - 可以从上游同步更新
   - 你的修改不会冲突
   - 可以持续贡献

3. **可以独立维护**
   - `my-learning/` 目录完全独立
   - 可以随意添加个人资料
   - 不影响主仓库

## ⚠️ 重要提醒

### 推送前检查

```bash
# 1. 确认 my-learning/ 被忽略
git status | grep my-learning
# 应该没有输出

# 2. 确认只有核心文件被跟踪
git status
# 应该只看到：main_claude.py, config.py, .gitignore

# 3. 查看即将提交的内容
git diff --cached
```

### 同步上游更新

```bash
# 1. 添加上游仓库（如果还没有）
git remote add upstream https://github.com/legendlsf/FM-Agent.git

# 2. 获取上游更新
git fetch upstream

# 3. 合并上游更新
git merge upstream/main

# 4. 解决冲突（如果有）
# 主要关注 config.py，保留你的修改

# 5. 推送到你的 fork
git push origin main
```

## 📊 文件统计

### 推送到 Fork 的修改

| 文件 | 类型 | 行数 | 说明 |
|------|------|------|------|
| main_claude.py | 新增 | +600 | Claude Code 适配版 |
| config.py | 修改 | +5 | 支持 Anthropic API |
| .gitignore | 修改 | +3 | 忽略 my-learning/ |
| **总计** | - | **+608** | - |

### 不推送的学习资料

| 目录 | 文件数 | 总大小 | 说明 |
|------|--------|--------|------|
| my-learning/ | 11 个 | ~90 KB | 个人学习资料 |

## 🎯 总结

✅ **清晰的分离**
- 核心代码修改在主仓库
- 个人学习资料在 my-learning/
- 通过 .gitignore 自动分离

✅ **前向兼容**
- 不破坏原有功能
- 可以安全推送到 fork
- 可以持续同步上游

✅ **易于维护**
- 学习资料独立管理
- 不污染主仓库
- 可以随意添加内容

---

**文档创建时间**：2026-05-16  
**项目状态**：✅ 准备就绪，可以推送到 fork

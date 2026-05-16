# FM-Agent Claude Code 适配 - 快速参考

## 🚀 快速开始（3 步）

```bash
# 1. 测试配置
cd /mnt/d/fm-agent && ./test_claude_config.sh

# 2. 运行分析
./run_with_claude.sh /mnt/d/fm-agent-test/datafabric-layer1-pti

# 3. 查看结果
cat /mnt/d/fm-agent-test/datafabric-layer1-pti/fm_agent/bug_validation/summary.json
```

## 📁 关键文件位置

| 文件 | 路径 | 用途 |
|------|------|------|
| 主程序 | `/mnt/d/fm-agent/main_claude.py` | Claude Code 适配版 |
| 启动脚本 | `/mnt/d/fm-agent/run_with_claude.sh` | 一键运行 |
| 测试脚本 | `/mnt/d/fm-agent/test_claude_config.sh` | 验证配置 |
| 使用指南 | `/mnt/d/fm-agent/CLAUDE_CODE_USAGE.md` | 详细文档 |
| 提交指南 | `/mnt/d/fm-agent/GITHUB_SUBMISSION_GUIDE.md` | GitHub 提交 |
| 学习资料 | `/mnt/d/fm-agent-学习资料.md` | 技术原理 |

## 🎯 三种提交方式

### 1️⃣ 向原项目提交 PR（推荐）
```bash
git remote add myfork https://github.com/<你的用户名>/FM-Agent.git
git checkout -b feature/claude-code-support
git add main_claude.py config.py *.sh *.md
git commit -m "feat: Add Claude Code CLI support"
git push myfork feature/claude-code-support
# 然后在 GitHub 创建 PR
```

### 2️⃣ 创建独立 Fork
```bash
# 在 GitHub 创建新仓库：FM-Agent-Claude
git remote add myrepo https://github.com/<你的用户名>/FM-Agent-Claude.git
git push myrepo main
```

### 3️⃣ 仅自己使用
```bash
# 无需任何操作，直接使用即可
./run_with_claude.sh /path/to/your/project
```

## ⚙️ 环境变量

```bash
export ANTHROPIC_BASE_URL="https://cc-vibe.com"
export ANTHROPIC_AUTH_TOKEN="sk-fc1ef9bdb10b97093baa6b4eb0ea3c825352cfb7cf4c1db6061ee33175e9acf7"
export LLM_MODEL="claude-sonnet-4"
```

## 📊 预期结果

```
输出目录：<项目>/fm_agent/
├── fm_agent.log                   # 完整日志
├── phases.json                    # 模块划分
├── extracted_functions/           # 提取的函数
├── spec_prompts/                  # 规范生成提示词
├── logic_verification_results/    # 验证结果
└── bug_validation/                # Bug 报告
    ├── summary.json               # 统计
    ├── bug_001.md                 # 详细报告
    └── _probe_bug_001.py          # 测试脚本
```

## 🐛 常见问题

### claude 命令未找到
```bash
which claude
# 如果没有输出，检查 PATH 或重新安装
```

### API 认证失败
```bash
# 测试 API 连接
curl -H "Authorization: Bearer $ANTHROPIC_AUTH_TOKEN" \
     https://cc-vibe.com/v1/models
```

### phases.json 未生成
```bash
# 查看日志
tail -100 <项目>/fm_agent/fm_agent.log
```

## 📚 完整文档

| 文档 | 内容 |
|------|------|
| CLAUDE_CODE_USAGE.md | 详细使用指南、故障排查 |
| ADAPTATION_SUMMARY.md | 适配总结、技术细节 |
| GITHUB_SUBMISSION_GUIDE.md | GitHub 提交完整指南 |
| PROJECT_COMPLETION_SUMMARY.md | 项目完成总结 |
| fm-agent-学习资料.md | FM-Agent 技术原理 |
| fm-agent-项目状态分析.md | 项目评估报告 |

## ✅ 许可证合规

- ✅ Apache License 2.0
- ✅ 允许修改和分发
- ✅ 允许商业使用
- ✅ 已保留原始许可证
- ✅ 已添加修改说明

## 💰 成本估算

| 项目规模 | 预计时间 | 预计成本 |
|----------|----------|----------|
| 1K 行 | 10-30 分钟 | $2-5 |
| 10K 行 | 30-120 分钟 | $10-50 |
| 50K 行 | 2-8 小时 | $50-200 |

## 🎓 学习资源

- 论文：https://arxiv.org/abs/2604.11556
- 官网：http://fm-agent.ai/
- GitHub：https://github.com/legendlsf/FM-Agent

## 📞 获取帮助

1. 查看文档：`/mnt/d/fm-agent/*.md`
2. 查看日志：`<项目>/fm_agent/fm_agent.log`
3. 测试配置：`./test_claude_config.sh`

---

**版本**：v1.0  
**日期**：2026-05-16  
**状态**：✅ 生产就绪

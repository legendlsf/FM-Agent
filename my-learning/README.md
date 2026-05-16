# My Learning - FM-Agent 学习和测试资料

这个目录包含我个人的学习资料、测试脚本和文档，**不会推送到 fork 仓库**。

## 📁 目录结构

```
my-learning/
├── README.md                          # 本文件
│
├── 快速开始
│   ├── run_with_claude.sh             # 一键启动脚本
│   ├── test_claude_config.sh          # 配置测试脚本
│   └── QUICK_REFERENCE.md             # 快速参考卡片
│
├── 使用文档
│   ├── CLAUDE_CODE_USAGE.md           # 详细使用指南
│   ├── ADAPTATION_SUMMARY.md          # 适配总结
│   └── CONTRIBUTING.md                # 贡献指南
│
├── 学习资料
│   ├── fm-agent-学习资料.md           # FM-Agent 技术原理
│   └── fm-agent-项目状态分析.md       # 项目评估报告
│
└── GitHub 相关
    ├── GITHUB_SUBMISSION_GUIDE.md     # GitHub 提交指南
    └── PROJECT_COMPLETION_SUMMARY.md  # 项目完成总结
```

## 🚀 快速开始

### 1. 测试配置

```bash
cd /mnt/d/fm-agent
./my-learning/test_claude_config.sh
```

### 2. 运行分析

```bash
cd /mnt/d/fm-agent
./my-learning/run_with_claude.sh /path/to/your/project
```

### 3. 查看结果

```bash
cat /path/to/your/project/fm_agent/bug_validation/summary.json
```

## 📚 文档说明

### 必读文档

1. **QUICK_REFERENCE.md** - 快速参考，包含所有常用命令
2. **CLAUDE_CODE_USAGE.md** - 详细使用指南，包含故障排查
3. **fm-agent-学习资料.md** - FM-Agent 技术原理和架构

### 进阶文档

4. **ADAPTATION_SUMMARY.md** - 适配技术细节
5. **fm-agent-项目状态分析.md** - 项目评估和适用场景
6. **PROJECT_COMPLETION_SUMMARY.md** - 完整的项目总结

### GitHub 相关（如果需要提交）

7. **GITHUB_SUBMISSION_GUIDE.md** - 完整的 GitHub 提交指南
8. **CONTRIBUTING.md** - 贡献指南

## 🎯 与主仓库的关系

### 主仓库（可推送到 fork）

```
/mnt/d/fm-agent/
├── main_claude.py          # ✅ 核心代码修改
├── config.py               # ✅ 配置修改
├── main.py                 # ✅ 原版保留
├── src/                    # ✅ 原版保留
├── md/                     # ✅ 原版保留
└── LICENSE                 # ✅ 原版保留
```

### my-learning 目录（仅本地）

```
/mnt/d/fm-agent/my-learning/
├── *.sh                    # ❌ 不推送：测试脚本
├── *.md                    # ❌ 不推送：学习文档
└── README.md               # ❌ 不推送：本说明
```

## 🔧 .gitignore 配置

在主仓库的 `.gitignore` 中添加：

```
# My personal learning materials
my-learning/
```

这样 `my-learning/` 目录不会被 git 跟踪。

## 📝 使用场景

### 场景 1：学习 FM-Agent

```bash
# 阅读学习资料
cat my-learning/fm-agent-学习资料.md

# 理解适配细节
cat my-learning/ADAPTATION_SUMMARY.md
```

### 场景 2：测试运行

```bash
# 测试配置
./my-learning/test_claude_config.sh

# 运行分析
./my-learning/run_with_claude.sh /path/to/project
```

### 场景 3：准备提交（如果需要）

```bash
# 查看提交指南
cat my-learning/GITHUB_SUBMISSION_GUIDE.md

# 查看完成总结
cat my-learning/PROJECT_COMPLETION_SUMMARY.md
```

## 💡 提示

1. **所有脚本都从主仓库根目录运行**
   ```bash
   cd /mnt/d/fm-agent
   ./my-learning/run_with_claude.sh <project>
   ```

2. **文档可以随时查阅**
   ```bash
   ls my-learning/*.md
   ```

3. **这个目录不会影响主仓库**
   - 不会被 git 跟踪
   - 不会推送到 GitHub
   - 可以随意修改和添加内容

## 🎓 学习路径建议

### 第一步：理解原理（1-2 小时）
1. 阅读 `fm-agent-学习资料.md`
2. 理解 Hoare 逻辑和形式化方法
3. 了解 FM-Agent 的五阶段流水线

### 第二步：测试运行（30 分钟）
1. 运行 `test_claude_config.sh`
2. 运行 `run_with_claude.sh` 分析测试项目
3. 查看生成的规范和 Bug 报告

### 第三步：深入理解（2-3 小时）
1. 阅读 `ADAPTATION_SUMMARY.md` 了解适配细节
2. 阅读 `fm-agent-项目状态分析.md` 了解适用场景
3. 查看 `main_claude.py` 源码理解实现

### 第四步：实际应用（持续）
1. 在 DataFabric 项目上使用
2. 根据结果调整配置
3. 建立最佳实践

## 📞 获取帮助

1. **查看快速参考**：`cat my-learning/QUICK_REFERENCE.md`
2. **查看使用指南**：`cat my-learning/CLAUDE_CODE_USAGE.md`
3. **查看日志**：`cat <项目>/fm_agent/fm_agent.log`

---

**目录创建时间**：2026-05-16  
**用途**：个人学习和测试  
**状态**：不推送到 GitHub

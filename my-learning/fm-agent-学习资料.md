# FM-Agent 项目学习资料

## 一、项目概述

### 1.1 项目定位
FM-Agent 是**首个实现大规模系统自动化组合推理的框架**，通过 LLM 驱动的 Hoare 风格推理来扩展形式化方法的应用范围。

- **论文**：FM-Agent: Scaling Formal Methods to Large Systems via LLM-Based Hoare-Style Reasoning
- **arXiv**：https://arxiv.org/abs/2604.11556
- **在线服务**：http://fm-agent.ai/
- **GitHub**：https://github.com/legendlsf/FM-Agent

### 1.2 解决的核心问题

**传统形式化方法的困境**：
- 难以扩展到大型系统（10万+ 行代码）
- 需要大量人工编写规范和证明
- 学习曲线陡峭，专业门槛高

**FM-Agent 的解决方案**：
- 使用 LLM 自动生成函数的行为规范（behavioral specifications）
- 基于 Hoare 逻辑进行组合推理（compositional reasoning）
- 自动推导测试用例验证潜在 bug
- 已成功应用于 143K LoC 的 Claude's C Compiler

### 1.3 核心价值

1. **自动化**：从代码自动生成规范，无需手工编写
2. **可扩展**：支持大规模代码库（10万+ 行）
3. **实用性**：自动生成测试用例并确认 bug
4. **通用性**：支持 10 种主流编程语言

---

## 二、技术架构

### 2.1 技术栈

```
核心框架：Python 3.12
AI 代理：OpenCode 1.4.6
LLM 服务：OpenRouter API
推荐模型：Claude Opus 4.6/4.7, Claude Sonnet 4.6
运行时：Bun (JavaScript runtime)
插件：oh-my-opencode
```

### 2.2 目录结构

```
fm-agent/
├── main.py                    # 入口和流水线编排器
├── config.py                  # 配置常量（模型、粒度、并发）
├── install.sh                 # 依赖安装脚本
├── src/                       # 核心源码模块
│   ├── extract.py            # 函数提取
│   ├── reasoner.py           # 推理引擎
│   ├── verification.py       # 验证逻辑
│   ├── llm_client.py         # LLM 交互
│   ├── parser.py             # 代码解析
│   ├── prompts.py            # 提示词生成
│   ├── file_utils.py         # 文件工具
│   ├── generate_topdown_layers.py    # 层次生成
│   ├── generate_batch_prompts.py     # 批量提示词
│   └── run_batch_gen.py              # 批量生成
└── md/                        # 工作流指导文档
    ├── system_prompt.md              # 规范生成规则
    ├── bug_validator.md              # Bug 验证指令
    ├── workflow_setup_extract.md     # 提取工作流
    ├── workflow_spec_step1_layers.md # 层次生成工作流
    └── workflow_spec_step4_batch.md  # 批量规范生成
```

### 2.3 核心配置参数

```python
# config.py
LLM_MODEL = "anthropic/claude-sonnet-4.6"  # LLM 模型
LLM_OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY")
LLM_OPENROUTER_API_BASE_URL = "https://openrouter.ai/api/v1"

MAX_SPC_ITER = 5          # 最大规范迭代次数
GRANULARITY = 40          # 代码块粒度（行数）
MAX_WORKERS = 10          # 最大并发工作线程
OPENCODE_MAX_RETRIES = 5  # OpenCode 最大重试次数
```

---

## 三、工作流程详解

### 3.1 五阶段流水线

```
Stage 1: 初始化 OpenCode
  └─> 在项目目录创建 AGENTS.md

Stage 2: 理解代码库并提取函数
  ├─> 分析项目结构
  ├─> 识别模块和依赖关系
  ├─> 生成 phases.json（阶段定义）
  └─> 提取所有函数到独立文件

Stage 3: 收集文件列表
  └─> 生成 fm_agent_file_list.json

Stage 4: 生成自顶向下层次
  ├─> 构建调用图（call graph）
  ├─> 计算拓扑层次
  └─> 生成 phase_NN_topdown_layers.json

Stage 5: 生成规范并验证
  ├─> 按阶段、按层次生成规范
  ├─> 并发调用 LLM 生成 [SPEC] 块
  ├─> 流式验证推理
  └─> 自动生成测试用例确认 bug
```

### 3.2 关键数据结构

#### phases.json 结构
```json
{
  "project": "项目名称",
  "languages": ["cpp", "python"],
  "file_extensions": ["cpp", "py"],
  "phases": [
    {
      "phase": 1,
      "name": "数据加载阶段",
      "description": "从文件系统加载原始数据",
      "modules": [
        {
          "name": "loader",
          "source_files": ["src/loader.cpp", "src/utils.cpp"]
        }
      ],
      "depends_on_phases": []
    }
  ]
}
```

#### 规范格式（SPEC Block）
```cpp
// [SPEC]
// Unit: src/engine/loader.cpp
//
// loadData(path: string) -> DataSet
//
// Pre-condition:
//   - path 是有效的文件路径
//   - 文件格式符合 CSV 规范
//
// Post-condition:
//   - 返回的 DataSet 包含所有行
//   - 每行的列数与 header 一致
//   - 数值列已转换为 double 类型
// [SPEC]

// [INFO]
// parseCSV(content: string) -> vector<vector<string>>
//   Pre-condition: content 是有效的 CSV 字符串
//   Post-condition: 返回二维数组，每行对应一个 CSV 行
// [INFO]

// 原始代码保持不变
DataSet loadData(const string& path) {
    // ...
}
```

### 3.3 Bug 验证流程

```
1. 逻辑验证发现 MISMATCH
   └─> 规范声称的后置条件 vs 代码实际行为不一致

2. 提取 gap 信息
   ├─> spec_claim: 规范要求的后置条件
   ├─> actual_behavior: 代码实际实现的行为
   ├─> code_evidence: 导致违反的具体代码行
   └─> trigger_condition: 触发 bug 的条件描述

3. 自动生成测试用例
   ├─> 通过公共 API 调用目标函数
   ├─> 使用 trigger_condition 构造输入
   └─> 断言 actual vs expected

4. 执行测试并确认
   ├─> 运行测试脚本
   ├─> 捕获输出
   └─> 判断 CONFIRMED / NOT CONFIRMED

5. 生成 Bug 报告
   ├─> <bug_id>.md: 详细的 Markdown 报告
   ├─> _probe_<bug_id>.<ext>: 测试脚本
   └─> <bug_id>.result.json: 机器可读结果
```

---

## 四、核心算法

### 4.1 Hoare 风格推理

**Hoare 三元组**：`{P} C {Q}`
- P: 前置条件（Pre-condition）
- C: 程序代码（Code）
- Q: 后置条件（Post-condition）

**组合推理规则**：
```
如果：
  {P1} f1() {Q1}
  {P2} f2() {Q2}
  Q1 ⊢ P2  (f1 的后置条件蕴含 f2 的前置条件)

则：
  {P1} f1(); f2() {Q2}
```

### 4.2 自顶向下层次生成

```python
# 算法伪代码
def generate_topdown_layers(phase):
    # 1. 构建调用图
    call_graph = build_call_graph(phase.functions)
    
    # 2. 计算拓扑排序
    topo_order = topological_sort(call_graph)
    
    # 3. 分配层次（从叶子到根）
    layers = {}
    for func in reversed(topo_order):
        if is_leaf(func):
            layers[func] = 0
        else:
            max_callee_layer = max(layers[callee] for callee in func.callees)
            layers[func] = max_callee_layer + 1
    
    # 4. 按层次分组
    return group_by_layer(layers)
```

**层次推理顺序**：
- Layer 0: 叶子函数（无调用）→ 先生成规范
- Layer 1: 只调用 Layer 0 的函数
- Layer N: 调用 Layer 0..N-1 的函数

### 4.3 代码块分割策略

```python
def split_into_blocks(func, granularity=40):
    """
    将长函数分割为多个块，每块约 40 行
    保持语法完整性（括号匹配）
    """
    lines = func.split('\n')
    if len(lines) <= granularity:
        return [func]
    
    blocks = []
    i = 0
    while i < len(lines):
        remaining = len(lines) - i
        if remaining <= granularity * 2:
            # 最后一块，全部包含
            blocks.append('\n'.join(lines[i:]))
            break
        
        end = i + granularity
        blocks.append('\n'.join(lines[i:end]))
        i = end
    
    return blocks
```

---

## 五、支持的编程语言

### 5.1 语言列表

| 语言 | 扩展名 | 注释语法 | 状态 |
|------|--------|----------|------|
| Rust | .rs | // | ✅ 完全支持 |
| C | .c | // | ✅ 完全支持 |
| C++ | .cpp, .cc, .cxx | // | ✅ 完全支持 |
| Python | .py | # | ✅ 完全支持 |
| Java | .java | // | ✅ 完全支持 |
| Go | .go | // | ✅ 完全支持 |
| CUDA | .cu | // | ✅ 完全支持 |
| JavaScript | .js | // | ✅ 完全支持 |
| TypeScript | .ts | // | ✅ 完全支持 |
| ArkTS | .ets | // | ✅ 完全支持 |

### 5.2 规范注释适配

```python
# 根据语言自动选择注释前缀
COMMENT_PREFIX = {
    'c': '//',
    'cpp': '//',
    'java': '//',
    'go': '//',
    'rust': '//',
    'python': '#',
    'ruby': '#',
    'shell': '#',
    'lua': '--',
    'haskell': '--',
    'sql': '--',
}
```

---

## 六、输出产物

### 6.1 目录结构

```
<项目根目录>/
└── fm_agent/                          # FM-Agent 工作目录
    ├── fm_agent.log                   # 完整日志
    ├── phases.json                    # 阶段定义
    ├── fm_agent_file_list.json        # 文件列表
    ├── extracted_functions/           # 提取的函数
    │   └── <path>/<file-ext>/
    │       └── <function_name>.<ext>
    ├── spec_prompts/                  # 规范生成提示词
    │   ├── system_prompt.md
    │   ├── phase_NN_topdown_layers.json
    │   └── batch_prompts_<project>_phaseNN/
    │       ├── manifest.json
    │       └── batch_NNN.md
    ├── logic_verification_results/    # 验证结果
    │   └── <path>/<file-ext>/
    │       └── <function_name>.result.json
    └── bug_validation/                # Bug 验证
        ├── summary.json               # 汇总统计
        ├── <bug_id>.md                # Bug 报告
        ├── <bug_id>.result.json       # 验证结果
        └── _probe_<bug_id>.<ext>      # 测试脚本
```

### 6.2 Bug 报告格式

```markdown
# Bug Report: <bug_id>

## Specification Claim
规范要求的后置条件

## Actual Behavior
代码实际实现的行为

## Code Evidence
导致违反的具体代码（带行号）

## Trigger Condition
触发 bug 的条件描述

## How to Trigger
- Input: 具体输入参数
- Expected: 期望输出
- Actual: 实际输出
- Steps: 复现步骤

## Probe Script
完整的测试脚本代码

## Probe Output
执行测试脚本的原始输出
```

### 6.3 结果统计

```json
// summary.json
{
  "total_reported": 15,
  "total_confirmed": 8,
  "total_not_confirmed": 5,
  "total_error": 2
}
```

---

## 七、使用方法

### 7.1 环境准备

```bash
# 1. 设置 OpenRouter API Key
export OPENROUTER_API_KEY="your-api-key-here"

# 2. 安装依赖
cd /mnt/d/fm-agent
./install.sh

# 3. (可选) 配置 oh-my-opencode
# 编辑 ~/.config/opencode/oh-my-opencode.json
{
  "disabled_hooks": ["comment-checker"]
}
```

### 7.2 运行分析

```bash
# 基本用法
python3 main.py <项目目录>

# 示例
python3 main.py /path/to/your/project
```

### 7.3 查看结果

```bash
# 查看日志
tail -f <项目目录>/fm_agent/fm_agent.log

# 查看 Bug 统计
cat <项目目录>/fm_agent/bug_validation/summary.json

# 查看具体 Bug 报告
ls <项目目录>/fm_agent/bug_validation/*.md
```

---

## 八、关键设计原则

### 8.1 规范编写规则（7 条黄金法则）

**Rule 1: 描述 WHAT，不描述 HOW**
- ✅ 好：返回排序后的数组，元素按升序排列
- ❌ 差：调用 quicksort 函数对数组排序

**Rule 2: 不描述实现细节**
- 不提及内部辅助函数名
- 不枚举条件分支
- 不列举常量值

**Rule 3: 避免模糊术语**
- ❌ 禁用：appropriate, correctly handles, as expected, properly
- ✅ 使用：精确的不变量和可验证的断言

**Rule 4: 规范由调用者驱动**
- 前置条件：调用者保证的条件
- 后置条件：调用者需要的保证

**Rule 5: 描述预期的正确行为**
- 规范不记录 bug
- 即使实现有 bug，规范仍描述正确行为

**Rule 6: 允许验证，不允许重构**
- 规范应该能验证实现
- 规范不应该能重构出实现

**Rule 7: 精确 = 治理规则，非枚举**
- ❌ 差：调度到 fmtShort 或 fmtLong
- ✅ 好：当 options.long 为 true 时返回长格式字符串

### 8.2 组合推理原则

1. **模块化**：每个函数独立规范
2. **层次化**：自底向上推理
3. **增量式**：利用已验证的 callee 规范
4. **并行化**：同层函数可并行处理

---

## 九、技术亮点

### 9.1 创新点

1. **首个 LLM 驱动的形式化方法框架**
   - 传统形式化方法需要专家手工编写
   - FM-Agent 实现全自动化

2. **可扩展的组合推理**
   - 支持 10万+ 行代码
   - 通过层次化分解降低复杂度

3. **端到端的 Bug 发现流程**
   - 不仅发现不一致
   - 自动生成测试用例确认

4. **多语言通用框架**
   - 支持 10 种主流语言
   - 统一的规范格式

### 9.2 工程优化

1. **并发处理**
   - 同层函数并行生成规范
   - 多个 OpenCode 进程并发

2. **容错机制**
   - 网络错误自动重试（最多 5 次）
   - 检测 rate limit 和 timeout

3. **增量处理**
   - 检查已生成的规范
   - 只处理缺失的部分

4. **流式验证**
   - 边生成边验证
   - 实时反馈进度

---

## 十、适用场景

### 10.1 理想场景

✅ **适合使用 FM-Agent 的项目**：
- 大型代码库（1万+ 行）
- 关键业务逻辑
- 需要高可靠性的系统
- 编译器、数据库、操作系统等基础软件
- 金融、医疗等安全关键领域

### 10.2 限制场景

⚠️ **不太适合的场景**：
- 小型脚本（< 1000 行）
- UI 交互逻辑
- 高度动态的代码（大量反射、元编程）
- 不支持的编程语言

### 10.3 模型要求

**强烈推荐**：
- Claude Opus 4.6/4.7
- Claude Sonnet 4.6

**原因**：
- 需要强大的推理能力
- 弱模型可能产生幻觉
- 导致错误的推理结论

---

## 十一、学习路径建议

### 11.1 理论基础

1. **Hoare 逻辑**
   - 前置条件、后置条件、不变量
   - 组合推理规则
   - 推荐阅读：《程序设计的逻辑基础》

2. **形式化方法**
   - 规范语言（Z, VDM, Alloy）
   - 定理证明（Coq, Isabelle）
   - 模型检测（SPIN, TLA+）

3. **程序分析**
   - 静态分析
   - 符号执行
   - 抽象解释

### 11.2 实践步骤

**第一步：小项目试验**
```bash
# 选择一个 1000 行左右的项目
python3 main.py /path/to/small/project
```

**第二步：分析输出**
- 阅读生成的规范
- 查看 Bug 报告
- 理解推理过程

**第三步：定制化**
- 修改 md/system_prompt.md
- 添加项目特定的领域知识
- 调整 config.py 参数

**第四步：大项目应用**
- 选择关键模块
- 逐步扩展到整个项目

### 11.3 进阶方向

1. **扩展语言支持**
   - 添加新的语言解析器
   - 适配注释语法

2. **优化推理策略**
   - 调整层次划分算法
   - 改进规范生成提示词

3. **集成 CI/CD**
   - 自动化运行 FM-Agent
   - 将 Bug 报告集成到工作流

---

## 十二、常见问题

### Q1: 为什么必须使用 OpenRouter？
A: FM-Agent 需要并发调用 LLM，OpenRouter 在 RPM/TPM 限制上更灵活。

### Q2: 可以使用其他模型吗？
A: 可以，但强烈推荐 Claude Opus/Sonnet 4.6+。弱模型可能产生不可靠的推理。

### Q3: 分析需要多长时间？
A: 取决于代码规模和模型速度。10K 行代码约需 30-60 分钟。

### Q4: 如何提高准确率？
A: 
- 使用更强的模型
- 在 md/ 目录添加项目文档
- 调整 GRANULARITY 参数

### Q5: 发现的 Bug 都是真实的吗？
A: 不一定。需要人工审查确认。FM-Agent 提供测试脚本辅助验证。

---

## 十三、参考资源

### 13.1 论文和文档
- 论文：https://arxiv.org/abs/2604.11556
- 官网：http://fm-agent.ai/
- GitHub：https://github.com/legendlsf/FM-Agent

### 13.2 相关技术
- OpenCode：https://github.com/opencode-ai/opencode
- OpenRouter：https://openrouter.ai/
- Hoare Logic：https://en.wikipedia.org/wiki/Hoare_logic

### 13.3 形式化方法工具
- Coq：https://coq.inria.fr/
- Isabelle：https://isabelle.in.tum.de/
- TLA+：https://lamport.azurewebsites.net/tla/tla.html
- Alloy：https://alloytools.org/

---

## 十四、总结

FM-Agent 是形式化方法领域的重要突破，通过 LLM 实现了大规模系统的自动化验证。它的核心价值在于：

1. **降低门槛**：无需形式化方法专家
2. **提高效率**：自动化生成规范和测试
3. **扩展能力**：支持 10万+ 行代码
4. **实用性强**：端到端的 Bug 发现流程

对于需要高可靠性的软件系统，FM-Agent 提供了一种全新的质量保证手段。

---

**文档版本**：v1.0  
**更新日期**：2026-05-16  
**作者**：Hermes Agent  
**项目地址**：/mnt/d/fm-agent

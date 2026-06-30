# 体系总览

## 设计哲学

本规范体系的核心理念：**三层嵌套，各管各的。**

```
┌─────────────────────────────────────────────────────────────┐
│                  7 阶段流程 (AGENTS.md)                       │
│  项目级质量门禁 — 该做的事都做了吗？                        │
│  阶段 0-3: 对话完成（检查/澄清/PRD/架构）                   │
│  阶段 4-7: auto-exec 接管                                   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │         auto-exec（跨会话执行编排）                    │    │
│  │  活太多一次做不完，怎么拆、怎么调度？                 │    │
│  │  .plan/task_plan.md + progress.md + scheduled task    │    │
│  │                                                       │    │
│  │  ┌──────────────────────────────────────────────┐    │    │
│  │  │  mode=tdd        → RED→GREEN→REFACTOR        │    │    │
│  │  │  mode=self-check → PLAN→DO→VERIFY→DECIDE     │    │    │
│  │  │  原子任务方法 — 这一小块怎么写才靠谱？         │    │    │
│  │  └──────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## 分层架构

### L1 — 约束层 (Constraints)

保证行为一致性的硬性和软性规则。

| 文件 | 可读？ | 机器可读？ | 加载时机 |
|------|--------|-----------|---------|
| `.clinerules` | ❌ | ✅ YAML | 每次代码生成前 |
| `core-rules.md` | ✅ | ❌ | 每次会话启动 |
| `prompt-defense.md` | ✅ | ❌ | 每次会话启动 |

- **`.clinerules`**：机器可读的硬约束。包含 FUSE 门禁、架构红线、安全规范、auto-exec 强制规则
- **`core-rules.md`**：人类可读的行为规则。包含意图分类、auto-exec 流程、TDD 哲学、记忆纪律
- **`prompt-defense.md`**：Prompt 注入防护。角色锁定、数据保护、外部数据隔离

### L2 — 流程层 (Processes)

将需求转化为可执行工作的整套流程。

| 流程 | 范围 | 载体 |
|------|------|------|
| AGENTS.md 7 阶段 | 项目级生命周期 | `.clinerules` 强制门禁 |
| auto-exec 编排 | 跨会话多步骤 | scheduled task + .plan/ |
| self-check loop | 单次中等任务 | 四步协议（PLAN→DO→VERIFY→DECIDE） |
| TDD | 代码原子任务 | RED→GREEN→REFACTOR |

### L3 — 协议层 (Protocols)

协作沟通的基建设施。

| 协议 | 位置 | 用途 |
|------|------|------|
| `.plan/` | 工作区根目录 | 持久化任务计划和进度 |
| `.cowork/` | 工作区根目录 | 协作状态、Design Note、审查记录 |
| `COLLABORATION.md` | 工作区根目录 | 审查门禁和协作模型 |
| `PROTOCOL.yaml` | `.cowork/` | 机器可读协作协议 |

### L4 — 基础设施层 (Infrastructure)

支撑上述三层运转的工具集。

| 组件 | 位置 | 用途 |
|------|------|------|
| Cowork Skills | Cowork 系统 | 可复用的执行指令集 |
| 共享记忆 | `MEMORY.md` + `memory/*.md` | 跨会话知识持久化 |
| 脚本工具 | `scripts/` | FUSE 安全写入、E2E 验证 |
| Git 钩子 | `.githooks/` | 提交前检查 |

## 关键指标

- **采纳率**：衡量产出质量的唯一标准（<50% 说明循环在烧钱）
- **停滞检测**：连续 3 轮未解决同一问题 → 标记 stuck
- **8 轮上限**：self-check 超过 8 轮未达标 → 标记 blocked
- **30 分钟原则**：超过 30 分钟的任务必须走 auto-exec

## 文件责任归属

```
工作区根目录/                    ← 不属于任何项目 git
├── .clinerules                 ← 本仓库 (dev-workflow-spec)
├── .claude/rules/
│   ├── core-rules.md           ← 本仓库
│   └── prompt-defense.md      ← 本仓库
├── MEMORY.md + memory/         ← 本仓库（模板）
├── COLLABORATION.md            ← 本仓库
├── .cowork/                    ← 本仓库
├── .plan/templates/            ← 本仓库
├── feature_gates.yaml          ← 本仓库（模板）
├── scripts/                    ← 本仓库
├── .githooks/                  ← 本仓库
│
└── 子项目/                     ← 各子项目独立 git
    ├── CLAUDE.md               ← 子项目 git 跟踪
    ├── AGENTS.md               ← 子项目 git 跟踪
    ├── PRD.md                  ← 子项目 git 跟踪
    ├── CHANGELOG.md            ← 子项目 git 跟踪
    └── .clinerules             ← 子项目 git 跟踪
```

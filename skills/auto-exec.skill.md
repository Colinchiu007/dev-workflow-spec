---
name: auto-exec
description: 自主执行编排 — 将开发目标自动分解为可执行任务，通过跨会话批量执行持续工作，支持多子Agent并行 + Review + E2E + 上下文压缩 + 自适应记忆 + Knowledge Module
---

# Auto-Exec 技能说明

## 所属仓库

完整 SKILL.md 和工作流程说明维护在 **auto-exec-mechanism** 仓库：

- **仓库**: `https://github.com/Colinchiu007/auto-exec-mechanism`
- **SKILL.md**: 完整 Phase 0-5 流程、Worker prompt 模板、知识模块
- **README.md**: 架构设计说明

### 配套 Skill：self-check-loop

Auto-Exec 的 `mode=self-check` 执行模式使用内置的 self-check 协议（PLAN→DO→VERIFY→DECIDE），该协议是 self-check-loop skill 的轻量内嵌版本。

**self-check-loop** 适用于单次中等复杂度任务（不需要跨会话编排的场景）：
- 写作、设计、架构评审
- 不需要多步骤依赖的独立任务
- 当前对话内能搞定

两者关系：

| Skill | 适用场景 | 验证机制 | 跨会话 |
|-------|---------|---------|--------|
| auto-exec | 多步骤工程任务 | TDD / self-check 协议 | 是 |
| self-check-loop | 单次中等复杂度任务 | VERIFY 打分 ≥8 | 否 |

## 触发条件

- "自动执行""持续做""跑几小时"
- 多步骤目标，不需要在旁边监督
- 明确说 `/auto-exec <目标>`

## 快速流程

### Phase 0: Intent Gate
| 类型 | 行动 |
|------|------|
| 简单查询 | 不启动 |
| 明确指令 | 可启动 |
| 开放任务（澄清后） | 可启动 |

### Phase 1: ECC 风险分级
| 等级 | 处理 |
|------|------|
| 🔵 低 | 全自动 |
| 🟡 中 | 完成 notify |
| 🔴 高 | 暂停等你确认 |

### Phase 2: 任务分解
写入 `.plan/task_plan.md`。每个任务：
- ≤30 分钟
- 标注 mode（tdd/self-check/auto）
- 标注验证标准
- 标注依赖和风险

### Phase 3-5: 执行 → 轮询 → 清理
完整内容见 [auto-exec-mechanism 仓库](https://github.com/Colinchiu007/auto-exec-mechanism)。

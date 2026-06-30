---
name: auto-exec
description: 自主执行编排 — 将开发目标自动分解为可执行任务，通过跨会话批量执行持续工作，支持多子Agent并行 + Review + E2E + 上下文压缩 + 自适应记忆 + Knowledge Module
---

# Auto-Exec 技能说明

## 触发条件

- "自动执行""持续做""跑几小时"
- 多步骤目标，不需要在旁边监督
- 明确说 `/auto-exec <目标>`

## 流程

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
见 `docs/04-AUTO-EXEC.md`。

## 关键门禁

- 采纳率追踪
- 停滞检测（连续 3 轮未解决 → stuck）
- self-check 8 轮上限
- PRD 同步

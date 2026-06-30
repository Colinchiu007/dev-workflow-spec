---
name: self-check-loop
description: 轻量自检循环协议 — 不需要 full auto-exec 编排时，用 PLAN-DO-VERIFY-DECIDE 四步让 AI 自我迭代直到达标。适用于单次中等复杂度任务。
---

# Self-Check Loop 技能说明

## 何时使用

介于普通 prompt 和完整 auto-exec 之间：
- 单次中等复杂度任务（写作、重构、组件设计）
- 需要多轮迭代但不想开整个编排
- 不需要跨会话持久化

## 协议模板

```
▸ SELF-CHECKING LOOP 协议
TASK（任务）：[描述产出]
SUCCESS CRITERIA（成功标准）：[标准 1][标准 2][标准 3]
LOOP PROTOCOL：
  1. PLAN — 说明下一步做什么
  2. DO — 产出或改进
  3. VERIFY — 每条标准 1-10 分，明确列出不达标项
  4. DECIDE — 全 ≥8 输出 FINAL；否则 ITERATING，修复最低分项
RULES：
  - 每条达 8 分前不准完成
  - 每轮修复最低分项
  - 不提问，自行假设
```

## 边界

- 超过 8 轮未 FINAL → 标准太高或任务太模糊
- AI 反复打 8+ 但产出不达标 → 收紧标准

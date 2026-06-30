---
name: handoff
description: 会话压缩成交接文档供新 agent 接续
---

# Handoff — 跨 Agent 交接

> 完整内容已安装为 Cowork skill。

## 何时使用

- 上下文窗口已消耗 >60%，需要切换新会话
- 从调研 Agent 移交给实现 Agent
- 多 Agent 并行工作时汇总状态

## 最小交接模板

```markdown
# Handoff: <会话主题>

## 已完成
- <关键成果>

## 未完成
- <待办项>

## 关键决策
- <决策内容> — <原因>

## 引用路径（非重复内容）
- PRD: <路径>
- .plan/: <路径>
- 关键文件: <路径>
```

不重复 PRD/plan/commit 已有内容，引用路径代替。

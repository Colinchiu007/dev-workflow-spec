# 共享记忆系统

## 架构

双记忆架构，一个共享（跨模式）、一个自动（模式私有）。

```
共享记忆（跨模式共用）         自动记忆（模式内部）
  memory/ + MEMORY.md          ~/.claude/projects/.../memory/
  ├── MEMORY.md（索引，始终加载前200行）    ├── 会话运行时自动写入
  ├── memory/*.md（主题文件）                └── update-memory 技能整理
  └── update-memory 技能维护
```

## 记忆类型

| type | 用途 | 内容要点 |
|------|------|---------|
| `user` | 用户角色、偏好、目标 | 技术栈、沟通风格、工作习惯 |
| `feedback` | 行为指导、偏好确认 | 规则 → Why → How to apply |
| `project` | 项目状态、决策、进展 | 事实/决策 → Why → How to apply |
| `reference` | 外部资源指针 | 信息在哪、怎么获取 |

## 文件格式

```markdown
---
name: kebab-case-name
description: 一句话描述，80-150字，说明什么场景下需要读取这个文件
metadata:
  type: user|project|feedback|reference
---

# 标题

内容包含 **Why:** 和 **How to apply:** 两个关键节。
```

## 索引格式（MEMORY.md）

```
- [名称](memory/文件名.md) — 一句话描述（80-100字）
```

每条一行，按主题分组，总行数 ≤ 200 行。

## 维护

- 会话结束时调用 `update-memory` 技能整理
- 周日凌晨定时任务 `weekly-memory-consolidation` 自动整理
- 写入优先写共享目录（`memory/*.md`），再写自动记忆
- 过时记忆移到 `memory/archived/` 或删除

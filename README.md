# AI Development Workflow Spec

> 一套完整的 AI 辅助开发规范体系，从项目初始化到跨会话多步骤任务编排。
> 当前版本：从 9 子项目视频生成平台实践中提取，可复用到任意技术项目。

## 体系一览

```
┌─────────────────────────────────────────────────────────┐
│                   约束层 (Constraint Layer)               │
│  .clinerules + core-rules.md + prompt-defense.md         │
│  机器可读硬约束 + 人类可读行为规则 + 安全基线            │
├─────────────────────────────────────────────────────────┤
│                   流程层 (Process Layer)                  │
│  AGENTS.md 7 阶段流程 → auto-exec 编排 → TDD/self-check  │
│  项目级生命周期 → 跨会话执行 → 原子任务方法              │
├─────────────────────────────────────────────────────────┤
│                   协议层 (Protocol Layer)                 │
│  .plan/ + .cowork/ + COLLABORATION.md + PROTOCOL.yaml    │
│  持久化计划 + 协作协议 + 审查门禁                         │
├─────────────────────────────────────────────────────────┤
│                   基础设施层 (Infrastructure)             │
│  skills + memory/ + scripts/ + .githooks/                │
│  可复用技能集 + 共享记忆 + 工具链 + Git 钩子             │
└─────────────────────────────────────────────────────────┘
```

## 包含什么

| 层 | 组件 | 文件/位置 |
|----|------|----------|
| **约束层** | 全局硬约束 | `templates/global/.clinerules` |
| | 核心行为规则 | `templates/global/core-rules.md` |
| | Prompt 安全防御 | `templates/global/prompt-defense.md` |
| **流程层** | 7 阶段开发流程 | `templates/project/AGENTS.md` |
| | 跨会话自动编排 | `skills/auto-exec.skill.md` |
| | 轻量自检循环 | `skills/self-check-loop.skill.md` |
| | TDD 方法论 | `docs/06-TDD-PHILOSOPHY.md` |
| **协议层** | .plan/ 持久化协议 | `templates/plan/` |
| | 协作协议 | `templates/global/PROTOCOL.yaml` |
| | 审查门禁 | `templates/global/COLLABORATION.md` |
| | Design Note 模板 | `templates/global/DESIGN_NOTE_TEMPLATE.md` |
| **基础设施** | 共享记忆系统 | `docs/09-MEMORY-SYSTEM.md` |
| | 安全写入脚本 | `scripts/safe-write.sh` |
| | Git 钩子 | `.githooks/pre-commit` |
| | Skill 激活规则 | `templates/claude-skills/skill-rules.json` |

## 快速开始

```bash
# 1. 克隆此仓库到新项目工作区
cp -r docs 项目根目录/docs-workflow

# 2. 初始化全局配置（在工作区根目录执行）
bash dev-workflow-spec/scripts/init-workspace.sh

# 3. 为新项目添加规范文件
bash dev-workflow-spec/scripts/init-project.sh 我的新项目
```

## 核心原则

- **结论先行**：任何方案/回答，开篇给结论，再附验证方式
- **先读代码再发言**：不做猜测，只做验证
- **测试驱动**：修复 bug 必须先写回归测试
- **PRD 同步**：功能改动必须同步 PRD
- **成本意识**：采纳率是北极星指标，不是跑了多少轮
- **fail fast**：不确定就说，不做假设执行

## 与相关项目的关系

| 项目 | 关系 |
|------|------|
| [auto-exec-mechanism](https://github.com/Colinchiu007/auto-exec-mechanism) | .plan/ 协议的独立工具实现（hash_anchor, init_deep, planning_pipeline 等） |
| oh-my-openagent | .plan/ STATE.md 协议的灵感来源 |

## 许可

MIT

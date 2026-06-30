# 7 阶段开发流程

## 概述

每个子项目的 `AGENTS.md` 定义了 7 阶段开发流程，由 `.clinerules` 的「7 阶段流程门禁」强制执行。

## 7 阶段

```
阶段 0: AGENTS.md 检查
  → 收到需求后先检查项目根目录是否有 AGENTS.md
  → 无或版本过旧：先补 AGENTS.md 再继续

阶段 1: 想法澄清
  → 模糊需求必须反问确认
  → 未经确认不得进入编码

阶段 2: PRD
  → 功能变更必须确认 PRD 已覆盖
  → 未覆盖 → 先更新 PRD
  → PRD 更新后确认 PRD 同步 markdown 已满足

阶段 3: 架构
  → 涉及架构决策的变更先读 ARCHITECTURE.md/AGENTS.md
  → 无架构文档 → 先写 Design Note 审批后再编码

阶段 4: 开发计划
  → 预估 >30 分钟的任务必须先拆子任务
  → 标注依赖和风险等级
  → auto-exec Phase 2 接管（如适用）

阶段 5: 编码
  → TDD（RED → GREEN → REFACTOR）
  → 先写失败测试，再实现，再重构
  → 每步只做一个

阶段 6: 代码评审
  → 提交前自审（安全/错误处理/边界/测试/PRD/CHANGELOG）
  → CRITICAL 问题必须修复才能继续

阶段 7: 发布
  → CI 通过 → git 已提交 → CHANGELOG 已更新
  → CI 不通过不合并
```

## 跳过条件

| 场景 | 可跳过 | 保留 |
|------|--------|------|
| 纯文档变更 | 阶段 3-5, TDD | 阶段 6(评审) + 阶段 7(CI) |
| 纯 CI/配置 | 阶段 2-4 | 阶段 6 + 阶段 7 |
| 紧急 bug 止血型 | 阶段 1-4 | 阶段 5(TDD) + 回归测试 |
| 紧急 bug 排查型 | 走 auto-exec | 轮询间隔 1 分钟 |

## 被归档的旧流程

以下机制已冻结，记录在 `ARCHIVED_PROCESSES.md`：
- Plan Gate（PROTOCOL.yaml）
- LLM-as-Judge
- Checkpoint 机制
- Full Track vs Fast Track
- Star↔Ring 审查升级
- Type C/D 审批
- Design Note 6 元素模板
- EARS 需求规范

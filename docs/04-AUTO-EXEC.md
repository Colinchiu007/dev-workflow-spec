# Auto-Exec — 跨会话执行编排

## 是什么

当任务需要 >30 分钟或 ≥3 个有依赖关系的步骤时，禁止在当前会话直接执行。必须拆分为子任务，通过 scheduled task 跨会话执行。

## 流程

```
Phase 0: 意图分类 (Intent Gate)
  → 不适用场景：简单查询、一次性指令、纯对话

Phase 1: 风险分级 (ECC)
  → 🔵 低：全自动
  → 🟡 中：执行完通知确认
  → 🔴 高：暂停等你确认

Phase 2: 任务分解
  → 写入 .plan/task_plan.md（≤30 分钟/子任务）
  → 标注 mode（tdd/self-check/auto）
  → 标注验证标准、依赖、风险

Phase 3: 执行启动
  → 创建 scheduled task（常规 5 分钟 / 排查型 1 分钟）
  → taskId: auto-exec-<目标简称>

Phase 4: 执行轮询
  → 每轮：读 .plan/ → 执行 → 测试 → 审查 → commit → 更新进度

Phase 5: 完成与清理
  → 清理 .plan/ → 禁用 scheduled task → 通知完成
```

## 执行模式

| mode | 适用场景 | 方法 | 验证 |
|------|---------|------|------|
| tdd | 代码逻辑、算法、API 实现 | RED→GREEN→REFACTOR | pytest 全绿 |
| self-check | 设计、文案、架构、UI | PLAN→DO→VERIFY→DECIDE | 自评 ≥8 分 |
| auto | 不确定 | 自行判断并更新 task_plan.md | — |

## 质量门禁（每轮必须执行）

1. **TDD 雪球**：涉及代码变更必须走 RED→GREEN→REFACTOR
2. **Review Checklist**：正确性 + 安全 + 错误处理 + 边界 + 测试
3. **PRD 门禁**：功能改动必须同步 PRD
4. **停滞检测**：连续 3 轮未解决同一问题 → 标记 stuck
5. **采纳率追踪**：记录每轮 accept/reject，累计 <50% 标记低效

## 与 self-check-loop 的关系

```
I[接到任务] --> J{任务规模}
J -->|单次中等复杂度| S[self-check-loop]
J -->|多步骤工程| A[auto-exec]
A --> P2[拆分子任务] --> P3{标注执行模式}
P3 -->|mode=tdd| EX1[RED→GREEN→REFACTOR]
P3 -->|mode=self-check| EX2[PLAN→DO→VERIFY→DECIDE]
EX1 --> P4[Review + 停滞检测]
EX2 --> P4 --> P5{全部完成?}
P5 -->|否| P3
P5 -->|是| DONE[汇总交付]
```

## 紧急 bug 分流

| 类型 | 条件 | 执行方式 |
|------|------|---------|
| 止血型 | 根因明确、≤3 文件、5-10 分钟 | 当前会话直接修复 |
| 排查型 | 根因不确定、需多路径探索 | auto-exec 编排，轮询 1 分钟 |
| 分界判断 | 能否 30 秒说清改哪几个文件、怎么改 | 能→止血型，不能→排查型 |

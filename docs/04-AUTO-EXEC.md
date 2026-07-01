# Auto-Exec — 跨会话批量执行编排

> 完整 SKILL.md 和工作流程说明维护在 [auto-exec-mechanism](https://github.com/Colinchiu007/auto-exec-mechanism) 仓库。
> 本文档为 dev-workflow-spec 体系中的概览和引用说明。

## 是什么

当任务需要 >30 分钟或 ≥3 个有依赖关系的步骤时，禁止在当前会话直接执行。必须拆分为子任务，通过 scheduled task 跨会话批量执行。

## 核心流程

```
Phase 0: Intent Gate           → 分类需求，只有明确指令/开放任务进入编排
Phase 1: ECC 风险分级           → 🔵全自动 🟡完成通知 🔴暂停确认
Phase 2: 任务分解               → 写入 .plan/task_plan.md
Phase 2.5: Knowledge Module    → .plan/knowledge/ 注入项目最佳实践（Phase 4 结束时自动收割写回）
Phase 3: 执行启动               → 创建 scheduled task + worker prompt
Phase 4: 批量执行轮询           → 每轮多任务，上下文 >70% 退出
Phase 5: 完成与清理             → 清理 .plan/ → 更新 MEMORY.md → 禁用 task → 通知
```

## 关键特性（v3 batch 模式）

| 特性 | 说明 |
|------|------|
| **Batch 执行** | 每轮尽可能多完成 pending 任务，直到上下文接近上限 |
| **分支检查** | 执行前 `git branch --show-current`，不在 main/特性分支则创建 `feat/auto-exec-<任务>` |
| **原子 Commit** | 每独立逻辑变更单独 commit，禁止 `git add -A` |
| **强制 Push** | 每 3 commit 或 batch 结束时 `git push`，失败时 `git pull --rebase` |
| **知识模块** | `.plan/knowledge/` 双向管道：预加载项目上下文 + 执行后自动收割失败/发现/模式 |
| **自适应退出** | 上下文使用率 >70% 时退出，等待下次轮询 |
| **停滞检测** | 连续 3 轮未解决同一问题 → 标记 stuck |
| **采纳率追踪** | 记录每轮 accept/reject，累计 <50% 标记低效 |

完整 worker prompt 模板见 [auto-exec-mechanism](https://github.com/Colinchiu007/auto-exec-mechanism) 的 SKILL.md。

## 执行模式

| mode | 适用场景 | 方法 | 验证 |
|------|---------|------|------|
| tdd | 代码逻辑、算法、API 实现 | RED→GREEN→REFACTOR | pytest 全绿 |
| self-check | 设计、文案、架构、UI | PLAN→DO→VERIFY→DECIDE | 自评 ≥8 分 |
| auto | 不确定 | 自行判断并更新 task_plan.md | — |

## 与 self-check-loop 的关系

```
[接到任务] --> 单次中等复杂度? --> self-check-loop (当前对话内迭代)
            --> 多步骤工程?    --> auto-exec (跨会话批量编排)
                                     ├── mode=tdd        → RED→GREEN→REFACTOR
                                     └── mode=self-check → PLAN→DO→VERIFY→DECIDE
```

## 紧急 bug 分流

| 类型 | 条件 | 执行方式 |
|------|------|---------|
| 止血型 | 根因明确、≤3 文件、5-10 分钟 | 当前会话直接修复 |
| 排查型 | 根因不确定、需多路径探索 | auto-exec 编排，轮询 1 分钟 |
| 分界判断 | 能否 30 秒说清改哪几个文件 | 能→止血型，不能→排查型 |

## .clinerules 两级决策树

全局 `.clinerules` 中定义了 auto-exec 的触发逻辑：

```
第一关（客观指标）→ 第二关（5条件逃脱口）→ 第三关（ABCD 分类）
         ↓                       ↓                  ↓
  >30min 或 ≥3步骤       全部满足可 bypass      A节奏/B攻坚/C探索/D破坏
```

详见 `.clinerules` 中的 `auto-exec 强制门禁（两级决策树）` 章节。

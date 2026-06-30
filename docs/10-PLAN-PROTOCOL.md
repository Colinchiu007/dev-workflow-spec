# .plan/ 协议 — 持久化任务计划

## 目录结构

```
.plan/
├── task_plan.md      # 编号伪代码执行计划
├── progress.md       # 进度 + 决策日志 + 阻塞项
├── todo.md           # 外部进度清单
├── knowledge/        # Knowledge Module 最佳实践注入
│   └── *.md          # scope + rules
└── templates/        # 模板文件
    ├── task_plan.tmpl.md
    ├── progress.tmpl.md
    ├── knowledge.tmpl.md
    └── todo.tmpl.md
```

## task_plan.md 格式

```markdown
# 项目: <项目名>
# 目标: <一句话目标>
# 创建: <日期>

## 任务清单

| # | 任务 | 依赖 | 风险 | PRD | 测试 | 模式 | 验证标准 | 状态 |
|---|------|------|------|-----|------|------|---------|------|
| 1 | 实现 auth API | - | low | no | yes | tdd | pytest 全绿 | pending |
| 2 | 设计 prompt 模板 | 1 | low | yes | no | self-check | 各项 ≥8 分 | pending |

## DAG
1.1 → 1.2 → 1.3 ─→ 2.1 → 2.2
```

### 列说明

| 列 | 必填 | 说明 |
|----|------|------|
| 模式 | ✅ | tdd / self-check / auto，缺省 = 不完整 |
| 验证标准 | ✅ | 可客观判断的条件，如"测试全绿""延迟 <200ms" |
| PRD | ✅ | true/false，PRD-impact 标记 |
| 测试 | ✅ | true（默认）/ false |
| 风险 | ✅ | low / medium / high（ECC 分级） |

## progress.md 格式

```markdown
# 进度

## 当前状态
- 当前任务: #
- 已完成: #/#
- 本轮执行: <时间戳>

## 决策记录
- <决策内容> — <决策原因>

## 采纳率追踪
- 本轮产出: accept N / reject N → 采纳率 N%
- 累计: accept N / reject N → 采纳率 N%
- 低采纳原因: <如果采纳率 < 50%，记录原因>

## 阻塞项
- [ ] <风险等级> <描述>
```

## 设计原则

- `.plan/` 是唯一真理源，所有执行器读取它
- 不要依赖会话上下文，每次执行是全新会话
- 子任务完成后把关键发现写入决策记录
- 执行完成时，摘要写入 MEMORY.md

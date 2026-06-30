# 协作协议

## 双角色模型

```
你（审查者 / 决策者）
    │
    ├── 提需求（方向性描述即可）
    ├── 审查重要变更（架构 / 契约 / 高风险）
    └── 裁决争议
    │
    ▼
我（执行 Agent）
    │
    ├── shared-models（数据契约）
    ├── .clinerules（硬约束）
    └── memory/（规则沉淀）
```

## 审查分层

| 层级 | 范围 | 审查方式 | 你的投入 |
|------|------|---------|---------|
| Tier 1 | 日常修复、配置、文档 | 自验 + 测试全绿 | 选择性看一眼 diff |
| Tier 2 | 架构调整、共享契约变更、API 重写 | 你审 diff + PRD | ~5 分钟 |
| Tier 3 | DB schema、安全凭证、回滚敏感的变更 | 你必须在场 | 一起 review |

## Review Checklist（审查时参考）

```
□ 安全检查：密钥/env 硬编码？SQL 注入？输入校验？
□ 架构合规：shared-models 契约被绕过？
□ 回归测试：bug fix 带测试了？新逻辑有覆盖？
□ 错误处理：异常正确处理？有 logging 或 re-raise？
□ 边界：空列表、None、超大输入时表现？
□ 文档同步：PRD/CHANGELOG 更新了？
□ 测试全绿：pytest / npm test 通过？
```

## 质量门禁

### Pre-commit
- shared-models 变更必须审查者批准
- 新增依赖须确认
- bug fix 附带回归测试

### Pre-merge
- 测试 100% 通过
- Tier 2/3 变更：审查者标记 approved
- PRD/CHANGELOG 已同步

### Pre-release
- 全链路集成测试通过
- 审查者最终确认

## 失败模式

| 场景 | 处理 |
|------|------|
| 需求含糊 | 我梳理成具体方案 → 你确认后再执行 |
| 测试失败 | 我修复 → 重新提交 |
| 我不确定 | 直接告诉你，不等 |
| 审查超时 | STATUS.yaml 标记 review_stalled |

## 状态跟踪

STATUS.yaml 记录当前在做的事：

```yaml
current: "当前任务描述"
status: "working | review | stuck | idle"
blocker: null
last_update: "2026-06-25T22:00:00+08:00"
```

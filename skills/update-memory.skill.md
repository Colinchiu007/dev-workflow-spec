---
name: update-memory
description: 会话结束时扫描重要信息并更新共享记忆文件（memory/*.md + MEMORY.md）
---

# Update Memory 技能说明

## 流程

### Phase 1: 扫描会话
- 用户偏好和反馈
- 项目决策和理由
- Bug 根因和解决方案
- 新功能/变更/进展

### Phase 2: 检查已有记忆
避免重复或冲突。

### Phase 3: 更新文件
- 更新已有文件：merge 新信息
- 创建新文件：`memory/<kebab-name>.md`
- 格式：type + Why + How to apply

### Phase 4: 更新 MEMORY.md 索引
- 格式：`- [名称](memory/文件名.md) — 一句话描述`
- 保持 200 行以内

### Phase 5: 报告
- 列出新增/更新/删除的文件

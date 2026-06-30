# 版本管理与发布流程

## 版本号策略

采用 [SemVer 2.0](https://semver.org/)：

```
主版本.次版本.修订号
  │      │      └── 修订号：向后兼容的 bug 修复
  │      └──────── 次版本：向后兼容的新功能
  └─────────────── 主版本：不兼容的 API/架构变更
```

### 版本号判断规则

| 变更类型 | 版本号示例 | 说明 |
|---------|-----------|------|
| 初始开发 | 0.1.0, 0.2.0 | 正式发布前，次版本递增即可 |
| 向后兼容 bug 修复 | 1.0.0 → 1.0.1 | 不改 API、不改契约 |
| 向后兼容新功能 | 1.0.0 → 1.1.0 | 新增 API、新增配置项 |
| 破坏性变更 | 1.0.0 → 2.0.0 | 改 shared-models、删 API、改数据格式 |

## CHANGELOG 规范

每个项目使用 `CHANGELOG.md`（见 `templates/project/CHANGELOG.md`）。

### 格式

```markdown
## [版本号] - 发布日期

### Added
- 新功能描述 (#PR)

### Changed
- 变更描述 (#PR)

### Fixed
- 修复描述 (#PR)

### Deprecated
- 即将废弃的功能

### Removed
- 已移除的功能

### Security
- 安全修复
```

### 编写原则

- 每条变更一行，使用现在时主动语态（"新增""修复""移除"，不是"已新增""已修复"）
- 关联 PR 号 `(#42)`，方便追溯
- Unreleased 章节保持最新，发布时改为对应版本号
- **PRD 同步变更必须在 CHANGELOG 中标注**

## 发布检查清单

### 发布前

- [ ] 所有测试通过（pytest / npm test）
- [ ] CHANGELOG.md 已更新
- [ ] PRD 已同步（如涉及功能变更）
- [ ] 版本号已更新
- [ ] `.clinerules` 无冲突
- [ ] shared-models 变更已获三组 ACK
- [ ] Code review 已完成（AI 自审 + 人工确认）
- [ ] MEMORY.md 已更新

### 发布中

- [ ] `git tag v<版本号>`
- [ ] `git push --tags`
- [ ] CI 通过
- [ ] 通知相关方

### 发布后

- [ ] 确认线上正常
- [ ] 记录发布到 MEMORY.md（可选）

## git tag 规范

```bash
# 标注 tag（带 message）
git tag -a v1.0.0 -m "Release v1.0.0: 初始版本"

# 推送 tag
git push origin v1.0.0
```

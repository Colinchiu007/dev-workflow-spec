---
name: improve-codebase-architecture
description: 扫描代码库找出架构深化机会，生成自包含 HTML 报告
---

# Improve Codebase Architecture — 架构深化

> 完整内容已安装为 Cowork skill。

## 何时使用

- "代码架构太差""重构""代码库熵太高"
- 定期架构健康度检查
- 新成员加入前做架构梳理

## 流程

1. 扫描代码库 → 识别 shallow 模块（仅 CRUD 无抽象）
2. 生成 HTML 架构报告
3. 建议深化方向
4. 可选：Grill 式深度追问

## 输出

- `architecture-review-<date>.html` — 自包含报告
- 报告中标注 shallow 模块、循环依赖、缺失抽象层

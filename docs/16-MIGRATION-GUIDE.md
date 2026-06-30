# 迁移指南：将 dev-workflow-spec 应用到现有项目

> 本文档面向已有代码的项目如何接入 dev-workflow-spec 规范体系。

## 适用场景

- 已有代码库但缺少开发规范文件
- 已有部分规范但零散不统一
- 多个项目之间规范不一致，需要统一基线

## 迁移步骤

### 第一步：初始化工作区根目录

在工作区根目录执行：

```bash
# 1. 复制全局约束文件
cp dev-workflow-spec/templates/global/.clinerules .clinerules
cp dev-workflow-spec/templates/global/core-rules.md .claude/rules/core-rules.md
cp dev-workflow-spec/templates/global/prompt-defense.md .claude/rules/prompt-defense.md
cp dev-workflow-spec/templates/global/COLLABORATION.md .claude/COLLABORATION.md

# 2. 修改 .clinerules 中的项目特定规则（架构红线、测试要求等）
# 编辑 .clinerules 补充项目特定约束

# 3. 安装 pre-commit hook（FUSE 截断保护）
cp dev-workflow-spec/.githooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### 第二步：逐个项目初始化

对每个子项目执行：

```bash
bash dev-workflow-spec/scripts/init-project.sh <项目目录>
```

这会生成 AGENTS.md、CLAUDE.md、PRD.md、CHANGELOG.md、.clinerules。

### 第三步：自定义 AGENTS.md

编辑 AGENTS.md，补充：
- 项目特定的测试命令和目录结构
- 特殊的架构约束
- 部署/CI 流程

### 第四步：接入 auto-exec 编排

```bash
# 1. 安装 auto-exec skill（通过 Cowork 或手动复制）
# 2. 准备 .plan/ 目录
mkdir .plan
cp dev-workflow-spec/templates/plan/* .plan/
# 3. 创建 scheduled task（在对话中通过 /auto-exec 触发）
```

### 第五步：接入记忆系统

```bash
# 1. 创建记忆目录
mkdir -p memory
# 2. 初始化 MEMORY.md
echo "# 记忆索引" > MEMORY.md
# 3. 安装 update-memory skill（会话结束时自动调用）
```

## 落地检查清单

- [ ] `.clinerules` 已配置
- [ ] `.claude/rules/core-rules.md` 已配置
- [ ] `.claude/rules/prompt-defense.md` 已配置
- [ ] 每个子项目有 AGENTS.md
- [ ] 每个子项目有 PRD.md（如果涉及产品功能）
- [ ] 每个子项目有 CHANGELOG.md
- [ ] pre-commit hook 已安装
- [ ] memory/ 目录已就绪
- [ ] Cowork skills 已安装（auto-exec, self-check-loop, diagnosing-bugs, handoff 等）
- [ ] CLAUDE.local.md 已创建（本地私密配置）

## 常见问题

### Q: 已有 CLAUDE.md，需要替换吗？
不需要。init-project.sh 只在目标文件不存在时创建。已有文件保留，手动合并。

### Q: 项目已有自己的 PRD 格式，需要改吗？
不需要。PRD.md 是模板，可以自行调整结构，只要内容覆盖功能描述、验收标准即可。

### Q: FUSE 文件系统如何保护？
安装 pre-commit hook 后，每次 `git commit` 自动验证 staged 文件的语法完整性。绕过 hook（`--no-verify`）需要人工确认。

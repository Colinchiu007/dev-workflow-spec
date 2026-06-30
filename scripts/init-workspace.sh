#!/bin/bash
# init-workspace.sh — 初始化项目工作区的全局配置
# 用法: bash init-workspace.sh <工作区根目录>
#
# 将 dev-workflow-spec 的全局模板分发到目标工作区根目录

set -euo pipefail

SPEC_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WORKSPACE="${1:-$(pwd)}"

echo ">>> 初始化工作区: $WORKSPACE"
echo ">>> 模板来源: $SPEC_DIR"

# 创建必要的目录结构
mkdir -p "$WORKSPACE/.claude/rules"
mkdir -p "$WORKSPACE/.cowork/design-notes"
mkdir -p "$WORKSPACE/.cowork/checkpoints"
mkdir -p "$WORKSPACE/.cowork/questions"
mkdir -p "$WORKSPACE/.cowork/reviews"
mkdir -p "$WORKSPACE/.plan/templates"
mkdir -p "$WORKSPACE/.plan/knowledge"
mkdir -p "$WORKSPACE/scripts"
mkdir -p "$WORKSPACE/.githooks"
mkdir -p "$WORKSPACE/memory"

# 分发全局约束文件
echo ">>> 分发全局约束文件..."
cp "$SPEC_DIR/templates/global/.clinerules" "$WORKSPACE/.clinerrules" 2>/dev/null || true
cp "$SPEC_DIR/templates/global/core-rules.md" "$WORKSPACE/.claude/rules/core-rules.md"
cp "$SPEC_DIR/templates/global/prompt-defense.md" "$WORKSPACE/.claude/rules/prompt-defense.md"
cp "$SPEC_DIR/templates/global/COLLABORATION.md" "$WORKSPACE/COLLABORATION.md" 2>/dev/null || true

# 分发协作协议
echo ">>> 分发协作协议..."
cp "$SPEC_DIR/templates/global/PROTOCOL.yaml" "$WORKSPACE/.cowork/PROTOCOL.yaml" 2>/dev/null || true
cp "$SPEC_DIR/templates/global/DESIGN_NOTE_TEMPLATE.md" "$WORKSPACE/.cowork/DESIGN_NOTE_TEMPLATE.md" 2>/dev/null || true
cp "$SPEC_DIR/templates/plan/task_plan.md" "$WORKSPACE/.plan/templates/task_plan.tmpl.md" 2>/dev/null || true
cp "$SPEC_DIR/templates/plan/progress.md" "$WORKSPACE/.plan/templates/progress.tmpl.md" 2>/dev/null || true

# 分发脚本
echo ">>> 分发工具脚本..."
cp "$SPEC_DIR/scripts/safe-write.sh" "$WORKSPACE/scripts/safe-write.sh" 2>/dev/null || true
chmod +x "$WORKSPACE/scripts/safe-write.sh" 2>/dev/null || true

# 分发 Git 钩子
echo ">>> 分发 Git 钩子..."
cp "$SPEC_DIR/.githooks/pre-commit" "$WORKSPACE/.githooks/pre-commit" 2>/dev/null || true
chmod +x "$WORKSPACE/.githooks/pre-commit" 2>/dev/null || true

# 初始化 MEMORY.md
if [ ! -f "$WORKSPACE/MEMORY.md" ]; then
    echo "# MEMORY.md — 共享记忆索引" > "$WORKSPACE/MEMORY.md"
    echo "" >> "$WORKSPACE/MEMORY.md"
    echo "> 初始化的共享记忆系统" >> "$WORKSPACE/MEMORY.md"
fi

echo ""
echo ">>> 完成！工作区初始化成功。"
echo "下一步：为每个子项目运行 init-project.sh"

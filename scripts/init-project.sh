#!/bin/bash
# init-project.sh — 为新项目添加规范文件
# 用法: bash init-project.sh <项目目录>
#
# 在项目目录中生成 AGENTS.md、CLAUDE.md、PRD.md、CHANGELOG.md、.clinerules

set -euo pipefail

SPEC_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="${1:?用法: $0 <项目目录>}"
PROJECT_NAME="$(basename "$PROJECT_DIR")"

echo ">>> 初始化项目: $PROJECT_NAME ($PROJECT_DIR)"

# AGENTS.md
if [ ! -f "$PROJECT_DIR/AGENTS.md" ]; then
    cp "$SPEC_DIR/templates/project/AGENTS.md" "$PROJECT_DIR/AGENTS.md"
    echo "  + AGENTS.md"
fi

# CLAUDE.md
if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
    # 替换项目名称占位符
    sed "s/\[项目名称\]/$PROJECT_NAME/g" "$SPEC_DIR/templates/project/CLAUDE.md" > "$PROJECT_DIR/CLAUDE.md"
    echo "  + CLAUDE.md"
fi

# PRD.md
if [ ! -f "$PROJECT_DIR/docs/PRD.md" ] && [ ! -f "$PROJECT_DIR/PRD.md" ]; then
    mkdir -p "$PROJECT_DIR/docs"
    cp "$SPEC_DIR/templates/project/PRD.md" "$PROJECT_DIR/docs/PRD.md"
    echo "  + docs/PRD.md"
fi

# CHANGELOG.md
if [ ! -f "$PROJECT_DIR/CHANGELOG.md" ]; then
    cp "$SPEC_DIR/templates/project/CHANGELOG.md" "$PROJECT_DIR/CHANGELOG.md"
    echo "  + CHANGELOG.md"
fi

# .clinerules
if [ ! -f "$PROJECT_DIR/.clinerules" ]; then
    cp "$SPEC_DIR/templates/project/.clinerules" "$PROJECT_DIR/.clinerules"
    echo "  + .clinerules"
fi

echo ""
echo ">>> 项目 $PROJECT_NAME 初始化完成。"
echo "编辑 AGENTS.md 和 .clinerules 添加项目特定的开发规范和约束。"

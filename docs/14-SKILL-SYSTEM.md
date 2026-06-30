# Skill 系统 — 可复用指令集

## 是什么

Skill 是预先定义好的一组指令，让 AI 在特定场景下自动执行标准流程。相当于"可复用的 AI 技能包"。

## 当前体系中的核心 Skills

| Skill | 触发 | 用途 |
|-------|------|------|
| auto-exec | 多步骤复杂任务 | 跨会话执行编排 |
| self-check-loop | 单次中等复杂度任务 | 轻量自检迭代 |
| update-memory | 会话结束 / 重要信息 | 记忆系统维护 |
| diagnosing-bugs | 难以复现的 bug | 6 阶段调试循环 |
| brainstorming | 创意/新功能前 | 需求探索与澄清 |
| code-review-and-quality | PR/审查前 | 多维度代码审查 |
| git-workflow-and-versioning | Git 操作 | 版本管理约定 |
| api-and-interface-design | API 设计 | 接口设计指南 |
| security-and-hardening | 安全相关 | 安全加固 |
| testing-anti-patterns | 测试编写 | 测试反模式参考 |
| handoff | 上下文耗尽/切换 | 会话压缩交接 |
| improve-codebase-architecture | 架构问题 | 架构扫描 + 深化 |

## Skill 激活机制

通过 `.claude/skills/skill-rules.json` 配置：

```json
{
    "skills": {
        "debugging-and-error-recovery": {
            "type": "domain",
            "enforcement": "suggest",
            "priority": "high",
            "promptTriggers": {
                "keywords": ["bug", "error", "debug", "调试"],
                "intentPatterns": ["(fix|debug).*?(bug|error)"]
            }
        }
    }
}
```

### 触发字段说明

| 字段 | 含义 |
|------|------|
| `type` | domain / guardrail — 功能型还是门禁型 |
| `enforcement` | suggest / required — 建议还是强制 |
| `priority` | 匹配优先级 |
| `promptTriggers.keywords` | 关键字触发 |
| `promptTriggers.intentPatterns` | 正则意图匹配 |

## Skill 文件结构

```
skill-name.skill/       ← .skill 扩展名（zip 归档）
└── SKILL.md            ← 主指令文件
    └── frontmatter: name, description（触发描述）
    └── body: 使用说明、流程、示例
```

## 安装 Skill

```bash
# 通过 Cowork CLI
mcp__cowork__save_skill name="my-skill" description="..." content="..."

# 通过 .skill 文件分享
# 打包：zip -r my-skill.skill my-skill/
# 安装：通过 present_files 呈现，用户点击安装
```

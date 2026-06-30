# 所有组件的协作关系图

## 完整架构

```mermaid
flowchart TB
    subgraph L1["L1 约束层"]
        CR[.clinerules<br/>机器可读硬约束]
        COR[core-rules.md<br/>人类可读行为规则]
        PD[prompt-defense.md<br/>安全基线]
    end

    subgraph L2["L2 流程层"]
        AG[AGENTS.md<br/>7 阶段流程]
        AE[auto-exec<br/>跨会话编排]
        SCL[self-check-loop<br/>轻量自检]
        TDD[TDD<br/>测试驱动开发]
    end

    subgraph L3["L3 协议层"]
        PLAN[.plan/ 协议<br/>task_plan + progress]
        CW[.cowork/ 协议<br/>PROTOCOL + STATUS]
        COL[COLLABORATION.md<br/>审查门禁]
        DN[Design Note 模板]
    end

    subgraph L4["L4 基础设施"]
        MEM[共享记忆<br/>MEMORY.md + memory/*.md]
        SK[Skills<br/>可复用指令集]
        SC[scripts/<br/>工具链]
        GH[.githooks/<br/>Git 钩子]
        SR[skill-rules.json<br/>Skill 激活规则]
    end

    subgraph EXT["外部"]
        AEM[auto-exec-mechanism<br/>工具实现]
        OA[oh-my-openagent<br/>协议灵感]
    end

    %% 层间关系
    L1 -->|约束| L2
    L2 -->|使用| L3
    L3 -->|调用| L4
    L2 -.->|参考| EXT

    %% 流程层内部
    AG -->|阶段4-7 接管| AE
    AE -->|子任务| TDD
    AE -->|子任务| SCL

    %% 关键联动
    CR -.->|每次代码生成前| AG
    COR -.->|会话启动| AE
    PLAN -->|执行载体| AE
    COL -->|审查依据| AG
    MEM -->|跨会话知识| AE

    style L1 fill:#ffe0e0,stroke:#cc0000
    style L2 fill:#e0ffe0,stroke:#00cc00
    style L3 fill:#e0e0ff,stroke:#0000cc
    style L4 fill:#ffffe0,stroke:#cccc00
```

## 请求处理流程

```mermaid
sequenceDiagram
    participant U as 你
    participant IG as Intent Gate
    participant L1 as 约束层
    participant L2 as 流程层
    participant L3 as 协议层
    participant L4 as 基础设施

    U->>IG: 提出需求
    IG->>L1: 加载约束

    alt 简单查询
        IG->>U: 直接回答
    else 明确指令 <30min
        IG->>L2: 执行
        L2->>L4: 调 scripts/tests
        L2->>L3: 更新 .plan/ 或 docs
        L2->>U: 交付
    else 复杂任务 >30min
        IG->>L2: 启动 auto-exec
        L2->>L3: 写入 task_plan.md
        L2->>L3: 创建 scheduled task
        loop 跨会话执行
            L2->>L4: 执行子任务
            L2->>L3: 更新 progress.md
            L2->>L3: 停滞检测
        end
        L2->>U: 通知完成
    end
```

## 文件归属矩阵

| 文件 | 所属仓库 | 是否强制 | 说明 |
|------|---------|---------|------|
| `.clinerules` | dev-workflow-spec | ✅ | 每个项目工区分发一份 |
| `core-rules.md` | dev-workflow-spec | ✅ | 每个项目工区分发一份 |
| `prompt-defense.md` | dev-workflow-spec | ✅ | 每个项目工区分发一份 |
| `COLLABORATION.md` | dev-workflow-spec | ✅ | 每个项目工区分发一份 |
| `AGENTS.md` | 子项目 | ✅ | 每个子项目独立维护 |
| `CLAUDE.md` | 子项目 | ✅ | 每个子项目独立维护 |
| `PRD.md` | 子项目 | ✅ | 每个子项目独立维护 |
| `CHANGELOG.md` | 子项目 | ✅ | 每个子项目独立维护 |
| `MEMORY.md` | dev-workflow-spec | 推荐 | 项目工区分发模板 |
| `.cowork/` | dev-workflow-spec | 推荐 | 项目工区分发 |
| `.plan/` | dev-workflow-spec | 按需 | auto-exec 时使用 |
| `feature_gates.yaml` | dev-workflow-spec | 按需 | 需要功能开关时使用 |
| Skill | Cowork 系统 | 按需 | 通过 Cowork 安装 |

## 关键决策记录

| 决策 | 理由 | 日期 |
|------|------|------|
| 双角色模型代替多 Agent | 多 Agent 从未跑通，单线执行效率更高 | 2026-06-25 |
| auto-exec 强制 | >30min/≥3步骤必须编排，否则上下文溢出 | 2026-06-30 |
| 紧急 bug 分级（止血/排查） | 防止紧急修复也被 auto-exec 卡住 | 2026-06-30 |
| 8 轮 self-check 上限 | 超过说明标准太高或任务太模糊 | 2026-06-30 |
| FUSE 禁止 Write/Edit | 已验证多次静默截断 | 2026-06-27 |

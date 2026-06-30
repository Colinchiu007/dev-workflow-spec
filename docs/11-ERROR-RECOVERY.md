# 错误恢复链

## 三层 API 恢复路径

| 场景 | 对应 | 恢复策略 | 重试上限 |
|------|------|---------|---------|
| `stop_reason: "max_tokens"` | 输出截断 | escalate: 8K → 64K（首次），后续用 continuation prompt | 3 次 |
| `prompt_too_long` | context 溢出 | reactive compact: 裁剪到最近 5 条消息 | 1 次 |
| 429/529 | 限速/过载 | 指数退避 + jitter，529 连续 3 次切换 fallback 模型 | 按退避 |

## 指数退避算法

```
min(500ms * 2^attempt, 32s) + random(0, base * 0.25)
```

- attempt=0: ~500ms
- attempt=1: ~1s
- attempt=2: ~2s
- attempt=3: ~4s
- attempt=4: ~8s
- attempt=5: ~16s
- attempt=6: ~32s (max)

## RecoveryState 跟踪

```python
RecoveryState(
    has_escalated: bool,
    recovery_count: int,
    consecutive_529: int,
    has_attempted_reactive_compact: bool,
    current_model: str
)
```

每步记录到 progress.md 的决策日志。

## 工具执行恢复

Manus 风格 — 在 API 恢复之后的工具级恢复：

1. 工具执行失败 → 先验证工具名和参数是否正确
2. 根据错误信息尝试修复参数；如果不行，换替代方法
3. 多次失败 → 记录失败原因，标记任务为 blocked，通知用户
4. 不重复尝试同一个失败操作（与 consecutive_529 类似但独立计数）

## 停滞检测（Ralph Wiggum Loop 防范）

```
轮次 1: 尝试方案 A → 失败
轮次 2: 尝试方案 B → 失败
轮次 3: 尝试方案 C → 失败
       → 触发停滞检测！
       → 记录所有已尝试方案
       → 标记任务为 stuck
       → 切换到下一个可执行任务
```

连续 3 轮对同一个问题尝试不同方案但未解决 → 标记 stuck。

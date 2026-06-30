# FUSE 文件系统防护

## 背景

在 FUSE 挂载目录中直接使用 Write/Edit 工具会导致文件静默截断（null 字节污染或内容丢失），已反复验证。

## 硬门禁

写入前决策树：

```
文件路径在 D:\Data\projects\ 下？
  ├─ 是 → 禁止 Write/Edit 工具
  │      正确方法：bash Python heredoc（python3 << 'PYEOF'）
  │      写入后立即验证：
  │        JS:   node --check <文件路径>
  │        Python: python3 -c "import ast; ast.parse(open('路径').read())"
  │      验证不通过 = 写入失败 → 用 heredoc 重写
  └─ 否 → 可以使用 Write/Edit 工具
```

## 正确写入方法

### A：bash Python heredoc（推荐，大文件/精确内容）

```bash
python3 << 'PYEOF'
content = """...你的文件内容..."""
path = "/mnt/path/to/file"
with open(path, 'w', newline='\n') as f:
    f.write(content)
PYEOF
```

### B：safe-write 辅助脚本（简短内容）

```bash
echo "content" | scripts/safe-write.sh <filepath> --py
echo "content" | scripts/safe-write.sh <filepath> --js
```

### C：python3 -c 单行（非常简短）

```bash
python3 -c "open('path','w').write('content')"
```

## 写入后强制验证

```bash
# Python 文件
python3 -c "import ast; ast.parse(open('file.py').read())"
# JavaScript 文件
node --check file.js
```

静默通过即 OK。否则视为写入失败，须用 heredoc 重写。

## 已知的 FUSE 异常模式

- 文件在 `ls -la` 中显示但 `cat`/`head`/Python `open()` 返回 ENOENT
- 文件非零大小但内容全空（null 字节）
- git index 损坏（`bad config line 1`）
- 连续编辑同一文件触发静默截断

## 教训沉淀

详见 `memory/lesson-fuse-file-corruption.md` 和 `memory/lesson-fuse-edit-tool.md`。

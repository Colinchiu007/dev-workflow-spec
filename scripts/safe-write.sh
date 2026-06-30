#!/usr/bin/env bash
# safe-write — FUSE-safe file write with syntax validation
#
# Usage:
#   safe-write <filepath> [--py|--js]   (reads content from stdin)
#   safe-write <filepath> --py --content "..."  (inline content)
#
# Writes via Python to avoid FUSE null-byte truncation.
# Validates syntax after write.

set -eo pipefail

FILE="${1:?Usage: safe-write <filepath> [--py|--js]}"
shift

LANG=""
CONTENT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --py) LANG="py" ;;
    --js) LANG="js" ;;
    --content) shift; CONTENT="$1" ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

if [ -n "$CONTENT" ]; then
  # Inline content
  python3 -c "
import sys
path = '$FILE'
content = '''$CONTENT'''
with open(path, 'w', newline='\n') as f:
    f.write(content)
print(f'Written {len(content.encode(\"utf-8\"))} bytes to {path}')
"
else
  # Stdin content
  python3 -c "
import sys
path = '$FILE'
content = sys.stdin.read()
with open(path, 'w', newline='\n') as f:
    f.write(content)
print(f'Written {len(content.encode(\"utf-8\"))} bytes to {path}')
"
fi

# Validation
case "$LANG" in
  py)
    python3 -c "
import ast
with open('$FILE') as f:
    ast.parse(f.read())
print('AST: OK')
" ;;
  js)
    node --check "$FILE" && echo "JS: OK" ;;
esac

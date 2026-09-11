#!/usr/bin/env bash
# hook-protect-test-files.sh —— 修复类任务中阻止编辑测试文件（Stage 4 铁律的硬约束）
# 机制：PreToolUse hook；block 以 exit 2 退出，stderr 文本回灌给 agent 自纠。
# 注册：见 scripts/settings-hooks.example.json
# 说明：从 stdin 读工具调用 JSON；用分支名/任务标注判断是否修复任务，按你的约定调整 FIX_PATTERN。
set -euo pipefail
input=$(cat)
tool=$(printf '%s' "$input" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
path=$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//') || true

case "$tool" in Edit|Write|MultiEdit|NotebookEdit) ;; *) exit 0 ;; esac
[ -z "${path:-}" ] && exit 0

# 修复任务判定：分支名以 fix/ 开头，或任务标注含 "fix:"（改成你团队的约定）
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
case "$branch" in fix/*) is_fix=1 ;; *) is_fix=0 ;; esac
[ "$is_fix" -eq 1 ] || exit 0

case "$path" in
  *test*|*spec*|*__tests__*|*e2e*)
    echo "BLOCK: 修复任务($branch)中禁止编辑测试文件：$path" >&2
    echo "本任务纪律是 failing test first——先写复现测试并看着它失败的那一步已经过去；" >&2
    echo "现在只允许修改实现。若确需改测试（如测试本身有错）：停下，向用户请示（可回答 Go/No-go）。" >&2
    exit 2
    ;;
esac
exit 0

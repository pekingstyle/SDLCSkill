#!/usr/bin/env bash
# hook-plan-sync.sh —— plan 同步护栏：实现文件变更而 plan.md 不在变更集时提醒（Stage 3 铁律 6）
# 机制：PreToolUse hook（Edit/Write 前触发）；提醒态（非阻断），团队可改为阻断。
# 注册：见 scripts/settings-hooks.example.json
set -euo pipefail
input=$(cat)
tool=$(printf '%s' "$input" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
case "$tool" in Edit|Write|MultiEdit) ;; *) exit 0 ;; esac

# 已在改 plan.md 本身 → 无事
path=$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//') || true
case "${path:-}" in *plan.md) exit 0 ;; esac

# 当前分支是否存在 plan.md（变更目录约定：intent/<日期>-<slug>/plan.md 或根 plan.md）
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
plan=$(ls intent/*/plan.md plan.md 2>/dev/null | head -1 || true)

if [ -n "$plan" ] && [ -f "$plan" ]; then
  # 粗检：plan 状态是否 approved；未批准就写实现 = 跳闸门
  if grep -qi 'status:[[:space:]]*proposed' "$plan"; then
    echo "BLOCK: $plan 仍是 proposed——闸门未过，先盘问计划并请工程师批准（改 status 为 approved 并 commit），再写实现代码。" >&2
    exit 2
  fi
  echo "NOTE: 实现偏离 $plan 时，同一 commit 内更新它（审计轨迹要求）。本次编辑后请自检。" >&2
fi
exit 0

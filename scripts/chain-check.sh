#!/usr/bin/env bash
# chain-check.sh —— 工件链完整性检查（commit 前跑一次）
# 用法: ./chain-check.sh <change-dir>   例: ./chain-check.sh intent/2026-09-12-claims-status
# 退出码: 0=通过  1=链断裂（缺上游引用或空文件）
# 原则: 每个下游工件头部必须引用上游（from intent.md <日期/SHA>）——引用是审计轨迹可执行的地方。
set -u

dir="${1:-.}"
fail=0

has_file() { [ -f "$dir/$1" ]; }

check_link() { # $1=文件名 $2=上游名 $3=是否必须
  if ! has_file "$1"; then return 0; fi
  if ! grep -qi "from ${2}" "$dir/$1"; then
    if [ "$3" = "must" ]; then
      echo "FAIL: $dir/$1 存在但头部未引用上游 ${2}（应有 'from ${2} <日期/SHA>'）"; fail=1
    else
      echo "WARN: $dir/$1 未引用 ${2}（若无该上游可忽略）"
    fi
  else
    echo "OK:   $dir/$1 → ${2}"
  fi
}

check_nonempty() {
  if has_file "$1" && [ ! -s "$dir/$1" ]; then
    echo "FAIL: $dir/$1 是空文件"; fail=1
  fi
}

echo "== 工件链检查: $dir =="

if ! has_file intent.md; then
  echo "WARN: 无 intent.md（热修场景可接受；收尾时须补写 intent 保持链不断）"
else
  echo "OK:   intent.md 存在（链头）"
fi
check_nonempty intent.md; check_nonempty spec.md; check_nonempty plan.md

check_link spec.md "intent.md" "opt"     # spec 只在有 intent 时要求引用
check_link plan.md "intent.md"  "must"   # plan 必须能溯源到链头
check_link plan.md "spec.md"    "opt"

if [ "$fail" -eq 0 ]; then echo "== PASS =="; else echo "== FAIL：请修复后再 commit =="; fi
exit "$fail"

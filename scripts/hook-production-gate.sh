#!/usr/bin/env bash
# hook-production-gate.sh —— 生产闸门：agent does everything up to the production gate and nothing past it
# 机制：PreToolUse hook，拦一切指向生产环境的命令/部署，除非存在人类当日签核工件。
# 注册：见 scripts/settings-hooks.example.json；受监管环境请加配平台受管配置（概念对照见 references/bindings.md 与 governance.md）。
set -euo pipefail
input=$(cat)

case "$input" in
  *prod*|*production*|*"kubectl apply"*|*deploy*)
    # 人类签核工件：.approvals/YYYY-MM-DD-prod-deploy.ok（内容含批准人）
    if [ -f ".approvals/$(date +%F)-prod-deploy.ok" ]; then
      exit 0
    fi
    echo "BLOCK: 生产环境操作被闸门拦截（本会话未发现人类签核）。" >&2
    echo "两条合法路径：" >&2
    echo "  1) 请人类在 .approvals/$(date +%F)-prod-deploy.ok 写入批准人与范围后重试；" >&2
    echo "  2) 走 PR 评审 + 分支保护，由流水线部署。" >&2
    echo "到闸门为止的一切你都可以做；过了闸门的事不属于你。" >&2
    exit 2
    ;;
esac
exit 0

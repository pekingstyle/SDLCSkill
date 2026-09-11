<!-- Stage 6 复盘产出，版本化于 lessons/：写给未来调查的人/agent；写完必做——补 eval、必要时写回 intent -->
# Lessons: <事故名称>（<YYYY-MM>）

- incident: <工单/频道链接>        # 频道即审计轨迹：请求、诊断、授权、修复全在里面
- date: YYYY-MM-DD
- band: <被击穿的控制带，见 bands.yaml>
- severity: S1-S4
- duration: 发现 → 恢复 耗时

## What happened
时间线（部署/告警/诊断/授权/恢复），引用频道关键消息。

## Root cause
一层不够就再问一层（5 Whys）。

## What fixed it
修复 PR / 执行的 runbook；由谁授权（人，不是 agent 自批）。

## What we learned
- 对系统：<结构性认知，如"缓存 key 变更必须走 tenant 维度回归">
- 对流程：<闸门/检测哪里失灵或立功>

## Actions
- [x] eval: 新增 <eval id>（复现场景 + 当时缺失的行为检查）——修复发布到生产时必须已完成
- [ ] intent: <若引出更大改动，写回 intent/<日期>-<slug>/intent.md 的链接>
- [ ] 项目记忆(AGENTS.md)/skill/hook: <同类错误第二次 → 修正进配置>

---

## 填写示例（2026-06 checkout 缓存事故，节选）

# Lessons: checkout cache key 丢失 tenant id（2026-06）

- incident: #inc-checkout（22:04–22:12）
- band: http_5xx_rate 3σ
- severity: S2
- duration: 8 分钟（告警 → 授权回滚 → 带内）

## Root cause
21:40 部署把缓存 key 从 `claim:{id}` 改为 `claim:{id}:{step}`，序列化时丢掉 tenant 维度，
跨租户命中同一缓存条目 → 5xx 攀升。

## What fixed it
回滚 21:40 部署（runbook: rollback-last-deploy，当日早在 staging 演练过；授权：R. Mehta "Go"）。

## What we learned
- 系统：缓存 key 变更是跨租户安全敏感变更，必须带 tenant 维度测试。
- 流程：2σ→3σ 间隔仅 3 分钟，检测有效；授权请示（"shall I run it?"）一分钟内获批，闸门没有成为拖累。

## Actions
- [x] eval: eval-037（缓存 key 变更后跨租户请求不得命中同一条目）
- [x] AGENTS.md: 缓存 key 构造规范 + tenant 维度强制项

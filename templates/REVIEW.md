<!-- Stage 5 产出，置于 PR 内：passes 固定、分级设上限、不表扬、≤400 词（中文≤600字）、必含 diff-vs-plan；agent 不得自批 -->
# REVIEW: PR #<编号> — <标题>（from plan.md <日期>）

- reviewer: <agent 身份>（人的批准在分支保护/code owner 环节，不由 agent 出具）
- verdict: approve | request-changes
- diff vs plan.md: 一致 | 偏差如下（<逐条>；对应 commit 是否同步更新了 plan.md？）

## Bugs pass
[Important] <会在运行中造成错误行为的问题；上限 N 条>
[Nit] <风格/小改进；上限 M 条；没有就删掉本节，不凑数>

## Security pass
对照 secure-api 等政策逐项：输入校验 / 输出编码 / 每路由显式鉴权（默认拒绝）/ 速率限制 / 无硬编码密钥。

## Compliance pass
对照 spec 头部所列政策的适用条款；引用政策版本。

## Findings（若为作者方视角）
- [ ] <finding 1> → 修复于 commit <sha>
- [ ] <finding 2> → 不接受，理由：<…>

---

## 填写示例（claims status PR #142，节选）

# REVIEW: PR #142 — claims status page（from plan.md 2026-06-08）

- reviewer: sdlc-reviewer（agent）
- verdict: request-changes
- diff vs plan.md: 偏差 1 处——缓存实现用了内存 Map 而非 plan 的 60s TTL 代理缓存；
  plan.md 已在同一 commit a1b2c3 更新 ✓

## Bugs pass
[Important] claims-proxy 对理赔 API 的 5xx 未做重试/熔断，理赔系统抖动时状态页整页 500。
[Nit] `claimsStatus` 类型可用 discriminated union 表达状态机。

## Security pass
输入校验 ✓；鉴权：越权用例 403 ✓；限流 60/min/user ✓；无硬编码密钥 ✓（密钥走受管存储）。

## Compliance pass
备注不可见裁决已落实：对外仅输出"下一步"动作描述 ✓（compliance-claims@2026-05）。

## Findings
- [ ] 熔断修复于 commit 9d8e7f
- [ ] union 类型：本轮不做，理由：改动面扩大到 3 个文件，超出本 plan 范围。

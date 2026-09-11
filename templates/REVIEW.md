<!-- Stage 5 产出，置于 PR 内：由独立评审实例出具（非作者会话）；passes 固定、每 pass 显式作答禁止留空、分级设上限、不表扬、≤400 词（中文≤600字）、必含 diff-vs-plan；agent 不得自批 -->
# REVIEW: PR #<编号> — <标题>（from plan.md <日期>）

- reviewer: <评审实例身份——与作者实例不同上下文；人的批准在分支保护/code owner 环节，不由 agent 出具>
- 评审输入: diff + plan.md + spec.md + 政策清单（不含作者对话与自我评价）
- verdict: approve | request-changes
- diff vs plan.md: 一致 | 偏差如下（<逐条>；对应 commit 是否同步更新了 plan.md？）

## Bugs pass
- 结论: 发现 <N> 项 / 未发现（二选一，禁止留空）
- 发现: [Important] <问题 + 证据链接>；[Nit] <…>（Important 设上限，无则写"无"，不凑数）
- 检查手段: <实际做了什么——如"对照 plan 逐文件读 diff；跑了哪些用例">

## Security pass
- 结论: 发现 <N> 项 / 未发现（二选一，禁止留空）
- 发现: <问题 + 证据链接>
- 检查手段: 输入校验 / 输出编码 / 每路由显式鉴权（默认拒绝）/ 速率限制 / 无硬编码密钥——逐项核对结果

## Compliance pass
- 结论: 发现 <N> 项 / 未发现（二选一，禁止留空）
- 发现: <问题 + 政策条款>
- 检查手段: 对照 spec 头部所列政策版本逐条适用条款（引用版本号）

## 作者方回应（作者实例填写；无权修改上方评审结论）
- [ ] <finding 1> → 修复于 commit <sha>
- [ ] <finding 2> → 不接受，理由：<…>

---

## 填写示例（claims status PR #142，节选）

# REVIEW: PR #142 — claims status page（from plan.md 2026-06-08）

- reviewer: review-ci（CI 非交互评审实例，非作者会话）
- 评审输入: PR diff + plan.md@2026-06-08 + spec.md@2026-06-06 + secure-api@2026-08-01
- verdict: request-changes
- diff vs plan.md: 偏差 1 处——缓存实现用了内存 Map 而非 plan 的 60s TTL 代理缓存；
  plan.md 已在同一 commit a1b2c3 更新 ✓

## Bugs pass
- 结论: 发现 2 项
- 发现: [Important] claims-proxy 对理赔 API 的 5xx 未做重试/熔断，理赔系统抖动时状态页整页
  500（证据：src/claims-proxy.ts 未含重试逻辑）；[Nit] `claimsStatus` 类型可用
  discriminated union 表达状态机
- 检查手段: 对照 plan 逐文件读 diff；本地跑 npm test -- claims（12 用例全绿）

## Security pass
- 结论: 未发现
- 检查手段: 输入校验 ✓；鉴权——越权用例 403 ✓；限流 60/min/user ✓；无硬编码密钥 ✓
  （密钥走受管存储）

## Compliance pass
- 结论: 未发现
- 检查手段: 备注不可见裁决已落实——对外仅输出"下一步"动作描述 ✓（compliance-claims@2026-05）

## 作者方回应（作者实例填写；无权修改评审结论）
- [ ] 熔断缺失 → 修复于 commit 9d8e7f
- [ ] union 类型 → 本轮不做：改动面扩大到 3 个文件，超出本 plan 范围。

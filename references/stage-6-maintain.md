# Stage 6 — Maintain：闭环——生产信号变成下一份 intent.md

**检测保持确定性**（控制带脚本里没有模型）；诊断与修复是 agent 在闸门后的工作。人 triage 和评审工作，而不再从零启动它。

## 执行步骤
1. 选**一个**有稳定滚动基线的指标（CI 失败率 / 部署后 5xx / PR 周期时长），跑通再加。
2. 检测脚本：滚动窗口均值+标准差（Western Electric 规则）；控制带落 `templates/bands.yaml`：1σ log / 2σ 只读诊断 / 3σ 仅 gated 提议（修复 PR 或预批准 runbook）。
3. 控制带击穿（2σ 起）才调 agent；诊断**只读**：对比错误签名与部署 diff，查日志与指标。
4. 修复走两条 gated 路：开 PR 过评审闸门，或触发预批准 runbook（如 staging 演练过的回滚）。请示格式："原因像是 X；回滚今天早在 staging 演练过。要我执行吗？"
5. 事故记录 + 诊断 → **新 intent.md** 进 Stage 1，环闭合。
6. 修复发布到生产时补一条 eval（回归免疫）；post-mortem 落 `templates/lessons.md` 结构、存 `lessons/`，未来调查可读。
7. 其他渠道进来的工作（工单/频道@）：agent 以自己身份做 first responder；**频道即审计轨迹**（请求/诊断/授权/修复全留痕）；小而有界 → PR 过闸门，更大 → 新 intent——环开始自我供血。
8. 定期安全扫描（依赖漏洞/秘密泄漏/配置漂移）：扫描器确定性，findings 同样走链。

## 闸门（出）
新 intent 被 triage/接受 → 回 Stage 1。

## 本阶段禁令
检测脚本调模型；绕过评审闸门"直接修"；修复上线不补 eval；post-mortem 不入库。

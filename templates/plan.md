<!-- Stage 3 产出：批准后才写码；盘问到"没见过对话的工程师也能照此实现"；偏离时同一 commit 更新 -->
# Plan: <名称>（from intent.md <日期>；依据 spec.md <日期/SHA>）

- date: YYYY-MM-DD
- status: proposed | approved   ← 批准 = 工程师改 status 并 commit；此后才允许写实现代码

## Files that change
逐个列路径（新建的标注 NEW）。**路径必须真实存在或明确标注新建**。

## Order of work
步骤序列，每步一个可验证的完成标志；标注最险的一步。

## Tests that prove it
哪些测试证明改动达标（对应 spec 的 Acceptance criteria）。

## Risks
盘问三连的答案：这个改动可能破坏什么？最险的一步与对策？放弃了哪些备选方案、为什么？

---

## 填写示例（claims status self-service，节选）

# Plan: claims status self-service（from intent.md 2026-06-02；依据 spec.md 2026-06-06）

- status: approved（批准人：实现工程师，2026-06-08）

## Files that change
- NEW portal/services/claims-proxy.ts        ← 理赔系统只读代理
- NEW portal/routes/claims-status.ts         ← 页面路由 + 鉴权过滤
- portal/middleware/rate-limit.ts            ← 挂 60 req/min/user
- NEW portal/__tests__/claims-status.e2e.ts  ← 含 403 越权用例

## Order of work
1. claims-proxy + 单测（mock 理赔 API）
2. 路由 + 鉴权过滤 + 越权用例          ← 最险：鉴权过滤条件写错 = 跨客户泄漏
3. 限流中间件接入
4. 前端页面对齐品牌 mock，截图 diff

## Tests that prove it
- npm test -- claims（单测 + e2e 全绿）
- 越权用例：他人 token 请求他人理赔 ID → 403
- 截图 diff 与品牌 mock 一致

## Risks
- 破坏面：理赔 API 无测试环境，代理层用合同测试锁响应结构；
  最险一步（鉴权过滤）由第二步独立 PR、code owner 复审。
- 放弃方案：直连理赔库（违反只读约束）；WebSocket 推送（超出 R1 范围，进 intent 池）。

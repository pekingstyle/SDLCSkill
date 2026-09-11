<!-- Stage 2 产出：需求与设计合一。铁律：没有 Flagged concerns 一节不算 spec；未解决顾虑不进 Build -->
# Spec: <名称>（from intent.md <日期>）

- date: YYYY-MM-DD
- status: draft | approved
- 依据政策: <brand/security/compliance/UX skill 名称及版本，如 secure-api@2026-08-01>
- unresolved concerns: <N>（必须为 0 才能置 approved）

## Requirements
字段级、可验收、编号；每条尽量可回溯到 intent 的哪一点（R1 ← Problem 第 2 句）。

## Design
方案概述、涉及的系统/服务、数据流、接口契约。前端改动附 mock 导出物链接。

## Flagged concerns
每条含四项：疑虑是什么 / 涉及哪条政策 / 建议裁决人 / 裁决结果与日期。

## Open questions
从 intent 带入的问题，注明当前进展。

## Acceptance criteria
工程做完后用什么证明达标（与 Stage 4 的验证手段对应）。

---

## 填写示例（claims status self-service，节选）

# Spec: claims status self-service（from intent.md 2026-06-02）

- 依据政策: secure-api@2026-08-01, brand-portal@2026-07-15
- unresolved concerns: 0

## Requirements
- R1: 客户登录门户后可看到本人名下每笔理赔的：状态（受理/审核中/待补充/已决）、下一步、预计完成日期 ← Expected outcome
- R2: 状态数据仅允许查询本人理赔（鉴权按客户 ID 严格过滤）← secure-api §3
- R3: 预计日期缺失时显示"审核中，预计日期待定"，不许编造日期
- R4: 页面 3 秒内完成首屏渲染（P75）

## Design
只读集成：门户后端新增加理状态查询代理，调既有理赔系统的查询 API；
不写理赔系统；状态缓存 TTL 60s（客服侧已确认可接受）。

## Flagged concerns
- [已裁决] 理赔员备注是否可见？→ 合规 owner 裁决（2026-06-05）：备注默认不可见，
  仅"下一步"动作描述对外展示。依据 compliance-claims@2026-05。
- [已裁决] 理赔 API 无速率限制？→ 按 secure-api §4，代理层加 60 req/min/user。

## Acceptance criteria
- 用非本人 token 请求他人理赔 ID → 403（自动化测试覆盖）
- 状态页截图与品牌 mock diff 一致

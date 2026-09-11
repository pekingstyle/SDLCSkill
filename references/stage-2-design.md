# Stage 2 — Design：需求与设计压进一个会话

传统把需求与设计拆给两个团队接力，慢且丢真；这里一个被提示的会话完成两者：agent 拿 intent.md 产出"需求+设计"合一的 spec，被组织政策约束，就地标出（flag）存疑之处。**政策在写作时生效，而不是几周后的评审里被发现。**

## 执行步骤
1. 会话加载组织政策 skills（品牌/安全/合规/UX）。没有政策 skill 时用现有政策文档替代，并在 spec 头部注明依据版本。
2. 把 intent.md 交给 agent，要求产出需求+设计规格。
3. 政策含糊、冲突、或需要人拍板之处，**就地**写进 Flagged concerns：疑虑是什么 + 涉及哪条政策 + 建议裁决人。
4. Flagged concerns 在 spec 进入工程前逐条与政策所有者裁决，记录结论与日期。
5. product owner 评审但不代写。目标是"工程能直接拿去做实现计划的 spec，且带着已裁决的顾虑"。
6. 前端改动：先出界面 mock 并迭代，导出物随 spec 交付。

## 闸门（出）
spec 批准 → plan mode（Stage 3 前半）。**unresolved concerns 必须为 0 才能置 approved。**
请示格式："spec 完成，N 个顾虑中 M 个已裁决，剩 X 需要你拍板。拍板后我进入实现计划。"

## 本阶段禁令
交付没有 Flagged concerns 一节的 spec；把未解决顾虑带进工程；spec 静默修改（需求变更 = status 退回 draft 重走评审）。

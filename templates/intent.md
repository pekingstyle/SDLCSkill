<!-- Stage 1 产出：复制到 intent/<日期>-<slug>/，用发起人原话填写；agent 只代笔、不拍板开放问题 -->
# Intent: <一句话名称>（from <来源路线：想法/工单/事故链接>）

- author: <发起人>（工件所有权归发起人）
- date: YYYY-MM-DD
- status: proposed | accepted   ← 接受动作 = 改为 accepted 并 commit，同时触发 Stage 2

## Problem
现在发生了什么、为什么是问题。用发起人的原话，不写解决方案。

## Who is affected
哪些用户/团队受到影响，影响频率与场景。

## Expected outcome
期望结果的**可观察行为**（不是技术方案）。验收时对照这里。

## Impact
做成后的量化收益：省多少钱/时间、提升什么指标。

## Constraints
合规 / 技术 / 时间等边界。没有就写"无已知约束"，不许留空。

## Open questions
保持开放的问题清单。**禁止替发起人拍板**；裁决发生在 Stage 2 与政策所有者之间。

---

## 填写示例（贯穿案例：保险理赔状态自助查询）

# Intent: claims status self-service（from 产品评审会想法）

- author: R. Mehta（产品）
- date: 2026-06-02
- status: accepted

## Problem
客户无法在不打电话的情况下得知理赔进度。每次查询都是一通客服电话。

## Who is affected
所有提交过理赔的客户；客服团队承接全部查询压力。

## Expected outcome
客户在门户里看到理赔状态、下一步是什么、预计日期。

## Impact
预计削减 X% 的查询类来电；客户焦虑（不知道下一步）显著下降。

## Constraints
理赔系统是既有 record of record，先做只读集成；门户已有登录体系。

## Open questions
- 理赔员的备注是否对客户可见？（→ 带入 spec 的 Flagged concerns）

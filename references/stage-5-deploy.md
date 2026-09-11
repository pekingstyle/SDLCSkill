# Stage 5 — Deploy：评审双向运行，治理在行为发生时强制执行

agent 既评进来的 PR（对照组织政策），也在自己的 PR 上逐条回应 findings。所有 PR 得到同一套 passes，findings 按严重度分级；**人的注意力上移一层**：这个改动是否做到 plan 想要的、风险是否可接受。

## 执行步骤
1. 评审纪律以 `templates/REVIEW.md` 为准：passes = bugs/security/compliance（清单归政策所有者）；Important/Nit 分级且设上限；不表扬；≤400 词。
2. 必含固定检查：**diff 是否符合 plan.md**——偏离而未同步 plan = 违规。
3. 循环：评审 → 逐条修复 → push，直到 CI 绿且 findings 清零；循环由 agent 自己跑。
4. 人的评审留给受监管/关键代码，评意图与风险；合并批准走分支保护 + code owner——**agent 没有任何自批通道**。
5. 部署分级自治：dev 高自治；staging 自动+闸门；production 人批+仅 gated 通道。agent 用自己身份运行，日志与人可区分；分支保护保证无直推路由。
6. 闸门即 hook：allow / ask / block，exit 2 回灌原因让 agent 自纠（示例 `scripts/hook-production-gate.sh`；受管配置见 governance.md 与 bindings.md）。

## 闸门（出）
PR 合并 → 流水线；生产运行信号 → Stage 6。

## 本阶段禁令
自批；越过生产闸门；评审写表扬或超字数；省略 diff-vs-plan 检查。

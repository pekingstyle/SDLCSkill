# Stage 3 — Build：先 plan mode，再实现

项目记忆（AGENTS.md）、skills、hooks、并行会话与子代理是让本阶段越跑越快的**基础设施**——它们的设立与治理见 `governance.md`，本文件只管每次实现要做的事。

## 执行步骤（plan mode）
1. plan mode 开场——默认起点，不是可选项。
2. 交出 intent.md + spec.md，要实现计划：**点名哪些文件会改、工作顺序、哪些测试能证明**。
3. 盘问计划三连：这个改动可能破坏什么？最险的一步是什么？放弃了哪些方案？
4. 迭代到"没见过对话的工程师也能只照 plan 实现"为止——这是计划完成的判据。
5. 批准的计划 commit 为 plan.md（读 `templates/plan.md`），加入审计轨迹；Stage 5 会拿 diff 对照它。
6. 接受计划后实现；计划扎实时常一遍过。
7. 实现偏离 plan：**同一 commit 更新 plan.md**（可配 hook 强制，见 scripts/hook-plan-sync.sh）。

## 高风险变更（跨系统 / 动数据模型 / 动鉴权）
plan 须 tech lead/architect 批。plan 中每个文件路径必须真实存在或明确标注 NEW——防无人认领的幻觉改动面。

## 闸门（出）
实现完成且自证通过（Stage 4）→ 开 PR 进 Stage 5。

## 本阶段禁令
无 plan.md 写实现代码；盘问走形式；偏离不同步；改测试文件让失败测试通过（hook 兜底）。

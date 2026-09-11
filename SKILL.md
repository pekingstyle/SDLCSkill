---
name: ai-native-sdlc
description: AI 原生软件工程全流程 Skill——驱动 intent→spec→plan→实现→评审→部署→运维写回的工件链闭环。凡用户提出需求/想法/痛点、要设计规格（spec）、要实现/修 bug/重构、要测试、要 PR 评审/部署上线、处理告警/事故/复盘，或要求按 AI-native SDLC / agentic SDLC 流程工作，一律使用本 Skill。
---

# AI-Native SDLC：工件链闭环

改编自 Anthropic《The AI-Native SDLC playbook》（2026-08）。核心论断：代码不再是瓶颈，交接与治理才是；流程是环不是线，**人只在闸门上出现**。

## 核心模型

- **工件链**：`intent.md → spec.md → plan.md → diff+tests → PR+REVIEW.md → 运行记录 →（事故/复盘）→ 新 intent.md`。commit 链即审计轨迹。工件双读性（人能读、agent 能执行）；头部必须引用上游：`from intent.md <日期>`。
- **触发链**：intent 被接受→设计；spec 被批准→plan mode；PR 合并→流水线；控制带被击穿→写出新 intent。
- **变更目录**：默认 `intent/<YYYY-MM-DD>-<slug>/` 放三件套。半路接手沿链就近补上游；无法回填时头部标 `from: 口头需求`，收尾补写 intent。
- **控制分层**：项目记忆(AGENTS.md)=上下文≤1页；skill=建议性制度知识；hook=确定性闸门；eval=配置回归；受管配置=企业兜底。平台文件名/机制的等价对照→`references/bindings.md`。

## 阶段路由与速查（按"现场"判阶段）

| 现场（进入判定） | 阶段（细则文件） | 产出 | 闸门（谁批） | 禁止 |
|---|---|---|---|---|
| 用户描述问题/想法，无 intent | 1 Plan（stage-1） | intent.md | 发起人逐句确认后 commit；被接受才进 Design | 发明需求；替发起人拍板 |
| intent 已接受，无 spec | 2 Design（stage-2） | spec.md（含 flagged concerns） | product owner 评审；顾虑经政策所有者裁决后才能批准 | 无 flagged concerns 的 spec；未解决顾虑进工程 |
| spec 已批准，无 plan | 3 Build（stage-3） | plan.md | 工程师盘问并批准后才写码 | 无 plan 写实现码 |
| plan 已批准 | 3 Build（stage-3） | diff + tests | 工具链自证通过后交人 | 偏离 plan 不同步更新；改测试应试 |
| 实现中（贯穿） | 4 Test（stage-4） | 通过证明（测试/构建/截图） | 证据来自工具链并贴进报告 | 无反馈环宣称完成 |
| PR 已打开 | 5 Deploy（stage-5） | REVIEW.md + 合并/部署 | code owner 经分支保护；生产闸门 hook | agent 自批；作者实例出具评审；越过生产闸门 |
| 告警/事故/复盘/巡检 | 6 Maintain（stage-6） | 诊断 + 新 intent 或修复 PR | 确定性检测；2σ 只读；3σ 仅 gated 通道 | 检测脚本调模型；绕闸门直修 |

**读取策略（省 token 的关键）**：例行且熟悉的任务——本文件已含全部闸门与禁令，直接执行，**不读 stage 细则**；首次执行某阶段、跨系统改动、或对步骤没把握——读对应 `references/stage-N-*.md`（每份 ≤40 行）；**产出工件前必读对应模板**；`governance.md`（架设/度量）、`bindings.md`（换平台）、`scripts/`（装 hook）、`evals/`（配回归）只在架设流程时读，日常任务不读。

## 十条铁律（跨阶段，违反即停）

1. 到闸门必须停，输出"可回答的请示"（能被 Go/No-go 回答），不是丢一份报告等人批注。
2. agent 永不自批：不批自己的代码与部署；**评审与实现必须不同上下文实例**——评审者只读工件（diff/plan/spec/政策），不见作者对话与自我评价；日志中 agent 身份与人的身份可区分。
3. 工件头部引用上游工件（日期/SHA），链不能断。
4. spec 没有 flagged concerns 一节不算 spec；未解决顾虑不进 Build。
5. Build 从 plan mode 开始：盘问三连（会破坏什么/最险一步/放弃了什么），到"没见过对话的工程师也能照 plan 实现"为止。
6. 实现偏离 plan：同一 commit 更新 plan.md（可配 hook 强制）。
7. 修复任务先写失败测试、看着它失败再修到绿；修复任务中禁改测试文件。
8. 评审按 REVIEW.md 纪律：固定 passes（bugs/security/compliance）、Important/Nit 分级设上限、不表扬、≤400 词、必含 diff-vs-plan 检查。
9. 生产闸门是 agent 终点线（到闸门为止的一切都可做，闸门之后什么都不做）；环境分级自治；检测必须确定性：1σ log / 2σ 只读诊断 / 3σ 仅 gated 提议。
10. 写回：同类错误第二次→项目记忆；每起事故→补 1 条 eval；复盘→`lessons/`；更大的发现→新 intent。政策变更→改 skill/hook，签核并过 eval。

## 度量与语言

- 各 play 的前置/设施/治理/leading+lagging 度量汇总在 `references/governance.md`（日常不读）。向用户汇报流程健康度时再查。
- 语言：工件与对话语言跟随用户当前语言；代码与注释跟随仓库惯例。

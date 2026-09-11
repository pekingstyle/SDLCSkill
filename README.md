# SDLCSkill — AI-Native SDLC Skill（`ai-native-sdlc`）

把软件研发跑成**工件链闭环**的 Agent Skill：

```
intent.md → spec.md → plan.md → diff+tests → PR+REVIEW.md → 运行记录 ─┐
     ↑                                                                  │
     └──────────── 事故/复盘写成新 intent.md ←── 控制带告警 ←─────────────┘
```

每个阶段以提交一个工件结束，工件的"被接受"自动触发下一阶段；人只在闸门上出现（instigating / directing / governing）。改编自 Anthropic《The AI-Native SDLC playbook》（2026-08），并做了**平台无关化**重构：不绑定任何 agent 产品名，五个绑定点（项目记忆文件 / 技能目录 / hook / 非交互运行 / 受管配置）在 `references/bindings.md` 集中映射，缺能力的平台有"agent 层 → 仓库层 → 基础设施层"的降级路径。

## 安装

`SKILL.md` 的 `name: ai-native-sdlc` 需与安装目录名一致，clone 时指定目录名：

```bash
# ZCode / AGENTS.md 系（Codex、Zed 等）——用户级，全项目可用
git clone https://github.com/pekingstyle/SDLCSkill.git ~/.agents/skills/ai-native-sdlc

# Claude Code
git clone https://github.com/pekingstyle/SDLCSkill.git ~/.claude/skills/ai-native-sdlc

# 仓库级（随代码分发给团队）
git clone https://github.com/pekingstyle/SDLCSkill.git <repo>/.agents/skills/ai-native-sdlc
```

## 结构（21 个文件，整包 ≈21k 字符；日常任务典型加载 ≈4.6k 字符）

```
SKILL.md                     # 路由层：阶段判定表 + 十条铁律 + 条件化读取策略（例行任务只读这一份）
references/
  stage-1-plan.md … stage-6-maintain.md   # 六阶段执行细则（每份 ≤21 行：步骤/闸门/禁令）
  governance.md              # 架设总纲：控制分层、14 个 play 的前置/设施/治理/度量、受管配置示例、采用顺序
  bindings.md                # 平台适配层：五个绑定点 × 平台对照 + 降级策略
templates/                   # intent / spec / plan / REVIEW / bands.yaml / lessons 六个工件模板
                             #   全部带贯穿示例（保险理赔状态自助查询），复制即用
scripts/                     # chain-check.sh（工件链检查）+ 三只 hook（测试文件保护/plan 同步/生产闸门）
evals/README.md              # 给"驾驶 agent 的配置"做回归：20–50 真实任务收集法 + CI 接入
```

## 核心纪律（SKILL.md 十条铁律速览）

到闸门必停并输出可回答的请示；agent 永不自批；工件头部引用上游；spec 无 flagged concerns 不算 spec；Build 先 plan mode 并盘问三连；偏离 plan 同 commit 更新；修复先写失败测试；REVIEW.md 按 passes/分级/≤400 词；生产闸门是 agent 终点线、检测必须确定性（1σ log / 2σ 只读 / 3σ gated）；写回闭环（错误两次→项目记忆、事故→eval、复盘→lessons、发现→新 intent）。

## Source

Adapted from [The AI-Native SDLC playbook](https://claude.com/blog/the-ai-native-sdlc-playbook) (Anthropic, 2026), reworked to be platform-neutral.

Licensed under the [MIT License](LICENSE).

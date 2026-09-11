# Bindings：平台适配层

本 Skill 的六阶段、工件链、闸门、控制分层是**平台无关的**。只有五个"绑定点"因 agent 平台而异。**换平台时只改本表，其他文件零改动。**

## 五个绑定点 × 平台对照

| 绑定点 | 通用语义 | AGENTS.md 系（ZCode / Codex / Zed 等） | Claude Code | 无对应能力的平台 |
|---|---|---|---|---|
| **项目记忆文件** | 每次会话开头被完整读入的仓库级上下文（≤1 页） | `AGENTS.md`（跨工具通用约定，本 Skill 的默认绑定） | `CLAUDE.md`（语义完全相同，仅文件名不同） | 仓库 README 的 "For AI agents" 一节，用 CI 模板分发到各仓库 |
| **技能目录** | 按触发词加载的制度知识包（frontmatter 触发 + 正文指令） | `.agents/skills/<name>/SKILL.md` | `.claude/skills/<name>/SKILL.md` | 提示模板库 + 在任务说明里人工引用 |
| **行为闸门（hook）** | 工具调用前/后的事件脚本：allow / ask / block（exit 2 把原因回灌给 agent 自纠） | 平台 hook 配置 | `settings.json` 的 hooks（PreToolUse 等） | **闸门后移**：CI 必过检查 + 分支保护 + CODEOWNERS + 服务端拒绝 |
| **非交互运行** | CI / 定时任务里无头跑 agent（evals、**PR 评审实例**、事故响应） | 平台 CLI 的 headless / 非交互模式 | `claude -p "<prompt>"` | 任意可脚本化的 agent CLI；都没有则 evals 退化为人工执行的检查清单 |
| **受管配置** | 平台级强制兜底：权限 deny/allow、沙箱、仅受管 hooks、插件来源白名单、最低版本 | 平台管理端策略 | managed settings（示例见 governance.md） | 容器/镜像层限制 + 网络策略（出口白名单）+ 最小权限凭据 |

子代理同理：verifier 定义放 `.agents/agents/verifier.md`（AGENTS.md 系）或 `.claude/agents/verifier.md`（Claude Code）。

## 映射纪律

1. 本 Skill 各文件中出现"项目记忆 / skill 目录 / hook / 非交互模式 / 受管配置"的地方，一律按本表落到你实际使用的平台。
2. **平台缺某层能力时的降级顺序**：agent 内机制 → 仓库层（分支保护、CI 检查、CODEOWNERS）→ 基础设施层（网络策略、镜像、凭据最小化）。**闸门永远要存在，只是换了执行者**——比如平台不支持 hook 拦截"改测试文件"，就在 CI 里加一条"fix/* 分支的 diff 不得触碰 tests/"检查，违规即红。
3. 受管配置的键名各家不同（详见 governance.md 的概念表），**按概念对照迁移，不逐键照抄**。
4. 新平台接入 = 在本表加一列 + 在仓库里放对应文件，流程本身不用改。

## 本 Skill 自身的安装位置

- 用户级（所有项目可用）：`~/.agents/skills/ai-native-sdlc/`（即本包当前位置）。
- 仓库级（随代码分发、团队共享）：复制到 `<repo>/.agents/skills/ai-native-sdlc/`（或 `<repo>/.claude/skills/`，若团队统一用 Claude Code）。
- hook 脚本（`scripts/hook-*.sh`）随包携带，注册格式见 `scripts/settings-hooks.example.json`，路径按仓库实际位置调整。

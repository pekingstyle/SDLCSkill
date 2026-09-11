# Governance：架设、治理与度量（**日常任务不读本文件**——流程跑起来后只在架设、度量汇报、政策变更时读）

面向采用本流程的平台/工程负责人。执行层内容在 SKILL.md 与 stage 文件；本文件回答：每个 play 需要什么前置、怎么治理、怎么度量。

## 一、控制分层决策表

| 载体 | 性质 | 放什么 | 判断标准 |
|---|---|---|---|
| `AGENTS.md`（项目记忆） | 上下文 | 新人第一天需要的：构建/测试/lint 命令、约定、架构指针、常见错误 | 每个会话都要知道；**≤1 页**（每次会话开头被完整读） |
| Skill | 建议性控制 | 必须一致执行的制度知识：安全基线、API 规范、品牌/合规/UX 政策 | 触发式加载；政策所有者签核 |
| Hook | 确定性闸门 | 必须无条件成立的规则：生产闸门、测试文件保护、plan 同步 | allow/ask/block；exit 2 把原因回灌 agent 自纠 |
| Eval | 配置回归 | 20–50 个真实任务；项目记忆/skills/hooks/模型/prompt 变更触发 | "配置即代码"：走 PR、跑套件、不合格不合并 |
| 受管配置 | 企业兜底 | 权限、沙箱、仅受管 hooks/MCP、来源白名单、最低版本 | 受监管环境最终防线；本地方不可关闭 |

**口诀**：skill 让违规少见，hook 让违规几乎不可能，eval 保证两者没被改坏，受管配置保证没人绕得过。

## 二、各 play 架设速查（前置 / 设施 / 治理 / 度量）

| Play | Prerequisites | Infrastructure | Governance 要点 | Leading → Lagging |
|---|---|---|---|---|
| 1 intent.md | 无（clay play） | 仓库 `intent/` 目录（一次性搭建） | 发起人所有权；接受后不可静默改；不写方案 | 意图捕获数/周 → 想法到生产周期 |
| 2 需求设计一会话 | intent.md + 政策 skills | product owner 能用 agent 即可，**无需工程技能** | spec 头部记政策版本；变更退回 draft 重审 | intent→spec 时长 → spec 缺陷外溢数 |
| 3-1 plan mode | intent/spec | agent CLI + 仓库 | 高风险 plan 升级审批；路径必须真实 | plan-mode 采纳率/一遍过率 → diff 偏离 drift |
| 3-2 项目记忆 | 无（clay play） | `AGENTS.md` ≤1 页 | 错误两次→写回；与 skill 不重复；遗留仓冷启动先让 agent 起草人修正 | 修订频率 → 惯例类评审 findings |
| 3-3 skills | 政策 source of truth | `.agents/skills/<name>/SKILL.md` | 政策 owner 签核（版本+日期）；**测触发**（3 种说法） | 政策修订→合并耗时 → 政策类 findings 趋零 |
| 3-4 hooks | skill 在场 | hook 注册（scripts/ 有模板） | 拦截文案写给 agent（可执行）；决策留痕（时间戳+裁决） | 每闸门等待时长 → 到生产的违规数 |
| 3-5 并行/子代理 | worktree | verifier 子代理（定义见下） | 最终检查用全新上下文，不采信主会话结论 | 并行任务数 → 合并后回滚率 |
| 4-1 feedback loop | 无（clay play） | 一键测试/构建/截图 | 终检用干净环境；截图固定视口与数据 | 自检迭代次数 → 人检出的逃逸缺陷 |
| 4-2 evals | 项目记忆 + feedback loop | CI 非交互跑 agent + API 预算 | 失败阻合并；退役要理由；活套件定期审视 | 套件时长/成本 → 逃逸回归数 |
| 5-1 PR 评审环 | AGENTS.md + skills + 子代理 | 仓库集成（评审 bot/命令） | REVIEW.md 纪律；双向评审；无自批通道 | 首评时长 → 逃逸缺陷（按严重度） |
| 5-2 闸门/受管配置 | hook 基础 | 平台受管配置（键名见 bindings） | 逐条权衡 deny vs 能力（按数据分级） | 闸门等待时长 → 生产违规数 |
| 5-3 CI/CD 分级自治 | 评审环 + 闸门 | 非交互 runner、部署经受控 API、回滚演练 | agent 独立身份；无直推路由；环境分级 | PR 周期 → 部署失败/回滚率 |
| 6-1 闭环 | intent + 评审 + 闸门 + 回滚通道 | 指标存储（Prometheus/CI API）+ 仓库读权限 + 非交互 runner | 检测无模型；分级响应；先 staging 演练回滚 | 击穿→修复 PR 时长 → MTTR/同因复发率 |
| 6-2/3/4 补eval·扫描·事件驱动 | 闭环先转起来 | 频道/工单集成 | 频道即审计；post-mortem 入库；小修→PR、大改→intent | 复盘 48h 完成率 → 同因复发率 |

**Verifier 子代理定义**（放 `.agents/agents/verifier.md` 或平台等价位置，见 bindings.md）：
> 在主会话自认为完成时启动。以**全新上下文**重跑全部检查（测试/构建/lint/政策清单），只输出 pass/fail 与证据链接；不得采信主会话的任何中间结论——裁决不被产生代码的假设污染。

## 三、受管配置示例（键名随平台而异，概念对照见 `bindings.md`）

```json
{
  "permissions": {
    "deny": ["Read(.env*)", "Read(./secrets/**)", "WebFetch", "Bash(curl *)", "Bash(wget *)"],
    "allow": ["Bash(git *)", "Bash(make build)", "Bash(make test)", "Bash(make lint)"],
    "disableBypassPermissionsMode": "disable"
  },
  "allowManagedPermissionRulesOnly": true,
  "sandbox": {
    "enabled": true, "failIfUnavailable": true, "allowUnsandboxedCommands": false,
    "network": { "allowedDomains": ["git.internal.example.com", "registry.npmjs.org"] },
    "credentials": {
      "files": [ { "path": "~/.ssh", "mode": "deny" }, { "path": "~/.aws/credentials", "mode": "deny" } ],
      "envVars": [ { "name": "GITHUB_TOKEN", "mode": "deny" } ]
    }
  },
  "allowManagedHooksOnly": true,
  "disableSideloadFlags": true,
  "allowManagedMcpServersOnly": true,
  "strictKnownMarketplaces": [ { "source": "github", "repo": "example-corp/approved-plugins" } ],
  "requiredMinimumVersion": "2.1.193"
}
```

**每行买到什么控制**：deny 把秘密挡在上下文外并堵工具级外呼；allow 预批安全内环，防 deny 退化成提示疲劳；`disableBypassPermissionsMode`+`allowManagedPermissionRulesOnly`＝无人能放宽规则；sandbox 补 permissions 的洞（工具级 deny 挡不住 shell 触网，OS 级白名单才挡得住；`failIfUnavailable=true` 沙箱起不来就拒工，绝不裸奔）；`allowManagedHooksOnly`＝审批闸门是仅有的 hooks；`disableSideloadFlags`+`strictKnownMarketplaces`＝技能只来自批准市场；`allowManagedMcpServersOnly`＝工具面是平台 allowlist；`requiredMinimumVersion`＝控制由真正评估过的 build 强制。**这是起点不是模板**：每条 deny 都在与能力交易，平衡取决于仓库数据分级。

## 四、采用顺序（箭头=采用顺序，非执行顺序；无入边的 clay play 可立刻采用）

```
clay plays（今天就能做）：intent.md 目录 ┃ AGENTS.md 一页纸 ┃ 一键反馈环
        ↓
政策 skills ┃ 行为 hooks ┃ PR 评审环
        ↓
evals 上 CI ┃ 受管配置 ┃ CI/CD 分级自治
        ↓
闭环（控制带→新 intent）┃ 定期扫描 ┃ 事件驱动接入
```

**最小采用路径**：AGENTS.md + feedback loop 起步 → 1 个最痛的 skill → 1 只最必要的 hook → evals 上 CI → 评审环 → 闸门 → 闭环。先用手把每步跑顺（手动提示），再让"工件被接受"自动扣动下一道闸门。

## 五、流程自身的治理

- skill/hook/项目记忆变更：走 PR；政策所有者签核；CI 跑 eval 回归。
- skill 上线前测触发：3 种不同说法描述同类任务，每次都要触发（靠 frontmatter 的 description，不靠正文）。
- 汇报口径：leading（政策修订→合并耗时；每闸门等待时长）+ lagging（政策类 findings 趋零；逃逸事故）。
- 政策废止→同步退役对应 skill/hook/eval 用例（写明原因），不留僵尸约束。

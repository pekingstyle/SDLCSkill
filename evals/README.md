# Evals：给"驾驶 agent 的配置"做回归

> Evals are the AI-native equivalent of stage-gate QA. —— 套件在 CI 里非交互运行：定时 + **凡 项目记忆(AGENTS.md) / skills / hooks / 模型 / prompt 变更必跑**。因为正是这份配置在驾驶 agent，它配得上和代码同级的回归测试。

## 一、收集任务集（一次性，之后滚动维护）

1. 平台工程师从**近期真实工作**里收集 **20–50 个任务**，每个带预期/可接受的结果。
2. 来源多样化：常规功能、bug 修复、重构、政策执行类任务（如"加一个端点并满足 secure-api"）。
3. 修复发布到生产时的每起事故 → 各补一条 eval（回归免疫）。

## 二、每个 eval = prompt + checks

checks 定义"可接受"，四类（原文口径）：**测试通过 / lint 干净 / 行为不变 / 政策被遵守**。

```yaml
# evals/cases/eval-037-cache-key.yaml
id: eval-037
origin: lessons/2026-06-checkout-cache.md   # 从哪起事故/哪件工作来
prompt: |
  在 portal/ 中为理赔状态查询加一层缓存：key 含 claim id 与 tenant id，TTL 60 秒。
  改动需符合 secure-api-review skill 与项目记忆（AGENTS.md）的缓存规范。
setup:
  - git checkout eval-fixtures/claims-portal   # 固定起点的镜像/夹具仓库
checks:
  - name: tests-pass
    run: npm test -- claims
  - name: lint-clean
    run: npm run lint
  - name: policy-no-hardcoded-secrets
    run: "! grep -rn 'password\\|secret' portal/services/*cache*"
  - name: tenant-isolation            # 本条是事故免疫：跨租户不得命中同一缓存条目
    run: node evals/assert-tenant-isolation.js
budget:
  max_turns: 20
  timeout_minutes: 15
```

## 三、接入 CI

- 触发：定时（每日/每周）+ 配置目录（`.agents/` 等，见 `references/bindings.md`）下 **项目记忆、skills、hooks 的任何 diff** + 模型/主 prompt 版本变更。
- 运行：CI 中以**非交互模式**跑 agent（各平台命令见 `references/bindings.md`），在沙箱内执行；带 API 预算上限。
- 判定：任一 check 失败 → **阻止合并**，直到修好，或有理由地退役该用例（在 PR 里写明原因，禁止静默删）。

## 四、维护纪律（evals 是活的套件）

- 模型进步后旧用例会失去区分度：定期审视，全绿率长期 100% 的套件是摆设。
- eval 失败的归因若指向**配置**（项目记忆/skill/hook 写错了），修配置；不许改 eval 迁就行为。
- eval 变更与代码变更走同一条 PR 评审；套件时长与成本作为 leading 指标盯住。
- Lagging 指标：被 eval 在合并前拦下的回归数 vs 逃逸到生产的回归数。

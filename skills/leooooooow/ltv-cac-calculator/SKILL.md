---
name: ltv-cac-calculator
description: Compare ecommerce LTV and CAC using realistic order, margin, and retention assumptions. Use when teams need to know whether acquisition is compounding value or buying fragile revenue.
---

# LTV CAC Calculator

增长不是把人买进来就结束，关键是这些客户值不值这个获客成本。

## 解决的问题

很多团队会说“这个渠道还在赚钱”，但没真正算清：
- 用户是否会复购；
- 毛利能否覆盖获客成本；
- 看起来跑得动，其实 payback 太慢；
- 如果 retention 变差，整个模型会不会瞬间失效。

这个 skill 的目标是：
**用一套可解释的方式，估算 LTV / CAC 关系，并给出增长是否健康的判断。**

## 何时使用

- 评估新渠道或新 campaign；
- 复盘某类客户是否值得继续加预算；
- 比较不同商品、不同人群的 acquisition quality。

## 输入要求

- 客单价
- 毛利结构
- 复购频次 / 生命周期窗口
- 当前 CAC
- 可选：退款率、客服成本、履约成本、会员贡献

## 工作流

1. 估算单客户生命周期贡献。
2. 计算 LTV / CAC 比率。
3. 判断 payback 是否健康。
4. 提示最弱的环节：留存、毛利、价格、CAC 等。

## 输出格式

1. 假设表
2. LTV / CAC 结果
3. 风险点评
4. 建议动作

## 质量标准

- 不假装精确，必须说明生命周期假设。
- 区分“看起来合理”和“真正稳健”。
- 输出要服务于预算和 retention 决策。
- 建议动作要明确。

## 资源

参考 `references/output-template.md`。

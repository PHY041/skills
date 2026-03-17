---
name: inventory-reorder-calculator
description: Estimate ecommerce reorder timing and quantity using demand, lead time, and safety stock assumptions. Use when operators need a practical reorder point instead of guesswork.
---

# Inventory Reorder Calculator

补货不是“快没了再下单”，而是提前算出风险和时间窗口。

## 解决的问题

很多库存问题不是不会卖，而是：
- 卖太快，断货；
- 下太多，压现金；
- lead time 一波动，计划就失真；
- 没有 safety stock，运营靠感觉补货。

这个 skill 的目标是：
**根据销量、库存、交期和安全库存，算出更稳妥的 reorder point 和建议补货量。**

## 何时使用

- SKU 在快速增长或大促前；
- 供应链 lead time 不稳定；
- 需要在不断货和不压货之间找平衡。

## 输入要求

- 当前库存
- 日均销量 / 周均销量
- 供应商 lead time
- MOQ / 包装倍数
- 安全库存目标
- 可选：季节性、大促、补货周期限制

## 工作流

1. 估算补货周期内需求。
2. 加上安全库存缓冲。
3. 计算 reorder point。
4. 给出建议补货量和风险提示。

## 输出格式

1. 假设表
2. Reorder point
3. 建议补货量
4. 风险区间与建议

## 质量标准

- 明确写出交期和需求假设。
- 区分补货点和补货量。
- 能支持日常运营决策，而不是只给公式。
- 对波动风险有提醒。

## 资源

参考 `references/output-template.md`。

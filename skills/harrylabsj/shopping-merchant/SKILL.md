---
name: shopping-merchant
description: Evaluate which kind of seller a shopper should prefer on Chinese e-commerce platforms. Use when the user is deciding between official flagship stores, brand-authorized stores, self-operated retail, marketplace sellers, factory-direct shops, or discount outlets, and wants to understand authenticity risk, after-sales reliability, fulfillment stability, and when paying slightly more for a stronger merchant is worth it.
---

# Shopping Merchant

Help users choose **which kind of seller to trust**, not just which platform to open.

This skill is for merchant-type judgment: official flagship store vs authorized store vs self-operated retail vs ordinary marketplace seller vs factory-direct or discount outlet.

Use it when the user asks questions such as:
- 这类商品该买旗舰店还是普通店
- 自营和第三方有什么差别
- 品牌店、授权店、个人店怎么选
- 值不值得为了更稳的店多花一点钱
- 哪类商家更适合买高单价商品

This is a low-sensitivity public skill. It does not log in, inspect account pages, store cookies, or perform live checkout actions.

Read these references as needed:
- `references/merchant-guide.md` for merchant-type comparison rules
- `references/risk-thresholds.md` for when higher trust should outweigh lower price
- `references/output-patterns.md` for result structure

## Workflow

1. Identify the purchase context.
   - Understand what the user is buying and how risky the purchase is.
   - If needed, ask one short clarifying question about product value, authenticity sensitivity, or after-sales importance.

2. Classify the merchant decision.
   Common merchant choices include:
   - official flagship store
   - brand-authorized store
   - self-operated retail
   - marketplace third-party seller
   - factory-direct or wholesale-style seller
   - discount outlet or clearance channel

3. Judge the trade-off.
   Weigh:
   - authenticity confidence
   - return and warranty expectations
   - shipping and fulfillment stability
   - seller quality consistency
   - price gap versus risk gap

4. Give a merchant recommendation.
   - Say which merchant type is the strongest fit.
   - Explain when paying more for a stronger merchant is justified.
   - Explain when a lower-trust merchant is still acceptable.

## Output

Use this structure unless the user asks for something shorter:

### Best Merchant Type
State the strongest default choice.

### Why
List the main reasons.

### When a Cheaper Seller Is Still Fine
Explain when lower-trust sellers may still be acceptable.

### When to Pay More for Safety
Explain when stronger merchant trust is worth the premium.

### Final Advice
Give a direct merchant-selection recommendation.

## Quality bar

Do:
- optimize for trust-adjusted value, not raw price alone
- distinguish product-risk level from seller-risk level
- explain when stronger after-sales support matters
- be explicit about authenticity-sensitive purchases

Do not:
- treat all third-party sellers as equally risky
- assume the cheapest merchant is the best choice
- pretend to verify live store pages or account-only information

# Insights: Duka Smart Electronics

Prepared by: Junior Data Analyst · Data: 150 customers, 800 orders (Jan 2025 – Sep 2026)

Unless stated otherwise, money figures use **Completed orders only**, revenue is
`quantity × unit_price × (1 − discount/100)`, and profit is revenue minus `quantity × cost_price`.
Completed orders bring in **KSh 24.16M** of revenue and **KSh 2.89M** of profit, an overall margin of **12.0%**.

---

## 1. Accessories are our most profitable products, but they sell the least (Q16, Q33)

**Finding.** Accessories bring in only **4.5%** of revenue (KSh 1.08M), yet they earn **KSh 456,746 in profit, 15.8% of the total**. Their margin is **42.4%**. Every other category earns only **9.9%–11.4%** (Mobile Phones 10.5%, Computing 10.6%, Electronics 9.9%, Home Appliances 11.4%). Individual accessories are even stronger: Oraimo Earbuds and the Anker 20W Charger each make about **51%**, and the Logitech Mouse makes **47%**.

**Why it matters.** Our two biggest categories, Mobile Phones (28.7% of revenue) and Computing (27.3%), keep roughly 10 shillings of profit from every 100 shillings sold. One shilling of accessory sales is worth about four shillings of phone sales in profit.

**Recommendation.** Bundle an accessory with every phone and laptop sale (charger, earbuds or mouse) and show accessories at the till and on the product pages. Stop discounting accessories.

---

## 2. Discounts above 10% turn sales into losses (Q13, Q33)

**Finding.** Discounts cost us **KSh 1.52M** on completed orders (an average of 5.6% per order). Orders discounted by more than 10% (**97 orders, KSh 3.12M revenue**) have a margin of **−0.9%**, which means we lose money on them. Orders with no discount (306 orders) earn **17.5%**, and orders with 1%–10% off earn **9.6%**.

**Why it matters.** The deep discounts do not just reduce profit, they remove it. We hand over KSh 3.12M of stock and earn nothing for it.

**Recommendation.** Set a **10% discount cap**, and require manager approval for anything above it. On low-margin products such as Hotpoint Refrigerators (4.0% margin) and Samsung TVs (4.6%), cap discounts at 5%.

---

## 3. Nairobi produces almost 40% of revenue (Q17, Q25)

**Finding.** Nairobi generates **KSh 9.58M, 39.7%** of revenue, from **41** purchasing customers. The next city, Mombasa, makes KSh 3.16M. The three smallest cities (Thika, Nyeri, Machakos) each make **under KSh 1.2M**. Machakos has only **3 customers** but they spent **KSh 745,100**, about **KSh 248,000 per customer**, which is higher than Nairobi's roughly KSh 234,000.

**Why it matters.** The business depends heavily on one city. A problem in Nairobi, such as a competitor opening, a delivery problem or a downturn, would hit overall sales hard. The small cities are not weak because customers there spend little. They are weak because we have too few customers there.

**Recommendation.** Keep Nairobi stocked and well served, but put the next marketing budget into acquiring customers in Machakos and Mombasa, where spending per customer is already high. Machakos has only 3 customers, so test first with a small campaign before committing more money.

---

## 4. The VIP label does not identify our best customers (Q24, Q27)

**Finding.** The average completed spend per customer is **VIP KSh 253,252, Corporate KSh 197,959 and Retail KSh 163,575**. VIP customers spend only **1.5 times** as much as Retail customers. Among the **top 10 customers** (KSh 664,000 to KSh 848,000 each, together **29.8% of all revenue**), **9 are labelled Retail** and only 1 is VIP. Retail customers as a group bring in about **60%** of revenue.

**Why it matters.** The segment labels are not telling us who really matters. We could be giving VIP treatment to the wrong people while our largest Retail spenders get no special attention. Just 10 customers (6.7% of all customers) produce nearly a third of our revenue.

**Recommendation.** Define VIP by actual spending, for example the top 10% of spenders, and update the label each quarter. Give the current top 10 a named account contact and early access to new stock.

---

## 5. A third of buyers have gone quiet (Q34)

**Finding.** **47 of our 132 purchasing customers (35.6%)** have not completed an order in the last 90 days, measured against the latest order date in the data (30 September 2026).

**Why it matters.** Winning a new customer costs more than keeping an existing one. More than one customer in three has stopped buying, and we have not yet contacted them.

**Recommendation.** Run a win-back campaign on these 47 customers, starting with those who spent the most. Use M-Pesa-friendly offers such as a small discount on accessories (see Insight 1) rather than a large discount on phones (see Insight 2). Repeat the Q34 query every month to catch customers earlier.

---

## 6. Revenue is growing fast, with a strong December peak and a weak January (Q31, Q40)

**Finding.** Revenue for January–September 2026 was **KSh 12.83M**, up **86%** from **KSh 6.89M** for the same months of 2025. December 2025 was our best month of that year at **KSh 2.03M**, up **60%** on November. January 2026 then fell **84%** to **KSh 322,433**, our lowest month ever. The three highest-revenue months are August 2026 (KSh 2.24M), September 2026 (KSh 2.09M) and June 2026 (KSh 2.04M).

**Why it matters.** Growth is real, but sales are uneven. December is driven by festive shopping, and the January drop leaves stock, staff and rent unfunded at the start of the year.

**Recommendation.** Build stock before November, with the most stock in high-demand electronics. Plan a January promotion (for example back-to-school laptops and accessories, with discounts kept within the 10% cap) so the quiet month is not wasted. Review cash flow before each December so the January dip is planned for.

---

## 7. One order in five never turns into revenue (Q20)

**Finding.** Of **800 orders**, only **634 (79.3%)** are Completed. **90 (11.3%)** were Cancelled and **76 (9.5%)** are still Pending, so **20.8%** of orders have produced no revenue.

**Why it matters.** Each cancelled or pending order is demand that we won, but then lost or have not collected. Pending orders are especially useful because the customer has already decided to buy.

**Recommendation.** Contact the 76 pending customers this week to confirm payment or delivery. For cancellations, record a reason code so we can find the cause. Since M-Pesa is used for most orders (441 of 800, 55%), send an automatic M-Pesa payment reminder for any order still pending after 48 hours.

---

*Reproducibility:* Insights 1, 3, 4, 5, 6 and 7 come directly from Q16/Q33, Q25, Q24/Q27, Q34, Q31/Q40 and Q20. Insight 2 comes from a discount-band query that is not one of the 46 questions. It is included in `queries.sql` as a supporting query.
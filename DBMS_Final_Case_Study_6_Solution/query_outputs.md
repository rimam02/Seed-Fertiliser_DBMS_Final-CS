# Query Output Summary

These are the expected outputs from the supplied seed data. When preparing the final submission, capture the actual PostgreSQL terminal/table output and paste screenshots below the corresponding queries if your teacher requires visible result evidence.

## Q1 — scalar subquery
Average quota = **114.76 kg**.
Rows returned: **19**.

## Q2 — IN
Kharif farmers with at least one issue: **14 rows**.
Farmer not included: F015 (Yash Shinde).

## Q3 — NOT IN
Farmers who did not receive Urea in Kharif: **9 rows**:
F003, F005, F007, F008, F010, F011, F013, F014, F015.

## Q4 — EXISTS
Farmers with at least one Kharif issue: **14 rows**.

## Q5 — NOT EXISTS
Farmers who collected nothing in Kharif:
- F015 — Yash Shinde

## Q6 — ANY
Minimum seed stock = **955 kg** (Cotton Seed).
Products with stock greater than at least one seed stock: **7 rows**.
The only product not returned is Cotton Seed itself.

## Q7 — ALL
Maximum seed stock = **2275 kg** (Wheat Seed).
Products with stock greater than every seed stock:
- P005 — Urea — 3495 kg
- P006 — DAP — 3120 kg

## Q8 — more than 80% quota
Rows returned: **13**.
The farmers are F001, F002, F003, F004, F006, F007, F008, F009, F010, F011, F012, F013 and F014.

## Q9 — below average stock
Average stock = **2110 kg**.
Products below average:
- P004 — Cotton Seed — 955 kg
- P003 — Maize Seed — 1305 kg
- P007 — Potash — 1815 kg
- P002 — Rice Seed — 1920 kg
- P008 — NPK 10-26-26 — 1995 kg

## Q10 — latest issue of each product
Eight rows are returned, one per product. The latest recipients are:
- Cotton Seed — Aditya Salunkhe — 2026-06-21 — 70 kg
- DAP — Diya Bhosale — 2026-11-29 — 90 kg
- Maize Seed — Anaya Kulkarni — 2026-11-25 — 120 kg
- NPK 10-26-26 — Neel Joshi — 2026-07-13 — 5 kg
- Potash — Diya Bhosale — 2026-06-26 — 95 kg
- Rice Seed — Omkar Gaikwad — 2026-11-28 — 95 kg
- Urea — Isha Joshi — 2026-11-27 — 140 kg
- Wheat Seed — Kabir Deshmukh — 2026-11-26 — 90 kg

## Q11 — every registered farmer
Output: **0 rows** with the current sample data. No single product was issued to all 15 active registered farmers during Kharif 2026.

## Q12 — GROUP BY + HAVING
Products issued more than 300 kg in Kharif:
- P005 — Urea — 815 kg
- P006 — DAP — 490 kg
- P003 — Maize Seed — 475 kg
- P001 — Wheat Seed — 455 kg

## Q13 — filtering + sorting
Three active farmers match `village ILIKE '%gaon%'`:
- F004 — Sneha Jadhav — Wadgaon
- F003 — Rohan More — Pargaon
- F001 — Aarav Patil — Nandgaon

## Q14 — quota-rule check
Output: **15 rows**. Every farmer with a Kharif quota has no product-level over-issue in the supplied sample data.

## Q15 — farmer-wise Kharif utilisation
All 15 farmers are reported. Utilisation ranges from **0% to 96.15%**.
Highest utilisation in the sample: F009 at 96.15%.
Lowest: F015 at 0%.

## Q16 — JOIN rewrite of Q4
Same farmer set as Q4: **14 rows**.

## Q17 — JOIN rewrite of Q9
Same product set as Q9: **5 rows**.

## Q18 — NOT IN NULL trap
The intentionally constructed `NOT IN` query contains a NULL in its subquery and therefore returns **0 rows**.
The `NOT EXISTS` alternative returns the farmer with no Kharif issue: **F015**.

-- queries.sql
-- Case Study 6: Seed and Fertiliser Depot Stock
-- Run after schema.sql and seed.sql in PostgreSQL.
-- The main reporting season used below is Kharif 2026.

-- ============================================================
-- Q1. SCALAR SUBQUERY
-- Farmers having at least one quota greater than the average quota.
-- The inner query returns ONE value.
-- ============================================================
SELECT f.farmer_code, f.farmer_name, q.quota_qty
FROM farmers f
JOIN quotas q ON q.farmer_id = f.farmer_id
WHERE q.quota_qty > (SELECT AVG(quota_qty) FROM quotas)
ORDER BY q.quota_qty DESC;

-- ============================================================
-- Q2. MULTI-ROW SUBQUERY: IN
-- Farmers who received at least one product during Kharif 2026.
-- ============================================================
SELECT farmer_code, farmer_name
FROM farmers
WHERE farmer_id IN (
    SELECT DISTINCT i.farmer_id
    FROM issues i
    JOIN seasons s ON s.season_id = i.season_id
    WHERE s.season_name = 'Kharif 2026'
)
ORDER BY farmer_code;

-- ============================================================
-- Q3. MULTI-ROW SUBQUERY: NOT IN
-- Farmers who did NOT receive Urea in Kharif 2026.
-- The subquery returns farmer IDs.
-- ============================================================
SELECT f.farmer_code, f.farmer_name
FROM farmers f
WHERE f.farmer_id NOT IN (
    SELECT i.farmer_id
    FROM issues i
    JOIN products p ON p.product_id = i.product_id
    JOIN seasons s ON s.season_id = i.season_id
    WHERE p.product_name = 'Urea'
      AND s.season_name = 'Kharif 2026'
)
ORDER BY f.farmer_code;

-- ============================================================
-- Q4. CORRELATED SUBQUERY: EXISTS
-- Registered farmers who have at least one Kharif issue.
-- The inner query refers to the outer farmer row.
-- ============================================================
SELECT f.farmer_code, f.farmer_name
FROM farmers f
WHERE EXISTS (
    SELECT 1
    FROM issues i
    JOIN seasons s ON s.season_id = i.season_id
    WHERE i.farmer_id = f.farmer_id
      AND s.season_name = 'Kharif 2026'
)
ORDER BY f.farmer_code;

-- ============================================================
-- Q5. CORRELATED SUBQUERY: NOT EXISTS
-- Registered farmers who collected NOTHING in Kharif 2026.
-- This is the direct answer to the case-study question.
-- ============================================================
SELECT f.farmer_code, f.farmer_name
FROM farmers f
WHERE NOT EXISTS (
    SELECT 1
    FROM issues i
    JOIN seasons s ON s.season_id = i.season_id
    WHERE i.farmer_id = f.farmer_id
      AND s.season_name = 'Kharif 2026'
)
ORDER BY f.farmer_code;

-- ============================================================
-- Q6. MULTI-ROW SUBQUERY: ANY
-- Products whose current stock is greater than at least one seed's stock.
-- ============================================================
SELECT ps.product_code, ps.product_name, ps.category, ps.current_stock
FROM product_stock ps
WHERE ps.current_stock > ANY (
    SELECT current_stock
    FROM product_stock
    WHERE category = 'SEED'
)
ORDER BY ps.current_stock DESC;

-- ============================================================
-- Q7. MULTI-ROW SUBQUERY: ALL
-- Products whose current stock is greater than EVERY seed's stock.
-- ============================================================
SELECT ps.product_code, ps.product_name, ps.category, ps.current_stock
FROM product_stock ps
WHERE ps.current_stock > ALL (
    SELECT current_stock
    FROM product_stock
    WHERE category = 'SEED'
)
ORDER BY ps.current_stock DESC;

-- ============================================================
-- Q8. CORRELATED SUBQUERY
-- Farmers whose total Kharif issue is more than 80% of their total
-- Kharif quota. This directly answers case-study question (1).
-- ============================================================
SELECT
    f.farmer_code,
    f.farmer_name,
    COALESCE((
        SELECT SUM(i.quantity)
        FROM issues i
        JOIN seasons s ON s.season_id = i.season_id
        WHERE i.farmer_id = f.farmer_id
          AND s.season_name = 'Kharif 2026'
    ), 0) AS issued_qty,
    COALESCE((
        SELECT SUM(q.quota_qty)
        FROM quotas q
        JOIN seasons s ON s.season_id = q.season_id
        WHERE q.farmer_id = f.farmer_id
          AND s.season_name = 'Kharif 2026'
    ), 0) AS quota_qty
FROM farmers f
WHERE COALESCE((
        SELECT SUM(i.quantity)
        FROM issues i
        JOIN seasons s ON s.season_id = i.season_id
        WHERE i.farmer_id = f.farmer_id
          AND s.season_name = 'Kharif 2026'
      ), 0)
      >
      0.80 * COALESCE((
        SELECT SUM(q.quota_qty)
        FROM quotas q
        JOIN seasons s ON s.season_id = q.season_id
        WHERE q.farmer_id = f.farmer_id
          AND s.season_name = 'Kharif 2026'
      ), 0)
ORDER BY issued_qty DESC;

-- ============================================================
-- Q9. SCALAR SUBQUERY
-- Products whose current stock is below the average stock across products.
-- Direct answer to case-study question (2).
-- ============================================================
SELECT product_code, product_name, category, current_stock
FROM product_stock
WHERE current_stock < (SELECT AVG(current_stock) FROM product_stock)
ORDER BY current_stock;

-- ============================================================
-- Q10. CORRELATED SUBQUERY
-- Latest issue of each product, showing the farmer who received it.
-- ============================================================
SELECT
    p.product_name,
    f.farmer_name,
    i.issue_date,
    i.quantity
FROM issues i
JOIN products p ON p.product_id = i.product_id
JOIN farmers f ON f.farmer_id = i.farmer_id
WHERE i.issue_date = (
    SELECT MAX(i2.issue_date)
    FROM issues i2
    WHERE i2.product_id = i.product_id
)
ORDER BY p.product_name;

-- ============================================================
-- Q11. NOT EXISTS / "EVERY REGISTERED FARMER"
-- Products issued to every registered farmer in Kharif.
-- A product qualifies when no registered farmer is missing an issue.
-- ============================================================
SELECT p.product_code, p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM farmers f
    WHERE f.status = 'ACTIVE'
      AND NOT EXISTS (
          SELECT 1
          FROM issues i
          JOIN seasons s ON s.season_id = i.season_id
          WHERE i.product_id = p.product_id
            AND i.farmer_id = f.farmer_id
            AND s.season_name = 'Kharif 2026'
      )
)
ORDER BY p.product_code;

-- ============================================================
-- Q12. GROUP BY + HAVING
-- Product-wise issue totals in Kharif, only products issued more than 300 kg.
-- Demonstrates aggregation, filtering groups and sorting.
-- ============================================================
SELECT
    p.product_code,
    p.product_name,
    SUM(i.quantity) AS total_issued
FROM issues i
JOIN products p ON p.product_id = i.product_id
JOIN seasons s ON s.season_id = i.season_id
WHERE s.season_name = 'Kharif 2026'
GROUP BY p.product_code, p.product_name
HAVING SUM(i.quantity) > 300
ORDER BY total_issued DESC;

-- ============================================================
-- Q13. FILTERING + SORTING
-- Active farmers from a selected village pattern, newest registrations first.
-- ============================================================
SELECT farmer_code, farmer_name, village, registered_on
FROM farmers
WHERE status = 'ACTIVE'
  AND village ILIKE '%gaon%'
ORDER BY registered_on DESC, farmer_name;

-- ============================================================
-- Q14. CORRELATED SUBQUERY
-- Farmers whose issue of each product never exceeded their quota for
-- that same product and season. This checks the quota rule.
-- ============================================================
SELECT f.farmer_code, f.farmer_name
FROM farmers f
WHERE EXISTS (
    SELECT 1
    FROM quotas q
    JOIN seasons s ON s.season_id = q.season_id
    WHERE q.farmer_id = f.farmer_id
      AND s.season_name = 'Kharif 2026'
)
AND NOT EXISTS (
    SELECT 1
    FROM issues i
    JOIN quotas q
      ON q.farmer_id = i.farmer_id
     AND q.product_id = i.product_id
     AND q.season_id = i.season_id
    JOIN seasons s ON s.season_id = i.season_id
    WHERE i.farmer_id = f.farmer_id
      AND s.season_name = 'Kharif 2026'
    GROUP BY i.farmer_id, i.product_id, i.season_id, q.quota_qty
    HAVING SUM(i.quantity) > q.quota_qty
)
ORDER BY f.farmer_code;

-- ============================================================
-- Q15. CASE-STUDY REPORT
-- Full farmer-wise quota utilisation report for Kharif.
-- ============================================================
SELECT
    f.farmer_code,
    f.farmer_name,
    COALESCE(SUM(q.quota_qty), 0) AS total_quota,
    COALESCE(SUM(i.issue_qty), 0) AS total_issued,
    ROUND(
        100.0 * COALESCE(SUM(i.issue_qty), 0)
        / NULLIF(SUM(q.quota_qty), 0), 2
    ) AS utilisation_percent
FROM farmers f
LEFT JOIN quotas q
    ON q.farmer_id = f.farmer_id
   AND q.season_id = (SELECT season_id FROM seasons WHERE season_name = 'Kharif 2026')
LEFT JOIN (
    SELECT farmer_id, product_id, season_id, SUM(quantity) AS issue_qty
    FROM issues
    GROUP BY farmer_id, product_id, season_id
) i
    ON i.farmer_id = q.farmer_id
   AND i.product_id = q.product_id
   AND i.season_id = q.season_id
GROUP BY f.farmer_code, f.farmer_name
ORDER BY utilisation_percent DESC NULLS LAST, f.farmer_code;

-- ============================================================
-- Q16. JOIN REWRITE #1
-- Same requirement as Q4 (farmers who have a Kharif issue),
-- rewritten using JOIN + DISTINCT instead of EXISTS.
-- ============================================================
SELECT DISTINCT f.farmer_code, f.farmer_name
FROM farmers f
JOIN issues i ON i.farmer_id = f.farmer_id
JOIN seasons s ON s.season_id = i.season_id
WHERE s.season_name = 'Kharif 2026'
ORDER BY f.farmer_code;

-- ============================================================
-- Q17. JOIN REWRITE #2
-- Same requirement as Q9 (stock below average), rewritten with
-- a one-row average-stock relation and CROSS JOIN.
-- ============================================================
SELECT ps.product_code, ps.product_name, ps.category, ps.current_stock
FROM product_stock ps
CROSS JOIN (
    SELECT AVG(current_stock) AS avg_stock
    FROM product_stock
) a
WHERE ps.current_stock < a.avg_stock
ORDER BY ps.current_stock;

-- ============================================================
-- Q18. OPTIONAL NULL-TRAP DEMONSTRATION
-- NOT IN can return no rows when the subquery contains NULL.
-- The following is intentionally a demonstration, not a production
-- report. Compare it with NOT EXISTS.
-- ============================================================
SELECT f.farmer_code, f.farmer_name
FROM farmers f
WHERE f.farmer_id NOT IN (
    SELECT NULL::INT
    UNION ALL
    SELECT farmer_id FROM issues WHERE season_id = 1
);
-- Expected: no rows, because NOT IN compares against a set containing NULL.

-- Safer form:
SELECT f.farmer_code, f.farmer_name
FROM farmers f
WHERE NOT EXISTS (
    SELECT 1
    FROM issues i
    WHERE i.farmer_id = f.farmer_id
      AND i.season_id = 1
);

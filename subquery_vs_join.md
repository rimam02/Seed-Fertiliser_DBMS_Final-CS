# Subquery vs Join — Comparison Note

## Requirement
The case study asks for at least two queries to be rewritten using joins so that the result, readability and intent can be compared. fileciteturn0file0L2-L3

## Comparison 1 — Farmers who collected in Kharif

### Subquery version
Q4 uses:

```sql
SELECT f.farmer_code, f.farmer_name
FROM farmers f
WHERE EXISTS (
    SELECT 1
    FROM issues i
    JOIN seasons s ON s.season_id = i.season_id
    WHERE i.farmer_id = f.farmer_id
      AND s.season_name = 'Kharif 2026'
);
```

### Join version
Q16 uses:

```sql
SELECT DISTINCT f.farmer_code, f.farmer_name
FROM farmers f
JOIN issues i ON i.farmer_id = f.farmer_id
JOIN seasons s ON s.season_id = i.season_id
WHERE s.season_name = 'Kharif 2026';
```

### Comparison
- `EXISTS` communicates the business question as an existence test: "does this farmer have at least one issue?"
- `JOIN` communicates the relationship and is convenient when columns from the matching issue/season rows are also required.
- `DISTINCT` is needed in the join version because one farmer can have many issue rows. Without it, the farmer can appear multiple times.
- Both express the same requirement and return the same set of farmers.

## Comparison 2 — Products below average stock

### Subquery version
Q9 uses:

```sql
SELECT product_code, product_name, category, current_stock
FROM product_stock
WHERE current_stock < (SELECT AVG(current_stock) FROM product_stock);
```

### Join-style rewrite
Q17 first creates a one-row relation containing the average and then combines it with every product using `CROSS JOIN`:

```sql
SELECT ps.product_code, ps.product_name, ps.category, ps.current_stock
FROM product_stock ps
CROSS JOIN (
    SELECT AVG(current_stock) AS avg_stock
    FROM product_stock
) a
WHERE ps.current_stock < a.avg_stock;
```

### Comparison
- The scalar-subquery version is shorter and reads naturally: "show products whose stock is below the average."
- The `CROSS JOIN` version makes the average a named relation/column, which can be useful if more calculated values are needed.
- For this simple requirement, the scalar subquery has clearer intent.
- The join rewrite is included because the evaluation explicitly asks for comparison rather than claiming that one style is always better.

## NOT IN vs NOT EXISTS

`NOT IN` is compact for a non-NULL set, but NULL values can change its three-valued-logic result. `NOT EXISTS` directly checks whether a matching row is absent and is therefore the safer expression when NULLs are possible.

Q18 deliberately demonstrates the NULL trap:

```sql
WHERE f.farmer_id NOT IN (
    SELECT NULL::INT
    UNION ALL
    SELECT farmer_id FROM issues WHERE season_id = 1
);
```

Because the subquery contains NULL, the predicate does not become TRUE for the normal farmer IDs. The `NOT EXISTS` alternative in Q18 does not have this NULL-trap behavior.

## Final design reasoning

There is no single rule that says "always use joins" or "always use subqueries." The choice depends on intent:
- Use `EXISTS`/`NOT EXISTS` when the main question is whether a related row exists.
- Use a join when columns from both relations are needed in the result or when expressing a relational combination is clearer.
- Use a scalar subquery when comparing against one calculated value, such as an average.
- Use `IN`/`NOT IN` when membership in a returned set is the clearest expression, while remembering the NULL issue with `NOT IN`.

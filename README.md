# DBMS Final Evaluation — Case Study 6
## Seed and Fertiliser Depot Stock Database Using SQL

This solution is based on the supplied ITM Skills University case-study sheet. The case asks for a database for a government depot that issues subsidised seed and fertiliser to registered farmers against a seasonal quota, and requires reports on quota utilisation, stock, farmers with no collection, latest issues and products issued to every registered farmer. The sheet specifically requires scalar, multi-row and correlated subqueries using `IN`, `NOT IN`, `EXISTS`, `NOT EXISTS`, `ANY` and `ALL`, plus at least two subquery-to-join rewrites and PostgreSQL filtering/sorting/aggregation. fileciteturn0file0L2-L3

## Files
1. `schema.sql` — tables, keys, constraints, indexes and the derived `product_stock` view.
2. `seed.sql` — realistic sample data: 15 farmers, 8 products, 3 seasons, 42 quota rows, 45 issue rows and 24 stock-receipt rows.
3. `queries.sql` — case-study reports and all required subquery types, including two join rewrites and a `NOT IN` NULL-trap demonstration.
4. `subquery_vs_join.md` — comparison note required by the evaluation.
5. `ER_Diagram.png` — ER-style diagram of the database.

## 1. Design

### Main entities
- **Farmers**: registered farmers who can receive subsidised products.
- **Products**: seed and fertiliser products available at the depot.
- **Seasons**: seasonal allocation periods.
- **Quotas**: the maximum quantity allowed for a farmer/product/season.
- **Issues**: actual quantities issued to farmers.
- **Stock Receipts**: quantities received into the depot from suppliers.

### Relationships
- One farmer can have many quotas and many issues.
- One product can have many quotas, issues and stock receipts.
- One season can have many quotas and issues.
- `quotas` has a unique `(farmer_id, product_id, season_id)` combination so a farmer has one quota for a product in a season.
- `issues` stores individual issue transactions, so multiple issues for the same farmer/product/season are allowed.
- Current stock is **derived**, not manually stored: total stock receipts minus total issues. This avoids storing the same fact twice and reduces the risk of an incorrect stock value.

## 2. Why this design?

### Alternative rejected: store `current_stock` directly in `products`
Rejected because stock can be calculated from transaction history. A manually stored stock value can become inconsistent if an issue or receipt is inserted without correctly updating the product row.

### Alternative rejected: put quota directly inside `farmers`
Rejected because quota is not a permanent property of a farmer. It changes by season and product. Therefore it belongs to the relationship between farmer, product and season.

### Alternative rejected: one table for both receipts and issues
Rejected because receipts and issues have different business meanings and attributes. A receipt comes from a supplier into the depot; an issue goes from the depot to a farmer.

### Alternative rejected: one row per farmer containing many product columns
Rejected because adding a new product would require changing the table structure. The normalized `products` + `quotas` + `issues` design handles new products without altering the schema.

## 3. Required subqueries

`queries.sql` deliberately demonstrates:
- **Scalar subquery** — returns one value, e.g. average quota/average stock.
- **Multi-row `IN`** — compares a value against a set returned by a subquery.
- **Multi-row `NOT IN`** — demonstrates exclusion and the NULL warning.
- **Correlated `EXISTS`** — checks whether a related row exists for each outer farmer.
- **Correlated `NOT EXISTS`** — checks absence; used for farmers who collected nothing.
- **`ANY`** — compares against at least one value from the subquery result.
- **`ALL`** — compares against every value from the subquery result.
- **Correlated aggregate subqueries** — calculate each farmer's quota and issue total.
- **Nested `NOT EXISTS`** — expresses the "for every registered farmer" requirement.

The case-study sheet explicitly asks students to explain correlated versus uncorrelated execution, the NULL trap with `NOT IN`, why `NOT EXISTS` is often safer, and when a subquery is clearer than a join. fileciteturn0file0L2-L3

## 4. Important reports

### Farmers using more than 80% of quota
Query Q8 calculates:
`total issued > 0.80 × total quota`

### Products below average stock
Query Q9 calculates the average of the derived `product_stock.current_stock`, then returns products below that average.

### Farmers collecting nothing in Kharif 2026
Query Q5 uses `NOT EXISTS`, which directly expresses the business rule: no matching issue exists for that farmer in the selected season.

### Latest issue of each product
Query Q10 uses a correlated `MAX(issue_date)` subquery to identify the latest transaction for each product.

### Products issued to every registered farmer
Query Q11 uses nested `NOT EXISTS`: a product qualifies only if there is no active farmer for whom a matching issue is missing.

## 5. PostgreSQL execution

Create a PostgreSQL database, then run:

```sql
\i schema.sql
\i seed.sql
\i queries.sql
```

If the files are in another folder, use their complete paths with `\i`.

Before the final demonstration, run:

```sql
SELECT * FROM product_stock ORDER BY product_id;
```

This lets you show the examiner that current stock is derived from receipts minus issues.

## 6. Viva points to remember

**Primary key:** uniquely identifies each row.

**Foreign key:** connects a row to a valid row in another table.

**Why `NOT EXISTS`?** It safely expresses "there is no matching row" and does not have the same NULL problem as `NOT IN`.

**Why can `NOT IN` be dangerous?** If the subquery returns a NULL, comparisons can become UNKNOWN under SQL's three-valued logic, which can cause expected rows not to be returned.

**Correlated subquery:** depends on a value from the current outer row and is logically evaluated with reference to that row.

**Scalar subquery:** returns one value.

**`ANY`:** true when the comparison is true for at least one returned value.

**`ALL`:** true when the comparison is true for every returned value.

**`GROUP BY`:** creates groups for aggregate calculations.

**`HAVING`:** filters groups after aggregation.

**Current stock formula:** `SUM(receipts) - SUM(issues)`.

**Why indexes?** Foreign-key/reporting columns such as farmer, product and season are frequently used in joins and filters, so indexes can reduce lookup work as the data grows.

## 7. Submission checklist

The case-study sheet lists these deliverables: ER diagram, `schema.sql`, `seed.sql`, `queries.sql` with outputs, `README.md` with design decisions/reasoning, and a comparison note for subquery versus join. fileciteturn0file0L3-L3

Before submission:
- [ ] ER diagram exported as PNG/PDF
- [ ] `schema.sql` runs without errors
- [ ] `seed.sql` runs without errors
- [ ] `queries.sql` runs after the schema and seed
- [ ] Screenshot outputs are captured for the important queries
- [ ] `README.md` is included
- [ ] `subquery_vs_join.md` is included
- [ ] GitHub repository contains all required files

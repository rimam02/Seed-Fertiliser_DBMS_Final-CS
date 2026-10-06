-- schema.sql
-- PostgreSQL schema for Case Study 6: Seed and Fertiliser Depot Stock

DROP TABLE IF EXISTS stock_receipts, issues, quotas, seasons, products, farmers CASCADE;

CREATE TABLE farmers (
    farmer_id      SERIAL PRIMARY KEY,
    farmer_code    VARCHAR(20) NOT NULL UNIQUE,
    farmer_name    VARCHAR(100) NOT NULL,
    village        VARCHAR(100) NOT NULL,
    phone          VARCHAR(15) UNIQUE,
    registered_on  DATE NOT NULL DEFAULT CURRENT_DATE,
    status         VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
                   CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

CREATE TABLE products (
    product_id     SERIAL PRIMARY KEY,
    product_code   VARCHAR(20) NOT NULL UNIQUE,
    product_name   VARCHAR(100) NOT NULL,
    category       VARCHAR(20) NOT NULL
                   CHECK (category IN ('SEED', 'FERTILISER')),
    unit           VARCHAR(20) NOT NULL,
    reorder_level  NUMERIC(12,2) NOT NULL DEFAULT 0
                   CHECK (reorder_level >= 0)
);

CREATE TABLE seasons (
    season_id      SERIAL PRIMARY KEY,
    season_name    VARCHAR(50) NOT NULL UNIQUE,
    start_date     DATE NOT NULL,
    end_date       DATE NOT NULL,
    CHECK (end_date > start_date)
);

CREATE TABLE quotas (
    quota_id       SERIAL PRIMARY KEY,
    farmer_id      INT NOT NULL REFERENCES farmers(farmer_id),
    product_id     INT NOT NULL REFERENCES products(product_id),
    season_id      INT NOT NULL REFERENCES seasons(season_id),
    quota_qty      NUMERIC(12,2) NOT NULL CHECK (quota_qty > 0),
    UNIQUE (farmer_id, product_id, season_id)
);

CREATE TABLE stock_receipts (
    receipt_id     SERIAL PRIMARY KEY,
    product_id     INT NOT NULL REFERENCES products(product_id),
    receipt_date   DATE NOT NULL,
    quantity       NUMERIC(12,2) NOT NULL CHECK (quantity > 0),
    supplier       VARCHAR(100) NOT NULL,
    batch_no       VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE issues (
    issue_id       SERIAL PRIMARY KEY,
    issue_no       VARCHAR(30) NOT NULL UNIQUE,
    farmer_id      INT NOT NULL REFERENCES farmers(farmer_id),
    product_id     INT NOT NULL REFERENCES products(product_id),
    season_id      INT NOT NULL REFERENCES seasons(season_id),
    issue_date     DATE NOT NULL,
    quantity       NUMERIC(12,2) NOT NULL CHECK (quantity > 0)
);

CREATE INDEX idx_quotas_farmer_season ON quotas(farmer_id, season_id);
CREATE INDEX idx_issues_farmer_season ON issues(farmer_id, season_id);
CREATE INDEX idx_issues_product ON issues(product_id);
CREATE INDEX idx_receipts_product ON stock_receipts(product_id);

-- A useful derived view: current stock = total receipts - total issues.
CREATE VIEW product_stock AS
SELECT
    p.product_id,
    p.product_code,
    p.product_name,
    p.category,
    p.unit,
    COALESCE(r.received_qty, 0) - COALESCE(i.issued_qty, 0) AS current_stock
FROM products p
LEFT JOIN (
    SELECT product_id, SUM(quantity) AS received_qty
    FROM stock_receipts
    GROUP BY product_id
) r ON r.product_id = p.product_id
LEFT JOIN (
    SELECT product_id, SUM(quantity) AS issued_qty
    FROM issues
    GROUP BY product_id
) i ON i.product_id = p.product_id;

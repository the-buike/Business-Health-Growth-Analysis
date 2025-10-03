CREATE OR REPLACE VIEW supplychain_dw.v_transport_cost_by_region_category AS
SELECT
    f.date_key,              
    r.region_id,
    c.category_id,
    r.region_name,
    c.category_name,
    ROUND(SUM(f.transportation_cost), 2) AS total_transport_cost
FROM supplychain_dw.fact_sales_inventory f
JOIN supplychain_dw.dim_region  r ON f.region_id = r.region_id
JOIN supplychain_dw.dim_category c ON f.category_id = c.category_id
GROUP BY f.date_key, r.region_id, c.category_id, r.region_name, c.category_name;

CREATE OR REPLACE VIEW supplychain_dw.v_units_sold_by_year AS
SELECT
    d.year,
    SUM(f.units_sold) AS total_units_sold
FROM supplychain_dw.fact_sales_inventory f
JOIN supplychain_dw.dim_date d ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;

CREATE OR REPLACE VIEW supplychain_dw.v_avg1_lead_time_by_category AS
SELECT
    f.date_key,                 -- for Year slicer
    c.category_id,              -- surrogate key (unique in dim_category)
    c.category_name,            -- label only
    SUM(f.lead_time_days)   AS lead_time_sum,
    COUNT(f.lead_time_days) AS lead_time_n
FROM supplychain_dw.fact_sales_inventory f
JOIN supplychain_dw.dim_category c
  ON f.category_id = c.category_id
GROUP BY f.date_key, c.category_id, c.category_name;



CREATE OR REPLACE VIEW supplychain_dw.v_orders_by_status AS
SELECT
    f.order_status,
    COUNT(*) AS order_count
FROM supplychain_dw.fact_sales_inventory f
GROUP BY f.order_status
ORDER BY f.order_status;

CREATE OR REPLACE VIEW supplychain_dw.v_inventory_by_category_region AS
SELECT
    c.category_name,
    r.region_name,
    SUM(f.inventory_level) AS total_inventory_level
FROM supplychain_dw.fact_sales_inventory f
JOIN supplychain_dw.dim_category c ON f.category_id = c.category_id
JOIN supplychain_dw.dim_region   r ON f.region_id   = r.region_id
GROUP BY c.category_name, r.region_name;





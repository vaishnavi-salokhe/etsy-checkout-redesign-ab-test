
USE etsy_ab_test;

-- QUERY 1: Assignment data quality
SELECT
    COUNT(*) AS total_assignments,
    COUNT(DISTINCT user_id) AS unique_users,
    SUM(user_id IS NULL) AS missing_user_ids
FROM assignments;

-- QUERY 2: Order data quality
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(user_id IS NULL) AS missing_user_ids
FROM orders;

-- QUERY 3: Overall A/B test performance
WITH user_results AS (
    SELECT
        a.user_id,
        a.variant,
        COUNT(o.order_id) AS order_count,
        COALESCE(SUM(o.order_value), 0) AS revenue
    FROM assignments a
    LEFT JOIN orders o
        ON a.user_id = o.user_id
    GROUP BY a.user_id, a.variant
)
SELECT
    variant,
    COUNT(*) AS assigned_users,
    SUM(order_count > 0) AS converted_users,
    ROUND(100.0 * SUM(order_count > 0) / COUNT(*), 2)
        AS conversion_rate_pct,
    SUM(order_count) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(SUM(order_count), 0), 2)
        AS average_order_value,
    ROUND(AVG(revenue), 2) AS revenue_per_user
FROM user_results
GROUP BY variant
ORDER BY variant;

-- QUERY 4: Device performance
WITH user_results AS (
    SELECT
        a.user_id,
        a.variant,
        a.device,
        COUNT(o.order_id) AS order_count,
        COALESCE(SUM(o.order_value), 0) AS revenue
    FROM assignments a
    LEFT JOIN orders o
        ON a.user_id = o.user_id
    GROUP BY a.user_id, a.variant, a.device
)
SELECT
    variant,
    device,
    COUNT(*) AS assigned_users,
    SUM(order_count > 0) AS converted_users,
    ROUND(100.0 * SUM(order_count > 0) / COUNT(*), 2)
        AS conversion_rate_pct,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS revenue_per_user
FROM user_results
GROUP BY variant, device
ORDER BY device, variant;

-- QUERY 5: New versus returning visitors
WITH user_results AS (
    SELECT
        a.user_id,
        a.variant,
        a.visitor_type,
        COUNT(o.order_id) AS order_count,
        COALESCE(SUM(o.order_value), 0) AS revenue
    FROM assignments a
    LEFT JOIN orders o
        ON a.user_id = o.user_id
    GROUP BY a.user_id, a.variant, a.visitor_type
)
SELECT
    variant,
    visitor_type,
    COUNT(*) AS assigned_users,
    SUM(order_count > 0) AS converted_users,
    ROUND(100.0 * SUM(order_count > 0) / COUNT(*), 2)
        AS conversion_rate_pct,
    ROUND(AVG(revenue), 2) AS revenue_per_user
FROM user_results
GROUP BY variant, visitor_type
ORDER BY visitor_type, variant;

-- QUERY 6: Daily conversion trend
WITH daily_users AS (
    SELECT
        a.user_id,
        a.variant,
        DATE(a.assigned_at) AS assignment_date,
        MAX(o.order_id IS NOT NULL) AS converted
    FROM assignments a
    LEFT JOIN orders o
        ON a.user_id = o.user_id
    GROUP BY a.user_id, a.variant, DATE(a.assigned_at)
)
SELECT
    assignment_date,
    variant,
    COUNT(*) AS assigned_users,
    SUM(converted) AS converted_users,
    ROUND(100.0 * SUM(converted) / COUNT(*), 2)
        AS conversion_rate_pct
FROM daily_users
GROUP BY assignment_date, variant
ORDER BY assignment_date, variant;

-- QUERY 7: Conversion lift
WITH user_results AS (
    SELECT
        a.user_id,
        a.variant,
        MAX(o.order_id IS NOT NULL) AS converted
    FROM assignments a
    LEFT JOIN orders o
        ON a.user_id = o.user_id
    GROUP BY a.user_id, a.variant
),
rates AS (
    SELECT
        variant,
        COUNT(*) AS users,
        SUM(converted) AS conversions,
        AVG(converted) AS conversion_rate
    FROM user_results
    GROUP BY variant
)
SELECT
    MAX(CASE WHEN variant = 'control' THEN users END)
        AS users_control,
    MAX(CASE WHEN variant = 'control' THEN conversions END)
        AS conversions_control,
    ROUND(100 * MAX(CASE WHEN variant = 'control'
        THEN conversion_rate END), 2) AS control_conversion_pct,
    MAX(CASE WHEN variant = 'treatment' THEN users END)
        AS users_treatment,
    MAX(CASE WHEN variant = 'treatment' THEN conversions END)
        AS conversions_treatment,
    ROUND(100 * MAX(CASE WHEN variant = 'treatment'
        THEN conversion_rate END), 2) AS treatment_conversion_pct,
    ROUND(100 * (
        MAX(CASE WHEN variant = 'treatment' THEN conversion_rate END)
        - MAX(CASE WHEN variant = 'control' THEN conversion_rate END)
    ), 2) AS absolute_lift_percentage_points,
    ROUND(100 * (
        MAX(CASE WHEN variant = 'treatment' THEN conversion_rate END)
        / NULLIF(MAX(CASE WHEN variant = 'control'
            THEN conversion_rate END), 0) - 1
    ), 2) AS relative_lift_pct
FROM rates;

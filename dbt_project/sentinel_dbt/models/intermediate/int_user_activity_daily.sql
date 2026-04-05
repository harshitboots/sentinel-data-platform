{{ config(materialized='table') }}

WITH transactions AS (

    SELECT
        user_id,
        transaction_date AS activity_date
    FROM {{ ref('stg_transactions') }}

),

events AS (

    SELECT
        user_id,
        DATE(event_time) AS activity_date
    FROM {{ ref('stg_events') }}

),

combined AS (

    SELECT * FROM transactions
    UNION ALL
    SELECT * FROM events

),

deduplicated AS (

    SELECT DISTINCT
        user_id,
        activity_date
    FROM combined

),

final AS (

    SELECT
        user_id,
        activity_date,

        COUNT(*) OVER (
            PARTITION BY user_id
            ORDER BY activity_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS activity_7d

    FROM deduplicated

)

SELECT * FROM final
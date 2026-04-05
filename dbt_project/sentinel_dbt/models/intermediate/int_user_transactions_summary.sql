{{ config(materialized='table') }}

WITH txns AS (

    SELECT * FROM {{ ref('stg_transactions') }}

),

agg AS (

    SELECT
        user_id,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_spend,
        AVG(amount) AS avg_transaction_value,
        MAX(transaction_date) AS last_transaction_date

    FROM txns
    GROUP BY user_id

)

SELECT * FROM agg
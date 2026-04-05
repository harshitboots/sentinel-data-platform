{{ config(materialized='table') }}

WITH profile AS (

    SELECT * FROM {{ ref('int_user_profile_enriched') }}

),

txn AS (

    SELECT * FROM {{ ref('int_user_transactions_summary') }}

),

events AS (

    SELECT * FROM {{ ref('int_user_event_summary') }}

),

joined AS (

    SELECT
        p.user_id,
        p.city,

        -- transaction metrics
        t.total_transactions,
        t.total_spend,
        t.avg_transaction_value,
        t.last_transaction_date,

        -- event metrics
        e.total_events,
        e.last_event_time

    FROM profile p
    LEFT JOIN txn t ON p.user_id = t.user_id
    LEFT JOIN events e ON p.user_id = e.user_id

)

SELECT * FROM joined
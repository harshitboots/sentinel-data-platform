{{ config(materialized='table') }}

WITH events AS (

    SELECT * FROM {{ ref('stg_events') }}

),

agg AS (

    SELECT
        user_id,
        COUNT(*) AS total_events,
        MAX(event_time) AS last_event_time

    FROM events
    GROUP BY user_id

)

SELECT * FROM agg
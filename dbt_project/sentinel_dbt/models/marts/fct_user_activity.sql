{{ config(materialized='table') }}

WITH activity AS (

    SELECT * FROM {{ ref('int_user_activity_daily') }}

)

SELECT
    user_id,
    activity_date,

    activity_7d,

    CASE 
        WHEN activity_7d > 0 THEN 1
        ELSE 0
    END AS is_active

FROM activity
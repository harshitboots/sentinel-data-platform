{{ config(materialized='table') }}

WITH profile_snapshot AS (

    SELECT
        CAST(user_id AS STRING) AS user_id,
        phone,
        city,
        dbt_valid_from,
        dbt_valid_to
    FROM {{ ref('user_profile_snapshot') }}

),

users AS (

    SELECT
        CAST(user_id AS STRING) AS user_id,
        name,
        email,
        signup_date
    FROM {{ ref('stg_users') }}

),

joined AS (

    SELECT
        u.user_id,
        u.name,
        u.email,
        u.signup_date,

        ps.phone,
        ps.city,

        ps.dbt_valid_from,
        ps.dbt_valid_to,

        CASE 
            WHEN ps.dbt_valid_to IS NULL THEN 1
            ELSE 0
        END AS is_current

    FROM profile_snapshot ps
    LEFT JOIN users u
        ON ps.user_id = u.user_id

),

final AS (

    SELECT
        user_id,
        name,
        email,
        signup_date,
        phone,
        city,
        dbt_valid_from,
        dbt_valid_to,
        is_current,

        DATE_DIFF(CURRENT_DATE(), signup_date, DAY) AS user_age_days,

        CASE 
            WHEN DATE_DIFF(CURRENT_DATE(), signup_date, DAY) <= 30 THEN 'new_user'
            WHEN DATE_DIFF(CURRENT_DATE(), signup_date, DAY) <= 180 THEN 'mid_user'
            ELSE 'old_user'
        END AS user_segment

    FROM joined

)

SELECT * FROM final
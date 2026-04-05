{{ config(materialized='table') }}

WITH users AS (

    SELECT * FROM {{ ref('stg_users') }}

),

profile AS (

    SELECT * FROM {{ ref('stg_user_profile') }}

),

joined AS (

    SELECT
        u.user_id,
        u.name,
        u.email,
        u.signup_date,

        p.phone,
        p.city,

        u.updated_at AS user_updated_at,
        p.updated_at AS profile_updated_at

    FROM users u
    LEFT JOIN profile p
        ON u.user_id = p.user_id

)

SELECT * FROM joined
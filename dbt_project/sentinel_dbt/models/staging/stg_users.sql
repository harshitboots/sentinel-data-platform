{{ config(materialized='view') }}

WITH source AS (

    SELECT * 
    FROM {{ source('raw', 'raw_users') }}

),

cleaned AS (

    SELECT
        CAST(user_id AS STRING) AS user_id,
        CAST(name AS STRING) AS name,
        CAST(email AS STRING) AS email,
        CAST(signup_date AS DATE) AS signup_date,
        CAST(updated_at AS TIMESTAMP) AS updated_at,

        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source

)

SELECT * FROM cleaned
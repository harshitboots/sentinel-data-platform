{{ config(materialized='view') }}

WITH source AS (

    SELECT * 
    FROM {{ source('raw', 'raw_user_profile') }}

),

cleaned AS (

    SELECT
        CAST(user_id AS STRING) AS user_id,
        CAST(phone AS STRING) AS phone,
        CAST(city AS STRING) AS city,
        CAST(updated_at AS TIMESTAMP) AS updated_at,

        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source

)

SELECT * FROM cleaned
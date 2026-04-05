{{ config(materialized='view') }}

WITH source AS (

    SELECT * 
    FROM {{ source('sentinel_raw', 'raw_events') }}

),

cleaned AS (

    SELECT
        CAST(event_id AS STRING) AS event_id,
        CAST(user_id AS STRING) AS user_id,
        CAST(event_type AS STRING) AS event_type,
        CAST(event_time AS TIMESTAMP) AS event_time,

        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source

)

SELECT * FROM cleaned
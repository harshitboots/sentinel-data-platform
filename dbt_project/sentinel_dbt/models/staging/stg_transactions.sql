{{ config(materialized='view') }}

WITH source AS (

    SELECT * 
    FROM {{ source('sentinel_raw', 'raw_transactions') }}

),

cleaned AS (

    SELECT
        CAST(transaction_id AS STRING) AS transaction_id,
        CAST(user_id AS STRING) AS user_id,
        CAST(amount AS FLOAT64) AS amount,
        CAST(transaction_date AS DATE) AS transaction_date,

        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM source

)

SELECT * FROM cleaned
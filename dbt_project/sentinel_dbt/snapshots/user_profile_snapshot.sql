{% snapshot user_profile_snapshot %}

{{
    config(
        target_schema='sentinel_stg',
        unique_key='user_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

SELECT
    user_id,
    phone,
    city,
    updated_at

FROM {{ source('raw', 'raw_user_profile') }}

{% endsnapshot %}
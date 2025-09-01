{{
  config(
    materialized = 'table',
    )
}}
SELECT 
    aircraft_code, 
    model
FROM 
    {{ source('demo_src', 'aircrafts') }}
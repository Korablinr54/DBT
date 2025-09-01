{% snapshot dim_airports %}

{% set snapshot_schema = target.schema + '_snapshot' %}

{{

    config(
        target_database = 'dbt_course',
        target_schema = snapshot_schema,
        unique_key = 'airport_code',
        strategy = 'check',
        dbt_valid_to_current = '\'9999-12-31\'::date',
        check_cols = ['airport_name','city','coordinates','timezone']
    )

}}

select 
    airport_code, 
    airport_name, 
    city, 
    coordinates, 
    timezone,
    case
        when count(*) over(partition by airport_code) = 1 
        then null
        else now()::timestamp
    end as dbt_valid_from_custom
from {{ ref('stg_booking__airports') }}

{% endsnapshot %}
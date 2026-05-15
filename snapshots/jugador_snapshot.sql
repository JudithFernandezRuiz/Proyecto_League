{% snapshot jugador_snapshot %}

{{
    config(
        target_database='BRONZE_DB',
        target_schema='PUBLIC',
        unique_key='puuid',
        strategy='check',
        check_cols=['elo', 'tier', 'lp'],
    )
}}

select * from {{ source('bronze', 'jugador') }}

{% endsnapshot %}
{% snapshot jugador_snapshot %}

{{
    config(
        target_database='LEAGUE_DB',
        target_schema='BRONZE',
        unique_key='puuid',
        strategy='check',
        check_cols=['elo', 'tier', 'lp'],
    )
}}

select * from {{ source('bronze', 'jugador') }}

{% endsnapshot %}
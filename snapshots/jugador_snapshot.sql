{% snapshot jugador_snapshot %}

{{
    config(
        target_database='SILVER_' ~ env_var('DBT_ENVIRONMENTS', 'DEV'),
        target_schema='snapshots',
        unique_key='puuid',
        strategy='check',
        check_cols=['elo', 'tier', 'lp'],
    )
}}

select 
    puuid,
    summonername,
    elo,
    tier,
    lp::integer as lp
from {{ ref('base__jugador') }} 
where puuid is not null
qualify row_number() over (partition by puuid order by puuid) = 1

{% endsnapshot %}
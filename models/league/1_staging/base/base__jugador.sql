with source as (
    select * from {{ source('bronze', 'raw_challenger_jugadores') }}
),

final as (
    select distinct
        puuid,
        summonername,
        'CHALLENGER' as elo,
        tier,
        lp
    from source
    where puuid is not null
      and summonername is not null
    
    qualify ROW_NUMBER() OVER (
        PARTITION BY puuid
        ORDER BY puuid
    ) = 1
)

select * from final
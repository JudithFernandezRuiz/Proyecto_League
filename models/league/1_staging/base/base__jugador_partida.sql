with source as (
    select * from {{ source('bronze', 'raw_challenger_jugadores') }}
),

final as (
    select distinct
        match_id,
        puuid,
        summonername,
        championid,
        championname,
        win,
        kills,
        deaths,
        assists,
        participantid,
        individualposition,
        goldearned,
        gameversion
    from source
    where match_id is not null
      and puuid is not null
    
    qualify ROW_NUMBER() OVER (
        PARTITION BY match_id, puuid
        ORDER BY match_id, puuid
    ) = 1
)

select * from final
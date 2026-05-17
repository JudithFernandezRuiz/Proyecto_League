with source as (
    select * from {{ source('bronze', 'raw_picks_bans') }}
),

final as (
    select distinct
        match_id,
        summonername,
        orden,
        tipo,
        championid,
        equipo,
        teamid
    from source
    where match_id is not null
      and championid is not null
    
    qualify ROW_NUMBER() OVER (
        PARTITION BY match_id, orden, tipo, championid, equipo
        ORDER BY match_id
    ) = 1
)

select * from final
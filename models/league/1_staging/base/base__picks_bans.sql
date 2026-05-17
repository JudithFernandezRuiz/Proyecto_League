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
        equipo
    from source
    where match_id is not null
      and championid is not null
      and summonername is not null
      and summonername != ''
)

select * from final
-- models/league/1_staging/base/base__picks_bans.sql

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
)

select * from final
with source as (
    select * from {{ source('bronze', 'stg_challenger_raw') }}
),

renamed as (
    select
        match_id                    as id_partida,
        puuid,
        summonername                as nombre_invocador,
        championid,
        championname,
        win,
        kills,
        deaths,
        assists,
        teamid                      as id_equipo,
        individualposition          as posicion,
        goldearned,
        patch,
        CASE WHEN teamid = 100 THEN 'BLUE' ELSE 'RED' END as lado
    from source
    where match_id is not null
      and puuid is not null
)

select distinct * from renamed
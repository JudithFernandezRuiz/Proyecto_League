with source as (

    select * from {{ source('bronze', 'RAW_CHALLENGER_JUGADORES') }}

),

renamed as (

    select
        match_id                                                        as id_partida,
        puuid,
        summonername                                                    as nombre_invocador,
        championid::integer                                             as championid,
        championname,
        win,
        kills::integer                                                  as kills,
        deaths::integer                                                 as deaths,
        assists::integer                                                as assists,
        CASE WHEN participantid::integer <= 5 THEN 100 ELSE 200 END    as id_equipo,
        teamposition                                                    as posicion,
        goldearned::integer                                             as goldearned,
       gameversion                                                      as patch,
        CASE WHEN participantid::integer <= 5 THEN 'BLUE' ELSE 'RED' END as lado
    from source
    where match_id is not null
      and puuid is not null

)

select distinct * from renamed
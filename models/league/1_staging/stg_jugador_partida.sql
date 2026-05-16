with source as (

    select * from {{ source('bronze', 'raw_challenger_jugadores') }}

),

renamed as (

    select
        match_id as id_partida,
        puuid,
        summonername as nombre_invocador,
        championid::integer as championid,
        championname,
        win,
        kills::integer as kills,
        deaths::integer as deaths,
        assists::integer as assists,
        case when participantid::integer <= 5 then 100 else 200 end as id_equipo,
        individualposition as posicion,
        goldearned::integer as goldearned,
        gameversion as patch,
        case when participantid::integer <= 5 then 'BLUE' else 'RED' end as lado
    from source
    where match_id is not null
      and puuid is not null

)

select distinct * from renamed

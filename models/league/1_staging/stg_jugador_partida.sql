with source as (
    select * from {{ ref('base__jugador_partida') }}
),

stg_posicion as (
    select * from {{ ref('stg_posicion_jugador') }}
),

stg_jugador as (
    select id_jugador, puuid from {{ ref('stg_jugador') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['match_id', 'puuid']) }} as id_jugador_partida,
        match_id as id_partida,
        puuid,
        CASE WHEN participantid::integer <= 5 
            THEN 'Azul' ELSE 'Rojo' END as lado,
        individualposition as posicion_nombre,
        championid::integer as id_campeon,
        championname,
        CAST(win AS BOOLEAN) as resultado,
        kills::integer as asesinatos,
        deaths::integer as muertes,
        assists::integer as asistencias,
        goldearned::integer as oro_total,
        gameversion as patch
    from source
    where match_id is not null
      and puuid is not null
    qualify ROW_NUMBER() OVER (PARTITION BY match_id, puuid ORDER BY puuid) = 1
),

final as (
    select
        r.id_jugador_partida,
        r.id_partida,
        jp.id_jugador,
        r.puuid,
        r.lado,
        p.id as id_posicion_jugador,
        r.id_campeon,
        r.championname,
        r.resultado,
        r.asesinatos,
        r.muertes,
        r.asistencias,
        r.oro_total,
        r.patch
    from renamed r
    left join stg_posicion p on p.nombre = r.posicion_nombre
    left join stg_jugador jp on r.puuid = jp.puuid
)

select * from final
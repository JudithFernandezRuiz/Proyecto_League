with source as (

    select * from {{ source('bronze', 'raw_challenger_jugadores') }}

),

stg_posicion as (

    select * from {{ ref('stg_posicion_jugador') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['match_id', 'puuid']) }}   as id_jugador_partida,
        match_id                                                         as id_partida,
        puuid,
        CASE WHEN participantid::integer <= 5 
            THEN 'Azul' ELSE 'Rojo' END                                 as lado,
        individualposition                                               as posicion_nombre
    from source
    where match_id is not null
      and puuid is not null
    qualify ROW_NUMBER() OVER (PARTITION BY match_id, puuid ORDER BY puuid) = 1

),

final as (

    select
        r.id_jugador_partida,
        r.id_partida,
        r.puuid,
        r.lado,
        p.id                                                            as id_posicion_jugador
    from renamed r
    left join stg_posicion p on p.nombre = r.posicion_nombre

)

select * from final
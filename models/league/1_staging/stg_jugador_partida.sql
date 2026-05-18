with source as (
    select * from {{ ref('base__jugador_partida') }}
),

stg_posicion as (
    select * from {{ ref('stg_posicion_jugador') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['match_id', 'puuid']) }}           as id_jugador_partida,
        match_id,
        substring(cast(puuid as string), 1, 12)                                 as id_jugador,
        CASE WHEN participantid::integer <= 5 
            THEN 'Azul' ELSE 'Rojo' END                                         as lado,
        p.id                                                                     as id_posicion_jugador
    from source s
    left join stg_posicion p on p.nombre = s.individualposition
    where puuid is not null
      and match_id is not null
      and participantid::integer <= 300
)

select * from final
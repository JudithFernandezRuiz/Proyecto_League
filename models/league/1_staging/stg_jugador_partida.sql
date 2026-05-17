with source as (
    select * from {{ ref('base__jugador_partida') }}
),

final as (
    select
        id_jugador_partida,
        id_partida,
        
        substring(cast(puuid as string), 1, 12) as id_jugador,
        lado,
        id_posicion_jugador
    from source
    where puuid is not null
      and id_partida is not null
)

select * from final
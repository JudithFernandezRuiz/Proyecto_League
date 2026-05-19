with source as (
    select * from {{ ref('base__jugador_partida') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['match_id', 'puuid']) }}           as id_jugador_partida,
        match_id,
        substring(cast(puuid as string), 1, 12)                                 as id_jugador,
        CASE WHEN participantid::integer <= 5 
            THEN 'Azul' ELSE 'Rojo' END                                         as lado,
        id_posicion_jugador
    from source s
    where puuid is not null
      and match_id is not null
)

select * from final
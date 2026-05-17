with source as (
    select * from {{ ref('base__evento_partida') }}
),

participantes as (
    select * from {{ ref('base__jugador_partida') }}
),

final as (
    select
       
        source.id_evento, 
        source.id_partida,
        
        substring(cast(p.puuid as string), 1, 12) as id_jugador,
        source.tiempo_partida,
        source.id_tipo_evento
    from source
    left join participantes p 
        on source.id_partida = p.id_partida 
        and source.participantid::integer = p.participantid::integer
    where source.tiempo_partida is not null
      and source.id_tipo_evento is not null
      and p.puuid is not null
)


select * from final
qualify ROW_NUMBER() OVER (PARTITION BY id_evento ORDER BY id_partida) = 1
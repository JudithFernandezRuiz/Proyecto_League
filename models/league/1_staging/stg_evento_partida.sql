with source as (
    select * from {{ ref('base__eventos') }}
),

participantes as (
    select * from {{ ref('base__jugador_partida') }}
),

final as (
    select
        source.match_id as id_partida, 
        substring(cast(p.puuid as string), 1, 12) as id_jugador,
        source.timestamp_ms as tiempo_partida, 
        source.tipo_evento 
    from source
    left join participantes p 
        on source.match_id = p.match_id 
        and source.participantid::integer = p.participantid::integer
    where source.timestamp_ms is not null
      and source.tipo_evento is not null
      and p.puuid is not null
)

select * from final
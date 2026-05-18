with source as (
    select * from {{ ref('base__eventos') }}
),

participantes as (
    select * from {{ ref('base__jugador_partida') }}
),

stg_partida as (
    select * from {{ ref('stg_partida') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'source.match_id',
            'source.timestamp_ms',
            'source.tipo_evento',
            'source.participantid',
            'source.killerid',
            'source.victimid',
            'source.itemid',
            'source.skillslot'
        ]) }}                                                           as id_evento,
        source.match_id                                                 as id_partida,
        substring(cast(p.puuid as string), 1, 12)                      as id_jugador,
        DATEADD('millisecond', 
            source.timestamp_ms::bigint, 
            sp.fecha_inicio)                                            as tiempo_partida,
        {{ dbt_utils.generate_surrogate_key(['source.tipo_evento']) }}  as id_tipo_evento,
        source.tipo_evento
    from source
    left join participantes p 
        on source.match_id = p.match_id 
        and source.participantid::integer = p.participantid::integer
    left join stg_partida sp
        on sp.id = source.match_id
    where source.timestamp_ms is not null
      and source.tipo_evento is not null
    qualify ROW_NUMBER() OVER (
        PARTITION BY source.match_id, source.timestamp_ms, source.tipo_evento, 
                     source.participantid, source.killerid, source.victimid, 
                     source.itemid, source.skillslot
        ORDER BY source.match_id
    ) = 1
)

select * from final
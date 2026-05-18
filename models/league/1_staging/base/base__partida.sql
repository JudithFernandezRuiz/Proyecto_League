with source as (
    select * from {{ source('bronze', 'raw_challenger_jugadores') }}
),

eventos as (
    select 
        match_id,
        timestamp_ms::bigint as duracion_ms
    from {{ source('bronze', 'raw_eventos') }}
    where tipo_evento = 'GAME_END'
    qualify ROW_NUMBER() OVER (PARTITION BY match_id ORDER BY timestamp_ms DESC) = 1
),

final as (
    select
        s.match_id,
        s.gameversion,
        s.queueid,
        s.gamestarttimestamp,
        s.win,
        s.participantid,
        s.gameduration_seg,
        DATEADD('millisecond', e.duracion_ms, TO_TIMESTAMP(s.gamestarttimestamp::bigint / 1000)) as fecha_fin
    from source s
    left join eventos e on e.match_id = s.match_id
    where s.match_id is not null
)

select * from final
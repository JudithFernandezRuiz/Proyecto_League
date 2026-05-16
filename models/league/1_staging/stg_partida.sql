with source as (
    select * from {{ source('bronze', 'raw_challenger_jugadores') }}
),

renamed as (
    select distinct
        match_id                                                as id,
        gameversion                                             as patch,
        CASE 
            WHEN queueId = '420' THEN 'RANKED_SOLO'
            WHEN queueId = '440' THEN 'FLEX_Q'
            WHEN queueId = '450' THEN 'ARAM'
            ELSE 'OTHER'
        END                                                     as modo_juego,
        win                                                     as resultado,
        TO_TIMESTAMP(gamestarttimestamp::bigint / 1000)        as fecha_inicio,
        NULL::timestamp                                         as fecha_fin
    from source
    where match_id is not null and modo_juego is not null
),

deduplicado as (
    select *,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) as rn
    from renamed
)

select
    id,
    patch,
    modo_juego,
    resultado,
    fecha_inicio,
    fecha_fin
from deduplicado
where rn = 1
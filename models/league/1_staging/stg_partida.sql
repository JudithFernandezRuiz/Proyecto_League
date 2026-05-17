with source as (
    select * from {{ ref('base__partida') }}
),

renamed as (
    select
        match_id as id,
        gameversion as patch,
        CASE 
            WHEN queueid = '420' THEN 'RANKED_SOLO'
            WHEN queueid = '440' THEN 'FLEX_Q'
            WHEN queueid = '450' THEN 'ARAM'
            ELSE 'OTHER'
        END as modo_juego,
        null as resultado,
        TO_TIMESTAMP(gamestarttimestamp::bigint / 1000) as fecha_inicio,
        NULL::timestamp as fecha_fin
    from source
    where match_id is not null
),

deduplicado as (
    select *,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id DESC) as rn
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
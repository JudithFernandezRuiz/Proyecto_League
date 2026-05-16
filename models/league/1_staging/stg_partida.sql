with source as (

    select * from {{ source('bronze', 'RAW_CHALLENGER_JUGADORES') }}

),

renamed as (

    select distinct
        match_id                                                as id,
        gameversion                                             as patch,
        'RANKED_SOLO'                                           as modo_juego,
        win                                                     as resultado,
        DATEADD('millisecond', 
            SPLIT_PART(match_id, '_', 2)::bigint % 86400000,
            CURRENT_DATE::timestamp)                            as fecha_inicio,
        NULL::timestamp                                         as fecha_fin
    from source
    where match_id is not null

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
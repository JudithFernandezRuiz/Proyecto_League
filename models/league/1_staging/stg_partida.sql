with source as (

    select * from {{ source('bronze', 'stg_challenger_raw') }}

),

renamed as (

    select distinct
        match_id                                                as id,
        gameversion                                             as patch,
        'RANKED_SOLO'                                           as modo_juego,
        win                                                     as resultado,
        TO_TIMESTAMP(gamestarttimestamp::bigint / 1000)         as fecha_inicio,
        NULL::timestamp                                         as fecha_fin
    from source
    where match_id is not null
      and gamestarttimestamp is not null
      and TRY_CAST(gamestarttimestamp as bigint) is not null

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
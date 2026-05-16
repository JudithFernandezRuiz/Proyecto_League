with source as (

    select * from {{ source('bronze', 'raw_challenger_jugadores') }}

),

renamed as (

    select distinct
        match_id as id,
        gameversion as patch,
        case 
            when queueid = '420' then 'SOLO_Q'
            when queueid = '440' then 'FLEX_Q'
            when queueid = '450' then 'ARAM'
            else 'OTHER'
        end as modo_juego,
        win as resultado,
        to_timestamp(gamestarttimestamp::bigint / 1000) as fecha_inicio,
        null::timestamp as fecha_fin
    from source
    where match_id is not null

),

deduplicado as (

    select *,
        row_number() over (partition by id order by id) as rn
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

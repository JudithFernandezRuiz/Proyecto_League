with source as (

    select * from {{ source('bronze', 'partida') }}

),

renamed as (

    select
        id,
        fecha_inicio,
        fecha_fin,
        patch,
        modo_juego,
        resultado
    from source
    where id is not null

),

deduplicado as (

    select *,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) as rn
    from renamed

)

select
    id,
    fecha_inicio,
    fecha_fin,
    patch,
    modo_juego,
    resultado
from deduplicado
where rn = 1
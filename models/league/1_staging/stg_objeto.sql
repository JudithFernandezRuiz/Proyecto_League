with 

source as (

    select * from {{ source('bronze', 'OBJETO_ITEMS') }}

),

renamed as (

    select
        id,
        nombre,
        costo
    from source
    where id is not null
      and nombre is not null

),

deduplicado as (

    select *,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) as rn
    from renamed

)

select
    id,
    nombre,
    costo
from deduplicado
where rn = 1

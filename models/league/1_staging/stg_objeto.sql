with 

source as (

    select * from {{ source('bronze', 'objeto') }}

),

renamed as (

    select
        id,
        nombre
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
    nombre
from deduplicado
where rn = 1
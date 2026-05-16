with 

source as (

    select * from {{ source('bronze', 'ping') }}

),

renamed as (

    select
        id,
        id_tipo_ping,
        tipo

    from source
    where id is not null

)

select distinct * from renamed
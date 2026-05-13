with 

source as (

    select * from {{ source('bronze', 'tipo_evento') }}

),

renamed as (

    select
        id,
        nombre,
        id_objeto,
        id_ping

    from source
  where id is not null

)

select distinct * from renamed
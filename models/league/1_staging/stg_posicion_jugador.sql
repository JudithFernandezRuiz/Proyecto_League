with 

source as (

    select * from {{ source('bronze', 'posicion_jugador') }}

),

renamed as (

    select
        id,
        nombre

    from source
    where id is not null

)

select distinct * from renamed
with source as (

    select * from {{ source('bronze', 'campeon') }}

),

renamed as (

    select
        id,
        id_tipo_campeon,
        nombre
    from source
    where id is not null
      and nombre is not null

)

select distinct * from renamed
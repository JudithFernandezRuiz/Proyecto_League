with 

source as (

    select * from {{ source('bronze', 'CAMPEON_DRAGON') }}

),

renamed as (

    select
        id,
        clase,
        rol_principal

    from source
     where id is not null

)

select distinct * from renamed
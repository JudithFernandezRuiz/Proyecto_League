with 

source as (

    select * from {{ source('bronze', 'tipo_campeon') }}

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
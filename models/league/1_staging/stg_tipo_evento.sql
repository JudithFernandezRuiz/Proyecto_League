with source as (

    select * from {{ source('bronze', 'raw_eventos') }}

),

renamed as (

    select distinct
        row_number() over (order by tipo_evento) as id,
        tipo_evento as nombre
    from source
    where tipo_evento is not null

)

select * from renamed

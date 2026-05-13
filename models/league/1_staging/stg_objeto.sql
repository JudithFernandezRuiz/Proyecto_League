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

)

select distinct * from renamed
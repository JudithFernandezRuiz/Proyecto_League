with source as (

    select * from {{ source('bronze', 'raw_challenger_jugadores') }}

),

renamed as (

    select distinct
        championid::integer as id,
        championname as nombre
    from source
    where championid is not null
      and championname is not null

)

select * from renamed

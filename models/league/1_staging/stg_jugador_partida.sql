with 

source as (

    select * from {{ source('bronze', 'jugador_partida') }}

),

renamed as (

    select
        id,
        id_jugador,
        id_partida,
        lado,
        id_posicion_jugador

    from source
  where id is not null

)

select distinct * from renamed
with 

source as (

    select * from {{ source('bronze', 'evento_partida') }}

),

renamed as (

    select
        id,
        id_jugador,
        id_partida,
        tiempo_partida,
        id_tipo_evento

    from source
  where id is not null

)

select distinct * from renamed
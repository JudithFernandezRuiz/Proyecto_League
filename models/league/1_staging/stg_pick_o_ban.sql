with 

source as (

    select * from {{ source('bronze', 'pick_o_ban') }}

),

renamed as (

    select
        id,
        id_partida,
        id_jugador,
        id_campeon,
        tipo_accion,
        orden_secuencia,
        lado

    from source
    where id is not null

)

select distinct * from renamed
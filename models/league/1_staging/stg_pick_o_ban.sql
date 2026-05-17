with source as (

    select * from {{ source('bronze', 'raw_picks_bans') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['match_id', 'orden::varchar', 'tipo']) }}  as id,
        match_id                                                                         as id_partida,
        null::integer                                                                    as id_jugador,
        championid::integer                                                              as id_campeon,
        tipo                                                                             as tipo_accion,
        orden::integer                                                                   as orden_secuencia,
        CASE WHEN equipo::integer = 100 THEN 'Azul' ELSE 'Rojo' END                    as lado
    from source
    where match_id is not null
      and championid is not null

)

select distinct * from renamed

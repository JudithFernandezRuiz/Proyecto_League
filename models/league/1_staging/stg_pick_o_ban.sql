with source as (
    select * from {{ source('bronze', 'raw_picks_bans') }}
),

stg_jugador as (
    select id, nombre_invocador from {{ ref('stg_jugador') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['match_id', 'orden::varchar', 'tipo']) }} as id,
        match_id as id_partida,
        summonername,  -- Agregar esta columna para el join
        championid::integer as id_campeon,
        tipo as tipo_accion,
        orden::integer as orden_secuencia,
        CASE WHEN equipo::integer = 100 THEN 'Azul' ELSE 'Rojo' END as lado
    from source
    where match_id is not null
      and championid is not null
),

con_id_jugador as (
    select
        id,
        id_partida,
        j.id as id_jugador,  -- CAMBIO: Rellenado con JOIN
        id_campeon,
        tipo_accion,
        orden_secuencia,
        lado
    from renamed r
    left join stg_jugador j on LOWER(r.summonername) = LOWER(j.nombre_invocador)
)

select distinct * from con_id_jugador
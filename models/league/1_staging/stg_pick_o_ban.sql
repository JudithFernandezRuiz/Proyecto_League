with source as (
    select * from {{ ref('base__picks_bans') }}
),

stg_jugador as (
    select id_jugador, nombre_invocador from {{ ref('stg_jugador') }}
),

with_jugador as (
    select
        source.*,
        j.id_jugador
    from source
    left join stg_jugador j on LOWER(source.summonername) = LOWER(j.nombre_invocador)
),

deduplicado as (
    select *,
        ROW_NUMBER() OVER (PARTITION BY match_id, orden, tipo, summonername ORDER BY match_id) as rn
    from with_jugador
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['match_id', 'orden::varchar', 'tipo', 'summonername']) }} as id,
        match_id as id_partida,
        id_jugador,
        championid::integer as id_campeon,
        tipo as tipo_accion,
        orden::integer as orden_secuencia,
        CASE WHEN equipo::integer = 100 THEN 'Azul' ELSE 'Rojo' END as lado
    from deduplicado
    where rn = 1
)

select * from final
with source as (
    select 
        match_id,
        summonername,
        orden,
        tipo,
        championid,
        equipo
    from {{ ref('base__picks_bans') }}
),

stg_jugador as (
    select distinct 
        id_jugador, 
        nombre_invocador 
    from {{ ref('stg_jugador') }}
),

stg_partida as (
    select 
        id, 
        modo_juego 
    from {{ ref('stg_partida') }}
),

with_partida as (
    select
        source.match_id,
        source.summonername,
        source.orden,
        source.tipo,
        source.championid,
        source.equipo,
        
        CASE 
            WHEN p.modo_juego IN ('COMPETITIVE', 'MATCH_MAKING_BANS', '5v5_FLEX', 'RANKED_SOLO') THEN source.orden::integer
            ELSE -1
        END as orden_final
    from source
    left join stg_partida p on source.match_id = p.id
),

with_jugador as (
    select
        with_partida.match_id,
        with_partida.summonername,
        with_partida.orden_final,
        with_partida.tipo,
        with_partida.championid,
        with_partida.equipo,
        j.id_jugador,
        ROW_NUMBER() OVER (
            PARTITION BY with_partida.match_id, with_partida.orden_final, with_partida.tipo, LOWER(with_partida.summonername) 
            ORDER BY with_partida.match_id
        ) as rn
    from with_partida
    
    left join stg_jugador j on 
        LOWER(TRIM(SPLIT_PART(with_partida.summonername, '#', 1))) = LOWER(TRIM(SPLIT_PART(j.nombre_invocador, '#', 1)))
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['match_id', 'orden_final::varchar', 'tipo', 'summonername']) }} as id,
        match_id as id_partida,
        id_jugador,
        championid::integer as id_campeon,
        tipo as tipo_accion,
        orden_final as orden_secuencia,
        CASE WHEN equipo::integer = 100 THEN 'Azul' ELSE 'Rojo' END as lado
    from with_jugador
    where rn = 1
)

select * from final
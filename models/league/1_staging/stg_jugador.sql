with source as (
    select * from {{ ref('base__jugador') }}
),

final as (
    select
        puuid as id_jugador, -- El puuid es el rey absoluto, limpio y único
        summonername as nombre_invocador,
        elo,
        tier,
        lp::integer as lp
        -- Eliminamos 'lado', 'id_equipo' o cualquier dato que cambie por partida
    from source
    where puuid is not null
      and summonername is not null
    qualify ROW_NUMBER() OVER (PARTITION BY puuid ORDER BY puuid) = 1
)

select * from final
{{
    config(
        materialized='table'
    )
}}

with rendimiento as (
    select * from {{ ref('fact_rendimiento_jugador') }}
),

campeon as (
    select * from {{ ref('dim_campeon') }}
),

posicion as (
    select * from {{ ref('stg_posicion_jugador') }}
),

metricas_finales as (
    select
        c.NOMBRE AS campeon,
        p.NOMBRE_POSICION AS rol,
        COUNT(*) AS partidas_jugadas,
        SUM(CASE WHEN f.RESULTADO::varchar ILIKE 'true' THEN 1 ELSE 0 END) AS victorias,
        ROUND(
            SUM(CASE WHEN f.RESULTADO::varchar ILIKE 'true' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
            2
        ) AS winrate_pct
    from rendimiento f
    join campeon c on f.ID_CAMPEON = c.ID
    join posicion p on f.ID_POSICION_JUGADOR = p.ID
    group by c.NOMBRE, p.NOMBRE_POSICION
    having COUNT(*) > 3 -- Filtramos para exigir más de 3 partidas jugadas
),

ranking_por_rol as (
    select 
        campeon,
        rol,
        partidas_jugadas,
        victorias,
        winrate_pct,
        -- Asignamos un número de fila (1, 2, 3...) reiniciando la cuenta por cada ROL, ordenado por Winrate
        ROW_NUMBER() OVER (PARTITION BY rol ORDER BY winrate_pct DESC, partidas_jugadas DESC) as ranking_posicion
    from metricas_finales
)

select 
    campeon,
    rol,
    partidas_jugadas,
    victorias,
    winrate_pct
from ranking_por_rol
where ranking_posicion <= 3 -- Nos quedamos estrictamente con el Top 3
order by rol ASC, ranking_posicion ASC
{{
    config(
        materialized='table'
    )
}}

with fact as (

    select * from {{ ref('fact_rendimiento_jugador') }}

),

ranked as (

    select
        puuid,
        id_campeon,
        COUNT(*)                                                        as partidas_jugadas,
        SUM(CASE WHEN resultado = 'True' THEN 1 ELSE 0 END)            as victorias,
        ROUND(SUM(CASE WHEN resultado = 'True' THEN 1 ELSE 0 END) * 100.0
            / COUNT(*), 2)                                             as winrate_pct,
        RANK() OVER (PARTITION BY puuid ORDER BY COUNT(*) DESC)        as ranking_uso
    from fact
    group by puuid, id_campeon

),

final as (

    select
        puuid,
        id_campeon,
        partidas_jugadas,
        victorias,
        winrate_pct,
        ranking_uso,
        CASE WHEN ranking_uso = 1 THEN TRUE ELSE FALSE END as es_campeon_mas_jugado
    from ranked

)

select * from final
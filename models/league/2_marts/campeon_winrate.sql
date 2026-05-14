{{
    config(
        materialized='table',
        depends_on=['ref("fact_resultado_partida")']
    )
}}

with fact as (

    select * from {{ ref('fact_resultado_partida') }}

),

final as (

    select
        id_jugador,
        id_campeon,
        COUNT(*)                                                        as partidas_jugadas,
        SUM(CASE WHEN resultado = true THEN 1 ELSE 0 END)              as victorias,
        ROUND(SUM(CASE WHEN resultado = true THEN 1 ELSE 0 END) * 100.0 
            / COUNT(*), 2)                                             as winrate_pct,
        RANK() OVER (PARTITION BY id_jugador ORDER BY COUNT(*) DESC)   as ranking_uso,
        CASE WHEN RANK() OVER (PARTITION BY id_jugador 
            ORDER BY COUNT(*) DESC) = 1 THEN TRUE ELSE FALSE END       as es_campeon_mas_jugado
    from fact
    group by id_jugador, id_campeon

)

select * from final
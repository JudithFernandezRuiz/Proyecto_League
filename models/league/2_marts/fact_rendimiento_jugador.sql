{{ config(
    materialized='table'
) }}

with stg_jugador_partida as (
    select * from {{ ref('stg_jugador_partida') }}
),

stg_partida as (
    select * from {{ ref('stg_partida') }}
),

raw as (
    select 
        match_id, 
        substring(cast(puuid as string), 1, 12)     as id_jugador,
        championid,
        kills, 
        deaths, 
        assists, 
        goldearned,
        win
    from {{ source('bronze', 'raw_challenger_jugadores') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['jp.match_id', 'jp.id_jugador']) }}    as id_rendimiento_jugador,
        jp.match_id                                                                  as id_partida,
        jp.id_jugador,
        {{ dbt_utils.generate_surrogate_key(['r.championid']) }}                    as id_campeon,
        EXTRACT(YEAR FROM p.fecha_inicio)                                           as anio,
        EXTRACT(MONTH FROM p.fecha_inicio)                                          as mes,
        EXTRACT(DAY FROM p.fecha_inicio)                                            as dia,
        jp.lado,
        r.win                                                                       as resultado,
        r.kills::integer                                                            as asesinatos,
        r.deaths::integer                                                           as muertes,
        r.assists::integer                                                          as asistencias,
        r.goldearned::integer                                                       as oro_total,
        jp.id_posicion_jugador
    from stg_jugador_partida jp
    inner join stg_partida p    on p.id = jp.match_id  
    inner join raw r            on r.match_id = jp.match_id 
                                and r.id_jugador = jp.id_jugador
)

select * from final
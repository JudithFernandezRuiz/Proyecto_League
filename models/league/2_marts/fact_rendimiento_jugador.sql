{{
    config(
        materialized='incremental',
        unique_key='id',
        on_schema_change='fail'
    )
}}

with stg_jugador_partida as (
    select * from {{ ref('stg_jugador_partida') }}
),

stg_partida as (
    select * from {{ ref('stg_partida') }}
),

raw as (
    select 
        match_id, 
        puuid, 
        championid,
        kills, 
        deaths, 
        assists, 
        goldearned 
    from {{ source('bronze', 'raw_challenger_jugadores') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['jp.id_partida', 'jp.id_jugador']) }} as id,
        jp.id_partida,
        jp.id_jugador,
        r.championid::integer                                                   as id_campeon,
        EXTRACT(YEAR FROM p.fecha_inicio)                                       as anio,
        EXTRACT(MONTH FROM p.fecha_inicio)                                      as mes,
        EXTRACT(DAY FROM p.fecha_inicio)                                        as dia,
        jp.lado,
        jp.resultado,
        r.kills::integer                                                        as asesinatos,
        r.deaths::integer                                                       as muertes,
        r.assists::integer                                                      as asistencias,
        jp.id_posicion_jugador,
        r.goldearned::integer                                                   as oro_total
    from stg_jugador_partida jp
    inner join stg_partida p     on p.id = jp.id_partida
    inner join raw r             on r.match_id = jp.id_partida
                                and r.puuid = jp.id_jugador

    {% if is_incremental() %}
    where jp.id_partida not in (select distinct id_partida from {{ this }})
    {% endif %}
)

select * from final
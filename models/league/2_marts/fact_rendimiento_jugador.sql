-- models/league/2_marts/fact_rendimiento_jugador.sql
{{
    config(
        materialized='incremental',
        unique_key=['id_partida', 'puuid'],
        on_schema_change='fail'
    )
}}

with stg_jugador_partida as (
    select * from {{ ref('stg_jugador_partida') }}
),

stg_partida as (
    select * from {{ ref('stg_partida') }}
),

final as (
    select
        ROW_NUMBER() OVER (ORDER BY jp.id_partida, jp.puuid) as id,
        jp.id_partida,
        jp.puuid,
        jp.championid                          as id_campeon,
        EXTRACT(YEAR FROM p.fecha_inicio)     as anio,
        EXTRACT(MONTH FROM p.fecha_inicio)    as mes,
        EXTRACT(DAY FROM p.fecha_inicio)      as dia,
        jp.lado,
        jp.win                                 as resultado,
        CAST(jp.kills AS INTEGER)              as asesinatos,
        CAST(jp.deaths AS INTEGER)             as muertes,
        CAST(jp.assists AS INTEGER)            as asistencias,
        jp.posicion,
        CAST(jp.goldearned AS INTEGER)         as oro_total,
        jp.nombre_invocador,
        jp.championname
    from stg_jugador_partida jp
    inner join stg_partida p on p.id = jp.id_partida
    
    {% if is_incremental() %}
    where jp.id_partida not in (select distinct id_partida from {{ this }})
    {% endif %}
)

select * from final
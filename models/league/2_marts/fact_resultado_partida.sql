-- models/league/2_marts/fact_resultado_partida.sql
{{
    config(
        materialized='incremental',
        unique_key='id_partida',
        on_schema_change='fail'
    )
}}

with stg_partida as (
    select * from {{ ref('stg_partida') }}
),

final as (
    select
        p.id                                as id_partida,
        p.patch,
        p.modo_juego,
        CASE 
            WHEN LOWER(p.resultado) = 'true' THEN 'VICTORIA'
            WHEN LOWER(p.resultado) = 'false' THEN 'DERROTA'
            ELSE p.resultado 
        END                                 as resultado,
        p.fecha_inicio,
        p.fecha_fin,
        DATEDIFF(second, p.fecha_inicio, p.fecha_fin) as duracion_segundos
    from stg_partida p
    
    {% if is_incremental() %}
    where p.id not in (select id_partida from {{ this }})
    {% endif %}
)

select * from final
{{
    config(
        materialized='incremental',
        unique_key='id_partida',
        on_schema_change='fail',
        depends_on=['ref("dim_partida")']
    )
}}

with dim_partida as (

    select * from {{ ref('dim_partida') }}

),

dim_tiempo as (

    select * from {{ ref('dim_tiempo') }}

),

dim_equipo as (

    select * from {{ ref('dim_equipo') }}

),

final as (

    select
        p.id                as id_partida,
        t.id                as id_tiempo,
        e.id                as id_equipo,
        p.resultado
    from dim_partida p
    left join dim_tiempo t  on t.fecha = p.fecha_inicio::date
    left join dim_equipo e  on e.nombre = p.resultado

)

select * from final

{% if is_incremental() %}
    where id_partida not in (select distinct id_partida from {{ this }})
{% endif %}
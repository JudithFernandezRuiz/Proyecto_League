{{
    config(
        materialized='table'
    )
}}

with picks as (

    select * from {{ ref('stg_pick_o_ban') }}

),

fact as (

    select * from {{ ref('fact_resultado_partida') }}

),

dim_campeon as (

    select * from {{ ref('dim_campeon') }}

),

final as (

    select
        p.id_partida,
        p.lado,
        p.tipo_accion,
        p.orden_secuencia,
        c.nombre                as campeon,
        c.clase,
        c.rol_principal,
        f.resultado,
        f.asesinatos,
        f.muertes,
        f.asistencias,
        f.dano_campeon,
        f.oro_total
    from picks p
    join dim_campeon c  on c.id = p.id_campeon
    join fact f         on f.id_partida = p.id_partida
                       and f.id_campeon = p.id_campeon

)

select * from final
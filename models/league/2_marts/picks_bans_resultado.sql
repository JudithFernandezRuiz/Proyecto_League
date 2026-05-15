{{
    config(
        materialized='table',
        depends_on=['ref("fact_resultado_partida")']
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

dim_equipo as (

    select * from {{ ref('dim_equipo') }}

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
        e.nombre                as equipo_ganador,
        f.resultado
    from picks p
    join dim_campeon c      on c.id = p.id_campeon
    join fact f             on f.id_partida = p.id_partida
    left join dim_equipo e  on e.id = f.id_equipo

)

select * from final
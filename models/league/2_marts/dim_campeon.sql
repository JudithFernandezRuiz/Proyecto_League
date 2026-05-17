with stg_campeon as (

    select * from {{ ref('stg_campeon') }}

),

stg_clase as (

    select * from {{ ref('stg_clase_campeon') }}

),

stg_rol as (

    select * from {{ ref('stg_tipo_rol') }}

),

final as (

    select
        c.id_campeon,
        c.champion_key,
        c.nombre,
        cl.clase,
        r.rol_principal
    from stg_campeon c
    left join stg_clase cl  on cl.id_clase = c.id_clase
    left join stg_rol r     on r.id_rol = c.id_rol

)

select * from final
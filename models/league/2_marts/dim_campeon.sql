with stg_campeon as (
    select * from {{ ref('stg_campeon') }}
),

stg_clase as (
    select * from {{ ref('stg_clase_campeon') }}
),

final as (
    select
        c.id_campeon as id_campeon, -- Cambiado al identificador correcto que viene de staging
        c.nombre,
        cl.clase,
    from stg_campeon c
    left join stg_clase cl  on cl.id_clase = c.id_clase
)

select * from final
with stg_campeon as (
    select * from {{ ref('stg_campeon') }}
),

stg_clase as (
    select * from {{ ref('stg_clase_campeon') }}
),

final as (
    select
        c.id,
        c.nombre,
        cl.nombre_clase,
    from stg_campeon c
    join stg_clase cl  
    on cl.id = c.id_clase_campeon
)

select * from final
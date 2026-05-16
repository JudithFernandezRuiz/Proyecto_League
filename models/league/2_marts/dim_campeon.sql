with stg_campeon as (

    select * from {{ ref('stg_campeon') }}

),

stg_tipo_campeon as (

    select * from {{ ref('stg_tipo_campeon') }}

),

final as (

    select
        c.id,
        c.nombre,
        t.clase,
        t.rol_principal
    from stg_campeon c
    left join stg_tipo_campeon t on c.id = t.id

)

select * from final
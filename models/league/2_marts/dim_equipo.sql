with stg_equipo as (

    select * from {{ ref('stg_equipo') }}

),

final as (

    select
        id,
        nombre
    from stg_equipo

)

select * from final
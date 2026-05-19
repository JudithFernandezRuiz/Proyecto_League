with base as (
    select * from {{ ref('base__campeon_dragon') }}
),

final as (
    select
        
        id_campeon AS id,
        id_clase_campeon,
        nombre,
    from base
)

select * from final
with base as (
    select * from {{ ref('base__campeon_dragon') }}
),

final as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['rol_principal']) }}   as id_rol,
        rol_principal
    from base
    where rol_principal is not null
)

select * from final
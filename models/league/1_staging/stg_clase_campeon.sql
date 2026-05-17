with base as (

    select * from {{ ref('base__campeon_dragon') }}

),

final as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['clase']) }}   as id_clase,
        clase
    from base
    where clase is not null

)

select * from final
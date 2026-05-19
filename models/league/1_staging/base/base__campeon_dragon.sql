with source as (
    select * from {{ source('bronze', 'CAMPEON_DRAGON') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['id']) }} AS id_campeon,
        {{ dbt_utils.generate_surrogate_key(['clase']) }} AS id_clase_campeon,
        nombre,
        clase
    from source
)

select * from final
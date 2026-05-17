with source as (

    select * from {{ source('bronze', 'CAMPEON_DRAGON') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['id']) }}      as id_campeon,
        id                                                  as champion_key,
        nombre,
        clase,
        rol_principal
    from source

)

select * from final
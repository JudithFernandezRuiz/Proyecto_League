with source as (

    select * from {{ ref('base__eventos') }}

),

final as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['tipo_evento']) }}  as id,
        tipo_evento                                              as nombre
    from source
    where tipo_evento is not null

)

select * from final
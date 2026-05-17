with source as (
    select * from {{ source('bronze', 'OBJETO_ITEMS') }}
),

final as (
    select distinct
        id,
        nombre,
        costo
    from source
    where id is not null
      and nombre is not null
    
    qualify ROW_NUMBER() OVER (
        PARTITION BY id
        ORDER BY id
    ) = 1
)

select * from final
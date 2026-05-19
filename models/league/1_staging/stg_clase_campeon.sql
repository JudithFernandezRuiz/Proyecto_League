with base as (
    select * from {{ ref('base__campeon_dragon') }}
),

final as (
    select distinct
        id_clase_campeon AS id,
        CASE 
            WHEN clase = 'Assassin' THEN 'Asesino'
            WHEN clase = 'Fighter' THEN 'Luchador'
            WHEN clase = 'Mage' THEN 'Mago' 
            WHEN clase = 'Support' THEN 'Soporte' 
            WHEN clase = 'Marksman' THEN 'Tirador' 
            WHEN clase = 'Tank' THEN 'Tanque'  
        END AS nombre_clase
    from base
    where clase is not null
)

select * from final
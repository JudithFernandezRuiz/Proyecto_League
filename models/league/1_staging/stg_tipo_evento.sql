with source as (
    -- 1. Lo cogemos de la source de eventos real de forma dinámica
    select distinct tipo_evento 
    from {{ ref('base__eventos') }}
    where tipo_evento is not null
),

final as (
    select
        -- Generamos un ID secuencial único y limpio para cada tipo de evento
        row_number() over (order by tipo_evento) as id_tipo_evento,
        tipo_evento as descripcion_evento
    from source
)

-- 2. Estructura limpia: sin columnas 'id' repetidas ni nombres ambiguos
select 
    id_tipo_evento,
    descripcion_evento
from final
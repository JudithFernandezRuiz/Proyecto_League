with source as (
    -- 1. Lo cogemos de la source de eventos real
    select distinct tipo_evento 
    from {{ ref('base__eventos') }}
    where tipo_evento is not null
),

final as (
    select
        -- Generamos un ID secuencial único para cada tipo de ping real encontrado
        row_number() over (order by tipo_evento) as id_tipo_ping,
        tipo_evento as tipo
    from source
    -- Filtramos para quedarnos solo con los eventos que sean pings (según tu lista)
    where tipo_evento in (
        'allInPings', 'assistMePings', 'commandPings', 'dangerPings', 
        'enemyMissingPings', 'enemyVisionPings', 'getBackPings', 'holdPings', 
        'needVisionPings', 'onMyWayPings', 'pushPings', 'visionClearedPings', 'basicPings'
    )
)

-- 2. Quitamos la columna 'id' repetida y nos quedamos solo con la estructura limpia
select 
    id_tipo_ping,
    tipo
from final
-- 1. Definimos el catálogo de pings directamente como nuestra fuente de datos limpia
with source_pings as (
    select 'allInPings' as tipo union all
    select 'assistMePings' union all
    select 'commandPings' union all
    select 'dangerPings' union all
    select 'enemyMissingPings' union all
    select 'enemyVisionPings' union all
    select 'getBackPings' union all
    select 'holdPings' union all
    select 'needVisionPings' union all
    select 'onMyWayPings' union all
    select 'pushPings' union all
    select 'visionClearedPings' union all
    select 'basicPings'
),

final as (
    select
        -- Generamos el ID único secuencial automáticamente (así evitamos meter números a mano)
        row_number() over (order by tipo) as id_tipo_ping,
        tipo
    from source_pings
)

-- 2. Borramos el ID repetido de la versión antigua y exponemos la estructura limpia
select 
    id_tipo_ping,
    tipo
from final
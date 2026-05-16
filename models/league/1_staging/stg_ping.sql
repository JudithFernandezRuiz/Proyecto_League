-- Tabla de referencia: tipos de ping
with pings as (

    select 1 as id, 1 as id_tipo_ping, 'allInPings' as tipo
    union all
    select 2, 2, 'assistMePings'
    union all
    select 3, 3, 'commandPings'
    union all
    select 4, 4, 'dangerPings'
    union all
    select 5, 5, 'enemyMissingPings'
    union all
    select 6, 6, 'enemyVisionPings'
    union all
    select 7, 7, 'getBackPings'
    union all
    select 8, 8, 'holdPings'
    union all
    select 9, 9, 'needVisionPings'
    union all
    select 10, 10, 'onMyWayPings'
    union all
    select 11, 11, 'pushPings'
    union all
    select 12, 12, 'visionClearedPings'
    union all
    select 13, 13, 'basicPings'

)

select * from pings

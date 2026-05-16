-- Tabla de referencia: posiciones en el mapa
with posiciones as (

    select 1 as id, 'TOP' as nombre
    union all
    select 2, 'JUNGLE'
    union all
    select 3, 'MIDDLE'
    union all
    select 4, 'BOTTOM'
    union all
    select 5, 'UTILITY'

)

select * from posiciones

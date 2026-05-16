-- Tabla de referencia: equipos en League of Legends
with equipos as (

    select 100 as id, 'BLUE' as nombre
    union all
    select 200, 'RED'

)

select * from equipos

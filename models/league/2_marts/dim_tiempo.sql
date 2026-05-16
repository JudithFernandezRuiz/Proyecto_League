with stg_partida as (

    select * from {{ ref('stg_partida') }}

),

final as (

    select distinct
        ROW_NUMBER() OVER (ORDER BY fecha_inicio)   as id,
        fecha_inicio::date                          as fecha,
        YEAR(fecha_inicio)                          as anio,
        MONTH(fecha_inicio)                         as mes,
        WEEK(fecha_inicio)                          as semana,
        DAYOFWEEK(fecha_inicio)                     as dia_semana,
        CASE 
            WHEN MONTH(fecha_inicio) BETWEEN 1 AND 3 THEN 'S1'
            WHEN MONTH(fecha_inicio) BETWEEN 4 AND 6 THEN 'S2'
            WHEN MONTH(fecha_inicio) BETWEEN 7 AND 9 THEN 'S3'
            ELSE 'S4'
        END                                         as temporada
    from stg_partida
    where fecha_inicio is not null

)

select * from final
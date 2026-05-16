with stg_partida as (
    select * from {{ ref('stg_partida') }}
),

fechas_unicas as (
    select 
        -- DATE_TRUNC elimina de raíz cualquier residuo oculto de horas o zonas horarias
        DATE_TRUNC('DAY', fecha_inicio)::date as fecha
    from stg_partida
    where fecha_inicio is not null
    -- Agrupamos inmediatamente aquí para garantizar 1 sola fila por día físico
    group by 1
),

final as (
    select
        fecha,
        YEAR(fecha)                          as anio,
        MONTH(fecha)                         as mes,
        WEEK(fecha)                          as semana,
        DAYOFWEEK(fecha)                     as dia_semana,
        CASE 
            WHEN MONTH(fecha) BETWEEN 1 AND 3 THEN 'S1'
            WHEN MONTH(fecha) BETWEEN 4 AND 6 THEN 'S2'
            WHEN MONTH(fecha) BETWEEN 7 AND 9 THEN 'S3'
            ELSE 'S4'
        END                                  as temporada
    from fechas_unicas
)

select * from final
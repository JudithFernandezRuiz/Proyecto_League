with source as (
    select * from {{ ref('base__jugador_partida') }}
),

stg_posicion_jugador AS (
    SELECT DISTINCT
        id_posicion_jugador AS id,
        CASE
            WHEN teamposition = 'JUNGLE' THEN 'Jungla'
            WHEN teamposition = 'MIDDLE' THEN 'Medio'
            WHEN teamposition = 'BOTTOM' THEN 'ADC'
            WHEN teamposition = 'UTILITY' THEN 'Support'
            ELSE 'Top'
        END AS nombre_posicion
    FROM source
) SELECT * FROM stg_posicion_jugador
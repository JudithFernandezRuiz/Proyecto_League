{{
    config(
        materialized='incremental',
        unique_key='id_evento',
        incremental_strategy='delete+insert',
        on_schema_change='fail'
    )
}}

with source as (
    select * from {{ ref('base__eventos') }}
    
    {% if is_incremental() %}
      -- Filtramos el origen para procesar solo las partidas que NO tengamos ya guardadas
      where match_id not in (select distinct id_partida from {{ this }})
    {% endif %}
),

-- Traemos los datos de jugador_partida originales para mapear el participantid con el PUUID real
participantes as (
    select match_id, participantid, puuid 
    from {{ ref('base__jugador_partida') }}
),

final as (
    select
        -- ID compuesto único según tus notas utilizando el PUUID
        {{ dbt_utils.generate_surrogate_key([
            'source.match_id',
            'p.puuid',
            'source.timestamp_ms',
            'source.tipo_evento'
        ]) }} as id_evento,
        
        source.match_id as id_partida,
        p.puuid as id_jugador, -- Identificador único real (PUUID) mapeado
        {{ dbt_utils.generate_surrogate_key(['source.tipo_evento']) }} as id_tipo_evento,
        
        -- Fecha/Hora bien casteada según tu nota
        TO_TIMESTAMP(source.timestamp_ms::bigint / 1000) as tiempo_partida,
        (source.timestamp_ms::bigint / 1000 / 60)::integer as minuto_partida, -- Minuto de juego
        
        -- Datos contextuales del evento limpios de texto repetido
        source.killerid,
        source.victimid,
        source.itemid,
        source.skillslot,
        source.position_x,
        source.position_y
    from source
    left join participantes p 
        on source.match_id = p.match_id 
        and source.participantid::integer = p.participantid::integer
    where source.timestamp_ms is not null
      and source.tipo_evento is not null
      and p.puuid is not null
)

select * from final
qualify ROW_NUMBER() OVER (PARTITION BY id_evento ORDER BY id_partida) = 1
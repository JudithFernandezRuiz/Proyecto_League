{{ config(
    materialized='incremental',
    incremental_strategy='append',
    on_schema_change='sync_all_columns'
) }}

with source as (
    select * from {{ ref('base__eventos') }}
),

participantes as (
    select * from {{ ref('base__jugador_partida') }}
),

stg_partida as (
    select * from {{ ref('stg_partida') }}
),

final as (
    select
        
        {{ dbt_utils.generate_surrogate_key([
            'substring(cast(p.puuid as string), 1, 12)',
            'source.match_id',
            'source.timestamp_ms',
            'source.tipo_evento'
        ]) }} as id_evento,
        
        source.match_id                                                                 as id_partida,
        substring(cast(p.puuid as string), 1, 12)                                       as id_jugador,
        
        -- Removed the single quotes around millisecond
        DATEADD(millisecond, 
            source.timestamp_ms::bigint, 
            sp.fecha_inicio)                                                            as tiempo_partida,
            
        {{ dbt_utils.generate_surrogate_key(['source.tipo_evento']) }}  as id_tipo_evento,
        source.tipo_evento                                                              as descripcion_evento
        
    from source
   
    left join participantes p 
        on source.match_id = p.match_id 
        and source.participantid::integer = p.participantid::integer
    
    inner join stg_partida sp
        on sp.id = source.match_id
        
    where source.timestamp_ms is not null
      and source.tipo_evento is not null
      
    {% if is_incremental() %}
      and source.match_id not in (select distinct id_partida from {{ this }})
    {% endif %}
    
    qualify ROW_NUMBER() OVER (
        PARTITION BY substring(cast(p.puuid as string), 1, 12), source.match_id, source.timestamp_ms, source.tipo_evento
        ORDER BY source.match_id
    ) = 1
)

select * from final
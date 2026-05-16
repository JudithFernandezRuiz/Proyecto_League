{{
    config(
        materialized='incremental',
        unique_key='id',
        incremental_strategy='append',
        on_schema_change='fail'
    )
}}

with source as (
    select * from {{ source('bronze', 'raw_eventos') }}
),

renamed as (
    select
        row_number() over (order by match_id, timestamp_ms) as id,
        participantid::integer as id_jugador,
        match_id as id_partida,
        to_timestamp(timestamp_ms::bigint / 1000) as tiempo_partida,
        row_number() over (partition by match_id order by timestamp_ms) as id_tipo_evento
    from source
    where participantid is not null 
      and participantid != ''
)

select distinct * from renamed

{% if is_incremental() %}
    where tiempo_partida > (select max(tiempo_partida) from {{ this }})
{% endif %}

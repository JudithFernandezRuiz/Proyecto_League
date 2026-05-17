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

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key([
            'match_id',
            'timestamp_ms',
            'tipo_evento',
            'participantid',
            'killerid',
            'victimid',
            'itemid',
            'skillslot'
        ]) }}                                                   as id_evento,
        participantid::integer                                  as id_jugador,
        match_id                                                as id_partida,
        TO_TIMESTAMP(timestamp_ms::bigint / 1000)               as tiempo_partida,
        {{ dbt_utils.generate_surrogate_key(['tipo_evento']) }} as id_tipo_evento
    from source
    where participantid is not null
      and participantid != ''
      and timestamp_ms is not null

)

select * from final

{% if is_incremental() %}
    where id_partida not in (select distinct id_partida from {{ this }})
{% endif %}
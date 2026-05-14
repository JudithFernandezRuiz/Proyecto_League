{{
    config(
        materialized='incremental',
        unique_key='id_partida',
        on_schema_change='fail'
    )
}}

with source as (

    select * from {{ source('bronze', 'evento_partida') }}

),

renamed as (

    select
        id_jugador,
        id_partida,
        tiempo_partida,
        id_tipo_evento
    from source
    where id_jugador is not null

)

select distinct * from renamed

{% if is_incremental() %}
    where id_partida not in (select distinct id_partida from {{ this }})
{% endif %}
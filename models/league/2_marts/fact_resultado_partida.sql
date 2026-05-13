{{
    config(
        materialized='incremental',
        unique_key='id',
        on_schema_change='fail'
    )
}}

with stg_jugador_partida as (

    select * from {{ ref('stg_jugador_partida') }}

),

stg_challenger_raw as (

    select * from {{ source('bronze', 'stg_challenger_raw') }}

),

dim_jugador as (

    select * from {{ ref('dim_jugador') }}

),

dim_campeon as (

    select * from {{ ref('dim_campeon') }}

),

dim_partida as (

    select * from {{ ref('dim_partida') }}

),

dim_tiempo as (

    select * from {{ ref('dim_tiempo') }}

),

final as (

    select
        ROW_NUMBER() OVER (ORDER BY r.match_id, r.puuid)    as id,
        r.match_id                                          as id_partida,
        j.id                                                as id_jugador,
        c.id                                                as id_campeon,
        t.id                                                as id_tiempo,
        jp.lado,
        r.win::boolean                                      as resultado,
        r.kills::integer                                    as asesinatos,
        r.deaths::integer                                   as muertes,
        r.assists::integer                                  as asistencias,
        r.totaldamagedealttochampions::integer              as dano_campeon,
        r.goldearned::integer                               as oro_total,
        r.teamposition                                      as posicion,
        r.visionscore::integer                              as vision_score
    from stg_challenger_raw r
    join dim_jugador j          on j.puuid = r.puuid
    join dim_campeon c          on c.id = r.championid::integer
    join dim_partida p          on p.id = r.match_id
    join dim_tiempo t           on t.fecha = p.fecha_inicio::date
    join stg_jugador_partida jp on jp.id_jugador = j.id 
                                and jp.id_partida = r.match_id

)

select * from final

{% if is_incremental() %}
    where id_partida not in (select distinct id_partida from {{ this }})
{% endif %}
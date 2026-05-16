with stg_jugador as (

    select * from {{ ref('stg_jugador') }}

),

stg_equipo as (

    select * from {{ ref('stg_equipo') }}

),

final as (

    select
        j.id,
        j.nombre_invocador,
        j.puuid,
        j.elo,
        j.tier,
        j.lp,
        e.nombre as equipo
    from stg_jugador j
    left join stg_equipo e on j.id_equipo = e.id

)

select * from final
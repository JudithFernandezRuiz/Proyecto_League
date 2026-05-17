with stg_jugador as (

    select * from {{ ref('stg_jugador') }}

),

final as (

    select
        id_jugador,
        nombre_invocador,
        puuid,
        elo,
        tier,
        lp
    from stg_jugador

)

select * from final
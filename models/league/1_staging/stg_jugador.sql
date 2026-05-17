with source as (

    select * from {{ source('bronze', 'jugador') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['puuid']) }}   as id_jugador,
        puuid,
        nombre_invocador,
        elo,
        tier,
        lp::integer                                         as lp
    from source
    where puuid is not null
      and nombre_invocador is not null
    qualify ROW_NUMBER() OVER (PARTITION BY puuid ORDER BY puuid) = 1

)

select * from final
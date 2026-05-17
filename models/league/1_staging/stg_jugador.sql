with source as (
    select * from {{ ref('base__jugador') }}
),

final as (
    select
        -- Tu regla: nos quedamos con el puuid haciéndole un cast para que sea legible
        substring(cast(puuid as string), 1, 12) as id_jugador, 
        summonername as nombre_invocador,
        elo,
        tier,
        lp::integer as lp
    from source
    where puuid is not null
      and summonername is not null
    
    qualify ROW_NUMBER() OVER (PARTITION BY id_jugador ORDER BY lp desc) = 1
)

select * from final
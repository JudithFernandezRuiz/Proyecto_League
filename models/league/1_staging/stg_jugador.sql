with source as (

    select * from {{ source('bronze', 'raw_challenger_jugadores') }}

),

renamed as (

    select
        row_number() over (order by puuid) as id,
        case when participantid::integer <= 5 then 100 else 200 end as id_equipo,
        summonername as nombre_invocador,
        puuid,
        elo,
        tier,
        lp::integer as lp
    from source
    where puuid is not null
      and summonername is not null

),

deduplicado as (

    select *,
        row_number() over (partition by puuid order by id) as rn
    from renamed

)

select
    id,
    id_equipo,
    nombre_invocador,
    puuid,
    elo,
    tier,
    lp
from deduplicado
where rn = 1

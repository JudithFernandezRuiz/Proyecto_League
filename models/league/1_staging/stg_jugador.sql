with 

source as (

    select * from {{ source('bronze', 'jugador') }}

),

renamed as (

    select
        id,
        id_equipo,
        nombre_invocador,
        puuid,
        elo,
        tier,
        lp
    from source
    where puuid is not null
      and nombre_invocador is not null

),

deduplicado as (

    select *,
        ROW_NUMBER() OVER (PARTITION BY puuid ORDER BY id) as rn
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
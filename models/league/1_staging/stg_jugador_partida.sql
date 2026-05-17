with source as (
    select * from {{ ref('base__jugador_partida') }}
),

final as (
    select
        match_id, 
        
        substring(cast(puuid as string), 1, 12) as id_jugador,
        participantid::integer as id_participante
    from source
    where puuid is not null
      and match_id is not null 
     
      and participantid::integer <= 300 
)

select * from final
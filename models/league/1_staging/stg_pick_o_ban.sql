with source as (

    select * from {{ source('bronze', 'raw_picks_bans') }}

),

renamed as (

    select
        row_number() over (order by match_id, orden) as id,
        match_id as id_partida,
        -- El id_jugador se obtiene del summonerName en el join con stg_jugador
        -- Lo dejamos como null por ahora ya que necesita join
        null::integer as id_jugador,
        championid::integer as id_campeon,
        tipo as tipo_accion,
        orden::integer as orden_secuencia,
        case when equipo = '100' then 'BLUE' else 'RED' end as lado
    from source
    where match_id is not null
      and championid is not null

)

select distinct * from renamed

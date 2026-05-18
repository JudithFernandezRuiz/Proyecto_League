with source as (

    select * from {{ source('bronze', 'raw_eventos') }}

),

final as (

    select
        match_id,
        timestamp_ms,
        tipo_evento,
        participantid,
        killerid,
        victimid,
        itemid,
        skillslot,
        leveluptype,
        wardtype,
        buildingtype,
        towertype,
        lanetype,
        monstertype,
        monstersubtype,
        teamid,
        position_x,
        position_y,
        bounty,
        shutdownbounty,
        killtype
    from source
   
    
    qualify ROW_NUMBER() OVER (
        PARTITION BY match_id, timestamp_ms, tipo_evento, participantid, killerid, victimid, itemid, skillslot
        ORDER BY timestamp_ms ASC
    ) = 1

)

select * from final
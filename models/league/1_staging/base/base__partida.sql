with source as (
    select * from {{ source('bronze', 'raw_challenger_jugadores') }}
),

final as (
    select distinct
        match_id,
        gameversion,
        queueid,
        gamestarttimestamp,
        gameduration
    from source
    where match_id is not null
    
    qualify ROW_NUMBER() OVER (
        PARTITION BY match_id
        ORDER BY match_id
    ) = 1
)

select * from final
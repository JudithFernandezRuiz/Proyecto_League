WITH kills_resumen AS (
    SELECT 
        match_id,
        CAST(participantId AS INT) AS participantId,
        kills AS total_kills_resumen
    FROM {{ source('bronze', 'raw_challenger_jugadores') }}
),

kills_eventos AS (
    SELECT 
        match_id,
        CAST(killerId AS INT) AS participantId,
        COUNT(*) AS total_kills_eventos
    FROM {{ source('bronze', 'raw_eventos') }}
    WHERE tipo_evento = 'CHAMPION_KILL'
    GROUP BY 
        match_id, 
        killerId
)

SELECT 
    r.match_id,
    r.participantId,
    r.total_kills_resumen,
    COALESCE(e.total_kills_eventos, 0) AS total_kills_eventos
FROM kills_resumen r
LEFT JOIN kills_eventos e
    ON r.match_id = e.match_id 
    AND r.participantId = e.participantId
WHERE r.total_kills_resumen != COALESCE(e.total_kills_eventos, 0)
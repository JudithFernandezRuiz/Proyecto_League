select *
from {{ ref('fact_rendimiento_jugador') }}
where resultado is not null
  and resultado not in ('True', 'False', 'true', 'false')
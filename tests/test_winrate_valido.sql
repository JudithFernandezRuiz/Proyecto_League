-- Test singular: el resultado solo puede ser TRUE o FALSE (ganó o perdió)
select *
from {{ ref('fact_resultado_partida') }}
where resultado is not null
  and resultado not in (true, false)
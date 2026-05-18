with source as (
   
    
    select distinct tipo_evento 
    from {{ ref('base__eventos') }}
    where tipo_evento is not null
),

final as (
    select
        
        row_number() over (order by tipo_evento) as id_tipo_evento,
        tipo_evento as descripcion_evento
    from source
)


select 
    id_tipo_evento,
    descripcion_evento
from final
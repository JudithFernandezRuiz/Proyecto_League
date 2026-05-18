with base as (
    select * from {{ ref('base__campeon_dragon') }}
),

clase as (
    select * from {{ ref('stg_clase_campeon') }}
),

rol as (
    select * from {{ ref('stg_tipo_rol') }}
),

final as (
    select
        
        {{ dbt_utils.generate_surrogate_key([
            'base.champion_key', 
            'base.clase'
        ]) }} as id_campeon,
        
       
        base.nombre,
        clase.id_clase,
        rol.id_rol
    from base
    left join clase on clase.clase = base.clase
    left join rol on rol.rol_principal = base.rol_principal
)

select * from final
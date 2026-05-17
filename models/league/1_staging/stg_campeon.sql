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
        -- CAMBIO: MD5 de id + clase como id_tipo_campeon
        MD5(CAST(base.champion_key AS VARCHAR) || base.clase) as id_tipo_campeon,
        base.champion_key,
        base.nombre,
        clase.id_clase,
        rol.id_rol
    from base
    left join clase on clase.clase = base.clase
    left join rol on rol.rol_principal = base.rol_principal
)

select * from final
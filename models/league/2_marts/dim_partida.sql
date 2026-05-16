with stg_partida as (

    select * from {{ ref('stg_partida') }}

),

deduplicado as (

    select *,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) as rn
    from stg_partida

),

final as (

    select
        id,
        patch,
        modo_juego,
        fecha_inicio,
        fecha_fin,
        resultado
    from deduplicado
    where rn = 1

)

select * from final
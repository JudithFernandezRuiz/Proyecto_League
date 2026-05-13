{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    
    {# Si el modelo tiene un schema configurado (como SILVER), úsalo tal cual #}
    {%- if custom_schema_name is not none -%}

        {{ custom_schema_name | trim }}

    {# Si no tiene schema personalizado, usa el esquema por defecto del perfil #}
    {%- else -%}

        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}
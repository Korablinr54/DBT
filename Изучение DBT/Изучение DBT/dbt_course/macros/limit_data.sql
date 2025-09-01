{% macro limit_data_days(column_name, days_number=3) %}
{% if target.name == 'dev' %}
where {{ column_name }} >= current_date - {{days_number}}
{% endif %}
{% endmacro %}
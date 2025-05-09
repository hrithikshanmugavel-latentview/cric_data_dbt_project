-- models/stadium_info.sql
{{ config(
    materialized='table'
) }}

WITH new_stadiums AS (
    SELECT DISTINCT
        MD5(CONCAT(
            COALESCE(venue, 'NULL'), '|',
            COALESCE(city, 'NULL')
        )) AS stadium_id,
        venue AS stadium_name,
        city AS stadium_city
    FROM
        {{ source('cricket_ipl_db', 'ipl_match_data') }}
)

-- Select clause depends on whether it's an incremental run or a full refresh.
SELECT
    ns.stadium_id,
    ns.stadium_name,
    ns.stadium_city
FROM
    new_stadiums ns
ORDER By ns.stadium_name, ns.stadium_city    

-- -- For incremental loads, filter out records that are already in the table.
-- {% if is_incremental() %}
--     LEFT JOIN {{ this }} existing
--         ON ns.stadium_id = existing.stadium_id
--     WHERE existing.stadium_id IS NULL
-- {% endif %}

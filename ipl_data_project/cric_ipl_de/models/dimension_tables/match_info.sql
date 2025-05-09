-- models/match_data.sql
{{config(
    MATERIALIZED="table",
    unique_key='match_id'
)}}
WITH match_data AS (
    SELECT
        cmd.*,
        ev.event_id,
        t1.team_id AS team_1_id,
        t2.team_id AS team_2_id,
        std.stadium_id
    FROM
        {{ source('cricket_ipl_db', 'ipl_match_data') }} AS cmd
    LEFT JOIN {{ ref('event_info') }} AS ev
        ON MD5(concat(
            COALESCE(cmd.event_name, 'NULL'), '|',
            COALESCE(cmd.season, 'NULL'), '|',
            COALESCE(cmd.match_type, 'NULL'), '|',
            COALESCE(cmd.gender, 'NULL'), '|',
            COALESCE(cmd.overs, 0), '|',
            COALESCE(cmd.team_type, 'NULL'), '|',
            COALESCE(cmd.balls_per_over, 0)
        )) = ev.event_id   
    LEFT JOIN {{ ref('team_info') }} AS t1
        ON MD5(concat(COALESCE(cmd.team_1, 'NULL'), '|', COALESCE(cmd.team_type, 'NULL'))) = t1.team_id
    LEFT JOIN {{ ref('team_info') }} AS t2
        ON MD5(concat(COALESCE(cmd.team_2, 'NULL'), '|', COALESCE(cmd.team_type, 'NULL'))) = t2.team_id
    LEFT JOIN {{ ref('stadium_info') }} AS std
        ON MD5(concat(COALESCE(cmd.venue, 'NULL'), '|', COALESCE(cmd.city, 'NULL'))) = std.stadium_id
)

SELECT DISTINCT
    match_id,
    dates_1,
    dates_2,
    dates_3,
    dates_4,
    dates_5,
    dates_6,
    event_id,
    match_number,
    team_1_id,
    team_2_id,
    event_stage,
    match_type_number,
    match_referees_id,
    tv_umpires_id,
    umpire_1_id,
    umpire_2_id,
    reserve_umpires_id,
    stadium_id
FROM
    match_data AS cmd

-- Append only new records
-- {% if is_incremental() %}
-- WHERE
--     MD5(concat(
--         COALESCE(dates_1, 'NULL'), '|', 
--         COALESCE(dates_2, 'NULL'), '|',
--         COALESCE(dates_3, 'NULL'), '|',
--         COALESCE(dates_4, 'NULL'), '|',
--         COALESCE(dates_5, 'NULL'), '|',
--         COALESCE(dates_6, 'NULL'), '|',
--         COALESCE(match_number, 0), '|',
--         COALESCE(event_stage, 'NULL'), '|',
--         COALESCE(match_type_number, 0), '|',
--         COALESCE(match_referees, 'NULL'), '|',
--         COALESCE(tv_umpires, 'NULL'), '|',
--         COALESCE(umpire_1, 'NULL'), '|',
--         COALESCE(umpire_2, 'NULL'), '|',
--         COALESCE(reserve_umpires, 'NULL'), '|',
--         COALESCE(team_1, 'NULL'), '|',
--         COALESCE(team_2, 'NULL'), '|',
--         COALESCE(venue, 'NULL'), '|',
--         COALESCE(city, 'NULL')
--     )) NOT IN (SELECT DISTINCT match_id FROM {{ this }})
-- {% endif %}

-- models/match_data.sql

WITH match_data AS (
    SELECT
        cmd.*,
        ev.event_id,
        t1.team_id AS team_1_id,
        t2.team_id AS team_2_id,
        std.stadium_id
    FROM
        `cricket_ipl_db`.`ipl_match_data` AS cmd
    LEFT JOIN `cricket_ipl_db`.`event_info` AS ev
        ON MD5(concat(
            COALESCE(cmd.event_name, 'NULL'), '|',
            COALESCE(cmd.season, 'NULL'), '|',
            COALESCE(cmd.match_type, 'NULL'), '|',
            COALESCE(cmd.gender, 'NULL'), '|',
            COALESCE(cmd.overs, 0), '|',
            COALESCE(cmd.team_type, 'NULL'), '|',
            COALESCE(cmd.balls_per_over, 0)
        )) = ev.event_id   
    LEFT JOIN `cricket_ipl_db`.`team_info` AS t1
        ON MD5(concat(COALESCE(cmd.team_1, 'NULL'), '|', COALESCE(cmd.team_type, 'NULL'))) = t1.team_id
    LEFT JOIN `cricket_ipl_db`.`team_info` AS t2
        ON MD5(concat(COALESCE(cmd.team_2, 'NULL'), '|', COALESCE(cmd.team_type, 'NULL'))) = t2.team_id
    LEFT JOIN `cricket_ipl_db`.`stadium_info` AS std
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
-- 
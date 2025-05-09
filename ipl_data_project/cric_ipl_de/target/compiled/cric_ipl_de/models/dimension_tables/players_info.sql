

WITH combined_players AS (
    SELECT team_1_player_1_id as player_id, team_1_player_1 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_2_id as player_id, team_1_player_2 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_3_id as player_id, team_1_player_3 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_4_id as player_id, team_1_player_4 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_5_id as player_id, team_1_player_5 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_6_id as player_id, team_1_player_6 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_7_id as player_id, team_1_player_7 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_8_id as player_id, team_1_player_8 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_9_id as player_id, team_1_player_9 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_10_id as player_id, team_1_player_10 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_11_id as player_id, team_1_player_11 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_1_player_12_id as player_id, team_1_player_12 AS player_name, team_1 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_1_id as player_id, team_2_player_1 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_2_id as player_id, team_2_player_2 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_3_id as player_id, team_2_player_3 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_4_id as player_id, team_2_player_4 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_5_id as player_id, team_2_player_5 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_6_id as player_id, team_2_player_6 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_7_id as player_id, team_2_player_7 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_8_id as player_id, team_2_player_8 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_9_id as player_id, team_2_player_9 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_10_id as player_id, team_2_player_10 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_11_id as player_id, team_2_player_11 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT team_2_player_12_id as player_id, team_2_player_12 AS player_name, team_2 AS team
    FROM `cricket_ipl_db`.`ipl_match_data`
)

SELECT DISTINCT
    player_id,
    player_name,
    team
FROM combined_players
WHERE player_id is NOT NULL
ORDER By player_name, team

-- For incremental loads, filter out records that are already in the table.
-- 
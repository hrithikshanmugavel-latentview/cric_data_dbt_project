
  
    

  create  table
    `cricket_ipl_db`.`match_results__dbt_tmp`
    
    
      as
    
    (
      -- models/match_results_data.sql


WITH match_results_data AS (
    SELECT
        -- Join with the Event_Info table to get event_id
        cmd.match_id,
        ev.event_id,
        t1.team_id AS team_1,
        t2.team_id AS team_2,
        toss_win.team_id AS toss_winner,
        cmd.toss_decision,
        cmd.match_result,
        win.team_id AS winner,
        cmd.by_innings,
        cmd.by_wickets,
        cmd.by_runs,
        cmd.method,
        cmd.player_of_match_id as player_of_match
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
            COALESCE(cmd.balls_per_over, 0))
        ) = ev.event_id
    LEFT JOIN `cricket_ipl_db`.`team_info` AS t1
        ON MD5(concat(COALESCE(cmd.team_1, 'NULL'), '|', COALESCE(cmd.team_type, 'NULL'))) = t1.team_id
    LEFT JOIN `cricket_ipl_db`.`team_info` AS t2
        ON MD5(concat(COALESCE(cmd.team_2, 'NULL'), '|', COALESCE(cmd.team_type, 'NULL'))) = t2.team_id
    LEFT JOIN `cricket_ipl_db`.`team_info` AS toss_win
        ON MD5(concat(COALESCE(cmd.toss_winner, 'NULL'), '|', COALESCE(cmd.team_type, 'NULL'))) = toss_win.team_id
    LEFT JOIN `cricket_ipl_db`.`team_info` AS win
        ON MD5(concat(COALESCE(cmd.winner, 'NULL'), '|', COALESCE(cmd.team_type, 'NULL'))) = win.team_id    
)

SELECT DISTINCT
    match_id,
    event_id,
    team_1,
    team_2,
    toss_winner,
    toss_decision,
    match_result,
    winner,
    by_innings,
    by_wickets,
    by_runs,
    method,
    player_of_match
FROM
    match_results_data

-- Append only new records
-- 
    )

  
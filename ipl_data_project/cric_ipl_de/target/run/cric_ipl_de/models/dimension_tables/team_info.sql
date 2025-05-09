
  
    

  create  table
    `cricket_ipl_db`.`team_info__dbt_tmp`
    
    
      as
    
    (
      -- models/team_info.sql


WITH combined_teams AS (
    -- Union of team_1 and team_2 to combine teams from both columns
    SELECT
        team_1 AS team,
        team_type
    FROM
        `cricket_ipl_db`.`ipl_match_data`
    UNION 
    SELECT
        team_2 AS team,
        team_type
    FROM
        `cricket_ipl_db`.`ipl_match_data`
)

, distinct_teams AS (
    -- Select distinct values and create unique team_id using MD5
    SELECT DISTINCT
        -- Generating unique team_id with MD5 and ensuring no null issues with COALESCE
        MD5(CONCAT(COALESCE(team, 'NULL') , '|', COALESCE(team_type, 'NULL'))) AS team_id,
        team,
        team_type
    FROM
        combined_teams
)

SELECT
    dt.team_id,
    dt.team as team_name,
    dt.team_type
FROM
    distinct_teams dt
ORDER BY dt.team    

-- -- For incremental loads, filter out records that are already in the table.
-- 
    )

  
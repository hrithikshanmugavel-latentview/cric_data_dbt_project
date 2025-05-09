
  
    

  create  table
    `cricket_ipl_db`.`referee_info__dbt_tmp`
    
    
      as
    
    (
      -- models/referee_info.sql


WITH referees AS (
    SELECT DISTINCT
        match_referees_id AS referee_id,
        match_referees AS referee_name
    FROM
        `cricket_ipl_db`.`ipl_match_data`
)

SELECT
    r.referee_id,
    r.referee_name
FROM
    referees r
ORDER BY r.referee_name    

-- For incremental loads, filter out records that are already in the table.
-- 
    )

  

  
    

  create  table
    `cricket_ipl_db`.`stadium_info__dbt_tmp`
    
    
      as
    
    (
      -- models/stadium_info.sql


WITH new_stadiums AS (
    SELECT DISTINCT
        MD5(CONCAT(
            COALESCE(venue, 'NULL'), '|',
            COALESCE(city, 'NULL')
        )) AS stadium_id,
        venue AS stadium_name,
        city AS stadium_city
    FROM
        `cricket_ipl_db`.`ipl_match_data`
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
-- 
    )

  
-- models/umpire_info.sql


WITH combined_umpires AS (
    SELECT reserve_umpires_id AS umpire_id, reserve_umpires as umpire_name
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION 
    SELECT tv_umpires_id as umpire_id, tv_umpires AS umpire_name
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT umpire_1_id as umpire_id, umpire_1 AS umpire
    FROM `cricket_ipl_db`.`ipl_match_data`
    UNION
    SELECT umpire_2_id as umpire_id, umpire_2 AS umpire
    FROM `cricket_ipl_db`.`ipl_match_data`
)

, distinct_umpires AS (
    SELECT DISTINCT
        umpire_name, umpire_id
    FROM combined_umpires
)

SELECT
    du.umpire_id,
    du.umpire_name
FROM
    distinct_umpires du
WHERE du.umpire_name != '-'
ORDER BY du.umpire_name


-- -- For incremental loads, filter out records that are already in the table.
-- 
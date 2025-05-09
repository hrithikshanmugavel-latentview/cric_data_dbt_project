
      insert into `cricket_ipl_db`.`event_info` (`event_id`, `event_name`, `season`, `match_type`, `gender`, `overs`, `team_type`, `balls_per_over`)
    (
       select `event_id`, `event_name`, `season`, `match_type`, `gender`, `overs`, `team_type`, `balls_per_over`
       from `cricket_ipl_db`.`event_info__dbt_tmp`
    )
  
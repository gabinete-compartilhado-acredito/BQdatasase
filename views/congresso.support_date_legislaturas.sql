WITH d AS (
WITH dates AS (
SELECT
  GENERATE_DATE_ARRAY(DATE_TRUNC(DATE '2023-02-01', MONTH), 
                      DATE_ADD(DATE_ADD(DATE_TRUNC(CURRENT_DATE(), MONTH)
                                        , INTERVAL -40 YEAR)
                               , INTERVAL 1 DAY)
                      , INTERVAL -1 DAY)
    AS this_day,
    1 as dummy)
 
SELECT aday, 
      DATE_DIFF(DATE "2019-02-01",
       aday,
      YEAR) AS diff
FROM dates, UNNEST(this_day) as aday)

SELECT
  *,
  CASE
    WHEN d.diff BETWEEN -4 AND 0 THEN 56
    WHEN d.diff BETWEEN 1
  AND 4 THEN 55
    WHEN d.diff BETWEEN 5 AND 8 THEN 54
    WHEN d.diff BETWEEN 9
  AND 12 THEN 53
    WHEN d.diff BETWEEN 13 AND 16 THEN 52
    WHEN d.diff BETWEEN 17
  AND 20 THEN 51
    WHEN d.diff BETWEEN 21 AND 24 THEN 50
    WHEN d.diff BETWEEN 25
  AND 28 THEN 49
    WHEN d.diff BETWEEN 29 AND 32 THEN 48
  END AS legislatura,
  CASE
    WHEN d.diff BETWEEN -4 AND 0 THEN aday
    WHEN d.diff BETWEEN 1
  AND 4 THEN date_add(aday,
    INTERVAL 4 year)
    WHEN d.diff BETWEEN 5 AND 8 THEN date_add(aday,  INTERVAL 8 year)
    WHEN d.diff BETWEEN 9
  AND 12 THEN date_add(aday,
    INTERVAL 12 year)
    WHEN d.diff BETWEEN 13 AND 16 THEN date_add(aday,  INTERVAL 16 year)
    WHEN d.diff BETWEEN 17
  AND 20 THEN date_add(aday,
    INTERVAL 20 year)
    WHEN d.diff BETWEEN 21 AND 24 THEN date_add(aday,  INTERVAL 24 year)
    WHEN d.diff BETWEEN 25
  AND 28 THEN date_add(aday,
    INTERVAL 28 year)
    WHEN d.diff BETWEEN 29 AND 32 THEN date_add(aday,  INTERVAL 32 year)
  END AS data_displaced
FROM
  d


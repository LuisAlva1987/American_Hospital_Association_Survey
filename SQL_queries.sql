-- Hospital Performance

--How many hospitals participated each year survey was conducted?
SELECT
  release_period,
  COUNT(facility_id) AS hospital_count
FROM
  luisalva.hopitals_patients_survey.responses
GROUP BY
  release_period
ORDER BY
  release_period DESC;

--How many hospitals per state participated in the lastest survey?
  SELECT
    state,
    COUNT(facility_id) AS hospital_count
  FROM
    luisalva.hopitals_patients_survey.responses
  WHERE release_period = '07_2023'
  GROUP BY
    state
  ORDER BY 
    state;

--What is the average state hospital participation all year surveyed?
WITH
  state_count AS (
  SELECT
    state,
    COUNT(facility_id) AS facility_count
  FROM
    luisalva.hopitals_patients_survey.responses
  GROUP BY
    state)

  SELECT
    state,
    ROUND(facility_count/(SELECT
                            COUNT(DISTINCT release_period)
                          FROM
                            luisalva.hopitals_patients_survey.responses), 2) AS avg_facility_count
  FROM
    state_count
  ORDER BY
    state;

--How hospitals participation has been performing? How volume of participation has increase or decrease over the years?
WITH
  year_count AS (
  SELECT
    release_period,
    COUNT(facility_id) AS facility_count
  FROM
    luisalva.hopitals_patients_survey.responses
  GROUP BY
    release_period )
SELECT
  release_period,
  facility_count,
  facility_count - LAG(facility_count, 1) OVER (ORDER BY release_period) AS yearly_change
FROM
  year_count
ORDER BY
  release_period;

--State Performance

--What is the average state response rate for all years surveyed?
SELECT
  state,
  ROUND(AVG(response_rate), 2) AS response_rate
FROM
  luisalva.hopitals_patients_survey.responses
GROUP BY
  state
ORDER BY
  response_rate DESC;

--What states have the highest average response rate for each survey year?
WITH
  FIRST AS (
SELECT
  state,
  release_period,
  ROUND(AVG(CAST(response_rate AS int)), 2) AS avg_response_rate
FROM
  luisalva.hopitals_patients_survey.responses
GROUP BY
  state,
  release_period
ORDER BY
  state,
  release_period)

SELECT
  f.state,
  f.release_period,
  f.avg_response_rate
FROM
  FIRST f
INNER JOIN (
  SELECT
    release_period,
    MAX(avg_response_rate) AS max_avg_response_rate
  FROM
    FIRST
  GROUP BY
    release_period) AS fi
ON
  f.avg_response_rate = fi.max_avg_response_rate
ORDER BY
  release_period DESC;


--Area/Measure Performance

--How many areas are measured in the survey?
SELECT
  DISTINCT measure AS area_measured
FROM
  luisalva.hopitals_patients_survey.measures

--What are the areas measured results nationally for last year?
SELECT
  nr.release_period,
  m.measure AS area_measured,
  nr.bottom_box_percentage AS poor,
  nr.middle_box_percentage AS fair,
  nr.top_box_percentage AS good
FROM
  luisalva.hopitals_patients_survey.measures m
JOIN
  luisalva.hopitals_patients_survey.national_results nr
ON
  m.measure_id = nr.measure_id
JOIN
  luisalva.hopitals_patients_survey.reports r
ON
  nr.release_period = r.release_period
WHERE
  nr.release_period = '07_2023'

--What is the area that received the highest poor measure in the latest survey?
SELECT
  nr.release_period,
  m.measure AS measure,
  nr.bottom_box_percentage AS poor,
FROM
  luisalva.hopitals_patients_survey.measures m
JOIN
  luisalva.hopitals_patients_survey.national_results nr
ON
  m.measure_id = nr.measure_id
JOIN
  luisalva.hopitals_patients_survey.reports r
ON
  nr.release_period = r.release_period
WHERE
  nr.release_period = '07_2023'
ORDER BY
  poor DESC;

--What is the area that received the highest good measure in the latest survey?
SELECT
  nr.release_period,
  m.measure AS measure,
  nr.top_box_percentage AS good,
FROM
  luisalva.hopitals_patients_survey.measures m
JOIN
  luisalva.hopitals_patients_survey.national_results nr
ON
  m.measure_id = nr.measure_id
JOIN
  luisalva.hopitals_patients_survey.reports r
ON
  nr.release_period = r.release_period
WHERE
  nr.release_period = '07_2023'
ORDER BY
  good DESC;

--what area/measure had the lowest average for all surveys?


--Are there any specific areas where hospitals have made more progress than others?
--All areas received an average of ##% poor rating which is good to start with.
--Have hospitals' HCAHPS scores improved over the past 9 years?
--What recommendations can you make to hospitals to help them further improve the patient experience?

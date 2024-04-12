-- Hospital Performance

--How many hospitals participated in the latest survey?
SELECT
  COUNT(facility_id) AS hospital_id
FROM
  luisalva.hopitals_patients_survey.responses
WHERE
  release_period = '07_2023'; 

--What is the state with best participation of hospitals over the years?
SELECT
  state,
  COUNT(facility_id) AS facility_count
FROM
  luisalva.hopitals_patients_survey.responses
GROUP BY
  state
ORDER BY
  facility_count DESC
LIMIT
  1;

--What were the years with the highest and lowest hospitals survey participation?
SELECT
  release_period,
  COUNT(facility_id) facility_count
FROM
  luisalva.hopitals_patients_survey.responses
GROUP BY
  release_period
ORDER BY
  facility_count DESC;

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

--What state has the highest average response rate all years combined? What state has the lowest?
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

--What states had the most complited surveys?


--What state has the best response rate?
--What state has the worst average and the best average


--Have hospitals' HCAHPS scores improved over the past 9 years?

--What recommendations can you make to hospitals to help them further improve the patient experience?

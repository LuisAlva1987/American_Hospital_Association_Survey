-- Hospital Performance

--How many hospitals participated in the latest survey?
SELECT
  COUNT(facility_id) AS hospital_id
FROM
  luisalva.hopitals_patients_survey.responses
WHERE
  release_period = '07_2023'; 

--What is the state with most participation of hospitals over the years?
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



--Have hospitals' HCAHPS scores improved over the past 9 years?

--What recommendations can you make to hospitals to help them further improve the patient experience?

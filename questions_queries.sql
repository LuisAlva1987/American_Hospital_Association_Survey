-- Hospital Performance

--How many hospitals participated in the latest survey?
SELECT
  COUNT(facility_id) AS hospital_id
FROM
  luisalva.hopitals_patients_survey.responses
WHERE
  release_period = '07_2023'; 


--What was the year where most hospitals participated in the survey?


--How hospitals participation has been performing? how volume of participation has increase or decrease over the years? Do a function window maybe.

--What recommendations can you make to hospitals to help them further improve the patient experience?

--Have hospitals' HCAHPS scores improved over the past 9 years?

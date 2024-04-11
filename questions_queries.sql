-- Hospital Performance

--How many hospitals participated in the latest survey?
SELECT
  COUNT(facility_id) AS hospital_id
FROM
  luisalva.hopitals_patients_survey.responses
WHERE
  release_period = '07_2023'; 

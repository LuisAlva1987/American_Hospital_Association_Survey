# American Hospital Association Sirveys Data Analysis

## About

American Hospital Association (AHA) is a national organization that represents hospitals and their patients, and acts as a source of information on health care issues and trends. Each year AHA produces the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS) survey. The intent of the HCAHPS initiative is to provide a standardized survey instrument for measuring patients’ perspectives on hospital care in order to create incentives for hospitals to improve their quality of care. 
The purpose of this analysis is to analyze the results for the last 9 years aiming to answer the following questions:
Have hospitals' HCAHPS scores improved over the past 9 years?
1. What areas/measures received the worst results in the last released survey?
2. Are there any specific areas where hospitals have made more progress than others?
3. Are there any major areas of opportunity remaining?
4. What recommendations can you make to hospitals to help them further improve the patient experience?


## About Data

The HCAHPS survey data base contains seven tables:
* Questions - Questions asked to patients as it appears on the HCAHPS survey.
* Measures - Hospital areas measured in the survey such as 'Communication with Nurses' and 'Responsiveness of Hospital Staff'.
* Report - Survey results released periods.
* State - State abbreviation for the 50 US States (plus DC - District of Columbia).
* Responses - Surveys completed and response rates from patients by facility.
* State Results - Survey results by state.
* National Results - Survey results nationally.

The following is the entity relationship diagram that shows each how these tables relate to each other.
![image](https://github.com/Luis102487/patients_survey/assets/96627296/4de6a7fd-f3fc-4ab2-bc26-fff8c5d04614)

1. What areas/measures received the worst results in the last released survey

   SELECT
  nr.release_period,
  r.start_date,
  r.end_date,
  m.measure,
  nr.bottom_box_percentage AS never,
  nr.middle_box_percentage AS usually,
  nr.top_box_percentage AS always
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
  never


try some feature engeenering maybe

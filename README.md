# American Hospital Association Survey Data Analysis

American Hospital Association (AHA) is a national organization that represents hospitals and their patients, and acts as a source of information on health care issues and trends. Each year AHA produces the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS) survey. The intent of the HCAHPS initiative is to provide a standardized survey instrument for measuring patients’ perspectives on hospital care in order to create incentives for hospitals to improve their quality of care. 
The purpose of this analysis is to analyze the results for the last 9 years aiming to answer the following questions:

1. How many areas are measured in the survey?
2. How many years of survey are available in the data?
3. How many hospitals are measured in the survey?
4. What areas measured received the worst and best results in the lastest released survey nationally?
5. all areas received an average of ##% poor rating which is good to start with. 
7. What states had the most complited surveys?
8. What state has the best response rate?
9. What state has the worst average and the best average
10. Have hospitals' HCAHPS scores improved over the past 9 years?
11. Are there any specific areas where hospitals have made more progress than others?
12. Are there any major areas of opportunity remaining?
13. What recommendations can you make to hospitals to help them further improve the patient experience?


## About the Data

The HCAHPS survey data base contains seven tables:
* Questions - Questions asked to patients as it appears on the HCAHPS survey.
* Measures - Hospital areas measured in the survey such as 'Communication with Nurses' and 'Responsiveness of Hospital Staff'.
* Report - Survey results released periods.
* State - State abbreviation for the 50 US States (plus DC - District of Columbia).
* Responses - Surveys completed and response rates from patients by facility.
* State Results - Survey results by state.
* National Results - Survey results nationally.

The following is the entity relationship diagram that shows each how these tables relate to each other.
![image](https://github.com/Luis102487/patients_survey/assets/96627296/6e144772-3720-447c-b3c3-f3843e1b98da)


## Exploring the Data
1. How many areas are measured in the survey?
  ```sql
  SELECT
    DISTINCT measure AS area_measured
  FROM
    luisalva.hopitals_patients_survey.measures
  ```
  ![image](https://github.com/Luis102487/patients_survey/assets/96627296/05c46672-8d8f-4408-9ea6-3506889bcc7b)
> There are ten areas measured in the survey.


2. How many years of survey are available in the data?
  ```sql
  SELECT
    DISTINCT release_period,
    start_date,
    end_date
  FROM
    luisalva.hopitals_patients_survey.reports
  ORDER BY
    release_period;
  ```
  ![image](https://github.com/Luis102487/American-Hospital-Association-Survey/assets/96627296/15a395d2-f850-456c-a500-5c059cc9748d)

> There are 9 years of survey available in the survey starting in 2013 until 2022.
  
  
3. How many hospitals are measured in the survey?

4. What areas measured received the worst and best results in the lastest released survey nationally? 

```sql

SELECT
  *
FROM
  luisalva.hopitals_patients_survey.state_results
SELECT
  *
FROM
  luisalva.hopitals_patients_survey.questions
SELECT
  state,
  ROUND(AVG(response_rate AS int), 2) AS response_rate
FROM
  luisalva.hopitals_patients_survey.responses
GROUP BY
  state
ORDER BY
  response_rate DESC;

```

1. What areas measured received the worst and best results in the lastest released survey nationally? 

```sql

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
ORDER BY
  nr.release_period;

```

RESULTS 
![image](https://github.com/Luis102487/patients_survey/assets/96627296/47c269da-d1a5-444f-bb0e-839db084606c)

> According to the survey hospitals struggle in the area of 'Communication about Medicines' but excel at 'Discharge Information'
> 'Communication about Medicines' area measured received the highest poor rate with a 20% of participants surveyed stating that manage of this area was poor. Followed by 'Discharge Information' at a 14%; surprisingly this measure also received the highest good rating of all the areas measured in the latest survey. This show that for this specific measure there was not middle ground participants in the survey either like it or disliked the management of 'Discharge Information' and a lot of potential for opportunity.

try some feature engeenering maybe

# American Hospital Association Survey Data Analysis

American Hospital Association (AHA) is a national organization that represents hospitals and their patients, and acts as a source of information on health care issues and trends. Each year AHA produces the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS) survey. The intent of the HCAHPS survey is to provide an instrument for measuring patients’ perspectives on hospital care in order to create incentives for hospitals to improve their quality of care. 

The purpose of this project is to analyze the survey data for the last 9 years (2015 through 2023) using SQL to answer the following questions aiming to 
provide recomendations to improve their quality of care. 

### Hospital Performance
* Has the volume of hospital participation increase or decrease over the years? 
* What recommendations can you make to hospitals to help them further improve the patient experience?
* Have hospitals' HCAHPS scores improved over the past 9 years?

### State Performance
* What state has the highest average response rate all years combined? What state has the lowest?
* What states have the highest average response rate for each survey year?
* What states had the most complited surveys?
* What state has the best response rate?
* What state has the worst average and the best average

### Area/Measure Performance
* How many areas are measured in the survey?
* What areas measured received the worst and best results in the lastest released survey nationally?
* what area/measure had the lowest average for all surveys?
* Are there any specific areas where hospitals have made more progress than others?
* All areas received an average of ##% poor rating which is good to start with. 

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


## Questions

### Hospital Performance

* **Has the volume of hospital participation increase or decrease over the years?**

In order to find the answer to this questions, first we need find how many hospitals participated each year the survey was conducted. We can achieve this by counting facility ID grouped by release period ordering by facility ID count DESC to also find the year with the most hospital participation (query below).
  ```sql
  SELECT
     release_period AS year,
     COUNT(facility_id) AS hospital_count
  FROM
     luisalva.hopitals_patients_survey.responses
  GROUP BY
     year
  ORDER BY
     hospital_count DESC;
  ```
The results of this query shows the amount of hospitals that partcipated each year the survey was conducted and also shows that 2019 was the year that most hospitals participated in the survey with 4,895 hospitals.
  
We can also create a query to find average hospitals particpation during the years surveyed to see what years were higher or lower than the average.
  ```sql
    WITH hospitals AS (
    SELECT
      release_period AS year,
      COUNT(facility_id) AS hospital_count
    FROM
      luisalva.hopitals_patients_survey.responses
    GROUP BY
      year)

  SELECT ROUND(AVG(hospital_count), 2) AS hospital_average
  FROM hospitals;
  ```
The average hospitals participation during the years surveyed is 4,802. Most of years survey (2015 through 2023) were above the average in hospital participation, the only years lower than the average were 2015, 2016, and 2018.



* How many hospitals per state participated in the lastest survey?
  ```sql
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
  ```





1. How many areas are measured in the survey?
   ```sql
   SELECT
     DISTINCT measure AS area_measured
   FROM
     luisalva.hopitals_patients_survey.measures
   ```

2. How hospitals participation has been performing
  
  
3. What was the year where most hospitals participated in the survey?
   ```sql
   SELECT
     release_period,
     COUNT(facility_id) facility_count
   FROM
     luisalva.hopitals_patients_survey.responses
   GROUP BY
     release_period
   ORDER BY
     facility_count desc;
   ```

4. What state has the highest average response rate all years combined? What state has the lowest?
   ```sql
   SELECT
     state,
     ROUND(AVG(response_rate), 2) AS response_rate
   FROM
     luisalva.hopitals_patients_survey.responses
   GROUP BY
     state
   ORDER BY
     response_rate DESC;
   ```
5. What states have the highest average response rate for each survey year?
   ```sql
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
   ```

6. What areas measured received the worst and best results in the lastest released survey nationally? 
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

try some feature engeenering maybe
investigate window functions

dividelo by hospital performance. 
            state performance. 
            measures/areas performance.
            

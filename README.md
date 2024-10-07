## Summary

American Hospital Association (AHA) is a national organization that represents hospitals and their patients, and acts as a source of information on health care issues and trends. Each year AHA produces the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS) survey. The intent of the HCAHPS survey is to provide an instrument for measuring patients’ perspectives on hospital care in order to create incentives for hospitals to improve their quality of care. 

The purpose of this project is to analyze the survey data for the last 9 years (2015 through 2023) using SQL to answer the following questions aiming to 
provide recomendations to improve their quality of care:

* Has the volume of hospital participation increase or decrease over the years?
* What is the current state of patient involvement (surveys completed by patients in hospitals)? What recommendations can you make to have a better sense of what needs to be further improve on patient care?
* What are the measures with the lowest improvement over the years surveyed and in what specific states/region?
* What is the sentiment on patient care on each region? Are there any patterns?
* What areas measured received the worst and best results in the lastest released survey nationally? How much have they improved or declined? 
* Have hospitals' HCAHPS scores improved over the past 9 years? What is the tendency?
* Based on the researched data, what recommendations can you make to hospitals to help them further improve the patient experience?

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

**Has the volume of hospital participation increase or decrease over the years?**

In order to find the answer to this questions, first we need find how many hospitals participated each year the survey was conducted. We can achieve this by counting hospital_count  (facility_id) grouped by year (release_period) ordered by hospital_count DESC to also find the year with the most and least hospital participation.
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

Overall, the volume of hospital participation has stay steady over the last 9 years the survey has been conducted. Year 2019 was the year with most hospital participation with 4,895 hospitals while 2016 had the least hospital participation with 4,628 hospitals. That is a difference of 219 hospitals between these two years, which shows that there hasn't been any sharp decreases or increases in participation. The average hospitals participation during the years surveyed is 4,802. Only three of the surveyed years (2015, 2016, and 2018) were below the average participation while most of the recent years surveyed (last six years) were above average hospital participation. This fact signs a tendency of participation increase over the years. 

**What is the current state of patient involvement (surveys completed by patients in hospitals)? What recommendations can you make to have a better sense of what needs to be further improve on patient care?**

To get a sense of patient involvement over the years the survey was conducted we can get the average response rate for each year. 

  ```sql
SELECT
  release_period,
  ROUND(AVG(response_rate), 1) AS avg_response_rate
FROM
  luisalva.hopitals_patients_survey.responses
GROUP BY
  release_period
ORDER BY 
  release_period desc;
  ```
To get a better sense of where exactly there is less patient involvement over the years the survey was conducted we will run a query to get the average response rate by state.
```sql
SELECT
  state,
  ROUND(AVG(response_rate), 1) AS avg_response_rate
FROM
  luisalva.hopitals_patients_survey.responses
GROUP BY
  state
ORDER BY 
  avg_response_rate;
```
To get more indepth, we can run a query using a Common Table Expression with a windown function to understand what state had the highest decreased in response rate over the years the surevey has been conducted.
```sql
WITH
  response_average AS (
  SELECT
    state,
    release_period,
    ROUND(AVG(response_rate), 1) AS avg_response_rate
  FROM
    luisalva.hopitals_patients_survey.responses
  GROUP BY
    state,
    release_period
  ORDER BY
    state,
    release_period),

  year_difference AS (
  SELECT
    state,
    release_period,
    avg_response_rate,
    LAG(avg_response_rate) OVER (PARTITION BY state ORDER BY release_period) - avg_response_rate AS diff_from_last_year
  FROM
    response_average
  WHERE
    release_period IN ('07_2015',
      '07_2023'))

SELECT
  *
FROM
  year_difference
ORDER BY
  diff_from_last_year DESC
```

Patient involvement (surveys completed) have been generally low throughout the years the survey was conducted. Average response rate has been decreasing year by year by aproximately one percent yearly from 27.6% in 2015 to 19.4% in 2023. In a state level we will find a low average patient involvement throughout the years the survey was conducted as well, having Wisconsin with the highest involvement average at 33.8% and 41 out of the 51 states below 25% patient involvement. A already low decreasing response rate doesn't provide enough data to allow us to see a fuller picture. Therefore, the recomendation in this case would be finding ways to improve patient involvement in order to gather more data and consequently have a more accurate picture on what needs to be improve for better patient quality of care.


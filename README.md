## Summary

American Hospital Association (AHA) is a national organization that represents hospitals and their patients, and acts as a source of information on health care issues and trends. Each year AHA produces the Hospital Consumer Assessment of Healthcare Providers and Systems (HCAHPS) survey. The intent of the HCAHPS survey is to provide an instrument for measuring patients’ perspectives on hospital care in order to create incentives for hospitals to improve their quality of care. 

The purpose of this project is to analyze the survey data for the last 9 years (2015 through 2023) using SQL to answer the following questions aiming to 
provide recomendations to improve their quality of care:

* Has the volume of hospital participation increase or decrease over the years?
* What is the current state of patient involvement (surveys completed by patients in hospitals)? 
* Are there any major areas for opportunity of improvement? What regions in the country are the most impacted?
* What areas have made more progress over the years surveyed? 
* What is the patient care sentiment on each region? Are there any patterns?
* Have hospitals' HCAHPS scores improved over the past 9 years? What is the tendency?
* Based on the researched data, what recommendations can you make to hospitals to help them further improve the patient experience?

## Survey Methodology
How many areas are survey
what does less_positive_percent, intermediate, and most_positive represent?

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
  diff_from_last_year DESC;
```

Patient involvement (surveys completed) have been generally low throughout the years the survey was conducted. National average response rate has been decreasing year by year by aproximately one percent yearly from 27.6% in 2015 to 19.4% in 2023. In a state level, we will also find a low average patient involvement for all combined years the survey was conducted, having Wisconsin with the highest involvement average at 33.8% and 41 out of the 51 states below 25% patient involvement. In tearm of decreasing average response throughout the years the survey was conducted Utah has the shapest decrease going from 33% average involvment in 2015 to 18.9% in 2023, that is a 15% decrease throughout the 9 years the surevey has been conducted. A already low decreasing response rate doesn't provide enough data to allow us to see a fuller picture. Therefore, the recomendation in this case would be finding ways to improve patient involvement in order to gather more data and consequently have a more accurate picture on what needs to be improve for better patient quality of care.

**Are there any major areas for opportunity of improvement?? and what specific region are the most impacted?**

There is a total of 10 areas measuared in the survey. The grading choices given to patients to reflect their sentiment about the quality of sevice for each of the questions were: "sometimes or never", "usually", and "always" meaning less positive, intermediate, and most positive respectively. 

First, to find areas for opportunity of improvement in a national levele we need to find the average for each measure for all the years surveyed by joining the measures table with the national results table and creating a query using a Common Table Expression.

```sql
WITH
  measures_results AS (
  SELECT
    r.release_period,
    r.measure_id,
    m.measure,
    r.bottom_box_percentage AS less_positive_percent,
    r.middle_box_percentage AS intermediate_percent,
    r.top_box_percentage AS most_positive_percent
  FROM
    luisalva.hopitals_patients_survey.national_results r
  JOIN
    luisalva.hopitals_patients_survey.measures m
  ON
    r.measure_id = m.measure_id)
SELECT
  measure,
  ROUND(AVG(less_positive_percent), 1) AS less_positive_avg_percent,
  ROUND(AVG(intermediate_percent), 1) AS intermediate_avg_percent,
  ROUND(AVG(most_positive_percent), 1) AS most_positive_avg_percent,
FROM
  measures_results
GROUP BY
  measure;
```
The two areas with the lowest average performance for all years surveyed combined, therefore, the major areas for opportunity of improvement are "Comunication about Medicines" and "Discharge Information" with 13.3% and 17.8% of patient less positive sentiment.

To identify the regions of the country where "Comunication about Medicines" and "Discharge Information" have the highest disapprovement rating, and therefore regions where this area needs to be emphazise for further iprovement we need to join the state_results table, measures table, and state table in the following query.

```sql
SELECT
  s.region,
  m.measure,
  ROUND(AVG(r.bottom_box_percentage), 1) AS region_percentage
FROM
  luisalva.hopitals_patients_survey.state_results r
JOIN
  luisalva.hopitals_patients_survey.measures m
ON
  r.measure_id = m.measure_id
JOIN
  luisalva.hopitals_patients_survey.states s
ON
  r.State = s.state
GROUP BY
  s.region,
  m.measure
ORDER BY
  region_percentage DESC;
```

From this query we can see that the regions with the highest disapprovement in the area of "Comunication about Medicines" are the Mid-Atlantic region and the South Atlantics region with 21.1% and 20% of disaprovemment. Regarding the area of "Discharge Information" the two areas with the highest disapprovement ratings are Mid-Atlantic and East South Central with 14.6% and 14.3 respectively.

*** What areas have made more progress over the years surveyed?**

To identify specific areas where hospitals have made more progress, we have to join the national_results table with the measures table
and identify the areas where most positive sentiment has increased over the years.

```sql
SELECT
  r.release_period,
  m.measure,
  r.top_box_percentage AS most_positive,
  r.top_box_percentage - LAG(r.top_box_percentage) OVER (PARTITION BY m.measure ORDER BY r.release_period) AS percent_difference
FROM
  luisalva.hopitals_patients_survey.national_results r
JOIN
  luisalva.hopitals_patients_survey.measures m
ON
  r.measure_id = m.measure_id
WHERE
  r.release_period IN ('07_2015',
    '07_2023')
ORDER BY
  m.measure,
  r.release_period DESC;
```
From this query we can see that none of the areas have increased for the most positive sentiment over the years. Most of the areas if anything have decreased their most positive sentiment. 

To see eexplore this question into more detail I would like to know if there are any states where areas most positive sentiment have increased over the years surveyed. 
```sql
WITH
  state_measure AS (
  SELECT
    r.release_period,
    r.State,
    m.measure,
    r.top_box_percentage AS most_positive,
    r.top_box_percentage - LAG(r.top_box_percentage) OVER (PARTITION BY m.measure, state ORDER BY r.release_period) AS percent_difference
  FROM
    luisalva.hopitals_patients_survey.state_results r
  JOIN
    luisalva.hopitals_patients_survey.measures m
  ON
    r.measure_id = m.measure_id
  WHERE
    release_period IN ('07_2015',
      '07_2023')
  ORDER BY
    State,
    measure,
    release_period DESC)
SELECT
  *
FROM
  state_measure
ORDER BY
  percent_difference desc;
```
There are a few states where areas most positive sentiment have significant significantly from 2015 to 2023. In North Dakota, "Quietness of Hospital Environment" has increased 7% since 2015. In Alaska, most positive sentiment in the areas of "Communication with Nurses", "Cleanliness of Hospital Environment", and "Overall Hospital Rating" have increased 6% each. We can see that in the state level some areas most positive sentiment have increased in comparison to the national level where there was no increased in areas most positive sentiment. 

**What is the patient care sentiment on each region? Are there any patterns?**

For the purpose of this survey the country has been devided in nine distinct regions. Each region divided by a groupo of states according to state locations. The nine regions are: Pacific, Mountain, New England,
Mid-Atlantic, South Atlantic, East North Central, East South Central, West North Central, and West South Central. 
Since survey results are only provided in a state level, region results will have to be based on the average results of the states that belongs to each region. To identify the average region results, first, I joined three tables state_results, meausres, and states. This allowed me to see the areas measure, results(sentiment), state, and the region the states belongs to. 
```sql
SELECT
  r.release_period,
  s.state,
  s.region,
  m.measure,
  r.bottom_box_percentage,
  r.middle_box_percentage,
  r.top_box_percentage
FROM
  luisalva.hopitals_patients_survey.state_results r
JOIN
  luisalva.hopitals_patients_survey.measures m
ON
  r.measure_id = m.measure_id
JOIN
  luisalva.hopitals_patients_survey.states s
ON
  r.State = s.state
ORDER BY
  region,
  release_period;
```
Next, I proceeded to find the average results for each region by turning the previous query into a common table expression and adding a query. 
```sql
WITH
  average_region AS (
  SELECT
    r.release_period,
    s.state,
    s.region,
    m.measure,
    r.bottom_box_percentage AS negative,
    r.middle_box_percentage AS neutral,
    r.top_box_percentage AS positive
  FROM
    luisalva.hopitals_patients_survey.state_results r
  JOIN
    luisalva.hopitals_patients_survey.measures m
  ON
    r.measure_id = m.measure_id
  JOIN
    luisalva.hopitals_patients_survey.states s
  ON
    r.State = s.state
  ORDER BY
    region,
    release_period)
SELECT
  region,
  measure,
  ROUND(AVG(negative), 1) AS negative_avg,
  ROUND(AVG(neutral), 1) AS neutral_avg,
  ROUND(AVG(positive), 1) AS positive_avg
FROM
  average_region
GROUP BY
  region,
  measure
ORDER BY
  region,
  measure;
```









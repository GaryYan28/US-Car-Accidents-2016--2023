# Car Accidents Analysis

### By Gary Yan
### Last Updated: June 27, 2025

[Link to Tableau dashboard](https://public.tableau.com/views/USAccidents2016--2023/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Background

Traffic accidents pose a critical public safety issue and conventional wisdom is that it is particularly risky to drive during adverse conditions like storms or low visibility. However, analysis of the Countrywide Traffic Accident Dataset (Moosavi et al., 2019) reveals some interesting and counterintuitive trends: accidents during clear weather, good visibility, and weekends demonstrate high severity rates. This suggests driver behavior such as speeding or distraction in perceived "safe" conditions may contribute significantly to crash outcomes. Using SQL and data visualization tools, this project identifies these hidden risk factors and challenges traditional assumptions about accident prevention. By transforming raw data into actionable insights, the analysis aims to support more nuanced safety strategies that address complacency, not just obvious hazards.

## Data Structure

The dataset consists of one table with about 7.7 million records.
Each record has 46 attributes.

| Attribute Name         | Data Type | Description / Notes              |
| ---------------------- | --------- | -------------------------------- |
| ID                     | VARCHAR   | Primary Key (unique accident ID) |
| SOURCE                 | VARCHAR   | Data source                      |
| SEVERITY               | NUMBER    | Severity level of the accident   |
| START\_TIME            | TIMESTAMP | Start time of accident           |
| END\_TIME              | TIMESTAMP | End time of accident             |
| START\_LAT             | NUMBER    | Starting latitude                |
| START\_LNG             | NUMBER    | Starting longitude               |
| END\_LAT               | NUMBER    | Ending latitude                  |
| END\_LNG               | NUMBER    | Ending longitude                 |
| DISTANCE               | NUMBER    | Distance involved                |
| DESCRIPTION            | VARCHAR   | Description of accident          |
| STREET                 | VARCHAR   | Street name                      |
| CITY                   | VARCHAR   | City                             |
| COUNTY                 | VARCHAR   | County                           |
| STATE                  | VARCHAR   | State                            |
| ZIPCODE                | VARCHAR   | Zipcode                          |
| COUNTRY                | VARCHAR   | Country                          |
| TIMEZONE               | VARCHAR   | Time zone                        |
| AIRPORT\_CODE          | VARCHAR   | Nearby airport code              |
| WEATHER\_TIMESTAMP     | TIMESTAMP | Timestamp for weather data       |
| TEMPERATURE            | NUMBER    | Temperature (°F)                 |
| WIND\_CHILL            | NUMBER    | Wind chill                       |
| HUMIDITY               | NUMBER    | Humidity percentage              |
| PRESSURE               | NUMBER    | Atmospheric pressure             |
| VISIBILITY             | NUMBER    | Visibility distance (mi.)        |
| WIND\_DIRECTION        | VARCHAR   | Direction of wind                |
| WIND\_SPEED            | NUMBER    | Wind speed (mph)                 |
| PRECIPITATION          | NUMBER    | Precipitation (in.)              |
| WEATHER\_CONDITION     | VARCHAR   | Weather condition description    |
| AMENITY                | BOOLEAN   | Amenity flag                     |
| BUMP                   | BOOLEAN   | Bump flag                        |
| CROSSING               | BOOLEAN   | Crossing flag                    |
| GIVE\_WAY              | BOOLEAN   | Give way flag                    |
| JUNCTION               | BOOLEAN   | Junction flag                    |
| NO\_EXIT               | BOOLEAN   | No exit flag                     |
| RAILWAY                | BOOLEAN   | Railway flag                     |
| ROUNDABOUT             | BOOLEAN   | Roundabout flag                  |
| STATION                | BOOLEAN   | Station flag                     |
| STOP                   | BOOLEAN   | Stop flag                        |
| TRAFFIC\_CALMING       | BOOLEAN   | Traffic calming flag             |
| TRAFFIC\_SIGNAL        | BOOLEAN   | Traffic signal flag              |
| TURNING\_LOOP          | BOOLEAN   | Turning loop flag                |
| SUNRISE\_SUNSET        | VARCHAR   | Sunrise or sunset status         |
| CIVIL\_TWILIGHT        | VARCHAR   | Civil twilight status            |
| NAUTICAL\_TWILIGHT     | VARCHAR   | Nautical twilight status         |
| ASTRONOMICAL\_TWILIGHT | VARCHAR   | Astronomical twilight status     |


## Insights

#### Accidents per day
* From when the first accident was recorded on Feb. 08, 2016 to the last accident on Mar. 31, 2023, there were an average of 2745 accidents per day and the average severity of the accidents was 2.22.
    * Accident recording took a few months to ramp up, July of 2016 was the first month where we observed a similar number of accidents as following months.
    * Using July 2016 onward stats, we get an average of 2876 accidents per day with an average severity of 2.22.

![Monthly Acccident Totals](https://github.com/user-attachments/assets/9343dddf-d91f-4c14-a79f-ee9d9920147e)

* Number of accidents on weekends significantly lower than on weekdays but with a slightly higher average severity.
    * 3150 - 3600 accidents per day on weekdays with 2.21 average severity.
    * 1732 accidents per day and 2.25 average severity on Saturdays.
    * 1465 accidents per day and 2.27 average severity on Sundays.
![accidents per day by day of the week](https://github.com/user-attachments/assets/ff488bf0-bd40-4e88-81ad-f0f89f445444)

* On weekdays, most likely times for accidents are 7:00, 8:00, 17:00, and 16:00.
* On weekends, accidents spread throughout 11:00--17:00.
    * But rest of accidents are also more evenly spread through morning and evenings too.

* Number of accidents per day is highest in the winter followed by fall, then spring, then summer.
    * Average severity of accidents is highest in summer, followed by spring, then fall, then winter.
![accidents per season](https://github.com/user-attachments/assets/320a64ca-7c14-499f-a254-8bd7095a1286)

#### Road Conditions

* Most accidents occurred on local roads, but the average severity of accidents on highways is higher.
![street type](https://github.com/user-attachments/assets/ee405e1c-a4e0-4685-bbe3-ec88b695e007)

* Average severity and the percentage of accidents that are high severity are greatest in clear weather.
* Average severity and high severity percentage were lowest in 'fair' weather.
* Cloudy weather accounts for the plurality of accidents and the average severity is close to the overall average severity.
* Rain and snow had higher average severity than overall average.
    * More accidents in rain than all other forms of precipitation combined.
* Adverse weather conditions like thunderstorms and fog had average severity lower than the overall average.
![weather conditions](https://github.com/user-attachments/assets/2d416df9-f9da-4a4a-b621-d2b8ba0f9013)

* Average severity largely unaffected by road visibility but more high severity accidents in lower visibility conditions.
    * Exception is when visibility is less than 1 mile, then we see the fewest high severity accidents.
![visibility](https://github.com/user-attachments/assets/4983c3c8-951d-4cf8-a5a2-2a27a824c317)

* Very small number of accidents in areas with traffic calming measures but lower average severity.
![traffic calming](https://github.com/user-attachments/assets/e27d9d69-22d7-42de-be1a-fbba43801823)

## Conclusion

* **Speed is the greatest predictor of severity of accidents**
    * Highway accidents are much more severe on average.
    * Traffic calming measures also lower severity. Fewer accidents occur near these measures so may have an effect on reducing accidents but hard to tell without knowing throughput. 
* **More accidents occur daily during the colder seasons and most accidents occur during weekdays.**
* The higher prevelance of accidents on weekdays can likely be attributed to influx of cars during peak commuting times.
* During colder months, the higher accidents could be due to the shorter days. 
    * From the data we can see that although there are more accidents before sunset in the summer months, the difference is much greater in accidents after sunset during colder months. 
* Average severity differences between seasons are very small. 
* Average severity differences between weekdays and weekends may mean something.
    * **Fewer cars on the roads may allow people to drive faster, leading to more severe incidents.**
* Hard to see a correlation between visibility and accident severity.
    * Low visibility does not necessarily contribute to more severe accidents but hard to tell if it contributes to more accidents.
* Overwhelming majority of accidents occur during clear, cloudy, and fair weather
    * These can be considered "good" weather for driving, especially clear weather.
    * **Clear weather has highest average severity.**
    * Accidents in rain and snow are about the same severity as cloudy weather.

Speed appears to be the greatest predictor of accident severity, with highway crashes being more severe on average. More accidents occur during colder months, likely due to the shorter daylight hours but average severity stays about the same. Weekdays have more accidents than weekends, particularly around peak commuting hours, whereas weekend accidents tend to be slightly more severe. Most accidents occur during good weather, precipitation and adverse weather conditions don't appear to influence accident severity. Surprisingly, clear weather accidents have the highest average severity. 

## Sources
Data used for the project from:

    Moosavi, Sobhan, Mohammad Hossein Samavatian, Srinivasan Parthasarathy, and Rajiv Ramnath. “A Countrywide Traffic Accident Dataset.”, 2019.

    Moosavi, Sobhan, Mohammad Hossein Samavatian, Srinivasan Parthasarathy, Radu Teodorescu, and Rajiv Ramnath. "Accident Risk Prediction based on Heterogeneous Sparse Data: New Dataset and Insights." In proceedings of the 27th ACM SIGSPATIAL International Conference on Advances in Geographic Information Systems, ACM, 2019.


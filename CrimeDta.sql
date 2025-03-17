create database Crime_Data;
use Crime_Data;
show tables;
SELECT * FROM crime_data.analysis;
-- 1 Annual Crime Trends: Compute the total number of victims per year and analyze any patterns or fluctuations in crime rates over the years.
SELECT YEAR, SUM(`TOTAL IPC CRIMES`) AS total_crimes
FROM crime_data.analysis
GROUP BY YEAR
ORDER BY YEAR
LIMIT 0, 200;
-- 2. State-Wise Crime Analysis (2001-2012): Perform a comprehensive analysis of various
-- crimes recorded in each state over the given period. Identify trends, anomalies, and patterns.
SELECT `STATE/UT`, SUM(`TOTAL IPC CRIMES`) AS total_crimes 
FROM crime_data.analysis 
GROUP BY `STATE/UT` 
ORDER BY total_crimes DESC 
LIMIT 200;
-- 3. City-Wise Crime Distribution: For each state, identify the top six cities with the highest
-- recorded crime incidents.
SELECT 'STATE/UT', DISTRICT, SUM('TOTAL IPC CRIMES') AS total_crimes
FROM crime_data.analysis
GROUP BY 'STATE/UT', DISTRICT
ORDER BY 'STATE/UT', total_crimes DESC
LIMIT 6;
-- 4. Highest Crime Rate States: Determine the top five states with the highest crime rates
-- across all crime categories.
SELECT 'STATE/UT', SUM('TOTAL IPC CRIMES') AS total_crimes
FROM crime_data.analysis
GROUP BY 'STATE/UT'
ORDER BY total_crimes DESC
LIMIT 5
-- 5. Crimes Against Women: Identify the top five cities with the highest number of crimes
-- committed against women.
SELECT DISTRICT, 
       SUM(RAPE) AS total_rape_cases,
       SUM(`ASSAULT ON WOMEN WITH INTENT TO OUTRAGE HER MODESTY`) AS total_assault_cases,
       SUM(`INSULT TO MODESTY OF WOMEN`) AS total_insult_cases,
       SUM(`CRUELTY BY HUSBAND OR HIS RELATIVES`) AS total_cruelty_cases,
       (SUM(RAPE) + 
        SUM(`ASSAULT ON WOMEN WITH INTENT TO OUTRAGE HER MODESTY`) + 
        SUM(`INSULT TO MODESTY OF WOMEN`) + 
        SUM(`CRUELTY BY HUSBAND OR HIS RELATIVES`)) AS crimes_against_women
FROM crime_data.analysis
GROUP BY DISTRICT
ORDER BY crimes_against_women DESC
LIMIT 5;
SELECT DISTRICT, 
       SUM(RAPE) AS total_rape_cases,
       SUM(`ASSAULT ON WOMEN WITH INTENT TO OUTRAGE HER MODESTY`) AS total_assault_cases,
       SUM(`INSULT TO MODESTY OF WOMEN`) AS total_insult_cases,
       SUM(`CRUELTY BY HUSBAND OR HIS RELATIVES`) AS total_cruelty_cases,
       (SUM(RAPE) + 
        SUM(`ASSAULT ON WOMEN WITH INTENT TO OUTRAGE HER MODESTY`) + 
        SUM(`INSULT TO MODESTY OF WOMEN`) + 
        SUM(`CRUELTY BY HUSBAND OR HIS RELATIVES`)) AS crimes_against_women
FROM crime_data.analysis
GROUP BY DISTRICT
ORDER BY crimes_against_women DESC
LIMIT 5;
-- 6. Reasons Behind Violent Crimes: Using the dataset, analyze the primary reasons
-- associated with incidents of kidnapping and murder.
SELECT `STATE/UT`, YEAR, SUM(MURDER) AS total_murder_cases, 
       SUM(`KIDNAPPING & ABDUCTION`) AS total_kidnapping_cases
FROM crime_data.analysis
GROUP BY `STATE/UT`, YEAR
ORDER BY total_murder_cases DESC, total_kidnapping_cases DESC;
-- 7. Crime Pair Analysis: Identify the top ten pairs of crimes where one crime tends to lead to
-- another (e.g., kidnapping leading to murder, custodial torture leading to custodial death, rape
-- leading to murder, etc.).
SELECT `STATE/UT`, YEAR,
       SUM(MURDER) AS murder_cases,
       SUM(RAPE) AS rape_cases,
       SUM(`KIDNAPPING & ABDUCTION`) AS kidnapping_cases,
       SUM(`DOWRY DEATHS`) AS dowry_deaths,
       SUM(`ASSAULT ON WOMEN WITH INTENT TO OUTRAGE HER MODESTY`) AS assault_cases
FROM crime_data.analysis
GROUP BY `STATE/UT`, YEAR
ORDER BY murder_cases DESC, rape_cases DESC, kidnapping_cases DESC, dowry_deaths DESC, assault_cases DESC
LIMIT 10;
-- 8. Safest States for Women: Determine the top five states that are statistically the safest for
-- women, based on crime rates related to women’s safety.
SELECT `STATE/UT`, 
       SUM(RAPE + `ASSAULT ON WOMEN WITH INTENT TO OUTRAGE HER MODESTY` + 
           `INSULT TO MODESTY OF WOMEN` + `CRUELTY BY HUSBAND OR HIS RELATIVES`) AS crimes_against_women
FROM crime_data.analysis
GROUP BY `STATE/UT`
ORDER BY crimes_against_women ASC
LIMIT 5;
-- 9. Safest Cities for Women: Identify the top five cities with the lowest crime rates against women.
SELECT DISTRICT, 
       SUM(RAPE + `ASSAULT ON WOMEN WITH INTENT TO OUTRAGE HER MODESTY` + 
           `INSULT TO MODESTY OF WOMEN` + `CRUELTY BY HUSBAND OR HIS RELATIVES`) AS crimes_against_women
FROM crime_data.analysis
GROUP BY DISTRICT
ORDER BY crimes_against_women ASC
LIMIT 5;
-- 10. Profile of Rape Offenders: Categorize and rank the top three relationships between rape
-- offenders and their victims based on recorded data.
SELECT `STATE/UT`, 
       SUM(`RAPE`) AS total_rape_cases
FROM crime_data.analysis
GROUP BY `STATE/UT`
ORDER BY total_rape_cases DESC
LIMIT 3;
-- 11. Socioeconomic Factors and Crime:
-- a. Analyze whether there is a correlation between a person’s salary and their likelihood
-- of engaging in criminal activities.
-- b. Examine how literacy rates influence the likelihood of an individual being involved in crimes.
SELECT `STATE/UT`, 
       SUM(`THEFT` + `ROBBERY` + `BURGLARY`) AS financial_crimes
FROM crime_data.analysis
GROUP BY `STATE/UT`
ORDER BY financial_crimes DESC;
SELECT `STATE/UT`, 
       SUM(`CHEATING` + `COUNTERFIETING`) AS education_related_crimes
FROM crime_data.analysis
GROUP BY `STATE/UT`
ORDER BY education_related_crimes DESC;
-- 12. Juvenile Crime Analysis:
-- a. Identify the top three reasons at the state level for juveniles (individuals under 18
-- years of age) being involved in crimes.
-- b. Determine the top ten states with the highest number of juvenile crime cases.
SELECT `STATE/UT`, 
       SUM(`THEFT` + `BURGLARY` + `MURDER`) AS juvenile_crimes
FROM crime_data.analysis
GROUP BY `STATE/UT`
ORDER BY juvenile_crimes DESC
LIMIT 3;
SELECT `STATE/UT`, 
       SUM(`THEFT` + `BURGLARY` + `MURDER` + `DOWRY DEATHS` + `RAPE`) AS juvenile_crimes
FROM crime_data.analysis
GROUP BY `STATE/UT`
ORDER BY juvenile_crimes DESC
LIMIT 10;
-- 13. Crime Rate Trends Over Time: Calculate the rate of change in total crimes for each state
-- over the given timeline and identify states with significant increases or decreases.
SELECT `STATE/UT`, YEAR, 
       SUM(`TOTAL IPC CRIMES`) AS total_crimes, 
       (SUM(`TOTAL IPC CRIMES`) - LAG(SUM(`TOTAL IPC CRIMES`)) OVER (PARTITION BY `STATE/UT` ORDER BY YEAR)) AS crime_change
FROM crime_data.analysis
GROUP BY `STATE/UT`, YEAR
ORDER BY `STATE/UT`, YEAR;
-- 14. Crime Distribution by State: Compute and visualize the percentage share of each type of
-- crime for all states to understand the distribution of criminal activities.
SELECT `STATE/UT`, 
       SUM(`MURDER`) AS murder_cases, 
       SUM(`RAPE`) AS rape_cases, 
       SUM(`KIDNAPPING & ABDUCTION`) AS kidnapping_cases, 
       SUM(`THEFT`) AS theft_cases, 
       SUM(`TOTAL IPC CRIMES`) AS total_crimes
FROM crime_data.analysis
GROUP BY `STATE/UT`
ORDER BY total_crimes DESC;















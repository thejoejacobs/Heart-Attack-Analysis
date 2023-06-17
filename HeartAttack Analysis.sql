SELECT *
FROM PersonalProject..HeartAttack


-- Checking if there are duplicate rows 

SELECT age, sex, cp, trtbps, chol, fbs, restecg, thalachh, exng, oldpeak, slp, caa, thall, output
FROM PersonalProject..HeartAttack 
GROUP BY age, sex, cp, trtbps, chol, fbs, restecg, thalachh, exng, oldpeak, slp, caa, thall, output
HAVING COUNT(*) > 1;

-- There is 1 duplicate row
-- Dropping the duplicate row
WITH CTE AS (
  SELECT age, sex, cp, trtbps, chol, fbs, restecg, thalachh, exng, oldpeak, slp, caa, thall, output,
         ROW_NUMBER() OVER (PARTITION BY age, sex, cp, trtbps, chol, fbs, restecg, thalachh, exng, oldpeak, slp, caa, thall, output ORDER BY (SELECT 0)) AS RowNumber
  FROM PersonalProject..HeartAttack
)
DELETE FROM CTE WHERE RowNumber > 1;


-- Next step is to check for null values

SELECT *
FROM PersonalProject..HeartAttack
WHERE age IS NULL 
	OR sex IS NULL 
	OR cp IS NULL 
	OR trtbps IS NULL 
	OR chol IS NULL 
	OR fbs IS NULL 
	OR restecg IS NULL 
	OR thalachh IS NULL 
	OR exng IS NULL 
	OR oldpeak IS NULL 
	OR slp IS NULL 
	OR caa IS NULL 
	OR thall IS NULL 
	OR output IS NULL;


-- For better readability or understanding, some column names will be renamed
-- Columns that will be renamed are: cp, trtbps, chol, fbs, restecg, thalachh, exng, oldpeak, slp, caa, thall

BEGIN TRANSACTION;

EXEC sp_rename 'PersonalProject..HeartAttack.cp', 'chest_pain_type', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.trtbps', 'resting_blood_pressure', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.chol', 'cholestoral', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.fbs', 'fasting_blood_sugar', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.restecg', 'resting_electrocardiographic', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.thalachh', 'maximum_heart_rate', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.exng', 'exercise_induced_angina', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.oldpeak', 'ST_depression', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.slp', 'slope_peak_exercise', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.caa', 'number_of_major_vessels', 'COLUMN';
EXEC sp_rename 'PersonalProject..HeartAttack.thall', 'thalium_stress_test', 'COLUMN';

COMMIT;

-- Viewing renamed columns 

SELECT *
FROM PersonalProject..HeartAttack



--- For better understanding, the feature values will be added to columns
-- For the other columns where feature values will be added, new columns has to be created for them and then the feature values added

--Adding feature values for sex

ALTER TABLE PersonalProject..HeartAttack
ADD sex_new VARCHAR(50);

UPDATE PersonalProject..HeartAttack
SET sex_new = CASE
    WHEN sex = 0 THEN 'Female'
    WHEN sex = 1 THEN 'Male'
    END;

-- Dropping the old column
ALTER TABLE PersonalProject..HeartAttack
DROP COLUMN sex;

-- Rename the new column
EXEC sp_rename 'PersonalProject..HeartAttack.sex_new', 'sex', 'COLUMN';


--Adding feature values for chest_pain_type
ALTER TABLE PersonalProject..HeartAttack
ADD chest_pain_type_new VARCHAR(50);

UPDATE PersonalProject..HeartAttack
SET chest_pain_type_new = CASE
    WHEN chest_pain_type = 0 THEN 'typical angina'
    WHEN chest_pain_type = 1 THEN 'atypical angina'
    WHEN chest_pain_type = 2 THEN 'non-anginal pain'
	WHEN chest_pain_type = 3 THEN 'asymptomatic'
    END;

-- Dropping the old column
ALTER TABLE PersonalProject..HeartAttack
DROP COLUMN chest_pain_type;

-- Rename the new column
EXEC sp_rename 'PersonalProject..HeartAttack.chest_pain_type_new', 'chest_pain_type', 'COLUMN';


-- Adding feature values for fasting_blood_sugar

ALTER TABLE PersonalProject..HeartAttack
ADD fasting_blood_sugar_new VARCHAR(50);

UPDATE PersonalProject..HeartAttack
SET fasting_blood_sugar_new = CASE
    WHEN fasting_blood_sugar = 0 THEN '<120 mg/dl'
    WHEN fasting_blood_sugar = 1 THEN '>120 mg/dl'
    END;

-- Dropping the old column
ALTER TABLE PersonalProject..HeartAttack
DROP COLUMN fasting_blood_sugar;

-- Rename the new column
EXEC sp_rename 'PersonalProject..HeartAttack.fasting_blood_sugar_new', 'fasting_blood_sugar', 'COLUMN';


-- Adding feature values for  resting_electrocardiographic
ALTER TABLE PersonalProject..HeartAttack
ADD resting_electrocardiographic_new VARCHAR(50);

UPDATE PersonalProject..HeartAttack
SET resting_electrocardiographic_new = CASE
    WHEN resting_electrocardiographic = 0 THEN 'normal'
    WHEN resting_electrocardiographic = 1 THEN 'ST-T wave abnormality'
    WHEN resting_electrocardiographic = 2 THEN 'ventricular hypertrophy'
    END;

-- Dropping the old column
ALTER TABLE PersonalProject..HeartAttack
DROP COLUMN resting_electrocardiographic;

-- Rename the new column
EXEC sp_rename 'PersonalProject..HeartAttack.resting_electrocardiographic_new', 'resting_electrocardiographic', 'COLUMN';


-- Adding feature values for exercise_induced_angina
ALTER TABLE PersonalProject..HeartAttack
ADD exercise_induced_angina_new VARCHAR(50);

UPDATE PersonalProject..HeartAttack
SET exercise_induced_angina_new = CASE
    WHEN exercise_induced_angina = 0 THEN 'no'
    WHEN exercise_induced_angina = 1 THEN 'yes'
    END;

-- Dropping the old column
ALTER TABLE PersonalProject..HeartAttack
DROP COLUMN exercise_induced_angina;

-- Rename the new column
EXEC sp_rename 'PersonalProject..HeartAttack.exercise_induced_angina_new', 'exercise_induced_angina', 'COLUMN';


-- Adding feature values for slope_peak_exercise
ALTER TABLE PersonalProject..HeartAttack
ADD slope_peak_exercise_new VARCHAR(50);

UPDATE PersonalProject..HeartAttack
SET slope_peak_exercise_new = CASE
    WHEN slope_peak_exercise = 0 THEN 'upsloping'
    WHEN slope_peak_exercise = 1 THEN 'flat'
    WHEN slope_peak_exercise = 2 THEN 'downsloping'
    END;

-- Dropping the old column
ALTER TABLE PersonalProject..HeartAttack
DROP COLUMN slope_peak_exercise;

-- Rename the new column
EXEC sp_rename 'PersonalProject..HeartAttack.slope_peak_exercise_new', 'slope_peak_exercise', 'COLUMN';


-- Adding feature values for thalium_stress_test
ALTER TABLE PersonalProject..HeartAttack
ADD thalium_stress_test_new VARCHAR(50);

UPDATE PersonalProject..HeartAttack
SET thalium_stress_test_new = CASE
    WHEN thalium_stress_test = 0 THEN 'normal 0'
    WHEN thalium_stress_test = 1 THEN 'normal 1'
    WHEN thalium_stress_test = 2 THEN 'fixed defect'
	WHEN thalium_stress_test = 3 THEN 'reversible defect'
    END;

-- Dropping the old column
ALTER TABLE PersonalProject..HeartAttack
DROP COLUMN thalium_stress_test;

-- Rename the new column
EXEC sp_rename 'PersonalProject..HeartAttack.thalium_stress_test_new', 'thalium_stress_test', 'COLUMN';


-- Adding feature values for output
ALTER TABLE PersonalProject..HeartAttack
ADD output_new VARCHAR(50);

UPDATE PersonalProject..HeartAttack
SET output_new = CASE
    WHEN output = 0 THEN 'no disease'
    WHEN output = 1 THEN 'disease'
    END;

-- Dropping the old column
ALTER TABLE PersonalProject..HeartAttack
DROP COLUMN output;

-- Rename the new column
EXEC sp_rename 'PersonalProject..HeartAttack.output_new', 'output', 'COLUMN';

SELECT *
FROM PersonalProject..HeartAttack


-- I noticed that the name I gave to some columns were wrong, so I had to rename it to the right name
EXEC sp_rename 'PersonalProject..HeartAttack.cholestoral', 'cholesterol', 'COLUMN'
EXEC sp_rename 'PersonalProject..HeartAttack.thalium_stress_test', 'thallium_stress_test', 'COLUMN'



/****************************************************
ANSWERING BUSINESS QUESTIONS
*****************************************************/

-- 1. What is the average age of patients?
SELECT CAST(AVG(age) AS INTEGER) as AverageAge
FROM PersonalProject..HeartAttack


--2. What is the number of male and female patients?
SELECT sex, COUNT(*) AS TotalNumberOfPatients
FROM PersonalProject..HeartAttack
GROUP BY sex


--3. What is the result of the thallium_stress_test for each sex?
SELECT sex, thallium_stress_test, COUNT(thallium_stress_test) AS TotalThalliumStressTest
FROM PersonalProject..HeartAttack
GROUP BY sex, thallium_stress_test
ORDER BY sex


--4. Which sex had the most patients with heart diseases?
SELECT sex, COUNT(*) AS CountDisease
FROM PersonalProject..HeartAttack
WHERE output = 'disease'
GROUP BY sex
ORDER BY CountDisease DESC;


--5. Which sex has the highest cholesterol level?
SELECT sex, CAST(AVG(cholesterol) AS INTEGER) AS AverageCholesterol
FROM PersonalProject..HeartAttack
GROUP BY sex
ORDER BY AverageCholesterol DESC;


--6. What Chest pain type resulted in no heart disease?
SELECT chest_pain_type, COUNT(*) AS CountofNoDisease
FROM PersonalProject..HeartAttack
WHERE output = 'no disease'
GROUP BY chest_pain_type


--7. Which thallium stress test led to higher incidence of heart disease?
SELECT thallium_stress_test, COUNT(*) AS DiseaseCount
FROM PersonalProject..HeartAttack
WHERE output = 'disease'
GROUP BY thallium_stress_test
ORDER BY DiseaseCount DESC


--8. Is there a relationship between the number of major vessels healthy and the occurrence of heart disease?
SELECT number_of_major_vessels, COUNT(*) AS DiseaseCount
FROM PersonalProject..HeartAttack
WHERE output = 'disease'
GROUP BY number_of_major_vessels
ORDER BY number_of_major_vessels;





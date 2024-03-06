SELECT * FROM healthcare_db.ocd_patient_data;

-- 1. Count and percentage of Female vs Male having OCD and average obsession score by gender

WITH data AS (
SELECT 
	Gender,
    COUNT(`patient ID`) AS number_of_patients,
    ROUND(avg(`Y-BOCS Score (Obsessions)`),2) AS average_obsession_score
FROM 
	healthcare_db.ocd_patient_data
GROUP BY 
	Gender
ORDER BY 
	number_of_patients DESC 
)
SELECT 
	SUM(CASE WHEN Gender = 'Male' THEN number_of_patients ELSE 0 END) AS male_patients_count,
    SUM(CASE WHEN Gender = 'Female' THEN number_of_patients ELSE 0 END) AS female_patients_count,
    
    ROUND(SUM(CASE WHEN Gender = 'Male' THEN number_of_patients ELSE 0 END)/
    (SUM(CASE WHEN Gender = 'Male' THEN number_of_patients ELSE 0 END)+SUM(CASE WHEN Gender = 'Female' THEN number_of_patients ELSE 0 END))*100,2) AS percentage_of_male,
	ROUND(SUM(CASE WHEN Gender = 'Female' THEN number_of_patients ELSE 0 END)/
    (SUM(CASE WHEN Gender = 'Female' THEN number_of_patients ELSE 0 END)+SUM(CASE WHEN Gender = 'Male' THEN number_of_patients ELSE 0 END))*100,2) AS percentage_of_female

FROM data;


-- 2. Count of Patients by Ethnicity and their respective Average Obsession Score

SELECT 
	Ethnicity,
    COUNT(`Patient ID`) AS number_of_patients,
    ROUND(avg(`Y-BOCS Score (Obsessions)`),2) AS avg_obsession_score
FROM 
	healthcare_db.ocd_patient_data
GROUP BY 
	Ethnicity
ORDER BY 
	avg_obsession_score DESC;


-- 3. Number of people diagnosed with OCD MoM (Month over Month)

ALTER TABLE healthcare_db.ocd_patient_data
MODIFY `OCD Diagnosis Date` date;

SELECT 
	DATE_FORMAT(`OCD Diagnosis Date`, '%Y-%m-01 00:00:00') AS month,
	COUNT(`Patient ID`) AS number_of_patients
FROM 
	healthcare_db.ocd_patient_data
GROUP BY 
	month
ORDER BY 
	month;


-- 4. Count of the most common type of obsession and it's average obsession score

SELECT 
	`Obsession Type`,
    COUNT(`Patient ID`) AS number_of_patients,
    ROUND(avg(`Y-BOCS Score (Obsessions)`),2) AS avg_obsession_score
FROM 
	healthcare_db.ocd_patient_data
GROUP BY 
	`Obsession Type`
ORDER BY 
	number_of_patients;


-- 5. Count of the most common type of compulsion and it's average compulsion score

SELECT 
	`Compulsion Type`,
    COUNT(`Patient ID`) AS number_of_patients,
    ROUND(avg(`Y-BOCS Score (Compulsions)`),2) AS avg_compulsion_score
FROM 
	healthcare_db.ocd_patient_data
GROUP BY 
	`Compulsion Type`
ORDER BY 
	number_of_patients;


-- --------------- Clinical Profile Insights ---------------

-- 6. Average age at OCD diagnosis and duration of symptoms

SELECT 
    Gender,
    ROUND(AVG(Age),0) AS Avg_age,
    ROUND(AVG(`Duration of Symptoms (months)`),0) AS Avg_Duration_of_Symptoms_in_months
FROM 
    healthcare_db.ocd_patient_data
GROUP BY 
    Gender;
    
    
-- 7. Percentage of patients having family history of OCD

SELECT 
    ROUND((COUNT(CASE WHEN `Family History of OCD` = 'Yes' THEN 1 END) / COUNT(*)) * 100,2) AS percentage_with_family_history
FROM 
	healthcare_db.ocd_patient_data;


-- ---------------- Treatment Insights ----------------------

-- 8. Medication usage and commonly prescribed medications for OCD patients

SELECT
    Medications,
    ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) AS avg_obsession_score,
    ROUND(AVG(`Y-BOCS Score (Compulsions)`),2) AS avg_compulsion_score,
    COUNT(*) AS prescription_count,
    SUM(CASE WHEN `Depression Diagnosis` = 'Yes' THEN 1 ELSE 0 END) AS depression_count,
    SUM(CASE WHEN `Anxiety Diagnosis` = 'Yes' THEN 1 ELSE 0 END) AS anxiety_count
FROM 
	healthcare_db.ocd_patient_data
WHERE 
	Medications IS NOT NULL
GROUP BY 
    Medications
ORDER BY 
    prescription_count DESC;


-- 9. Comparison of Y-BOCS scores between medicated and non-medicated groups

SELECT 
    CASE WHEN Medications = 'None' THEN 'Non-Medicated' ELSE 'Medicated' END AS medication_group,
    COUNT(*) AS patient_count,
    ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) AS avg_obsession_score,
    ROUND(AVG(`Y-BOCS Score (Compulsions)`),2) AS avg_compulsion_score,
    SUM(CASE WHEN `Depression Diagnosis` = 'Yes' THEN 1 ELSE 0 END) AS depression_count,
    SUM(CASE WHEN `Anxiety Diagnosis` = 'Yes' THEN 1 ELSE 0 END) AS anxiety_count
FROM 
    healthcare_db.ocd_patient_data
GROUP BY 
    medication_group;


    
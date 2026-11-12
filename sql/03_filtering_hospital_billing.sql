/* 03 - SELECT and WHERE filtering
   Uses setup/hospital_billing.sql.
   Engine: SQL Server (T-SQL). */

/*1 Retrieve the patient_id and patient_name for all records in the hospital billing dataset.*/
  SELECT 
    patient_id,
    patient_name
  FROM dbo.hospital_billing

  /*List the patient_id, total_fee, and date_of_admission for patients who have been admitted after '2024-07-15'.*/
  SELECT 
    patient_id,
    total_amount,
    admission_date
  FROM dbo.hospital_billing
  WHERE  admission_date > '2024-07-15'

/*3 Display the patient_id, patient_name, and doctor's_name for patients who have 'Dr. Wilson' as their doctor.*/
SELECT
    patient_id,
    patient_name,
    doctor_name
FROM hospital_billing
WHERE doctor_name ='Dr. Wilson'

/*4 Find the patient_id and total_fee for patients whose total_fee is greater than $7000.*/
SELECT 
    Patient_id,
    total_amount
FROM hospital_billing
WHERE total_amount>7000

/*5 Show the patient_id, patient_name, and nurse_name for patients who have 'Nurse Miller' as their nurse. */
SELECT patient_id,patient_name,nurse_name
FROM hospital_billing
WHERE nurse_name = 'Nurse Miller'

/*6 List the patient_id, total_fee, and date_of_admission for patients admitted between '2024-07-20' and '2024-08-20'.
*/
SELECT 
    patient_id,
    total_amount,
    admission_date
FROM hospital_billing
WHERE admission_date IN ('2024-07-20','2024-08-20')

/*7 Display the patient_id, patient_name, and total_fee for patients with 'Paid' status.*/
SELECT 
    patient_id,
    patient_name,
    total_amount
FROM hospital_billing
WHERE payment_status ='Paid';

/*8.Retrieve the patient_id, patient_name, and medicenes_list for patients with 'Unpaid' status.*/
SELECT 
    patient_id,
    patient_name
FROM hospital_billing
WHERE payment_status = 'Unpaid';

/*9 Show the patient_id, patient_name, and nurse_name for patients who have 'Nurse Perez' as their nurse and 
'Dr. Adams' as their doctor.*/
SELECT 
    patient_id,
    patient_name,
    nurse_name,
    doctor_name
FROM hospital_billing
WHERE nurse_name ='Nurse perez' 
                    AND doctor_name = 'Dr. Adams'

/*10 Find the patient_id and total_fee for patients who have 'General' as their room type.*/
SELECT
    patient_id,
    patient_name,
    total_amount
FROM hospital_billing
WHERE room_type ='General'

/*11 Display the patient_id, patient_name, and doctor's_name for patients who have a 
total_fee between $4000 and $6000.*/
SELECT 
    patient_id,
    patient_name,
    doctor_name,
    total_amount
FROM hospital_billing
WHERE total_amount BETWEEN 4000 AND 6000

/*12 List the patient_id, total_fee, and date_of_admission for patients who were admitted before '2024-07-10'.*/
SELECT 
    patient_id,
    total_amount,
    admission_date
FROM hospital_billing
WHERE admission_date < '2024-07-10'

/*13 Show the patient_id, patient_name, and nurse_name for patients with 'Semi-Private' room type.
cross verify :SELECT 
    
    COUNT(room_type)
FROM hospital_billing
WHERE room_type= 'semi-private'


*/
SELECT
    patient_id,
    patient_name,
    nurse_name,
    room_type
FROM hospital_billing
WHERE room_type = 'Semi-Private'

/*14 Retrieve the patient_id, total_fee, and date_of_admission for patients whose total_fee is less than $5000.*/
SELECT
    patient_id,
    total_amount,
    admission_date
FROM hospital_billing
WHERE total_amount < 5000

/*15 Display the patient_id, patient_name, and total_fee for patients with 'Private' room type.*/
SELECT 
    patient_id,
    patient_name,
    total_amount,
    room_type
FROM hospital_billing
WHERE room_type='Private'

/*16 Find the patient_id and total_fee for patients who have 'Paid' status and a total_fee greater than $6000.*/
SELECT
    patient_id,
    total_amount,
    payment_status
FROM hospital_billing
WHERE payment_status = 'Paid' AND total_amount> '6000'

/*17 Show the patient_id, patient_name, and nurse_name for patients who have 
'Nurse Wilson' as their nurse and 'Dr. Perez' as their doctor.*/

SELECT 
    patient_id,
    patient_name,
    nurse_name,
    doctor_name
FROM hospital_billing
WHERE nurse_name LIKE '%wilson%' AND doctor_name='DR. perez'

/*18 List the patient_id, total_fee, and date_of_admission for patients who were admitted after '2024-08-20'.*/
SELECT
    patient_id,
    total_amount,
    admission_date
FROM hospital_billing
WHERE admission_date>'2024-08-20'


/*19 Display the patient_id, patient_name, and doctor's_name for patients with 'Unpaid' status 
and a total_fee less than $4000.
*/
SELECT
    patient_id,
    patient_name,
    doctor_name
FROM hospital_billing
WHERE payment_status = 'unpaid' AND total_amount<'4000'

/*20 Retrieve the patient_id, patient_name, and nurse_name for patients who have 
'Nurse Perez' as their nurse and a total_fee greater than $5000.*/

SELECT
    patient_id,
    patient_name,
    nurse_name,
    total_amount
FROM hospital_billing
WHERE nurse_name = 'nurse perez' AND total_amount>'5000'


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- Q6: "between '2024-07-20' and '2024-08-20'" was written with IN, which only matches those two exact days.
SELECT patient_id, total_amount, admission_date
FROM hospital_billing
WHERE admission_date BETWEEN '2024-07-20' AND '2024-08-20';

-- Q8 asks for a medicines list, but the table has no such column: say so instead of silently dropping it.

-- Q16, Q19, Q20 compare numbers with strings ('6000'), which forces an implicit conversion; compare numbers.
SELECT patient_id, total_amount, payment_status
FROM hospital_billing
WHERE payment_status = 'Paid' AND total_amount > 6000;

-- Q17 used LIKE '%wilson%', which would also match 'Nurse Wilson-Grant'; the question asks for an exact name.
SELECT patient_id, patient_name, nurse_name, doctor_name
FROM hospital_billing
WHERE nurse_name = 'Nurse Wilson' AND doctor_name = 'Dr. Perez';

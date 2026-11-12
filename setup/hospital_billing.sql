/* Practice table for sql/03_filtering_hospital_billing.sql (fictional data). */

CREATE TABLE hospital_billing (
    patient_id INT PRIMARY KEY,
    patient_name NVARCHAR(100),
    admission_date DATE,
    discharge_date DATE,
    total_amount DECIMAL(10, 2),
    insurance_coverage DECIMAL(10, 2),
    payment_status NVARCHAR(50),
    room_type NVARCHAR(50),
    doctor_name NVARCHAR(100),
    nurse_name NVARCHAR(100)
);

INSERT INTO hospital_billing (patient_id, patient_name, admission_date, discharge_date, total_amount, insurance_coverage, payment_status, room_type, doctor_name, nurse_name)
VALUES
    (1, 'John Doe', '2023-01-05', '2023-01-10', 5000, 2500, 'Paid', 'Private', 'Dr. Smith', 'Nurse Johnson'),
    (2, 'Jane Smith', '2023-02-10', '2023-02-15', 7000, 4000, 'Paid', 'Semi-Private', 'Dr. Johnson', 'Nurse Brown'),
    (3, 'Michael Johnson', '2023-03-15', '2023-03-20', 6500, 3000, 'Unpaid', 'General', 'Dr. Miller', 'Nurse Martinez'),
    (4, 'Sarah Williams', '2023-04-20', '2023-04-25', 8500, 5000, 'Paid', 'Private', 'Dr. Davis', 'Nurse Thompson'),
    (5, 'Emily Brown', '2023-05-25', '2023-05-30', 5500, 3000, 'Unpaid', 'Semi-Private', 'Dr. Wilson', 'Nurse Harris'),
    (6, 'David Miller', '2023-06-30', '2023-07-05', 9000, 6000, 'Paid', 'General', 'Dr. Taylor', 'Nurse Rodriguez'),
    (7, 'Olivia Martinez', '2023-07-10', '2023-07-15', 7500, 3500, 'Paid', 'Private', 'Dr. Adams', 'Nurse Lee'),
    (8, 'Alexander Taylor', '2023-08-15', '2023-08-20', 6000, 2000, 'Unpaid', 'Semi-Private', 'Dr. Brown', 'Nurse Scott'),
    (9, 'Emma Thompson', '2023-09-20', '2023-09-25', 8000, 4500, 'Paid', 'General', 'Dr. Harris', 'Nurse Perez'),
    (10, 'Noah Wilson', '2023-10-25', '2023-10-30', 7200, 3000, 'Unpaid', 'Private', 'Dr. Wilson', 'Nurse King'),
    (11, 'Isabella Rodriguez', '2023-11-30', '2023-12-05', 6800, 3500, 'Paid', 'Semi-Private', 'Dr. Anderson', 'Nurse White'),
    (12, 'Ethan Lee', '2023-12-10', '2023-12-15', 5400, 2000, 'Unpaid', 'General', 'Dr. Martinez', 'Nurse Taylor'),
    (13, 'Sophia Scott', '2024-01-15', '2024-01-20', 9200, 5000, 'Paid', 'Private', 'Dr. Perez', 'Nurse Thomas'),
    (14, 'Mia Perez', '2024-02-20', '2024-02-25', 6300, 3000, 'Unpaid', 'Semi-Private', 'Dr. King', 'Nurse Hall'),
    (15, 'James King', '2024-03-25', '2024-03-30', 7800, 4500, 'Paid', 'General', 'Dr. White', 'Nurse Allen'),
    (16, 'Benjamin Hall', '2024-04-30', '2024-05-05', 6800, 3500, 'Unpaid', 'Private', 'Dr. Hall', 'Nurse Young'),
    (17, 'Abigail Allen', '2024-05-10', '2024-05-15', 7400, 4000, 'Paid', 'Private', 'Dr. Young', 'Nurse Adams'),
    (18, 'Ella Thomas', '2024-06-15', '2024-06-20', 5700, 3000, 'Paid', 'General', 'Dr. Adams', 'Nurse Perez'),
    (19, 'Jacob Young', '2024-07-20', '2024-07-25', 8900, 4500, 'Unpaid', 'Semi-Private', 'Dr. Perez', 'Nurse Wilson'),
    (20, 'Charlotte Adams', '2024-08-25', '2024-08-30', 6900, 3500, 'Paid', 'Private', 'Dr. Wilson', 'Nurse Miller');

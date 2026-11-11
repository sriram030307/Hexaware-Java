-- Day 5 Set 3: Hospital Patient Records
CREATE DATABASE IF NOT EXISTS hospital_training; USE hospital_training;
CREATE TABLE IF NOT EXISTS patients(patient_id INT PRIMARY KEY,patient_name VARCHAR(100) NOT NULL,address_line VARCHAR(200) NOT NULL,phone VARCHAR(20) NOT NULL);
CREATE TABLE IF NOT EXISTS departments(department_id INT PRIMARY KEY,department_name VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE IF NOT EXISTS doctors(doctor_id INT PRIMARY KEY,doctor_name VARCHAR(100) NOT NULL,department_id INT NOT NULL,FOREIGN KEY(department_id) REFERENCES departments(department_id));
CREATE TABLE IF NOT EXISTS visits(visit_id INT PRIMARY KEY,patient_id INT NOT NULL,doctor_id INT NOT NULL,visit_date DATE NOT NULL CHECK(visit_date<=CURRENT_DATE),diagnosis VARCHAR(200),prescription VARCHAR(200),status ENUM('OPEN','CLOSED') NOT NULL DEFAULT 'OPEN',FOREIGN KEY(patient_id) REFERENCES patients(patient_id),FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id));
CREATE TABLE IF NOT EXISTS billing(billing_id INT PRIMARY KEY,visit_id INT NOT NULL UNIQUE,bill_amount DECIMAL(12,2) NOT NULL CHECK(bill_amount>=0),paid_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK(paid_amount>=0 AND paid_amount<=bill_amount),FOREIGN KEY(visit_id) REFERENCES visits(visit_id));
INSERT IGNORE INTO patients VALUES (1,'Patient One','Chennai','9000000001'),(2,'Patient Two','Madurai','9000000002'),(3,'Patient Three','Coimbatore','9000000003'),(4,'Patient Four','Chennai','9000000004'),(5,'Patient Five','Salem','9000000005'),(6,'Patient Six','Trichy','9000000006'),(7,'Patient Seven','Chennai','9000000007'),(8,'Patient Eight','Vellore','9000000008'),(9,'Patient Nine','Erode','9000000009'),(10,'Patient Ten','Chennai','9000000010');
INSERT IGNORE INTO departments VALUES (1,'Cardiology'),(2,'Neurology'),(3,'Orthopaedics'),(4,'General Medicine'),(5,'Dermatology'),(6,'ENT'),(7,'Paediatrics'),(8,'Oncology'),(9,'Ophthalmology'),(10,'Psychiatry');
INSERT IGNORE INTO doctors VALUES (1,'Dr A',1),(2,'Dr B',2),(3,'Dr C',3),(4,'Dr D',4),(5,'Dr E',5),(6,'Dr F',6),(7,'Dr G',7),(8,'Dr H',8),(9,'Dr I',9),(10,'Dr J',10);
INSERT IGNORE INTO visits VALUES (1,1,1,'2026-10-01','Checkup','Rest','OPEN'),(2,2,2,'2026-10-02','Review','Medication','OPEN'),(3,3,3,'2026-10-03','Pain','Therapy','CLOSED'),(4,4,4,'2026-10-04','Fever','Rest','OPEN'),(5,5,5,'2026-10-05','Allergy','Medicine','CLOSED'),(6,6,6,'2026-10-06','Ear pain','Drops','OPEN'),(7,7,7,'2026-10-07','Child review','Advice','OPEN'),(8,8,8,'2026-10-08','Follow-up','Review','CLOSED'),(9,9,9,'2026-10-09','Vision','Glasses','OPEN'),(10,10,10,'2026-10-10','Consult','Review','OPEN');
INSERT IGNORE INTO billing VALUES (1,1,1000,1000),(2,2,1500,500),(3,3,1200,1200),(4,4,800,0),(5,5,2000,1000),(6,6,900,900),(7,7,700,0),(8,8,1800,1800),(9,9,1100,0),(10,10,1300,500);
SELECT * FROM visits WHERE visit_id=1; UPDATE visits SET status='CLOSED' WHERE visit_id=1;
DELETE FROM billing WHERE visit_id=10; DELETE FROM visits WHERE visit_id=10;
SELECT DISTINCT p.patient_id,p.patient_name,v.visit_date FROM patients p JOIN visits v ON p.patient_id=v.patient_id WHERE v.visit_date>='2026-10-01' AND v.visit_date<'2026-11-01' ORDER BY v.visit_date;
SELECT d.doctor_name,dep.department_name FROM doctors d JOIN departments dep ON d.department_id=dep.department_id ORDER BY dep.department_name,d.doctor_name;
-- Safe table admin demo only (DROP DATABASE intentionally omitted)
CREATE TABLE demo_table(id INT PRIMARY KEY,note VARCHAR(40)); RENAME TABLE demo_table TO renamed_demo_table; DROP TABLE renamed_demo_table;

-- seed.sql
-- Realistic sample data: 15 farmers, 8 products, 3 seasons,
-- 32 quota rows, 45 issue rows and 24 stock receipts.

INSERT INTO farmers (farmer_code, farmer_name, village, phone, registered_on, status) VALUES
('F001','Aarav Patil','Nandgaon','9000000001','2026-01-10','ACTIVE'),
('F002','Meera Shah','Khed','9000000002','2026-01-12','ACTIVE'),
('F003','Rohan More','Pargaon','9000000003','2026-01-14','ACTIVE'),
('F004','Sneha Jadhav','Wadgaon','9000000004','2026-01-16','ACTIVE'),
('F005','Vikram Pawar','Kasarwadi','9000000005','2026-01-18','ACTIVE'),
('F006','Anaya Kulkarni','Shirur','9000000006','2026-01-20','ACTIVE'),
('F007','Kabir Deshmukh','Manchar','9000000007','2026-01-22','ACTIVE'),
('F008','Isha Joshi','Rajgurunagar','9000000008','2026-01-24','ACTIVE'),
('F009','Omkar Gaikwad','Alephata','9000000009','2026-01-26','ACTIVE'),
('F010','Diya Bhosale','Junnar','9000000010','2026-01-28','ACTIVE'),
('F011','Aditya Salunkhe','Narayanpur','9000000011','2026-02-01','ACTIVE'),
('F012','Kavya Chavan','Daund','9000000012','2026-02-03','ACTIVE'),
('F013','Neel Joshi','Baramati','9000000013','2026-02-05','ACTIVE'),
('F014','Tara Mane','Indapur','9000000014','2026-02-07','ACTIVE'),
('F015','Yash Shinde','Bhigwan','9000000015','2026-02-09','ACTIVE');

INSERT INTO products (product_code, product_name, category, unit, reorder_level) VALUES
('P001','Wheat Seed','SEED','kg',500),
('P002','Rice Seed','SEED','kg',400),
('P003','Maize Seed','SEED','kg',350),
('P004','Cotton Seed','SEED','kg',250),
('P005','Urea','FERTILISER','kg',700),
('P006','DAP','FERTILISER','kg',600),
('P007','Potash','FERTILISER','kg',450),
('P008','NPK 10-26-26','FERTILISER','kg',500);

INSERT INTO seasons (season_name, start_date, end_date) VALUES
('Kharif 2026','2026-06-01','2026-10-31'),
('Rabi 2026-27','2026-11-01','2027-03-31'),
('Summer 2027','2027-04-01','2027-05-31');

-- Kharif quotas
INSERT INTO quotas (farmer_id, product_id, season_id, quota_qty) VALUES
(1,1,1,100),(1,5,1,150),(1,6,1,100),
(2,1,1,120),(2,2,1,80),(2,5,1,140),
(3,2,1,100),(3,6,1,120),
(4,3,1,150),(4,5,1,180),
(5,1,1,90),(5,7,1,100),
(6,4,1,80),(6,5,1,120),
(7,3,1,130),(7,6,1,100),
(8,2,1,90),(8,8,1,100),
(9,1,1,110),(9,5,1,150),
(10,3,1,120),(10,7,1,100),
(11,4,1,90),(11,6,1,110),
(12,2,1,100),(12,5,1,130),
(13,1,1,100),(13,8,1,120),
(14,3,1,140),(14,6,1,120),
(15,4,1,100),(15,7,1,100);

-- Rabi quotas for a smaller set
INSERT INTO quotas (farmer_id, product_id, season_id, quota_qty) VALUES
(1,1,2,120),(2,2,2,100),(3,1,2,100),(4,5,2,160),
(5,6,2,120),(6,3,2,130),(7,1,2,100),(8,5,2,150),
(9,2,2,100),(10,6,2,100);

-- Stock receipts
INSERT INTO stock_receipts (product_id, receipt_date, quantity, supplier, batch_no) VALUES
(1,'2026-05-20',1800,'Maharashtra Seed Corp','B001'),
(1,'2026-07-05',700,'Maharashtra Seed Corp','B002'),
(2,'2026-05-22',1500,'GreenField Seeds','B003'),
(2,'2026-07-10',500,'GreenField Seeds','B004'),
(3,'2026-05-25',1200,'AgroStar Seeds','B005'),
(3,'2026-07-12',400,'AgroStar Seeds','B006'),
(4,'2026-05-28',900,'CottonGrow Ltd','B007'),
(5,'2026-05-18',2500,'Bharat Fertilisers','B008'),
(5,'2026-07-08',800,'Bharat Fertilisers','B009'),
(6,'2026-05-19',2200,'Krishi Chemicals','B010'),
(6,'2026-07-09',600,'Krishi Chemicals','B011'),
(7,'2026-05-21',1600,'Agro Inputs India','B012'),
(8,'2026-05-23',1300,'National Fertiliser Co','B013'),
(8,'2026-07-15',500,'National Fertiliser Co','B014'),
(1,'2026-10-15',500,'Maharashtra Seed Corp','B015'),
(2,'2026-10-16',400,'GreenField Seeds','B016'),
(3,'2026-10-18',300,'AgroStar Seeds','B017'),
(4,'2026-10-20',200,'CottonGrow Ltd','B018'),
(5,'2026-10-22',600,'Bharat Fertilisers','B019'),
(6,'2026-10-23',500,'Krishi Chemicals','B020'),
(7,'2026-10-24',400,'Agro Inputs India','B021'),
(8,'2026-10-25',400,'National Fertiliser Co','B022'),
(5,'2026-11-10',700,'Bharat Fertilisers','B023'),
(6,'2026-11-12',500,'Krishi Chemicals','B024');

-- Kharif issues: enough variation for subquery results.
INSERT INTO issues (issue_no, farmer_id, product_id, season_id, issue_date, quantity) VALUES
('I001',1,1,1,'2026-06-10',95),
('I002',1,5,1,'2026-06-12',120),
('I003',1,6,1,'2026-06-15',80),
('I004',2,1,1,'2026-06-11',110),
('I005',2,2,1,'2026-06-14',60),
('I006',2,5,1,'2026-06-18',130),
('I007',3,2,1,'2026-06-12',70),
('I008',3,6,1,'2026-06-19',110),
('I009',4,3,1,'2026-06-13',140),
('I010',4,5,1,'2026-06-20',170),
('I011',5,1,1,'2026-06-15',50),
('I012',5,7,1,'2026-06-21',90),
('I013',6,4,1,'2026-06-16',75),
('I014',6,5,1,'2026-06-22',100),
('I015',7,3,1,'2026-06-17',120),
('I016',7,6,1,'2026-06-23',95),
('I017',8,2,1,'2026-06-18',80),
('I018',8,8,1,'2026-06-24',90),
('I019',9,1,1,'2026-06-19',105),
('I020',9,5,1,'2026-06-25',140),
('I021',10,3,1,'2026-06-20',100),
('I022',10,7,1,'2026-06-26',95),
('I023',11,4,1,'2026-06-21',70),
('I024',11,6,1,'2026-06-27',100),
('I025',12,2,1,'2026-06-22',85),
('I026',12,5,1,'2026-06-28',120),
('I027',13,1,1,'2026-06-23',90),
('I028',13,8,1,'2026-06-29',110),
('I029',14,3,1,'2026-06-24',115),
('I030',14,6,1,'2026-06-30',105),
-- F15 has a quota but no Kharif issue, useful for NOT EXISTS.
-- Extra repeated issues to demonstrate latest-issue logic.
('I031',1,5,1,'2026-07-10',20),
('I032',2,5,1,'2026-07-11',10),
('I033',9,1,1,'2026-07-12',5),
('I034',13,8,1,'2026-07-13',5),
('I035',4,5,1,'2026-07-14',5);

-- Rabi issues
INSERT INTO issues (issue_no, farmer_id, product_id, season_id, issue_date, quantity) VALUES
('I036',1,1,2,'2026-11-20',100),
('I037',2,2,2,'2026-11-21',90),
('I038',3,1,2,'2026-11-22',80),
('I039',4,5,2,'2026-11-23',150),
('I040',5,6,2,'2026-11-24',100),
('I041',6,3,2,'2026-11-25',120),
('I042',7,1,2,'2026-11-26',90),
('I043',8,5,2,'2026-11-27',140),
('I044',9,2,2,'2026-11-28',95),
('I045',10,6,2,'2026-11-29',90);

CREATE TABLE Person (
   userID INT UNSIGNED NOT NULL UNIQUE,
   email VARCHAR(50),
   Fname  VARCHAR(50),
   Lname  VARCHAR(50),
   DoB DATE NOT NULL DEFAULT '0000-00-00',
   PRIMARY KEY(userID) 
);



CREATE TABLE Phone (
   userID     INT UNSIGNED NOT NULL,
   serialNo   INT UNSIGNED NOT NULL AUTO_INCREMENT,
   country_code VARCHAR(4),
   area_code VARCHAR(3),
   phone_number VARCHAR(15),
   PRIMARY KEY(serialNo,userID),
   FOREIGN KEY (userID) REFERENCES Person (userID)
);



CREATE TABLE Villa (
VillaID INT UNSIGNED NOT NULL,
VName VARCHAR(15),
con_year DATE,
age INT UNSIGNED,
picture_url VARCHAR(100),
VOwner INT UNSIGNED NOT NULL,
PRIMARY KEY(VillaID),
FOREIGN KEY(VOwner) REFERENCES Person(userID) 
);

CREATE TABLE Coupon (
villaID INT UNSIGNED NOT NULL,
CouponCode VARCHAR(10) NOT NULL UNIQUE,
startDate DATE,
endDate DATE,
Discount INT SIGNED NOT NULL,
created_by  INT UNSIGNED NOT NULL,
PRIMARY KEY(CouponCode),
FOREIGN KEY(villaID) REFERENCES Villa(VillaID),
FOREIGN KEY(created_by) REFERENCES Person(userID)
);


CREATE TABLE reservation (
reservationNo INT UNSIGNED NOT NULL,
villaID INT UNSIGNED NOT NULL,
userID INT UNSIGNED NOT NULL,
Fname VARCHAR(50),Lname VARCHAR(50),startDate DATE,
endDate DATE,
priceHistory DECIMAL(6,2) NOT NULL DEFAULT 0,
depositPrice DECIMAL(6,2) NOT NULL DEFAULT 0,
PRIMARY KEY(reservationNo),
FOREIGN KEY(userID) REFERENCES Person(userID),
FOREIGN KEY(villaID) REFERENCES Villa(VillaID)
);

CREATE TABLE Review (
reviewID INT UNSIGNED NOT NULL AUTO_INCREMENT, 
userID     INT UNSIGNED NOT NULL,
reservationNo INT UNSIGNED NOT NULL,
villaID INT UNSIGNED NOT NULL,
description VARCHAR(100),
rating INT UNSIGNED NOT NULL DEFAULT 0,
PRIMARY KEY(reviewID),
FOREIGN KEY(userID) REFERENCES Person(userID),
FOREIGN KEY(reservationNo) REFERENCES reservation(reservationNo) 
);


CREATE TABLE likedreviews(
SNo INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
reviewID INT UNSIGNED NOT NULL,
userID INT UNSIGNED NOT NULL,
PRIMARY KEY(SNo),
FOREIGN KEY(reviewID) REFERENCES Review(reviewID),
FOREIGN KEY(userID) REFERENCES Person(userID)
);

CREATE TABLE features(
featureID INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
VillaID INT UNSIGNED NOT NULL,
feature VARCHAR(20),
created_by INT UNSIGNED NOT NULL,
PRIMARY KEY(featureID),
FOREIGN KEY(villaID) REFERENCES Villa(VillaID),
FOREIGN KEY(created_by) REFERENCES Person(userID)
);

CREATE TABLE Rate(
rateID INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
VillaID INT UNSIGNED NOT NULL,
startdate DATE,
enddate DATE,
rate NUMERIC(6,2) NOT NULL,
PRIMARY KEY(rateID),
FOREIGN KEY(VillaID) REFERENCES Villa(VillaID)
);

CREATE TABLE couponsapplied(
redemptionNo INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
reservationNo INT UNSIGNED NOT NULL,
CouponCode VARCHAR(10) NOT NULL,
PRIMARY KEY(redemptionNo),
FOREIGN KEY(reservationNo) REFERENCES reservation(reservationNo),
FOREIGN KEY(CouponCode) REFERENCES Coupon(`CouponCode`)
);


CREATE TABLE VOwner(
userID INT UNSIGNED NOT NULL,
reportsto INT UNSIGNED NOT NULL,
PRIMARY KEY (userID),
FOREIGN KEY (userID) REFERENCES Person(userID)
);

CREATE TABLE Favorites(
sNo INT UNSIGNED AUTO_INCREMENT,
userID INT UNSIGNED,
villaID INT UNSIGNED,
PRIMARY KEY(sno),
FOREIGN KEY(userID) REFERENCES Person(userID),
FOREIGN KEY(villaID) REFERENCES Villa(villaID)
);
SHOW TABLES;





DROP TABLE couponsapplied;
DROP TABLE Favorites;
DROP TABLE features;
DROP TABLE likedreviews;
DROP TABLE Phone;
DROP TABLE Rate;
DROP TABLE Review;
DROP TABLE reservation;
DROP TABLE VOwner;
DROP TABLE Coupon;
DROP TABLE Villa;
DROP TABLE Person;



INSERT INTO Person (userID,email,Fname,Lname,DoB) VALUES (1,'jack_killer@gmail.com','Jackie','Jones','1983-2-28'),(2,'Hello_macy@yahoo.com','Jessie','Jackson','1986-03-04'),
(3,'john_black@hotmail.com'	,'Tommy'	,'Trojan'	,'1990-04-22'),
(4,'ny_robert@usc.edu'	,'Niki',	'Nanjan',	'1980-06-10'),
(5,'cool_andrew@bbc.co.uk'	,'Jalli'	,'Shadan'	,'1984-11-27'),
(6,'coryphillip@voa.gov',	'Houtan'	,'Khandan',	'1966-06-06'),
(7,'DaneilJ@msnbc.com',	'Naz'	,'Nazi',	'2000-04-20'),
(8,'rohanau@cs.mit.edu',	'Ab'	,'Bazi'	,'1956-12-12'),
(9,'edmorales@houti.com',	'Ben'	,'Ghazi',	'1973-11-10'),
(10,'danamoon@louti.com',	'Carlos'	,'Santana'	,'1977-07-07'),
(11,'owner1@villa.com',	'Roberto',	'Carlos',	'1955-05-05'),
(12,'owner2@villa.com'	,'De'	,'Vilardo',	'1944-04-04'),
(13,'owner3@villa.com',	'villa'	,'Blanka',	'1974-11-11'),
(14,'ceo@villa.com','nino','bino','1991-01-01'),
(15,'manager2@villa.com','Bookish','Morinio','1950-04-17');

INSERT INTO Villa (villaID,VName,VOwner) VALUES (1,'Fifi',11),
(2,'Lulu',12),
(3,'Penny',13),
(4,'Kiki',11),
(5,'Vivi',11),
(6,'Gigi',11),
(7,'Kitty',12),
(8,'Ellie',13),
(9,'Ali',14),
(10,'Kelley',12),
(11,'Dori',12),
(12,'Houti',13);


INSERT INTO Favorites(userID,villaID) VALUES (1,2),(1,4),(2,8),(3,10),(3,3),(3,7),(3,7),(4,10),(4,4),(5,1),(6,3),(7,2),(7,4),(7,12),(8,1),(8,9),(9,6),(10,11),(10,12),(13,1),(14,2);

INSERT INTO Phone(`userID`,country_code,area_code,phone_number) VALUES (11,'111','111','1111'),(12,'222','222','2222'),(13,'333','333','3333'),(14,'444','444','4444');


INSERT INTO features(VillaID,feature,created_by) VALUES(1,'swimming pool',11),(1,'jacuzzi',11),(2,'swimming pool',12),(3,'swimming pool',13),(3,'xbox360',13),(3,'board games',13),(4,'jacuzzi',11),(5,'xbox360',11),(6,'pets allowed',11),(7,'billiard TABLE',12),(7,'xbox360',12),(7,'board games',12),(7,'pets allowed',12),(8,'pets alowed',13),(9,'board games',14),(10,'board games',12),(11,'jacuzzi',12),(12,'jacuzzi',13);


INSERT INTO reservation(reservationNo,userID,villaID,Fname,Lname,startDate,endDate,depositPrice) VALUES 
(1,1,1,'Jackie','Jones','2013-01-02','2013-01-04',50),
(2,7,2,'Naz','Nazi','2013-01-05','2013-01-06',30),
(3,2,3,'Jessie','Jackson','2013-02-03','2013-02-07',60),
(4,4,4,'Niki','Nanjan','2013-02-04','2013-02-05',39),
(5,4,5,'Niki','Nanjan','2013-03-06','2013-03-12',40),
(6,4,6,'Niki','Nanjan','2013-04-23','2013-04-25',42),
(7,6,7,'Houtan','Khandan','2013-05-29','2013-06-01',60),
(8,10,8,'Carlos','Santana','2013-07-30','2013-08-02',100),
(9,3,9,'Tommy','Trojan','2013-08-11','2013-08-12',24),
(10,2,10,'Jessie','Jackson','2013-08-19','2013-08-21',75),
(11,5,11,'Jalli','Shadan','2013-08-15','2013-08-17',51),
(12,6,12,'Houtan','Khandan','2013-08-27','2013-08-28',33),
(13,2,1,'Jessie','Jackson','2013-09-01','2013-09-03',40),
(14,5,2,'Jalli','Shadan','2013-09-02','2013-09-03',25),
(15,9,3,'Ben','Ghazi','2013-09-15','2013-09-20',36),
(16,5,4,'Jalli','Shadan','2013-10-01','2013-10-03',27),
(17,4,5,'Niki','Nanjan','2013-10-15','2013-10-16',24),
(18,5,6,'Jalli','Shadan','2013-11-02','2013-11-04',30),
(19,10,7,'Carlos','Santana','2013-11-06','2013-11-07',50),
(20,9,8,'Ben','Ghazi','2013-11-06','2013-11-10',60),
(21,4,9,'Niki','Nanjan','2013-11-10','2013-11-13',15),
(22,4,10,'Niki','Nanjan','2013-11-11','2013-11-13',60),
(23,6,11,'Houtan','Khandan','2013-12-01','2013-12-04',40),
(24,5,12,'Jalli','Shadan','2013-12-23','2013-12-26',30),
(25,7,1,'Naz','Nazi','2014-01-12','2014-01-15',48),
(26,9,2,'Ben','Ghazi','2014-01-06','2014-01-07',34),
(27,6,2,'Houtan','Khandan','2014-02-05','2014-02-09',40),
(28,5,5,'Jalli','Shadan','2014-02-09','2014-02-15',50),
(29,4,8,'Niki','Nanjan','2014-03-18','2014-03-19',120),
(30,2,4,'Jessie','Jackson','2014-04-27','2014-04-30',50),
(31,4,10,'Niki','Nanjan','2014-05-29','2014-06-01',96),
(32,9,12,'Ben','Ghazi','2014-07-28','2014-08-02',42),
(33,9,7,'Ben','Ghazi','2014-08-11','2014-08-12',75),
(34,7,4,'Naz','Nazi','2014-08-15','2014-08-21',50),
(35,8,8,'Ab','Bazi','2014-08-13','2014-08-17',120),
(36,3,2,'Tommy','Trojan','2014-08-27','2014-08-28',40),
(37,2,11,'Jessie','Jackson','2014-06-20','2014-06-23',70),
(38,1,2,'Jackie','Jones','2014-08-28','2014-08-30',40),
(39,9,1,'Ben','Ghazi','2014-04-10','2014-04-15',60),
(40,9,7,'Ben','Ghazi','2014-02-05','2014-02-09',75),
(41,8,7,'Ab','Bazi','2014-02-09','2014-02-15',75),
(42,5,7,'Jalli','Shadan','2014-03-18','2014-03-19',75),
(43,6,1,'Houtan','Khandan','2014-05-12','2014-05-13',51);



INSERT INTO likedreviews(reviewID,userID) VALUES (1,4),(1,2),(1,3),(2,7),(2,4),(3,8),(4,9),(5,2),(5,4),(14,2),(14,4),(14,6),(15,3),(15,6),(15,7);


INSERT INTO VOwner(userID,reportsto) VALUES(11,15),(12,15),(13,15),(14,14);


INSERT INTO Coupon(`CouponCode`,`villaID`,`startDate`,`endDate`,Discount,created_by) VALUES(1,1,'2013-09-01','2014-01-31',20,11),
(2,2,'2013-09-01','2013-12-31',15,12),
(3,3,'2013-09-01','2013-12-31',25,13),
(4,4,'2013-09-01','2013-12-31',10,11),
(5,1,'2014-01-01','2014-08-31',15,11);

INSERT INTO couponsapplied(`reservationNo`,`CouponCode`)VALUES(15,3),(16,4),(25,1),(26,2),(43,5);

INSERT INTO Review(`reviewID`,`userID`,`villaID`,`description`,`rating`) VALUES (1,1,1,'Poor maintainance considering the price.',2),
(2,2,3,'Boring and Dull',1),
(3,4,6,'Love it!',4),
(4,2,1,'Best vila error',2),
(5,7,1,"'Though not clean, has fantastic scenery around it'",3),
(6,5,2,'not recommended',1),
(7,6,1,'Good one',4),
(8,4,4,'I gonna rent again and again',5),
(9,9,3,'Good work',5),
(10,3,9,'A must visit villa',5),
(11,10,8,'Nice',1),
(13,6,7,'poor one',1),
(14,1,7,'popular one',4),
(15,7,3,'wanna go back!',5);

INSERT INTO likedreviews(reviewID,userID) VALUES (1,4),(1,2),(1,3),(2,7),(2,4),(3,8),(4,9),(5,2),(5,4),(14,2),(14,4),(14,6),(15,3),(15,6),(15,7);

INSERT INTO Rate(`rateID`,`VillaID`,`startdate`,`enddate`,`rate`) VALUES 
(1,1,'2013-01-01','2013-08-31',150),
(2,2,'2013-01-01','2013-08-31',100),
(3,3,'2013-01-01','2013-08-31',200),
(4,4,'2013-01-01','2013-08-31',130),
(5,5,'2013-01-01','2013-08-31',120),
(6,6,'2013-01-01','2013-08-31',140),
(7,7,'2013-01-01','2013-08-31',180),
(8,8,'2013-01-01','2013-08-31',300),
(9,9,'2013-01-01','2013-08-31',80),
(10,10,'2013-01-01','2013-08-31',250),
(11,11,'2013-01-01','2013-08-31',170),
(12,12,'2013-01-01','2013-08-31',110),
(13,1,'2013-09-01','2013-12-31',120),
(14,2,'2013-09-01','2013-12-31',75),
(15,3,'2013-09-01','2013-12-31',160),
(16,4,'2013-09-01','2013-12-31',90),
(17,5,'2013-09-01','2013-12-31',80),
(18,6,'2013-09-01','2013-12-31',100),
(19,7,'2013-09-01','2013-12-31',150),
(20,8,'2013-09-01','2013-12-31',200),
(21,9,'2013-09-01','2013-12-31',50),
(22,10,'2013-09-01','2013-12-31',200),
(23,11,'2013-09-01','2013-12-31',120),
(24,12,'2013-09-01','2013-12-31',90),
(25,1,'2014-01-01','2014-08-31',180),
(26,2,'2014-01-01','2014-08-31',120),
(27,3,'2014-01-01','2014-08-31',240),
(28,4,'2014-01-01','2014-08-31',150),
(29,5,'2014-01-01','2014-08-31',150),
(30,6,'2014-01-01','2014-08-31',180),
(31,7,'2014-01-01','2014-08-31',250),
(32,8,'2014-01-01','2014-08-31',400),
(33,9,'2014-01-01','2014-08-31',110),
(34,10,'2014-01-01','2014-08-31',320),
(35,11,'2014-01-01','2014-08-31',210),
(36,12,'2014-01-01','2014-08-31',140);



SELECT VillaID ,VName FROM Villa WHERE VillaID IN (SELECT VillaID FROM features WHERE feature LIKE 'jacuzzi' AND feature NOT LIKE 'pets allowed');

SELECT Fname,Lname,VOwner,COUNT(*) FROM Villa,Person WHERE Person.`userID`=Villa.`VOwner` GROUP BY VOwner;

SELECT DISTINCT userID,Fname,Lname FROM reservation WHERE reservationNo IN (SELECT reservationNo FROM couponsapplied WHERE `CouponCode` IN (SELECT CouponCode FROM Coupon WHERE Discount >10));

SELECT userID,Fname,Lname FROM reservation WHERE `startDate`>= '2013-01-01' AND `endDate`< '2014-01-01' ORDER BY `depositPrice` DESC LIMIT 3;


SELECT AVG(DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(DoB, '%Y') - (DATE_FORMAT(NOW(), '00-%m-%d') < DATE_FORMAT(DoB, '00-%m-%d'))) AS Average_Age FROM Person WHERE userID IN(SELECT  DISTINCT userID FROM reservation WHERE startDate <='2013-09-01' AND endDate<='2014-01-01');


SELECT P.userID,P.Fname,P.Lname,V.`VName`,V.`VillaID`,AVG(rating) FROM Review  R INNER JOIN Villa  V ON V.`VillaID`=R.`villaID` INNER JOIN Person P ON V.`VOwner`= P.`userID` GROUP BY V.`VillaID` ORDER BY AVG(rating) DESC LIMIT 3;


SELECT villaID,datediff(`endDate`,`startDate`)daysrented FROM reservation WHERE datediff(`endDate`,`startDate`) IN (SELECT MAX(datediff(`endDate`,`startDate`)) AS daysrented FROM reservation  WHERE startDate AND endDate BETWEEN '2014-01-01' AND '2014-12-31' ) AND startDate AND endDate BETWEEN '2014-01-01' AND '2014-12-30';






SELECT DISTINCT Review.`userID`AS UsersmakingReview , likedreviews.`reviewID`FROM likedreviews 
INNER JOIN Review ON Review.`reviewID`=likedreviews.`reviewID` ;  


SELECT T1.UsersmakingReview,  T1.RID ,MAX(SUM(COUNT(T1.NumberofLikes)))  FROM (SELECT DISTINCT Review.`reviewID` AS RID,count(likedreviews.`reviewID`) AS NumberofLikes, Review.`villaID` AS VID,Review.`userID`AS UsersmakingReview FROM likedreviews 
INNER JOIN Review ON Review.`reviewID`=likedreviews.`reviewID` WHERE Review.`reviewID` = Review.`reviewID`) AS T1 ;  


SELECT DISTINCT Review.`reviewID` AS RID,count(likedreviews.`reviewID`) AS NumberofLikes, Review.`villaID` AS VID,Review.`userID`AS UsersmakingReview FROM likedreviews 
INNER JOIN Review ON Review.`reviewID`=likedreviews.`reviewID` GROUP BY RID;



SELECT VO1 AS VillaOwnerID, (VacantVillas/TotalOwned) AS VacancyRatio FROM  (SELECT T4.VOwner AS VO2,count(T4.VillaID)AS TotalOwned FROM Villa AS T4 GROUP BY T4.VOwner)AS T4,
(SELECT T1.VOwner AS VO1 ,count(DISTINCT T1.`VillaID`) AS VacantVillas FROM Villa AS T1 WHERE T1.`VillaID` IN 
(SELECT DISTINCT T2.villaID FROM reservation AS T2 WHERE T2.villaID NOT IN (SELECT T3.villaID FROM reservation AS T3 WHERE T3.startDate <= '2014-08-15' AND T3.`endDate`>='2014-08-15')
)GROUP BY T1.`VOwner` )AS T1  WHERE VO1 = VO2;



SELECT Person.Fname,Person.`Lname`,T1.`userID`,T1.`reservationNo` AS FirstReservationID,T2.`reservationNo`AS SecondReservationID FROM Person,reservation T1, reservation T2 WHERE
 (T2.`startDate` BETWEEN T1.`startDate` AND T1.`endDate` AND T1.`villaID` != T2.`villaID` AND T1.`userID`=T2.`userID` AND Person.`userID`=T1.`userID`);

 
 SELECT Fname,Lname FROM Person WHERE userID IN (SELECT DISTINCT VOwner FROM Villa WHERE VillaID IN (SELECT  VID2014 FROM  
 (SELECT SUM(DATEDIFF(T1.`endDate`,T1.`startDate`)) AS DiffDate2013 ,villaID AS VID2013 FROM reservation AS T1 WHERE `startDate` >='2013-01-01' AND endDate < DATE_ADD('2013-01-01', INTERVAL 8 MONTH) GROUP BY villaID) AS T1,
 (SELECT Sum(DATEDIFF(T2.`endDate`,T2.`startDate`)) AS DiffDate2014,`villaID` AS VID2014 FROM reservation AS T2 WHERE startDate >='2014-01-01' AND endDate < DATE_ADD('2014-01-01', INTERVAL 8 MONTH) GROUP BY VillaID) AS T3 WHERE VID2013= VID2014 AND ((DiffDate2014-DiffDate2013)/DiffDate2013)*100 >10));  
 
 

 


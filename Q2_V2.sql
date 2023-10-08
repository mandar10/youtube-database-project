-- QUERY
SELECT V1.Video_Title, C1.Channel_Name, T1.VIEW_RATIO_LIKE 
FROM `youtube`.`Video` V1, `youtube`.`Channel` C1,
(
	SELECT V.VIDEO_ID AS VIDEO_ID, (SUM(V1.IS_LIKED)/SUM(V1.IS_VIEWED)) AS VIEW_RATIO_LIKE
		FROM youtube.`User_Video_Relation` V1, youtube.VIDEO V, youtube.USER U, youtube.CHANNEL C
		WHERE V1.VIDEO_ID = V.VIDEO_ID
		AND C.USER_ID = U.USER_ID
		AND C.CHANNEL_ID = V.CHANNEL_ID
		AND U.USER_NAME LIKE '%Marvel Entertainment%'
		GROUP BY V.VIDEO_ID
) AS T1
WHERE V1.Video_ID = T1.Video_ID
AND V1.Channel_ID = C1.Channel_ID
ORDER BY V1.Video_Title ASC;


-- SOFTWARE USED
-- MySQL Server (Xampp)


-- EXPLANATION
-- This is another version of Q2 Query and the only change here is a nested suqeuery is being converted into a join
-- statement query


-- DDL QUERIES
CREATE DATABASE youtube;

CREATE TABLE `youtube`.`User` (
    `User_ID` BIGINT NOT NULL AUTO_INCREMENT,
    `User_Name` VARCHAR(100) NOT NULL UNIQUE,
    `First_Name` VARCHAR(100) NOT NULL,
    `Last_Name` VARCHAR(100) NOT NULL,
    `Age` INT NOT NULL,
    `Email` VARCHAR(100) NOT NULL,
    `Gender` VARCHAR(10) NOT NULL,
    `Address` VARCHAR(1000) NOT NULL,
    `Is_Consumer` BOOLEAN NOT NULL DEFAULT FALSE,
    `Is_Creator` BOOLEAN NOT NULL DEFAULT FALSE,
    CHECK (`Age` > 18),
    PRIMARY KEY (`User_ID`)
);

CREATE TABLE `youtube`.`Channel` (
    `Channel_ID` BIGINT NOT NULL AUTO_INCREMENT,
    `User_ID` BIGINT,
    `Channel_Name` VARCHAR(100) NOT NULL,
    `Channel_Subscription_Count` INT NOT NULL,
    `Channel_Created_Date` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Is_Verified` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`Channel_ID`),
    FOREIGN KEY (`User_ID`) REFERENCES `youtube`.`User`(`User_ID`)
)  ENGINE=INNODB;

CREATE TABLE `youtube`.`Video` (
    `Video_ID` BIGINT NOT NULL AUTO_INCREMENT,
    `User_ID` BIGINT NOT NULL,
    `Channel_ID` BIGINT NOT NULL,
    `Video_Title` VARCHAR(100) NOT NULL,
    `VIdeo_Description` VARCHAR(100) NOT NULL,
    `Video_Thumbnail_URL` VARCHAR(100) NOT NULL,
    `Video_URL` VARCHAR(100) NOT NULL,
    `Video_Category` VARCHAR(100) NOT NULL,
    `Video_Duration` INT NOT NULL,
    `Video_Upload_Date` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Video_ID`),
	FOREIGN KEY (`User_ID`) REFERENCES `youtube`.`User`(`User_ID`),
	FOREIGN KEY (`Channel_ID`) REFERENCES `youtube`.`Channel`(`Channel_ID`)
)  ENGINE=INNODB;

CREATE TABLE `youtube`.`Sponsor` (
    `Sponsor_ID` BIGINT NOT NULL AUTO_INCREMENT,
    `Sponsor_Name` VARCHAR(100) NOT NULL,
    `Sponsor_Email` VARCHAR(100) NOT NULL,
    `Sponsor_Phone` VARCHAR(10) NOT NULL,
    PRIMARY KEY (`Sponsor_ID`)
)  ENGINE=INNODB;

CREATE TABLE `youtube`.`Video_Sponsorship` (
    `Sponsor_ID` BIGINT NOT NULL,
    `Video_ID` BIGINT NOT NULL,
    `Sponsorship_Amount` INT NOT NULL,
	FOREIGN KEY (`Video_ID`) REFERENCES `youtube`.`Video`(`Video_ID`),
	FOREIGN KEY (`Sponsor_ID`) REFERENCES `youtube`.`Sponsor`(`Sponsor_ID`),
	PRIMARY KEY (`Video_ID`,`Sponsor_ID`)
)  ENGINE=INNODB;

CREATE TABLE `youtube`.`User_Video_Relation` (
    `Video_ID` BIGINT NOT NULL,
    `User_ID` BIGINT NOT NULL,
    `Is_Liked` BOOLEAN NOT NULL,
    `Is_Viewed` BOOLEAN NOT NULL,
    `Is_Interested` BOOLEAN NOT NULL,
	FOREIGN KEY (`User_ID`) REFERENCES `youtube`.`User`(`User_ID`),
	FOREIGN KEY (`Video_ID`) REFERENCES `youtube`.`Video`(`Video_ID`),
    PRIMARY KEY (`User_ID`,`Video_ID`)
)  ENGINE=INNODB;

CREATE TABLE `youtube`.`User_Channel_Subscription` (
    `User_ID` BIGINT NOT NULL,
    `Channel_ID` BIGINT NOT NULL,
    `Subscription_Type` BOOLEAN NOT NULL,
	FOREIGN KEY (`User_ID`) REFERENCES `youtube`.`User`(`User_ID`),
	FOREIGN KEY (`Channel_ID`) REFERENCES `youtube`.`Channel`(`Channel_ID`),
    PRIMARY KEY (`User_ID`,`Channel_ID`)
)  ENGINE=INNODB;

CREATE TABLE `youtube`.`Keywords` (
	`Keyword_ID` BIGINT NOT NULL AUTO_INCREMENT,
    `Keyword_Name` VARCHAR(100) NOT NULL,
    `Keyword_Create_Date` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Keyword_ID`)
)  ENGINE=INNODB;

CREATE TABLE `youtube`.`Video_Keyword_Relation` (
	`Keyword_ID` BIGINT  NOT NULL,
    `Video_ID` BIGINT NOT NULL,
    FOREIGN KEY (`Video_ID`) REFERENCES `youtube`.`Video`(`Video_ID`),
    FOREIGN KEY (`Keyword_ID`) REFERENCES `youtube`.`Keywords`(`Keyword_ID`),
    PRIMARY KEY (`Video_ID`, `Keyword_ID`)
)  ENGINE=INNODB;

CREATE TABLE `youtube`.`Video_Comment` (
    `Video_ID` BIGINT NOT NULL,
    `Video_Comment_ID` BIGINT NOT NULL AUTO_INCREMENT,
    `User_ID` BIGINT NOT NULL,
    `Comment_Text` VARCHAR(100) NOT NULL,
    `No_Of_Likes` INT NOT NULL,
    `Comment_Sentiment` DECIMAL(3,2) NOT NULL,
    `Comment_Created_Date` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Video_Comment_ID`),
	FOREIGN KEY (`Video_ID`) REFERENCES `youtube`.`Video`(`Video_ID`),
	FOREIGN KEY (`User_ID`) REFERENCES `youtube`.`User`(`User_ID`)
)  ENGINE=INNODB;


-- DML QUERIES

-- INSERT User QUERIES

INSERT INTO `youtube`.`User` (`User_ID`, `User_Name`, `First_Name`, `Last_Name`, `Age`, `Email`, `Gender`, `Address`, `Is_Consumer`, `Is_Creator`) VALUES
(1, 'MARVEL ENTERTAINMENT', 'John', 'Smith', 25, 'johnsmith@example.com', 'Male', '123 Main St, Anytown, USA', 1, 1),
(3, 'janesmith', 'Jane', 'Smith', 30, 'janesmith@example.com', 'Female', '456 Main St, Anytown, USA', 1, 1),
(4, 'bobjones', 'Bob', 'Jones', 40, 'bobjones@example.com', 'Male', '789 Main St, Anytown, USA', 1, 1),
(5, 'johndoe', 'John', 'Doe', 28, 'johndoe@example.com', 'Male', '123 Main St, Anytown, USA', 1, 1),
(6, 'janesmith2', 'Jane', 'Smith', 35, 'janesmith2@example.com', 'Female', '456 Main St, Anytown, USA', 1, 1),
(7, 'sarahjones', 'Sarah', 'Jones', 42, 'sarahjones@example.com', 'Female', '789 Main St, Anytown, USA', 1, 1),
(8, 'jimsmith', 'Jim', 'Smith', 24, 'jimsmith@example.com', 'Male', '123 Main St, Anytown, USA', 1, 1),
(9, 'lisawang', 'Lisa', 'Wang', 50, 'lisawang@example.com', 'Female', '456 Main St, Anytown, USA', 1, 1),
(10, 'taylorswift', 'Taylor', 'Swift', 29, 'taylor@example.com', 'Female', '456 Main St, Anytown, USA', 1, 1),
(11, 'user1', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(12, 'user2', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(13, 'user3', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(14, 'user4', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(15, 'user5', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(16, 'user6', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(17, 'user7', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(18, 'user8', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(19, 'user9', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(20, 'user11', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(21, 'user12', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(22, 'user13', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(23, 'user14', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(24, 'user15', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(25, 'user16', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(26, 'user17', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(27, 'user18', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(28, 'user19', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(29, 'user21', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(30, 'user22', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(31, 'user23', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(32, 'user24', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(33, 'user25', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(34, 'user26', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(35, 'user27', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(36, 'user28', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(37, 'user29', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(38, 'user31', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(39, 'user32', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(40, 'user33', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(41, 'user34', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(42, 'user35', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(43, 'user36', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(44, 'user37', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(45, 'user38', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(46, 'user39', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(47, 'user41', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(48, 'user42', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(49, 'user43', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(50, 'user44', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(51, 'user45', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(52, 'user46', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(53, 'user47', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(54, 'user48', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(55, 'user49', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(56, 'user51', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(57, 'user52', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(58, 'user53', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(59, 'user54', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(60, 'user55', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(61, 'user56', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(62, 'user57', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(63, 'user58', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(64, 'user59', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(65, 'user61', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(66, 'user62', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(67, 'user63', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(68, 'user64', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(69, 'user65', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(70, 'user66', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(71, 'user67', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(72, 'user68', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(73, 'user69', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(74, 'user71', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(75, 'user72', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(76, 'user73', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(77, 'user74', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(78, 'user75', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(79, 'user76', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(80, 'user77', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(81, 'user78', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(82, 'user79', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(83, 'user81', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(84, 'user82', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(85, 'user83', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(86, 'user84', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(87, 'user85', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(88, 'user86', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(89, 'user87', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(90, 'user88', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(91, 'user89', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(92, 'user91', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(93, 'user92', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(94, 'user93', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(95, 'user94', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(96, 'user95', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(97, 'user96', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(98, 'user97', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(99, 'user98', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(100, 'user99', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0),
(101, 'user101', 'John', 'Doe', 25, 'john.doe1@gmail.com', 'Male', '123 Main Street, Anytown, USA', 1, 0),
(102, 'user102', 'Jane', 'Doe', 35, 'jane.doe1@gmail.com', 'Female', '456 Oak Avenue, Anytown, USA', 1, 0),
(103, 'user103', 'Bob', 'Smith', 30, 'bob.smith1@gmail.com', 'Male', '789 Elm Street, Anytown, USA', 1, 0),
(104, 'user104', 'Alice', 'Jones', 40, 'alice.jones1@gmail.com', 'Female', '1011 Pine Avenue, Anytown, USA', 1, 0),
(105, 'user105', 'Tom', 'Brown', 22, 'tom.brown1@gmail.com', 'Male', '1213 Cedar Lane, Anytown, USA', 1, 0),
(106, 'user106', 'Samantha', 'White', 28, 'samantha.white1@gmail.com', 'Female', '1415 Oak Lane, Anytown, USA', 1, 0),
(107, 'user107', 'James', 'Green', 32, 'james.green1@gmail.com', 'Male', '1617 Maple Street, Anytown, USA', 1, 0),
(108, 'user108', 'Emily', 'Black', 26, 'emily.black1@gmail.com', 'Female', '1819 Elm Street, Anytown, USA', 1, 0),
(109, 'user109', 'William', 'Taylor', 31, 'william.taylor1@gmail.com', 'Male', '2021 Oak Avenue, Anytown, USA', 1, 0);

-- INSERT Channel QUERIES

INSERT INTO  `youtube`.`Channel` (`Channel_ID`, `User_ID`, `Channel_Name`, `Channel_Subscription_Count`, `Channel_Created_Date`, `Is_Verified`) VALUES
(1, 1, 'My Channel', 101, '2023-01-01', 0),
(5, 7, 'My Awesome Channel', 1, '2021-01-01', 1),
(6, 4, 'My Verified Channel', 5, '2022-02-25', 1),
(7, 5, 'My Verified Channel 2', 2, '2022-02-25', 1),
(8, 10, 'Taylor Swift', 10, '2022-02-25', 1),
(9, 10, 'Taylor Swift 2', 10, '2022-02-25', 1);

-- INSERT Video Queries

INSERT INTO `youtube`.`Video` (`Video_ID`, `User_ID`, `Channel_ID`, `Video_Title`, `VIdeo_Description`, `Video_Thumbnail_URL`, `Video_URL`, `Video_Category`, `Video_Duration`, `Video_Upload_Date`) VALUES
(1, 1, 1, 'My First Video', 'This is my first video on YouTube', 'https://example.com/thumbnail1.jpg', 'https://example.com/video1.mp4', 'Vlog', 180, '2023-02-26'),
(2, 5, 7, 'How to Cook a Steak', 'Learn how to cook the perfect steak with this step-by-step tutorial', 'https://example.com/thumbnail2.jpg', 'https://example.com/video2.mp4', 'Cooking', 300, '2023-02-26'),
(3, 4, 6, 'Travel Vlog: Exploring Tokyo', 'Join me on my trip to Tokyo as I visit the city’s top attractions', 'https://example.com/thumbnail3.jpg', 'https://example.com/video3.mp4', 'Travel', 480, '2023-02-26'),
(4, 10, 8, 'My Product Review', 'Check out my review of the latest tech product!', 'https://example.com/thumbnail5.jpg', 'https://example.com/video5.mp4', 'Technology', 480, '2023-02-23'),
(5, 10, 8, 'My Fitness Routine', 'Join me for my daily workout routine!', 'https://example.com/thumbnail4.jpg', 'https://example.com/video4.mp4', 'Fitness', 300, '2023-02-20'),
(6, 10, 8, 'My Gaming Stream', 'Join me for some live gaming action!', 'https://example.com/thumbnail3.jpg', 'https://example.com/video3.mp4', 'Gaming', 1200, '2023-02-25'),
(7, 10, 8, 'My Travel Vlog', 'Follow me on my latest travel adventure!', 'https://example.com/thumbnail2.jpg', 'https://example.com/video2.mp4', 'Travel', 240, '2023-02-24'),
(8, 10, 8, 'My New Recipe', 'Check out my latest recipe video!', 'https://example.com/thumbnail1.jpg', 'https://example.com/video1.mp4', 'Food', 180, '2023-02-01'),
(9, 1, 1, 'My first video', 'This is my first video on this channel', 'https://example.com/thumbnail1.jpg', 'https://example.com/video1.mp4', 'Vlogs', 360, '2023-02-26'),
(10, 1, 1, 'My second video', 'Check out my new vlog', 'https://example.com/thumbnail2.jpg', 'https://example.com/video2.mp4', 'Vlogs', 480, '2023-02-26'),
(11, 1, 1, 'My third video', 'A day in my life', 'https://example.com/thumbnail3.jpg', 'https://example.com/video3.mp4', 'Vlogs', 600, '2023-02-26'),
(12, 1, 1, 'My fourth video', 'My thoughts on current events', 'https://example.com/thumbnail4.jpg', 'https://example.com/video4.mp4', 'Opinion', 720, '2023-02-26'),
(13, 1, 1, 'My fifth video', 'How to cook a delicious meal', 'https://example.com/thumbnail5.jpg', 'https://example.com/video5.mp4', 'Cooking', 540, '2023-01-26'),
(14, 10, 8, 'My Product Review', 'Check out my review of the latest tech product!', 'https://example.com/thumbnail5.jpg', 'https://example.com/video5.mp4', 'Technology', 480, '2023-01-23'),
(15, 10, 8, 'My Fitness Routine', 'Join me for my daily workout routine!', 'https://example.com/thumbnail4.jpg', 'https://example.com/video4.mp4', 'Fitness', 300, '2023-01-01'),
(16, 10, 8, 'My Gaming Stream', 'Join me for some live gaming action!', 'https://example.com/thumbnail3.jpg', 'https://example.com/video3.mp4', 'Gaming', 1200, '2023-01-10'),
(17, 10, 8, 'My Travel Vlog', 'Follow me on my latest travel adventure!', 'https://example.com/thumbnail2.jpg', 'https://example.com/video2.mp4', 'Travel', 240, '2023-01-16'),
(18, 10, 8, 'My New Recipe', 'Check out my latest recipe video!', 'https://example.com/thumbnail1.jpg', 'https://example.com/video1.mp4', 'Food', 180, '2023-01-30');

-- INSERT Sponsor Queries

INSERT INTO `youtube`.`Sponsor` (`Sponsor_ID`, `Sponsor_Name`, `Sponsor_Email`, `Sponsor_Phone`) VALUES
(1, 'ABC Corporation', 'abc@example.com', '555-1234'),
(2, 'XYZ Corporation', 'xyz@example.com', '555-5678'),
(3, '123 Company', '123@example.com', '555-9012');

-- INSERT Video_Sponsorship Queries

INSERT INTO `youtube`.`Video_Sponsorship` (`Sponsor_ID`, `Video_ID`, `Sponsorship_Amount`) VALUES
(1, 1, 500),
(1, 4, 100),
(1, 7, 50),
(2, 2, 1000),
(2, 5, 200),
(2, 8, 75),
(3, 3, 750),
(3, 6, 150);

-- INSERT User_Video_Relation Queries

INSERT INTO `youtube`.`User_Video_Relation` (`Video_ID`, `User_ID`, `Is_Liked`, `Is_Viewed`, `Is_Interested`) VALUES
(1, 1, 1, 1, 0),
(1, 3, 0, 1, 1),
(2, 3, 0, 1, 0),
(2, 4, 0, 1, 1),
(4, 3, 1, 1, 1),
(4, 4, 0, 1, 0),
(4, 5, 1, 1, 1),
(5, 4, 0, 0, 0),
(5, 6, 0, 0, 1),
(5, 7, 1, 1, 0),
(7, 1, 1, 1, 1),
(7, 5, 1, 1, 1),
(7, 10, 0, 1, 0),
(9, 1, 1, 1, 0),
(10, 3, 0, 1, 0),
(11, 7, 1, 1, 0),
(12, 8, 1, 1, 0),
(13, 6, 1, 1, 0),
(14, 1, 1, 1, 0),
(14, 3, 1, 1, 0),
(14, 5, 1, 1, 0),
(14, 7, 1, 1, 0),
(15, 4, 1, 1, 1);

-- INSERT User_Channel_Subscription Queries

INSERT INTO `youtube`.`User_Channel_Subscription` (`User_ID`, `Channel_ID`, `Subscription_Type`) VALUES
(1, 1, 1),
(3, 1, 1),
(4, 1, 0),
(5, 1, 1),
(6, 1, 0),
(7, 1, 1),
(8, 1, 0),
(9, 1, 1),
(10, 1, 0),
(10, 5, 1),
(10, 9, 1),
(1, 8, 1),
(11, 1, 1),
(12, 1, 1),
(13, 1, 1),
(14, 1, 1),
(15, 1, 1),
(16, 1, 1),
(17, 1, 1),
(18, 1, 1),
(19, 1, 1),
(20, 1, 1),
(21, 1, 1),
(22, 1, 1),
(23, 1, 1),
(24, 1, 1),
(25, 1, 1),
(26, 1, 1),
(27, 1, 1),
(28, 1, 1),
(29, 1, 1),
(30, 1, 1),
(31, 1, 1),
(32, 1, 1),
(33, 1, 1),
(34, 1, 1),
(35, 1, 1),
(36, 1, 1),
(37, 1, 1),
(38, 1, 1),
(39, 1, 1),
(40, 1, 1),
(41, 1, 1),
(42, 1, 1),
(43, 1, 1),
(44, 1, 1),
(45, 1, 1),
(46, 1, 1),
(47, 1, 1),
(48, 1, 1),
(49, 1, 1),
(50, 1, 1),
(51, 1, 1),
(52, 1, 1),
(53, 1, 1),
(54, 1, 1),
(55, 1, 1),
(56, 1, 1),
(57, 1, 1),
(58, 1, 1),
(59, 1, 1),
(60, 1, 1),
(61, 1, 1),
(62, 1, 1),
(63, 1, 1),
(64, 1, 1),
(65, 1, 1),
(66, 1, 1),
(67, 1, 1),
(68, 1, 1),
(69, 1, 1),
(70, 1, 1),
(71, 1, 1),
(72, 1, 1),
(73, 1, 1),
(74, 1, 1),
(75, 1, 1),
(76, 1, 1),
(77, 1, 1),
(78, 1, 1),
(79, 1, 1),
(80, 1, 1),
(81, 1, 1),
(82, 1, 1),
(83, 1, 1),
(84, 1, 1),
(85, 1, 1),
(86, 1, 1),
(87, 1, 1),
(88, 1, 1),
(89, 1, 1),
(90, 1, 1),
(91, 1, 1),
(92, 1, 1),
(93, 1, 1),
(94, 1, 1),
(95, 1, 1),
(96, 1, 1),
(97, 1, 1),
(98, 1, 1),
(99, 1, 1),
(100, 1, 1),
(101, 1, 1),
(102, 1, 1),
(103, 1, 1),
(104, 1, 1),
(105, 1, 1),
(106, 1, 1),
(107, 1, 1),
(108, 1, 1),
(109, 1, 1);

-- INSERT Keywords Queries


INSERT INTO `youtube`.`Keywords` (`Keyword_ID`, `Keyword_Name`, `Keyword_Create_Date`) VALUES
(1, 'music', '2023-02-26'),
(2, 'cooking', '2023-02-26'),
(3, 'fitness', '2023-02-26'),
(4, 'travel', '2023-02-26'),
(5, 'sports', '2023-02-26');

-- INSERT Video_Keyword_Relation Queries

INSERT INTO `youtube`.`Video_Keyword_Relation` (`Keyword_ID`, `Video_ID`) VALUES
(1, 10),
(1, 14),
(2, 11),
(2, 15),
(3, 12),
(3, 18),
(4, 9),
(4, 16),
(5, 13),
(5, 17);

-- INSERT Video_Comment Queries

INSERT INTO `youtube`.`Video_Comment` (`Video_ID`, `Video_Comment_ID`, `User_ID`, `Comment_Text`, `No_Of_Likes`, `Comment_Sentiment`, `Comment_Created_Date`) VALUES
(9, 1, 1, 'Great video!', 5, '0.80', '2023-02-26'),
(10, 2, 10, 'Thanks for sharing!', 3, '0.50', '2023-02-26'),
(11, 3, 1, 'Interesting topic!', 2, '0.40', '2023-02-26'),
(12, 4, 10, 'I learned a lot!', 1, '0.90', '2023-02-26'),
(13, 5, 1, 'Great job!', 4, '0.60', '2023-02-26'),
(14, 6, 10, 'This is amazing!', 2, '0.20', '2023-02-26'),
(15, 7, 1, 'Keep up the good work!', 3, '0.70', '2023-02-26'),
(16, 8, 10, 'I enjoyed this video!', 6, '0.80', '2023-02-26'),
(17, 9, 1, 'Not my favorite, but still good!', 2, '0.10', '2023-02-26'),
(18, 10, 10, 'This video is really helpful!', 1, '0.30', '2023-02-26'),
(14, 11, 9, 'This is amazing wow!', 2, '0.20', '2023-02-26'),
(15, 12, 4, 'Hello', 1, '0.33', '2023-02-27');
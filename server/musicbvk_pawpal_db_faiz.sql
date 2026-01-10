-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 10, 2026 at 04:23 PM
-- Server version: 10.3.39-MariaDB-log-cll-lve
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `musicbvk_pawpal_db_faiz`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `motivation_message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `user_id`, `pet_id`, `motivation_message`, `created_at`) VALUES
(1, 12, 9, 'i have to admit totty is soo cute', '2026-01-09 12:58:51'),
(2, 12, 1, 'i just lost my dog and tannie really reminds me of him T_T', '2026-01-09 17:43:25'),
(3, 12, 6, 'Simba really seems playful and affectionate. My daughter really loves having playful and affectionate animal', '2026-01-09 18:23:11'),
(4, 12, 7, 'i meann look at the bow... HE IS SOO CUTE', '2026-01-09 19:40:13'),
(5, 12, 4, 'cuz she\'s cute', '2026-01-10 10:26:40');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `donation_type` varchar(50) NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `user_id`, `pet_id`, `donation_type`, `amount`, `created_at`) VALUES
(1, 12, 2, 'Money', 20.00, '2026-01-09 09:28:42'),
(2, 12, 2, 'Money', 90.00, '2026-01-09 09:52:53'),
(3, 12, 2, 'Money', 2.00, '2026-01-10 05:48:37'),
(4, 12, 2, 'Money', 2.00, '2026-01-10 06:27:57');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `pet_gender` varchar(10) DEFAULT NULL,
  `pet_age` float DEFAULT NULL,
  `pet_health` varchar(50) DEFAULT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `pet_gender`, `pet_age`, `pet_health`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(1, 10, 'Tannie', 'Dog', 'male', 3, 'Healthy', 'Adoption', 'Energetic and Loves running', '[\"assets/pets/pet_1_1.png\",\"assets/pets/pet_1_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:33:12'),
(2, 10, 'Bami', 'Dog', 'male', 2.5, 'Healthy', 'Donation', 'Loves playing outside', '[\"assets/pets/pet_2_1.png\",\"assets/pets/pet_2_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:34:18'),
(3, 10, 'Rocket', 'Other', 'male', 3, 'Injured', 'Help/Rescue', 'Found injured, needs care', '[\"assets/pets/pet_3_1.png\",\"assets/pets/pet_3_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:35:39'),
(4, 10, 'Daisy', 'Cat', 'female', 4, 'Healthy', 'Adoption', 'Playful and cuddly', '[\"assets/pets/pet_4_1.png\",\"assets/pets/pet_4_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:37:32'),
(5, 10, 'Luna', 'Rabbit', 'female', 6, 'Need Medical Check', 'Help/Rescue', 'Rescued from street', '[\"assets/pets/pet_5_1.png\"]', '6.4593455', '100.5007849', '2025-12-06 01:38:53'),
(6, 10, 'Simba', 'Dog', 'male', 4, 'Healthy', 'Adoption', 'Playful and affectionate', '[\"assets/pets/pet_6_1.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:40:20'),
(7, 10, 'Coco', 'Dog', 'female', 5, 'Healthy', 'Adoption', 'Friendly and playful', '[\"assets/pets/pet_7_1.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:41:54'),
(8, 10, 'Bella', 'Rabbit', 'female', 3, 'Recovering', 'Help/Rescue', 'Need a safe home', '[\"assets/pets/pet_8_1.png\",\"assets/pets/pet_8_2.png\"]', '6.4595282', '100.4993932', '2025-12-06 01:50:37'),
(9, 10, 'Totty', 'Other', 'male', 2.5, 'Healthy', 'Adoption', 'Cute but really a fast runner', '[\"assets/pets/pet_9_1.png\"]', '6.4593403', '100.5007934', '2025-12-06 11:31:55');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL COMMENT 'Unique ID',
  `name` varchar(100) NOT NULL COMMENT 'User''s full name ',
  `email` varchar(100) NOT NULL COMMENT 'User''s login email',
  `password` varchar(255) NOT NULL COMMENT 'Hashed password',
  `phone` varchar(20) NOT NULL,
  `image_path` text DEFAULT NULL,
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6) COMMENT 'Timestamp'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `image_path`, `reg_date`) VALUES
(1, 'faizlyana', 'faizlyana@gmail.com', '64311ac2d669ab9c8189bb66b354fa4c2cd30cb6', '123456789', NULL, '2025-11-21 17:08:29.998035'),
(10, 'fatimah', 'fatimah@gmail.com', '55af9969919e0f55f3d6ef3daaf47e6aba558859', '123456789', NULL, '2025-11-26 01:04:43.004356'),
(11, 'ali', 'ali@gmail.com', '66f4a5fdce45bed1b1b99474956e530c4671c3a7', '123456789', NULL, '2025-11-26 01:35:40.931660'),
(12, 'ahmad', 'ahmad@gmail.com', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', '0192839400', 'assets/profiles/12.png', '2026-01-09 10:17:46.250411'),
(13, 'faizlyana', 'faezaliyana@gmail.com', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', '0173049200', 'assets/profiles/13.png', '2026-01-09 15:52:07.862960');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `pet_id` (`pet_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID', AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD CONSTRAINT `tbl_pets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

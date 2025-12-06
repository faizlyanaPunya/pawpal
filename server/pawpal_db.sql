-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Dec 06, 2025 at 07:21 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
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

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(1, 10, 'Tannie', 'Dog', 'Adoption', 'Energetic and Loves running', '[\"assets/pets/pet_1_1.png\",\"assets/pets/pet_1_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:33:12'),
(2, 10, 'Bami', 'Dog', 'Donation', 'Loves playing outside', '[\"assets/pets/pet_2_1.png\",\"assets/pets/pet_2_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:34:18'),
(3, 10, 'Rocket', 'Other', 'Help/Rescue', 'Found injured, needs care', '[\"assets/pets/pet_3_1.png\",\"assets/pets/pet_3_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:35:39'),
(4, 10, 'Daisy', 'Cat', 'Adoption', 'Playful and cuddly', '[\"assets/pets/pet_4_1.png\",\"assets/pets/pet_4_2.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:37:32'),
(5, 10, 'Luna', 'Rabbit', 'Help/Rescue', 'Rescued from street', '[\"assets/pets/pet_5_1.png\"]', '6.4593455', '100.5007849', '2025-12-06 01:38:53'),
(6, 10, 'Simba', 'Dog', 'Adoption', 'Playful and affectionate', '[\"assets/pets/pet_6_1.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:40:20'),
(7, 10, 'Coco', 'Dog', 'Adoption', 'Friendly and playful', '[\"assets/pets/pet_7_1.png\"]', '6.4605127', '100.4993932', '2025-12-06 01:41:54'),
(8, 10, 'Bella', 'Rabbit', 'Help/Rescue', 'Need a safe home', '[\"assets/pets/pet_8_1.png\",\"assets/pets/pet_8_2.png\"]', '6.4595282', '100.4993932', '2025-12-06 01:50:37'),
(9, 10, 'Totty', 'Other', 'Adoption', 'Cute but really a fast runner', '[\"assets/pets/pet_9_1.png\"]', '6.4593403', '100.5007934', '2025-12-06 11:31:55');

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
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6) COMMENT 'Timestamp'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `reg_date`) VALUES
(1, 'faizlyana', 'faizlyana@gmail.com', '64311ac2d669ab9c8189bb66b354fa4c2cd30cb6', '123456789', '2025-11-21 17:08:29.998035'),
(10, 'fatimah', 'fatimah@gmail.com', '55af9969919e0f55f3d6ef3daaf47e6aba558859', '123456789', '2025-11-26 01:04:43.004356'),
(11, 'ali', 'ali@gmail.com', '66f4a5fdce45bed1b1b99474956e530c4671c3a7', '123456789', '2025-11-26 01:35:40.931660');

--
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID', AUTO_INCREMENT=12;

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

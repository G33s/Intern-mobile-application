-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 18, 2024 at 01:51 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `account_inform`
--
CREATE DATABASE IF NOT EXISTS `account_inform` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `account_inform`;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `message`, `date`) VALUES
(1, 9, 'รหัสงาน: HRS-93145', '2024-10-07 21:47:21'),
(2, 9, 'รหัสงาน: NAC-65213', '2024-10-07 22:03:22'),
(3, 10, 'รหัสงาน: IGX-46357', '2024-10-08 02:22:40'),
(4, 10, 'รหัสงาน: MIW-09863', '2024-10-08 02:26:15'),
(5, 10, 'รหัสงาน: QAY-16542', '2024-10-08 02:26:57');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `job_key` varchar(8) NOT NULL,
  `location_from_name` text DEFAULT NULL,
  `from_province_name` text DEFAULT NULL,
  `from_district_name` text DEFAULT NULL,
  `from_sub_district_name` text DEFAULT NULL,
  `from_post_code` text DEFAULT NULL,
  `from_building_number` text DEFAULT NULL,
  `location_to_name` text DEFAULT NULL,
  `to_province_name` text DEFAULT NULL,
  `to_district_name` text DEFAULT NULL,
  `to_sub_district_name` text DEFAULT NULL,
  `to_post_code` text DEFAULT NULL,
  `to_building_number` text DEFAULT NULL,
  `contact_number` varchar(10) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `working_status` int(11) NOT NULL,
  `date_start` varchar(255) DEFAULT NULL,
  `date_app_start` varchar(255) DEFAULT NULL,
  `date_app_end` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`id`, `user_id`, `job_key`, `location_from_name`, `from_province_name`, `from_district_name`, `from_sub_district_name`, `from_post_code`, `from_building_number`, `location_to_name`, `to_province_name`, `to_district_name`, `to_sub_district_name`, `to_post_code`, `to_building_number`, `contact_number`, `date`, `working_status`, `date_start`, `date_app_start`, `date_app_end`) VALUES
(1, 2, 'MNY-5491', '5555', 'Chiang Mai', 'Mueang Chiang Mai', '---', '10400', '123', '123', 'Chiang Mai', 'Mueang Chiang Mai', 'Si Phum', '10400', '155/432', '0914092928', '2024-09-16 07:07:04', 4, '2024-09-16', NULL, NULL),
(3, 8, 'RVS-4670', '5555', 'Bangkok', 'Bang Kapi', 'Hua Mak', '10400', 'testt', 'Chiang Mai', 'Bangkok', 'Mueang Phuket', '---', '10400', '112', '0914092928', '2024-09-17 11:22:57', 2, '2024-09-20', NULL, NULL),
(4, 8, 'LCP-1692', '5555', 'Chiang Mai', 'Mueang Chiang Mai', '---', '10400', 'testt', 'Chiang Mai', 'Bangkok', 'Mueang Phuket', '---', '10400', '5454', '0914092928', '2024-09-17 11:24:08', 2, '2024-09-17', NULL, NULL),
(5, 2, 'SGU-1904', '5555', 'Chiang Mai', 'Mueang Chiang Mai', 'Si Phum', '10400', '123', '123', 'Chiang Mai', 'Mueang Chiang Mai', 'Si Phum', '10400', '10', '0914092928', '2024-09-19 05:32:14', 1, '2024-09-19', NULL, NULL),
(6, 8, 'OXT-1829', '123', 'Bangkok', 'Mueang Chiang Mai', 'Si Phum', '10400', 'testt', 'Chiang Mai', 'Chiang Mai', 'Mueang Chiang Mai', 'Talat Yai', '10400', '155/432', '0914092928', '2024-09-23 07:37:40', 1, '2024-09-23', NULL, NULL),
(7, 8, 'KPQ-7930', '5555', 'Chiang Mai', 'Mueang Chiang Mai', 'Talat Yai', '10400', '123', 'Chiang Mai', 'Bangkok', 'Mueang Chiang Mai', 'Si Phum', '10400', '112', '0914092928', '2024-09-24 08:07:22', 2, '2024-09-24', '2024-09-24 15:17:12', '2024-09-25 16:35:12'),
(8, 8, 'RTB-9261', '5555', 'Chiang Mai', 'Mueang Phuket', 'Si Phum', '10400', '123', 'Chiang Mai', 'Chiang Mai', 'Mueang Chiang Mai', 'Si Phum', '10400', '123', '0914092928', '2024-09-25 08:46:05', 2, '2024-09-25', '2024-09-25 15:46:54', '2024-09-25 16:26:53'),
(9, 8, 'CHU-2386', 'test', 'Bangkok', 'Bang Kapi', 'Si Phum', '10400', '123', 'Chiang Mai', 'Phuket', 'Mueang Phuket', 'Hua Mak', '10400', '5454', '0914092928', '2024-10-07 11:25:29', 2, '2024-10-07', '2024-10-07 18:32:13', '2024-10-07 18:32:42'),
(10, 8, 'XIY-0134', '5555', 'Chiang Mai', 'Mueang Chiang Mai', 'Talat Yai', '10400', '123', 'Chiang Mai', 'Chiang Mai', 'Mueang Chiang Mai', 'Hua Mak', '10400', '123', '0914092928', '2024-10-07 15:37:46', 3, '2024-10-07', '2024-10-07 22:37:58', NULL),
(11, 9, 'HRS-9314', 'test', 'Bangkok', 'Mueang Chiang Mai', 'Si Phum', '10400', 'testt', 'Chiang Mai', 'Chiang Mai', 'Mueang Chiang Mai', 'Si Phum', '10400', '155/432', '0914092928', '2024-10-07 21:47:21', 2, '2024-10-08', '2024-10-08 05:06:53', '2024-10-08 05:07:05'),
(12, 9, 'NAC-6521', '5555', 'เชียงใหม่', 'เมืองเชียงใหม่', 'ช้างเผือก', '10400', 'testt', 'Chiang Mai', 'เชียงใหม่', 'อเมืองเชียงใหม่', 'ช้างเผือก', '10400', '155/432', '0914092928', '2024-10-07 22:03:22', 4, '2024-10-08', '2024-10-08 05:06:04', NULL),
(13, 10, 'IGX-4635', 'test', 'กรุงเพพ', 'ดินแดง', 'ดินแดง', '10400', '123', 'test2', 'เชียงใหม่', 'เมืองเชียงใหม่', 'ช้างเผือก', '1055', '123456', '000', '2024-10-08 02:22:40', 2, '2024-10-08', '2024-10-08 09:24:01', '2024-10-08 09:25:08'),
(14, 10, 'MIW-0986', 'test', 'กรุงเพพ', 'ดินแดง', 'ดินแดง', '10400', '123', 'test2', 'กรุงเพพ', 'เมืองเชียงใหม่', 'ช้างเผือก', '1055', '123456', '000', '2024-10-08 02:26:15', 1, '2024-10-09', NULL, NULL),
(15, 10, 'QAY-1654', 'test', 'เชียงใหม่', 'บางแสน', 'ดินแดง', '10400', '123', 'test2', 'กรุงเพพ', 'ดินแดง', 'ช้างเผือก', '1055', '123456', '000', '2024-10-08 02:26:57', 4, '2024-10-08', '2024-10-08 09:27:03', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `profile_name` varchar(50) DEFAULT NULL,
  `bill_code` varchar(7) NOT NULL DEFAULT '',
  `car_type` char(255) DEFAULT NULL,
  `car_regis` varchar(20) DEFAULT NULL,
  `regis_province` varchar(255) DEFAULT NULL,
  `car_brand` varchar(255) DEFAULT NULL,
  `tank_number` varchar(255) DEFAULT NULL,
  `department_leader` char(255) DEFAULT NULL,
  `department_phone` varchar(255) DEFAULT NULL,
  `branch` char(255) DEFAULT NULL,
  `web_permission` int(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `phone`, `profile_name`, `bill_code`, `car_type`, `car_regis`, `regis_province`, `car_brand`, `tank_number`, `department_leader`, `department_phone`, `branch`, `web_permission`) VALUES
(1, 'admin', 'admin123', '123', 'super admin', '123456', 'รถ 6 ล้อ 7.2เมตร', '12-333', 'ชลบุรี', 'HONDA', 'ABCDEFG123QWER', 'ศรัณย์ จิรพันธุ์เพชร', '0914092928', 'กรุงเทพ', 1),
(2, 'test', 'test555', '111', 'test user', '654321', 'รถ 6 ล้อ 7.2เมตร', '789-999', 'เชียงใหม่', 'Lamborghini', '456789GGWP456', 'ศรัณย์ จิรพันธุ์เพชร', '0914092928', 'เชียงราย', 2),
(8, 'piggy', '654321', '0914092928', 'หมูหมา กาไก่', '777', 'car', '456', 'bkk', 'toyota', '864', 'ศ', '09145612', 'กทม', 2),
(9, 'testv2', '999', '0914092928', 'full test', '999', 'car', 't 555', 'bkk', 'toyota', '123', 'qweqwe', '09145612', '123', 2),
(10, 'user1', '123456', '081455', 'first user', '789', 'car', '123asd', 'bkk', 'car', '123', 'gee', '0955', 'bkk', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_notifications_users` (`user_id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_status_users` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `status`
--
ALTER TABLE `status`
  ADD CONSTRAINT `fk_status_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- Database: `app`
--
CREATE DATABASE IF NOT EXISTS `app` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `app`;

-- --------------------------------------------------------

--
-- Table structure for table `job_images`
--

CREATE TABLE `job_images` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `job_key` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `upload_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_images`
--

INSERT INTO `job_images` (`id`, `user_id`, `job_key`, `image_path`, `upload_time`) VALUES
(1, 8, 'KPQ-7930', 'uploads/33.jpg', '2024-09-25 09:35:12'),
(2, 8, 'CHU-2386', 'uploads/33.jpg', '2024-10-07 11:32:42'),
(3, 9, 'HRS-9314', 'uploads/33.jpg', '2024-10-07 22:07:05'),
(4, 10, 'IGX-4635', 'uploads/33.jpg', '2024-10-08 02:25:08');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `job_images`
--
ALTER TABLE `job_images`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `job_images`
--
ALTER TABLE `job_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- Database: `car_status`
--
CREATE DATABASE IF NOT EXISTS `car_status` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `car_status`;

-- --------------------------------------------------------

--
-- Table structure for table `check_status`
--

CREATE TABLE `check_status` (
  `user_id` int(11) NOT NULL,
  `status_1` int(11) NOT NULL,
  `status_2` int(11) NOT NULL,
  `status_3` int(11) NOT NULL,
  `status_4` int(11) NOT NULL,
  `status_5` int(11) NOT NULL,
  `status_6` int(11) NOT NULL,
  `status_7` int(11) NOT NULL,
  `status_8` int(11) NOT NULL,
  `status_9` int(11) NOT NULL,
  `status_10` int(11) NOT NULL,
  `status_11` int(11) NOT NULL,
  `status_12` int(11) NOT NULL,
  `status_13` int(11) NOT NULL,
  `status_14` varchar(255) NOT NULL,
  `status_15` int(11) NOT NULL,
  `status_16` int(11) NOT NULL,
  `all_status_check` int(11) NOT NULL,
  `check_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `check_status`
--

INSERT INTO `check_status` (`user_id`, `status_1`, `status_2`, `status_3`, `status_4`, `status_5`, `status_6`, `status_7`, `status_8`, `status_9`, `status_10`, `status_11`, `status_12`, `status_13`, `status_14`, `status_15`, `status_16`, `all_status_check`, `check_time`) VALUES
(2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '678', 1, 1, 1, '2024-09-22 14:16:29'),
(8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '555', 1, 1, 1, '2024-09-23 07:11:55'),
(8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '555', 1, 1, 1, '2024-09-24 08:06:44'),
(8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '123', 1, 1, 1, '2024-09-25 08:46:43'),
(8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '123', 1, 1, 1, '2024-10-07 11:28:26'),
(9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '88', 1, 1, 1, '2024-10-07 22:04:36'),
(10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, '100', 1, 1, 1, '2024-10-08 02:23:26');
--
-- Database: `news_db`
--
CREATE DATABASE IF NOT EXISTS `news_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `news_db`;

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` int(11) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `upload_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `file_name`, `file_path`, `upload_time`) VALUES
(1, 'images.jpg', 'uploads/images.jpg', '2024-09-14 20:40:31'),
(2, 'news2.png', 'uploads/news2.png', '2024-09-14 20:40:31'),
(3, 'news3.jpg', 'uploads/news3.jpg', '2024-09-14 20:40:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 14, 2020 at 08:10 AM
-- Server version: 5.7.14
-- PHP Version: 5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fastify`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AUTH` ()  BEGIN
select * from authentication;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_DELETE_TODO` (IN `jsonObject` JSON)  BEGIN
	DECLARE TODO_ID VARCHAR(45);
	DECLARE M_USER_ID VARCHAR(45);
    
	SET TODO_ID = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.id'));
	SET M_USER_ID = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.user_id'));
	
    DELETE FROM todo WHERE id = TODO_ID AND user_id = M_USER_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GET_SRPRODUCTS` ()  BEGIN

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_GET_TODO` (IN `jsonObject` JSON)  BEGIN
 DECLARE M_USER_ID VARCHAR(45);
 /*select JSON_EXTRACT(jsonObject,'$.user_id');*/
 SET M_USER_ID = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.user_id'));
     SELECT `todo`.`id`,
     		`todo`.`user_id`,
            `todo`.`title`,
            `todo`.`todo_image`,
            `todo`.`description`,
            `todo`.`created_at`
           
     FROM `todo`
     where `todo`.`user_id` = M_USER_ID;
/*select * from todo;*/
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_INSERT_TODO` (IN `jsonObject` JSON)  BEGIN
	DECLARE M_USER_ID VARCHAR(45);
	DECLARE TODO_TITLE VARCHAR(100);
	DECLARE TODO_DESCRIPTION VARCHAR(500);
	DECLARE TODO_CREATED_AT VARCHAR(45);
	DECLARE TODO_UPDATED_AT VARCHAR(45);

	SET M_USER_ID = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.user_id'));
	SET TODO_TITLE = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.title'));
	SET TODO_DESCRIPTION = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.description'));
	SET TODO_CREATED_AT = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.created_at'));
	SET TODO_UPDATED_AT = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.updated_at'));
    
    INSERT INTO todo (
		user_id,
        title,
        description,
        created_at,
        updated_at) values(
			M_USER_ID,
			TODO_TITLE,
			TODO_DESCRIPTION,
			TODO_CREATED_AT,
			TODO_UPDATED_AT);

     
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_SHOW_TODO` (IN `jsonObject` JSON)  BEGIN
 DECLARE TODO_ID VARCHAR(45);
 DECLARE M_USER_ID VARCHAR(45);
 SET TODO_ID = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.id'));
 SET M_USER_ID = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.user_id'));
     SELECT `todo`.`id`,
     		`todo`.`user_id`,
            `todo`.`title`,
            `todo`.`todo_image`,
            `todo`.`description`,
            `todo`.`created_at`
           
     FROM `todo`
     where `todo`.`user_id` = M_USER_ID AND `todo`.`id` = TODO_ID;
/*select * from todo;*/
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_TBL_M_USER_REGISTER` (IN `jsonObject` JSON)  BEGIN
	DECLARE M_USER_NAME VARCHAR(50);
	DECLARE M_USER_EMAIL VARCHAR(50);

	DECLARE M_USER_PASSWORD VARCHAR(45);

	DECLARE M_USER_TOKEN VARCHAR(100);
	DECLARE M_USER_AVATAR VARCHAR(300);


	/*select JSON_EXTRACT(jsonObject,'$.user_id');*/
 
 	SET M_USER_AVATAR = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.avatar'));

	SET M_USER_NAME = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.name'));
	SET M_USER_EMAIL = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.email'));
	SET M_USER_PASSWORD = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.password'));
	SET M_USER_TOKEN = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.token'));
    
 
	INSERT INTO `users`(
		name,
		email,
		password,
        avatar,
		remember_token,
		created_at,
		updated_at
    )
      values(
		M_USER_NAME,
		M_USER_EMAIL,
		M_USER_PASSWORD,
        M_USER_AVATAR,
		M_USER_TOKEN,
		now(),
		now()
      );
     /*SELECT `todo`.`user_id`,
            `todo`.`title`,
            `todo`.`todo_image`,
            `todo`.`description`,
            `todo`.`created_at`
           
     FROM `todo`
     where `todo`.`user_id` = M_USER_ID;*/
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `USP_UPDATE_TODO` (IN `jsonObject` JSON)  BEGIN
	DECLARE TODO_ID VARCHAR(45);
	DECLARE M_USER_ID VARCHAR(45);
	DECLARE TODO_TITLE VARCHAR(100);
	DECLARE TODO_DESCRIPTION VARCHAR(500);
	DECLARE TODO_CREATED_AT VARCHAR(45);
	DECLARE TODO_UPDATED_AT VARCHAR(45);
    
	SET TODO_ID = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.id'));
	SET M_USER_ID = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.user_id'));
	SET TODO_TITLE = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.title'));
	SET TODO_DESCRIPTION = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.description'));
	
	SET TODO_UPDATED_AT = JSON_UNQUOTE(JSON_EXTRACT(jsonObject,'$.updated_at'));
    
   
UPDATE todo set 
		title = TODO_TITLE,
        description = TODO_DESCRIPTION,
        updated_at = TODO_UPDATED_AT
            WHERE id = TODO_ID AND user_id = M_USER_ID;
     
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `authentication`
--

CREATE TABLE `authentication` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `secret_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `authentication`
--

INSERT INTO `authentication` (`id`, `user_id`, `secret_id`, `created_at`, `updated_at`, `expires_at`) VALUES
('1c3c248ee401decd0963d07e4061c87d29ccb5aab90656fb99', 1, 1, '2019-10-03 20:43:04', '2019-10-03 20:43:04', '2019-11-02 20:43:04'),
('2e31424e991418ae8b981656587de3d32fa409eab5118c85f7', 1, 1, '2019-11-29 19:17:09', '2019-11-29 19:17:09', '2019-12-29 19:17:09'),
('6ec009b8554bbd9cb84a9ecbbe17cbfc24019a743a0617cb3d', 1, 1, '2019-11-29 20:27:12', '2019-11-29 20:27:12', '2020-03-29 20:27:12'),
('7e46b348bad5a11b662db02956cc3a8cb536e95a46accc2df5', 1, 1, '2019-10-04 19:26:54', '2019-10-04 19:26:54', '2019-11-03 19:26:54'),
('97d6db02c35f7d36bdea2cb67cbb8733089044dcf0951f38da', 1, 1, '2019-11-29 19:06:31', '2019-11-29 19:06:31', '2019-12-29 19:06:31'),
('b6d37a6147c66b05d49caa3a4caef56fcb88a5fd700da2fc00', 1, 1, '2019-10-04 19:21:29', '2019-10-04 19:21:29', '2019-11-03 19:21:29'),
('c179219310c06c6360a4a9d699c1617173055e390f435ed258', 1, 1, '2019-10-03 19:05:27', '2019-10-03 19:05:27', '2020-02-02 19:05:27'),
('ea22cca8305ef37debbc7f45da5351ba46ae93ffa57168099e', 1, 1, '2019-10-04 19:21:02', '2019-10-04 19:21:02', '2020-02-03 19:21:02'),
('eff1756880de323f784c4a45dcfaf75d1a5f1a32102b6fa602', 63, 1, '2020-03-14 08:07:18', '2020-03-14 08:07:18', '2020-04-13 08:07:18');

-- --------------------------------------------------------

--
-- Table structure for table `secret`
--

CREATE TABLE `secret` (
  `id` int(10) UNSIGNED NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `secret`
--

INSERT INTO `secret` (`id`, `secret`, `description`, `permission`, `created_at`, `updated_at`) VALUES
(1, '7f46165474d11ee5836777d85df2cdab', 'Mobile', '{}', '2018-12-25 10:10:10', '2018-12-25 10:10:10'),
(2, '3d4fe7a00bc6fb52a91685d038733d6f', 'Web', '{}', '2018-12-25 10:10:10', '2018-12-25 10:10:10');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sr_products`
--

CREATE TABLE `tbl_sr_products` (
  `order_id` int(11) NOT NULL,
  `cuustomer_name` varchar(100) DEFAULT NULL,
  `Producr_name` varchar(100) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `received_amount` double DEFAULT NULL,
  `paid_amount` double DEFAULT NULL,
  `order_status` varchar(45) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_sr_products`
--

INSERT INTO `tbl_sr_products` (`order_id`, `cuustomer_name`, `Producr_name`, `address`, `received_amount`, `paid_amount`, `order_status`) VALUES
(1, 'Amidfsd', 'fsdfdsfs', 'fdsfdgfdgs', 1000.56, 50.5, 'new');

-- --------------------------------------------------------

--
-- Table structure for table `todo`
--

CREATE TABLE `todo` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `todo_image` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `todo`
--

INSERT INTO `todo` (`id`, `user_id`, `title`, `description`, `todo_image`, `created_at`, `updated_at`) VALUES
(18, 1, 'TODO_TEST', 'TODO_DES', NULL, '2019-11-29 19:09:06', NULL),
(19, 1, 'title todo', 'description todo', NULL, '2019-11-29 20:27:36', '2019-11-29 20:27:36'),
(22, 1, 'dsdsd', 'todo hhhhhhhhhhhhhhhhhhhhhhh', NULL, '2019-11-30 19:57:30', '2019-11-30 19:57:30'),
(23, 1, 'dsdsd', 'todo hhppph', NULL, '2019-11-30 19:58:35', '2019-11-30 19:58:35'),
(24, 1, 'dsd', 'ndfnf', NULL, '2019-12-03 18:47:38', '2019-12-03 18:47:38'),
(26, 1, 'TODO_TEST', 'TODO_DES', NULL, '2019-12-03 19:15:42', '2019-12-03 19:15:42'),
(27, 1, 'TODO', 'TODO_DES', NULL, '2019-12-07 17:32:03', '2019-12-07 17:32:03'),
(28, 1, 'TODO1', 'TODO_DES', NULL, '2019-12-08 16:27:02', '2019-12-08 16:27:02'),
(29, 1, 'TODO1', 'TODO_DES', NULL, '2019-12-08 16:28:58', '2019-12-08 16:28:58'),
(30, 1, 'TODO1', 'TODO_DES', NULL, '2019-12-08 16:29:12', '2019-12-08 16:29:12'),
(31, 1, 'TODO1', 'TODO_DES', NULL, '2019-12-08 16:42:41', '2019-12-08 16:42:41'),
(32, 1, 'TODO1', 'TODO_DES', NULL, '2019-12-25 17:01:14', '2019-12-25 17:01:14'),
(33, 1, 'TODO1', 'TODO_DES', NULL, '2019-12-25 17:01:14', '2019-12-25 17:01:14'),
(34, 1, 'TODO_TEST', 'TODO_DES', NULL, '2020-03-14 07:19:36', '2020-03-14 07:19:36'),
(35, 1, 'TODO_TEST', 'TODO_DES', NULL, '2020-03-14 07:19:36', '2020-03-14 07:19:36');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `avatar`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'amit', 'amit@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'ac0cfa88ad2bb9242f69a80e1270724662277082d9c533714b334df84094a526', '2019-10-03 18:18:29', '2019-10-03 18:18:29'),
(4, 'amit df', 'amitfd@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'da9481d4a41a29de9bb7e8b3074b284fe7d0571f1c2dcc6831ae4d575228e0c9', '2019-10-04 20:07:56', '2019-10-04 20:07:56'),
(6, 'amit aaa', 'amitaaadi@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '108d5142b23602a4207862ea02ad7e4bf03ea052052a4837c194b47f393aeead', '2019-10-06 11:48:48', '2019-10-06 11:48:48'),
(7, 'amitx', 'amitx@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '4dc42f6e069dca7049791002243e83cad5c4423d4b8c30148a7565c4850de3c4', '2019-12-25 15:32:12', '2019-12-25 15:32:12'),
(16, 'amitz', 'amitff@gmail.com', '123456', NULL, '212957807d7c1f044fe536707e9b49a0656019a47820977d9509ac534f92701f', NULL, NULL),
(18, 'amitxrtrtr', 'amitrr@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '1b5649f86cad10c050a503392f2468f6ba67cfd5f94f6d16249291253ab8689c', '2019-12-25 15:59:50', '2019-12-25 15:59:50'),
(24, 'amitx maurya', 'amitrMauryaa@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'bba81ec1be0fee595b4e688acd26255dd97854e5c59891c067b5b0cc8b08249f', '2019-12-25 16:07:17', '2019-12-25 16:07:17'),
(25, 'amitx maurya1', 'amitrMauryaa1@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '3ca11208211d25c36d832269b6b83c7c7c47e017e9a39593924126d2a69301bd', '2019-12-25 16:10:32', '2019-12-25 16:10:32'),
(27, 'amitx maurya2', 'amitrMauryaa2@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '03a5632d3eb20cf4d31deb1d9ec8cb46b2d7106c5e56269cfb98b0b19183156e', '2019-12-25 16:11:07', '2019-12-25 16:11:07'),
(28, 'amitx maurya3', 'amitrMauryaa4@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'd21ef6c5ad1a1c43c6dcbab19bf3f34782d77de165209def3ac2071d2cda5c8e', '2019-12-25 16:11:58', '2019-12-25 16:11:58'),
(29, 'amitx maurya5', 'amitrMauryaa5@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'da3847e578ac122fbadae58ddd932a4a9bec0264e123c04468a4698ad90969ae', '2019-12-25 16:12:26', '2019-12-25 16:12:26'),
(30, 'amitx maurya6', 'amitrMauryaa7@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'f76e89d75092968bfc4dd10ccc8be53cfbc07c2c3a18b32b4d91539ef662cef5', '2019-12-25 16:14:30', '2019-12-25 16:14:30'),
(31, 'amitx maurya8', 'amitrMauryaa8@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '02dc330a13144df945b7a643dccd71f23bec08327f7b7e6c89fdbe64c5aa8c09', '2019-12-25 16:15:15', '2019-12-25 16:15:15'),
(32, 'amitx', 'emailAmit@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '482fba014b13e1b5c9271960d04037cc8e397f2dcac2111db7a25650cdccf96b', '2019-12-25 17:51:59', '2019-12-25 17:51:59'),
(39, 'amitx1', 'emailAmit1@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, '7d06d958325eb4fff2095f8ae9550d70f508369e2c8f8b69dee094d99c388ae1', '2019-12-25 17:59:40', '2019-12-25 17:59:40'),
(42, 'amitx1', 'emailaa@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'f1923463a0be9ae38ea300b6e5285812004e585935ca1282c6574a6c0ff278ed', '2019-12-25 18:03:12', '2019-12-25 18:03:12'),
(47, 'amitx1', 'emailaasd3@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', NULL, 'd9a72273055d9788012fad260ade4393aeb04bb1dd0b9b39eeb9fc7cd9c050d6', '2019-12-25 18:11:20', '2019-12-25 18:11:20'),
(60, 'amitx9', 'emailaasd93@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'fastify_images\\995a983d7bb6a4456fc6_arduino-bluetooth_bb.png', '3f9da046fee69fa32e8890a3a30fc4297c462dcbb7e28c094ccd85f86b4d1c07', '2019-12-26 20:00:04', '2019-12-26 20:00:04'),
(63, 'amitx10', 'emailaasd10@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'fastify_images\\02cade7c066d953433e3_arduino-bluetooth_bb.png', '9d24d34efab98feea88a5a4e0cdec41602bfa5cd5ffb0794a518e4863234c16d', '2019-12-28 08:06:45', '2019-12-28 08:06:45'),
(65, 'amitz', 'amif@gmail.com', '123456', NULL, '212957807d7c1f044fe536707e9b49a0656019a47820977d9509ac534f92701f', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authentication`
--
ALTER TABLE `authentication`
  ADD UNIQUE KEY `authentication_id_unique` (`id`),
  ADD KEY `authentication_secret_id_foreign` (`secret_id`),
  ADD KEY `authentication_user_id_foreign` (`user_id`);

--
-- Indexes for table `secret`
--
ALTER TABLE `secret`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `secret_secret_unique` (`secret`);

--
-- Indexes for table `tbl_sr_products`
--
ALTER TABLE `tbl_sr_products`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `todo`
--
ALTER TABLE `todo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `todo_user_id_foreign` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `secret`
--
ALTER TABLE `secret`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_sr_products`
--
ALTER TABLE `tbl_sr_products`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `todo`
--
ALTER TABLE `todo`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `authentication`
--
ALTER TABLE `authentication`
  ADD CONSTRAINT `authentication_secret_id_foreign` FOREIGN KEY (`secret_id`) REFERENCES `secret` (`id`),
  ADD CONSTRAINT `authentication_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `todo`
--
ALTER TABLE `todo`
  ADD CONSTRAINT `todo_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

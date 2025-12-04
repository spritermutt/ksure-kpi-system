-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 08, 2025 at 02:00 PM
-- Server version: 5.7.24
-- PHP Version: 8.3.1
--
-- ✅ UPDATED: Fixed user_login_logs to support NULL user_id for failed login attempts
-- ✅ UPDATED: Added last_login column to users table for Login System (Sequence 3)
-- ✅ UPDATED: Modified audit_logs to support NULL user_id for failed login tracking

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `web_ksure`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL COMMENT 'NULL allowed for failed login attempts where user not found',
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_table` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `old_value` text COLLATE utf8mb4_unicode_ci COMMENT 'Can store IP address for rate limiting: ip:192.168.1.100',
  `new_value` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `department_id` int(11) NOT NULL,
  `department_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `file_download_logs`
--

CREATE TABLE `file_download_logs` (
  `download_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `response_id` int(11) NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `downloaded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `forms`
--

CREATE TABLE `forms` (
  `form_id` int(11) NOT NULL,
  `title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_assignments`
--

CREATE TABLE `form_assignments` (
  `assignment_id` int(11) NOT NULL,
  `form_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `assigned_by` int(11) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_attachments`
--

CREATE TABLE `form_attachments` (
  `attachment_id` int(11) NOT NULL,
  `response_id` int(11) NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` int(10) UNSIGNED NOT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uploaded_by` int(11) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_fields`
--

CREATE TABLE `form_fields` (
  `field_id` int(11) NOT NULL,
  `form_id` int(11) NOT NULL,
  `label` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `field_type` enum('text','textarea','email','number','date','datetime','select','checkbox','radio','file') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `options` json DEFAULT NULL,
  `placeholder` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_index` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_field_values`
--

CREATE TABLE `form_field_values` (
  `value_id` int(11) NOT NULL,
  `response_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_responses`
--

CREATE TABLE `form_responses` (
  `response_id` int(11) NOT NULL,
  `form_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `quarter_id` int(11) NOT NULL,
  `status` enum('draft','submitted','approved','rejected','resubmitted') COLLATE utf8mb4_unicode_ci DEFAULT 'draft',
  `supervisor_id` int(11) NOT NULL COMMENT 'All forms must be reviewed by supervisor',
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `review_comment` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_status_logs`
--

CREATE TABLE `form_status_logs` (
  `log_id` int(11) NOT NULL,
  `response_id` int(11) NOT NULL,
  `status` enum('draft','submitted','approved','rejected','resubmitted') COLLATE utf8mb4_unicode_ci NOT NULL,
  `changed_by` int(11) NOT NULL,
  `changed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `note` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_submission_logs`
--

CREATE TABLE `form_submission_logs` (
  `submission_log_id` int(11) NOT NULL,
  `response_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `form_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `status` enum('draft','submitted','approved','rejected','resubmitted') COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invites`
--

CREATE TABLE `invites` (
  `invite_id` int(11) NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('admin','supervisor','staff') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'staff',
  `department_id` int(11) NOT NULL COMMENT 'All invites must specify department',
  `invite_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `invited_by` int(11) NOT NULL,
  `status` enum('pending','accepted','expired','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `invited_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `accepted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('info','warning','success','error') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'info',
  `related_response_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `reset_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_by` int(11) DEFAULT NULL,
  `requested_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `used_at` datetime DEFAULT NULL,
  `status` enum('pending','used','expired') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quarters`
--

CREATE TABLE `quarters` (
  `quarter_id` int(11) NOT NULL,
  `year` smallint(6) NOT NULL,
  `quarter` enum('Q1','Q2','Q3','Q4') COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('Upcoming','Active','Closed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Upcoming'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','supervisor','staff') COLLATE utf8mb4_unicode_ci DEFAULT 'staff',
  `department_id` int(11) DEFAULT NULL COMMENT 'NULL allowed for Admin users',
  `invited_by` int(11) NOT NULL COMMENT 'Every user must have an inviter',
  `is_verified` tinyint(1) DEFAULT '0',
  `last_login` timestamp NULL DEFAULT NULL COMMENT 'Track last successful login time (Sequence 3)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_login_logs`
--

CREATE TABLE `user_login_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL COMMENT 'NULL allowed for failed login attempts where user not found',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `login_status` enum('success','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'success',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_audit_logs_user` (`user_id`),
  ADD KEY `idx_audit_logs_table` (`target_table`),
  ADD KEY `idx_audit_logs_table_id` (`target_table`,`target_id`),
  ADD KEY `idx_audit_logs_created` (`created_at`),
  ADD KEY `idx_audit_logs_action` (`action`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`department_id`);

--
-- Indexes for table `file_download_logs`
--
ALTER TABLE `file_download_logs`
  ADD PRIMARY KEY (`download_id`),
  ADD KEY `idx_download_logs_user` (`user_id`),
  ADD KEY `idx_download_logs_response` (`response_id`);

--
-- Indexes for table `forms`
--
ALTER TABLE `forms`
  ADD PRIMARY KEY (`form_id`),
  ADD KEY `idx_forms_created_by` (`created_by`);

--
-- Indexes for table `form_assignments`
--
ALTER TABLE `form_assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `assigned_by` (`assigned_by`),
  ADD KEY `idx_form_assignments_form` (`form_id`),
  ADD KEY `idx_form_assignments_dept` (`department_id`);

--
-- Indexes for table `form_attachments`
--
ALTER TABLE `form_attachments`
  ADD PRIMARY KEY (`attachment_id`),
  ADD KEY `idx_form_attachments_response` (`response_id`),
  ADD KEY `idx_form_attachments_uploaded_by` (`uploaded_by`);

--
-- Indexes for table `form_fields`
--
ALTER TABLE `form_fields`
  ADD PRIMARY KEY (`field_id`),
  ADD KEY `idx_form_fields_form_id` (`form_id`),
  ADD KEY `idx_form_fields_order` (`form_id`,`order_index`);

--
-- Indexes for table `form_field_values`
--
ALTER TABLE `form_field_values`
  ADD PRIMARY KEY (`value_id`),
  ADD KEY `idx_form_field_values_response` (`response_id`),
  ADD KEY `idx_form_field_values_field` (`field_id`);

--
-- Indexes for table `form_responses`
--
ALTER TABLE `form_responses`
  ADD PRIMARY KEY (`response_id`),
  ADD KEY `idx_form_responses_form` (`form_id`),
  ADD KEY `idx_form_responses_user` (`user_id`),
  ADD KEY `idx_form_responses_dept` (`department_id`),
  ADD KEY `idx_form_responses_quarter` (`quarter_id`),
  ADD KEY `idx_form_responses_status` (`status`),
  ADD KEY `idx_form_responses_supervisor` (`supervisor_id`);

--
-- Indexes for table `form_status_logs`
--
ALTER TABLE `form_status_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_status_logs_response` (`response_id`),
  ADD KEY `idx_status_logs_changed_by` (`changed_by`);

--
-- Indexes for table `form_submission_logs`
--
ALTER TABLE `form_submission_logs`
  ADD PRIMARY KEY (`submission_log_id`),
  ADD KEY `idx_submission_logs_response` (`response_id`),
  ADD KEY `idx_submission_logs_user` (`user_id`),
  ADD KEY `idx_submission_logs_form` (`form_id`),
  ADD KEY `idx_submission_logs_dept` (`department_id`);

--
-- Indexes for table `invites`
--
ALTER TABLE `invites`
  ADD PRIMARY KEY (`invite_id`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `invited_by` (`invited_by`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `idx_notifications_user` (`user_id`),
  ADD KEY `idx_notifications_user_read` (`user_id`,`is_read`),
  ADD KEY `idx_notifications_response` (`related_response_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `requested_by` (`requested_by`);

--
-- Indexes for table `quarters`
--
ALTER TABLE `quarters`
  ADD PRIMARY KEY (`quarter_id`),
  ADD UNIQUE KEY `year` (`year`,`quarter`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_department` (`department_id`),
  ADD KEY `idx_users_role` (`role`),
  ADD KEY `fk_users_invited_by` (`invited_by`),
  ADD KEY `idx_users_last_login` (`last_login`);

--
-- Indexes for table `user_login_logs`
--
ALTER TABLE `user_login_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_login_logs_user` (`user_id`),
  ADD KEY `idx_login_logs_status` (`login_status`),
  ADD KEY `idx_login_logs_created` (`created_at`),
  ADD KEY `idx_login_logs_ip_created` (`ip_address`, `created_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `file_download_logs`
--
ALTER TABLE `file_download_logs`
  MODIFY `download_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forms`
--
ALTER TABLE `forms`
  MODIFY `form_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_assignments`
--
ALTER TABLE `form_assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_attachments`
--
ALTER TABLE `form_attachments`
  MODIFY `attachment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_fields`
--
ALTER TABLE `form_fields`
  MODIFY `field_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_field_values`
--
ALTER TABLE `form_field_values`
  MODIFY `value_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_responses`
--
ALTER TABLE `form_responses`
  MODIFY `response_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_status_logs`
--
ALTER TABLE `form_status_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_submission_logs`
--
ALTER TABLE `form_submission_logs`
  MODIFY `submission_log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invites`
--
ALTER TABLE `invites`
  MODIFY `invite_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quarters`
--
ALTER TABLE `quarters`
  MODIFY `quarter_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_login_logs`
--
ALTER TABLE `user_login_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
-- ✅ NO FOREIGN KEY CONSTRAINT on user_id to allow NULL values
--

--
-- Constraints for table `file_download_logs`
--
ALTER TABLE `file_download_logs`
  ADD CONSTRAINT `file_download_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `file_download_logs_ibfk_2` FOREIGN KEY (`response_id`) REFERENCES `form_responses` (`response_id`) ON DELETE CASCADE;

--
-- Constraints for table `forms`
--
ALTER TABLE `forms`
  ADD CONSTRAINT `forms_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `form_assignments`
--
ALTER TABLE `form_assignments`
  ADD CONSTRAINT `form_assignments_ibfk_1` FOREIGN KEY (`form_id`) REFERENCES `forms` (`form_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_assignments_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_assignments_ibfk_3` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `form_attachments`
--
ALTER TABLE `form_attachments`
  ADD CONSTRAINT `form_attachments_ibfk_1` FOREIGN KEY (`response_id`) REFERENCES `form_responses` (`response_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_attachments_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `form_fields`
--
ALTER TABLE `form_fields`
  ADD CONSTRAINT `form_fields_ibfk_1` FOREIGN KEY (`form_id`) REFERENCES `forms` (`form_id`) ON DELETE CASCADE;

--
-- Constraints for table `form_field_values`
--
ALTER TABLE `form_field_values`
  ADD CONSTRAINT `form_field_values_ibfk_1` FOREIGN KEY (`response_id`) REFERENCES `form_responses` (`response_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_field_values_ibfk_2` FOREIGN KEY (`field_id`) REFERENCES `form_fields` (`field_id`) ON DELETE CASCADE;

--
-- Constraints for table `form_responses`
--
ALTER TABLE `form_responses`
  ADD CONSTRAINT `form_responses_ibfk_1` FOREIGN KEY (`form_id`) REFERENCES `forms` (`form_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_responses_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_responses_ibfk_3` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_responses_ibfk_4` FOREIGN KEY (`quarter_id`) REFERENCES `quarters` (`quarter_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_responses_ibfk_5` FOREIGN KEY (`supervisor_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `form_status_logs`
--
ALTER TABLE `form_status_logs`
  ADD CONSTRAINT `form_status_logs_ibfk_1` FOREIGN KEY (`response_id`) REFERENCES `form_responses` (`response_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_status_logs_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `form_submission_logs`
--
ALTER TABLE `form_submission_logs`
  ADD CONSTRAINT `form_submission_logs_ibfk_1` FOREIGN KEY (`response_id`) REFERENCES `form_responses` (`response_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_submission_logs_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_submission_logs_ibfk_3` FOREIGN KEY (`form_id`) REFERENCES `forms` (`form_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `form_submission_logs_ibfk_4` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE;

--
-- Constraints for table `invites`
--
ALTER TABLE `invites`
  ADD CONSTRAINT `invites_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invites_ibfk_2` FOREIGN KEY (`invited_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`related_response_id`) REFERENCES `form_responses` (`response_id`) ON DELETE SET NULL;

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `password_resets_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_invited_by` FOREIGN KEY (`invited_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE SET NULL;

--
-- Constraints for table `user_login_logs`
-- ✅ NO FOREIGN KEY CONSTRAINT on user_id to allow NULL values
--
-- เพิ่ม User Admin เริ่มต้น (ปิดเช็ค Foreign Key ชั่วคราวเพื่อให้สร้างคนแรกได้)
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO `users` (`user_id`, `full_name`, `email`, `password_hash`, `role`, `department_id`, `invited_by`, `is_verified`, `created_at`) 
VALUES (1, 'System Admin', 'admin@example.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 'admin', NULL, 1, 1, NOW());
UPDATE `users` SET `invited_by` = 1 WHERE `user_id` = 1;
SET FOREIGN_KEY_CHECKS=1;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

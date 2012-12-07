-- phpMyAdmin SQL Dump
-- version 3.3.9.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 07, 2012 at 04:20 AM
-- Server version: 5.5.9
-- PHP Version: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `laohrp`
--

-- --------------------------------------------------------

--
-- Table structure for table `section_settings`
--

CREATE TABLE `section_settings` (
  `section_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `section_settings_pkey` (`section_id`,`locale`,`setting_name`),
  KEY `section_settings_section_id` (`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `section_settings`
--

INSERT INTO `section_settings` (`section_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(1, 'en_US', 'title', 'National Ethical Committee for Health Research', 'string'),
(1, 'en_US', 'abbrev', 'NECHR', 'string'),
(1, 'en_US', 'policy', '', 'string'),
(2, 'en_US', 'title', 'Ethical Committee of the University of Health Sciences', 'string'),
(2, 'en_US', 'abbrev', 'ECUHS', 'string'),
(2, 'en_US', 'policy', '', 'string'),
(1, 'en_US', 'address', 'Secretary\r\nNational Ethics Committee for Health Research\r\nRoom #221\r\nNational Institute of Public Health\r\nSamsenthai Road, Ban Kao Nhot, Sisattanak District, \r\nVientiane, Lao PDR\r\nTel: (856-21) 250670-205', 'string'),
(1, 'en_US', 'bankAccount', 'National Institute of Public Health', 'string'),
(2, 'en_US', 'address', 'Secretary\r\nEthical Committee of the University of Health Sciences\r\nUniversity of Health Sciences\r\nSamsenthai Road, Sisattanak District,\r\nVientiane, Lao PDR', 'string'),
(2, 'en_US', 'bankAccount', 'Available soon...', 'string');

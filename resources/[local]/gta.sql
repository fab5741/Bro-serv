-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mar. 16 fév. 2021 à 15:58
-- Version du serveur :  5.7.31
-- Version de PHP : 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gta`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `ADD_COLUMN_IF_NOT_EXISTS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_COLUMN_IF_NOT_EXISTS` (IN `dbName` TINYTEXT, IN `tableName` TINYTEXT, IN `fieldName` TINYTEXT, IN `fieldDef` TEXT)  BEGIN
  IF NOT EXISTS (
    SELECT * FROM information_schema.COLUMNS
    WHERE `column_name`  = fieldName
    AND   `table_name`   = tableName
    AND   `table_schema` = dbName
  )
  THEN
    SET @ddl=CONCAT('ALTER TABLE ', dbName, '.', tableName, ' ADD COLUMN ', fieldName, ' ', fieldDef);
    PREPARE stmt from @ddl;
    EXECUTE stmt;
  END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `amount` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `accounts`
--

INSERT INTO `accounts` (`id`, `amount`) VALUES
(1, 3123268),
(2, 19440),
(3, 1197480),
(4, 233719),
(5, 240000),
(6, 597090),
(7, 555860),
(8, 48610),
(9, 1000),
(10, 1000),
(11, 477187577),
(12, 1800);

-- --------------------------------------------------------

--
-- Structure de la table `dpkeybinds`
--

DROP TABLE IF EXISTS `dpkeybinds`;
CREATE TABLE IF NOT EXISTS `dpkeybinds` (
  `id` varchar(50) DEFAULT NULL,
  `keybind1` varchar(50) DEFAULT 'num4',
  `emote1` varchar(255) DEFAULT '',
  `keybind2` varchar(50) DEFAULT 'num5',
  `emote2` varchar(255) DEFAULT '',
  `keybind3` varchar(50) DEFAULT 'num6',
  `emote3` varchar(255) DEFAULT '',
  `keybind4` varchar(50) DEFAULT 'num7',
  `emote4` varchar(255) DEFAULT '',
  `keybind5` varchar(50) DEFAULT 'num8',
  `emote5` varchar(255) DEFAULT '',
  `keybind6` varchar(50) DEFAULT 'num9',
  `emote6` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `dpkeybinds`
--

INSERT INTO `dpkeybinds` (`id`, `keybind1`, `emote1`, `keybind2`, `emote2`, `keybind3`, `emote3`, `keybind4`, `emote4`, `keybind5`, `emote5`, `keybind6`, `emote6`) VALUES
('license:3ffad8d438c26c883e6c18b33cc69c3bb6dc4fac', 'num4', 'dance', 'num5', 'sit', 'num6', '', 'num7', '', 'num8', '', 'num9', '');

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

DROP TABLE IF EXISTS `items`;
CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `label` varchar(64) NOT NULL,
  `weight` int(11) NOT NULL,
  `usable` int(11) NOT NULL,
  `rare` int(11) NOT NULL,
  `can_remove` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `items`
--

INSERT INTO `items` (`id`, `label`, `weight`, `usable`, `rare`, `can_remove`) VALUES
(1, 'Blé', 1, 0, 0, 1),
(2, 'Farine', 1, 0, 0, 1),
(3, 'Bro\'Bab', 1, 1, 0, 1),
(4, 'Raisin', 1, 1, 0, 1),
(5, 'Le jus des bros', 1, 1, 0, 0),
(6, 'Weed (non traité)', 1, 0, 0, 0),
(7, 'Weed', 1, 0, 0, 0),
(8, 'Valise d\'argent', 1, 0, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(15) NOT NULL,
  `label` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `jobs`
--

INSERT INTO `jobs` (`id`, `name`, `label`) VALUES
(1, 'gouv', 'Gouvernement'),
(2, 'lspd', 'LSPD'),
(3, 'lsms', 'LSMS'),
(4, 'farm', 'Fermiers'),
(5, 'wine', 'Vignerons'),
(6, 'taxi', 'Taxi'),
(7, 'bennys', 'Benny\'s'),
(8, 'newspapers', 'Livreurs de journaux');

-- --------------------------------------------------------

--
-- Structure de la table `job_account`
--

DROP TABLE IF EXISTS `job_account`;
CREATE TABLE IF NOT EXISTS `job_account` (
  `job` int(10) UNSIGNED NOT NULL,
  `account` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`job`,`account`),
  KEY `account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `job_account`
--

INSERT INTO `job_account` (`job`, `account`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);

-- --------------------------------------------------------

--
-- Structure de la table `job_armory`
--

DROP TABLE IF EXISTS `job_armory`;
CREATE TABLE IF NOT EXISTS `job_armory` (
  `job` int(11) UNSIGNED NOT NULL,
  `weapon` varchar(25) NOT NULL,
  `amount` int(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`job`,`weapon`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `job_armory`
--

INSERT INTO `job_armory` (`job`, `weapon`, `amount`) VALUES
(2, 'WEAPON_FLASHLIGHT', 9),
(2, 'WEAPON_NIGHTSTICK', 10),
(2, 'WEAPON_PISTOL', 7),
(2, 'WEAPON_SMG', 7),
(2, 'WEAPON_STUNGUN', 10);

-- --------------------------------------------------------

--
-- Structure de la table `job_grades`
--

DROP TABLE IF EXISTS `job_grades`;
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `job` int(11) UNSIGNED NOT NULL,
  `grade` tinyint(3) UNSIGNED NOT NULL,
  `label` varchar(30) NOT NULL,
  `salary` double UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `job` (`job`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `job_grades`
--

INSERT INTO `job_grades` (`id`, `job`, `grade`, `label`, `salary`) VALUES
(1, 1, 5, 'Gouverneur', 3600),
(2, 1, 4, 'Vice-Gouverneur', 1680),
(3, 1, 3, 'Conseiller', 1200),
(4, 2, 5, 'Capitaine', 1680),
(5, 2, 4, 'Lieutenant', 1380),
(6, 2, 3, 'Sergeant', 1200),
(7, 2, 2, 'Officier', 600),
(8, 2, 1, 'Recrue', 480),
(9, 3, 5, 'Directeur', 1680),
(10, 3, 4, 'Chirurgien-Chef', 1380),
(11, 3, 3, 'Chirurgien', 1200),
(12, 3, 2, 'Interne', 600),
(13, 3, 1, 'Ambulancier', 480),
(14, 4, 5, 'Gérant', 1680),
(15, 4, 4, 'DRH', 1200),
(16, 4, 3, 'Manager', 960),
(17, 4, 2, 'Fermier', 600),
(18, 4, 1, 'Recrue', 480),
(19, 5, 5, 'Gérant', 1680),
(20, 5, 4, 'DRH', 1200),
(21, 5, 3, 'Manager', 960),
(22, 5, 2, 'Vigneron', 600),
(23, 5, 1, 'Recrue', 480),
(24, 6, 5, 'Gérant', 1680),
(25, 6, 4, 'DRH', 1200),
(26, 6, 3, 'Manager', 960),
(27, 6, 2, 'Taxi', 600),
(28, 6, 1, 'Recrue', 480),
(29, 7, 5, 'Gérant', 1680),
(30, 7, 4, 'DRH', 1200),
(31, 7, 3, 'Manager', 960),
(32, 7, 2, 'Mécanicien', 600),
(33, 7, 1, 'Recrue', 480),
(34, 8, 0, 'Livreur de journaux', 0);

-- --------------------------------------------------------

--
-- Structure de la table `job_item`
--

DROP TABLE IF EXISTS `job_item`;
CREATE TABLE IF NOT EXISTS `job_item` (
  `job` int(11) UNSIGNED NOT NULL,
  `item` int(11) UNSIGNED NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL DEFAULT '1',
  UNIQUE KEY `job_2` (`job`,`item`),
  KEY `job` (`job`),
  KEY `item` (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `job_item`
--

INSERT INTO `job_item` (`job`, `item`, `amount`) VALUES
(2, 2, 0),
(2, 3, 0),
(2, 6, 0),
(2, 7, 46);

-- --------------------------------------------------------

--
-- Structure de la table `job_vehicle`
--

DROP TABLE IF EXISTS `job_vehicle`;
CREATE TABLE IF NOT EXISTS `job_vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` int(11) UNSIGNED NOT NULL,
  `vehicle_mod` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `job` (`job`),
  KEY `vehicle_mod` (`vehicle_mod`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `job_vehicle`
--

INSERT INTO `job_vehicle` (`id`, `job`, `vehicle_mod`) VALUES
(2, 2, 46),
(3, 7, 56);

-- --------------------------------------------------------

--
-- Structure de la table `owned_properties`
--

DROP TABLE IF EXISTS `owned_properties`;
CREATE TABLE IF NOT EXISTS `owned_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rented` int(11) NOT NULL,
  `owner` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `phone_app_chat`
--

DROP TABLE IF EXISTS `phone_app_chat`;
CREATE TABLE IF NOT EXISTS `phone_app_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `phone_calls`
--

DROP TABLE IF EXISTS `phone_calls`;
CREATE TABLE IF NOT EXISTS `phone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(10) NOT NULL COMMENT 'Num tel proprio',
  `num` varchar(10) NOT NULL COMMENT 'Num reférence du contact',
  `incoming` int(11) NOT NULL COMMENT 'Défini si on est à l''origine de l''appels',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `accepts` int(11) NOT NULL COMMENT 'Appels accepter ou pas',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `phone_calls`
--

INSERT INTO `phone_calls` (`id`, `owner`, `num`, `incoming`, `time`, `accepts`) VALUES
(15, 'nil', 'lspd', 1, '2021-01-09 21:40:40', 0),
(16, 'lspd', '###-####', 0, '2021-01-09 21:40:40', 0);

-- --------------------------------------------------------

--
-- Structure de la table `phone_messages`
--

DROP TABLE IF EXISTS `phone_messages`;
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transmitter` varchar(10) NOT NULL,
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `isRead` int(11) NOT NULL DEFAULT '0',
  `owner` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `phone_messages`
--

INSERT INTO `phone_messages` (`id`, `transmitter`, `receiver`, `message`, `time`, `isRead`, `owner`) VALUES
(44, '883-0534', '555-3565', 'test', '2021-01-09 21:15:43', 0, 0),
(56, 'lspd', '883-0534', 'test', '2021-01-09 21:29:06', 1, 0),
(42, '883-0534', '555-3565', 'gag', '2021-01-09 21:15:40', 0, 0),
(54, 'lspd', '883-0534', 'test', '2021-01-09 21:28:27', 1, 0),
(55, '883-0534', 'lspd', 'test', '2021-01-09 21:28:27', 0, 1),
(27, '883-0534', '555-3565', 'test', '2021-01-09 20:58:47', 0, 0),
(26, '883-0534', '555-3565', 'GPS: -1512.3311767578, -288.02359008789', '2021-01-09 20:57:41', 0, 0),
(33, '883-0534', '555-3565', 'gaga', '2021-01-09 21:06:45', 0, 0),
(34, '883-0534', '555-3565', 'agag', '2021-01-09 21:08:03', 0, 0),
(28, '883-0534', '555-3565', 'tet', '2021-01-09 21:00:26', 0, 0),
(29, '883-0534', '555-3565', 'test', '2021-01-09 21:02:15', 0, 0),
(30, '883-0534', '555-3565', 'geg', '2021-01-09 21:02:24', 0, 0),
(31, '883-0534', '555-3565', 'gag', '2021-01-09 21:05:31', 0, 0),
(32, '555-3565', '0', 'gaga', '2021-01-09 21:06:45', 1, 1),
(50, '883-0534', '555-3565', 'test', '2021-01-09 21:18:06', 0, 0),
(35, '883-0534', '555-3565', 'gaga', '2021-01-09 21:09:12', 0, 0),
(40, '883-0534', '555-3565', 'aga', '2021-01-09 21:14:10', 0, 0),
(39, '883-0534', '555-3565', 'gaga', '2021-01-09 21:10:56', 0, 0),
(38, '883-0534', '555-3565', 'gagag', '2021-01-09 21:10:25', 0, 0),
(51, '555-3565', '883-0534', 'test', '2021-01-09 21:18:06', 1, 1),
(46, '883-0534', '555-3565', 'ag', '2021-01-09 21:16:19', 0, 0),
(53, 'lspd', '883-0534', 'test', '2021-01-09 21:25:21', 1, 0),
(48, '883-0534', '555-3565', 'gag', '2021-01-09 21:17:38', 0, 0),
(52, 'lspd', '883-0534', 'test', '2021-01-09 21:20:34', 1, 0),
(57, '883-0534', 'lspd', 'test', '2021-01-09 21:29:06', 0, 1),
(58, '883-0534', 'lspd', 'tetet', '2021-01-09 21:30:28', 0, 1),
(59, '883-0534', 'lspd', 'salyuta', '2021-01-09 21:30:36', 0, 1),
(60, 'lspd', '883-0534', 'gaga', '2021-01-09 21:31:59', 1, 1),
(61, '883-0534', 'lspd', 'terst', '2021-01-09 21:36:53', 0, 0),
(62, 'lspd', '883-0534', 'terst', '2021-01-09 21:36:53', 1, 1),
(63, '883-0534', '883-0534', 'Bonjour ,monsieur, j\'arrive de suite,', '2021-01-09 21:37:17', 1, 0),
(64, '883-0534', '883-0534', 'Bonjour ,monsieur, j\'arrive de suite,', '2021-01-09 21:37:17', 1, 1),
(65, '883-0534', '883-0534', 'test', '2021-01-09 21:37:46', 1, 0),
(66, '883-0534', '555-3565', 'test', '2021-01-09 21:37:46', 1, 1),
(67, '883-0534', '555-3565', 'J\'arrive de suite', '2021-01-09 21:39:01', 1, 0),
(68, '555-3565', '883-0534', 'J\'arrive de suite', '2021-01-09 21:39:01', 1, 1),
(69, '883-0534', '555-3565', 'ok', '2021-01-09 21:39:41', 0, 0),
(70, '555-3565', '883-0534', 'ok', '2021-01-09 21:39:41', 1, 1),
(71, 'lsms', '883-0534', 'test', '2021-01-09 21:40:07', 1, 1),
(72, 'bennys', '883-0534', 'test', '2021-01-09 21:43:25', 1, 1),
(73, '883-0534', 'lspd', 'test', '2021-01-09 21:43:34', 0, 0),
(74, 'lspd', '883-0534', 'test', '2021-01-09 21:43:34', 1, 1),
(75, '883-0534', 'lspd', 'tat', '2021-01-09 21:44:11', 0, 0),
(76, 'lspd', '883-0534', 'tat', '2021-01-09 21:44:11', 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `phone_players_contacts`
--

DROP TABLE IF EXISTS `phone_players_contacts`;
CREATE TABLE IF NOT EXISTS `phone_players_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discord` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `display` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `phone_players_contacts`
--

INSERT INTO `phone_players_contacts` (`id`, `discord`, `number`, `display`) VALUES
(3, 'discord:150331120255238144', '555-3565', 'deux');

-- --------------------------------------------------------

--
-- Structure de la table `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `discord` varchar(30) NOT NULL,
  `x` double NOT NULL DEFAULT '0',
  `y` double NOT NULL DEFAULT '0',
  `z` double NOT NULL DEFAULT '0',
  `job_grade` tinyint(10) UNSIGNED DEFAULT NULL,
  `onDuty` tinyint(1) NOT NULL DEFAULT '0',
  `skin` text,
  `clothes` text,
  `liquid` double UNSIGNED NOT NULL DEFAULT '100',
  `dirty` double UNSIGNED NOT NULL DEFAULT '0',
  `firstname` varchar(16) NOT NULL DEFAULT 'John',
  `lastname` varchar(16) NOT NULL DEFAULT 'Smith',
  `birth` varchar(10) NOT NULL DEFAULT '00/01/1901',
  `permis` smallint(6) NOT NULL DEFAULT '0',
  `gun_permis` tinyint(1) NOT NULL DEFAULT '0',
  `gameId` int(11) NOT NULL DEFAULT '-1',
  `phone_number` varchar(10) NOT NULL,
  `weapons` text,
  `last_property` varchar(255) DEFAULT NULL,
  `hunger` smallint(6) NOT NULL DEFAULT '100',
  `thirst` smallint(6) NOT NULL DEFAULT '100',
  `health` tinyint(3) UNSIGNED NOT NULL DEFAULT '200',
  PRIMARY KEY (`id`),
  KEY `job_grade` (`job_grade`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `players`
--

INSERT INTO `players` (`id`, `discord`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `clothes`, `liquid`, `dirty`, `firstname`, `lastname`, `birth`, `permis`, `gun_permis`, `gameId`, `phone_number`, `weapons`, `last_property`, `hunger`, `thirst`, `health`) VALUES
(6, 'discord:150331120255238144', 238.70506286621094, -2019.324462890625, 18.31009292602539, 4, 0, '{\"tshirt_1\":2,\"pants_2\":4,\"chain_2\":0,\"decals_1\":0,\"decals_2\":0,\"torso_2\":0,\"arms_2\":0,\"torso_1\":3,\"arms\":4,\"chain_1\":0,\"shoes_2\":0,\"shoes_1\":3,\"tshirt_2\":0,\"pants_1\":5,\"sex\":0,\"glasses_1\":0}', NULL, 0, 250, 'John', 'Smith', '00/01/1901', 0, 1, 1, '153-8068', '[\"WEAPON_PUMPSHOTGUN\"]', NULL, 77, 77, 200);

-- --------------------------------------------------------

--
-- Structure de la table `player_account`
--

DROP TABLE IF EXISTS `player_account`;
CREATE TABLE IF NOT EXISTS `player_account` (
  `player` int(10) UNSIGNED NOT NULL,
  `account` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`player`,`account`),
  UNIQUE KEY `player_3` (`player`,`account`),
  KEY `player` (`player`,`account`),
  KEY `player_2` (`player`,`account`),
  KEY `account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `player_account`
--

INSERT INTO `player_account` (`player`, `account`) VALUES
(6, 12);

-- --------------------------------------------------------

--
-- Structure de la table `player_item`
--

DROP TABLE IF EXISTS `player_item`;
CREATE TABLE IF NOT EXISTS `player_item` (
  `player` int(11) UNSIGNED NOT NULL,
  `item` int(11) UNSIGNED NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL DEFAULT '1',
  UNIQUE KEY `player_2` (`player`,`item`),
  KEY `player` (`player`),
  KEY `item` (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `player_item`
--

INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES
(6, 3, 1),
(6, 5, 1),
(6, 8, 45);

-- --------------------------------------------------------

--
-- Structure de la table `player_vehicle`
--

DROP TABLE IF EXISTS `player_vehicle`;
CREATE TABLE IF NOT EXISTS `player_vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) UNSIGNED NOT NULL,
  `vehicle_mod` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player` (`player`),
  KEY `vehicle_mod` (`vehicle_mod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `properties`
--

DROP TABLE IF EXISTS `properties`;
CREATE TABLE IF NOT EXISTS `properties` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `address` varchar(255) NOT NULL,
  `pos` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `enter` varchar(255) NOT NULL,
  `exit` varchar(255) NOT NULL,
  `clothes` varchar(255) NOT NULL,
  `safe` varchar(255) NOT NULL,
  `frigo` varchar(255) NOT NULL,
  `storage` varchar(255) NOT NULL,
  `garage` varchar(255) NOT NULL,
  `liquid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `properties`
--

INSERT INTO `properties` (`id`, `address`, `pos`, `price`, `owner`, `enter`, `exit`, `clothes`, `safe`, `frigo`, `storage`, `garage`, `liquid`) VALUES
(1, '3090 Whispymound Drive', '{\"x\":119.15917205811,\"y\":565.16540527344,\"z\":183.95933532715}', 800000, 'discord:150331120255238144', '{\"y\":557.032,\"z\":183.301,\"x\":118.037}', '{\"x\":117.27471923828,\"y\":559.55059814453,\"z\":184.30490112305}', '{\"x\":117.92822265625,\"y\":549.15533447266,\"z\":184.09689331055}', '{\"x\":125.65377807617, \"y\":552.9443359375,\"z\":184.09689331055}', '{\"x\":120.23885345459,\"y\":557.30133056641,\"z\":184.29721069336}', '{\"x\":124.47821807861,\"y\":547.56109619141,\"z\":184.09701538086}', '{\"x\":131.59066772461,\"y\":567.84387207031,\"z\":183.46154785156}', 0),
(2, '3671 Whispymound Drive', '{\r\n\"x\":8.8123035430908,\"y\":541.03002929688,\"z\":176.02809143066\r\n}', 950000, 'discord:150331120255238144', '{\"x\":6.7524085044861,\"y\":536.21832275391,\"z\":176.02803039551}', '{\"x\":7.9650750160217,\"y\":538.41711425781,\"z\":176.02803039551}', '{\"x\":0.56223160028458,\"y\":526.48870849609,\"z\":170.61721801758}', '{\"x\":4.5538091659546,\"y\":531.14404296875,\"z\":175.34321594238}', '{\"x\":-11.678949356079,\"y\":516.69543457031,\"z\":174.6282043457}', '{\"x\":-6.9495420455933,\"y\":530.54919433594,\"z\":174.99975585938}', '{\"x\":21.822206497192,\"y\":544.76037597656,\"z\":176.02758789062}', 0),
(3, 'La Fuente Blanca', '{\"x\":1394.2781982422,\"y\":1141.8348388672,\"z\":114.60352325439}', 300000, 'discord:150331120255238144', '{\"x\":1399.1557617188,\"y\":1143.873046875,\"z\":114.6118927002}', '{\"x\":1396.8510742188,\"y\":1141.822265625,\"z\":114.33364868164}', '{\"x\":1399.9819335938,\"y\":1139.794921875,\"z\":114.33358764648}', '{\"x\":1402.2209472656,\"y\":1132.1999511719,\"z\":114.33364868164}', '{\"x\":1395.1733398438,\"y\":1149.6873779297,\"z\":114.33364868164}', '{\"x\":1403.7276611328,\"y\":1144.6275634766,\"z\":114.33364868164}', '{\"x\":1402.6475830078,\"y\":1118.4504394531,\"z\":114.83769226074}', 518),
(4, '3 Alta Street A', '{\"x\":-266.42681884766,\"y\":-955.36315917969,\"z\":31.224014282227}', 250000, 'discord:150331120255238144', '{\"x\":-272.76809692383,\"y\":-939.95989990234,\"z\":92.510940551758}', '{\"x\":-269.83993530273,\"y\":-941.14007568359,\"z\":92.510940551758}', '{\"x\":-277.6813659668,\"y\":-960.44439697266,\"z\":86.314407348633}', '{\"x\":-279.9997253418,\"y\":-968.51318359375,\"z\":91.108322143555}', '{\"x\":-270.28707885742,\"y\":-954.49951171875,\"z\":91.108322143555}', '{\"x\":-274.61563110352,\"y\":-968.46563720703,\"z\":91.108322143555}', '{\"x\":-291.92483520508,\"y\":-988.77722167969,\"z\":24.137041091919}', 0),
(5, '4 Integrity Way A', '{\"x\":-44.923316955566,\"y\":-587.33673095703,\"z\":38.161235809326}', 3000000, 'discord:150331120255238144', '{\"x\":-27.37176322937,\"y\":-596.59741210938,\"z\":80.030868530273}', '{\"x\":-31.379657745361,\"y\":-595.26159667969,\"z\":80.030891418457}', '{\"x\":-38.205348968506,\"y\":-589.46466064453,\"z\":78.830299377441}', '{\"x\":-20.887836456299,\"y\":-594.11315917969,\"z\":79.630676269531}', '{\"x\":-11.124963760376,\"y\":-584.71087646484,\"z\":79.430717468262}', '{\"x\":-27.596370697021,\"y\":-581.18988037109,\"z\":79.230682373047}', '{\"x\":-38.392509460449,\"y\":-620.30364990234,\"z\":35.082023620605}', 0),
(6, '4 Integrity Way B', '{\"x\":-43.945999145508,\"y\":-584.48254394531,\"z\":38.161571502686}', 2600000, 'discord:150331120255238144', '{\"x\":-20.514738082886,\"y\":-609.30194091797,\"z\":100.23284912109}', '{\"x\":-25.355182647705,\"y\":-607.41430664062,\"z\":100.23284912109}', '{\"x\":-17.65518951416,\"y\":-587.93438720703,\"z\":94.036361694336}', '{\"x\":-19.660057067871,\"y\":-605.38116455078,\"z\":100.2328414917}', '{\"x\":-25.315414428711,\"y\":-593.81915283203,\"z\":98.830276489258}', '{\"x\":-20.729257583618,\"y\":-579.80236816406,\"z\":98.830276489258}', '{\"x\":-38.392509460449,\"y\":-620.30364990234,\"z\":35.082023620605}', 0),
(7, '2045 North Conker Avenue', '{\"x\":373.02493286133,\"y\":428.12606811523,\"z\":145.68466186523}', 350000, 'discord:150331120255238144', '{\"x\":373.17129516602,\"y\":421.89303588867,\"z\":145.90789794922}', '{\"x\":373.72482299805,\"y\":423.84320068359,\"z\":145.90789794922}', '{\"x\":374.27279663086,\"y\":411.71487426758,\"z\":142.10025024414}', '{\"x\":379.4895324707,\"y\":414.31631469727,\"z\":145.70001220703}', '{\"x\":375.51885986328,\"y\":420.19253540039,\"z\":145.90020751953}', '{\"x\":370.4619140625,\"y\":412.72561645508,\"z\":145.70001220703}', '{\"x\":391.14050292969,\"y\":430.46325683594,\"z\":143.6135559082}', 0),
(8, '3655 Whispymound Drive', '{\"x\":-175.58526611328,\"y\":502.17129516602,\"z\":137.42022705078}', 35000000, NULL, '{\"x\":-172.41702270508,\"y\":494.27993774414,\"z\":137.65370178223}', '{\"x\":-174.17613220215,\"z\":497.47589111328,\"y\":137.66700744629}', '{\"x\":-167.35444641113,\"y\":487.40222167969,\"z\":133.84378051758}', '{\"x\":-163.98709106445,\"y\":492.14181518555,\"z\":137.44361877441}', '{\"x\":-170.23219299316,\"y\":496.15194702148,\"z\":137.65357971191}', '{\"x\":-171.41883850098,\"y\":486.8154296875,\"z\":137.44361877441}', '{\"x\":-189.11856079102,\"y\":501.78726196289,\"z\":134.47961425781}', 0),
(9, '2044 Whispymound Drive', '{\"x\":346.83700561523,\"y\":440.8410949707,\"z\":147.70219421387}', 32000000, NULL, '{\"x\":340.11547851562,\"y\":436.27340698242,\"z\":149.39408874512}', '{\"x\":342.09588623047,\"y\":437.96447753906,\"z\":149.38076782227}', '{\"x\":334.27816772461,\"y\":428.58682250977,\"z\":145.57086181641}', '{\"x\":339.48104858398,\"y\":426.61611938477,\"z\":149.17060852051}', '{\"x\":341.52178955078,\"y\":433.58682250977,\"z\":149.38063049316}', '{\"x\":332.41958618164,\"y\":432.0556640625,\"z\":149.17054748535}', '{\"x\":353.84085083008,\"y\":437.34362792969,\"z\":146.67053222656}', 0);

-- --------------------------------------------------------

--
-- Structure de la table `properties2`
--

DROP TABLE IF EXISTS `properties2`;
CREATE TABLE IF NOT EXISTS `properties2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `entering` varchar(255) DEFAULT NULL,
  `exit` varchar(255) DEFAULT NULL,
  `inside` varchar(255) DEFAULT NULL,
  `outside` varchar(255) DEFAULT NULL,
  `ipls` varchar(255) DEFAULT '[]',
  `gateway` varchar(255) DEFAULT NULL,
  `is_single` int(11) DEFAULT NULL,
  `is_room` int(11) DEFAULT NULL,
  `is_gateway` int(11) DEFAULT NULL,
  `room_menu` varchar(255) DEFAULT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `properties2`
--

INSERT INTO `properties2` (`id`, `name`, `label`, `entering`, `exit`, `inside`, `outside`, `ipls`, `gateway`, `is_single`, `is_room`, `is_gateway`, `room_menu`, `price`) VALUES
(1, 'WhispymoundDrive', '2677 Whispymound Drive', '{\"y\":564.89,\"z\":182.959,\"x\":119.384}', '{\"x\":117.347,\"y\":559.506,\"z\":183.304}', '{\"y\":557.032,\"z\":183.301,\"x\":118.037}', '{\"y\":567.798,\"z\":182.131,\"x\":119.249}', '[]', NULL, 1, 1, 0, '{\"x\":118.748,\"y\":566.573,\"z\":175.697}', 1500000),
(2, 'NorthConkerAvenue2045', '2045 North Conker Avenue', '{\"x\":372.796,\"y\":428.327,\"z\":144.685}', '{\"x\":373.548,\"y\":422.982,\"z\":144.907},', '{\"y\":420.075,\"z\":145.904,\"x\":372.161}', '{\"x\":372.454,\"y\":432.886,\"z\":143.443}', '[]', NULL, 1, 1, 0, '{\"x\":377.349,\"y\":429.422,\"z\":137.3}', 1500000),
(3, 'RichardMajesticApt2', 'Richard Majestic, Apt 2', '{\"y\":-379.165,\"z\":37.961,\"x\":-936.363}', '{\"y\":-365.476,\"z\":113.274,\"x\":-913.097}', '{\"y\":-367.637,\"z\":113.274,\"x\":-918.022}', '{\"y\":-382.023,\"z\":37.961,\"x\":-943.626}', '[]', NULL, 1, 1, 0, '{\"x\":-927.554,\"y\":-377.744,\"z\":112.674}', 1700000),
(4, 'NorthConkerAvenue2044', '2044 North Conker Avenue', '{\"y\":440.8,\"z\":146.702,\"x\":346.964}', '{\"y\":437.456,\"z\":148.394,\"x\":341.683}', '{\"y\":435.626,\"z\":148.394,\"x\":339.595}', '{\"x\":350.535,\"y\":443.329,\"z\":145.764}', '[]', NULL, 1, 1, 0, '{\"x\":337.726,\"y\":436.985,\"z\":140.77}', 1500000),
(5, 'WildOatsDrive', '3655 Wild Oats Drive', '{\"y\":502.696,\"z\":136.421,\"x\":-176.003}', '{\"y\":497.817,\"z\":136.653,\"x\":-174.349}', '{\"y\":495.069,\"z\":136.666,\"x\":-173.331}', '{\"y\":506.412,\"z\":135.0664,\"x\":-177.927}', '[]', NULL, 1, 1, 0, '{\"x\":-174.725,\"y\":493.095,\"z\":129.043}', 1500000),
(6, 'HillcrestAvenue2862', '2862 Hillcrest Avenue', '{\"y\":596.58,\"z\":142.641,\"x\":-686.554}', '{\"y\":591.988,\"z\":144.392,\"x\":-681.728}', '{\"y\":590.608,\"z\":144.392,\"x\":-680.124}', '{\"y\":599.019,\"z\":142.059,\"x\":-689.492}', '[]', NULL, 1, 1, 0, '{\"x\":-680.46,\"y\":588.6,\"z\":136.769}', 1500000),
(7, 'LowEndApartment', 'Appartement de base', '{\"y\":-1078.735,\"z\":28.4031,\"x\":292.528}', '{\"y\":-1007.152,\"z\":-102.002,\"x\":265.845}', '{\"y\":-1002.802,\"z\":-100.008,\"x\":265.307}', '{\"y\":-1078.669,\"z\":28.401,\"x\":296.738}', '[]', NULL, 1, 1, 0, '{\"x\":265.916,\"y\":-999.38,\"z\":-100.008}', 562500),
(8, 'MadWayneThunder', '2113 Mad Wayne Thunder', '{\"y\":454.955,\"z\":96.462,\"x\":-1294.433}', '{\"x\":-1289.917,\"y\":449.541,\"z\":96.902}', '{\"y\":446.322,\"z\":96.899,\"x\":-1289.642}', '{\"y\":455.453,\"z\":96.517,\"x\":-1298.851}', '[]', NULL, 1, 1, 0, '{\"x\":-1287.306,\"y\":455.901,\"z\":89.294}', 1500000),
(9, 'HillcrestAvenue2874', '2874 Hillcrest Avenue', '{\"x\":-853.346,\"y\":696.678,\"z\":147.782}', '{\"y\":690.875,\"z\":151.86,\"x\":-859.961}', '{\"y\":688.361,\"z\":151.857,\"x\":-859.395}', '{\"y\":701.628,\"z\":147.773,\"x\":-855.007}', '[]', NULL, 1, 1, 0, '{\"x\":-858.543,\"y\":697.514,\"z\":144.253}', 1500000),
(10, 'HillcrestAvenue2868', '2868 Hillcrest Avenue', '{\"y\":620.494,\"z\":141.588,\"x\":-752.82}', '{\"y\":618.62,\"z\":143.153,\"x\":-759.317}', '{\"y\":617.629,\"z\":143.153,\"x\":-760.789}', '{\"y\":621.281,\"z\":141.254,\"x\":-750.919}', '[]', NULL, 1, 1, 0, '{\"x\":-762.504,\"y\":618.992,\"z\":135.53}', 1500000),
(11, 'TinselTowersApt12', 'Tinsel Towers, Apt 42', '{\"y\":37.025,\"z\":42.58,\"x\":-618.299}', '{\"y\":58.898,\"z\":97.2,\"x\":-603.301}', '{\"y\":58.941,\"z\":97.2,\"x\":-608.741}', '{\"y\":30.603,\"z\":42.524,\"x\":-620.017}', '[]', NULL, 1, 1, 0, '{\"x\":-622.173,\"y\":54.585,\"z\":96.599}', 1700000),
(12, 'MiltonDrive', 'Milton Drive', '{\"x\":-775.17,\"y\":312.01,\"z\":84.658}', NULL, NULL, '{\"x\":-775.346,\"y\":306.776,\"z\":84.7}', '[]', NULL, 0, 0, 1, NULL, 0),
(13, 'Modern1Apartment', 'Appartement Moderne 1', NULL, '{\"x\":-784.194,\"y\":323.636,\"z\":210.997}', '{\"x\":-779.751,\"y\":323.385,\"z\":210.997}', NULL, '[\"apa_v_mp_h_01_a\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-766.661,\"y\":327.672,\"z\":210.396}', 1300000),
(14, 'Modern2Apartment', 'Appartement Moderne 2', NULL, '{\"x\":-786.8663,\"y\":315.764,\"z\":186.913}', '{\"x\":-781.808,\"y\":315.866,\"z\":186.913}', NULL, '[\"apa_v_mp_h_01_c\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-795.735,\"y\":326.757,\"z\":186.313}', 1300000),
(15, 'Modern3Apartment', 'Appartement Moderne 3', NULL, '{\"x\":-774.012,\"y\":342.042,\"z\":195.686}', '{\"x\":-779.057,\"y\":342.063,\"z\":195.686}', NULL, '[\"apa_v_mp_h_01_b\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.386,\"y\":330.782,\"z\":195.08}', 1300000),
(16, 'Mody1Apartment', 'Appartement Mode 1', NULL, '{\"x\":-784.194,\"y\":323.636,\"z\":210.997}', '{\"x\":-779.751,\"y\":323.385,\"z\":210.997}', NULL, '[\"apa_v_mp_h_02_a\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-766.615,\"y\":327.878,\"z\":210.396}', 1300000),
(17, 'Mody2Apartment', 'Appartement Mode 2', NULL, '{\"x\":-786.8663,\"y\":315.764,\"z\":186.913}', '{\"x\":-781.808,\"y\":315.866,\"z\":186.913}', NULL, '[\"apa_v_mp_h_02_c\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-795.297,\"y\":327.092,\"z\":186.313}', 1300000),
(18, 'Mody3Apartment', 'Appartement Mode 3', NULL, '{\"x\":-774.012,\"y\":342.042,\"z\":195.686}', '{\"x\":-779.057,\"y\":342.063,\"z\":195.686}', NULL, '[\"apa_v_mp_h_02_b\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.303,\"y\":330.932,\"z\":195.085}', 1300000),
(19, 'Vibrant1Apartment', 'Appartement Vibrant 1', NULL, '{\"x\":-784.194,\"y\":323.636,\"z\":210.997}', '{\"x\":-779.751,\"y\":323.385,\"z\":210.997}', NULL, '[\"apa_v_mp_h_03_a\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.885,\"y\":327.641,\"z\":210.396}', 1300000),
(20, 'Vibrant2Apartment', 'Appartement Vibrant 2', NULL, '{\"x\":-786.8663,\"y\":315.764,\"z\":186.913}', '{\"x\":-781.808,\"y\":315.866,\"z\":186.913}', NULL, '[\"apa_v_mp_h_03_c\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-795.607,\"y\":327.344,\"z\":186.313}', 1300000),
(21, 'Vibrant3Apartment', 'Appartement Vibrant 3', NULL, '{\"x\":-774.012,\"y\":342.042,\"z\":195.686}', '{\"x\":-779.057,\"y\":342.063,\"z\":195.686}', NULL, '[\"apa_v_mp_h_03_b\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.525,\"y\":330.851,\"z\":195.085}', 1300000),
(22, 'Sharp1Apartment', 'Appartement Persan 1', NULL, '{\"x\":-784.194,\"y\":323.636,\"z\":210.997}', '{\"x\":-779.751,\"y\":323.385,\"z\":210.997}', NULL, '[\"apa_v_mp_h_04_a\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-766.527,\"y\":327.89,\"z\":210.396}', 1300000),
(23, 'Sharp2Apartment', 'Appartement Persan 2', NULL, '{\"x\":-786.8663,\"y\":315.764,\"z\":186.913}', '{\"x\":-781.808,\"y\":315.866,\"z\":186.913}', NULL, '[\"apa_v_mp_h_04_c\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-795.642,\"y\":326.497,\"z\":186.313}', 1300000),
(24, 'Sharp3Apartment', 'Appartement Persan 3', NULL, '{\"x\":-774.012,\"y\":342.042,\"z\":195.686}', '{\"x\":-779.057,\"y\":342.063,\"z\":195.686}', NULL, '[\"apa_v_mp_h_04_b\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.503,\"y\":331.318,\"z\":195.085}', 1300000),
(25, 'Monochrome1Apartment', 'Appartement Monochrome 1', NULL, '{\"x\":-784.194,\"y\":323.636,\"z\":210.997}', '{\"x\":-779.751,\"y\":323.385,\"z\":210.997}', NULL, '[\"apa_v_mp_h_05_a\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-766.289,\"y\":328.086,\"z\":210.396}', 1300000),
(26, 'Monochrome2Apartment', 'Appartement Monochrome 2', NULL, '{\"x\":-786.8663,\"y\":315.764,\"z\":186.913}', '{\"x\":-781.808,\"y\":315.866,\"z\":186.913}', NULL, '[\"apa_v_mp_h_05_c\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-795.692,\"y\":326.762,\"z\":186.313}', 1300000),
(27, 'Monochrome3Apartment', 'Appartement Monochrome 3', NULL, '{\"x\":-774.012,\"y\":342.042,\"z\":195.686}', '{\"x\":-779.057,\"y\":342.063,\"z\":195.686}', NULL, '[\"apa_v_mp_h_05_b\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.094,\"y\":330.976,\"z\":195.085}', 1300000),
(28, 'Seductive1Apartment', 'Appartement Séduisant 1', NULL, '{\"x\":-784.194,\"y\":323.636,\"z\":210.997}', '{\"x\":-779.751,\"y\":323.385,\"z\":210.997}', NULL, '[\"apa_v_mp_h_06_a\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-766.263,\"y\":328.104,\"z\":210.396}', 1300000),
(29, 'Seductive2Apartment', 'Appartement Séduisant 2', NULL, '{\"x\":-786.8663,\"y\":315.764,\"z\":186.913}', '{\"x\":-781.808,\"y\":315.866,\"z\":186.913}', NULL, '[\"apa_v_mp_h_06_c\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-795.655,\"y\":326.611,\"z\":186.313}', 1300000),
(30, 'Seductive3Apartment', 'Appartement Séduisant 3', NULL, '{\"x\":-774.012,\"y\":342.042,\"z\":195.686}', '{\"x\":-779.057,\"y\":342.063,\"z\":195.686}', NULL, '[\"apa_v_mp_h_06_b\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.3,\"y\":331.414,\"z\":195.085}', 1300000),
(31, 'Regal1Apartment', 'Appartement Régal 1', NULL, '{\"x\":-784.194,\"y\":323.636,\"z\":210.997}', '{\"x\":-779.751,\"y\":323.385,\"z\":210.997}', NULL, '[\"apa_v_mp_h_07_a\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.956,\"y\":328.257,\"z\":210.396}', 1300000),
(32, 'Regal2Apartment', 'Appartement Régal 2', NULL, '{\"x\":-786.8663,\"y\":315.764,\"z\":186.913}', '{\"x\":-781.808,\"y\":315.866,\"z\":186.913}', NULL, '[\"apa_v_mp_h_07_c\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-795.545,\"y\":326.659,\"z\":186.313}', 1300000),
(33, 'Regal3Apartment', 'Appartement Régal 3', NULL, '{\"x\":-774.012,\"y\":342.042,\"z\":195.686}', '{\"x\":-779.057,\"y\":342.063,\"z\":195.686}', NULL, '[\"apa_v_mp_h_07_b\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.087,\"y\":331.429,\"z\":195.123}', 1300000),
(34, 'Aqua1Apartment', 'Appartement Aqua 1', NULL, '{\"x\":-784.194,\"y\":323.636,\"z\":210.997}', '{\"x\":-779.751,\"y\":323.385,\"z\":210.997}', NULL, '[\"apa_v_mp_h_08_a\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-766.187,\"y\":328.47,\"z\":210.396}', 1300000),
(35, 'Aqua2Apartment', 'Appartement Aqua 2', NULL, '{\"x\":-786.8663,\"y\":315.764,\"z\":186.913}', '{\"x\":-781.808,\"y\":315.866,\"z\":186.913}', NULL, '[\"apa_v_mp_h_08_c\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-795.658,\"y\":326.563,\"z\":186.313}', 1300000),
(36, 'Aqua3Apartment', 'Appartement Aqua 3', NULL, '{\"x\":-774.012,\"y\":342.042,\"z\":195.686}', '{\"x\":-779.057,\"y\":342.063,\"z\":195.686}', NULL, '[\"apa_v_mp_h_08_b\"]', 'MiltonDrive', 0, 1, 0, '{\"x\":-765.287,\"y\":331.084,\"z\":195.086}', 1300000),
(37, 'IntegrityWay', '4 Integrity Way', '{\"x\":-47.804,\"y\":-585.867,\"z\":36.956}', NULL, NULL, '{\"x\":-54.178,\"y\":-583.762,\"z\":35.798}', '[]', NULL, 0, 0, 1, NULL, 0),
(38, 'IntegrityWay28', '4 Integrity Way - Apt 28', NULL, '{\"x\":-31.409,\"y\":-594.927,\"z\":79.03}', '{\"x\":-26.098,\"y\":-596.909,\"z\":79.03}', NULL, '[]', 'IntegrityWay', 0, 1, 0, '{\"x\":-11.923,\"y\":-597.083,\"z\":78.43}', 1700000),
(39, 'IntegrityWay30', '4 Integrity Way - Apt 30', NULL, '{\"x\":-17.702,\"y\":-588.524,\"z\":89.114}', '{\"x\":-16.21,\"y\":-582.569,\"z\":89.114}', NULL, '[]', 'IntegrityWay', 0, 1, 0, '{\"x\":-26.327,\"y\":-588.384,\"z\":89.123}', 1700000),
(40, 'DellPerroHeights', 'Dell Perro Heights', '{\"x\":-1447.06,\"y\":-538.28,\"z\":33.74}', NULL, NULL, '{\"x\":-1440.022,\"y\":-548.696,\"z\":33.74}', '[]', NULL, 0, 0, 1, NULL, 0),
(41, 'DellPerroHeightst4', 'Dell Perro Heights - Apt 28', NULL, '{\"x\":-1452.125,\"y\":-540.591,\"z\":73.044}', '{\"x\":-1455.435,\"y\":-535.79,\"z\":73.044}', NULL, '[]', 'DellPerroHeights', 0, 1, 0, '{\"x\":-1467.058,\"y\":-527.571,\"z\":72.443}', 1700000),
(42, 'DellPerroHeightst7', 'Dell Perro Heights - Apt 30', NULL, '{\"x\":-1451.562,\"y\":-523.535,\"z\":55.928}', '{\"x\":-1456.02,\"y\":-519.209,\"z\":55.929}', NULL, '[]', 'DellPerroHeights', 0, 1, 0, '{\"x\":-1457.026,\"y\":-530.219,\"z\":55.937}', 1700000),
(43, 'MazeBankBuilding', 'Maze Bank Building', '{\"x\":-79.18,\"y\":-795.92,\"z\":43.35}', NULL, NULL, '{\"x\":-72.50,\"y\":-786.92,\"z\":43.40}', '[]', NULL, 0, 0, 1, NULL, 0),
(44, 'OldSpiceWarm', 'Old Spice Warm', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_01a\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(45, 'OldSpiceClassical', 'Old Spice Classical', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_01b\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(46, 'OldSpiceVintage', 'Old Spice Vintage', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_01c\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(47, 'ExecutiveRich', 'Executive Rich', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_02b\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(48, 'ExecutiveCool', 'Executive Cool', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_02c\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(49, 'ExecutiveContrast', 'Executive Contrast', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_02a\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(50, 'PowerBrokerIce', 'Power Broker Ice', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_03a\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(51, 'PowerBrokerConservative', 'Power Broker Conservative', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_03b\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(52, 'PowerBrokerPolished', 'Power Broker Polished', NULL, '{\"x\":-75.69,\"y\":-827.08,\"z\":242.43}', '{\"x\":-75.51,\"y\":-823.90,\"z\":242.43}', NULL, '[\"ex_dt1_11_office_03c\"]', 'MazeBankBuilding', 0, 1, 0, '{\"x\":-71.81,\"y\":-814.34,\"z\":242.39}', 5000000),
(53, 'LomBank', 'Lom Bank', '{\"x\":-1581.36,\"y\":-558.23,\"z\":34.07}', NULL, NULL, '{\"x\":-1583.60,\"y\":-555.12,\"z\":34.07}', '[]', NULL, 0, 0, 1, NULL, 0),
(54, 'LBOldSpiceWarm', 'LB Old Spice Warm', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_01a\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(55, 'LBOldSpiceClassical', 'LB Old Spice Classical', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_01b\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(56, 'LBOldSpiceVintage', 'LB Old Spice Vintage', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_01c\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(57, 'LBExecutiveRich', 'LB Executive Rich', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_02b\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(58, 'LBExecutiveCool', 'LB Executive Cool', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_02c\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(59, 'LBExecutiveContrast', 'LB Executive Contrast', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_02a\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(60, 'LBPowerBrokerIce', 'LB Power Broker Ice', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_03a\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(61, 'LBPowerBrokerConservative', 'LB Power Broker Conservative', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_03b\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(62, 'LBPowerBrokerPolished', 'LB Power Broker Polished', NULL, '{\"x\":-1579.53,\"y\":-564.89,\"z\":107.62}', '{\"x\":-1576.42,\"y\":-567.57,\"z\":107.62}', NULL, '[\"ex_sm_13_office_03c\"]', 'LomBank', 0, 1, 0, '{\"x\":-1571.26,\"y\":-575.76,\"z\":107.52}', 3500000),
(63, 'MazeBankWest', 'Maze Bank West', '{\"x\":-1379.58,\"y\":-499.63,\"z\":32.22}', NULL, NULL, '{\"x\":-1378.95,\"y\":-502.82,\"z\":32.22}', '[]', NULL, 0, 0, 1, NULL, 0),
(64, 'MBWOldSpiceWarm', 'MBW Old Spice Warm', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_01a\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000),
(65, 'MBWOldSpiceClassical', 'MBW Old Spice Classical', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_01b\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000),
(66, 'MBWOldSpiceVintage', 'MBW Old Spice Vintage', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_01c\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000),
(67, 'MBWExecutiveRich', 'MBW Executive Rich', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_02b\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000),
(68, 'MBWExecutiveCool', 'MBW Executive Cool', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_02c\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000),
(69, 'MBWExecutive Contrast', 'MBW Executive Contrast', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_02a\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000),
(70, 'MBWPowerBrokerIce', 'MBW Power Broker Ice', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_03a\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000),
(71, 'MBWPowerBrokerConvservative', 'MBW Power Broker Convservative', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_03b\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000),
(72, 'MBWPowerBrokerPolished', 'MBW Power Broker Polished', NULL, '{\"x\":-1392.74,\"y\":-480.18,\"z\":71.14}', '{\"x\":-1389.43,\"y\":-479.01,\"z\":71.14}', NULL, '[\"ex_sm_15_office_03c\"]', 'MazeBankWest', 0, 1, 0, '{\"x\":-1390.76,\"y\":-479.22,\"z\":72.04}', 2700000);

-- --------------------------------------------------------

--
-- Structure de la table `property_item`
--

DROP TABLE IF EXISTS `property_item`;
CREATE TABLE IF NOT EXISTS `property_item` (
  `property` int(10) UNSIGNED NOT NULL,
  `item` int(10) UNSIGNED NOT NULL,
  `amount` int(11) NOT NULL,
  KEY `item` (`item`),
  KEY `property` (`property`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `property_item`
--

INSERT INTO `property_item` (`property`, `item`, `amount`) VALUES
(3, 5, 50);

-- --------------------------------------------------------

--
-- Structure de la table `tutorials`
--

DROP TABLE IF EXISTS `tutorials`;
CREATE TABLE IF NOT EXISTS `tutorials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `published` tinyint(1) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(60) NOT NULL DEFAULT 'Vehicule',
  `name` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `job` int(11) UNSIGNED DEFAULT NULL,
  `maxWeight` int(11) NOT NULL DEFAULT '50',
  PRIMARY KEY (`id`),
  KEY `job` (`job`)
) ENGINE=InnoDB AUTO_INCREMENT=345 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `vehicles`
--

INSERT INTO `vehicles` (`id`, `label`, `name`, `price`, `job`, `maxWeight`) VALUES
(1, 'Oracle', 'oracle', 48000, NULL, 50),
(2, 'Cruiser', 'police', 15000, 2, 50),
(3, 'Buffalo', 'police2', 24000, 2, 50),
(4, 'Interceptor', 'police3', 30000, 2, 50),
(5, 'Banalisée', 'police4', 19920, 2, 50),
(6, 'Moto de police', 'policeb', 19200, 2, 20),
(7, 'Maverick', 'polmav', 168000, 2, 10),
(8, 'Ambulance', 'ambulance', 55000, 3, 50),
(9, 'Bobcat XL', 'bobcatxl', 10000, NULL, 80),
(10, 'Taxi', 'taxi', 5000, 6, 50),
(11, 'Dépanneuse', 'towtruck', 5000, 7, 50),
(12, 'Blista', 'blista', 5000, NULL, 50),
(13, 'Dilettante', 'dilettante', 400, NULL, 50),
(14, 'Issi', 'issi2', 12000, NULL, 40),
(15, 'issi classique', 'issi3', 6000, NULL, 40),
(16, 'Rhapsody', 'rhapsody', 8000, NULL, 50),
(17, 'Cognoscenti', 'cognoscenti', 15000, NULL, 50),
(19, 'Brioso R/A', 'brioso', 8000, NULL, 30),
(20, 'Panto', 'panto', 300, NULL, 10),
(21, 'Prairie', 'prairie', 600, NULL, 20),
(26, 'Asea', 'asea', 2000, NULL, 40),
(27, 'Asterope', 'asterope', 3000, NULL, 50),
(28, 'Cognoscenti 55', 'cog55', 25000, NULL, 50),
(29, 'Emperor', 'emperor', 1200, NULL, 50),
(30, 'Fugitive', 'fugitive', 4800, NULL, 50),
(31, 'Glendale', 'glendale', 8000, NULL, 50),
(32, 'Ingot', 'ingot', 1200, NULL, 50),
(33, 'Intruder', 'intruder', 2000, NULL, 50),
(34, 'Premier', 'premier ', 1450, NULL, 30),
(35, 'Primo', 'primo', 3200, NULL, 40),
(36, 'Regina', 'regina', 600, NULL, 20),
(37, 'Shafter', 'shafter', 6000, NULL, 50),
(38, 'Stafford', 'stafford', 8000, NULL, 50),
(39, 'Stanier', 'Stanier', 3200, NULL, 100),
(40, 'Stanier', 'Stanier', 3200, NULL, 30),
(41, 'Stratum', 'stratum', 1650, NULL, 100),
(42, 'Strech', 'stretch', 100000, NULL, 100),
(43, 'Super Diamond', 'superd', 133000, NULL, 55),
(44, 'Surge', 'surge', 2300, NULL, 35),
(45, 'Tailgater', 'tailgater', 6700, NULL, 40),
(46, 'Wareener', 'warerener', 23500, NULL, 40),
(47, 'Washington', 'washington', 3200, NULL, 40),
(48, 'Baller', 'baller', 7000, NULL, 80),
(49, 'Baller(2)', 'baller2', 9000, NULL, 95),
(50, 'Baller LE', 'baller3', 9000, NULL, 100),
(51, 'Baller LE LWB', 'baller4', 11000, NULL, 100),
(52, 'BeeJay XL', 'bjxl', 6700, NULL, 85),
(53, 'Cavalcade', 'calvalcade', 4000, NULL, 75),
(54, 'Cavalcade (2)', 'cavalcade2', 8500, NULL, 80),
(55, 'Contender', 'contender', 14500, NULL, 120),
(56, 'Dubsta', 'dubsta', 16500, NULL, 120),
(57, 'Dybsta (2)', 'dubsta2', 18000, NULL, 125),
(58, 'FQ 2 ', 'fq2', 22000, NULL, 100),
(59, 'Granger', 'granger', 27000, NULL, 125),
(60, 'Greskey', 'gresley', 18500, NULL, 100),
(61, 'Habanero', 'habanero', 15000, NULL, 100),
(62, 'Huntley S', 'huntley', 22000, NULL, 100),
(63, 'Landstalker', 'landstalker', 13000, NULL, 100),
(64, 'Mesa', 'mesa', 25000, NULL, 100),
(65, 'Patriot', 'patriot', 28000, NULL, 100),
(66, 'Patriot Stretch', 'patriot2', 75000, NULL, 100),
(67, 'Radi', 'radius', 13000, NULL, 100),
(68, 'Rocoto', 'rocot', 8900, NULL, 80),
(69, 'Seminole', 'seminole', 19000, NULL, 102),
(70, 'Serrano', 'seranno', 18000, NULL, 120),
(71, 'Toros', 'toros', 28500, NULL, 120),
(72, 'XLS', 'xls', 22000, NULL, 120),
(73, 'Cognoscenti Cabrio', 'cogcabrio', 42000, NULL, 55),
(74, 'Exemplar', 'exemplar', 15000, NULL, 35),
(75, 'F620', 'f620', 78500, NULL, 35),
(76, 'Felon', 'felon', 80000, NULL, 35),
(77, 'Felon GT', 'felon2', 88000, NULL, 35),
(78, 'Jackal', 'jackal', 75000, NULL, 35),
(79, 'Oracle XS', 'oracle2', 55000, NULL, 35),
(80, 'Sentinel XS', 'sentinel', 45000, NULL, 100),
(81, 'Sentinel', 'sentinel2', 48000, NULL, 100),
(82, 'Windsor', 'windsor', 102000, NULL, 100),
(83, 'Windsor Drop', 'windsor2', 132000, NULL, 100),
(84, 'Zion', 'zion', 62000, NULL, 100),
(85, 'Zion Cabrio', 'zion2', 68000, NULL, 100),
(86, 'Blade', 'blade', 22000, NULL, 50),
(87, 'Buccaneer', 'buccaneer', 38000, NULL, 50),
(88, 'Buccaneer Cabrio', 'buccaneer2', 45000, NULL, 50),
(89, 'Chino', 'chino', 35000, NULL, 50),
(90, 'Chino custom', 'chino', 38000, NULL, 50),
(91, 'Clique', 'clique', 45000, NULL, 50),
(92, 'Coquette BlackFin', 'coquette3', 75000, NULL, 50),
(93, 'Deviant', 'deviant', 88000, NULL, 50),
(94, 'Dominator', 'dominator', 73000, NULL, 50),
(95, 'Dominato Pisswasser', 'dominator2', 75000, NULL, 50),
(96, 'Dominato GTX', 'dominator3', 103000, NULL, 50),
(97, 'Dukes', 'dukes', 45000, NULL, 50),
(98, 'ellie', 'ellie', 65000, NULL, 50),
(99, 'Faction', 'faction', 25000, NULL, 50),
(100, 'Faction Custom', 'faction2', 45000, NULL, 50),
(101, 'Gauntlet', 'gauntlet', 65000, NULL, 50),
(102, 'Gauntlet Redwood', 'gauntlet2', 68000, NULL, 50),
(103, 'Hermes', 'hermes', 48000, NULL, 50),
(104, 'Hotknife', 'hotknife', 155000, NULL, 50),
(105, 'Hustler', 'hustler', 102000, NULL, 50),
(106, 'Impaler', 'impaler', 25000, NULL, 50),
(107, 'Moobeam', 'moonbeam', 13000, NULL, 120),
(108, 'Moobeam custom', 'moonbeam2', 16000, NULL, 120),
(109, 'Nightshade', 'nightshade', 65000, NULL, 50),
(110, 'Phoenix', 'phoenix', 40000, NULL, 50),
(111, 'Picador', 'picador', 23000, NULL, 50),
(112, 'Rat-Truck', 'ratloader2', 2500, NULL, 120),
(113, 'Rat-Loader', 'ratloader', 50, NULL, 0),
(114, 'Ruiner', 'ruiner', 13000, NULL, 50),
(115, 'Ruiner 2000', 'ruiner2', 18000, NULL, 50),
(116, 'Sabre Turbo', 'sabregt', 23000, NULL, 50),
(117, 'Sabre Turbo custom', 'sabregt2', 28000, NULL, 50),
(118, 'Slamvan', 'slamvan', 7000, NULL, 100),
(119, 'Slamvan 2', 'slamvan2', 13000, NULL, 120),
(120, 'Slamvan c ustom', 'slamvan3', 19000, NULL, 120),
(121, 'Satllion', 'stallion', 23000, NULL, 50),
(122, 'Stallion Burger Shot', 'stallion2', 25000, NULL, 50),
(123, 'Tampa', 'tampa', 28000, NULL, 50),
(124, 'Tulip', 'tulip', 33000, NULL, 50),
(125, 'Vamos', 'vamos', 13000, NULL, 50),
(126, 'Vigero', 'vigero', 18000, NULL, 50),
(127, 'Virgo', 'virgo', 15000, NULL, 50),
(128, 'Virgo classique custom', 'virgo2', 18000, NULL, 50),
(129, 'Virgo classique', 'virgo3', 17500, NULL, 50),
(130, 'Voodoo custom', 'voodoo', 23500, NULL, 50),
(131, 'Yosemite', 'yosemite', 25000, NULL, 100),
(132, 'Ardent', 'ardent', 50000, NULL, 50),
(133, 'Roosevelt', 'btype', 63500, NULL, 50),
(134, 'Frânken Stange', 'btype2', 15000, NULL, 50),
(135, 'Roosevelt Valor', 'btype3', 70000, NULL, 50),
(136, 'Casco', 'casco', 55000, NULL, 50),
(137, 'Cheburek', 'cheburek', 28000, NULL, 50),
(138, 'Cheetah classique', 'cheetah2', 68000, NULL, 50),
(139, 'Coquette classique', 'coquette2', 75000, NULL, 50),
(140, 'Deluxo', 'deluxo', 45000, NULL, 50),
(141, 'Fagaloa', 'fagaloa', 7500, NULL, 50),
(142, 'Stirling GT', 'feltzer3', 88000, NULL, 50),
(143, 'GT500', 'gt500', 98000, NULL, 50),
(144, 'Infernus classique', 'infernus2', 102000, NULL, 50),
(145, 'JB 700', 'jb700', 73000, NULL, 50),
(146, 'Jester classique', 'jester3', 60000, NULL, 50),
(147, 'Mamba', 'mamba', 76500, NULL, 50),
(148, 'Manana', 'manana', 18000, NULL, 50),
(149, 'Michelli GT', 'michelli', 13500, NULL, 50),
(150, 'Monroe', 'monroe', 63000, NULL, 50),
(151, 'Peyote', 'peyote', 23000, NULL, 50),
(152, 'Pigalle', 'pigalle', 12600, NULL, 50),
(153, 'Rapid GT classique', 'rapidgt3', 45000, NULL, 50),
(154, 'Retinue', 'retinue', 25000, NULL, 50),
(155, 'Savestra', 'savestra', 25000, NULL, 50),
(156, 'Stinger', 'stinger', 120000, NULL, 50),
(157, 'Stinger GT', 'stingergt', 145000, NULL, 50),
(158, 'Stromberg', 'stromberg', 102000, NULL, 50),
(159, 'Swinger', 'swinger', 120000, NULL, 50),
(160, 'Torero', 'torero', 125000, NULL, 50),
(161, 'Tornado', 'tornado', 26000, NULL, 50),
(162, 'Tornado (2)', 'tornado2', 28000, NULL, 50),
(163, 'Tornado custom', 'tornado5', 29500, NULL, 50),
(164, 'Turismo classique', 'turismo2', 880000, NULL, 50),
(165, 'Viseris', 'viseris', 73000, NULL, 50),
(166, 'z190', '190z', 60000, NULL, 50),
(167, 'Z-Type', 'ztype', 45000, NULL, 50),
(168, 'Alpha', 'alpha', 39000, NULL, 50),
(169, 'Banshee', 'banshee', 43000, NULL, 50),
(170, 'Bestia GTS', 'bestagts', 35000, NULL, 50),
(171, 'Blista Compact', 'blista2', 12000, NULL, 50),
(172, 'Blista GO GO Monkey', 'blista3', 12500, NULL, 50),
(173, 'Buffalo', 'buffalo', 35000, NULL, 50),
(174, 'Buffalo S', 'buffalo2', 38000, NULL, 50),
(175, 'Buffalo Sprunk', 'buffalo3', 40000, NULL, 50),
(176, 'Carbonizzare', 'carbonizzare', 45000, NULL, 50),
(177, 'Comet', 'comet2', 53000, NULL, 50),
(178, 'Comet rétro custom', 'comet3', 58000, NULL, 50),
(179, 'Comet Safari', 'comet4', 53500, NULL, 50),
(180, 'Comet SR', 'comet5', 59000, NULL, 50),
(181, 'Coquette', 'coquette', 63000, NULL, 50),
(182, 'Elegy rétro custom', 'elegy', 70000, NULL, 50),
(183, 'Elegy RH8', 'elegy2', 75000, NULL, 50),
(184, 'Feltzer', 'feltzer2', 56000, NULL, 50),
(185, 'Flash GT', 'flashgt', 88000, NULL, 50),
(186, 'Furore GT', 'furoregt', 63000, NULL, 50),
(187, 'Fusilade', 'fusilade', 43000, NULL, 50),
(188, 'Futo', 'futo', 23000, NULL, 50),
(189, 'GB200', 'gb200', 28000, NULL, 50),
(190, 'Hotring Sabre', 'hotring', 43000, NULL, 50),
(191, 'Itali GTO', 'italigto', 88000, NULL, 50),
(192, 'Jester', 'jester', 65000, NULL, 50),
(193, 'Jester (course)', 'jester2', 68000, NULL, 50),
(194, 'Khamelion', 'khamelion', 62000, NULL, 50),
(195, 'Kuruma', 'kuruma', 60000, NULL, 50),
(196, 'Lynx', 'lynx', 55000, NULL, 50),
(197, 'Massacro', 'massacro', 55000, NULL, 50),
(198, 'Massacro (course)', 'massacro2', 55000, NULL, 50),
(199, 'Neon', 'neon', 65000, NULL, 50),
(200, '9F', 'ninef', 48000, NULL, 50),
(201, '9F Cabrio', 'ninef2', 52000, NULL, 50),
(202, 'Pariah', 'Pariah', 50000, NULL, 50),
(203, 'Penumbra', 'penumbra', 53000, NULL, 50),
(204, 'Raiden', 'raiden', 53000, NULL, 50),
(205, 'Rapid GT', 'rapidgt', 63000, NULL, 50),
(206, 'Rapid GT (2)', 'rapidgt2', 65000, NULL, 50),
(207, 'Revolter', 'revolter', 65000, NULL, 50),
(208, 'Ruston', 'ruston', 103000, NULL, 50),
(209, 'Shafter', 'shafter2', 13000, NULL, 50),
(210, 'Shafter V12', 'shafter3', 13500, NULL, 50),
(211, 'Shafter LWB', 'shafter4', 15500, NULL, 50),
(212, 'Shlagen GT', 'shlagen', 66000, NULL, 50),
(213, 'Schwartzer', 'schwarzer', 66000, NULL, 50),
(214, 'Sentinel classique', '68000', 66000, NULL, 50),
(215, 'Seven-70', 'seven70', 68000, NULL, 50),
(216, 'Specter', 'specter', 75000, NULL, 50),
(217, 'Specter custom', 'specter2', 78000, NULL, 50),
(218, 'Sultan', 'sultan', 22000, NULL, 50),
(219, 'Surano', 'surano', 78000, NULL, 50),
(220, 'Tampas drift', 'tampa2', 38000, NULL, 50),
(221, 'Tropos rallye', 'tropos', 35000, NULL, 50),
(222, 'Verlierer', 'verlierer2', 42000, NULL, 50),
(223, 'Crusader', 'crusader', 5000, NULL, 50),
(224, 'BMX', 'bmx', 500, NULL, 50),
(225, 'Cruiser', 'cruiser', 200, NULL, 50),
(226, 'Fixter', 'fixter', 350, NULL, 50),
(227, 'Scorcher', 'scorcher', 800, NULL, 50),
(228, 'Tribike', 'tribike', 1000, NULL, 50),
(229, 'Endurex', 'tribike2', 950, NULL, 50),
(230, 'Tri-Cycles', 'tribike3', 1100, NULL, 50),
(231, 'Bison', 'bison', 22000, NULL, 120),
(232, 'Burrito', 'burrito3', 18000, NULL, 120),
(233, 'Camper', 'camper', 25000, NULL, 150),
(234, 'Journey', 'journey', 13000, NULL, 150),
(235, 'Minivan', 'minivan', 3200, NULL, 50),
(236, 'Minivan custom', 'minivan2', 3800, NULL, 50),
(237, 'Rumpo custom', 'rumpo3', 32000, NULL, 50),
(238, 'Speedo', 'speedo', 23000, NULL, 50),
(239, 'Speedo custom', 'speedo4', 26000, NULL, 50),
(240, 'Surfer', 'surfer', 13000, NULL, 50),
(241, 'youga', 'youha', 18000, NULL, 120),
(242, 'Youga classique', 'youga2', 19000, NULL, 120),
(243, 'Sadler', 'sadler', 21000, NULL, 120),
(244, 'Guardian', 'guardian', 250000, NULL, 120),
(245, 'Injection', 'bfinjection', 13000, NULL, 50),
(246, 'Bifta', 'bifta', 12000, NULL, 50),
(247, 'Blazer', 'blazer', 6000, NULL, 50),
(248, 'Blazer aqua', 'blazer5', 18000, NULL, 50),
(249, 'Bodhi', 'bodhi2', 23000, NULL, 50),
(250, 'Brawler', 'brawler', 63000, NULL, 50),
(251, 'Duneloader', 'dloader', 6000, NULL, 120),
(252, 'Dune Buggy', 'dune', 8000, NULL, 50),
(253, 'FreeCrawler', 'freecrawler', 27000, NULL, 50),
(254, 'Kalahari', 'kalahari', 2500, NULL, 50),
(255, 'Kamacho', 'kamacho', 26000, NULL, 80),
(256, 'Mesa', 'mesa3', 42000, NULL, 50),
(257, 'Rancher', 'rancherxl', 18000, NULL, 50),
(258, 'Rebel rouillé', 'rebel', 4800, NULL, 50),
(259, 'Rebel', 'rebel2', 12000, NULL, 50),
(260, 'Riata', 'riata', 32000, NULL, 120),
(261, 'Sandking XL', 'sandking', 23000, NULL, 120),
(262, 'Sandking SWB', 'sandking2', 26000, NULL, 120),
(263, 'Trophy truck', 'trophytruck', 199000, NULL, 50),
(264, 'Akuma', 'akuma', 23000, NULL, 10),
(265, 'Avarus', 'avarus', 7500, NULL, 10),
(266, 'Bagger', 'bagger', 12000, NULL, 50),
(267, 'Bati 801', 'bati', 15000, NULL, 10),
(268, 'Bati 801RR', 'bati2', 18000, NULL, 10),
(269, 'BF400', 'bf400', 13000, NULL, 10),
(270, 'Carbon RS', 'carbonrs', 18000, NULL, 10),
(271, 'Chimera', 'chimera', 16000, NULL, 10),
(272, 'Cliffhanger', 'cliffhanger', 8000, NULL, 10),
(273, 'Daemon', 'deamon', 6000, NULL, 10),
(274, 'Daemon (2)', 'deamon2', 9000, NULL, 10),
(275, 'Defiler', 'defiler', 6000, NULL, 10),
(276, 'Diabolus', 'diablous', 9000, NULL, 10),
(277, 'Diabolus custom', 'diablous2', 11000, NULL, 10),
(278, 'Double-T', 'double', 14000, NULL, 10),
(279, 'Enduro', 'enduro', 18000, NULL, 10),
(280, 'Esskey', 'esskey', 11000, NULL, 10),
(281, 'Faggio sport', 'faggio', 1200, NULL, 10),
(282, 'Faggio', 'faggio2', 600, NULL, 10),
(283, 'Faggio mod', 'faggio3', 700, NULL, 50),
(284, 'FCR 100', 'fcr', 6600, NULL, 50),
(285, 'FCR 1000 custom', 'fcr2', 19000, NULL, 50),
(286, 'Gargoyle', 'gargoyle', 22000, NULL, 50),
(287, 'Hakuchou', 'hakuchou', 18000, NULL, 50),
(288, 'Hexer', 'hexer', 14000, NULL, 50),
(289, 'Innovation', 'innovation', 25000, NULL, 50),
(290, 'Lectro', 'lectro', 16000, NULL, 50),
(291, 'Manchez', 'manchez', 9000, NULL, 50),
(292, 'Nemesis', 'nemesis', 12000, NULL, 50),
(293, 'Nightblade', 'nightblade', 28000, NULL, 50),
(294, 'PCJ 600', 'pcj', 13000, NULL, 10),
(295, 'Rat bike', 'ratbike', 900, NULL, 10),
(296, 'Ruffian', 'ruffian', 6000, NULL, 10),
(297, 'Sanchez Promo', 'sanchez', 6000, NULL, 10),
(298, 'Sanchez', 'sanchez2', 8000, NULL, 10),
(299, 'Sanctus', 'sanctus', 120000, NULL, 50),
(300, 'Trump', 'soverein', 9900, NULL, 75),
(301, 'Thrust', 'thrust', 18000, NULL, 10),
(302, 'Vader', 'vader', 13000, NULL, 10),
(303, 'Vindicator', 'vindicator', 23000, NULL, 10),
(304, 'Vortex', 'vortex', 17500, NULL, 10),
(305, 'Wolfsbane', 'wolfsbane', 7500, NULL, 10),
(306, 'Zombie bobber', 'zombiea', 16500, NULL, 10),
(307, 'Zombie chopper', 'zombieb', 17500, NULL, 10),
(308, 'Adder', 'adder', 90000, NULL, 50),
(309, 'Autarch', 'autarch', 120000, NULL, 50),
(310, 'Banshee 900R', 'banshee2', 135000, NULL, 50),
(311, 'Bullet', 'bullet', 150000, NULL, 50),
(312, 'Cheetah', 'cheetah', 135000, NULL, 50),
(313, 'Cyclone', 'cyclone', 120000, NULL, 50),
(314, 'Entity XF', 'entityxf', 160000, NULL, 50),
(315, 'Entity XXR', 'entity2', 185000, NULL, 50),
(316, 'FMJ', 'fmj', 135000, NULL, 50),
(317, 'FP1', 'fp1', 135000, NULL, 50),
(318, 'Infernus', 'infernus', 150000, NULL, 50),
(319, 'Itali GTB', 'italigtb', 180000, NULL, 50),
(320, 'Itali GTB custom', 'italigtb2', 210000, NULL, 50),
(321, 'RE-7B', 'le7b', 235000, NULL, 50),
(322, 'Nero', 'nero', 255000, NULL, 50),
(323, 'Nero custom', 'nero2', 285000, NULL, 50),
(324, 'Osiris', 'osiris', 235000, NULL, 50),
(325, 'Penetrator', 'penetrator', 135000, NULL, 50),
(326, '811', 'pfister811', 156000, NULL, 50),
(327, 'X80 Proto', 'prototipo', 380000, NULL, 50),
(328, 'Reaper', 'reaper', 336000, NULL, 50),
(329, 'SC1', 'sc1', 285000, NULL, 50),
(330, 'ETR1', 'sheava', 180000, NULL, 20),
(331, 'Sultan RS', 'sultanrs', 88000, NULL, 20),
(332, 'T20', 't20', 195000, NULL, 20),
(333, 'Taipan', 'taipan', 220000, NULL, 20),
(334, 'Tempesta', 'tempesta', 265000, NULL, 20),
(335, 'Tezeract', 'tezeract', 465000, NULL, 20),
(336, 'Turismo R', 'turismor', 235000, NULL, 20),
(337, 'Tyrant', 'tyrant', 220000, NULL, 20),
(338, 'Tyrus', 'tyrus', 180000, NULL, 20),
(339, 'Vacca', 'vacca', 135000, NULL, 20),
(340, 'Vagner', 'vagner', 185000, NULL, 20),
(341, 'Visione', 'visione', 302000, NULL, 20),
(342, 'Voltic', 'voltic', 130000, NULL, 20),
(343, 'XA-21', 'xa21', 195000, NULL, 20),
(344, 'Zentorno', 'zentorno', 223000, NULL, 20);

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_item`
--

DROP TABLE IF EXISTS `vehicle_item`;
CREATE TABLE IF NOT EXISTS `vehicle_item` (
  `vehicle_mod` int(11) NOT NULL,
  `item` int(11) UNSIGNED NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL DEFAULT '1',
  UNIQUE KEY `vehicle_2` (`vehicle_mod`,`item`),
  KEY `vehicle_mod` (`vehicle_mod`),
  KEY `item` (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_mod`
--

DROP TABLE IF EXISTS `vehicle_mod`;
CREATE TABLE IF NOT EXISTS `vehicle_mod` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle` int(11) NOT NULL,
  `parking` varchar(255) NOT NULL,
  `gameId` int(11) DEFAULT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` double DEFAULT NULL,
  `heading` double DEFAULT NULL,
  `bodyHealth` double DEFAULT '1000',
  `primaryColour` int(11) DEFAULT NULL,
  `secondaryColour` int(11) DEFAULT NULL,
  `dirtLevel` double DEFAULT '0',
  `doorLockStatus` int(11) DEFAULT NULL,
  `engineHealth` double DEFAULT '1000',
  `fuelLevel` double DEFAULT '30',
  `livery` int(11) DEFAULT NULL,
  `numberPlateText` varchar(8) DEFAULT NULL,
  `petrolTankHealth` int(11) DEFAULT NULL,
  `roofLivery` int(11) DEFAULT NULL,
  `windowTint` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vehicle` (`vehicle`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `vehicle_mod`
--

INSERT INTO `vehicle_mod` (`id`, `vehicle`, `parking`, `gameId`, `x`, `y`, `z`, `heading`, `bodyHealth`, `primaryColour`, `secondaryColour`, `dirtLevel`, `doorLockStatus`, `engineHealth`, `fuelLevel`, `livery`, `numberPlateText`, `petrolTankHealth`, `roofLivery`, `windowTint`) VALUES
(44, 219, '', 2562, -228.53738403320312, -1299.9024658203125, 30.93446922302246, 287.2345886230469, 1000, 131, 0, 0.0023145785089582205, 0, 1000, 32.94766616821289, 0, '48JNV774', NULL, -1, -1),
(46, 2, 'global', 235010, 236.70596313476562, -779.2359008789062, 30.28151512145996, 129.1238250732422, 989.8165283203125, 0, 0, 0.0410161130130291, 1, 984.724853515625, 28.71035385131836, 0, '42UEF323', NULL, -1, -1),
(56, 4, 'bennys', 5122, -189.7909393310547, -1288.953857421875, 31.053020477294922, 281.2215881347656, 982.9869384765625, 0, 0, 0.01024177297949791, 0, 1000, 48.192604064941406, 0, '83PVP449', NULL, -1, -1);

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_mod_type`
--

DROP TABLE IF EXISTS `vehicle_mod_type`;
CREATE TABLE IF NOT EXISTS `vehicle_mod_type` (
  `vehicle_mod` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`type`),
  KEY `vehicle_mod` (`vehicle_mod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `job_account`
--
ALTER TABLE `job_account`
  ADD CONSTRAINT `job_account_ibfk_1` FOREIGN KEY (`job`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `job_account_ibfk_2` FOREIGN KEY (`account`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `job_armory`
--
ALTER TABLE `job_armory`
  ADD CONSTRAINT `job_armory_ibfk_1` FOREIGN KEY (`job`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `job_grades`
--
ALTER TABLE `job_grades`
  ADD CONSTRAINT `job_grades_ibfk_1` FOREIGN KEY (`job`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `job_item`
--
ALTER TABLE `job_item`
  ADD CONSTRAINT `job_item_ibfk_1` FOREIGN KEY (`job`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `job_item_ibfk_2` FOREIGN KEY (`item`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `job_vehicle`
--
ALTER TABLE `job_vehicle`
  ADD CONSTRAINT `job_vehicle_ibfk_1` FOREIGN KEY (`job`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `job_vehicle_ibfk_2` FOREIGN KEY (`vehicle_mod`) REFERENCES `vehicle_mod` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`job_grade`) REFERENCES `job_grades` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `player_account`
--
ALTER TABLE `player_account`
  ADD CONSTRAINT `player_account_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_account_ibfk_2` FOREIGN KEY (`player`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `player_item`
--
ALTER TABLE `player_item`
  ADD CONSTRAINT `player_item_ibfk_1` FOREIGN KEY (`player`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_item_ibfk_2` FOREIGN KEY (`item`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `player_vehicle`
--
ALTER TABLE `player_vehicle`
  ADD CONSTRAINT `player_vehicle_ibfk_1` FOREIGN KEY (`player`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_vehicle_ibfk_2` FOREIGN KEY (`vehicle_mod`) REFERENCES `vehicle_mod` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `property_item`
--
ALTER TABLE `property_item`
  ADD CONSTRAINT `property_item_ibfk_1` FOREIGN KEY (`item`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `property_item_ibfk_2` FOREIGN KEY (`property`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`job`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `vehicle_item`
--
ALTER TABLE `vehicle_item`
  ADD CONSTRAINT `vehicle_item_ibfk_1` FOREIGN KEY (`vehicle_mod`) REFERENCES `vehicle_mod` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `vehicle_item_ibfk_2` FOREIGN KEY (`item`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `vehicle_mod`
--
ALTER TABLE `vehicle_mod`
  ADD CONSTRAINT `vehicle_mod_ibfk_1` FOREIGN KEY (`vehicle`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `vehicle_mod_type`
--
ALTER TABLE `vehicle_mod_type`
  ADD CONSTRAINT `vehicle_mod_type_ibfk_1` FOREIGN KEY (`vehicle_mod`) REFERENCES `vehicle_mod` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

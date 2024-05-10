-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: company_attendance
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `entrance`
--

DROP TABLE IF EXISTS `entrance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entrance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` time DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entrance___fk` (`user_id`),
  CONSTRAINT `entrance___fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrance`
--

LOCK TABLES `entrance` WRITE;
/*!40000 ALTER TABLE `entrance` DISABLE KEYS */;
INSERT INTO `entrance` VALUES (1,'08:00:00',19),(2,'14:00:00',19),(3,'13:11:56',20),(4,'13:34:23',19),(5,'14:53:48',19),(6,'15:09:59',19),(7,'15:12:18',20);
/*!40000 ALTER TABLE `entrance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exit`
--

DROP TABLE IF EXISTS `exit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` time DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `justification_id` int(11) DEFAULT NULL,
  `working_justifications_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `justification_id` (`justification_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `justification_id` FOREIGN KEY (`justification_id`) REFERENCES `justifications` (`id`),
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exit`
--

LOCK TABLES `exit` WRITE;
/*!40000 ALTER TABLE `exit` DISABLE KEYS */;
INSERT INTO `exit` VALUES (1,'12:00:00',19,1,NULL),(2,'18:00:00',19,2,NULL),(3,'14:37:51',19,1,NULL),(4,'14:38:37',20,1,NULL),(5,'14:55:14',19,1,NULL),(6,'15:10:04',19,1,NULL),(7,'15:12:24',20,1,NULL);
/*!40000 ALTER TABLE `exit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `justifications`
--

DROP TABLE IF EXISTS `justifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `justifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `justifications`
--

LOCK TABLES `justifications` WRITE;
/*!40000 ALTER TABLE `justifications` DISABLE KEYS */;
INSERT INTO `justifications` VALUES (1,'Pausa pranzo'),(2,'Fine turno'),(3,'Appuntamento medico'),(4,'Emergenza familiare'),(5,'Problemi di salute'),(6,'Altro');
/*!40000 ALTER TABLE `justifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `hourly_rate` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (19,'Francesco','Mannozzi','0634c61494d47fb856164924ab37bee37d48fc449a6b7a8b2b77e09065991ae1',8.5),(20,'Riccardo','Nulli','4eb6b0b367171b91f30f49c59514eada9039e311a815d4b0bed09f87667be2da',10);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `working_justifications`
--

DROP TABLE IF EXISTS `working_justifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `working_justifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `working_justifications`
--

LOCK TABLES `working_justifications` WRITE;
/*!40000 ALTER TABLE `working_justifications` DISABLE KEYS */;
INSERT INTO `working_justifications` VALUES (1,'Commissione aziendale'),(2,'Formazione professionale'),(3,'Visita cliente'),(4,'Messa in sicurezza di un problema'),(5,'Altro');
/*!40000 ALTER TABLE `working_justifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workshift`
--

DROP TABLE IF EXISTS `workshift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workshift` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `workshift_pk` (`user_id`,`date`),
  CONSTRAINT `workshift_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workshift`
--

LOCK TABLES `workshift` WRITE;
/*!40000 ALTER TABLE `workshift` DISABLE KEYS */;
INSERT INTO `workshift` VALUES (1,'2024-05-10',19),(2,'2024-05-10',20);
/*!40000 ALTER TABLE `workshift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worktime`
--

DROP TABLE IF EXISTS `worktime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worktime` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrance_id` int(11) DEFAULT NULL,
  `exit_id` int(11) DEFAULT NULL,
  `workshift_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `worktime_pk` (`id`,`entrance_id`),
  UNIQUE KEY `worktime_pk_2` (`id`,`exit_id`),
  KEY `worktime_entrance_id_fk` (`entrance_id`),
  KEY `worktime_workshift_id_fk` (`workshift_id`),
  KEY `worktime_exit_id_fk` (`exit_id`),
  CONSTRAINT `worktime_entrance_id_fk` FOREIGN KEY (`entrance_id`) REFERENCES `entrance` (`id`),
  CONSTRAINT `worktime_exit_id_fk` FOREIGN KEY (`exit_id`) REFERENCES `exit` (`id`),
  CONSTRAINT `worktime_workshift_id_fk` FOREIGN KEY (`workshift_id`) REFERENCES `workshift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worktime`
--

LOCK TABLES `worktime` WRITE;
/*!40000 ALTER TABLE `worktime` DISABLE KEYS */;
INSERT INTO `worktime` VALUES (1,1,1,1),(2,2,2,1),(3,3,3,2),(4,4,4,1),(5,5,5,1),(6,6,6,1),(7,7,7,2);
/*!40000 ALTER TABLE `worktime` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-10 18:03:10

CREATE DATABASE  IF NOT EXISTS `web_dbagent` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;
USE `web_dbagent`;
-- MySQL dump 10.13  Distrib 5.6.19, for linux-glibc2.5 (x86_64)
--
-- Host: dbagent.cjehxaxuen4q.us-west-2.rds.amazonaws.com    Database: web_dbagent
-- ------------------------------------------------------
-- Server version	5.6.19-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Agencies`
--

DROP TABLE IF EXISTS `Agencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Agencies` (
  `agency_ref` varchar(8) COLLATE utf8_bin NOT NULL,
  `password` varchar(33) COLLATE utf8_bin DEFAULT NULL,
  `agency_title` varchar(30) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`agency_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Agencies`
--

LOCK TABLES `Agencies` WRITE;
/*!40000 ALTER TABLE `Agencies` DISABLE KEYS */;
INSERT INTO `Agencies` VALUES ('MJ831020','1f6fda80636fb763bef93193444b3f36',' Heisenberg Security');
/*!40000 ALTER TABLE `Agencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Agents`
--

DROP TABLE IF EXISTS `Agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Agents` (
  `agent_ref` varchar(8) COLLATE utf8_bin NOT NULL,
  `password` varchar(33) COLLATE utf8_bin DEFAULT NULL,
  `agent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`agent_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Agents`
--

LOCK TABLES `Agents` WRITE;
/*!40000 ALTER TABLE `Agents` DISABLE KEYS */;
INSERT INTO `Agents` VALUES ('SA375903','827ccb0eea8a706c4c34a16891f84e7b',1);
/*!40000 ALTER TABLE `Agents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Managers`
--

DROP TABLE IF EXISTS `Managers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Managers` (
  `manager_ref` varchar(8) COLLATE utf8_bin NOT NULL,
  `password` varchar(33) COLLATE utf8_bin DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`manager_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Managers`
--

LOCK TABLES `Managers` WRITE;
/*!40000 ALTER TABLE `Managers` DISABLE KEYS */;
INSERT INTO `Managers` VALUES ('1K2tr4jw',NULL,6),('BAvGLDd4',NULL,0),('H7jtBxaP','827ccb0eea8a706c4c34a16891f84e7b',4),('KonlG2sX',NULL,0),('Z9vwadrS',NULL,0),('ebqnigMY',NULL,0),('lUyLNwCH',NULL,0),('mTJ5MNnx',NULL,0),('snR2PpSh',NULL,0),('swHbH0Ev',NULL,0),('ujdZWWHA',NULL,0),('xgWlB7l1',NULL,20);
/*!40000 ALTER TABLE `Managers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-03-02 13:02:32
CREATE DATABASE  IF NOT EXISTS `dbagent` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;
USE `dbagent`;
-- MySQL dump 10.13  Distrib 5.6.19, for linux-glibc2.5 (x86_64)
--
-- Host: dbagent.cjehxaxuen4q.us-west-2.rds.amazonaws.com    Database: dbagent
-- ------------------------------------------------------
-- Server version	5.6.19-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ΑΞΙΟΛΟΓΗΣΕΙΣ`
--

DROP TABLE IF EXISTS `ΑΞΙΟΛΟΓΗΣΕΙΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΑΞΙΟΛΟΓΗΣΕΙΣ` (
  `ID_ΔΙΑΧΕΙΡΙΣΤΗ` int(11) NOT NULL,
  `ID_ΠΡΑΚΤΟΡΑ` int(11) NOT NULL,
  `ID_ΑΠΟΣΤΟΛΗΣ` int(11) NOT NULL,
  `ΣΧΟΛΙΟ` varchar(120) COLLATE utf8_bin DEFAULT NULL,
  `ΒΑΘΜΟΣ` float(2,1) unsigned NOT NULL,
  PRIMARY KEY (`ID_ΔΙΑΧΕΙΡΙΣΤΗ`,`ID_ΠΡΑΚΤΟΡΑ`,`ID_ΑΠΟΣΤΟΛΗΣ`),
  UNIQUE KEY `ID_ΔΙΑΧΕΙΡΙΣΤΗ_UNIQUE` (`ID_ΔΙΑΧΕΙΡΙΣΤΗ`),
  UNIQUE KEY `ID_ΠΡΑΚΤΟΡΑ_UNIQUE` (`ID_ΠΡΑΚΤΟΡΑ`),
  UNIQUE KEY `ID_ΑΠΟΣΤΟΛΗΣ_UNIQUE` (`ID_ΑΠΟΣΤΟΛΗΣ`),
  KEY `ID_ΠΡΑΚΤΟΡΑ_idx` (`ID_ΠΡΑΚΤΟΡΑ`),
  CONSTRAINT `ID_APOSTOLIS` FOREIGN KEY (`ID_ΑΠΟΣΤΟΛΗΣ`) REFERENCES `ΑΠΟΣΤΟΛΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ID_ΔΙΑΧΕΙΡΙΣΤΗ` FOREIGN KEY (`ID_ΔΙΑΧΕΙΡΙΣΤΗ`) REFERENCES `ΔΙΑΧΕΙΡΙΣΤΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ID_ΠΡΑΚΤΟΡΑ` FOREIGN KEY (`ID_ΠΡΑΚΤΟΡΑ`) REFERENCES `ΠΡΑΚΤΟΡΕΣ` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΑΞΙΟΛΟΓΗΣΕΙΣ`
--

LOCK TABLES `ΑΞΙΟΛΟΓΗΣΕΙΣ` WRITE;
/*!40000 ALTER TABLE `ΑΞΙΟΛΟΓΗΣΕΙΣ` DISABLE KEYS */;
INSERT INTO `ΑΞΙΟΛΟΓΗΣΕΙΣ` VALUES (1,1,1,'ΠΛΗΡΗΣ ΕΠΙΤΥΧΙΑ',9.3),(2,2,2,'ΠΛΗΡΗΣ ΕΠΙΤΥΧΙΑ',9.0),(3,3,3,'ΠΛΗΡΗΣ ΕΠΙΤΥΧΙΑ',9.6),(4,4,4,'ΙΚΑΝΟΠΟΙΗΤΙΚΗ ΕΠΙΤΥΧΙΑ',8.0),(5,5,5,'ΙΚΑΝΟΠΟΙΗΤΙΚΗ ΕΠΙΤΥΧΙΑ',8.5);
/*!40000 ALTER TABLE `ΑΞΙΟΛΟΓΗΣΕΙΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΑΠΟΣΤΟΛΕΣ`
--

DROP TABLE IF EXISTS `ΑΠΟΣΤΟΛΕΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΑΠΟΣΤΟΛΕΣ` (
  `ID` int(11) NOT NULL,
  `ΠΕΡΙΓΡΑΦΗ` varchar(150) COLLATE utf8_bin NOT NULL,
  `ΗΜΕΡΟΜΗΝΙΑ` date NOT NULL,
  `ΑΠΟΤΕΛΕΣΜΑ` enum('ΕΠΙΤΥΧΙΑ','ΑΠΟΤΥΧΙΑ') COLLATE utf8_bin NOT NULL,
  `ΤΙΤΛΟΣ ΕΓΚΛΗΜΑΤΟΣ` varchar(15) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_titlos_egklimatos_idx` (`ΤΙΤΛΟΣ ΕΓΚΛΗΜΑΤΟΣ`),
  CONSTRAINT `fk_titlos_egklimatos` FOREIGN KEY (`ΤΙΤΛΟΣ ΕΓΚΛΗΜΑΤΟΣ`) REFERENCES `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` (`ΟΝΟΜΑ`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΑΠΟΣΤΟΛΕΣ`
--

LOCK TABLES `ΑΠΟΣΤΟΛΕΣ` WRITE;
/*!40000 ALTER TABLE `ΑΠΟΣΤΟΛΕΣ` DISABLE KEYS */;
INSERT INTO `ΑΠΟΣΤΟΛΕΣ` VALUES (1,'ΚΙΝΕΖΙΚΗ ΠΡΕΣΒΕΙΑ','1999-12-31','ΕΠΙΤΥΧΙΑ','ΕΜΠ. ΟΠΛΩΝ'),(2,'ΑΠΑΓΩΓΗ Κ.Χ','2003-04-25','ΕΠΙΤΥΧΙΑ','ΑΠΑΓΩΓΗ'),(3,'ΔΟΛΟΦΟΝΙΑ Π.Μ.','2014-08-04','ΑΠΟΤΥΧΙΑ','ΔΟΛΟΦΟΝΙΑ'),(4,'ΤΡΟΜΟΚΡΑΤΙΚΗ ΕΠΙΘΕΣΗ ΠΑΡΙΣΙ 1','2000-02-28','ΕΠΙΤΥΧΙΑ','ΔΟΛΟΦΟΝΙΑ'),(5,'ΑΠΑΓΩΓΗ Ε.Τ.','2009-01-11','ΕΠΙΤΥΧΙΑ','ΑΠΑΓΩΓΗ');
/*!40000 ALTER TABLE `ΑΠΟΣΤΟΛΕΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ`
--

DROP TABLE IF EXISTS `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ` (
  `ID_ΑΠΟΣΤΟΛΗΣ` int(11) NOT NULL,
  `ID_ΕΓΚΛΗΜΑΤΙΑ` int(11) NOT NULL,
  PRIMARY KEY (`ID_ΑΠΟΣΤΟΛΗΣ`,`ID_ΕΓΚΛΗΜΑΤΙΑ`),
  KEY `fk_id_egklimatia1_idx` (`ID_ΕΓΚΛΗΜΑΤΙΑ`),
  CONSTRAINT `fk_id_apostolis1` FOREIGN KEY (`ID_ΑΠΟΣΤΟΛΗΣ`) REFERENCES `ΑΠΟΣΤΟΛΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_id_egklimatia1` FOREIGN KEY (`ID_ΕΓΚΛΗΜΑΤΙΑ`) REFERENCES `ΕΓΚΛΗΜΑΤΙΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ`
--

LOCK TABLES `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ` WRITE;
/*!40000 ALTER TABLE `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ` DISABLE KEYS */;
INSERT INTO `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ` VALUES (2,2),(1,3),(4,3),(3,4),(5,5);
/*!40000 ALTER TABLE `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΚΕΣ_ΟΡΓΑΝΩΣΕΙΣ`
--

DROP TABLE IF EXISTS `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΚΕΣ_ΟΡΓΑΝΩΣΕΙΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΚΕΣ_ΟΡΓΑΝΩΣΕΙΣ` (
  `ID_ΑΠΟΣΤΟΛΗΣ` int(11) NOT NULL,
  `ΕΓΚΛ_ΟΡΓ` varchar(30) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID_ΑΠΟΣΤΟΛΗΣ`,`ΕΓΚΛ_ΟΡΓ`),
  KEY `fk_egklorg_idx` (`ΕΓΚΛ_ΟΡΓ`),
  CONSTRAINT `fk_egklorg` FOREIGN KEY (`ΕΓΚΛ_ΟΡΓ`) REFERENCES `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` (`ΤΙΤΛΟΣ`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_id_apostolis2` FOREIGN KEY (`ID_ΑΠΟΣΤΟΛΗΣ`) REFERENCES `ΑΠΟΣΤΟΛΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΚΕΣ_ΟΡΓΑΝΩΣΕΙΣ`
--

LOCK TABLES `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΚΕΣ_ΟΡΓΑΝΩΣΕΙΣ` WRITE;
/*!40000 ALTER TABLE `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΚΕΣ_ΟΡΓΑΝΩΣΕΙΣ` DISABLE KEYS */;
INSERT INTO `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΚΕΣ_ΟΡΓΑΝΩΣΕΙΣ` VALUES (4,'18th street gang'),(5,'BLACK DRAGONS'),(2,'FOUR SEAS GANG'),(3,'LOS ZETAS'),(1,'SUR 13');
/*!40000 ALTER TABLE `ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΚΕΣ_ΟΡΓΑΝΩΣΕΙΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΔΙΑΧΕΙΡΙΣΤΕΣ`
--

DROP TABLE IF EXISTS `ΔΙΑΧΕΙΡΙΣΤΕΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΔΙΑΧΕΙΡΙΣΤΕΣ` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ΟΝΟΜΑ` varchar(50) COLLATE utf8_bin NOT NULL,
  `ΦΥΛΟ` enum('ΑΝΔΡΑΣ','ΓΥΝΑΙΚΑ') COLLATE utf8_bin NOT NULL,
  `ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ` varchar(30) COLLATE utf8_bin NOT NULL,
  `ΗΛΙΚΙΑ` tinyint(3) unsigned NOT NULL,
  `ΚΑΤΑΣΤΑΣΗ` enum('ΔΙΑΘΕΣΙΜΟΣ','ΠΛΗΡΩΣ_ΑΠΑΣΧΟΛΗΜΕΝΟΣ','ΣΕ_ΑΔΕΙΑ','ΑΠΟΣΤΟΛΗ_ΕΞΩΤΕΡΙΚΟ') COLLATE utf8_bin NOT NULL,
  `ΑΞΙΩΜΑ` enum('ΑΡΧΗΓΟΣ_ΓΡΑΦΕΙΟΥ_ΠΛΗΡΟΦΟΡΙΩΝ','ΑΡΧΗΓΟΣ_ΓΡΑΦΕΙΟΥ_ΣΤΡΑΤΗΓΙΚΗΣ','ΓΕΝΙΚΟΣ_ΕΠΙΘΕΩΡΗΤΗΣ','ΕΠΙΚΟΥΡΙΚΟΣ ΣΥΝΕΡΓΑΤΗΣ') COLLATE utf8_bin NOT NULL,
  `ΧΡΟΝΙΑ_ΕΜΠΕΙΡΙΑΣ` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `TITLOS_idx` (`ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ`),
  CONSTRAINT `TITLOS` FOREIGN KEY (`ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ`) REFERENCES `ΥΠΗΡΕΣΙΕΣ` (`ΤΙΤΛΟΣ`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΔΙΑΧΕΙΡΙΣΤΕΣ`
--

LOCK TABLES `ΔΙΑΧΕΙΡΙΣΤΕΣ` WRITE;
/*!40000 ALTER TABLE `ΔΙΑΧΕΙΡΙΣΤΕΣ` DISABLE KEYS */;
INSERT INTO `ΔΙΑΧΕΙΡΙΣΤΕΣ` VALUES (1,' Peter Pierce','ΑΝΔΡΑΣ','CIA',59,'ΣΕ_ΑΔΕΙΑ','ΓΕΝΙΚΟΣ_ΕΠΙΘΕΩΡΗΤΗΣ',21),(2,' Kostas Sideris','ΑΝΔΡΑΣ',' Sideris Security',54,'ΔΙΑΘΕΣΙΜΟΣ','ΑΡΧΗΓΟΣ_ΓΡΑΦΕΙΟΥ_ΠΛΗΡΟΦΟΡΙΩΝ',21),(3,' Daryl Dixon','ΑΝΔΡΑΣ',' Blackman Detective Services',45,'ΑΠΟΣΤΟΛΗ_ΕΞΩΤΕΡΙΚΟ','ΑΡΧΗΓΟΣ_ΓΡΑΦΕΙΟΥ_ΣΤΡΑΤΗΓΙΚΗΣ',20),(4,' Wolfgang Heisenberg','ΑΝΔΡΑΣ',' Heisenberg Security',65,'ΔΙΑΘΕΣΙΜΟΣ','ΑΡΧΗΓΟΣ_ΓΡΑΦΕΙΟΥ_ΠΛΗΡΟΦΟΡΙΩΝ',32),(5,' Bill Zaxos','ΑΝΔΡΑΣ','FBI',61,'ΣΕ_ΑΔΕΙΑ','ΓΕΝΙΚΟΣ_ΕΠΙΘΕΩΡΗΤΗΣ',30);
/*!40000 ALTER TABLE `ΔΙΑΧΕΙΡΙΣΤΕΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΕΓΚΛΗΜΑΤΙΕΣ`
--

DROP TABLE IF EXISTS `ΕΓΚΛΗΜΑΤΙΕΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΕΓΚΛΗΜΑΤΙΕΣ` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ΟΝΟΜΑ` varchar(30) COLLATE utf8_bin NOT NULL,
  `ΦΥΛΟ` enum('ΑΝΔΡΑΣ','ΓΥΝΑΙΚΑ') COLLATE utf8_bin NOT NULL,
  `ΗΛΙΚΙΑ` tinyint(2) unsigned NOT NULL,
  `ΒΑΘΜΟΣ ΕΠΙΚΙΝΔΥΝΟΤΗΤΑΣ` tinyint(2) unsigned NOT NULL,
  `ΤΙΤΛΟΣ_ΕΓΚΛ_ΟΡΓ` varchar(30) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk1_egkl_org_idx` (`ΤΙΤΛΟΣ_ΕΓΚΛ_ΟΡΓ`),
  CONSTRAINT `fk1_egkl_org` FOREIGN KEY (`ΤΙΤΛΟΣ_ΕΓΚΛ_ΟΡΓ`) REFERENCES `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` (`ΤΙΤΛΟΣ`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΕΓΚΛΗΜΑΤΙΕΣ`
--

LOCK TABLES `ΕΓΚΛΗΜΑΤΙΕΣ` WRITE;
/*!40000 ALTER TABLE `ΕΓΚΛΗΜΑΤΙΕΣ` DISABLE KEYS */;
INSERT INTO `ΕΓΚΛΗΜΑΤΙΕΣ` VALUES (1,'Marco Sulic','ΑΝΔΡΑΣ',28,9,'LOS ZETAS'),(2,'Juan Rodriguez','ΑΝΔΡΑΣ',36,7,'18th street gang'),(3,'ΣΤΟΛΑΣ ΣΩΤΗΡΗΣ','ΑΝΔΡΑΣ',31,7,'FOUR SEAS GANG'),(4,'XIAO CHUN','ΑΝΔΡΑΣ',42,8,'BLACK DRAGONS'),(5,'JAVIER TARREGA','ΑΝΔΡΑΣ',40,8,'SUR 13');
/*!40000 ALTER TABLE `ΕΓΚΛΗΜΑΤΙΕΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ`
--

DROP TABLE IF EXISTS `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` (
  `ΤΙΤΛΟΣ` varchar(30) COLLATE utf8_bin NOT NULL,
  `ΤΟΠΟΣ ΒΑΣΗΣ` varchar(30) COLLATE utf8_bin NOT NULL,
  `ΑΡΙΘΜΟΣ ΜΕΛΩΝ` int(10) unsigned NOT NULL,
  `ΒΑΘΜΟΣ ΕΠΙΚΙΝΔΥΝΟΤΗΤΑΣ` tinyint(2) unsigned NOT NULL,
  `ΑΡΧΗΓΟΣ` int(11) DEFAULT NULL,
  PRIMARY KEY (`ΤΙΤΛΟΣ`),
  KEY `fk1_arxigos_idx` (`ΑΡΧΗΓΟΣ`),
  CONSTRAINT `fk1_arxigos` FOREIGN KEY (`ΑΡΧΗΓΟΣ`) REFERENCES `ΕΓΚΛΗΜΑΤΙΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ`
--

LOCK TABLES `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` WRITE;
/*!40000 ALTER TABLE `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` DISABLE KEYS */;
INSERT INTO `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` VALUES ('18th street gang','ΙΤΑΛΙΑ',8,8,2),('BLACK DRAGONS','ΚΙΝΑ',21,8,NULL),('FOUR SEAS GANG','ΕΛΛΑΔΑ',9,6,NULL),('LOS ZETAS','ΜΕΞΙΚΟ',14,9,4),('SUR 13','ΙΣΠΑΝΙΑ',13,7,NULL);
/*!40000 ALTER TABLE `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΕΙΔΙΚΕΥΣΗ_ΕΓΚΛΗΜΑΤΙΩΝ`
--

DROP TABLE IF EXISTS `ΕΙΔΙΚΕΥΣΗ_ΕΓΚΛΗΜΑΤΙΩΝ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΕΙΔΙΚΕΥΣΗ_ΕΓΚΛΗΜΑΤΙΩΝ` (
  `ID_ΕΓΚΛΗΜΑΤΙΑ` int(11) NOT NULL,
  `ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ` varchar(15) COLLATE utf8_bin NOT NULL,
  `ΠΕΡΙΓΡΑΦΗ` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `ΕΜΠΕΙΡΙΑ` tinyint(2) unsigned NOT NULL,
  `ΒΑΘΜΟΣ_ΕΠΙΚΙΝΔΥΝΟΤΗΤΑΣ` float(2,1) unsigned NOT NULL,
  PRIMARY KEY (`ID_ΕΓΚΛΗΜΑΤΙΑ`,`ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ`),
  KEY `fk_onoma_egkl_idx` (`ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ`),
  CONSTRAINT `fk_id_egklimatia` FOREIGN KEY (`ID_ΕΓΚΛΗΜΑΤΙΑ`) REFERENCES `ΕΓΚΛΗΜΑΤΙΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_onoma_egkl` FOREIGN KEY (`ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ`) REFERENCES `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` (`ΟΝΟΜΑ`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΕΙΔΙΚΕΥΣΗ_ΕΓΚΛΗΜΑΤΙΩΝ`
--

LOCK TABLES `ΕΙΔΙΚΕΥΣΗ_ΕΓΚΛΗΜΑΤΙΩΝ` WRITE;
/*!40000 ALTER TABLE `ΕΙΔΙΚΕΥΣΗ_ΕΓΚΛΗΜΑΤΙΩΝ` DISABLE KEYS */;
INSERT INTO `ΕΙΔΙΚΕΥΣΗ_ΕΓΚΛΗΜΑΤΙΩΝ` VALUES (1,'ΗΛ. ΕΓΚΛΗΜΑ',NULL,19,9.5),(2,'ΑΠΑΓΩΓΗ',NULL,11,9.2),(2,'ΕΜΠ. Λ. ΣΑΡΚΟΣ',NULL,11,9.1),(3,'ΕΜΠ. ΝΑΡΚΩΤΙΚΩΝ',NULL,15,8.0),(3,'ΕΜΠ. ΟΠΛΩΝ',NULL,15,8.0),(4,'ΕΜΠ. ΟΠΛΩΝ',NULL,24,9.0),(5,'ΕΜΠ. ΝΑΡΚΩΤΙΚΩΝ',NULL,12,8.5);
/*!40000 ALTER TABLE `ΕΙΔΙΚΕΥΣΗ_ΕΓΚΛΗΜΑΤΙΩΝ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΕΣ`
--

DROP TABLE IF EXISTS `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΕΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΕΣ` (
  `ΟΝΟΜΑ ΕΓΚΛΗΜΑΤΟΣ` varchar(15) COLLATE utf8_bin NOT NULL,
  `ID_ΕΓΚΛΗΜΑΤΙΑ` int(11) NOT NULL,
  PRIMARY KEY (`ΟΝΟΜΑ ΕΓΚΛΗΜΑΤΟΣ`,`ID_ΕΓΚΛΗΜΑΤΙΑ`),
  KEY `fk_id_egklimatia2_idx` (`ID_ΕΓΚΛΗΜΑΤΙΑ`),
  CONSTRAINT `fk_egklima1` FOREIGN KEY (`ΟΝΟΜΑ ΕΓΚΛΗΜΑΤΟΣ`) REFERENCES `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` (`ΟΝΟΜΑ`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_id_egklimatia2` FOREIGN KEY (`ID_ΕΓΚΛΗΜΑΤΙΑ`) REFERENCES `ΕΓΚΛΗΜΑΤΙΕΣ` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΕΣ`
--

LOCK TABLES `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΕΣ` WRITE;
/*!40000 ALTER TABLE `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΕΣ` DISABLE KEYS */;
INSERT INTO `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΕΣ` VALUES ('ΑΠΑΓΩΓΗ',1),('ΗΛ. ΕΓΚΛΗΜΑ',1),('ΕΜΠ. Λ. ΣΑΡΚΟΣ',2),('ΠΑΡ. ΠΡΟΣΤΑΣΙΑΣ',2),('ΕΜΠ. ΝΑΡΚΩΤΙΚΩΝ',3),('ΕΜΠ. ΟΠΛΩΝ',4),('ΕΜΠ. ΝΑΡΚΩΤΙΚΩΝ',5);
/*!40000 ALTER TABLE `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΕΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ`
--

DROP TABLE IF EXISTS `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` (
  `ΟΝΟΜΑ ΕΓΚΛΗΜΑΤΟΣ` varchar(15) COLLATE utf8_bin NOT NULL,
  `ΕΓΚΛ_ΟΡΓΑΝΩΣΗ` varchar(30) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ΟΝΟΜΑ ΕΓΚΛΗΜΑΤΟΣ`,`ΕΓΚΛ_ΟΡΓΑΝΩΣΗ`),
  KEY `fk_onoma_egklimatikis_idx` (`ΕΓΚΛ_ΟΡΓΑΝΩΣΗ`),
  CONSTRAINT `fk_onoma_egklimatikis` FOREIGN KEY (`ΕΓΚΛ_ΟΡΓΑΝΩΣΗ`) REFERENCES `ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` (`ΤΙΤΛΟΣ`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_onoma_egklimatos` FOREIGN KEY (`ΟΝΟΜΑ ΕΓΚΛΗΜΑΤΟΣ`) REFERENCES `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` (`ΟΝΟΜΑ`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ`
--

LOCK TABLES `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` WRITE;
/*!40000 ALTER TABLE `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` DISABLE KEYS */;
INSERT INTO `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` VALUES ('ΔΟΛΟΦΟΝΙΑ','18th street gang'),('ΗΛ. ΕΓΚΛΗΜΑ','BLACK DRAGONS'),('ΑΠΑΓΩΓΗ','FOUR SEAS GANG'),('ΕΜΠ. Λ. ΣΑΡΚΟΣ','FOUR SEAS GANG'),('ΔΟΛΟΦΟΝΙΑ','LOS ZETAS'),('ΕΜΠ. ΟΠΛΩΝ','SUR 13'),('ΛΗΣΤΕΙΑ','SUR 13');
/*!40000 ALTER TABLE `ΕΙΔΟΣ_ΕΓΚΛΗΜΑΤΟΣ_ΕΓΚΛΗΜΑΤΙΚΗ_ΟΡΓΑΝΩΣΗ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ειδίκευση_Πρακτόρων`
--

DROP TABLE IF EXISTS `Ειδίκευση_Πρακτόρων`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ειδίκευση_Πρακτόρων` (
  `ID_ΠΡΑΚΤΟΡΑ` int(11) NOT NULL,
  `ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ` varchar(15) COLLATE utf8_bin NOT NULL,
  `ΠΕΡΙΓΡΑΦΗ` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `ΕΜΠΕΙΡΙΑ` tinyint(4) NOT NULL COMMENT '1-80',
  `ΑΞΙΟΛΟΓΗΣΗ` float NOT NULL COMMENT '1-10',
  PRIMARY KEY (`ID_ΠΡΑΚΤΟΡΑ`,`ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ`),
  KEY `fk_onoma_egkl_idx` (`ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ`),
  CONSTRAINT `fk_crime_name` FOREIGN KEY (`ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ`) REFERENCES `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` (`ΟΝΟΜΑ`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_id_praktora` FOREIGN KEY (`ID_ΠΡΑΚΤΟΡΑ`) REFERENCES `ΠΡΑΚΤΟΡΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ειδίκευση_Πρακτόρων`
--

LOCK TABLES `Ειδίκευση_Πρακτόρων` WRITE;
/*!40000 ALTER TABLE `Ειδίκευση_Πρακτόρων` DISABLE KEYS */;
INSERT INTO `Ειδίκευση_Πρακτόρων` VALUES (1,'ΗΛ. ΕΓΚΛΗΜΑ',NULL,19,9.5),(2,'ΑΠΑΓΩΓΗ',NULL,11,9.1),(2,'ΕΜΠ. Λ. ΣΑΡΚΟΣ',NULL,11,9.1),(4,'ΕΜΠ. ΟΠΛΩΝ',NULL,24,9),(5,'ΕΜΠ. ΝΑΡΚΩΤΙΚΩΝ',NULL,12,8.5);
/*!40000 ALTER TABLE `Ειδίκευση_Πρακτόρων` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Εκπαίδευση_Πρακτόρων`
--

DROP TABLE IF EXISTS `Εκπαίδευση_Πρακτόρων`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Εκπαίδευση_Πρακτόρων` (
  `ID` int(11) NOT NULL,
  `ΠΕΡΙΓΡΑΦΗ` varchar(120) COLLATE utf8_bin NOT NULL,
  `ΤΟΠΟΣ` varchar(25) COLLATE utf8_bin NOT NULL,
  `ΔΙΑΡΚΕΙΑ` tinyint(4) NOT NULL COMMENT 'months',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Εκπαίδευση_Πρακτόρων`
--

LOCK TABLES `Εκπαίδευση_Πρακτόρων` WRITE;
/*!40000 ALTER TABLE `Εκπαίδευση_Πρακτόρων` DISABLE KEYS */;
INSERT INTO `Εκπαίδευση_Πρακτόρων` VALUES (1,'\r\nΕκπαίδευση   σε πολεμικές τέχνες: Judo, Tae Kwon Do, Karate\r\n',' Louisiana, USA',6),(2,'\r\nΕκπαίδευση  χρήσης  βαρέων όπλων: Rocket Launcher, Όλμοι  \r\n',' Moscow, Russia',5),(3,'\r\nΕκπαίδευση για κατασκοπία: Παρατήρηση στόχου\r\n',' Hamburg,Germany',8),(4,'\r\nΕκπαίδευση  χρήσης όπλων: Πιστόλι, Περίστροφο, Πολυβόλο, Sniper Rifle\r\n',' Kentucky, USA',6),(5,'\r\nΕκπαίδευση   σε πολεμικές τέχνες: Judo, Krav Maga\r\n',' Athens, Greece',5);
/*!40000 ALTER TABLE `Εκπαίδευση_Πρακτόρων` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Οχήματα`
--

DROP TABLE IF EXISTS `Οχήματα`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Οχήματα` (
  `ΟΝΟΜΑ` varchar(20) COLLATE utf8_bin NOT NULL,
  `ΠΕΡΙΓΡΑΦΗ` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `ΤΥΠΟΣ` enum('μοτοσικλέτα','διθέσιο','τετραθέσιο','βαν') COLLATE utf8_bin NOT NULL,
  `ΤΑΧΥΤΗΤΑ` int(11) NOT NULL COMMENT 'μέγιστη, km/h',
  PRIMARY KEY (`ΟΝΟΜΑ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Οχήματα`
--

LOCK TABLES `Οχήματα` WRITE;
/*!40000 ALTER TABLE `Οχήματα` DISABLE KEYS */;
INSERT INTO `Οχήματα` VALUES ('BMW E60','4.8L V8 engine,362 hp, torque 490 Nm','τετραθέσιο',288),('Chevrolet Caprice ',' 3.8 L V6 engine, 325 hp','τετραθέσιο',267),('Dodge charger','Supercharged 6.2L SRT Hellcat V8 engine,707 horsepower,650 lb-ft of torque','τετραθέσιο',328),('Mercedes SLK 350','3.5 L V6 engine, 355 hp','διθέσιο',255),('Porsche 911 GT2',' 3.6 L supercharged engine, 450 hp ','διθέσιο',303);
/*!40000 ALTER TABLE `Οχήματα` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΟΠΛΑ`
--

DROP TABLE IF EXISTS `ΟΠΛΑ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΟΠΛΑ` (
  `ΟΝΟΜΑ` varchar(30) COLLATE utf8_bin NOT NULL,
  `ΕΙΔΟΣ` varchar(10) COLLATE utf8_bin NOT NULL,
  `ΠΕΡΙΓΡΑΦΗ` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `ΒΕΛΗΝΕΚΕΣ` float NOT NULL COMMENT 'in meters',
  `ΓΕΜΙΣΤΗΡΑΣ` tinyint(4) NOT NULL COMMENT 'χωρητικότητα',
  PRIMARY KEY (`ΟΝΟΜΑ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΟΠΛΑ`
--

LOCK TABLES `ΟΠΛΑ` WRITE;
/*!40000 ALTER TABLE `ΟΠΛΑ` DISABLE KEYS */;
INSERT INTO `ΟΠΛΑ` VALUES ('941F CHROME, 9mm JER','Πιστόλι','Ιδανικό για μακρινούς στόχους',600,17),('Colt Single Action A','Περίστοφο','Μεγάλη ακρίβεια στόχου',160,6),('GLOCK 19 GEN 4','Πιστόλι','Μεγάλη ακρίβεια στόχου',150,6),('Iver Johnson 1911A1 ','Περίστοφο','Μεγάλη ακρίβεια στόχου',160,9),('STRIKE ONE BLACK MIL','Πιστόλι','Αθόρυβο, μεγάλη εμβέλεια',800,17);
/*!40000 ALTER TABLE `ΟΠΛΑ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΥΠΗΡΕΣΙΕΣ`
--

DROP TABLE IF EXISTS `ΥΠΗΡΕΣΙΕΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΥΠΗΡΕΣΙΕΣ` (
  `ΤΙΤΛΟΣ` varchar(30) COLLATE utf8_bin NOT NULL,
  `ΕΙΔΟΣ` enum('ΔΗΜΟΣΙΑ','ΙΔΙΩΤΙΚΗ') COLLATE utf8_bin NOT NULL,
  `ΕΤΟΣ_ΙΔΡΥΣΗΣ` smallint(4) NOT NULL,
  `EMAIL` varchar(50) COLLATE utf8_bin NOT NULL,
  `ΤΗΛΕΦΩΝΟ` varchar(13) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ΤΙΤΛΟΣ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΥΠΗΡΕΣΙΕΣ`
--

LOCK TABLES `ΥΠΗΡΕΣΙΕΣ` WRITE;
/*!40000 ALTER TABLE `ΥΠΗΡΕΣΙΕΣ` DISABLE KEYS */;
INSERT INTO `ΥΠΗΡΕΣΙΕΣ` VALUES (' Blackman Detective Services','ΙΔΙΩΤΙΚΗ',1985,' blackmands@gmail.com','30-6944876250'),(' Heisenberg Security','ΙΔΙΩΤΙΚΗ',1856,' Heisenbergsec@yahoo.com','49-7418526537'),(' Sideris Security','ΙΔΙΩΤΙΚΗ',1973,' siderissec@gmail.com','30-6946894214'),('CIA','ΔΗΜΟΣΙΑ',1947,' ciagov@cia.com','7-5334820623'),('FBI','ΔΗΜΟΣΙΑ',1908,' fbisecurity@fbi.com','7-3247851049');
/*!40000 ALTER TABLE `ΥΠΗΡΕΣΙΕΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Πίνακας_Πράκτορα`
--

DROP TABLE IF EXISTS `Πίνακας_Πράκτορα`;
/*!50001 DROP VIEW IF EXISTS `Πίνακας_Πράκτορα`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `Πίνακας_Πράκτορα` AS SELECT 
 1 AS `ID`,
 1 AS `ΗΛΙΚΙΑ`,
 1 AS `ΟΝΟΜΑ`,
 1 AS `ΚΑΤΑΣΤΑΣΗ`,
 1 AS `ΦΥΛΟ`,
 1 AS `ID_ΔΙΑΧΕΙΡΙΣΤΗ`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ΠΡΑΚΤΟΡΕΣ`
--

DROP TABLE IF EXISTS `ΠΡΑΚΤΟΡΕΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΠΡΑΚΤΟΡΕΣ` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ΗΛΙΚΙΑ` tinyint(2) unsigned NOT NULL,
  `ΟΝΟΜΑ` varchar(20) COLLATE utf8_bin NOT NULL,
  `ΚΑΤΑΣΤΑΣΗ` enum('ΔΙΑΘΕΣΙΜΟΣ','ΣΕ_ΑΠΟΣΤΟΛΗ','ΤΡΑΥΜΑΤΙΑΣ','ΝΕΚΡΟΣ') COLLATE utf8_bin NOT NULL,
  `ΦΥΛΟ` enum('ΑΝΔΡΑΣ','ΓΥΝΑΙΚΑ') COLLATE utf8_bin NOT NULL,
  `ID_ΔΙΑΧΕΙΡΙΣΤΗ` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_id_diaxeiristi_idx` (`ID_ΔΙΑΧΕΙΡΙΣΤΗ`),
  CONSTRAINT `fk_id_diaxeiristi` FOREIGN KEY (`ID_ΔΙΑΧΕΙΡΙΣΤΗ`) REFERENCES `ΔΙΑΧΕΙΡΙΣΤΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΠΡΑΚΤΟΡΕΣ`
--

LOCK TABLES `ΠΡΑΚΤΟΡΕΣ` WRITE;
/*!40000 ALTER TABLE `ΠΡΑΚΤΟΡΕΣ` DISABLE KEYS */;
INSERT INTO `ΠΡΑΚΤΟΡΕΣ` VALUES (1,44,' Bill Wallace','ΣΕ_ΑΠΟΣΤΟΛΗ','ΑΝΔΡΑΣ',2),(2,32,' John Kosmides','ΤΡΑΥΜΑΤΙΑΣ','ΑΝΔΡΑΣ',2),(3,35,' Natasa Romanov','ΔΙΑΘΕΣΙΜΟΣ','ΓΥΝΑΙΚΑ',4),(4,56,' Klaus Ballack','ΔΙΑΘΕΣΙΜΟΣ','ΑΝΔΡΑΣ',3),(5,41,'Peter ','ΔΙΑΘΕΣΙΜΟΣ','ΑΝΔΡΑΣ',1);
/*!40000 ALTER TABLE `ΠΡΑΚΤΟΡΕΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ`
--

DROP TABLE IF EXISTS `ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ` (
  `ID_ΠΡΑΚΤΟΡΑ` int(11) NOT NULL,
  `ID_ΑΠΟΣΤΟΛΗΣ` int(11) NOT NULL,
  PRIMARY KEY (`ID_ΠΡΑΚΤΟΡΑ`,`ID_ΑΠΟΣΤΟΛΗΣ`),
  KEY `ΙD_ΑΠΟΣΤΟΛΗΣ2_idx` (`ID_ΑΠΟΣΤΟΛΗΣ`),
  CONSTRAINT `ΙD_ΑΠΟΣΤΟΛΗΣ2` FOREIGN KEY (`ID_ΑΠΟΣΤΟΛΗΣ`) REFERENCES `ΑΠΟΣΤΟΛΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ID_PRAKTORA2` FOREIGN KEY (`ID_ΠΡΑΚΤΟΡΑ`) REFERENCES `ΠΡΑΚΤΟΡΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ`
--

LOCK TABLES `ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ` WRITE;
/*!40000 ALTER TABLE `ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ` DISABLE KEYS */;
INSERT INTO `ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ` VALUES (4,1),(2,2),(5,3),(3,4),(2,5);
/*!40000 ALTER TABLE `ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Πράκτορας_Εκπαίδευση_Πρακτόρων`
--

DROP TABLE IF EXISTS `Πράκτορας_Εκπαίδευση_Πρακτόρων`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Πράκτορας_Εκπαίδευση_Πρακτόρων` (
  `ID_ΠΡΑΚΤΟΡΑ` int(11) NOT NULL,
  `ID_ΕΚΠΑΙΔΕΥΣΗΣ` int(11) NOT NULL,
  PRIMARY KEY (`ID_ΠΡΑΚΤΟΡΑ`,`ID_ΕΚΠΑΙΔΕΥΣΗΣ`),
  KEY `ID_ΕΚΠΑΙΔΕΥΣΗΣ_REF` (`ID_ΕΚΠΑΙΔΕΥΣΗΣ`),
  CONSTRAINT `ID_ΕΚΠΑΙΔΕΥΣΗΣ_REF` FOREIGN KEY (`ID_ΕΚΠΑΙΔΕΥΣΗΣ`) REFERENCES `Εκπαίδευση_Πρακτόρων` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ID_ΠΡΑΚΤΟΡΑ_REF3` FOREIGN KEY (`ID_ΠΡΑΚΤΟΡΑ`) REFERENCES `ΠΡΑΚΤΟΡΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Πράκτορας_Εκπαίδευση_Πρακτόρων`
--

LOCK TABLES `Πράκτορας_Εκπαίδευση_Πρακτόρων` WRITE;
/*!40000 ALTER TABLE `Πράκτορας_Εκπαίδευση_Πρακτόρων` DISABLE KEYS */;
INSERT INTO `Πράκτορας_Εκπαίδευση_Πρακτόρων` VALUES (1,1),(2,3),(5,3),(4,4),(2,5);
/*!40000 ALTER TABLE `Πράκτορας_Εκπαίδευση_Πρακτόρων` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Πράκτορας_Οχήματα`
--

DROP TABLE IF EXISTS `Πράκτορας_Οχήματα`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Πράκτορας_Οχήματα` (
  `ID_ΠΡΑΚΤΟΡΑ` int(11) NOT NULL,
  `OΝΟΜΑ_ΟΧΗΜΑΤΟΣ` varchar(20) COLLATE utf8_bin NOT NULL,
  `ΚΑΤΑΣΤΑΣΗ` enum('ΚΑΛΗ','SERVICE','ΕΚΤΟΣ_ΛΕΙΤΟΥΡΓΙΑΣ') COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID_ΠΡΑΚΤΟΡΑ`,`OΝΟΜΑ_ΟΧΗΜΑΤΟΣ`),
  KEY `OΝΟΜΑ_ΟΧΗΜΑΤΟΣ_REF2` (`OΝΟΜΑ_ΟΧΗΜΑΤΟΣ`),
  CONSTRAINT `ID_ΠΡΑΚΤΟΡΑ_REF2` FOREIGN KEY (`ID_ΠΡΑΚΤΟΡΑ`) REFERENCES `ΠΡΑΚΤΟΡΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `OΝΟΜΑ_ΟΧΗΜΑΤΟΣ_REF2` FOREIGN KEY (`OΝΟΜΑ_ΟΧΗΜΑΤΟΣ`) REFERENCES `Οχήματα` (`ΟΝΟΜΑ`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Πράκτορας_Οχήματα`
--

LOCK TABLES `Πράκτορας_Οχήματα` WRITE;
/*!40000 ALTER TABLE `Πράκτορας_Οχήματα` DISABLE KEYS */;
INSERT INTO `Πράκτορας_Οχήματα` VALUES (1,'Dodge charger','ΚΑΛΗ'),(2,'BMW E60','ΚΑΛΗ'),(3,'Mercedes SLK 350','ΚΑΛΗ'),(4,'Porsche 911 GT2','SERVICE'),(5,'BMW E60','ΚΑΛΗ');
/*!40000 ALTER TABLE `Πράκτορας_Οχήματα` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Πράκτορας_Όπλα`
--

DROP TABLE IF EXISTS `Πράκτορας_Όπλα`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Πράκτορας_Όπλα` (
  `ID_ΠΡΑΚΤΟΡΑ` int(11) NOT NULL,
  `ΟΝΟΜΑ_ΟΠΛΟΥ` varchar(20) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID_ΠΡΑΚΤΟΡΑ`,`ΟΝΟΜΑ_ΟΠΛΟΥ`),
  KEY `ΟΝΟΜΑ_ΟΠΛΟΥ` (`ΟΝΟΜΑ_ΟΠΛΟΥ`),
  CONSTRAINT `ΟΝΟΜΑ_ΟΠΛΟΥ` FOREIGN KEY (`ΟΝΟΜΑ_ΟΠΛΟΥ`) REFERENCES `ΟΠΛΑ` (`ΟΝΟΜΑ`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Πράκτορας_Όπλα_ibfk_1` FOREIGN KEY (`ID_ΠΡΑΚΤΟΡΑ`) REFERENCES `ΠΡΑΚΤΟΡΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Πράκτορας_Όπλα`
--

LOCK TABLES `Πράκτορας_Όπλα` WRITE;
/*!40000 ALTER TABLE `Πράκτορας_Όπλα` DISABLE KEYS */;
INSERT INTO `Πράκτορας_Όπλα` VALUES (3,'941F CHROME, 9mm JER'),(1,'Colt Single Action A'),(4,'GLOCK 19 GEN 4'),(2,'Iver Johnson 1911A1 '),(5,'STRIKE ONE BLACK MIL');
/*!40000 ALTER TABLE `Πράκτορας_Όπλα` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Πράκτορας_Gadgets`
--

DROP TABLE IF EXISTS `Πράκτορας_Gadgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Πράκτορας_Gadgets` (
  `ID_ΠΡΑΚΤΟΡΑ` int(11) NOT NULL,
  `ΟΝΟΜΑ_GADGET` varchar(20) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID_ΠΡΑΚΤΟΡΑ`,`ΟΝΟΜΑ_GADGET`),
  KEY `ΟΝΟΜΑ_GADGET_REF` (`ΟΝΟΜΑ_GADGET`),
  CONSTRAINT `ID_ΠΡΑΚΤΟΡΑ_REF` FOREIGN KEY (`ID_ΠΡΑΚΤΟΡΑ`) REFERENCES `ΠΡΑΚΤΟΡΕΣ` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ΟΝΟΜΑ_GADGET_REF` FOREIGN KEY (`ΟΝΟΜΑ_GADGET`) REFERENCES `Gadgets` (`ΟΝΟΜΑ`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Πράκτορας_Gadgets`
--

LOCK TABLES `Πράκτορας_Gadgets` WRITE;
/*!40000 ALTER TABLE `Πράκτορας_Gadgets` DISABLE KEYS */;
INSERT INTO `Πράκτορας_Gadgets` VALUES (2,'Audio Jammer'),(3,'Night Vision Spy Cam'),(3,'Pen Voice Recorder'),(4,'Pen Voice Recorder');
/*!40000 ALTER TABLE `Πράκτορας_Gadgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Πράκτορες_Απαγωγές`
--

DROP TABLE IF EXISTS `Πράκτορες_Απαγωγές`;
/*!50001 DROP VIEW IF EXISTS `Πράκτορες_Απαγωγές`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `Πράκτορες_Απαγωγές` AS SELECT 
 1 AS `ID`,
 1 AS `ΟΝΟΜΑ`,
 1 AS `ID_ΔΙΑΧΕΙΡΙΣΤΗ`,
 1 AS `ΠΕΡΙΓΡΑΦΗ`,
 1 AS `ΕΜΠΕΙΡΙΑ`,
 1 AS `ΑΞΙΟΛΟΓΗΣΗ`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Πράκτορες_Ενεργοί`
--

DROP TABLE IF EXISTS `Πράκτορες_Ενεργοί`;
/*!50001 DROP VIEW IF EXISTS `Πράκτορες_Ενεργοί`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `Πράκτορες_Ενεργοί` AS SELECT 
 1 AS `ID`,
 1 AS `ΟΝΟΜΑ`,
 1 AS `ΦΥΛΟ`,
 1 AS `ΗΛΙΚΙΑ`,
 1 AS `ID_ΔΙΑΧΕΙΡΙΣΤΗ`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Πράκτορες_Εξοπλισμός`
--

DROP TABLE IF EXISTS `Πράκτορες_Εξοπλισμός`;
/*!50001 DROP VIEW IF EXISTS `Πράκτορες_Εξοπλισμός`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `Πράκτορες_Εξοπλισμός` AS SELECT 
 1 AS `ID_Πράκτορα`,
 1 AS `ΟΝΟΜΑ`,
 1 AS `ΠΕΡΙΓΡΑΦΗ`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Πράκτορες_Incognito`
--

DROP TABLE IF EXISTS `Πράκτορες_Incognito`;
/*!50001 DROP VIEW IF EXISTS `Πράκτορες_Incognito`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `Πράκτορες_Incognito` AS SELECT 
 1 AS `ID`,
 1 AS `ΚΑΤΑΣΤΑΣΗ`,
 1 AS `ID_ΔΙΑΧΕΙΡΙΣΤΗ`,
 1 AS `ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ`
--

DROP TABLE IF EXISTS `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` (
  `ΟΝΟΜΑ` varchar(15) COLLATE utf8_bin NOT NULL,
  `ΠΕΡΙΓΡΑΦΗ` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `ΠΟΙΝΗ` enum('ΦΥΛΑΚΙΣΗ','ΧΡΗΜΑΤΙΚΗ') COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ΟΝΟΜΑ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ`
--

LOCK TABLES `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` WRITE;
/*!40000 ALTER TABLE `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` DISABLE KEYS */;
INSERT INTO `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` VALUES ('ΑΠΑΓΩΓΗ',NULL,'ΦΥΛΑΚΙΣΗ'),('ΔΟΛΟΦΟΝΙΑ',NULL,'ΦΥΛΑΚΙΣΗ'),('ΕΜΠ. Λ. ΣΑΡΚΟΣ','ΕΜΠΟΡΙΟ ΛΕΥΚΗΣ ΣΑΡΚΟΣ','ΦΥΛΑΚΙΣΗ'),('ΕΜΠ. ΝΑΡΚΩΤΙΚΩΝ','ΕΜΠΟΡΙΟ ΝΑΡΚΩΤΙΚΩΝ','ΦΥΛΑΚΙΣΗ'),('ΕΜΠ. ΟΠΛΩΝ','ΕΜΠΟΡΙΟ ΟΠΛΩΝ','ΦΥΛΑΚΙΣΗ'),('ΗΛ. ΕΓΚΛΗΜΑ','ΗΛΕΚΤΡΟΝΙΚΟ ΕΓΚΛΗΜΑ','ΦΥΛΑΚΙΣΗ'),('ΛΗΣΤΕΙΑ',NULL,'ΦΥΛΑΚΙΣΗ'),('ΠΑΡ. ΠΡΟΣΤΑΣΙΑΣ','ΠΑΡΟΧΗ ΠΡΟΣΤΑΣΙΑΣ','ΦΥΛΑΚΙΣΗ');
/*!40000 ALTER TABLE `ΚΑΤΗΓΟΡΙΕΣ_ΕΓΚΛΗΜΑΤΩΝ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Gadgets`
--

DROP TABLE IF EXISTS `Gadgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Gadgets` (
  `ΟΝΟΜΑ` varchar(50) COLLATE utf8_bin NOT NULL,
  `ΠΕΡΙΓΡΑΦΗ` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `ΒΑΡΟΣ` int(11) unsigned NOT NULL,
  `ΔΙΑΣΤΑΣΕΙΣ` varchar(14) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ΟΝΟΜΑ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Gadgets`
--

LOCK TABLES `Gadgets` WRITE;
/*!40000 ALTER TABLE `Gadgets` DISABLE KEYS */;
INSERT INTO `Gadgets` VALUES ('Audio Jammer','Audio Jammer is a white noise generator designed to keep your conversations private even when someone is trying to liste',100,'30'),('Car Tracking GPS Dat','the tracker sends position and speed of the car data,and time spent moving to your computer',120,'6x4x3'),('Night Vision Spy Cam','This watch delivers 1920 x 1080 lines of color resolution video at 30 frames per second. The video is captured and store',255,'25x5x1'),('Pen Voice Recorder','has a secret activation switch and a very sensitive internal microphone to capture even the faintest of sounds',30,'16x1x1');
/*!40000 ALTER TABLE `Gadgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `Πίνακας_Πράκτορα`
--

/*!50001 DROP VIEW IF EXISTS `Πίνακας_Πράκτορα`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dbagent`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Πίνακας_Πράκτορα` AS select `ΠΡΑΚΤΟΡΕΣ`.`ID` AS `ID`,`ΠΡΑΚΤΟΡΕΣ`.`ΗΛΙΚΙΑ` AS `ΗΛΙΚΙΑ`,`ΠΡΑΚΤΟΡΕΣ`.`ΟΝΟΜΑ` AS `ΟΝΟΜΑ`,`ΠΡΑΚΤΟΡΕΣ`.`ΚΑΤΑΣΤΑΣΗ` AS `ΚΑΤΑΣΤΑΣΗ`,`ΠΡΑΚΤΟΡΕΣ`.`ΦΥΛΟ` AS `ΦΥΛΟ`,`ΠΡΑΚΤΟΡΕΣ`.`ID_ΔΙΑΧΕΙΡΙΣΤΗ` AS `ID_ΔΙΑΧΕΙΡΙΣΤΗ` from `ΠΡΑΚΤΟΡΕΣ` where (`ΠΡΑΚΤΟΡΕΣ`.`ID` = 37) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Πράκτορες_Απαγωγές`
--

/*!50001 DROP VIEW IF EXISTS `Πράκτορες_Απαγωγές`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dbagent`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Πράκτορες_Απαγωγές` AS select `ΠΡΑΚΤΟΡΕΣ`.`ID` AS `ID`,`ΠΡΑΚΤΟΡΕΣ`.`ΟΝΟΜΑ` AS `ΟΝΟΜΑ`,`ΠΡΑΚΤΟΡΕΣ`.`ID_ΔΙΑΧΕΙΡΙΣΤΗ` AS `ID_ΔΙΑΧΕΙΡΙΣΤΗ`,`Ειδίκευση_Πρακτόρων`.`ΠΕΡΙΓΡΑΦΗ` AS `ΠΕΡΙΓΡΑΦΗ`,`Ειδίκευση_Πρακτόρων`.`ΕΜΠΕΙΡΙΑ` AS `ΕΜΠΕΙΡΙΑ`,`Ειδίκευση_Πρακτόρων`.`ΑΞΙΟΛΟΓΗΣΗ` AS `ΑΞΙΟΛΟΓΗΣΗ` from (`ΠΡΑΚΤΟΡΕΣ` join `Ειδίκευση_Πρακτόρων`) where ((`Ειδίκευση_Πρακτόρων`.`ΟΝΟΜΑ_ΕΓΚΛΗΜΑΤΟΣ` = 'Απαγωγή') and (`Ειδίκευση_Πρακτόρων`.`ID_ΠΡΑΚΤΟΡΑ` = `ΠΡΑΚΤΟΡΕΣ`.`ID`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Πράκτορες_Ενεργοί`
--

/*!50001 DROP VIEW IF EXISTS `Πράκτορες_Ενεργοί`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dbagent`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Πράκτορες_Ενεργοί` AS select `ΠΡΑΚΤΟΡΕΣ`.`ID` AS `ID`,`ΠΡΑΚΤΟΡΕΣ`.`ΟΝΟΜΑ` AS `ΟΝΟΜΑ`,`ΠΡΑΚΤΟΡΕΣ`.`ΦΥΛΟ` AS `ΦΥΛΟ`,`ΠΡΑΚΤΟΡΕΣ`.`ΗΛΙΚΙΑ` AS `ΗΛΙΚΙΑ`,`ΠΡΑΚΤΟΡΕΣ`.`ID_ΔΙΑΧΕΙΡΙΣΤΗ` AS `ID_ΔΙΑΧΕΙΡΙΣΤΗ` from `ΠΡΑΚΤΟΡΕΣ` where (`ΠΡΑΚΤΟΡΕΣ`.`ΚΑΤΑΣΤΑΣΗ` = 'ΔΙΑΘΕΣΙΜΟΣ') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Πράκτορες_Εξοπλισμός`
--

/*!50001 DROP VIEW IF EXISTS `Πράκτορες_Εξοπλισμός`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dbagent`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Πράκτορες_Εξοπλισμός` AS (select `Πράκτορας_Gadgets`.`ID_ΠΡΑΚΤΟΡΑ` AS `ID_Πράκτορα`,`Gadgets`.`ΟΝΟΜΑ` AS `ΟΝΟΜΑ`,`Gadgets`.`ΠΕΡΙΓΡΑΦΗ` AS `ΠΕΡΙΓΡΑΦΗ` from (`Gadgets` join `Πράκτορας_Gadgets`) where (`Πράκτορας_Gadgets`.`ΟΝΟΜΑ_GADGET` = `Gadgets`.`ΟΝΟΜΑ`)) union (select `Πράκτορας_Οχήματα`.`ID_ΠΡΑΚΤΟΡΑ` AS `ID_Πράκτορα`,`Οχήματα`.`ΟΝΟΜΑ` AS `ΟΝΟΜΑ`,`Οχήματα`.`ΠΕΡΙΓΡΑΦΗ` AS `ΠΕΡΙΓΡΑΦΗ` from (`Οχήματα` join `Πράκτορας_Οχήματα`) where (`Πράκτορας_Οχήματα`.`OΝΟΜΑ_ΟΧΗΜΑΤΟΣ` = `Οχήματα`.`ΟΝΟΜΑ`)) union (select `Πράκτορας_Όπλα`.`ID_ΠΡΑΚΤΟΡΑ` AS `ID_Πράκτορα`,`ΟΠΛΑ`.`ΟΝΟΜΑ` AS `ΟΝΟΜΑ`,`ΟΠΛΑ`.`ΠΕΡΙΓΡΑΦΗ` AS `ΠΕΡΙΓΡΑΦΗ` from (`ΟΠΛΑ` join `Πράκτορας_Όπλα`) where (`Πράκτορας_Όπλα`.`ΟΝΟΜΑ_ΟΠΛΟΥ` = `ΟΠΛΑ`.`ΟΝΟΜΑ`)) order by `ID_Πράκτορα` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Πράκτορες_Incognito`
--

/*!50001 DROP VIEW IF EXISTS `Πράκτορες_Incognito`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dbagent`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `Πράκτορες_Incognito` AS select `ΠΡΑΚΤΟΡΕΣ`.`ID` AS `ID`,`ΠΡΑΚΤΟΡΕΣ`.`ΚΑΤΑΣΤΑΣΗ` AS `ΚΑΤΑΣΤΑΣΗ`,`ΠΡΑΚΤΟΡΕΣ`.`ID_ΔΙΑΧΕΙΡΙΣΤΗ` AS `ID_ΔΙΑΧΕΙΡΙΣΤΗ`,`ΔΙΑΧΕΙΡΙΣΤΕΣ`.`ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ` AS `ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ` from (`ΠΡΑΚΤΟΡΕΣ` join `ΔΙΑΧΕΙΡΙΣΤΕΣ`) where (`ΔΙΑΧΕΙΡΙΣΤΕΣ`.`ID` = `ΠΡΑΚΤΟΡΕΣ`.`ID_ΔΙΑΧΕΙΡΙΣΤΗ`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-03-02 13:03:44

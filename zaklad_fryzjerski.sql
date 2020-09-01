-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 23 Cze 2020, 15:56
-- Wersja serwera: 10.4.11-MariaDB
-- Wersja PHP: 7.4.6
Create DATABASE zaklad_fryzjerski;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `zaklad_fryzjerski`


DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `znajdzFryzjeraWSalonie` (IN `salon` INT(3))  NO SQL
SELECT * from fryzjer WHERE fryzjer.salon=salon$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `znajdzKlientaPoID` (IN `ID` INT(2))  NO SQL
SELECT * from klient where klient.id =ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `znajdzNajdrozszaUsluge` ()  NO SQL
select MAX(usluga.cena) FROM usluga$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `fryzjer`
--

CREATE TABLE `fryzjer` (
  `id` int(2) NOT NULL,
  `imie` varchar(15) DEFAULT NULL,
  `nazwisko` varchar(15) DEFAULT NULL,
  `nr_tel` varchar(12) DEFAULT NULL,
  `salon` int(3) DEFAULT NULL,
  `pensja` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `fryzjer`
--

INSERT INTO `fryzjer` (`id`, `imie`, `nazwisko`, `nr_tel`, `salon`, `pensja`) VALUES
(1, 'Damian', 'Nowak', '123456789', 1, 3000),
(2, 'Marek', 'Konrad', '987654321', 1, 3000),
(3, 'Natan ', 'Piotr', '123444567', 2, 3500),
(4, 'Dawid', 'Kowalski', '566432567', 2, 3500),
(5, 'Krystian', 'Radomski', '124098543', 2, 4000);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klient`
--

CREATE TABLE `klient` (
  `id` int(4) NOT NULL,
  `imie` varchar(15) DEFAULT NULL,
  `nazwisko` varchar(15) DEFAULT NULL,
  `nr_tel` varchar(12) DEFAULT NULL,
  `email` varchar(25) DEFAULT NULL,
  `salon` int(3) DEFAULT NULL,
  `usluga` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `klient`
--

INSERT INTO `klient` (`id`, `imie`, `nazwisko`, `nr_tel`, `email`, `salon`, `usluga`) VALUES
(1, 'Michał', 'Kowalski', '123678459', 'Michal@gamil.com', 1, 1),
(2, 'Dagmara', 'Nowak', '123123123', 'Dagmara@gmail.com', 1, 3),
(3, 'Marta', 'Kaszubska', '123905423', 'Marta@gmail.com', 2, 4),
(4, 'Wiktor', 'Bobalik', '123567332', 'Wiktor@onet.pl', 2, 7),
(5, 'Piotr ', 'Malinowski', '234576543', 'Piotr@wp.pl', 1, 1),
(6, 'Marlena', 'Święta', '123567543', 'Marlena@tlen.pl', 1, 8);

--
-- Wyzwalacze `klient`
--
DELIMITER $$
CREATE TRIGGER `akualizacja_Wpisu` AFTER UPDATE ON `klient` FOR EACH ROW INSERT INTO logs VALUES
(null,new.id,'Aktualizacja',NOW(),new.Imie,new.Nazwisko,new.email,new.nr_tel)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `nowy_Wpis` AFTER INSERT ON `klient` FOR EACH ROW INSERT INTO logs VALUES
(null,new.id,'Dodany',NOW(),new.Imie,new.Nazwisko,new.email,new.nr_tel)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `usuniety_Wpis` AFTER DELETE ON `klient` FOR EACH ROW INSERT INTO logs VALUES
(null,old.id,'Usuniety',NOW(),old.Imie,old.Nazwisko,old.email,old.nr_tel)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `logs`
--

CREATE TABLE `logs` (
  `logID` int(11) NOT NULL,
  `klientID` int(4) DEFAULT NULL,
  `akcja` varchar(30) DEFAULT NULL,
  `dataZdazenia` datetime DEFAULT NULL,
  `Imie` varchar(20) DEFAULT NULL,
  `Nazwisko` varchar(20) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  `tel` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `logs`
--

INSERT INTO `logs` (`logID`, `klientID`, `akcja`, `dataZdazenia`, `Imie`, `Nazwisko`, `email`, `tel`) VALUES
(1, 7, 'Dodany', '2020-06-23 15:50:45', 'Nowy', 'Nowy2', 'Michal@gamil.com', '123456789'),
(2, 7, 'Usuniety', '2020-06-23 15:52:39', 'Nowy', 'Nowy2', 'Michal@gamil.com', '123456789'),
(3, 6, 'Usuniety', '2020-06-23 15:54:15', 'Marlena', 'Święta', 'Marlena@tlen.pl', '123567543'),
(4, 6, 'Aktualizacja', '2020-06-23 15:54:46', 'Marlena', 'Święta', 'Marlena@tlen.pl', '123567543');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `salon`
--

CREATE TABLE `salon` (
  `id` int(3) NOT NULL,
  `miasto` varchar(30) DEFAULT NULL,
  `ulica` varchar(30) DEFAULT NULL,
  `kod_pocztowy` varchar(6) DEFAULT NULL,
  `otwarcie` int(2) DEFAULT NULL,
  `zamkniecie` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `salon`
--

INSERT INTO `salon` (`id`, `miasto`, `ulica`, `kod_pocztowy`, `otwarcie`, `zamkniecie`) VALUES
(1, 'Warszawa', 'Mokra 16/3', '02-112', 6, 22),
(2, 'Krakow', 'Szeroka 18/5C', '11-234', 8, 20);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `usluga`
--

CREATE TABLE `usluga` (
  `id` int(2) NOT NULL,
  `cena` int(3) DEFAULT NULL,
  `opis` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `usluga`
--

INSERT INTO `usluga` (`id`, `cena`, `opis`) VALUES
(1, 50, 'Strzyzenie meskie'),
(2, 100, 'farbowanie klasa wlosow A'),
(3, 150, 'farbowanie klasa wlosow B'),
(4, 200, 'farbowanie klasa wlosow C'),
(5, 150, 'Ombre'),
(6, 150, 'Sombre'),
(7, 50, 'Stylizacja (umycie,wysuszenie,ulozenie..)'),
(8, 150, 'Strzezenie Damskie');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `fryzjer`
--
ALTER TABLE `fryzjer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `salon` (`salon`);

--
-- Indeksy dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD PRIMARY KEY (`id`),
  ADD KEY `salon` (`salon`,`usluga`),
  ADD KEY `usluga` (`usluga`);

--
-- Indeksy dla tabeli `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`logID`);

--
-- Indeksy dla tabeli `salon`
--
ALTER TABLE `salon`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `usluga`
--
ALTER TABLE `usluga`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `fryzjer`
--
ALTER TABLE `fryzjer`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `klient`
--
ALTER TABLE `klient`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT dla tabeli `logs`
--
ALTER TABLE `logs`
  MODIFY `logID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `salon`
--
ALTER TABLE `salon`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `usluga`
--
ALTER TABLE `usluga`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD CONSTRAINT `klient_ibfk_1` FOREIGN KEY (`usluga`) REFERENCES `usluga` (`id`),
  ADD CONSTRAINT `klient_ibfk_2` FOREIGN KEY (`salon`) REFERENCES `salon` (`id`);

--
-- Ograniczenia dla tabeli `salon`
--
ALTER TABLE `salon`
  ADD CONSTRAINT `salon_ibfk_1` FOREIGN KEY (`id`) REFERENCES `fryzjer` (`salon`) ON UPDATE CASCADE;
COMMIT;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

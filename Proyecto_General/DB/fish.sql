-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 06, 2025 at 04:48 PM
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
-- Database: `fish`
--

-- --------------------------------------------------------

--
-- Table structure for table `compras`
--

CREATE TABLE `compras` (
  `ID` int(11) NOT NULL,
  `Usuario_ID` int(11) NOT NULL,
  `Pase_ID` int(11) NOT NULL,
  `Precio` decimal(10,2) NOT NULL,
  `Fecha_compra` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `ID` int(11) NOT NULL,
  `Nombre_Item` varchar(50) NOT NULL,
  `Precio` int(11) NOT NULL,
  `Tipo` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para los items disponibles para comprar en la tienda';

-- --------------------------------------------------------

--
-- Table structure for table `pases`
--

CREATE TABLE `pases` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Precio` decimal(10,2) NOT NULL,
  `Tipo` varchar(50) NOT NULL,
  `Fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `peces`
--

CREATE TABLE `peces` (
  `ID` int(11) NOT NULL,
  `Nombre_Pez` varchar(40) NOT NULL,
  `Calidad` varchar(40) NOT NULL,
  `Precio` int(11) NOT NULL,
  `Peso` decimal(10,0) NOT NULL,
  `Profundidad` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `ID` int(11) NOT NULL,
  `Usuario` varchar(25) NOT NULL,
  `Nombre` varchar(25) NOT NULL,
  `Contraseña` char(255) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Doblones` int(11) NOT NULL,
  `FechadeReg` datetime NOT NULL DEFAULT current_timestamp(),
  `Edad` int(11) DEFAULT NULL,
  `Genero` varchar(20) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `foto` varchar(255) NOT NULL DEFAULT '../Imagenes/PLACEHOLDER.png',
  `rol` varchar(20) NOT NULL DEFAULT 'cliente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para los usuarios registrados en FishStack';

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`ID`, `Usuario`, `Nombre`, `Contraseña`, `Email`, `Doblones`, `FechadeReg`, `Edad`, `Genero`, `Telefono`, `foto`, `rol`) VALUES
(1, 'John', 'The_Murder', '$2y$10$njYCDNDrV/qrnA3lr473i.ID9D.9qG2jQkIAdMRIm.rWwb7LfSWjW', 'papanoel@gmail.com', 0, '2025-09-03 21:59:48', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png', 'cliente'),
(2, 'MarceloPrime', 'FireNoKING', '$2y$10$WPi.NVfX3vVxDV5YEQ.PvOhqqqwq0hfqbQPsaoEdY6IQSMe1UrHO6', 'alanocamarcel@gmail.com', 0, '2025-09-03 22:02:25', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png', 'cliente'),
(3, 'Alex_morgan', 'Alexis', '$2y$10$5FngmgdEC0QlOX9zpOtqOe8ZyrhNQgTflfRGvCx1ZG9zoFeWZQq9m', 'johancuello@gmail.com', 0, '2025-09-15 23:40:15', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png', 'cliente'),
(4, 'Pancho', 'Panchito777', '$2y$10$2MC4jqq4ENqjtLt0JIvW6u9wt6C2L5V220rIfQAiCHa0l/GkqWmeu', 'mayonesa@gmail.com', 0, '2025-09-28 20:51:45', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png', 'cliente'),
(5, 'Julian', 'Alexiso5700', '$2y$10$nrKnUJW7pzyRizVp2T5h3u9BPthUEAaOmq/USb/4ixxMF/BjIHy/S', 'alexisis@gmail.com', 0, '2025-09-29 10:00:46', 16, 'aeae', '12312312', '../Imagenes/Usuarios/5_Captura de pantalla 2024-08-24 220359.png', 'cliente'),
(6, 'Martin', 'Oni-Chan', '$2y$10$nekDBrjaACKesG.ISZd7yOLH.sXc//dWmw7vAeA0d4a.BDwX6b5s.', 'Martin315@gmail.com', 0, '2025-10-06 11:07:59', 17, 'Tung tung Sahur', '11111111111', '../Imagenes/PLACEHOLDER.png', 'cliente'),
(7, 'Martin315', 'Marcos', '$2y$10$Of.2yxOtAAkvjU2pDwwImOh2TFRvGJPcj30EG3IzYtw10WKeJ/OIK', 'k.c.b.xiomara@gmail.com', 0, '2025-10-06 11:38:00', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png', 'cliente'),
(8, 'asd', 'sadsa', '$2y$10$BTfp8iS6i4lKQlE9vSiScey2ZtlQICh4qnOMX0sefVCAeDeCzEUIW', 'adsad@gmail-com', 0, '2025-10-06 11:41:22', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png', 'cliente');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Usuario_ID` (`Usuario_ID`),
  ADD KEY `Pase_ID` (`Pase_ID`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nombre_Item` (`Nombre_Item`);

--
-- Indexes for table `pases`
--
ALTER TABLE `pases`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `peces`
--
ALTER TABLE `peces`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nombre_Pez` (`Nombre_Pez`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Usuario` (`Usuario`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `compras`
--
ALTER TABLE `compras`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pases`
--
ALTER TABLE `pases`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `peces`
--
ALTER TABLE `peces`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`Usuario_ID`) REFERENCES `usuarios` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `compras_ibfk_2` FOREIGN KEY (`Pase_ID`) REFERENCES `pases` (`ID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

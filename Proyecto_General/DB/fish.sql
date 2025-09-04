-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-09-2025 a las 04:16:47
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `fish`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `items`
--

CREATE TABLE `items` (
  `ID` int(11) NOT NULL,
  `Nombre_Item` varchar(50) NOT NULL,
  `Precio` int(11) NOT NULL,
  `Tipo` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para los items disponibles para comprar en la tienda';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `peces`
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
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID` int(11) NOT NULL,
  `Usuario` varchar(25) NOT NULL,
  `Nombre` varchar(25) NOT NULL,
  `Contraseña` char(255) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Doblones` int(11) NOT NULL,
  `FechadeReg` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para los usuarios registrados en FishStack';

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID`, `Usuario`, `Nombre`, `Contraseña`, `Email`, `Doblones`, `FechadeReg`) VALUES
(1, 'John', 'The_Murder', '$2y$10$njYCDNDrV/qrnA3lr473i.ID9D.9qG2jQkIAdMRIm.rWwb7LfSWjW', 'papanoel@gmail.com', 0, '2025-09-03 21:59:48'),
(2, 'MarceloPrime', 'FireNoKING', '$2y$10$WPi.NVfX3vVxDV5YEQ.PvOhqqqwq0hfqbQPsaoEdY6IQSMe1UrHO6', 'alanocamarcel@gmail.com', 0, '2025-09-03 22:02:25');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nombre_Item` (`Nombre_Item`);

--
-- Indices de la tabla `peces`
--
ALTER TABLE `peces`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nombre_Pez` (`Nombre_Pez`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Usuario` (`Usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `items`
--
ALTER TABLE `items`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `peces`
--
ALTER TABLE `peces`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

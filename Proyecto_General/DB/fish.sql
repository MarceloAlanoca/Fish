-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 30-09-2025 a las 04:47:02
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
-- Estructura de tabla para la tabla `compras`
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
-- Estructura de tabla para la tabla `pases`
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
  `FechadeReg` datetime NOT NULL DEFAULT current_timestamp(),
  `Edad` int(11) DEFAULT NULL,
  `Genero` varchar(20) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `foto` varchar(255) NOT NULL DEFAULT '../Imagenes/PLACEHOLDER.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para los usuarios registrados en FishStack';

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID`, `Usuario`, `Nombre`, `Contraseña`, `Email`, `Doblones`, `FechadeReg`, `Edad`, `Genero`, `Telefono`, `foto`) VALUES
(1, 'John', 'The_Murder', '$2y$10$njYCDNDrV/qrnA3lr473i.ID9D.9qG2jQkIAdMRIm.rWwb7LfSWjW', 'papanoel@gmail.com', 0, '2025-09-03 21:59:48', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png'),
(2, 'MarceloPrime', 'FireNoKING', '$2y$10$WPi.NVfX3vVxDV5YEQ.PvOhqqqwq0hfqbQPsaoEdY6IQSMe1UrHO6', 'alanocamarcel@gmail.com', 0, '2025-09-03 22:02:25', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png'),
(3, 'Alex_morgan', 'Alexis', '$2y$10$5FngmgdEC0QlOX9zpOtqOe8ZyrhNQgTflfRGvCx1ZG9zoFeWZQq9m', 'johancuello@gmail.com', 0, '2025-09-15 23:40:15', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png'),
(4, 'Pancho', 'Panchito777', '$2y$10$2MC4jqq4ENqjtLt0JIvW6u9wt6C2L5V220rIfQAiCHa0l/GkqWmeu', 'mayonesa@gmail.com', 0, '2025-09-28 20:51:45', NULL, NULL, NULL, '../Imagenes/PLACEHOLDER.png'),
(5, 'Julian', 'Alexiso5700', '$2y$10$nrKnUJW7pzyRizVp2T5h3u9BPthUEAaOmq/USb/4ixxMF/BjIHy/S', 'alexisis@gmail.com', 0, '2025-09-29 10:00:46', 16, 'aeae', '12312312', '../Imagenes/Usuarios/5_Captura de pantalla 2024-08-24 220359.png');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `Usuario_ID` (`Usuario_ID`),
  ADD KEY `Pase_ID` (`Pase_ID`);

--
-- Indices de la tabla `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Nombre_Item` (`Nombre_Item`);

--
-- Indices de la tabla `pases`
--
ALTER TABLE `pases`
  ADD PRIMARY KEY (`ID`);

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
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `items`
--
ALTER TABLE `items`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pases`
--
ALTER TABLE `pases`
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
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`Usuario_ID`) REFERENCES `usuarios` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `compras_ibfk_2` FOREIGN KEY (`Pase_ID`) REFERENCES `pases` (`ID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

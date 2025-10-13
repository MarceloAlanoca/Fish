-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-10-2025 a las 15:55:42
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
-- Estructura de tabla para la tabla `comentarios`
--

CREATE TABLE `comentarios` (
  `Id_Comentario` int(11) NOT NULL,
  `Id_Update` int(11) NOT NULL,
  `Id_Usuario` int(11) NOT NULL,
  `Comentario` text NOT NULL,
  `Fecha` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Estructura de tabla para la tabla `updates`
--

CREATE TABLE `updates` (
  `Id_Update` int(11) NOT NULL,
  `Titulo` varchar(100) NOT NULL,
  `Tipo` enum('Parche','Actualización') NOT NULL,
  `Imagen` varchar(255) DEFAULT NULL,
  `Descripcion_Corta` varchar(255) NOT NULL,
  `Texto_Detallado` text NOT NULL,
  `Fecha_Publicacion` datetime DEFAULT current_timestamp(),
  `Autor_Id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `updates`
--

INSERT INTO `updates` (`Id_Update`, `Titulo`, `Tipo`, `Imagen`, `Descripcion_Corta`, `Texto_Detallado`, `Fecha_Publicacion`, `Autor_Id`) VALUES
(1, 'Parche 1.0 — Inicio de Aventura', 'Parche', '../Imagenes/Iconos/Thiago.jpg', 'Se lanza la primera versión del juego con el sistema de pesca básico.', 'En esta versión inicial se introduce el sistema de pesca principal, con peces comunes y animaciones de captura. También se agregaron sonidos ambientales y el menú principal del juego.', '2025-09-15 00:00:00', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(25) NOT NULL,
  `Usuario` varchar(25) NOT NULL,
  `Contraseña` char(255) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Doblones` int(11) NOT NULL,
  `FechadeReg` datetime NOT NULL DEFAULT current_timestamp(),
  `Edad` int(11) DEFAULT NULL,
  `Genero` varchar(20) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `foto` varchar(255) NOT NULL DEFAULT '..ImagenesIconosProfileDefault.png',
  `rol` varchar(20) NOT NULL DEFAULT 'cliente',
  `carnet` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para los usuarios registrados en FishStack';

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID`, `Nombre`, `Usuario`, `Contraseña`, `Email`, `Doblones`, `FechadeReg`, `Edad`, `Genero`, `Telefono`, `foto`, `rol`, `carnet`) VALUES
(1, 'Thiago Loaiza', 'Creeper', '$2y$10$MhLOQZHgDiv.y7N.i9xZl.PiN5pRbSOlEFUa307gjP/uC4LP1k/0i', 'thiagolosizat123@gmail.com', 0, '2025-10-13 10:42:48', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'AFEDCS'),
(2, 'Marcos', 'Firefox', '$2y$10$HRtxjP6NU0AbUL.YsvkjDO9lD1w.thOFXMAkS0oE8ivTaOQXJtY3i', 'elfalopade2024@gmail.com', 0, '2025-10-13 10:44:58', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'QWERTY'),
(3, 'p3dql', 'p3dql', '$2y$10$tlKij9S1UOhK0N3DOLj8BOt87/aOQ/dAiVyEeaT.P.4qrwIVz.wyi', 'pedroleone.hall@gmail.com', 0, '2025-10-13 10:45:37', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'ZXCVBN'),
(4, 'Kanshane', 'KanshaneSPONT', '$2y$10$7kk89dJ2R47xbmDOrZBgYeGrOseplBRmEQ281UCYuT/lO0V5.Xu1G', 'john.heber.huallpa.cisneros09@gmail.com', 0, '2025-10-13 10:46:48', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'PLMOKN'),
(5, 'mocoatomico', 'lautarolg', '$2y$10$iOgIwnxvBaBbW1Pe9GKDi.QHSvwbbuPLFi.RV1vxciO7k63/6EWU2', 'lautaronavarro1818@gmail.com', 0, '2025-10-13 10:47:16', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'HGFDSA'),
(6, 'alejandrach', 'alejandra ', '$2y$10$MGnTk8lVr0Ij8gs2DnZBg.2o5KtvAFb5wm5B/fTNY/DtL43W6Bv7e', 'alejandrachavezu9@gmail.com', 0, '2025-10-13 10:48:00', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'NBVCXZ'),
(7, 'leather', 'gaelggv', '$2y$10$lOLDD18C5tePR1.PagbrtuySbw/IN8C0uWRBDrOCHpVkmwqmGq3gm', 'gaelestrada1979@gmail.com', 0, '2025-10-13 10:48:25', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'LKJHGF');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`Id_Comentario`),
  ADD KEY `Id_Update` (`Id_Update`),
  ADD KEY `Id_Usuario` (`Id_Usuario`);

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
-- Indices de la tabla `updates`
--
ALTER TABLE `updates`
  ADD PRIMARY KEY (`Id_Update`),
  ADD KEY `Autor_Id` (`Autor_Id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Usuario` (`Nombre`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `Id_Comentario` int(11) NOT NULL AUTO_INCREMENT;

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
-- AUTO_INCREMENT de la tabla `updates`
--
ALTER TABLE `updates`
  MODIFY `Id_Update` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `comentarios_ibfk_1` FOREIGN KEY (`Id_Update`) REFERENCES `updates` (`Id_Update`) ON DELETE CASCADE,
  ADD CONSTRAINT `comentarios_ibfk_2` FOREIGN KEY (`Id_Usuario`) REFERENCES `usuarios` (`ID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`Usuario_ID`) REFERENCES `usuarios` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `compras_ibfk_2` FOREIGN KEY (`Pase_ID`) REFERENCES `pases` (`ID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `updates`
--
ALTER TABLE `updates`
  ADD CONSTRAINT `updates_ibfk_1` FOREIGN KEY (`Autor_Id`) REFERENCES `usuarios` (`ID`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

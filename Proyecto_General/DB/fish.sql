-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-11-2025 a las 05:08:56
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

--
-- Volcado de datos para la tabla `comentarios`
--

INSERT INTO `comentarios` (`Id_Comentario`, `Id_Update`, `Id_Usuario`, `Comentario`, `Fecha`) VALUES
(2, 4, 1, 'Fa mejor nadota', '2025-10-20 22:59:49');

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

--
-- Volcado de datos para la tabla `compras`
--

INSERT INTO `compras` (`ID`, `Usuario_ID`, `Pase_ID`, `Precio`, `Fecha_compra`) VALUES
(1, 1, 1, 15000.00, '2025-10-27 23:21:28'),
(2, 1, 1, 15000.00, '2025-10-27 23:28:10'),
(3, 1, 2, 10000.00, '2025-10-27 23:37:47'),
(4, 17, 2, 10000.00, '2025-11-25 03:59:29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gamedata`
--

CREATE TABLE `gamedata` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `doblones` int(11) DEFAULT 0,
  `amuletos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`amuletos`)),
  `equipados` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`equipados`)),
  `canas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`canas`)),
  `cana_equipada` varchar(100) DEFAULT NULL,
  `barcos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`barcos`)),
  `barco_equipado` varchar(100) DEFAULT NULL,
  `skins` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`skins`)),
  `skin_equipada` varchar(100) DEFAULT NULL,
  `alineaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`alineaciones`)),
  `alineacion_equipada` varchar(100) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
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
  `Fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `Foto` varchar(255) DEFAULT NULL,
  `texto_descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pases`
--

INSERT INTO `pases` (`ID`, `Nombre`, `Precio`, `Tipo`, `Fecha_creacion`, `Foto`, `texto_descripcion`) VALUES
(1, 'PASE DE PLATINO', 15000.00, 'PROGRESO', '2025-10-21 01:39:53', '68f6e46908103_68f6e4048e9ae_PlatinoPass.png', '¡Pescador, este es el Pase de Platino de FishStack!  \r\nPensado para quienes quieren dejar de ser principiantes y empezar a jugar en ligas mayores.  \r\nCon este pase obtendrás un paquete de ventajas pensadas para farmear más, llegar más profundo y lucirte como una verdadera leyenda del mar.\r\n\r\n────────────────────────────────────────────\r\n💰 25.000 Doblones Iniciales\r\n────────────────────────────────────────────\r\nRecibe un impulso económico masivo con **25.000 doblones** listos para usar como quieras desde el primer minuto:\r\n• Comprar cañas avanzadas y equipo extra  \r\n• Adquirir múltiples amuletos y combinarlos  \r\n• Invertir en anzuelos y mejoras premium  \r\n• Optimizar tu barco o guardar para futuras actualizaciones  \r\n• Probar contenido sin necesidad de farmear durante horas\r\n\r\nEste monto inicial te permite saltarte la etapa más lenta del progreso y enfocarte en lo divertido: explorar, probar builds y capturar peces cada vez más raros.\r\n\r\n────────────────────────────────────────────\r\n🎣 Caña Dorada – Doble Recompensa y 5000 m de Profundidad\r\n────────────────────────────────────────────\r\nEquipa la exclusiva **Caña Dorada de Platino**, una herramienta pensada para pescadores que buscan eficiencia máxima:\r\n• Profundidad de hasta **5000 metros**  \r\n• Capacidad de **duplicar el valor de lo que pesques** (x2 en tus capturas)  \r\n\r\nCon esta caña podrás llegar a zonas ultra profundas, encontrar especies únicas y, al mismo tiempo, multiplicar tus ganancias en cada salida de pesca. Ideal para jugadores que quieren sacar el máximo provecho de cada inmersión.\r\n\r\n────────────────────────────────────────────\r\n🟡 Skin Dorada de George\r\n────────────────────────────────────────────\r\nDesbloquea una **skin dorada exclusiva para George**, tu pescador.  \r\nNo solo demuestra tu estatus de jugador platino, sino que convierte a George en una verdadera celebridad del muelle:\r\n• Apariencia totalmente renovada  \r\n• Estilo dorado brillante, único y reconocible  \r\n• Skin permanente vinculada a tu cuenta\r\n\r\nPerfecta para destacar en cada captura, en cada pantalla y en cada captura de pantalla.\r\n\r\n────────────────────────────────────────────\r\n💀 Amuleto Calavera – Ganancia Automática del 8%\r\n────────────────────────────────────────────\r\nIncluye el poderoso **Amuleto Calavera**, un objeto especial que premia cada pique con ganancias automáticas:\r\n• Cada vez que pique un pez, ganas **un 8% de su valor automáticamente**  \r\n• Funciona como un “bonus pasivo” constante mientras pescás  \r\n• Ideal para farmear mientras explorás, pruebas rutas o simplemente disfrutás del juego\r\n\r\nEste amuleto convierte cada intento en progreso real, incluso cuando la captura no es perfecta.\r\n\r\n────────────────────────────────────────────\r\n🌊 El Pase para Dominar el Mar\r\n────────────────────────────────────────────\r\nEl Pase de Platino es la elección perfecta para los jugadores que quieren ir más allá de un simple inicio fuerte y apuntan a dominar FishStack a largo plazo:\r\n• Mucho más valor de juego que su costo  \r\n• Progreso acelerado gracias a la Caña Dorada  \r\n• Estilo único con la Skin Dorada de George  \r\n• Ingreso pasivo con el Amuleto Calavera  \r\n• 25.000 doblones para montar tu propia estrategia desde el minuto uno\r\n\r\nSi querés avanzar rápido, ganar más y lucir como un verdadero veterano del océano, el Pase de Platino es tu siguiente paso.\r\n'),
(2, 'PASE DE BIENVENIDA', 10000.00, 'PROGRESO', '2025-10-27 00:54:26', '68fec2c2a16fd_WelcomePass.png', '¡Bienvenido pescador!  \r\nEste Pase de Bienvenida fue diseñado especialmente para los aventureros que quieren comenzar su viaje con la mejor ventaja posible.  \r\nCon este pase obtendrás un conjunto de recompensas premium que acelerarán tu progreso desde el primer lanzamiento de caña.\r\n\r\n────────────────────────────────────────────\r\n🎣 Caña de Profundidad Extrema – 3500 metros\r\n────────────────────────────────────────────\r\nEquipa una caña exclusiva capaz de llegar hasta los 3500 metros bajo la superficie.  \r\nEsto te permitirá acceder a zonas profundas desde el inicio, capturar peces raros mucho antes de tiempo y desbloquear rutas que otros jugadores deberán esperar semanas para explorar.  \r\nComparada con la caña tier 2 estándar, esta caña tiene un **20% más de potencia y eficiencia**, lo que se traduce en una mejor velocidad de captura, mayor estabilidad y un rendimiento superior en todas tus expediciones.\r\n\r\n────────────────────────────────────────────\r\n💰 10.000 Doblones Iniciales\r\n────────────────────────────────────────────\r\nRecibe un impulso económico instantáneo con **10.000 doblones** listos para usar como quieras:\r\n• Comprar cañas adicionales  \r\n• Adquirir amuletos  \r\n• Comprar anzuelos premium  \r\n• Mejorar tu barco o equipo  \r\n• Probar contenido sin necesidad de farmear horas  \r\n\r\nEste monto inicial te permitirá experimentar más, progresar más rápido y disfrutar al máximo del juego desde el comienzo.\r\n\r\n────────────────────────────────────────────\r\n✨ Amuleto del Errante – Suerte Elevada\r\n────────────────────────────────────────────\r\nIncluye el mítico **Amuleto del Errante**, un objeto codiciado por su poderosa capacidad de aumentar la suerte del pescador.  \r\nCon él tendrás:\r\n• Mayor probabilidad de obtener peces raros  \r\n• Más chances de recibir cofres especiales  \r\n• Posibilidad de encontrar objetos únicos durante tus inmersiones  \r\n\r\nIdeal para jugadores que quieren destacar desde temprano y construir una colección impresionante de peces especiales.\r\n\r\n────────────────────────────────────────────\r\n🌊 Un Inicio que Vale por Tres\r\n────────────────────────────────────────────\r\nEl Pase de Bienvenida es, sin duda, la forma más inteligente de comenzar tu aventura en FishStack.  \r\nValor real muy superior al costo del pase, beneficios inmediatos, acceso adelantado al contenido y un empujón monumental en tus primeras horas de juego.');

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
(2, 'Parche 0.0.5 — Primeros pasos', 'Parche', '../Imagenes/Thumbnails/FirstPatch.png', 'Aqui empezo FishStack.', 'En FishStack seguimos trabajando con dedicación para ofrecer la mejor experiencia posible a nuestra comunidad de jugadores. En esta actualización queremos compartir con ustedes cómo estamos puliendo nuestra página web y optimizando cada detalle para que navegar, descubrir novedades y participar en nuestra comunidad sea más intuitivo y divertido.\r\n\r\nOptimización del Rendimiento:\r\nHemos realizado mejoras significativas en la carga de la página, reduciendo tiempos de espera y asegurándonos de que todo funcione de manera fluida incluso en dispositivos con menor rendimiento. La optimización del código y la estructura de los archivos nos permite ofrecer una experiencia más estable y agradable para todos los usuarios.\r\n\r\nDiseño Más Intuitivo:\r\nEstamos refinando el diseño visual de la web, con un enfoque en la claridad y la facilidad de navegación. Se han ajustado los menús, barras de navegación y botones para que los jugadores puedan acceder rápidamente a las secciones más importantes: actualizaciones del juego, su perfil, la tienda de ítems y la galería de logros. Los colores, tipografías y elementos gráficos se han armonizado para mantener el estilo pixel-art característico de FishStack.\r\n\r\nSistema de Actualizaciones Mejorado:\r\nAhora cada parche y actualización del juego cuenta con su propia sección detallada en la web. Los jugadores pueden leer toda la información relevante sobre los cambios, mejoras y correcciones de errores, acompañada de imágenes de presentación de cada parche. Estamos incorporando además un sistema para que los usuarios puedan dejar comentarios y sugerencias directamente en cada actualización, fomentando una comunicación más cercana entre el equipo de desarrollo y la comunidad.\r\n\r\nInteractividad y Contenido Dinámico:\r\nEstamos trabajando para que la página web se sienta viva y en constante movimiento, integrando elementos dinámicos como banners, anuncios de eventos y secciones interactivas donde se muestran logros, estadísticas de pesca y ranking de jugadores. Esto permite que la experiencia online refleje la diversión y el espíritu de exploración del juego FishStack.\r\n\r\nPreparación para Futuras Funcionalidades:\r\nEsta actualización también sienta las bases para nuevas funciones que pronto llegarán a la web: perfiles más completos, integración con redes sociales, mejoras en el sistema de comentarios y más contenido exclusivo para los jugadores. Cada cambio está pensado para que nuestra comunidad tenga un lugar seguro, atractivo y entretenido donde interactuar mientras disfrutan del juego.\r\n\r\nEn resumen, estamos afinando cada detalle para que FishStack no solo sea un juego de pixel y pesca emocionante, sino también una experiencia completa y atractiva en línea. ¡Gracias por acompañarnos en esta aventura y por ayudarnos a construir la mejor comunidad posible!', '2025-10-13 00:00:00', 1),
(4, 'Parche 0.0.25 — Avanzando en cosas', 'Parche', './Imagenes/Thumbnails/update_68f5bb31526b7_Captura de pantalla 2025-08-10 214348.png', 'Algunos cambios no relevantes', 'aaadadadadadad', '2025-10-20 06:31:45', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID` int(11) NOT NULL,
  `Nombre` varchar(25) NOT NULL,
  `Usuario` varchar(25) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Doblones` int(11) NOT NULL DEFAULT 0,
  `FechadeReg` datetime NOT NULL DEFAULT current_timestamp(),
  `Edad` int(11) DEFAULT NULL,
  `Genero` varchar(20) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `foto` varchar(255) NOT NULL DEFAULT '../Imagenes/Iconos/ProfileDefault.png',
  `rol` varchar(20) NOT NULL DEFAULT 'cliente',
  `carnet` varchar(6) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_expire` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para los usuarios registrados en FishStack';

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID`, `Nombre`, `Usuario`, `Password`, `Email`, `Doblones`, `FechadeReg`, `Edad`, `Genero`, `Telefono`, `foto`, `rol`, `carnet`, `reset_token`, `reset_expire`) VALUES
(1, 'Thiago Loaiza', 'Creeper', '$2y$10$3eRSyQUVikuKw3iEPrnzx.exQWlCcNHEslEOZDl9MaeE/OfmvBRvm', 'thiagolosizat123@gmail.com', 0, '2025-10-13 10:42:48', 12, 'Hombre', '1212', '../Imagenes/Usuarios/1_Captura de pantalla 2025-08-01 185124.png', 'ADMINISTRADOR', 'AFEDCS', NULL, NULL),
(2, 'Marcos', 'Firefox', '$2y$10$HRtxjP6NU0AbUL.YsvkjDO9lD1w.thOFXMAkS0oE8ivTaOQXJtY3i', 'elfalopade2024@gmail.com', 0, '2025-10-13 10:44:58', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'QWERTY', 'c28e2955b40dfcd864663ddf956eff63ac26a9d2b9c2c17fe2fe5b984c6c8d07', '2025-10-27 01:15:34'),
(3, 'p3dql', 'p3dql', '$2y$10$tlKij9S1UOhK0N3DOLj8BOt87/aOQ/dAiVyEeaT.P.4qrwIVz.wyi', 'pedroleone.hall@gmail.com', 0, '2025-10-13 10:45:37', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'ZXCVBN', NULL, NULL),
(4, 'Kanshane', 'KanshaneSPONT', '$2y$10$7kk89dJ2R47xbmDOrZBgYeGrOseplBRmEQ281UCYuT/lO0V5.Xu1G', 'john.heber.huallpa.cisneros09@gmail.com', 0, '2025-10-13 10:46:48', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'PLMOKN', NULL, NULL),
(5, 'mocoatomico', 'lautarolg', '$2y$10$iOgIwnxvBaBbW1Pe9GKDi.QHSvwbbuPLFi.RV1vxciO7k63/6EWU2', 'lautaronavarro1818@gmail.com', 0, '2025-10-13 10:47:16', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'HGFDSA', NULL, NULL),
(6, 'alejandrach', 'alejandra ', '$2y$10$MGnTk8lVr0Ij8gs2DnZBg.2o5KtvAFb5wm5B/fTNY/DtL43W6Bv7e', 'alejandrachavezu9@gmail.com', 0, '2025-10-13 10:48:00', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'NBVCXZ', NULL, NULL),
(7, 'leather', 'gaelggv', '$2y$10$lOLDD18C5tePR1.PagbrtuySbw/IN8C0uWRBDrOCHpVkmwqmGq3gm', 'gaelestrada1979@gmail.com', 0, '2025-10-13 10:48:25', NULL, NULL, NULL, '..ImagenesIconosProfileDefault.png', 'ADMINISTRADOR', 'LKJHGF', 'd70cf6199b0b3e60cbcf9d2ec916d14e4a3e02d4d531d4004bb97f55e4c55927', '2025-10-27 01:20:52'),
(17, '213', '12312', '$2y$10$ClGCLiKA0HpMAs5U8u/97uh.JGjQxqOzuczcQ4tVQ8ZF26SEcTDr2', '213@123', 0, '2025-11-25 00:52:14', NULL, NULL, NULL, '../Imagenes/Iconos/ProfileDefault.png', 'cliente', NULL, NULL, NULL),
(18, '123213', '1231231', '$2y$10$hJ9P6xzNfM/UyB3.pOhtoOAOdy9nbZfnHTUkjMIh4zVu9wPJhAyZa', '123@213', 0, '2025-11-25 01:05:32', NULL, NULL, NULL, '../Imagenes/Iconos/ProfileDefault.png', 'cliente', NULL, NULL, NULL);

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
-- Indices de la tabla `gamedata`
--
ALTER TABLE `gamedata`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

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
  MODIFY `Id_Comentario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `gamedata`
--
ALTER TABLE `gamedata`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `items`
--
ALTER TABLE `items`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pases`
--
ALTER TABLE `pases`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `peces`
--
ALTER TABLE `peces`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `updates`
--
ALTER TABLE `updates`
  MODIFY `Id_Update` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

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
-- Filtros para la tabla `gamedata`
--
ALTER TABLE `gamedata`
  ADD CONSTRAINT `gamedata_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `usuarios` (`ID`);

--
-- Filtros para la tabla `updates`
--
ALTER TABLE `updates`
  ADD CONSTRAINT `updates_ibfk_1` FOREIGN KEY (`Autor_Id`) REFERENCES `usuarios` (`ID`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

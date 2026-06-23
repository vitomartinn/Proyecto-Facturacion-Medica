-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-06-2026 a las 02:05:27
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
-- Base de datos: `facturacion_medica`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerFacturaPaciente` (IN `p_ID_Paciente` INT)   BEGIN
    SELECT
        P.Nombre            AS Paciente,
        M.Nombre            AS Medico,
        M.Especialidad,
        F.ID_Factura,
        COALESCE(MED.Nombre, 'Sin medicamento') AS Medicamento,
        COALESCE(MED.Dosis,  '-')               AS Dosis,
        DF.Cantidad,
        F.Costo_Total
    FROM FACTURA F
    JOIN PACIENTE P         ON F.ID_Paciente    = P.ID_Paciente
    JOIN MEDICO   M         ON F.ID_Medico      = M.ID_Medico
    LEFT JOIN DETALLE_FACTURA DF ON DF.ID_Factura = F.ID_Factura
    LEFT JOIN MEDICAMENTO MED    ON MED.ID_Medicamento = DF.ID_Medicamento
    WHERE F.ID_Paciente = p_ID_Paciente
    ORDER BY F.ID_Factura;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `atencion`
--

CREATE TABLE `atencion` (
  `ID_Atencion` int(11) NOT NULL,
  `ID_Paciente` int(11) NOT NULL,
  `ID_Medico` int(11) NOT NULL,
  `Fecha_Consulta` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `atencion`
--

INSERT INTO `atencion` (`ID_Atencion`, `ID_Paciente`, `ID_Medico`, `Fecha_Consulta`) VALUES
(1, 1, 1, '2025-02-10'),
(2, 2, 2, '2025-02-11'),
(3, 3, 3, '2025-02-12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_factura`
--

CREATE TABLE `detalle_factura` (
  `ID_DetalleFactura` int(11) NOT NULL,
  `ID_Factura` int(11) NOT NULL,
  `ID_Medicamento` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_factura`
--

INSERT INTO `detalle_factura` (`ID_DetalleFactura`, `ID_Factura`, `ID_Medicamento`, `Cantidad`) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 2, 3, 1),
(4, 3, 4, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `ID_Factura` int(11) NOT NULL,
  `ID_Paciente` int(11) NOT NULL,
  `ID_Medico` int(11) NOT NULL,
  `Costo_Total` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `factura`
--

INSERT INTO `factura` (`ID_Factura`, `ID_Paciente`, `ID_Medico`, `Costo_Total`) VALUES
(1, 1, 1, 150.00),
(2, 2, 2, 200.00),
(3, 3, 3, 175.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medicamento`
--

CREATE TABLE `medicamento` (
  `ID_Medicamento` int(11) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Dosis` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `medicamento`
--

INSERT INTO `medicamento` (`ID_Medicamento`, `Nombre`, `Dosis`) VALUES
(1, 'Aspirina', '100mg'),
(2, 'Paracetamol', '500mg'),
(3, 'Ibuprofeno', '200mg'),
(4, 'Amoxicilina', '250mg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medico`
--

CREATE TABLE `medico` (
  `ID_Medico` int(11) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Especialidad` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `medico`
--

INSERT INTO `medico` (`ID_Medico`, `Nombre`, `Especialidad`) VALUES
(1, 'Dra. Ramírez', 'Cardiología'),
(2, 'Dr. Pérez', 'Pediatría'),
(3, 'Dra. Soto', 'Clínica General');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `ID_Paciente` int(11) NOT NULL,
  `Nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`ID_Paciente`, `Nombre`) VALUES
(1, 'Juan García'),
(2, 'Ana Martínez'),
(3, 'Carlos López');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `atencion`
--
ALTER TABLE `atencion`
  ADD PRIMARY KEY (`ID_Atencion`),
  ADD KEY `ID_Paciente` (`ID_Paciente`),
  ADD KEY `ID_Medico` (`ID_Medico`);

--
-- Indices de la tabla `detalle_factura`
--
ALTER TABLE `detalle_factura`
  ADD PRIMARY KEY (`ID_DetalleFactura`),
  ADD KEY `ID_Factura` (`ID_Factura`),
  ADD KEY `ID_Medicamento` (`ID_Medicamento`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`ID_Factura`),
  ADD KEY `ID_Paciente` (`ID_Paciente`),
  ADD KEY `ID_Medico` (`ID_Medico`);

--
-- Indices de la tabla `medicamento`
--
ALTER TABLE `medicamento`
  ADD PRIMARY KEY (`ID_Medicamento`);

--
-- Indices de la tabla `medico`
--
ALTER TABLE `medico`
  ADD PRIMARY KEY (`ID_Medico`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`ID_Paciente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `atencion`
--
ALTER TABLE `atencion`
  MODIFY `ID_Atencion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `detalle_factura`
--
ALTER TABLE `detalle_factura`
  MODIFY `ID_DetalleFactura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `ID_Factura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `medicamento`
--
ALTER TABLE `medicamento`
  MODIFY `ID_Medicamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `medico`
--
ALTER TABLE `medico`
  MODIFY `ID_Medico` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `ID_Paciente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `atencion`
--
ALTER TABLE `atencion`
  ADD CONSTRAINT `atencion_ibfk_1` FOREIGN KEY (`ID_Paciente`) REFERENCES `paciente` (`ID_Paciente`),
  ADD CONSTRAINT `atencion_ibfk_2` FOREIGN KEY (`ID_Medico`) REFERENCES `medico` (`ID_Medico`);

--
-- Filtros para la tabla `detalle_factura`
--
ALTER TABLE `detalle_factura`
  ADD CONSTRAINT `detalle_factura_ibfk_1` FOREIGN KEY (`ID_Factura`) REFERENCES `factura` (`ID_Factura`),
  ADD CONSTRAINT `detalle_factura_ibfk_2` FOREIGN KEY (`ID_Medicamento`) REFERENCES `medicamento` (`ID_Medicamento`);

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`ID_Paciente`) REFERENCES `paciente` (`ID_Paciente`),
  ADD CONSTRAINT `factura_ibfk_2` FOREIGN KEY (`ID_Medico`) REFERENCES `medico` (`ID_Medico`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

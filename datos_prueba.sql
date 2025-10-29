USE IoT;

-- 1. Insertar datos en las tablas catálogo 
INSERT IGNORE INTO operaciones (status_operacion, status_texto) VALUES
(1, 'Adelante'),
(2, 'Atrás'),
(3, 'Detener'),
(4, 'Vuelta adelante derecha'),
(5, 'Vuelta adelante izquierda'),
(6, 'Vuelta atrás derecha'),
(7, 'Vuelta atrás izquierda'),
(8, 'Giro 90° derecha'),
(9, 'Giro 90° izquierda'),
(10, 'Giro 360° derecha'),
(11, 'Giro 360° izquierda');

-- 1. Insertar datos en la tabla de obstáculos
INSERT IGNORE INTO obstaculos (status_obstaculo, status_texto) VALUES
(1, 'Adelante'),
(2, 'Adelante-Izquierda'),
(3, 'Adelante-Derecha'),
(4, 'Adelante-Izquierda-Derecha'),
(5, 'Retrocede');

-- 2. Insertar cliente de prueba
INSERT IGNORE INTO cliente (id_cliente, nombre_cliente, apellido_p, apellido_m, telefono, correo, pais, ciudad) VALUES
(1, 'Juan Carlos', 'Perez', 'Gomez', '5512345678', 'juan@email.com', 'México', 'CDMX'),
(2, 'Maria Elena', 'Lopez', 'Garcia', '5512345679', 'maria@email.com', 'México', 'Guadalajara');

-- 3. Insertar dispositivos de prueba
INSERT IGNORE INTO dispositivo (id_dispositivo, id_cliente, ip, latitud, longitud, nombre_dispositivo) VALUES
(1, 1, '192.168.1.100', 19.4326077, -99.133208, 'Carro_Principal'),
(2, 1, '192.168.1.101', 19.4326077, -99.133209, 'Carro_Secundario'),
(3, 2, '192.168.2.100', 20.6666666, -103.333333, 'Carro_GDL_1');

-- 4. Insertar movimientos/historial de operaciones de prueba
INSERT INTO historial_operaciones (id_dispositivo, status_operacion, fecha_hora) VALUES
(1, 1, NOW() - INTERVAL 10 MINUTE),  -- Adelante
(1, 8, NOW() - INTERVAL 9 MINUTE),   -- Giro 90° derecha
(1, 1, NOW() - INTERVAL 8 MINUTE),   -- Adelante
(1, 3, NOW() - INTERVAL 7 MINUTE),   -- Detener
(1, 5, NOW() - INTERVAL 6 MINUTE),   -- Vuelta adelante izquierda
(2, 1, NOW() - INTERVAL 5 MINUTE),   -- Adelante
(2, 9, NOW() - INTERVAL 4 MINUTE),   -- Giro 90° izquierda
(1, 2, NOW() - INTERVAL 3 MINUTE),   -- Atrás
(1, 3, NOW() - INTERVAL 2 MINUTE),   -- Detener
(1, 10, NOW() - INTERVAL 1 MINUTE);  -- Giro 360° derecha

-- 5. Insertar obstáculos de prueba
INSERT INTO historial_obstaculos (id_dispositivo, status_obstaculo, fecha_hora) VALUES
(1, 1, NOW() - INTERVAL 15 MINUTE),  -- Adelante
(1, 2, NOW() - INTERVAL 12 MINUTE),  -- Adelante-Izquierda
(1, 3, NOW() - INTERVAL 10 MINUTE),  -- Adelante-Derecha
(2, 4, NOW() - INTERVAL 8 MINUTE),   -- Adelante-Izquierda-Derecha
(1, 5, NOW() - INTERVAL 5 MINUTE),   -- Retrocede
(1, 1, NOW() - INTERVAL 3 MINUTE);   -- Adelante

-- 6. Insertar secuencias DEMO de prueba
INSERT INTO secuencias_demo (id_dispositivo, nombre_secuencia, fecha_creacion) VALUES
(1, 'Secuencia Exploración', NOW() - INTERVAL 1 HOUR),
(1, 'Secuencia Evasión', NOW() - INTERVAL 45 MINUTE),
(2, 'Secuencia Patrullaje', NOW() - INTERVAL 30 MINUTE);

-- 7. Insertar operaciones para las secuencias
INSERT INTO secuencia_operaciones (id_secuencia, status_operacion, orden) VALUES
-- Secuencia 1: Exploración
(1, 1, 1),   -- Adelante
(1, 8, 2),   -- Giro 90° derecha
(1, 1, 3),   -- Adelante
(1, 9, 4),   -- Giro 90° izquierda
(1, 1, 5),   -- Adelante
(1, 3, 6),   -- Detener
-- Secuencia 2: Evasión
(2, 1, 1),   -- Adelante
(2, 5, 2),   -- Vuelta adelante izquierda
(2, 1, 3),   -- Adelante
(2, 4, 4),   -- Vuelta adelante derecha
(2, 3, 5),   -- Detener
-- Secuencia 3: Patrullaje
(3, 1, 1),   -- Adelante
(3, 8, 2),   -- Giro 90° derecha
(3, 1, 3),   -- Adelante
(3, 9, 4),   -- Giro 90° izquierda
(3, 2, 5);   -- Atrás

-- 8. Insertar ejecuciones de secuencias
INSERT INTO ejecucion_secuencias (id_secuencia, fecha_ejecucion, estado) VALUES
(1, NOW() - INTERVAL 50 MINUTE, 'completado'),
(2, NOW() - INTERVAL 25 MINUTE, 'completado'),
(3, NOW() - INTERVAL 10 MINUTE, 'progreso'),
(1, NOW() - INTERVAL 5 MINUTE, 'pendiente');

-- 9. Verificar datos insertados
SELECT 'Clientes:' as '';
SELECT * FROM cliente;

SELECT 'Dispositivos:' as '';
SELECT * FROM dispositivo;

SELECT 'Total movimientos por dispositivo:' as '';
SELECT d.nombre_dispositivo, COUNT(ho.id_evento) as total_movimientos
FROM dispositivo d
LEFT JOIN historial_operaciones ho ON d.id_dispositivo = ho.id_dispositivo
GROUP BY d.id_dispositivo, d.nombre_dispositivo;

SELECT 'Total obstáculos por dispositivo:' as '';
SELECT d.nombre_dispositivo, COUNT(hob.id_evento) as total_obstaculos
FROM dispositivo d
LEFT JOIN historial_obstaculos hob ON d.id_dispositivo = hob.id_dispositivo
GROUP BY d.id_dispositivo, d.nombre_dispositivo;
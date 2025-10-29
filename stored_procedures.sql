USE IoT;

-- 1. Agregar un estatus de movimiento
DELIMITER //
CREATE PROCEDURE sp_agregar_movimiento(
    IN p_id_dispositivo INT,
    IN p_status_operacion INT
)
BEGIN
    INSERT INTO historial_operaciones (id_dispositivo, status_operacion)
    VALUES (p_id_dispositivo, p_status_operacion);
    
    SELECT LAST_INSERT_ID() as id_evento, 'Movimiento agregado correctamente' as mensaje;
END //
DELIMITER ;
-- modo manual y automatico
-- 2. Conocer el último estatus de movimiento
DELIMITER //
CREATE PROCEDURE sp_ultimo_movimiento(IN p_id_dispositivo INT)
BEGIN
    SELECT ho.*, o.status_texto, d.nombre_dispositivo
    FROM historial_operaciones ho
    JOIN operaciones o ON ho.status_operacion = o.status_operacion
    JOIN dispositivo d ON ho.id_dispositivo = d.id_dispositivo
    WHERE ho.id_dispositivo = p_id_dispositivo
    ORDER BY ho.fecha_hora DESC
    LIMIT 1;
END //
DELIMITER ;

-- 3. Conocer los últimos 10 estatus de movimientos
DELIMITER //
CREATE PROCEDURE sp_ultimos_10_movimientos(IN p_id_dispositivo INT)
BEGIN
    SELECT ho.id_evento, ho.fecha_hora, o.status_operacion, o.status_texto, d.nombre_dispositivo
    FROM historial_operaciones ho
    JOIN operaciones o ON ho.status_operacion = o.status_operacion
    JOIN dispositivo d ON ho.id_dispositivo = d.id_dispositivo
    WHERE ho.id_dispositivo = p_id_dispositivo
    ORDER BY ho.fecha_hora DESC
    LIMIT 10;
END //
DELIMITER ;

-- 4. Agregar secuencia DEMO con programación automática de N movimientos
DELIMITER //
CREATE PROCEDURE sp_agregar_secuencia_demo(
    IN p_id_dispositivo INT,
    IN p_nombre_secuencia VARCHAR(100),
    IN p_movimientos JSON
)
BEGIN
    DECLARE v_id_secuencia INT;
    
    INSERT INTO secuencias_demo (id_dispositivo, nombre_secuencia)
    VALUES (p_id_dispositivo, p_nombre_secuencia);
    
    SET v_id_secuencia = LAST_INSERT_ID();
    
    INSERT INTO secuencia_operaciones (id_secuencia, status_operacion, orden)
    SELECT v_id_secuencia, movimientos.status_op, @row_number := @row_number + 1 as orden
    FROM JSON_TABLE(p_movimientos, '$[*]' COLUMNS (
        status_op INT PATH '$'
    )) AS movimientos, (SELECT @row_number := 0) AS t;
    
    SELECT v_id_secuencia as id_secuencia, 'Secuencia DEMO creada correctamente' as mensaje;
END //
DELIMITER ;

-- 5. Conocer las últimas 20 secuencias DEMO
DELIMITER //
CREATE PROCEDURE sp_ultimas_20_secuencias()
BEGIN
    SELECT sd.*, d.nombre_dispositivo, COUNT(so.id_secuencia_operaciones) as total_movimientos
    FROM secuencias_demo sd
    JOIN dispositivo d ON sd.id_dispositivo = d.id_dispositivo
    LEFT JOIN secuencia_operaciones so ON sd.id_secuencia = so.id_secuencia
    GROUP BY sd.id_secuencia, d.nombre_dispositivo
    ORDER BY sd.fecha_creacion DESC
    LIMIT 20;
END //
DELIMITER ;

-- 6. Repetir una secuencia DEMO
DELIMITER //
CREATE PROCEDURE sp_repetir_secuencia(IN p_id_secuencia INT)
BEGIN
    SELECT so.orden, o.status_operacion, o.status_texto
    FROM secuencia_operaciones so
    JOIN operaciones o ON so.status_operacion = o.status_operacion
    WHERE so.id_secuencia = p_id_secuencia
    ORDER BY so.orden;
    
    INSERT INTO ejecucion_secuencias (id_secuencia, estado)
    VALUES (p_id_secuencia, 'pendiente');
    
    SELECT 'Secuencia lista para ejecutar' as mensaje;
END //
DELIMITER ;

-- 7. Agregar la lógica del obstáculo
DELIMITER //
CREATE PROCEDURE sp_agregar_obstaculo(
    IN p_id_dispositivo INT,
    IN p_status_obstaculo INT
)
BEGIN
    INSERT INTO historial_obstaculos (id_dispositivo, status_obstaculo)
    VALUES (p_id_dispositivo, p_status_obstaculo);
    
    SELECT LAST_INSERT_ID() as id_evento, 'Obstáculo registrado correctamente' as mensaje;
END //
DELIMITER ;

-- 8. Conocer el último estatus del obstáculo
DELIMITER //
CREATE PROCEDURE sp_ultimo_obstaculo(IN p_id_dispositivo INT)
BEGIN
    SELECT ho.*, obs.status_texto, d.nombre_dispositivo
    FROM historial_obstaculos ho
    JOIN obstaculos obs ON ho.status_obstaculo = obs.status_obstaculo
    JOIN dispositivo d ON ho.id_dispositivo = d.id_dispositivo
    WHERE ho.id_dispositivo = p_id_dispositivo
    ORDER BY ho.fecha_hora DESC
    LIMIT 1;
END //
DELIMITER ;

-- 9. Conocer los últimos 10 estatus de los obstáculos
DELIMITER //
CREATE PROCEDURE sp_ultimos_10_obstaculos(IN p_id_dispositivo INT)
BEGIN
    SELECT ho.id_evento, ho.fecha_hora, obs.status_obstaculo, obs.status_texto, d.nombre_dispositivo
    FROM historial_obstaculos ho
    JOIN obstaculos obs ON ho.status_obstaculo = obs.status_obstaculo
    JOIN dispositivo d ON ho.id_dispositivo = d.id_dispositivo
    WHERE ho.id_dispositivo = p_id_dispositivo
    ORDER BY ho.fecha_hora DESC
    LIMIT 10;
END //
DELIMITER ;
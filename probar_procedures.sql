USE IoT;

-- Probar cada stored procedure
SELECT '=== 1. ÚLTIMO MOVIMIENTO ===' as '';
CALL sp_ultimo_movimiento(1);

SELECT '=== 2. ÚLTIMOS 10 MOVIMIENTOS ===' as '';
CALL sp_ultimos_10_movimientos(1);

SELECT '=== 3. ÚLTIMO OBSTÁCULO ===' as '';
CALL sp_ultimo_obstaculo(1);

SELECT '=== 4. ÚLTIMOS 10 OBSTÁCULOS ===' as '';
CALL sp_ultimos_10_obstaculos(1);

SELECT '=== 5. ÚLTIMAS 20 SECUENCIAS ===' as '';
CALL sp_ultimas_20_secuencias();

SELECT '=== 6. REPETIR SECUENCIA ===' as '';
CALL sp_repetir_secuencia(1);

-- Probar agregar nuevos datos
SELECT '=== 7. AGREGAR NUEVO MOVIMIENTO ===' as '';
CALL sp_agregar_movimiento(1, 1);

SELECT '=== 8. AGREGAR NUEVO OBSTÁCULO ===' as '';
CALL sp_agregar_obstaculo(1, 2);

SELECT '=== 9. AGREGAR NUEVA SECUENCIA DEMO ===' as '';
CALL sp_agregar_secuencia_demo(1, 'Nueva Secuencia Test', '[1, 8, 1, 9, 3]');
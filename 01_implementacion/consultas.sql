-- Pacientes con más de 3 citas en el último mes
SELECT 
    p.paciente_id,
    p.nombre || ' ' || p.apellido AS paciente,
    COUNT(c.cita_id) AS cantidad_citas
FROM pacientes p
JOIN citas c ON c.paciente_id = p.paciente_id
WHERE c.fecha_hora >= NOW() - INTERVAL '1 month'
GROUP BY p.paciente_id, p.nombre, p.apellido
HAVING COUNT(c.cita_id) > 3
ORDER BY cantidad_citas DESC;

-- Doctores y su cantidad de citas por especialidad
SELECT 
    d.doctor_id,
    d.nombre || ' ' || d.apellido AS doctor,
    e.nombre AS especialidad,
    COUNT(c.cita_id) AS cantidad_citas
FROM doctores d
JOIN especialidades e ON d.especialidad_id = e.especialidad_id
LEFT JOIN citas c ON c.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.nombre, d.apellido, e.nombre
ORDER BY e.nombre, cantidad_citas DESC;

-- Medicamentos con stock menor al mínimo requerido
SELECT 
    medicamento_id,
    nombre,
    stock_actual,
    stock_minimo,
    unidad
FROM medicamentos
WHERE stock_actual < stock_minimo
ORDER BY stock_actual ASC;

-- Habitaciones disponibles por tipo
SELECT 
    h.tipo,
    COUNT(c.cama_id) AS camas_disponibles
FROM habitaciones h
JOIN camas c ON c.habitacion_id = h.habitacion_id
WHERE c.ocupada = FALSE
GROUP BY h.tipo
ORDER BY h.tipo;

-- Historial médico completo de un paciente específico
SELECT
    p.paciente_id,
    p.nombre || ' ' || p.apellido AS paciente,
    p.fecha_nacimiento,
    p.genero,
    CAST(LEFT(p.historial_medico, 200) AS VARCHAR) AS historial_medico_corto,
    c.cita_id,
    c.fecha_hora,
    CAST(LEFT(c.motivo, 100) AS VARCHAR) AS motivo_corto,
    d.nombre || ' ' || d.apellido AS doctor,
    e.nombre AS especialidad,
    diag.diagnostico_id,
    CAST(LEFT(diag.descripcion, 100) AS VARCHAR) AS diagnostico_corto,
    t.tratamiento_id,
    CAST(LEFT(t.descripcion, 100) AS VARCHAR) AS tratamiento_corto
FROM pacientes p
LEFT JOIN citas c ON c.paciente_id = p.paciente_id
LEFT JOIN doctores d ON d.doctor_id = c.doctor_id
LEFT JOIN especialidades e ON e.especialidad_id = d.especialidad_id
LEFT JOIN diagnosticos diag ON diag.cita_id = c.cita_id
LEFT JOIN tratamientos t ON t.diagnostico_id = diag.diagnostico_id
WHERE p.paciente_id = 1  --PD: cambia ese número por el de otro paciente para ver su histo.--
ORDER BY c.fecha_hora;

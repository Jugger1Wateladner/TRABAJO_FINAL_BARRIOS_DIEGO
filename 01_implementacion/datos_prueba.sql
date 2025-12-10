INSERT INTO especialidades (nombre, descripcion) VALUES
('Cardiologia','Cardiologia general y de adultos'),
('Pediatria','Atencion pediatrica'),
('Medicina General','Atencion primaria'),
('Traumatologia','Lesiones y ortopedia'),
('Otorrinolaringologia','enfermedades del oido, nariz y garganta');

INSERT INTO doctores (nombre, apellido, licencia_medica, especialidad_id, email, telefono, fecha_contratacion) VALUES
('Alex','Mason','CM-CAR-04231',1,'masonalexbo@gmail.com','0424-5553229','2020-03-01'),
('Teto','Kasane','CM-CAR-08931',5,'kasaneteto@yahoo.com','0416-5552413','2019-07-15'),
('Armando','Paredes','CM-CAR-06660',3,'armandpareds@hotmail.com','0414-5559632','2021-01-10');

INSERT INTO pacientes (nombre, apellido, fecha_nacimiento, genero, telefono, email, direccion, historial_medico) VALUES
('John','Price','1985-05-20','M','0412-5557848','johnprecio@hotmail.com','Las Quintas II','Alergia a penicilina'),
('Miku','Hatsune','2007-08-31','F','0414-5552312','hatsunemiku@gmail.com','Bulevar de Sabana Grande','Hipertension'),
('Jane','Doe','2000-01-01','F','0416-5555666','janedcsm@outlook.com','','Ninguno');

INSERT INTO habitaciones (numero, tipo, piso, descripcion) VALUES
('101','individual',1,'Habitacion cerca enfermeria'),
('102','doble',1,'Habitacion con banno compartido'),
('201','suite',2,'Suite para pacientes VIP');

INSERT INTO camas (habitacion_id, numero_cama, ocupada) VALUES
(1,'A',FALSE),
(2,'A',FALSE),
(2,'B',TRUE),
(3,'A',FALSE);

INSERT INTO medicamentos (nombre, laboratorio, presentacion, stock_actual, stock_minimo, unidad, precio_unitario, vencimiento) VALUES
('Paracetamol','Lab A','Tabletas 500mg',200,50,'tabletas',0.10,'2026-12-31'),
('Amoxicilina','Lab B','Capsulas 500mg',20,30,'capsulas',0.50,'2025-06-30'),
('Ibuprofeno','Lab C','Tabletas 200mg',5,20,'tabletas',0.08,'2024-11-30');

INSERT INTO citas (paciente_id, doctor_id, fecha_hora, duracion_minutos, motivo, estado) VALUES
(1,1, CURRENT_TIMESTAMP - INTERVAL '20 days',30,'Control cardiologia','atendida'),
(1,1, CURRENT_TIMESTAMP - INTERVAL '10 days',30,'Dolor toracico','atendida'),
(1,1, CURRENT_TIMESTAMP - INTERVAL '5 days',30,'Revision','programada'),
(2,2, CURRENT_TIMESTAMP - INTERVAL '40 days',45,'Chequeo general','atendida'),
(3,2, CURRENT_TIMESTAMP - INTERVAL '2 days',30,'Consulta pediatria','programada'),
(1,3, CURRENT_TIMESTAMP - INTERVAL '15 days',30,'Consulta medicina general','atendida');

INSERT INTO diagnosticos (cita_id, descripcion, codigo_CIE10, registrado_por) VALUES
(1,'Insuficiencia leve','I50.9',1),
(2,'Dolor no especificado','R07.9',1),
(4,'Chequeo normal','Z00.0',2);

INSERT INTO tratamientos (diagnostico_id, descripcion, inicio, fin, prescrito_por) VALUES
(1,'Tratamiento farmacologico basico', CURRENT_DATE - INTERVAL '10 days', CURRENT_DATE + INTERVAL '20 days', 1),
(2,'Recomendaciones y reposo', CURRENT_DATE - INTERVAL '20 days', NULL, 1);

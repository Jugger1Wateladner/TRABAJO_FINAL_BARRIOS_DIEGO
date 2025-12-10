DROP TABLE IF EXISTS tratamientos CASCADE;
DROP TABLE IF EXISTS diagnosticos CASCADE;
DROP TABLE IF EXISTS citas CASCADE;
DROP TABLE IF EXISTS medicamentos CASCADE;
DROP TABLE IF EXISTS camas CASCADE;
DROP TABLE IF EXISTS habitaciones CASCADE;
DROP TABLE IF EXISTS doctores CASCADE;
DROP TABLE IF EXISTS especialidades CASCADE;
DROP TABLE IF EXISTS pacientes CASCADE;
DROP TABLE IF EXISTS tratamientos_medicamentos CASCADE;

CREATE TABLE especialidades (
	especialidad_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL UNIQUE,
	descripcion TEXT,
	activo BOOLEAN NOT NULL DEFAULT TRUE,   
	CHECK (char_length(nombre) >= 3),
	CHECK (char_length(nombre) <= 100),
	CHECK (activo IN (TRUE, FALSE))
);

CREATE TABLE doctores (
    doctor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    licencia_medica VARCHAR(50) NOT NULL UNIQUE,
    especialidad_id INT NOT NULL,
    email VARCHAR(150),
    telefono VARCHAR(30),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_contratacion DATE NOT NULL DEFAULT CURRENT_DATE,
    CHECK (char_length(nombre) > 1),
    CHECK (char_length(apellido) > 1),
    CHECK (fecha_contratacion <= CURRENT_DATE),
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(especialidad_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE pacientes (
    paciente_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero CHAR(1) NOT NULL CHECK (genero IN ('M','F')),
    telefono VARCHAR(30),
    email VARCHAR(150),
    direccion TEXT,
    historial_medico TEXT DEFAULT '',
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE,
    CHECK (fecha_nacimiento <= CURRENT_DATE),
    CHECK (date_part('year', age(fecha_nacimiento)) BETWEEN 0 AND 130),
    CHECK (char_length(nombre) > 1)
);

CREATE TABLE habitaciones (
    habitacion_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero VARCHAR(20) NOT NULL UNIQUE,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('individual','doble','suite')),
    piso INT NOT NULL CHECK (piso >= 0),
    descripcion TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK (char_length(numero) > 0),
    CHECK (char_length(tipo) > 0),
    CHECK (activo IN (TRUE, FALSE))
);

CREATE TABLE camas (
    cama_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    habitacion_id INT NOT NULL,
    numero_cama VARCHAR(10) NOT NULL,
    ocupada BOOLEAN NOT NULL DEFAULT FALSE,
    descripcion TEXT,
    CHECK (char_length(numero_cama) > 0),
    CHECK (ocupada IN (TRUE, FALSE)),
    CHECK (char_length(numero_cama) <= 10),
    FOREIGN KEY (habitacion_id) REFERENCES habitaciones(habitacion_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE citas (
    cita_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    paciente_id INT NOT NULL,
    doctor_id INT NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    duracion_minutos INT NOT NULL DEFAULT 30,
    motivo TEXT,
    estado VARCHAR(20) NOT NULL DEFAULT 'programada',
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (fecha_hora >= '2000-01-01'::timestamp),
    CHECK (duracion_minutos > 0 AND duracion_minutos <= 1440),
    CHECK (estado IN ('programada','confirmada','atendida','cancelada','no-show')),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctores(doctor_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE diagnosticos (
    diagnostico_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cita_id INT NOT NULL,
    descripcion TEXT NOT NULL,
    codigo_CIE10 VARCHAR(20),
    registrado_por INT NOT NULL, 
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (char_length(descripcion) > 5),
    CHECK (char_length(coalesce(codigo_CIE10,'')) <= 20),
    CHECK (fecha_registro >= '2000-01-01'::timestamp),
    FOREIGN KEY (cita_id) REFERENCES citas(cita_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (registrado_por) REFERENCES doctores(doctor_id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE tratamientos (
    tratamiento_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diagnostico_id INT NOT NULL,
    descripcion    TEXT NOT NULL,
    inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    fin DATE,
    prescrito_por INT NOT NULL, 
    CHECK (char_length(descripcion) > 3),
    CHECK (fin IS NULL OR fin >= inicio),
    CHECK (inicio >= '2000-01-01'::date),
    FOREIGN KEY (diagnostico_id) REFERENCES diagnosticos(diagnostico_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prescrito_por) REFERENCES doctores(doctor_id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE medicamentos (
    medicamento_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    laboratorio VARCHAR(100),
    presentacion VARCHAR(100),
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 10,
    unidad VARCHAR(20) NOT NULL DEFAULT 'unidad',
    precio_unitario NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    vencimiento DATE,
    CHECK (char_length(nombre) > 1),
    CHECK (stock_actual >= 0),
    CHECK (stock_minimo >= 0)
);

CREATE TABLE tratamientos_medicamentos (
    tratamiento_id INT NOT NULL,
    medicamento_id INT NOT NULL,
    cantidad NUMERIC(10,2) DEFAULT 1,
    PRIMARY KEY (tratamiento_id, medicamento_id),
    FOREIGN KEY (tratamiento_id) REFERENCES tratamientos(tratamiento_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (medicamento_id) REFERENCES medicamentos(medicamento_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_citas_fecha ON citas (fecha_hora);
CREATE INDEX idx_medicamentos_stock ON medicamentos (stock_actual);

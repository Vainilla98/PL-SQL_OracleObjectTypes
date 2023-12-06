-- Ejercicio 1
CREATE OR REPLACE TYPE tPersona as OBJECT (
	Nombre varchar2(20),
	apellidos varchar2(40),
	fecha_nacimiento DATE,
    email varchar2(40),
    poblacion varchar2(40),
    cp varchar2(5)
) NOT final;
/
-- Ejercicio 2
CREATE OR REPLACE TYPE tAlumnos UNDER tPersona (
	ampa NUMBER(1)
);
/

CREATE OR REPLACE TYPE tProfesores UNDER tPersona (
	NRP varchar2(20),
	espacialidad varchar2(20)
);
/

CREATE TABLE alumnos OF tAlumnos;

INSERT INTO alumnos VALUES (tAlumnos('Sancho','Matamoros',TO_DATE('01/05/1978','DD/MM/YYYY'),'sancho@charoSL.com','La Gloriosa','12345',1));
INSERT INTO alumnos VALUES (tAlumnos('Munio','Mendoza',TO_DATE('05-11-1959','DD/MM/YYYY'),'munio@charoSL.com','La Gloriosa','12345',0));
INSERT INTO alumnos VALUES (tAlumnos('Nuño','Rodriguez',TO_DATE('24-07-1987','DD/MM/YYYY'),'nuño@charoSL.com','Mordor','67890',1));

CREATE TABLE profesores OF tProfesores;

INSERT INTO profesores VALUES (tProfesores('Giuseppe','Esposio',TO_DATE('03-02-1939','DD/MM/YYYY'),'giuseppe@charoSL.com','Isengard','12347','000001','DBA'));
INSERT INTO profesores VALUES (tProfesores('Amadeo','Giordani',TO_DATE('02-07-1952','DD/MM/YYYY'),'amadeo@charoSL.com','Moriah','12346','000002','Servicios Web'));
INSERT INTO profesores VALUES (tProfesores('Giovanni','Lombardi',TO_DATE('19-10-1924','DD/MM/YYYY'),'giovanni@charoSL.com','Mordor','67890','000003','Desarollo Web'));
-- Ejercicio 3
CREATE OR REPLACE TYPE tAsignaturas as OBJECT (
	Codigo NUMBER,
	Nombre varchar2(40),
	maestro REF tProfesores
);
/
CREATE TABLE asignaturas OF tAsignaturas;

INSERT INTO asignaturas
SELECT tAsignaturas(1, 'FFHH', REF(t))
FROM profesores t
WHERE NRP = '000001';

INSERT INTO asignaturas
SELECT tAsignaturas(2, 'ISO', REF(t))
FROM profesores t
WHERE NRP = '000001';

INSERT INTO asignaturas
SELECT tAsignaturas(3, 'PAR', REF(t))
FROM profesores t
WHERE NRP = '000002';

INSERT INTO asignaturas
SELECT tAsignaturas(4, 'PROG', REF(t))
FROM profesores t
WHERE NRP = '000003';

INSERT INTO asignaturas
SELECT tAsignaturas(5, 'SSII', REF(t))
FROM profesores t
WHERE NRP = '000002';

INSERT INTO asignaturas
SELECT tAsignaturas(6, 'EWEB', REF(t))
FROM profesores t
WHERE NRP = '000003';

INSERT INTO asignaturas
SELECT tAsignaturas(7, 'SGE', REF(t))
FROM profesores t
WHERE NRP = '000003';

-- Ejercicio 4
CREATE TYPE listaModulos AS TABLE OF tAsignaturas;

CREATE OR REPLACE TYPE tCurso as OBJECT (
	ID NUMBER,
	Nombre varchar2(40),
    duracion NUMBER,
    modulos listaModulos,
    tutor REF tProfesores
);
/
CREATE TABLE cursos OF tCurso NESTED TABLE modulos STORE as listModules;
-- DROP TABLE cursos

INSERT INTO cursos
SELECT 1,'ASIR',500, listaModulos(
    (SELECT tAsignaturas(1, 'PAR', REF(t))
    FROM profesores t
    WHERE NRP = '000002'),
    (SELECT tAsignaturas(2, 'ISO', REF(t))
    FROM profesores t
    WHERE NRP = '000002'),
    (SELECT tAsignaturas(3, 'FFHH', REF(t))
    FROM profesores t
    WHERE NRP = '000001')
    ), REF(t1)
FROM profesores t1
WHERE NRP = '000001';

INSERT INTO cursos
SELECT 2,'DAM',540, listaModulos(
    (SELECT tAsignaturas(1, 'PROG', REF(t))
    FROM profesores t
    WHERE NRP = '000003'),
    (SELECT tAsignaturas(2, 'ENDES', REF(t))
    FROM profesores t
    WHERE NRP = '000002'),
    (SELECT tAsignaturas(3, 'SSII', REF(t))
    FROM profesores t
    WHERE NRP = '000001')
    ), REF(t1)
FROM profesores t1
WHERE NRP = '000002';

INSERT INTO cursos
SELECT 3,'DAW',540, listaModulos(
    (SELECT tAsignaturas(1, 'PROG', REF(t))
    FROM profesores t
    WHERE NRP = '000003'),
    (SELECT tAsignaturas(2, 'SWEB', REF(t))
    FROM profesores t
    WHERE NRP = '000003'),
    (SELECT tAsignaturas(3, 'SSII', REF(t))
    FROM profesores t
    WHERE NRP = '000001')
    ), REF(t1)
FROM profesores t1
WHERE NRP = '000003';


-- *Con referencias
CREATE TYPE listaModulos2 AS TABLE OF REF tAsignaturas;

CREATE OR REPLACE TYPE tCurso2 as OBJECT (
	ID NUMBER,
	Nombre varchar2(40),
    duracion NUMBER,
    modulos listaModulos2,
    tutor REF tProfesores
);
/
CREATE TABLE cursos2 OF tCurso2 NESTED TABLE modulos STORE as listModules2;

INSERT INTO cursos2
SELECT 1,'ASIR',440, listaModulos2(
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 1),
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 2),
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 3)
    ), REF(t1)
FROM profesores t1
WHERE NRP = '000001';

INSERT INTO cursos2
SELECT 2,'DAM',480, listaModulos2(
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 4),
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 5),
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 7)
    ), REF(t1)
FROM profesores t1
WHERE NRP = '000002';

INSERT INTO cursos2
SELECT 3,'DAW',480, listaModulos2(
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 4),
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 5),
    (SELECT REF(t)
    FROM asignaturas t
    WHERE codigo = 7)
    ), REF(t1)
FROM profesores t1
WHERE NRP = '000003';


-- Ejercicio 5
CREATE TABLE matriculas (
    alumno REF tAlumnos,
    curso REF tCurso
);
DROP TABLE matriculas;
INSERT INTO matriculas VALUES (
    (
        SELECT REF(t)
        from alumnos t
        WHERE nombre = 'Sancho'
    ),
    (
        SELECT REF(t)
        from cursos t
        WHERE nombre = 'ASIR'
    )
);
INSERT INTO matriculas VALUES (
    (
        SELECT REF(t)
        from alumnos t
        WHERE nombre = 'Munio'
    ),
    (
        SELECT REF(t)
        from cursos t
        WHERE nombre = 'ASIR'
    )
);
INSERT INTO matriculas VALUES (
    (
        SELECT REF(t)
        from alumnos t
        WHERE nombre = 'Nuño'
    ),
    (
        SELECT REF(t)
        from cursos t
        WHERE nombre = 'DAM'
    )
);
-- Ejercicio 6

/*CREATE OR REPLACE PROCEDURE muestraDatos
AS
BEGIN
	FOR regCurso IN (SELECT * FROM cursos) LOOP
        dbms_output.put_line('==================');
        dbms_output.put_line(regCurso.nombre);
        dbms_output.put_line('==================');
        dbms_output.put_line('Duracion: '||regCurso.duracion||' horas');
        FOR i IN regCurso.modulos.FIRST .. regCurso.modulos.LAST LOOP
            dbms_output.put_line(regCurso.modulos(i).nombre);
            SELECT modulos FROM cursos

            --dbms_output.put_line(CHR(9)||'Maestro: '||);
        END LOOP;
    END LOOP;
END;
/*/

CREATE OR REPLACE PROCEDURE muestraDatos
AS
    tutor tProfesores;
    modulo tAsignaturas;
    total NUMBER;
BEGIN
	FOR regCurso IN (SELECT * FROM cursos2) LOOP
        dbms_output.put_line(regCurso.nombre);
        dbms_output.put_line('----------------------------------------');
        dbms_output.put_line('Duracion: '||regCurso.duracion||' horas');
        SELECT deref(tutor) into tutor from cursos2 WHERE id = regCurso.id;
        dbms_output.put_line('Tutor: '||tutor.nombre||' '||tutor.apellidos||' |  Mail: '||tutor.email);
        FOR i IN regCurso.modulos.FIRST .. regCurso.modulos.LAST LOOP
            SELECT deref(regCurso.modulos(i)) into modulo from dual;
            SELECT deref(modulo.maestro) into tutor from dual;
            dbms_output.put_line(CHR(09)||modulo.nombre||' --> Maestro: '||tutor.nombre||' '||tutor.apellidos);
            dbms_output.put_line(CHR(09)||CHR(09)||'Mail: '||tutor.email||'  Especialidad: '||tutor.espacialidad);
        END LOOP;
        dbms_output.put_line('Matriculas: ');
        total := 0;
        FOR regAlumno IN (SELECT deref(alumno) alumno from matriculas t where t.curso.id = regCurso.id) LOOP
            total := total + 1;
            dbms_output.put_line(CHR(09)||regAlumno.alumno.nombre ||' '||regAlumno.alumno.apellidos);
            IF ( regAlumno.alumno.ampa = 1) THEN
                dbms_output.put_line(CHR(09)||'Ampa: Si');
            ELSE
                dbms_output.put_line(CHR(09)||'Ampa: No');
            END IF;
            dbms_output.put_line(CHR(09)||regAlumno.alumno.fecha_nacimiento ||' | '||regAlumno.alumno.email||' | '||regAlumno.alumno.poblacion||CHR(10));
        END LOOP;
        dbms_output.put_line('Hay en total '||total||' alumnos');
        dbms_output.put_line('=========================='||CHR(10));
    END LOOP;
END;
/

EXECUTE muestraDatos

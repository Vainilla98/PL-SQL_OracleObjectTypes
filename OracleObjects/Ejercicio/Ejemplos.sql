CREATE TYPE tTlfn as OBJECT (
    tipo VARCHAR2(20),
    num NUMBER
);

CREATE TYPE tlistin as table of tTlfn;

CREATE TABLE empleados2 (
    id NUMBER,
    nombre VARCHAR2(20),
    telefonos tlistin
)
NESTED TABLE telefonos STORE AS TablaTelefonos;

INSERT INTO empleados2 VALUES (1,'Bartolo',tlistin(tTlfn('fijo',926812132), tTlfn('movil',652234531)));
INSERT INTO empleados2 VALUES (2,'tenia',tlistin(tTlfn('fijo',926786432), tTlfn('movil',653213123), tTlfn('fijo',626342311)));
INSERT INTO empleados2 VALUES (32,'flauta',tlistin(tTlfn('fijo',92632132), tTlfn('movil',653213321), tTlfn('fijo',626342311)));

SELECT nombre, telefonos
from empleados2, table(empleados2.telefonos)


-- COCHES
CREATE TYPE tcoche as OBJECT (
    marca varchar2(30),
    modelo varchar2(30)
);

CREATE TABLE vehiculos of tcoche;

-- o tambien se puede 
CREATE TABLE vehiculos2 (
    matricula VARCHAR2(20),
    coche tcoche
);

INSERT INTO vehiculos VALUES (tcoche('seat','panda'));
INSERT INTO vehiculos2 VALUES ('123A-AAA',tcoche('seat','panda'));

SELECT object_id, object_value from vehiculos;

SELECT v.coche.marca, v.coche.modelo from vehiculos2 v;

-- *Circulo*

CREATE OR REPLACE TYPE Circulo AS OBJECT (
    radio NUMBER,
    MEMBER FUNCTION Area RETURN NUMBER,
    MEMBER FUNCTION Perimetro RETURN NUMBER
);

CREATE OR REPLACE TYPE body Circulo as 
    MEMBER FUNCTION Area RETURN NUMBER IS
        res number(9,2);
        PI NUMBER := 3.1415926535897931;
    BEGIN 
        res := power(radio,2) * PI;
        RETURN res;
    END; 
    MEMBER FUNCTION Perimetro RETURN NUMBER IS
        res number(9,2);
        PI NUMBER := 3.1415926535897931;
    BEGIN
        res := 2 * radio * PI;
        RETURN res;
    END;
END;
/

create table circulo1 of Circulo; 


CREATE TABLE circulos (
    ID Number,
    cir Circulo,

    PRIMARY KEY (ID)
);

INSERT INTO circulos VALUES (1,Circulo(4));
INSERT INTO circulos VALUES (2,Circulo(8));
INSERT INTO circulos VALUES (3,Circulo(12));

BEGIN
  FOR RegCirculo IN (SELECT * from circulos) LOOP
    dbms_output.put_line(RegCirculo.ID||'-> Radio: '||RegCirculo.cir.radio||'- Perimetro: '||RegCirculo.cir.Perimetro||'- Área: '||RegCirculo.cir.Area);
  END LOOP;
END;


-- *PERSONAS*


CREATE OR REPLACE TYPE tPersona as OBJECT (
	Id number,
	Nombre varchar2(20),
	member function muestraDatos return varchar2
) NOT final;
/

CREATE OR REPLACE TYPE tEstudiante UNDER tPersona (
	centro varchar2(10),
	notaMedia number,
    overriding member function muestraDatos return varchar2
) NOT final;
/

CREATE OR REPLACE TYPE tEstudianteErasmus UNDER tEstudiante (
	centroDestino varchar2(20),
    pais VARCHAR2(20),
    overriding member function muestraDatos return varchar2
) NOT final;
/

CREATE OR REPLACE TYPE tProfesorado UNDER tPersona (
	modulo varchar2(10),
	nclases number,
    overriding member function muestraDatos return varchar2

) NOT final;
/

CREATE OR REPLACE TYPE tEmpleado UNDER tPersona (
	NSS VARCHAR2(40),
    overriding member function muestraDatos return varchar2
) NOT final;
/

create or replace type body tPersona as
	member function muestraDatos return varchar2 IS 
	BEGIN
		return ('Persona --> '||Id||' nombre: '|| nombre);
	end;
end;
/

create or replace type body tEstudiante as
	OVERRIDING member function muestraDatos return varchar2 IS
	begin
		return ('Estudiante --> '||Id||' nombre:'|| nombre|| ' centro:'|| centro || ' Notamedia:'||notamedia);
	end;
end;
/

create or replace type body tEstudianteErasmus as
	OVERRIDING member function muestraDatos return varchar2 IS
	begin
		return ('Estudiante Erasumus --> '||Id||' nombre:'|| nombre|| ' centro:'|| centro || ' Notamedia:'||notamedia||' Centro de Destino:'||centroDestino||' Pis:'||pais);
	end;
end;
/

create or replace type body tProfesorado as
	OVERRIDING member function muestraDatos return varchar2 IS
	begin
		return ('Profesor --> '||Id||' nombre:'|| nombre|| ' modulo:'|| modulo || ' Numero de Clases:'||nclases);
	end;
end;
/

create or replace type body tEmpleado as
	OVERRIDING member function muestraDatos return varchar2 IS
	begin
		return ('Empleado --> '||Id||' nombre:'|| nombre|| ' NSS:'|| NSS );
	end;
end;
/


CREATE TABLE personas of tPersona;

DROP TABLE personas;

INSERT INTO personas VALUES (tPersona(1,'Juse'));
INSERT INTO personas VALUES (tPersona(2,'Luis'));
INSERT INTO personas VALUES (tEstudiante(3,'Napoleon','Gloriosa',9));
INSERT INTO personas VALUES (tProfesorado(4,'Manue','SOR',6));
INSERT INTO personas VALUES (tProfesorado(5,'Jose Maria','PAR',9));

INSERT INTO personas VALUES (tEmpleado(6,'Josefina','000000001-S'));
INSERT INTO personas VALUES (tEmpleado(7,'Rafa','000000001-A'));

INSERT INTO personas VALUES (tEstudianteErasmus(8,'Bartolo','Gloriosa',4,'Detuch SL','Deutchland'));
INSERT INTO personas VALUES (tEstudianteErasmus(9,'Flaurio','Gloriosa',6,'Deutch Vökenhaimer','Deutchland'));

SELECT * FROM personas;
SELECT value(t) from personas t;
SELECT t.muestraDatos() FROM personas t;

 
-- *VEHÍCULOS*

CREATE OR REPLACE TYPE vehiculoBase as OBJECT (
    Id NUMBER,
    modelo VARCHAR2(20),
    velocidad NUMBER,

    MEMBER PROCEDURE acelerar (vel IN NUMBER),
    MEMBER PROCEDURE frenar (vel IN NUMBER),
    MEMBER PROCEDURE parar
) NOT final;

create or replace type body vehiculoBase as
	member PROCEDURE acelerar (vel IN NUMBER) IS
	begin
		velocidad := velocidad + vel;
	end;
    member PROCEDURE frenar (vel IN NUMBER) IS
	begin
		velocidad := velocidad - vel;
	end;
    member PROCEDURE parar  IS
	begin
		velocidad := 0;
	end;
end;
/

CREATE OR REPLACE TYPE coche UNDER vehiculoBase (
    Cuatrox4 VARCHAR2(5),
    nPuertas NUMBER
) NOT final;

CREATE OR REPLACE TYPE camion UNDER vehiculoBase (
    Tipo VARCHAR2(10),
    Capacidad NUMBER
) NOT final;

CREATE TABLE Vehiculos3 of vehiculoBase;
DROP TABLE vehiculos3
INSERT INTO Vehiculos3 VALUES (coche(1,'Casscai',0,'true',5));
INSERT INTO Vehiculos3 VALUES (coche(2,'Astra',0,'false',5));
INSERT INTO Vehiculos3 VALUES (coche(3,'Corsa',0,'false',3));
INSERT INTO Vehiculos3 VALUES (camion(4,'MAN',0,'cisterna',9000));
INSERT INTO Vehiculos3 VALUES (camion(5,'Daily',0,'caja',6000));
INSERT INTO Vehiculos3 VALUES (camion(6,'Serie TGX',0,'cisterna',13000));

SELECT * FROM Vehiculos3;
SELECT value(t) from Vehiculos3 t;
SELECT t.muestraDatos() FROM Vehiculos3 t;

DECLARE
    veh vehiculoBase;
BEGIN
    FOR i IN (SELECT value(v) from vehiculos3 v) LOOP
        -- IF (i is of (coche)) THEN
            dbms_output.put_line('Coche');
       -- END if;
    END LOOP;
END;


-- *Veterinario*

Create type veterinario as object (
    Id integer,
    Nombre varchar(100),
    Direccion varchar(255)
);
/

Create type mascota as object (
    Id integer,
    Raza varchar(100),
    Nombre varchar(100),
    Vet REF veterinario
);
/

Create table veterinarios of veterinario;
/

Create table mascotas of mascota (
    Primary key (id),
    Scope for (vet) is veterinarios
);
/

Insert into veterinarios values (1, 'Jesus Sánchez', 'C/El mareo, 29');
Insert into veterinarios values (2, 'Pilar Calvo','C/Sol,11');

Insert into mascotas 
    SELECT 1, 'perro','sprocket', REF(v)
    From veterinarios v
    Where v.id=1;
Insert into mascotas 
    SELECT 2, 'Gato','Gardfield', v.object_id -- Vale REF(v) igualmente 
    From veterinarios v
    Where v.id=1;

SELECT * from mascotas;
Select nombre, deref(vet) from mascotas;
Select nombre, v.vet.nombre from mascotas v;
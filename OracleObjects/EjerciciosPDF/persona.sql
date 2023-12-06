CREATE or replace TYPE tPersona as OBJECT (
	Id number,
	Nombre varchar2(20),
	member function muestraDatos return varchar2
) NOT final;
/

CREATE or replace type body tPersona as
	member function muestraDatos return varchar2 IS 
	BEGIN
		return ('Persona --> '||Id||' nombre: '|| nombre);
	end;
end;
/

-- Tipo de canet (ciclomotor, turismo, furgon, camion)
CREATE TYPE tCarnet as TABLE OF VARCHAR2(20); 

CREATE OR REPLACE TYPE tConductor UNDER tPersona (
	carnet tCarnet,
    overriding member function muestraDatos return varchar2
) NOT final;
/

CREATE or replace type body tConductor as
	OVERRIDING member function muestraDatos return varchar2 IS
    carnetes VARCHAR2(100) := '';
	BEGIN
        for i in 1..carnet.LAST
        LOOP
            carnetes := carnetes || carnet(i) ||',';
        END LOOP;
		return ('Conductor --> '||Id||' nombre:'|| nombre|| ' carnet:'|| carnetes );
	end;
end;
/

-- DROP TABLE conductores;

CREATE TABLE conductores OF tConductor
NESTED TABLE carnet STORE as carnetIndividuales;

INSERT INTO conductores VALUES (tConductor(1,'Jusepe', tCarnet('B')));
INSERT INTO conductores VALUES (tConductor(2,'Emanuelle', tCarnet('B','C')));
INSERT INTO conductores VALUES (tConductor(3,'Vittorio', tCarnet('C')));
-- TRUNCATE TABLE conductores
SELECT * from conductores;



--   + ======================== +
-- * |     VEHIUCLOS            |
--   + ======================== +

CREATE OR REPLACE TYPE vehiculoBase as OBJECT (
    Id NUMBER,
    modelo VARCHAR2(20),
    velocidad NUMBER,
    conductor REF tConductor,

    MEMBER PROCEDURE acelerar (vel IN NUMBER),
    MEMBER PROCEDURE frenar (vel IN NUMBER),
    MEMBER PROCEDURE parar
) NOT final;

-- DROP TYPE vehiculoBase FORCE;

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
-- DROP TYPE coche;
CREATE OR REPLACE TYPE coche UNDER vehiculoBase (
    Cuatrox4 VARCHAR2(5),
    nPuertas NUMBER
) NOT final;

-- DROP TYPE camion;
CREATE OR REPLACE TYPE camion UNDER vehiculoBase (
    Tipo VARCHAR2(10),
    Capacidad NUMBER
) NOT final;

CREATE TABLE Vehiculos3 (
    v vehiculoBase
);
-- DROP TABLE vehiculos3

INSERT INTO Vehiculos3 
SELECT coche(1,'Casscai', 0, REF(t),'true',5)
FROM conductores t
WHERE t.ID = 1;

BEGIN
    FOR i IN (SELECT Id, modelo, velocidad, DEREF(conductor) conductor from Vehiculos3) LOOP
        dbms_output.put_line(i.conductor.nombre);
    END LOOP;
END;

SELECT * FROM conductores;
SELECT * FROM vehiculos3;


SELECT DEREF(conductor)
from Vehiculos3
WHERE DEREF(conductor).ID = 1;

SELECT value(t).carnet carro
from vehiculos3 t
WHERE t.carro.REF(conductor).id = 1 -- :NEW.REF(conductor);

TRUNCATE TABLE vehiculos3;
/
INSERT INTO Vehiculos3 
SELECT coche(1,'Corsa', 0, REF(t),'false',3)
FROM conductores t
WHERE t.ID = 1;

INSERT INTO Vehiculos3 
SELECT camion(2,'MAN TGX', 0, REF(t),'true',2)
FROM conductores t
WHERE t.ID = 1;

CREATE OR REPLACE TRIGGER TR_Vehiculos3_1
	BEFORE INSERT 
	ON Vehiculos3
	FOR EACH ROW
DECLARE
    chofer tConductor;
    bien NUMBER := 0;
BEGIN
    SELECT DEREF(:NEW.v.conductor) INTO chofer FROM DUAL;
    IF ( :new.v IS OF (coche) ) THEN
        FOR i IN chofer.carnet.FIRST..chofer.carnet.LAST LOOP
            IF ( chofer.carnet(i) = 'B') THEN
                bien := 1;
            END IF;
        END LOOP;
        IF ( bien = 0) THEN
            raise_application_error(-20000,'El conductor no tiene carnet de coche');
        END IF;
    ELSIF ( :new.v IS OF (camion) ) THEN 
        FOR i IN chofer.carnet.FIRST..chofer.carnet.LAST LOOP
            IF ( chofer.carnet(i) = 'C') THEN
                bien := 1;
            END IF;
        END LOOP;
        IF ( bien = 0) THEN
            raise_application_error(-20000,'El conductor no tiene carnet de camión');
        END IF;
    ELSE
        raise_application_error(-20000,'Solo se pueden isertar conductores de camión y coche');
    END IF;
END;
/

SELECT * FROM Vehiculos3;
SELECT value(t) from Vehiculos3 t;
SELECT t.muestraDatos() FROM conductores t;



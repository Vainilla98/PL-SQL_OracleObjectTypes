-- empledepart2

CREATE OR REPLACE TYPE vehiculoBase as OBJECT (
    Id NUMBER,
    modelo VARCHAR2(20),
    velocidad NUMBER,

    MEMBER PROCEDURE acelerar (vel IN NUMBER),
    MEMBER PROCEDURE frenar (vel IN NUMBER),
    MEMBER PROCEDURE parar
) NOT final;
/

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
/

CREATE OR REPLACE TYPE camion UNDER vehiculoBase (
    Tipo VARCHAR2(10),
    Capacidad NUMBER
) NOT final;
/

CREATE TABLE Vehiculos3 of vehiculoBase;
/
-- DROP TABLE vehiculos3

INSERT INTO Vehiculos3 VALUES (coche(1,'Casscai',0,'true',5));
INSERT INTO Vehiculos3 VALUES (coche(2,'Astra',0,'false',5));
INSERT INTO Vehiculos3 VALUES (coche(3,'Corsa',0,'false',3));
INSERT INTO Vehiculos3 VALUES (camion(4,'MAN',0,'cisterna',9000));
INSERT INTO Vehiculos3 VALUES (camion(5,'Daily',0,'caja',6000));
INSERT INTO Vehiculos3 VALUES (camion(6,'Serie TGX',0,'cisterna',13000));


-- SELECT * FROM Vehiculos3;
-- SELECT value(t) from Vehiculos3 t;

CREATE OR REPLACE TYPE conductor AS OBJECT (
    ID NUMBER,
    Nombre VARCHAR2(30),
    Coche REF vehiculoBase
);

CREATE TABLE conductores of conductor;
-- DROP TABLE conductores;
INSERT INTO conductores 
SELECT 1, 'El Jona', REF(t)
from Vehiculos3 t
where t.Id = 1;

INSERT INTO conductores 
SELECT 2, 'Bena', REF(t)
from Vehiculos3 t
where t.Id = 2;

INSERT INTO conductores 
SELECT 3, 'Manolo', REF(t)
from Vehiculos3 t
where t.Id = 4;

SELECT nombre, DEREF(Coche).MODELO
from conductores;

SELECT * FROM vehiculos3;
SELECT * FROM conductores;

DECLARE
    i NUMBER := 1;
BEGIN
    FOR e IN (SELECT VALUE(t) carro from vehiculos3 t) LOOP
        UPDATE vehiculos3
        SET velocidad = e.acelerar(10*i)
        WHERE vehiculos3.id = e.id;
        i := i + 1;
    END LOOP;
END;

BEGIN
    FOR e IN (SELECT Id,Nombre, DEREF(Coche) conductor from conductores) LOOP
         dbms_output.put_line(e.Nombre ||' conduce un vehiculo con modelo'||e.conductor.modelo);
    END LOOP;
END;

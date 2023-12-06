-- Ejercicio 1
CREATE OR REPLACE TRIGGER Pag20n1
	BEFORE INSERT
	ON emple
	FOR EACH ROW
DECLARE
	IDEmple NUMBER;
BEGIN
	SELECT MAX(emple_no)+1 INTO IDEmple from emple;
    :NEW.emple_no := IDEmple;
END;
/

INSERT INTO emple VALUES (9999, 'Bunbury', 'EMPLEADO', 1, SYSDATE, 2000, NULL, 40);
-- Ejercicio 2
CREATE OR REPLACE TRIGGER Pag20n2
	BEFORE INSERT
	ON emple
	FOR EACH ROW
DECLARE
	IDEmple NUMBER;
BEGIN
	SELECT MAX(emple_no)+1 INTO IDEmple from emple;
    :NEW.emple_no := IDEmple;
    :NEW.fecha_alt := SYSDATE; 
END;
/

INSERT INTO emple VALUES (9999, 'Cabrales', 'ANALISTA', 1, NULL, 1500, NULL, 40);

ALTER TABLE emple DISABLE ALL TRIGGERS;
-- Ejercicio 3
CREATE OR REPLACE TRIGGER Pag20n3
	BEFORE INSERT
	ON emple
	FOR EACH ROW
DECLARE
	IDEmple NUMBER;
BEGIN
	SELECT MAX(emple_no)+1 INTO IDEmple from emple;
    :NEW.emple_no := IDEmple;
    :NEW.fecha_alt := SYSDATE;

    SELECT DISTINCT emple_no INTO :NEW.dir
    from emple
    WHERE depart_no = IDEmple 
    AND oficio = 'DIRECTOR';
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay mas de un departamento con nombre');
END;
/

INSERT INTO emple VALUES (NULL, 'TARQUE', 'ANALISTA', NULL, NULL, 1500, NULL, 40);

-- Ejercicio 4

-- Ejercicio 5
-- Ejercicio 6
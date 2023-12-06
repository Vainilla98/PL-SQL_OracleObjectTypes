SET SERVEROUTPUT ON

-- Ejercicio 1
CREATE OR REPLACE TRIGGER EJ3_1
    BEFORE INSERT ON emple
    FOR EACH ROW
DECLARE
    salario NUMBER;
BEGIN
    SELECT MIN(salario)-1 INTO salario FROM emple WHERE depart_no = :new.depart_no;
    :new.comision := null;
    :new.salario := salario;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento '|| :new.depart_no);
END;
/

-- SHOW ERROR;

INSERT INTO emple VALUES (
    1,
    'Bravo',
    'EMPLEADO',
    1,
    NULL,
    5000,
    200,
    40
  );

-- ALTER TRIGGER EJ3_1 DISABLE;

-- Ejercicio 2

CREATE OR REPLACE TRIGGER EJ3_2
    BEFORE INSERT ON emple
    FOR EACH ROW
DECLARE
    ID NUMBER;
    Ofi VARCHAR2(40);
    depi NUMBER;
BEGIN
    SELECT depart_no INTO ID FROM depart WHERE dnombre = 'VENTAS';
    Ofi := :new.oficio;
    depi := :new.depart_no;
    IF (Ofi = 'VENDEDOR') THEN
        IF (depi = ID) THEN
            dbms_output.put_line('Empleado insertado con exito brotha');
        ELSE 
               RAISE_APPLICATION_ERROR(-20001, 'Los venededores solo pueden estar en ventas.');
        END IF;
    ELSE
        IF (depi = ID) THEN
               RAISE_APPLICATION_ERROR(-20002, 'Los normals no pueden estar en ventas.');
            ELSE
               dbms_output.put_line('Empleado insertado con exito brotha');
        END IF;
    END IF; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento Ventas');
END;
/

CREATE OR REPLACE TRIGGER EJ3_2_BIEN
    BEFORE INSERT
    OR UPDATE of oficio, depart_no
    ON emple
    FOR EACH ROW
DECLARE
    ID NUMBER;
    Ofi VARCHAR2(40);
    depi NUMBER;
BEGIN
    SELECT depart_no INTO ID FROM depart WHERE dnombre = 'VENTAS';
    Ofi := :new.oficio;
    depi := :new.depart_no;
    IF (Ofi = 'VENDEDOR') THEN
        IF (depi = ID) THEN
            dbms_output.put_line('Empleado insertado con exito brotha');
        ELSE 
               RAISE_APPLICATION_ERROR(-20001, 'Los venededores solo pueden estar en ventas.');
        END IF;
    ELSE
        IF (depi = ID) THEN
               RAISE_APPLICATION_ERROR(-20002, 'Los normals no pueden estar en ventas.');
            ELSE
               dbms_output.put_line('Empleado insertado con exito brotha');
        END IF;
    END IF; 
END;


INSERT INTO EMPLE VALUES(2,'Raya','BUROCRATA',7698,NULL,1200,100,30);

-- Ejercicio 3      -- ES para deletes y UPDATES, es prevenir
-- ALTER TRIGGER EJ3_3 ENABLE;

CREATE OR REPLACE TRIGGER EJ3_3
    BEFORE INSERT ON emple
    FOR EACH ROW
DECLARE
    jefe VARCHAR2(40);
    depi NUMBER;
    Ofi VARCHAR2(40);
BEGIN
    Ofi := :new.oficio;
    depi := :new.depart_no;
    IF ( Ofi != 'DIRECTOR' OR Ofi != 'PRESIDENTE') THEN
        SELECT apellido INTO jefe 
        from emple
        WHERE depart_no = depi 
        AND (oficio = 'DIRECTOR' OR oficio = 'PRESIDENTE');
        DBMS_OUTPUT.PUT_LINE('Empleado insertado con éxito');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Jefe insertado con éxito');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'El departamento '||depi ||' no tiene jefe aun.');
END;
/

-- DELETE FROM emple
-- WHERE depart_no = 90;

INSERT INTO EMPLE VALUES(3,'Manolo','EMPLEADO',3,SYSDATE,12,1222,90);

-- Ejercicio 4

CREATE OR REPLACE TRIGGER EJ3_4
    BEFORE INSERT ON emple
    FOR EACH ROW
DECLARE
    SumSalario NUMBER;
    SumComision NUMBER;
    fallo1 EXCEPTION;
    PRAGMA EXCEPTION_INIT(fallo1, -20005);
BEGIN
    SELECT SUM(nvl(salario,0)) INTO SumSalario 
    FROM emple WHERE depart_no = :new.depart_no;

    SELECT SUM(nvl(comision,0)) INTO SumComision 
    FROM emple WHERE depart_no = :new.depart_no;

    SumComision := SumComision + nvl(:new.comision,0);
    SumSalario := SumSalario + nvl(:new.salario,0);

    IF ( SumComision > SumSalario ) THEN
        RAISE_APPLICATION_ERROR(-20005, 'La suma de comisiones es mayor que la de salarios.');
    END IF; 
EXCEPTION
    WHEN fallo1 THEN
        RAISE_APPLICATION_ERROR(-20006, 'La suma de comisiones es mayor que la de salarios.');
END;
/


INSERT INTO EMPLE VALUES(3,'Raya','DIRECTOR',7839,SYSDATE,100,120,90);

ALTER TABLE emple DISABLE ALL TRIGGERS;


DELETE FROM emple
WHERE depart_no = 90;


CREATE OR REPLACE TRIGGER EJ3_4
	FOR UPDATE OF comision
	OR INSERT
	ON emple
	COMPOUND TRIGGER
-- Variables del tigger compuesto
    CURSOR salida IS 
    SELECT depart.depart_no, sum(salario) sumSalario , sum(comision) sumComision
    FROM emple RIGHT OUTER JOIN depart
    ON emple.depart_no = depart.depart_no
    GROUP BY depart.depart_no;
-- Ejecución normal, BEFORE EACH ROW, variables :NEW, :OLD son permitidas
BEFORE EACH ROW
IS
BEGIN
    FOR regDepart IN salida LOOP
        IF (regDepart.depart_no = :new.depart_no) THEN
            IF (nvl(regDepart.sumSalario,0) + nvl(:new.salario,0) < nvl(regDepart.sumComision,0) + nvl(:new.comision,0)) THEN
                raise_application_error(-20000,'La suma de las comsiones es demasiado alta');
            END IF;
        END IF; 
    END LOOP;
END BEFORE EACH ROW;
END;
/
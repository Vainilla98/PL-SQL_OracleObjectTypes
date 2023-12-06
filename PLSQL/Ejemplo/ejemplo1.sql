CREATE TABLE AVISOS (
	Ejercicio NUMBER,
    Mensaje VARCHAR2(100),
    fecha DATE
);

-- Ejercicio 1
DECLARE
  codEmple NUMBER;
BEGIN
    SELECT max(nvl(emple_no,0))+10 INTO codEmple from emple; 
    INSERT INTO emple(emple_no,depart_no) VALUES (codEmple,&ID_Departamento);
    INSERT INTO AVISOS VALUES (1,'Empleado insertado con exito',SYSDATE);
END;
-- Ejercicio 2
CREATE OR REPLACE PROCEDURE Ej2
AS
	minSalario NUMBER;
BEGIN
	SELECT min(salario)*3 INTO minSalario FROM emple;
    dbms_output.put_line(minSalario||'. Hay que bajarle el sueldo: ');
    FOR regEmple IN (SELECT apellido, salario FROM emple) LOOP
        IF (regEmple.salario > minSalario) THEN
            dbms_output.put_line(regEmple.apellido);
            -- INSERT INTO AVISOS VALUES (1,regEmple.apellido,SYSDATE);
        END IF;  
    END LOOP;
END;
/

EXECUTE Ej2
-- Ejercicio 3
CREATE OR REPLACE PROCEDURE Ej3
AS
	maxSalario NUMBER;
BEGIN
	SELECT max(salario)/3 INTO maxSalario FROM emple;
    dbms_output.put_line(maxSalario||'. Hay que subirle el sueldo: ');
    FOR regEmple IN (SELECT apellido, salario FROM emple) LOOP
        IF (regEmple.salario < maxSalario) THEN
            dbms_output.put_line(regEmple.apellido ||' -> '||regEmple.salario);
            -- INSERT INTO AVISOS VALUES (1,regEmple.apellido ||' -> '||regEmple.salario,SYSDATE);
        END IF;  
    END LOOP;
END;
/

EXECUTE Ej3

-- Ejercicio 4
/*
 FLASE -> SI LA INCUMPLE
 TRUE -> SI LA CUMPLE
*/
/*CREATE OR REPLACE FUNCTION normativa (ID IN NUMBER)
RETURN BOOLEAN
AS
	minSalario NUMBER;
	maxSalario NUMBER;
    salarioE NUMBER;
    IDd NUMBER;
BEGIN
    SELECT depart_no INTO IDd FROM emple WHERE emple_no = ID;
    SELECT max(salario)/3 INTO maxSalario FROM emple WHERE depart_no = IDd;
    SELECT min(salario)*3 INTO minSalario FROM emple WHERE depart_no = IDd;
    DBMS_OUTPUT.PUT_LINE('MIN: '||minSalario ||'| MAX: '||maxSalario);
    SELECT salario INTO salarioE FROM emple WHERE emple_no = ID;
	IF (minSalario < salarioE AND maxSalario > salarioE) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe el empleado '|| ID);
        RETURN FALSE;
END;
/*/

CREATE OR REPLACE FUNCTION normativa (ID IN NUMBER)
RETURN BOOLEAN
AS
	minSalario NUMBER;
	maxSalario NUMBER;
    salarioE NUMBER;
    IDd NUMBER;
BEGIN
    SELECT depart_no INTO IDd FROM emple WHERE emple_no = ID;
    SELECT max(salario)/3 INTO maxSalario FROM emple WHERE depart_no = IDd;
    SELECT min(salario)*3 INTO minSalario FROM emple WHERE depart_no = IDd;
     DBMS_OUTPUT.PUT_LINE('MIN: '||minSalario ||'| MAX: '||maxSalario);
    SELECT nvl(salario,0) INTO salarioE FROM emple WHERE emple_no = ID;
	IF (minSalario < salarioE OR maxSalario > salarioE) THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe el empleado '|| ID);
        RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION normativa (ID IN NUMBER)
RETURN BOOLEAN
AS
	maxSalario NUMBER;
    salarioE NUMBER;
    IDd NUMBER;
BEGIN
    SELECT depart_no INTO IDd FROM emple WHERE emple_no = ID;
    SELECT max(salario)/3 INTO maxSalario FROM emple WHERE depart_no = IDd;
    DBMS_OUTPUT.PUT_LINE('max: '||maxSalario);
    SELECT nvl(salario,0) INTO salarioE FROM emple WHERE emple_no = ID;
	IF (maxSalario < salarioE) THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe el empleado '|| ID);
        RETURN FALSE;
END;
/


EXECUTE dbms_output.put_line(sys.diutil.bool_to_int(normativa(7839)));

CREATE OR REPLACE PROCEDURE Ej4
AS
    res BOOLEAN;
BEGIN
    dbms_output.put_line('Hay que cambiar el sueldo: ');
    FOR regEmple IN (SELECT emple_no, nvl(salario,0) salario, apellido FROM emple) LOOP
        res := normativa(regEmple.emple_no);
        IF ( res = false ) THEN
            dbms_output.put_line(regEmple.apellido ||' -> '||regEmple.salario);
            -- INSERT INTO AVISOS VALUES (1,regEmple.apellido,SYSDATE);
        END IF;  
    END LOOP;
END;
/


EXECUTE Ej4
-- Ejercicio 5
CREATE OR REPLACE TRIGGER difenreciaSalario
	FOR INSERT
	OR UPDATE OF salario
	ON emple
	COMPOUND TRIGGER
-- Variables del tigger compuesto
    CURSOR salida IS 
    SELECT depart_no, max(salario)*3 minSalario , min(salario) maxSalario
    FROM emple
    GROUP BY depart_no;

-- Ejecución normal, BEFORE EACH ROW, variables :NEW, :OLD son permitidas
BEFORE EACH ROW IS
BEGIN
	FOR regDepart IN salida LOOP
        IF (regDepart.depart_no = :new.depart_no) THEN
            IF ( ) THEN
                rais_application_eerror(-20000,'La suma de las comsiones es demasiado alta');
            ELSE

            END IF;
            EXIT;
        END IF; 
    END LOOP;
END BEFORE EACH ROW;
END;
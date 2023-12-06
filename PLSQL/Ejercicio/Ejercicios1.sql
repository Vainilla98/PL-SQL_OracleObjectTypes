SET SERVEROUTPUT ON

-- Ejercicio 1 [1]
CREATE OR REPLACE FUNCTION obtenerID (nombre IN VARCHAR2)
RETURN VARCHAR2
AS
    e_excepcion_largo EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_excepcion_largo, -12899);
    depart_ID depart.depart_no%type;
BEGIN
    SELECT depart_no INTO depart_ID FROM depart WHERE LOWER(dnombre) = LOWER(nombre);
    RETURN depart_ID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento '|| nombre);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay mas de un departamento con nombre');
    WHEN e_excepcion_largo THEN
        DBMS_OUTPUT.PUT_LINE('Hay mas demasiado largo el ID introducido');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Codigo:'||SQLCODE);
        DBMS_OUTPUT.put_line(SQLERRM);
END;
/

-- EXECUTE dbms_output.put_line(obtenerID('DSA'));
-- Ejercicio 2 [1]
-- SHOW ERRORs

CREATE OR REPLACE PROCEDURE muestraEmpleados (nombre IN VARCHAR2) 
AS
    e_excepcion_largo EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_excepcion_largo, -12899);
    ID NUMBER;
    CURSOR nombres (n depart.depart_no%TYPE) IS SELECT apellido FROM emple WHERE depart_no = n;
BEGIN
    ID := mostrarEmpleados(nombre); -- No utilizaste la funcion el ejercicio anterior
    FOR regEmple IN nombres(ID) LOOP
         dbms_output.put_line(regEmple.apellido);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento '|| depart_ID);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay mas de un departamento con nombre');
    WHEN e_excepcion_largo THEN
        DBMS_OUTPUT.PUT_LINE('Hay mas demasiado largo el ID introducido');
END;
/

-- EXECUTE muestraEmpleados('CONTABILIDAD')

-- Ejercicio 3 []
CREATE OR REPLACE FUNCTION sumaSalario (nombre IN VARCHAR2)
RETURN NUMBER
AS
    SalarioT NUMBER;
    ID NUMBER;
BEGIN
     SELECT depart_no INTO ID from depart WHERE LOWER(dnombre) = LOWER(nombre);
     SELECT SUM(salario+NVL(comision,0)) INTO SalarioT FROM emple WHERE depart_no = ID;
     IF (SalarioT IS NULL) THEN
        SalarioT := 0; -- Si no existe el departamento o no tiene empleados la suma del salario será de 0
     END IF; 
     RETURN SalarioT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento de '|| nombre);
END;
/

BEGIN
    dbms_output.put_line(sumaSalario('RRHH')||'€');
END;
/
-- Ejercicio 4

CREATE OR REPLACE PROCEDURE calculaSalarios 
AS
    CURSOR departamentos IS SELECT dnombre FROM depart;
BEGIN
    FOR nombre IN departamentos LOOP
         dbms_output.put_line(nombre.dnombre ||'-> '||sumaSalario(nombre.dnombre)||'€');
    END LOOP;
END;

-- EXECUTE calculaSalarios

-- Ejercicio 5

CREATE OR REPLACE PROCEDURE modificarLoc (nombre IN VARCHAR2, locali IN VARCHAR2)
AS
BEGIN
    UPDATE depart
    SET loc = locali
    WHERE dnombre = nombre;

    DBMS_OUTPUT.PUT_LINE('Se han modificado ' || SQL%ROWCOUNT || ' departamentos con el nombre de '||nombre);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento '|| nombre);
END;

-- EXECUTE modificarLoc('Mafia2','Napoli')
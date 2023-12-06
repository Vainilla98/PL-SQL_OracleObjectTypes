-- Ejercicio 1
DECLARE
    NumEmpleados NUMBER(5) := &NumeroEmpleado;
    num NUMBER(5);
BEGIN
    SELECT emple_no into num
    FROM emple 
    WHERE emple_no = NumEmpleados;

	UPDATE emple
    SET salario = salario * 1.10
    WHERE emple_no = NumEmpleados;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('El empleado no existe');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay varios empleados con el mismo apellido');
END;
/

INSERT INTO EMPLE VALUES(2,'Moncayo','EMPLEADO',1,sysdate,1000,NULL,40);


DECLARE
    ApeEmpleados VARCHAR(20) := '&ApellidoEmpleado'; -- Moncayo
    Ape VARCHAR(20);
BEGIN
    SELECT apellido into Ape
    FROM emple 
    WHERE apellido = ApeEmpleados;

	UPDATE emple
    SET salario = salario * 1.10
    WHERE emple_no = ApeEmpleados;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('El empleado no existe');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay varios empleados con el mismo apellido');
END;
/
-- Ejercicio 2
CREATE TABLE TEMP (
    ErrorLog VARCHAR2(100)
);

-- INSERT INTO depart VALUES (50, 'SeguridadDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD','El TobosoEl TobosoEl TobosoEl TobosoEl TobosoEl TobosoEl TobosoEl Toboso')

DECLARE
    e_excepcion_largo EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_excepcion_largo, -12899);
    ID NUMBER(5) := &CodDepartamento; 
    Nom VARCHAR2(255) := '&Nombre'; 
    Poblacion VARCHAR2(255) := '&Localidad'; 
    -- ID2 NUMBER(5);
    err_msg VARCHAR2(255);
    err_msg NUMBER;
BEGIN
    INSERT INTO depart VALUES (ID, Nom, Poblacion);
EXCEPTION
	WHEN e_excepcion_largo THEN
        INSERT INTO TEMP VALUES('Texto mas largo que lo permitido');
    WHEN DUP_VAL_ON_INDEX THEN
        INSERT INTO TEMP VALUES('Ya hay un id '||ID||' en depart');
    WHEN OTHERS THEN
        err_msg := SQLERRM;
        err_num := SQLCODE;
        INSERT INTO TEMP VALUES(err_num|| ': ' || err_msg);
END;


DECLARE -- Due punto zero 
    e_excepcion_largo EXCEPTION;
    nombre_repe EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_excepcion_largo, -12899);
    ID NUMBER(5) := &CodDepartamento; 
    Nom VARCHAR2(255) := '&Nombre'; 
    Poblacion VARCHAR2(255) := '&Localidad'; 
    Deparo VARCHAR2(40); 
    err_msg VARCHAR2(255);
    err_num NUMBER;
BEGIN
    BEGIN
        SELECT dnombre into Deparo from depart WHERE dnombre = Nom; -- Si no esta el departamento "Nom" da NO_DATA_FOUND
        RAISE nombre_repe;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('');
    END;
    INSERT INTO depart VALUES (ID, Nom, Poblacion);
EXCEPTION
	WHEN e_excepcion_largo THEN
        INSERT INTO TEMP VALUES('Texto mas largo que lo permitido');
    WHEN nombre_repe THEN
        INSERT INTO TEMP VALUES('Ya existe un departamento con el nombre '|| Nom);
    WHEN DUP_VAL_ON_INDEX THEN
        INSERT INTO TEMP VALUES('Ya hay un id '||ID||' en depart');
    WHEN OTHERS THEN
        err_msg := SQLERRM;
        err_num := SQLCODE;
        INSERT INTO TEMP VALUES(err_num|| ': ' || err_msg);
END;

DROP TABLE TEMP

SELECT object_name, object_type 
FROM USER_OBJECTS
WHERE object_type IN ('PROCEDURE' , 'FUNCTION')


SELECT text 
FROM USER_SOURCE
WHERE type = 'PROCEDURE'
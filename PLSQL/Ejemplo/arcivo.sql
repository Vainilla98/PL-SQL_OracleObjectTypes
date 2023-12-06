SET SERVEROUTPUT ON

DECLARE
    V_MIVARIABLE VARCHAR(20):='Hola Mundo';
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_MIVARIABLE);
    DBMS_OUTPUT.PUT_LINE('FIN DEL PROGRAMA');
END;
/

DECLARE
    V_NUM1 NUMBER(4,2):=10.22;
    V_NUM2 NUMBER(4,2):=20.1;
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_NUM1);
    DBMS_OUTPUT.PUT_LINE('LA SUMA ES: ' ||TO_CHAR(V_NUM1+V_NUM2));
END;
/

DECLARE
    nombre VARCHAR2(20):= '&Apellido';
BEGIN
    INSERT INTO emple (emple_no,apellido, fecha_alt,depart_no) VALUES (
        (SELECT max(emple_no)+1 from emple),
        nombre,
        sysdate,
        (SELECT depart_no FROM depart WHERE lower(loc)='bilbao')
    );
END;
/

SET autocommit OFF


DECLARE
    depart_ID depart.depart_no%type := 10;
BEGIN
    LOOP
        BEGIN
            SAVEPOINT inicio;
            INSERT INTO depart VALUES (
                depart_ID,
                'PROGAMACION',
                'VALDEPEÑAS'
            );
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Departamento '||depart_ID||' insertado.');
            EXIT;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                ROLLBACK TO inicio;
                DBMS_OUTPUT.PUT_LINE('Departamento '||depart_ID||', duplicado.');
                depart_ID := depart_ID + 10;
        END;
    END LOOP;
END;
/

SET autocommit ON

SHOW ERROR;
CREATE OR REPLACE PROCEDURE listarCiean AS
BEGIN
    FOR i IN 0..100 LOOP 
        dbms_output.put_line(i);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE tablaMultiplicar (num in NUMBER) AS
BEGIN
    FOR i IN 0..10 LOOP 
        dbms_output.put_line(num ||'x'||i||'= '||(num*i));
    END LOOP;
END;
/


EXECUTE tablaMultiplicar(45)

EXECUTE listarCiean();

CREATE OR REPLACE PROCEDURE generar10 (inicio in NUMBER, fin in NUMBER) AS
BEGIN
    FOR i IN inicio..fin LOOP 
        dbms_output.put_line('TABLA DE '||i);
        tablaMultiplicar(i);
        dbms_output.put_line(' ');
    END LOOP;
END;
/

EXECUTE generar10(31214,41452);


/* Prodedimiesnto muestraEmpleados1 que muestre los apellidos de los empleadso*/

CREATE OR REPLACE PROCEDURE muestraEmpleados1 () 
AS
    CURSOR apellidos IS SELECT apellido form emple;
    Ape emple.apellido%type;
BEGIN
    OPEN apellidos;
    LOOP
        FETCH apellidos INTO Ape;
        EXIT WHEN apellidos%NOTFOUND;
        dbms_output.put_line(Ape);
    END LOOP;
END;
/

EXECUTE muestraEmpleados1(31214,41452);


-- **** CURSORES ****
-- Forma 1
CREATE OR REPLACE PROCEDURE sacaInfo
AS
    CURSOR salida IS SELECT apellido, oficio, depart_no FROM emple ORDER BY depart_no;
    regEmple salida%ROWTYPE;
BEGIN
    OPEN salida;
    LOOP 
        FETCH salida INTO regEmple;
        EXIT WHEN salida%NOTFOUND;
        dbms_output.put_line(regEmple.apellido || ', ' ||regEmple.oficio || '-> ' ||regEmple.depart_no);
    END LOOP;
    CLOSE salida;
END;

EXECUTE sacaInfo
-- Forma 2
CREATE OR REPLACE PROCEDURE sacaInfo2
AS
    CURSOR salida IS SELECT apellido, oficio, depart_no FROM emple ORDER BY depart_no;
    regEmple salida%ROWTYPE;
BEGIN
    OPEN salida;
    FETCH salida INTO regEmple;
    WHILE salida%FOUND LOOP
        dbms_output.put_line(regEmple.apellido || ', ' ||regEmple.oficio || '-> ' ||regEmple.depart_no);
        FETCH salida INTO regEmple;
    END LOOP;
    CLOSE salida;
END;

EXECUTE sacaInfo2

-- Forma 3
CREATE OR REPLACE PROCEDURE sacaInfo3
AS
    CURSOR salida IS SELECT apellido, oficio, depart_no FROM emple ORDER BY depart_no;
BEGIN
    FOR regEmple IN salida LOOP
         dbms_output.put_line(regEmple.apellido || ', ' ||regEmple.oficio || '-> ' ||regEmple.depart_no);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE sacaInfo3_2 (num IN NUMBER)
AS
    CURSOR salida (n depart.depart_no%TYPE) IS SELECT apellido, oficio, depart_no FROM emple WHERE depart_no = n ORDER BY depart_no;
BEGIN
    FOR regEmple IN salida(num) LOOP
         dbms_output.put_line(regEmple.apellido || ', ' ||regEmple.oficio || '-> ' ||regEmple.depart_no);
    END LOOP;
END;
/

EXECUTE sacaInfo3_2(20)


-- PDF Pag 69
CREATE OR REPLACE FUNCTION sumarSalario (num IN NUMBER) 
RETURN NUMBER
AS
    SalarioT NUMBER := 0;
    CURSOR salida IS SELECT apellido, oficio, salario FROM emple WHERE depart_no = num;
BEGIN
     FOR regEmple IN salida LOOP
         dbms_output.put_line(regEmple.apellido || ', ' ||regEmple.oficio || '-> ' ||regEmple.salario||'€');
         SalarioT := SalarioT + regEmple.salario;
    END LOOP;
    RETURN SalarioT;
END;
/

EXECUTE dbms_output.put_line('El TOTAL es: '||sumarSalario(20)||'€')


CREATE OR REPLACE TRIGGER pruebaTG1
    AFTER DELETE ON prueba
BEGIN
    dmbs_output.put_line('Registo Borrado');
END;
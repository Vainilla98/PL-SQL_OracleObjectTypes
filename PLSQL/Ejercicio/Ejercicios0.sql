
SET SERVEROUTPUT ON
-- Ejercicio 1 [0.75]
DECLARE
    num1 NUMBER(2):=12;
    num2 NUMBER(2):=12;
BEGIN
    IF (num1 > num2) THEN
        DBMS_OUTPUT.PUT_LINE('El numero 1 es mas grande que el 2');
    ELSIF num1 = num2 THEN
        DBMS_OUTPUT.PUT_LINE('Son iguales');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El numero 2 es mas grande que el 1');
    END IF;
END;
/
-- Ejercicio 2 [1]
DECLARE
    num1 NUMBER(2):=8;
    num2 NUMBER(2):=4;
    opreacion VARCHAR2(10):='sa';
BEGIN
    CASE opreacion
        WHEN 'suma' THEN
            DBMS_OUTPUT.PUT_LINE(num1 ||' + '||num2 ||' ='||(num1+num2));
        WHEN 'resta' THEN
            DBMS_OUTPUT.PUT_LINE(num1 ||' - '||num2 ||' ='||(num1-num2));
        WHEN 'producto' THEN
            DBMS_OUTPUT.PUT_LINE(num1 ||' * '||num2 ||' ='||(num1*num2));
        ELSE
             DBMS_OUTPUT.PUT_LINE('OPERACION NO PERMITIDA');
    end CASE;
END;
/

-- Ejercicio 1 [2]

BEGIN
    FOR i IN 2..98 LOOP
        IF (mod(i,2)=0) THEN
            dbms_output.put_line(i);
        END IF;
    END LOOP;
END;
/

BEGIN
    FOR i IN 2..98 BY 2 LOOP
        
    END LOOP;
END;
/

DECLARE
    i NUMBER(3):= 98;
BEGIN
    WHILE i >= 0 LOOP 
        dbms_output.put_line(i);
        i := i -1;
    END LOOP;
END;
/
-- Ejercicio 2 [1]
BEGIN
    FOR i IN 0..10 LOOP 
    dbms_output.put_line(' ');
    dbms_output.put_line('Tabla de '|| i);
    dbms_output.put_line('===================');
        FOR j IN 1..10 LOOP 
            dbms_output.put_line(i ||' x '|| j || ' =' || (i*j));
        END LOOP;
    END LOOP;
END;
/



-- Ejercico 1 []
DECLARE
BEGIN
    UPDATE emple
    SET salario = salario * 1.15
    WHERE comision > 500 AND oficio = 'VENDEDOR';

    SELECT count(*) INTO contador
    FROM emple
    WHERE comision > 500 AND oficio = 'VENDEDOR';

    IF contador > 3 THEN
        dbms_output.put_line("Cambios descartados")
        ROLLBACK;
    ELSE
        dbms_output.put_line("Cambios realizados")
        COMMIT;
END;
/
-- Ejercico 2 []
CREATE TABLE TEMP (
    num NUMBER(3),
    categoria VARCHAR(6)
);

BEGIN
  FOR i IN 1..100 LOOP
    IF MOD(i,2) = 0 THEN
      INSERT INTO TEMP VALUES (i, 'par');
    ELSE
      INSERT INTO TEMP VALUES (i, 'impar');
    END IF;
  END LOOP;
END;
/

DROP TABLE TEMP;
-- Ejercico 3 []
BEGIN
    SELECT SUM(salario+comision)
    FROM emple

    SELECT count(*)
    FROM emple
    WHERE salario > 2000;
END;
/

-- Ejercico 4 []
DECLARE
    i NUMBER(2);
    nombre VARCHAR2(20);
BEGIN
    SELECT max(depart_No)+10 INTO i
    FROM emple;

    nombre := '&NombreDepartamento';
    INSERT INTO depart VALUES (i, nombre, NULL);
END;
/
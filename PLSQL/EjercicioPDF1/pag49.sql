-- Ejercicio 1
CREATE OR REPLACE FUNCTION maximo (n1 IN NUMBER, n2 IN NUMBER)
RETURN NUMBER
AS
BEGIN
	IF n1 > n2 THEN
		RETURN n1;
    ELSIF n2 > n1 THEN
        RETURN n2;
    ELSE
        RETURN n1;
	END IF;
END;
/

show ERRORS;

DECLARE
    n1 NUMBER := &Numero1;
    n2 NUMBER := &Numero2;
BEGIN
    dbms_output.put_line('El maximo de '||n1||' y '||n2||' es: '||maximo(n1,n2));
END;
/
-- Ejercicio 2

CREATE OR REPLACE FUNCTION multiplo (n1 IN NUMBER, n2 IN NUMBER)
RETURN BOOLEAN
AS
    numero NUMBER;
BEGIN
    FOR i IN 0..n1 LOOP 
        numero :=  n2 * i;
        IF (numero = n1) THEN
		    RETURN true;
        END IF;
    END LOOP;
    RETURN FALSE;
END;
/

DECLARE
    n1 NUMBER := &Numero1;
    n2 NUMBER := &Numero2;
    res BOOLEAN;
BEGIN
    IF (multiplo(n1,n2)) THEN
        dbms_output.put_line(n1||' es multiplo de '||n2);
    ELSE
        dbms_output.put_line(n1||' no es multiplo de '||n2);
    END IF;
END;
/
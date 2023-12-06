-- Ejercicio 1
CREATE OR REPLACE FUNCTION cuentaEmpleados (num IN NUMBER)
RETURN NUMBER
AS
    total NUMBER;
BEGIN
    SELECT count(*) into total FROM emple  WHERE depart_no = num GROUP BY depart_no;
    RETURN total;
END;
/
-- show ERRORS;

EXECUTE dbms_output.put_line(cuentaEmpleados(20)) ;
-- Ejercicio 2

CREATE OR REPLACE PROCEDURE insertDepart (nombre IN VARCHAR2, localidad IN VARCHAR2) 
AS
    ID NUMBER;
BEGIN
   SELECT max(depart_no)+10 into ID from depart;
   INSERT INTO depart VALUES (ID,nombre,localidad);
   IF sql%rowcount > 0 THEN
       dbms_output.put_line('Se han insertdo '||sql%rowcount||' registros.');
   END IF;
END;
/

EXECUTE insertDepart('Mafia2','VillaRobledo');
INSERT UBF
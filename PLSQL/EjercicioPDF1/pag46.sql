-- Ejercicio 1
CREATE OR REPLACE PROCEDURE numerosHastaX (num IN NUMBER) AS
BEGIN
    FOR i IN 0..num LOOP 
        dbms_output.put_line(i);
    END LOOP;
END;
/

DECLARE
    nom NUMBER := &Numero;
BEGIN
    numerosHastaX(nom);
END;
/
-- Ejercicio 2
CREATE OR REPLACE PROCEDURE dividir (dividendo IN NUMBER, divisor IN NUMBER, cociente OUT NUMBER, resto OUT NUMBER) 
AS
BEGIN
    cociente := TRUNC(dividendo/divisor) ;
    resto := MOD(dividendo, divisor);
END;
/

CREATE OR REPLACE PROCEDURE dividir2 (dividendo IN OUT NUMBER, divisor IN OUT NUMBER) 
AS
    aux NUMBER;
BEGIN
    aux := dividendo;
    dividendo := TRUNC(aux/divisor);
    divisor := MOD(aux, divisor);
END;
/
-- Ejercicio 3
DECLARE
 p1 number;
 p2 number;    
BEGIN
   dividir(&dividendo,&divisor, p1, p2);
   dbms_output.put_line('Cociente: '||p1);
   dbms_output.put_line('Resto: '||p2);
END;
/

DECLARE
    dividendo NUMBER := &dividendo;
    divisor NUMBER := &divisor;
BEGIN
   dividir2(dividendo,divisor);
   dbms_output.put_line('Cociente: '||dividendo);
   dbms_output.put_line('Resto: '||divisor);
END;
/
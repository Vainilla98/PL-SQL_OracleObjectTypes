SET SERVEROUTPUT ON

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

-- Ejercicio 6
SHOW ERROR
CREATE OR REPLACE PROCEDURE mostrarIniciales (nombre IN VARCHAR2) 
AS
    ID NUMBER;
    CURSOR nombres (n depart.depart_no%TYPE) IS SELECT apellido FROM emple WHERE depart_no = n;
BEGIN
    ID := obtenerID(nombre);
    FOR regEmple IN nombres(ID) LOOP
         dbms_output.put_line(substr(regEmple.apellido,1,3));
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento '|| nombre);
END;
/

EXECUTE mostrarIniciales('VENTAS')
-- Ejercicio 7 ???? Las funciones para que
CREATE OR REPLACE PROCEDURE potencia (base IN NUMBER, exponente IN NUMBER)
AS
    total NUMBER(9,3) := 1;
BEGIN
    IF (base = 0) THEN
        DBMS_OUTPUT.PUT_LINE('Datos incorrectos');
    ELSIF (base = 0 AND exponente = 0) THEN
        DBMS_OUTPUT.PUT_LINE('Datos incorrectos');
    ELSIF (exponente = 0) THEN
        DBMS_OUTPUT.PUT_LINE('1');
    ELSIF (exponente > 0) THEN
        FOR i IN 1..exponente LOOP
            total := total * base;
            dbms_output.put_line(total);
        END LOOP;
    ELSE
        dbms_output.put_line('Hail');
        FOR i IN 1..ABS(exponente) LOOP
            total := total * (1 / base);
            dbms_output.put_line(total);
        END LOOP;
    END IF; 
END;
/
EXECUTE potencia(2,-4);
-- Ejercicio 8
CREATE OR REPLACE PROCEDURE mostarJefes (nombre IN VARCHAR2) 
AS
    ID NUMBER;
    vacio EXCEPTION;
    PRAGMA EXCEPTION_INIT(vacio, -06503);
    CURSOR nombres (n depart.depart_no%TYPE) IS 
        SELECT DISTINCT j.apellido 
        FROM emple j INNER JOIN emple e
        ON j.emple_no = e.dir
        WHERE j.depart_no = n;
BEGIN
    ID := obtenerID(nombre);
    FOR regEmple IN nombres(ID) LOOP
         dbms_output.put_line(regEmple.apellido);
    END LOOP;
EXCEPTION
    WHEN vacio THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento '|| nombre);
END;
/

EXECUTE mostrarIniciales('df');
-- Ejercicio 9
CREATE OR REPLACE PROCEDURE mostrarVendedoresComisiones () 
AS
    CURSOR salida IS 
        SELECT DISTINCT apellido
        FROM emple
        WHERE oficio = 'VENDEDOR'
        ORDER BY nvl(comision,0) DESC
        FETCH first 2 row only;
BEGIN
    FOR regEmple IN salida LOOP
         dbms_output.put_line(regEmple.apellido);
    END LOOP;
END;
/
-- Ejercicio 10
CREATE OR REPLACE FUNCTION reversa (nombre IN VARCHAR2)
RETURN VARCHAR2
AS
    nombreReve depart.dnombre%type := '';
    j NUMBER;
BEGIN
    j := length(nombre);
  
    FOR i IN REVERSE 1..j LOOP          
        nombreReve := nombreReve || substr(nombre, i, 1);
    END LOOP;
    RETURN nombreReve;
END;
/

EXECUTE dbms_output.put_line(reversa('airtsuA'));
-- Ejercicio 11
CREATE OR REPLACE PROCEDURE mostrarEmpleadosReve (nombre IN VARCHAR2) 
AS
    vacio EXCEPTION;
    PRAGMA EXCEPTION_INIT(vacio, -06503);
    ID NUMBER;
    nombreReve depart.dnombre%type;
    CURSOR nombres (n depart.depart_no%TYPE) IS SELECT apellido FROM emple WHERE depart_no = n;
BEGIN
    nombreReve := reversa(nombre);
    ID := obtenerID(nombreReve);
    FOR regEmple IN nombres(ID) LOOP
         dbms_output.put_line(regEmple.apellido);
    END LOOP;
EXCEPTION
    WHEN vacio THEN
        DBMS_OUTPUT.PUT_LINE('No existe departamento '|| nombreReve);
END;
/

EXECUTE mostrarEmpleadosReve('satnev');
-- Ejercicio 12
CREATE OR REPLACE PROCEDURE borrarEmpleadosJovenes
AS
    num NUMBER := 10;
    maxDepart NUMBER;
    CURSOR nombres (n depart.depart_no%TYPE) IS 
        SELECT apellido
        FROM emple 
        WHERE depart_no = n
        ORDER BY fecha_alt DESC
        FETCH FIRST 2 ROW ONLY
    FOR UPDATE;
BEGIN
    SELECT MAX(depart_no) INTO maxDepart FROM depart;

    -- WHILE SQL%ROWCOUNT > 0 LOOP
    WHILE num <= maxDepart LOOP
        FOR regEmple IN nombres(num) LOOP
            DELETE FROM emple
            WHERE CURRENT OF nombres;
        END LOOP;
        num := num + 10; 
    END LOOP;
END;
/

EXECUTE borrarEmpleadosJovenes;
-- Ejercicio 13
CREATE OR REPLACE PROCEDURE mostrarproductos
AS
    CURSOR prove IS SELECT proveedor FROM productos;
    CURSOR produc (p productos.proveedor%TYPE) IS 
        SELECT codigoproducto, nombre, SUM(cantidad) cantidadT
        FROM productos NATURAL JOIN detallepedidos
        WHERE proveedor = p
        GROUP BY codigoproducto, nombre
        ORDER BY SUM(cantidad);
BEGIN
    FOR RegProvedor IN prove LOOP
        DBMS_OUTPUT.PUT_LINE(chr(10)||'        PROVEEDOR '|| upper(RegProvedor.proveedor));
        DBMS_OUTPUT.PUT_LINE('+ -------------------------------------------------------------------------- +');
        DBMS_OUTPUT.PUT_LINE(RPAD('CODIGO', 10, ' ') ||'| '|| RPAD('NOMBRE', 55, ' ') ||'| '|| 'CANTIDAD'||chr(10));
        FOR RegProduct IN produc(RegProvedor.proveedor) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(RegProduct.codigoproducto, 10, ' ')  || RPAD(RegProduct.nombre, 66, ' ') || RegProduct.cantidadT);
        END LOOP;
    END LOOP;
END;
/

EXECUTE mostrarproductos;
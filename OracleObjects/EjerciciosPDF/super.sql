-- Ejercicio 1
CREATE or replace TYPE tDireccion as OBJECT (
	CP varchar2(5),
	direccion varchar2(40)
);
/
-- Ejercicio 2
CREATE or replace TYPE tContacto as OBJECT (
	tlf varchar2(9),
	mail varchar2(40)
);
/
-- Ejercicio 3
CREATE or replace TYPE tPersona8 as OBJECT (
	Id number,
	Nombre varchar2(20),
    apellido varchar2(40),
    direccion tDireccion,
    contacto tContacto
) NOT final;
/
-- Ejercicio 4
CREATE or replace TYPE tCliente UNDER tPersona8 (
	Puntos number
);
/
-- Ejercicio 5
CREATE or replace TYPE tArticulo as OBJECT (
	Id number,
	Nombre varchar2(20),
    Precio number(9,2)
);
/
CREATE TABLE articulos OF tArticulo;

INSERT INTO articulos VALUES (tArticulo(1,'Churrascos',8.32));
INSERT INTO articulos VALUES (tArticulo(2,'Chorizos',3.49));
INSERT INTO articulos VALUES (tArticulo(3,'Morzillas',3.23));
INSERT INTO articulos VALUES (tArticulo(4,'Secretos Ibericos',10.45));
INSERT INTO articulos VALUES (tArticulo(5,'Chuletario',19.99));
INSERT INTO articulos VALUES (tArticulo(6,'Paletillas',9.32));
-- Ejercicio 6
CREATE or replace TYPE tDetalleCompra as OBJECT (
    articulo REF tArticulo,
	cantidad number
);
/

CREATE TYPE listaDetalleCompra as TABLE OF tDetalleCompra;  

CREATE or replace TYPE tListaCompra as OBJECT (
	Id number,
	Fecha DATE,
    cliente REF tCliente,
    compra listaDetalleCompra,

    MEMBER FUNCTION calcTotal return NUMBER 
);
/

CREATE OR REPLACE TYPE body tListaCompra as 
    MEMBER FUNCTION calcTotal RETURN NUMBER IS
        total number(9,2) := 0;
        precio number(9,2);
    BEGIN 
        FOR i IN compra.FIRST .. compra.LAST LOOP
            SELECT DEREF(compra(i).articulo).precio into precio FROM dual;
            total := total + compra(i).cantidad * precio; 
        END LOOP;
        RETURN total;
    END; 
END;
/
-- Ejercicio 7
CREATE TABLE clientes OF tCliente;
INSERT INTO clientes VALUES (tCliente(1,'Manolo','Garcia',tDireccion('13300','C/ La Gloriosa, 4'),tContacto('123456789','manolo@manolox.com'),5));
INSERT INTO clientes VALUES (tCliente(2,'Enrique','Bunbury',tDireccion('13301','C/ Gneral Prim, 5'),tContacto('234567890','Enrique@manolox.com'),10));

-- Ejercicio 8
CREATE TABLE compras OF tListaCompra NESTED TABLE compra STORE as tablaListaCompra;

INSERT INTO compras VALUES ( 1, TO_DATE('14-05-2023','DD/MM/YYYY'),
    (
        SELECT ref(t)
        FROM clientes t
        WHERE id = 1
    ), listaDetalleCompra (
        (
            SELECT tDetalleCompra(ref(t), 4)
            FROM articulos t
            WHERE id = 1 
        ),
        (
            SELECT tDetalleCompra(ref(t), 1)
            FROM articulos t
            WHERE id = 2
        ),
        (
            SELECT tDetalleCompra(ref(t), 2)
            FROM articulos t
            WHERE id = 4
        )
    )
);

INSERT INTO compras VALUES (2, sysdate,
    (
        SELECT ref(t)
        FROM clientes t
        WHERE id = 2
    ), listaDetalleCompra (
        (
            SELECT tDetalleCompra(ref(t), 2)
            FROM articulos t
            WHERE id = 3
        ),
        (
            SELECT tDetalleCompra(ref(t), 3)
            FROM articulos t
            WHERE id = 5
        ),
        (
            SELECT tDetalleCompra(ref(t), 6)
            FROM articulos t
            WHERE id = 6
        )
    )
);

-- Ejercicio 9
SELECT compra(1) FROM compras;


CREATE OR REPLACE PROCEDURE muestraDatos
AS
    cliente tCliente;
    articulo tArticulo;
    total NUMBER;
BEGIN
	FOR regcompra IN (SELECT * FROM compras) LOOP
        SELECT DEREF(regcompra.cliente) INTO cliente FROM dual;
        dbms_output.put_line('Cliente: '|| cliente.nombre||' '||cliente.apellido);
        dbms_output.put_line('Contacto: '|| cliente.contacto.tlf||' | '||cliente.contacto.mail);
        dbms_output.put_line('Dirección: '|| cliente.direccion.CP||' | '||cliente.direccion.direccion);
        dbms_output.put_line('------------------------------------------------------------');
        FOR i IN regcompra.compra.FIRST .. regcompra.compra.LAST LOOP
            SELECT DEREF(regcompra.compra(i).articulo) INTO articulo FROM dual;
            dbms_output.put_line(articulo.nombre ||' | '||articulo.precio||' | '||regcompra.compra(i).cantidad);
        END LOOP;
        SELECT t.calcTotal() into total from compras t where id = regcompra.id;
        dbms_output.put_line('Total: '||total||'€');
        dbms_output.put_line('=============================================='||CHR(10));
    END LOOP;
END;
/




EXECUTE muestraDatos
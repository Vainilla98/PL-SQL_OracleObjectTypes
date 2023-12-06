-- Ejercicio 1
CREATE OR REPLACE PROCEDURE muestraPedido (cod IN NUMBER)
AS
	TYPE cliente IS RECORD (
        varCodCliente clientes.codigocliente%TYPE,
		varCliente clientes.nombrecliente%TYPE,
        varFecha pedidos.fechapedido%TYPE
	);
	infoCliente cliente;
    Total NUMBER(9,2) := 0;
    IVA NUMBER(9,2);
    CURSOR salida IS 
        SELECT codigoproducto, cantidad, preciounidad 
        FROM detallepedidos
        WHERE codigoproducto = cod;
BEGIN
    SELECT codigocliente, nombrecliente, fechapedido into infoCliente 
    FROM pedidos NATURAL JOIN clientes 
    WHERE codigopedido = cod;
    
    dbms_output.put_line(infoCliente.varCodCliente || ', ' ||infoCliente.varCliente|| '. Fecha Pedido: ' ||infoCliente.varFecha);

    FOR RegProd IN salida LOOP -- Fallo
        dbms_output.put_line( RegProd.codigoproducto || '-> ' ||RegProd.cantidad || ', ' ||RegProd.preciounidad);
        Total := Total + RegProd.cantidad * RegProd.preciounidad;
    END LOOP;

    IVA := Total * 0.21;

    dbms_output.put_line('Precio total: '||Total);
    dbms_output.put_line('IVA: '||IVA);
    dbms_output.put_line('P.V.P.: '||(Total+IVA));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe pedido con codigo '|| cod);
END;
/

EXECUTE muestraPedido(9)

show ERRORS;
-- Ejercicio 2
CREATE OR REPLACE PROCEDURE infoCliente (cod IN NUMBER)
AS
    TYPE registro IS RECORD (
        varCodCliente clientes.codigocliente%TYPE,
		varCliente clientes.nombrecliente%TYPE,
        varCiudad clientes.ciudad%TYPE,
        varPais clientes.pais%TYPE,
        varTransaccion pagos.idtransaccion%TYPE,
        varCantidad pagos.cantidad%TYPE
	);
	infoPago registro;

    Total NUMBER(9,2) := 0;
    CURSOR salida IS 
    SELECT codigocliente, nombrecliente, ciudad, pais, idtransaccion ,cantidad
    FROM clientes NATURAL JOIN pagos
    WHERE codigocliente = cod
    ORDER BY fechapago;
BEGIN
    OPEN salida;
    FETCH salida INTO infoPago;
    IF salida%NOTFOUND THEN 
        DBMS_OUTPUT.PUT_LINE('No existe cliente con codigo '|| cod);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cliente: '||infoPago.varCodCliente||', '||infoPago.varCliente||'. Localidad: '||infoPago.varCiudad||', '||infoPago.varPais);
        DBMS_OUTPUT.PUT_LINE('_________________________________________________________________________');
        WHILE salida%FOUND LOOP
            Total := Total + infoPago.varCantidad;
            DBMS_OUTPUT.PUT_LINE('Transaccion: '||infoPago.varTransaccion||'. Cantidad: '||infoPago.varCantidad||'€');
            FETCH salida INTO infoPago;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('El total de pagos es '||Total||'€');
    END IF;
    CLOSE salida;
END;
/

EXECUTE infoCliente(9);
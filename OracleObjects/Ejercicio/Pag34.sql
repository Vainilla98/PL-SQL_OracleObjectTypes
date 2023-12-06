CREATE OR REPLACE TYPE coche as OBJECT (
    marca VARCHAR2(20),
    modelo VARCHAR2(20),
    velocidad NUMBER,

    MEMBER PROCEDURE acelerar (vel IN NUMBER),
    MEMBER PROCEDURE frenar (vel IN NUMBER)
);

CREATE OR REPLACE TYPE body coche as 
    MEMBER PROCEDURE acelerar (vel IN NUMBER) IS
    BEGIN 
        velocidad := nvl(velocidad,0) + vel;
    END; 
    MEMBER PROCEDURE frenar (vel IN NUMBER) IS
    BEGIN
        velocidad := nvl(velocidad,0) - vel;
    END;
END;
/

DECLARE
     carro coche := coche('Nissan','Cascai',10);
BEGIN
    dbms_output.put_line('Lo inicio a 10 km/h : '||carro.velocidad);
    carro.acelerar(10);
    dbms_output.put_line('Acelero en 10km/h: '||carro.velocidad);
    FOR i IN 1..5 LOOP
        carro.acelerar(10);
    END LOOP;
    dbms_output.put_line('Tras acelerar 10 km/h 5 veces: '|| carro.velocidad);
    carro.frenar(40);
    dbms_output.put_line('Tras frenar 40 km/h: '||carro.velocidad);
    FOR i IN 1..2 LOOP
        carro.frenar(6);
    END LOOP;
    dbms_output.put_line('Tras frenar 6 km/h 2 veces: '|| carro.velocidad);
END;
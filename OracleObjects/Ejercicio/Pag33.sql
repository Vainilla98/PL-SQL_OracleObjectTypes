CREATE OR REPLACE TYPE Circulo AS OBJECT (
    radio NUMBER,
    MEMBER FUNCTION Area RETURN NUMBER,
    MEMBER FUNCTION Perimetro RETURN NUMBER
);

CREATE OR REPLACE TYPE body Circulo as 
    MEMBER FUNCTION Area RETURN NUMBER IS
        res number(9,2);
        PI NUMBER := 3.1415926535897931;
    BEGIN 
        res := power(radio,2) * PI;
        RETURN res;
    END; 
    MEMBER FUNCTION Perimetro RETURN NUMBER IS
        res number(9,2);
        PI NUMBER := 3.1415926535897931;
    BEGIN
        res := 2 * radio * PI;
        RETURN res;
    END;
END;
/

CREATE TABLE circulos (
    ID Number,
    cir Circulo,

    PRIMARY KEY (ID)
);

INSERT INTO circulos VALUES (1,Circulo(4));
INSERT INTO circulos VALUES (2,Circulo(8));
INSERT INTO circulos VALUES (3,Circulo(12));

BEGIN
  FOR RegCirculo IN (SELECT * from circulos) LOOP
    dbms_output.put_line(RegCirculo.ID||'-> Radio: '||RegCirculo.cir.radio||'- Perimetro: '||RegCirculo.cir.Perimetro||'- Área: '||RegCirculo.cir.Area);
  END LOOP;
END;
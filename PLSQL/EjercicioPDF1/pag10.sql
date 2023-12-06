CREATE TABLE P1 (
     c1 NUMBER(3) PRIMARY KEY
);


DECLARE 
    i NUMBER(3) := 1;
    j NUMBER(3) := 1;
BEGIN
    WHILE j <= 50 LOOP
        BEGIN
            INSERT INTO P1 VALUES(i);
            i:=i+1;
            j:=j+1;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Fallo '||i);
                i:=i+1;
        END;
    END LOOP;
END;


TRUNCATE TABLE P1;
DROP TABLE P1;
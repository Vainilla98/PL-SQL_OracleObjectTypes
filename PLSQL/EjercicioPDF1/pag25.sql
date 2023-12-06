CREATE TABLE persona (
    Nombre VARCHAR2(30),
    fechaNacimiento DATE
);

DECLARE
    TYPE personas IS RECORD (
        nombre VARCHAR2(30),
        fecha_nacimiento DATE
    );
    per personas;
BEGIN
	per.nombre := '&Nombre';
    per.fecha_nacimiento := (TO_DATE('&FechaNacimiento', 'DD-MM-YYYY'));
    DBMS_OUTPUT.PUT_LINE('La edad de la persona es '|| TRUNC(MONTHS_BETWEEN(SYSDATE, per.fecha_nacimiento) / 12));

    INSERT INTO persona VALUES per;

    per.nombre := '&Nombre';
    per.fecha_nacimiento := (TO_DATE('&FechaNacimiento', 'DD-MM-YYYY'));
    DBMS_OUTPUT.PUT_LINE('La edad de la persona es '|| TRUNC(MONTHS_BETWEEN(SYSDATE, per.fecha_nacimiento) / 12));

    INSERT INTO persona VALUES per;
END;
/

DROP TABLE persona;
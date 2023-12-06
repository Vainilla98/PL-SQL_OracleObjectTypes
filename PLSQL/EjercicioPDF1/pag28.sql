DECLARE
    registro_min persona%rowtype;
    registro_max persona%rowtype;
BEGIN
	SELECT * INTO registro_min
    from persona 
    WHERE fechanacimiento = (SELECT min(fechanacimiento) from persona);

    SELECT * INTO registro_max
    from persona 
    WHERE fechanacimiento = (SELECT max(fechanacimiento) from persona);

    DBMS_OUTPUT.PUT_LINE('El mas joven: '||registro_max.Nombre ||' nacido el '|| registro_max.fechaNacimiento);
    DBMS_OUTPUT.PUT_LINE('El mas viejo: '||registro_min.Nombre ||' nacido el '|| registro_min.fechaNacimiento);
END;
/
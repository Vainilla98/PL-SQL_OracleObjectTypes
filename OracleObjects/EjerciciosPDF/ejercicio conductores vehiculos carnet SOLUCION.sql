create or replace type tlistacarnets as table of varchar2(10);

 create or replace type tpersona as object (
    id number,
    nombre varchar2(20),
    member function muestraDatos return varchar2)
    not final;

create or replace type body tpersona as
    member function muestraDatos return varchar2
    is
    begin
    	return ('Persona --> '||id ||' nombre: '|| nombre);
    end;
end;

create type tConductor under tpersona (
    carnets tlistacarnets,
    overriding member function muestradatos return varchar2
);


create or replace type body tconductor as
	overriding member function muestraDatos return varchar2
	is
		cadena varchar2(200);
	begin
		cadena :='Persona --> '||id ||' nombre: '|| nombre ||chr(10);
		for i in 1 .. carnets.count loop
			cadena := cadena || carnets(i) ||', ';
		end loop;
		dbms_output.put_line(cadena);
	end;
end;
/


create table conductores of tconductor nested table carnets store as tablaCarnets;

insert into conductores values (1,'Juan',tlistacarnets('b1','c'));
insert into conductores values (2,'Pepa',tlistacarnets('b1'));


create or replace type tvehiculoBase as object (
	marca varchar2(20),
	matricula varchar2(20),
	velocidad integer,
	conductor REF tconductor,
	member function getdatos return varchar2,
	member function getvelocidad return number,
	member procedure acelera(n in number),
	member procedure frena(n in number),
	member procedure para
) not final;
/

create or replace type body tvehiculoBase as
	member function getdatos return varchar2
	is
	begin
		return marca ||' velocidad '|| velocidad;
	end;
	member function getvelocidad return number
	is begin
		return velocidad;
	end;
	member procedure acelera(n in number)
	is
	begin
		velocidad:=velocidad +n;
	end acelera;
	member procedure frena(n in number)
	is
	begin
		velocidad:=velocidad - n;
	end;
	member procedure para
	is
	begin
		velocidad:=0;
	end;
end;
/

Create type tcoche under tvehiculoBase(
	nPuertas number,
	sedan char(1),
	OVERRIDING member function getdatos return varchar2
);
/


create or replace type body tcoche as
	OVERRIDING member function getdatos return varchar2
	is 
	begin
		return marca ||' velocidad: '|| velocidad ||' nPuertas:'||nPuertas||' sedan:'||sedan ;
	end;
end;
/

Create type tcamion under tvehiculoBase(
	tipo varchar2(10),
	capacidad number,
	OVERRIDING member function getdatos return varchar2
);
/

create or replace type body tcamion as
	OVERRIDING member function getdatos return varchar2 is
	begin
		return marca ||' velocidad: '|| velocidad ||' tipo:'||tipo||' capacidad:'||capacidad;
	end;
end;
/


create table vehiculos(
	id number,
	v tvehiculoBase
);


CREATE OR REPLACE TRIGGER conductoresConCarnetAdecuado
BEFORE INSERT
ON vehiculos
FOR EACH ROW
declare
	carnets tlistacarnets;
	con ref tconductor;
	cantidad number;
BEGIN
	select :new.v.conductor into con from dual;
	select deref(con).carnets into carnets from dual;
	if (:new.v is of (tcoche)) then
			SELECT COUNT(*) INTO cantidad
			FROM TABLE(CAST(carnets AS tlistacarnets))
			WHERE column_value = 'b1';
		if cantidad=0 then
			raise_application_error(-20000,'El conductor no tiene el carnet de coche B1 preciso');
		end if;
	else
		SELECT COUNT(*) INTO cantidad
		FROM TABLE(CAST(carnets AS tlistacarnets))
		WHERE column_value = 'c';
		if cantidad=0 then
			raise_application_error(-20000,'El conductor no tiene el carnet de coche C preciso');
		end if;
	end if;
end;
/


insert into vehiculos values (1,tcoche(1,'seat','1111111',0,(select ref(c) from conductores c where c.id='1'), 5,'n'))
insert into vehiculos values (2,tcamion(2,'scania','2222222',0,(select ref(c) from conductores c where c.id='2'),'caja',320));
/







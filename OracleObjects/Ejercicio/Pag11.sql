CREATE TYPE modulo as VARRAY(10) OF VARCHAR2(5); -- [4]
/

CREATE TABLE ciclosFormativos (
	Nombre VARCHAR2(4),
    Tipo VARCHAR2(20) CHECK (Tipo IN ('superior', 'medio')),
    modulos modulo 
);

INSERT INTO ciclosFormativos VALUES ('SMR','medio', modulos('MMEQ','RRLL','SOM','FOL','AWEB','ING'));
INSERT INTO ciclosFormativos VALUES ('SMR','medio', modulos('SEIN','EIE','SOR','SR','APOF'));

INSERT INTO ciclosFormativos VALUES ('DAM','superior', modulos('SSII','LMSGI','PROG','FOL','BDD','ENDES','ING'));
INSERT INTO ciclosFormativos VALUES ('ASIR','superior', modulos('ISO','PAR','FH','GBD','LMSGI','FOL','ING'));
INSERT INTO ciclosFormativos VALUES ('DAW','superior', modulos('DWEC','DWES','DAW','DIW','EIE'));

SELECT * FROM ciclosFormativos;

select Nombre, Tipo, count(*)
from ciclosFormativos, table(ciclosFormativos.modulos)
GROUP BY Nombre, Tipo;

select Nombre, Tipo, COLUMN_VALUE
from ciclosFormativos, table(ciclosFormativos.modulos)

SELECT Nombre, Tipo, COLUMN_VALUE Modulo
FROM ciclosFormativos, table(ciclosFormativos.modulos)
where COLUMN_VALUE = 'ING';


/*
Desarrollo web en entorno cliente 
Desarrollo web en entorno servidor 
Despliegue de aplicaciones web 
Diseño de interfaces web 
Empresa e iniciativa emprendedora 
*/
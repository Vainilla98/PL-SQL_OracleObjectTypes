CREATE TYPE tablaModulo as table OF VARCHAR2(5); -- [3]
/

CREATE TABLE ciclosFormativos2 (
	Nombre VARCHAR2(4),
    Tipo VARCHAR2(20) CHECK (Tipo IN ('superior', 'medio')),
    modulo tablaModulo
)

NESTED TABLE modulo STORE as tModulo; 

INSERT INTO ciclosFormativos2 VALUES ('SMR','medio', tablaModulo('MMEQ','RRLL','SOM','FOL','AWEB','ING'));
INSERT INTO ciclosFormativos2 VALUES ('SMR','medio', tablaModulo('SEIN','EIE','SOR','SR','APOF'));

INSERT INTO ciclosFormativos2 VALUES ('DAM','superior', tablaModulo('SSII','LMSGI','PROG','FOL','BDD','ENDES','ING'));
INSERT INTO ciclosFormativos2 VALUES ('ASIR','superior', tablaModulo('ISO','PAR','FH','GBD','LMSGI','FOL','ING'));
INSERT INTO ciclosFormativos2 VALUES ('DAW','superior', tablaModulo('DWEC','DWES','DAW','DIW','EIE'));


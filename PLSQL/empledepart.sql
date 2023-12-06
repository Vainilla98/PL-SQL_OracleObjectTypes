--
-- TABLA depart
--
ALTER session set container=XEPDB1;

CREATE USER empledepart2 IDENTIFIED BY empledepart2 container=current quota unlimited on users; 
GRANT connect, resource, create view  TO empledepart2;
GRANT CREATE ANY DIRECTORY TO empledepart2; 
grant read, write on directory direxport TO empledepart2;

DROP TABLE DEPART;

CREATE TABLE depart (
 depart_no  SMALLINT NOT NULL CONSTRAINT de_departno_pk primary key,
 dnombre  VARCHAR2(15), 
 loc      VARCHAR2(15)
);

INSERT INTO depart VALUES (10,'CONTABILIDAD','SEVILLA');
INSERT INTO depart VALUES (20,'INVESTIGACION','MADRID');
INSERT INTO depart VALUES (30,'VENTAS','BARCELONA');
INSERT INTO depart VALUES (40,'PRODUCCION','BILBAO');
COMMIT;

--
-- TABLA emple
--

DROP TABLE EMPLE;

CREATE TABLE emple (
 emple_no    SMALLINT NOT NULL constraint emp_emple_pk primary key,
 apellido  VARCHAR2(10),
 oficio    VARCHAR2(10),
 dir       SMALLINT,
 fecha_alt DATE      ,
 salario   NUMBER(6,2),
 comision  NUMBER(6,2),
 depart_no   SMALLINT NOT NULL,
 CONSTRAINT emp_dep_fk FOREIGN KEY (depart_NO) references depart
);

ALTER TABLE emple  ADD CONSTRAINT emp_dir_fk FOREIGN KEY (dir) references emple;

INSERT INTO emple VALUES (7839,'REY','PRESIDENTE',NULL,to_date('17/11/1991','DD/MM/YY'),
                        4100,NULL,10);


INSERT INTO emple VALUES (7566,'JIMENEZ','DIRECTOR',7839,TO_DATE('04/02/1991','DD/MM/YYYY'),
                        2900,NULL,20);

INSERT INTO emple VALUES (7698,'NEGRO','DIRECTOR',7839,TO_DATE('01/05/1991','DD/MM/YYYY'),
                        3005,NULL,30);

INSERT INTO emple VALUES (7654,'MARTIN','VENDEDOR',7698,TO_DATE('29/09/1991','DD/MM/YYYY'),
                        1600,1020,30);

INSERT INTO emple VALUES (7782,'CEREZO','DIRECTOR',7839,TO_DATE('09/06/1991','DD/MM/YYYY'),
                        2885,NULL,10);
INSERT INTO emple VALUES (7499,'ARROYO','VENDEDOR',7698,TO_DATE('20/02/1990','DD/MM/YYYY'),
                        1500,390,30);
INSERT INTO emple VALUES (7788,'GIL','ANALISTA',7566,TO_DATE('09/11/1991','DD/MM/YYYY'),
                        3000,NULL,20);

INSERT INTO emple VALUES (7844,'TOVAR','VENDEDOR',7698,TO_DATE('08/09/1991','DD/MM/YYYY'),
                        1350,0,30);
INSERT INTO emple VALUES (7876,'ALONSO','EMPLEADO',7788,TO_DATE('23/09/1991','DD/MM/YYYY'),
                        1430,NULL,20);
INSERT INTO emple VALUES (7900,'JIMENO','EMPLEADO',7698,TO_DATE('03/12/1991','DD/MM/YYYY'),
                        1335,NULL,30);
INSERT INTO emple VALUES (7902,'FERNANDEZ','ANALISTA',7566,TO_DATE('03/12/1991','DD/MM/YYYY'),
                        3000,NULL,20);

INSERT INTO emple VALUES (7369,'SANCHEZ','EMPLEADO',7902,TO_DATE('17/12/1990', 'DD/MM/YYYY'),
                        1040,NULL,20);
INSERT INTO emple VALUES (7934,'MUNOZ','EMPLEADO',7782,TO_DATE('23/01/1992','DD/MM/YYYY'),
                        1690,NULL,10);
INSERT INTO emple VALUES (7521,'SALA','VENDEDOR',7698,TO_DATE('22/02/1991','DD/MM/YYYY'),
                        1625,650,30);

COMMIT;
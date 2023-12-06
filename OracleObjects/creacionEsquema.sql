CREATE USER esquemaExamen IDENTIFIED BY esquemaExamen container=current quota unlimited on users; 
GRANT connect, resource, create view TO esquemaExamen;
DROP USER esquemaExamen  CASCADE;


CREATE USER pruebas IDENTIFIED BY pruebas container=current quota unlimited on users; 
GRANT connect, resource, create view TO pruebas;
DROP USER pruebas CASCADE;
/*
    Package DBMS_SQL -> Package para SQL din�mico
    O SQL din�mico busca montar e executar um comando em tempo de execu��o
    
    As linhas retornadas por um cursor s�o colocadas em uma �rea de mem�ria
    chamada de result set.
    
    Inclu�do da vers�o 7 / 8 sendo uma package legada
*/

-- Comando DML
SET SERVEROUTPUT ON
SET VERIFY OFF
CREATE OR REPLACE PROCEDURE PRC_UPDATE_SALARY_EMPLOYEE
  (pemployee_id        IN employees.employee_id%TYPE,
   ppercentual         IN NUMBER)
IS
  vcursor_id       INTEGER;
  vrows_processed  INTEGER;
BEGIN

  -- OPEN Cursor
  vcursor_id  := DBMS_SQL.OPEN_CURSOR;
  
  -- Parsing comando SQL
  -- Recebe o id do cursor e o comando DML a ser executado
  DBMS_SQL.PARSE(vcursor_id, 'UPDATE employees
                              SET    salary = salary * (1 + (:gpercentual/100))
                              WHERE  employee_id = :gemployee_id', DBMS_SQL.NATIVE);

  -- Binding Vari�veis
  DBMS_SQL.BIND_VARIABLE(vcursor_id, ':gpercentual', ppercentual);
  DBMS_SQL.BIND_VARIABLE(vcursor_id, ':gemployee_id', pemployee_id);
  
  -- Executando o Cursor
  vrows_processed := DBMS_SQL.EXECUTE(vcursor_id);
  
  -- CLOSE Cursor
  DBMS_SQL.CLOSE_CURSOR(vcursor_id);
  
  --COMMIT;
  
EXCEPTION
   WHEN OTHERS THEN 
       RAISE_APPLICATION_ERROR(-20001,'Erro Oracle ' || SQLCODE || SQLERRM);
END;

-- Executando a procedure

SELECT *
FROM   employees;

exec PRC_UPDATE_SALARY_EMPLOYEE(pemployee_id => 109, ppercentual => 10)

SELECT *
FROM   employees;

ROLLBACK;		

-- SQL Dinamico - DBMS_SQL

-- Comando SELECT

SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE

  vcursor_id   INTEGER;
  vrowcount    NUMBER;
  vfirst_name  VARCHAR2(30);
  vlast_name   VARCHAR2(30);

BEGIN

  vcursor_id  :=  DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(vcursor_id,'SELECT first_name,last_name FROM employees', DBMS_SQL.NATIVE);

  DBMS_SQL.DEFINE_COLUMN(vcursor_id,1,vfirst_name,30);

  DBMS_SQL.DEFINE_COLUMN(vcursor_id,2,vlast_name,30);

  vrowcount := DBMS_SQL.EXECUTE_AND_FETCH(vcursor_id); -- Executa o select din�mico e deixa no result set

  LOOP

    EXIT WHEN DBMS_SQL.FETCH_ROWS(vcursor_id) = 0;

    DBMS_SQL.COLUMN_VALUE(vcursor_id,1,vfirst_name);

    DBMS_SQL.COLUMN_VALUE(vcursor_id,2,vlast_name);

    DBMS_OUTPUT.PUT_LINE(vlast_name||', '||vfirst_name);

   END LOOP;

   DBMS_SQL.CLOSE_CURSOR(vcursor_id);

END;
	  

/*
    SYS_REFCURSOR
    Declarado no pacto standard do Oracle PL/SQL
    É uma declaação fraca do tipo IS REF CURSOR
    Forma mais simples de utilizar um cursor
    Um cursor aponta para um cursor ou um result set
*/

CREATE OR REPLACE PROCEDURE PRC_CURSOR_EMPLOYEES
  (pemployees_cursor OUT SYS_REFCURSOR)
IS
BEGIN
  OPEN pemployees_cursor 
  FOR -- select do cursor
	SELECT first_name, last_name 
	FROM employees;
	
END PRC_CURSOR_EMPLOYEES;

-- Procedure referenciando o Parametro OUT SYS_REFCURSOR

CREATE OR REPLACE PROCEDURE PRC_DISPLAY_EMPOYEES
IS
  employees_cursor  SYS_REFCURSOR; -- Cursor
  vfirst_name  employees.first_name%TYPE;
  vlast_name   employees.last_name%TYPE;
BEGIN
  PRC_CURSOR_EMPLOYEES(employees_cursor);
  
  LOOP
    FETCH  employees_cursor
    INTO   vfirst_name, vlast_name;
    EXIT   WHEN employees_cursor%NOTFOUND;
	
    DBMS_OUTPUT.PUT_LINE(vfirst_name || ' ' || vlast_name);

  END LOOP;
  
  CLOSE employees_cursor;
  
END PRC_DISPLAY_EMPOYEES;

-- Executando a Procedure PRC_DISPLAY_EMPOYEES

SET SERVEROUTPUT ON
SET VERIFY OFF
execute PRC_DISPLAY_EMPOYEES

-- Variável Cursor e Reference Cursor 

CREATE OR REPLACE FUNCTION FNC_GET_EMPOYEES
  (pemployee_id  IN NUMBER)
  RETURN SYS_REFCURSOR
IS
  employees_cursor  SYS_REFCURSOR;
BEGIN
  OPEN employees_cursor  
  FOR
    SELECT first_name, last_name
    FROM   employees
    WHERE  employee_id = pemployee_id;
    
  RETURN employees_cursor;
  
END FNC_GET_EMPOYEES;

-- Referenciando a Função

CREATE OR REPLACE PROCEDURE PRC_DISPLAY_EMPOYEES2
  (pemployee_id IN NUMBER)
IS
  employees_cursor  SYS_REFCURSOR;
  vfirst_name  employees.first_name%TYPE;
  vlast_name   employees.last_name%TYPE;
BEGIN
  employees_cursor := FNC_GET_EMPOYEES(pemployee_id);
  
  LOOP
    FETCH  employees_cursor
    INTO   vfirst_name, vlast_name;
    EXIT WHEN employees_cursor%NOTFOUND;
	
    DBMS_OUTPUT.PUT_LINE(vfirst_name || ' ' || vlast_name);

  END LOOP;
  
  CLOSE employees_cursor;
END PRC_DISPLAY_EMPOYEES2;

-- Executando a procedure 

SET SERVEROUTPUT ON
SET VERIFY OFF
execute PRC_DISPLAY_EMPOYEES2(100)


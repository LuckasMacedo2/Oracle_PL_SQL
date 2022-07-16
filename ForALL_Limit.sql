/*
    FOR ALL -> usado para diminuir a troca de contexto e melhorar a performance
    FOR normal -> Cada iteração tem uma troca de contexto
    FOR ALL comandos DML são empacotados em um pacote que é enviado para o PL/SQL Engine
    de uma vez. Ele só permite um único comando DML.
    Um select pode retornar muitas linhas
    A memória do Oracle é compartilhada para todos os usuários conectados ao banco
    Quanto maior a collection maior o consumo de memória
    LIMIT -> Permite dividir as linhas do select para buffer da collection
    de n elementos diminuindo assim o consumo de memória    
*/

SELECT COUNT (*) FROM EMPLOYEES;

-- Com muitas trocas de contexto
SET SERVEROUTPUT ON
SET VERIFY OFF
create or replace PROCEDURE PRC_UPDATE_SALARY
    (PPERCENTUAL IN NUMBER)
AS
    TYPE EMPLOYEE_ID_TABLE_TYPE IS TABLE OF EMPLOYEES.EMPLOYEE_ID%TYPE
    INDEX BY BINARY_INTEGER;
    EMPLOYEE_ID_TABLE EMPLOYEE_ID_TABLE_TYPE;
BEGIN
    SELECT DISTINCT EMPLOYEE_ID
        BULK COLLECT INTO EMPLOYEE_ID_TABLE
    FROM EMPLOYEES;
    
    DBMS_OUTPUT.PUT_LINE('QTD DE LINHAS: ' || EMPLOYEE_ID_TABLE.COUNT);

    -- Para cada iteração ocorre a troca de contexto a cada linha
    FOR I IN 1..EMPLOYEE_ID_TABLE.COUNT LOOP
        UPDATE EMPLOYEES 
        SET SALARY = SALARY * (1 + PPERCENTUAL / 100)
        WHERE EMPLOYEE_ID = EMPLOYEE_ID_TABLE(I);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

exec PRC_UPDATE_SALARY(10);

ROLLBACK;

-- FOR ALL para diminuir as trocas de contexto
SET SERVEROUTPUT ON
SET VERIFY OFF
create or replace PROCEDURE PRC_UPDATE_SALARY
    (PPERCENTUAL IN NUMBER)
AS
    TYPE EMPLOYEE_ID_TABLE_TYPE IS TABLE OF EMPLOYEES.EMPLOYEE_ID%TYPE
    INDEX BY BINARY_INTEGER;
    EMPLOYEE_ID_TABLE EMPLOYEE_ID_TABLE_TYPE;
BEGIN
    SELECT DISTINCT EMPLOYEE_ID
        BULK COLLECT INTO EMPLOYEE_ID_TABLE
    FROM EMPLOYEES;
    
    DBMS_OUTPUT.PUT_LINE('QTD DE LINHAS: ' || EMPLOYEE_ID_TABLE.COUNT);

    -- FOR ALL empacota todos os updates e os envia em uma única troca de contexto
    FORALL I IN 1..EMPLOYEE_ID_TABLE.COUNT 
        UPDATE EMPLOYEES 
        SET SALARY = SALARY * (1 + PPERCENTUAL / 100)
        WHERE EMPLOYEE_ID = EMPLOYEE_ID_TABLE(I);
        
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

exec PRC_UPDATE_SALARY(10);

ROLLBACK;

-- LIMIT
SET SERVEROUTPUT ON
SET VERIFY OFF
CREATE OR REPLACE PROCEDURE PRC_UPDATE_SALARY2
  (ppercentual IN NUMBER)
AS
  vLimit CONSTANT INTEGER(2) := 30; -- Tamanho do buffer
  TYPE employee_id_table_type IS TABLE OF employees.employee_id%TYPE 
  INDEX BY BINARY_INTEGER;  -- Type Associative Array
  employee_id_table  employee_id_table_type;
  CURSOR employees_cursor IS
    SELECT employee_id 
    FROM employees;
BEGIN

  OPEN employees_cursor;
  
  LOOP
    FETCH employees_cursor 
    BULK COLLECT INTO employee_id_table LIMIT vlimit; -- carrega a qtd de linhas conforme o limite (vlimit)
    
    EXIT WHEN employee_id_table.COUNT = 0;
    
    DBMS_OUTPUT.PUT_LINE('Linhas recuperadas: ' || employee_id_table.COUNT);
    
    FORALL indice IN 1..employee_id_table.COUNT 
      
      UPDATE employees e
      SET    e.salary = e.salary * (1 + ppercentual / 100)
      WHERE  e.employee_id = employee_id_table(indice);  
    
  END LOOP;
  
  CLOSE employees_cursor;
  -- COMMIT;
  
END;

exec PRC_UPDATE_SALARY2(10);

ROLLBACK
/*
    No PL/SQL � poss�vel utilizar os comandos DML (Data MAnipulation Language) - Insert Update e Delete
    Tamb�m � poss�vel controlar transa��es
    
    Bloco PL/SQL -> N�o � uma unidade de transa��o.
    
    PL/SQL n�o pode usar comandos DDL
    � poss�vel usar DDL no bloco PL/SQL utilizando SQL din�mico
    
    DCL -> Data comand language (grant, exemplo)
*/

/* SELECT no PL/SQL 
    Usa a cl�usula INTO
    Sintaxe:
    SELECT COLUNAS INT VARIAVEL FROM TABELA
    Uma variavel para cada coluna ou uma variavel record
    
    O SELECT deve retoronar somente uma linha
    Deve ser garantir que o select retorne uma linha
*/

SET SERVEROUTPUT ON 

DECLARE 
    VFISRT_NAME employees.first_name%TYPE;
    VLAST_NAME employees.last_name%TYPE;
    VSALARY employees.salary%TYPE;
    VEMPLOYEE_ID employees.employee_id%TYPE := 121;
BEGIN
    SELECT first_name, last_name, salary 
    INTO VFISRT_NAME, VLAST_NAME, VSALARY
    FROM employees
    WHERE employee_id = VEMPLOYEE_ID;
    
    DBMS_OUTPUT.PUT_LINE('ID = ' || VEMPLOYEE_ID);
    DBMS_OUTPUT.PUT_LINE('PRIMEIRO NOME = ' || VFISRT_NAME);
    DBMS_OUTPUT.PUT_LINE('�LTIMO NOME = ' || VLAST_NAME);
    DBMS_OUTPUT.PUT_LINE('SAL�RIO = ' || VSALARY);
END;

-- ERRO ORA-01403 - NO DATA FOUND
DECLARE 
    VFISRT_NAME employees.first_name%TYPE;
    VLAST_NAME employees.last_name%TYPE;
    VSALARY employees.salary%TYPE;
    VEMPLOYEE_ID employees.employee_id%TYPE := 50;
BEGIN
    SELECT first_name, last_name, salary 
    INTO VFISRT_NAME, VLAST_NAME, VSALARY
    FROM employees
    WHERE employee_id = VEMPLOYEE_ID;
    
    DBMS_OUTPUT.PUT_LINE('ID = ' || VEMPLOYEE_ID);
    DBMS_OUTPUT.PUT_LINE('PRIMEIRO NOME = ' || VFISRT_NAME);
    DBMS_OUTPUT.PUT_LINE('�LTIMO NOME = ' || VLAST_NAME);
    DBMS_OUTPUT.PUT_LINE('SAL�RIO = ' || VSALARY);
END;

-- ERRO ORA-01403 - NO DATA FOUND
DECLARE 
    VFISRT_NAME employees.first_name%TYPE;
    VLAST_NAME employees.last_name%TYPE;
    VSALARY employees.salary%TYPE;
    VEMPLOYEE_ID employees.employee_id%TYPE := 50;
BEGIN
    SELECT first_name, last_name, salary 
    INTO VFISRT_NAME, VLAST_NAME, VSALARY
    FROM employees
    WHERE employee_id = VEMPLOYEE_ID;
    
    DBMS_OUTPUT.PUT_LINE('ID = ' || VEMPLOYEE_ID);
    DBMS_OUTPUT.PUT_LINE('PRIMEIRO NOME = ' || VFISRT_NAME);
    DBMS_OUTPUT.PUT_LINE('�LTIMO NOME = ' || VLAST_NAME);
    DBMS_OUTPUT.PUT_LINE('SAL�RIO = ' || VSALARY);
END;

DECLARE 
    VJOB_ID employees.job_id%TYPE := 'IT_PROG';
    VAVG_SALARY employees.salary%TYPE;
    VSUM_SALARY employees.salary%TYPE;
BEGIN
    SELECT ROUND(AVG(SALARY), 2), ROUND(SUM(SALARY), 2)
    INTO VAVG_SALARY, VSUM_SALARY
    FROM employees
    WHERE job_id = VJOB_ID;
    
    DBMS_OUTPUT.PUT_LINE('CARGO = ' || VJOB_ID);
    DBMS_OUTPUT.PUT_LINE('M�DIA DE SAL�RIO = ' || VAVG_SALARY);
    DBMS_OUTPUT.PUT_LINE('SOMA DOS SAL�RIOS = ' || VSUM_SALARY);
END;

-- ERRO ORA-00913: valores demais
DECLARE 
    VJOB_ID employees.job_id%TYPE;
    VAVG_SALARY employees.salary%TYPE;
    VSUM_SALARY employees.salary%TYPE;
BEGIN
    SELECT ROUND(AVG(SALARY), 2), ROUND(SUM(SALARY), 2)
    INTO VJOB_ID, VAVG_SALARY, VSUM_SALARY
    FROM employees
    GROUP BY JOB_ID;
    DBMS_OUTPUT.PUT_LINE('CARGO = ' || VJOB_ID);
    DBMS_OUTPUT.PUT_LINE('M�DIA DE SAL�RIO = ' || VAVG_SALARY);
    DBMS_OUTPUT.PUT_LINE('SOMA DOS SAL�RIOS = ' || VSUM_SALARY);
END;

/* INSERT no PL/SQL 
    Mesma l�gica do SQL comum    
*/
DECLARE 
    VFISRT_NAME employees.first_name%TYPE;
    VLAST_NAME employees.last_name%TYPE;
    VSALARY employees.salary%TYPE;
BEGIN
    INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE,
    JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
    VALUES
    (EMPLOYEES_SEQ.NEXTVAL, 'KOBE', 'BRYANT', 'KBRYANT', '515.123.45568', SYSDATE, 'IT_PROG', 15000, 0.4, 103, 60);
    COMMIT;
END;

/* UPDATE no PL/SQL 
    Mesma l�gica do SQL comum    
*/
DECLARE 
    VID employees.employee_id%TYPE := 207;
    VPERCENTUAL NUMBER(3) := 10;
BEGIN
    UPDATE employees 
    SET salary = salary * (1 + VPERCENTUAL / 100)
    WHERE employee_id = VID;
    COMMIT;
END;

SELECT * FROM employees WHERE employee_id = 207;

/* DELETE no PL/SQL 
    Mesma l�gica do SQL comum    
*/
DECLARE 
    VID employees.employee_id%TYPE := 207;
BEGIN
    DELETE FROM employees 
    WHERE employee_id = VID;
    COMMIT;
END;

SELECT * FROM employees WHERE employee_id = 207;

/* 
    Controle de transa��o
    Transa��o = unidade l�gica de trabalho
    Conjunto em conjuntos DML
    Um comando DDL - CREATE TABLE, CREATE VIEW .... Tem commit autom�tico
    Um comando DCL - GRANT, REVOKE. Tem commit autom�tico
    
    No Oracle
        Uma transa��o � iniciada ao conectar ao banco 
        Executar um comando DML
        Ap�s um commit e um comando DML
        Ap�s um rollback e um comando DML
        Uma transa��o termina quando
        Uso de um comando COMMIT
        Uso de um comando ROLLBACK
        Um comando DDL ou DCL � executado
        O usu�rio encerra a sess�o
        Crash no sistema
        
    COMMIT consolida a transa��o.
    ROLLBACK descarta a transa��o.
    
    SAVEPOINT = marca no controle da transa��o
        SAVEPOINT nome_do_save_point
        ROLLBACK TO SAVEPOINT -> Descarta tudo a partir do save point, n�o encerra a transa��o do banco de dados
        ROLLBACK TO SAVEPOINT nome_do_save_point
*/
DECLARE 
    VID employees.employee_id%TYPE := 150;
    VPERCENTUAL NUMBER(3) := 10;
BEGIN
    UPDATE employees 
    SET salary = salary * (1 + VPERCENTUAL / 100)
    WHERE employee_id = VID;
    COMMIT;
END;

DECLARE 
    VID employees.employee_id%TYPE := 150;
    VPERCENTUAL NUMBER(3) := 20;
BEGIN
    UPDATE employees 
    SET salary = salary * (1 + VPERCENTUAL / 100)
    WHERE employee_id = VID;
    ROLLBACK;
END;

/*
    SAVEPOINT
*/
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE,
    JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
    VALUES
    (EMPLOYEES_SEQ.NEXTVAL, 'KOBE', 'BRYANT', 'KBRYANT', '515.123.45568', SYSDATE, 'IT_PROG', 15000, 0.4, 103, 60);

SAVEPOINT UPDATEOK;

UPDATE employees 
SET salary = 259999
WHERE JOB_ID = 'IT_PROG';

ROLLBACK TO SAVEPOINT UPDATEOK;

COMMIT;

/*
    Cursor implicito
        Sempre que um comando � executado um cursor � aberto
        O Oracle � respons�vel por gerenciar o cursor
        
    Atributos de crusores
    ROWCOUNT            N�mero de linahs afetadas pelo cursor, ou seja, pelo �ltimo comando SQL
    SQL%FOUND           Retorna TRUE se o cursor afetou uma ou mais linhas
    SQL%NOTFOUND        Retorna TRUE se o cursor n�o afetou nenhuma linha
    SQL%ISOPEN          Sempre FALSE, pois o Oracle � quem controla o cursor implicito automaticamente
*/
DECLARE 
    VID employees.employee_id%TYPE := 150;
    VPERCENTUAL NUMBER(3) := 10;
BEGIN
    UPDATE employees 
    SET salary = salary * (1 + VPERCENTUAL / 100)
    WHERE employee_id = VID;
    COMMIT;
END;

DECLARE 
    VDEPARTMENT_ID employees.DEPARTMENT_ID%TYPE := 60;
    VPERCENTUAL NUMBER(3) := 10;
BEGIN
    UPDATE employees 
    SET salary = salary * (1 + VPERCENTUAL / 100)
    WHERE DEPARTMENT_ID = VDEPARTMENT_ID;
    DBMS_OUTPUT.PUT_LINE('N�MERO DE EMPREGADOS ATUALIZADOS = ' || SQL%ROWCOUNT);
END;

ROLLBACK

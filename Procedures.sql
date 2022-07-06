/*
Criando Procedures
    Uma procedure possui um nome que permite que ela seja reutilizada
    Recebe par�metros
    P-CODE = c�digo compilado � salvo no banco de dados
    Tipos de par�metro = IN, OUT, INOUT
        IN = Entrada, permite um valor default. Recebe o valor pelo programa chamador
             Funcionam por refer�ncia
        OUT = Sa�da, devolvem um valor para o programa chamador
              Funcionam por c�pia
        IN OUT = Entrada e sa�da, recebem e devolvem um valor
              Funcionam por c�pia
        OUT e IN OUT s�o mais lentos por copiarem os par�metros para a procedure
        NOCOPY -> indica que o par�metro ser� por refer�ncia
    IS = AS
    DEFAULT define o valor padr�o do par�metro
    
    EXEC -> permite chamar uma procedure no SQLPLUS
    
    M�todos de passagem de par�metro
        Posicional -> passa o valor na ordem em que os par�metros foram definidos na procedure
        Nomeado -> Explicita o nome do par�metro, podendo colocar o diferir a ordem dos par�metros
        
    Recompilar procedures
        ALTER PROCEDURE nome_procedure COMPILE; 
        
    Removendo procedures
        DROP PROCEDURE nome_procedure;
        Remove a procedure pernamanentemente
*/

CREATE OR REPLACE PROCEDURE PRC_INSERE_EMPREGADO
    (PFIRST_NAME    IN VARCHAR2,
     PLAST_NAME     IN VARCHAR2,
     PEMAIL         IN VARCHAR2,
     PPHONE_NUMBER  IN VARCHAR2,
     PHIRE_DATE     IN DATE DEFAULT SYSDATE,
     PJOB_ID        IN VARCHAR2,
     PSALARY        IN NUMBER,
     PCOMMISSION_PCT IN NUMBER,
     PMANAGER_ID    IN NUMBER,
     PDEPARTMENT_ID IN NUMBER)
IS
BEGIN
INSERT INTO EMPLOYEES (
            EMPLOYEE_ID,
            FIRST_NAME,    
            LAST_NAME,   
            EMAIL,         
            PHONE_NUMBER,   
            HIRE_DATE,     
            JOB_ID,        
            SALARY,        
            COMMISSION_PCT, 
            MANAGER_ID,    
            DEPARTMENT_ID)
    VALUES(
            EMPLOYEES_SEQ.NEXTVAL,
            PFIRST_NAME,    
            PLAST_NAME,   
            PEMAIL,         
            PPHONE_NUMBER,   
            PHIRE_DATE,     
            PJOB_ID,        
            PSALARY,        
            PCOMMISSION_PCT, 
            PMANAGER_ID,    
            PDEPARTMENT_ID);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

BEGIN 
    PRC_INSERE_EMPREGADO('David', 'Bowie', 'DBOWIE', '515.127.4861', SYSDATE, 'IT_PROG', 15000, NULL, 103, 60);
COMMIT;
END;

SELECT * FROM EMPLOYEES WHERE FIRST_NAME = 'David';

-- Procedures com par�metros de entrada
CREATE OR REPLACE PROCEDURE PRC_AUMENTA_SALARIO_EMPREGADO
    (PEMPLOYEE_ID IN NUMBER,
     PPERCENTUAL IN NUMBER)
IS
BEGIN
    UPDATE EMPLOYEES 
    SET SALARY = SALARY * (1 + PPERCENTUAL / 100)
    WHERE EMPLOYEE_ID = PEMPLOYEE_ID;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

BEGIN
    PRC_AUMENTA_SALARIO_EMPREGADO(109, 10);
COMMIT;
END;

ROLLBACK;

-- Par�metros OUT e IN OUT
CREATE OR REPLACE PROCEDURE PRC_CONSULTA_EMPREGADO
    (PEMPLOYEE_ID   IN NUMBER,
     PFIRST_NAME    OUT VARCHAR2,
     PLAST_NAME     OUT VARCHAR2,
     PEMAIL         OUT VARCHAR2,
     PPHONE_NUMBER  OUT VARCHAR2,
     PHIRE_DATE     OUT DATE,
     PJOB_ID        OUT VARCHAR2,
     PSALARY        OUT NUMBER,
     PCOMMISSION_PCT OUT NUMBER,
     PMANAGER_ID    OUT NUMBER,
     PDEPARTMENT_ID OUT NUMBER)
IS
BEGIN
SELECT  FIRST_NAME,    
        LAST_NAME,   
        EMAIL,         
        PHONE_NUMBER,   
        HIRE_DATE,     
        JOB_ID,        
        SALARY,        
        COMMISSION_PCT, 
        MANAGER_ID,    
        DEPARTMENT_ID
    INTO
            PFIRST_NAME,    
            PLAST_NAME,   
            PEMAIL,         
            PPHONE_NUMBER,   
            PHIRE_DATE,     
            PJOB_ID,        
            PSALARY,        
            PCOMMISSION_PCT, 
            PMANAGER_ID,    
            PDEPARTMENT_ID
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = PEMPLOYEE_ID;
            
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Empregado n�o existe ' || SQLCODE || SQLERRM);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

CREATE OR REPLACE PROCEDURE PRC_CONSULTA_EMPREGADO
    (PEMPLOYEE_ID   IN NUMBER,
     PFIRST_NAME    OUT NOCOPY VARCHAR2,
     PLAST_NAME     OUT NOCOPY VARCHAR2,
     PEMAIL         OUT NOCOPY VARCHAR2,
     PPHONE_NUMBER  OUT NOCOPY VARCHAR2,
     PHIRE_DATE     OUT NOCOPY DATE,
     PJOB_ID        OUT NOCOPY VARCHAR2,
     PSALARY        OUT NOCOPY NUMBER,
     PCOMMISSION_PCT OUT NOCOPY NUMBER,
     PMANAGER_ID    OUT NOCOPY NUMBER,
     PDEPARTMENT_ID OUT NOCOPY NUMBER)
IS
BEGIN
SELECT  FIRST_NAME,    
        LAST_NAME,   
        EMAIL,         
        PHONE_NUMBER,   
        HIRE_DATE,     
        JOB_ID,        
        SALARY,        
        COMMISSION_PCT, 
        MANAGER_ID,    
        DEPARTMENT_ID
    INTO
            PFIRST_NAME,    
            PLAST_NAME,   
            PEMAIL,         
            PPHONE_NUMBER,   
            PHIRE_DATE,     
            PJOB_ID,        
            PSALARY,        
            PCOMMISSION_PCT, 
            PMANAGER_ID,    
            PDEPARTMENT_ID
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = PEMPLOYEE_ID;
            
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Empregado n�o existe ' || SQLCODE || SQLERRM);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE 
  employees_record  employees%ROWTYPE;
BEGIN
  PRC_CONSULTA_EMPREGADO(100, employees_record.first_name, employees_record.last_name, employees_record.email,
    employees_record.phone_number, employees_record.hire_date, employees_record.job_id, employees_record.salary, 
    employees_record.commission_pct, employees_record.manager_id, employees_record.department_id);
    DBMS_OUTPUT.PUT_LINE(employees_record.first_name || ' ' || 
                         employees_record.last_name || ' - ' ||
                         employees_record.department_id || ' - ' ||
                         employees_record.job_id || ' - ' ||
                         employees_record.phone_number || ' - ' ||
                         LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
END;

-- M�todo posicional
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE 
  employees_record  employees%ROWTYPE;
BEGIN
  PRC_CONSULTA_EMPREGADO(100, employees_record.first_name, employees_record.last_name, employees_record.email,
    employees_record.phone_number, employees_record.hire_date, employees_record.job_id, employees_record.salary, 
    employees_record.commission_pct, employees_record.manager_id, employees_record.department_id);
    DBMS_OUTPUT.PUT_LINE(employees_record.first_name || ' ' || 
                         employees_record.last_name || ' - ' ||
                         employees_record.department_id || ' - ' ||
                         employees_record.job_id || ' - ' ||
                         employees_record.phone_number || ' - ' ||
                         LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
END;

-- M�todo nomeado
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  VEMPLOYEE_ID NUMBER := 100;
  VFIRST_NAME VARCHAR2(200);
  VLAST_NAME VARCHAR2(200);
  VEMAIL VARCHAR2(200);
  VPHONE_NUMBER VARCHAR2(200);
  VHIRE_DATE DATE;
  VJOB_ID VARCHAR2(200);
  VSALARY NUMBER;
  VCOMMISSION_PCT NUMBER;
  VMANAGER_ID NUMBER;
  VDEPARTMENT_ID NUMBER;
BEGIN

  PRC_CONSULTA_EMPREGADO(
    PEMPLOYEE_ID => VEMPLOYEE_ID,
    PFIRST_NAME => VFIRST_NAME,
    PLAST_NAME => VLAST_NAME,
    PEMAIL => VEMAIL,
    PPHONE_NUMBER => VPHONE_NUMBER,
    PHIRE_DATE => VHIRE_DATE,
    PJOB_ID => VJOB_ID,
    PSALARY => VSALARY,
    PCOMMISSION_PCT => VCOMMISSION_PCT,
    PMANAGER_ID => VMANAGER_ID,
    PDEPARTMENT_ID => VDEPARTMENT_ID
  );

  DBMS_OUTPUT.PUT_LINE('PFIRST_NAME = ' || VFIRST_NAME);
  DBMS_OUTPUT.PUT_LINE('PLAST_NAME = ' || VLAST_NAME);
  DBMS_OUTPUT.PUT_LINE('PEMAIL = ' || VEMAIL);
  DBMS_OUTPUT.PUT_LINE('PPHONE_NUMBER = ' || VPHONE_NUMBER);
  DBMS_OUTPUT.PUT_LINE('PHIRE_DATE = ' || VHIRE_DATE);
  DBMS_OUTPUT.PUT_LINE('PJOB_ID = ' || VJOB_ID);
  DBMS_OUTPUT.PUT_LINE('PSALARY = ' || VSALARY);
  DBMS_OUTPUT.PUT_LINE('PCOMMISSION_PCT = ' || VCOMMISSION_PCT);
  DBMS_OUTPUT.PUT_LINE('PMANAGER_ID = ' || VMANAGER_ID);
  DBMS_OUTPUT.PUT_LINE('PDEPARTMENT_ID = ' || VDEPARTMENT_ID);
END;

-- Recompilando uma procedure
ALTER PROCEDURE PRC_INSERE_EMPREGADO COMPILE; 

-- Removendo a procedure
DROP PROCEDURE PRC_CONSULTA_EMPREGADO;
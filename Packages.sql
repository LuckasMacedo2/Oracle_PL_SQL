/*
Package = pacote composto por package specification e body. Serve para organizar o c�digo
O body � opcional -> ele implementa a procedure ou fun��o
A package specification � a interface p�blica da package
Pode ter um conjunto de procedures e um conjunto de fun��es
Ganha se performance, pois quando algo da package � referenciado toda a package � carregada para a mem�ria
Package specification � p�blico e pode ser referenciado por fora
Body fica os componentes privados

Packages - beneficios
    Organiza��o
    Modulariza��o
    Variaveis globais com valores durante toda a sess�o
    Performance - toda a package � carregada para a mem�ria ao referenciar um item da package
    Gerenciamento de procedimentos ou fun��es � mais simples
    Gerenciamento de seguran�a mais simples
    
*/

-- Criando o package spection - interface para o mundo exterior
-- declare-se a assinatura da procedure ou fun��o
-- Uma variavel no spefication � uma variavel global -> tem valor durante toda a sess�o do Oracle

CREATE OR REPLACE PACKAGE PCK_EMPREGADOS
IS
    GMINSALARY EMPLOYEES.SALARY%TYPE;
    
    PROCEDURE PRC_INSERE_EMPREGADO
    (PFIRST_NAME    IN VARCHAR2,
     PLAST_NAME     IN VARCHAR2,
     PEMAIL         IN VARCHAR2,
     PPHONE_NUMBER  IN VARCHAR2,
     PHIRE_DATE     IN DATE DEFAULT SYSDATE,
     PJOB_ID        IN VARCHAR2,
     PSALARY        IN NUMBER,
     PCOMMISSION_PCT IN NUMBER,
     PMANAGER_ID    IN NUMBER,
     PDEPARTMENT_ID IN NUMBER);
     
     PROCEDURE PRC_AUMENTA_SALARIO_EMPREGADO
     (PEMPLOYEE_ID IN NUMBER,
     PPERCENTUAL IN NUMBER);
     
     FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO
     (pemployee_id   IN NUMBER)
     RETURN NUMBER;

END PCK_EMPREGADOS;

-- Cria��o do package body
-- Tudo declarado aqui ser�o privados
CREATE OR REPLACE PACKAGE BODY PCK_EMPREGADOS
IS
    PROCEDURE PRC_INSERE_EMPREGADO
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
    
    IF PSALARY < PCK_EMPREGADOS.GMINSALARY THEN
        RAISE_APPLICATION_ERROR(-20002, 'Sal�rio abaixo do menor sal�rio dos empregados ' || TO_CHAR(PCK_EMPREGADOS.GMINSALARY) || '. Inv�lido!');
    END IF;
    
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
        VALUES
            (
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
    
    PROCEDURE PRC_AUMENTA_SALARIO_EMPREGADO
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

    FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO
      (pemployee_id   IN NUMBER)
       RETURN NUMBER
    IS 
      vSalary  employees.salary%TYPE;
    BEGIN
      SELECT salary
      INTO   vsalary
      FROM   employees
      WHERE employee_id = pemployee_id;
      RETURN (vsalary);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Empregado inexistente');
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || ' - ' || SQLERRM);
    END;
    
-- Procedimento de uma �nica execu��o na sess�o
BEGIN
    SELECT MIN(SALARY)
    INTO PCK_EMPREGADOS.GMINSALARY
    FROM EMPLOYEES;
END PCK_EMPREGADOS;

-- Referenciando componentes de uma package
-- Somente componentes publicos podem referenciar um componente de uma package

BEGIN
    PCK_EMPREGADOS.prc_insere_empregado('Bob', 'Dylan', 'BDYYLAN', '515.258.4861', sysdate, 'IT_PROG', 20000, NULL, 103, 60);
    COMMIT;
END;

-- Procedimento de uma �nica execu��o na sess�o
/*
    A primeira vez ao referenciar um componente da package na primeira vez na sess�o
    o procedimento ser� executado apenas nesta vez e depois nunca mais nessa sess�o
    Ex.: inicializa��o de sess�o
    Fica entre o begin e o end da package
    
    Recompilando uma package
*/

-- Recompilando uma package
ALTER PACKAGE PCK_EMPREGADOS COMPILE SPECIFICATION;
-- Recompilando uma body
ALTER PACKAGE PCK_EMPREGADOS COMPILE BODY;

-- Removendo uma package body
DROP PACKAGE BODY PCK_EMPREGADOS;
-- Removendo uma package body e specfication
DROP PACKAGE PCK_EMPREGADOS;

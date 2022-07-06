/*
    Variavel é uma estrutura na memória
    
    RECORD = estrutura composta de campos na memória. Cada campo com seu nome e tipo de dado
    
    A estrutura pode ser composta por tantos campos quanto necessário

    Sintaxe
    DECLARE
    TYPE nome_tipo_record IS RECORD (campo1, campo2, ..., campon);
    
    nome_variavel_record nome_tipo_record;
*/
SET SERVEROUTPUT ON
SET VERIFY OFF -- DESLIGA A IMPRESSÃO DO BLOCO APÓS EXECUTÁ-LO
ACCEPT pemployee_id PROMPT 'Digete o Id do empregado: '
DECLARE 
    TYPE EMPLOYEE_RECORD_TYPE IS RECORD 
            (EMPLOYEE_ID employees.employee_id%TYPE,
             FIRST_NAME employees.FIRST_NAME%TYPE,
             LAST_NAME employees.LAST_NAME%TYPE,
             EMAIL employees.EMAIL%TYPE,
             PHONE_NUMBER employees.PHONE_NUMBER%TYPE);
    EMPLOYEE_RECORD EMPLOYEE_RECORD_TYPE;
BEGIN
    SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER
    INTO EMPLOYEE_RECORD
    FROM EMPLOYEES
    WHERE employee_id = &pemployee_id;
    dbms_output.put_line(EMPLOYEE_RECORD.EMPLOYEE_ID || ' - ' ||
                         EMPLOYEE_RECORD.FIRST_NAME || ' - ' ||
                         EMPLOYEE_RECORD.LAST_NAME || ' - ' ||
                         EMPLOYEE_RECORD.PHONE_NUMBER);
END;

/*
    Atributo %ROWTIPE
    Define que o tipo dos dados do record serão o mesmo da tabela
    O nome, tam, tipo não precisam ser conhecidos. Útil ao utilizar o SELECT * ...
    Sintaxe
    employye_record employees%ROWTYPE;
*/
SET SERVEROUTPUT ON
SET VERIFY OFF -- DESLIGA A IMPRESSÃO DO BLOCO APÓS EXECUTÁ-LO
ACCEPT pemployee_id PROMPT 'Digte o Id do empregado: '
DECLARE 
    EMPLOYEE_RECORD EMPLOYEES%ROWTYPE;
BEGIN
    SELECT *
    INTO EMPLOYEE_RECORD
    FROM EMPLOYEES
    WHERE employee_id = &pemployee_id;
    dbms_output.put_line(EMPLOYEE_RECORD.EMPLOYEE_ID || ' - ' ||
                         EMPLOYEE_RECORD.FIRST_NAME || ' - ' ||
                         EMPLOYEE_RECORD.LAST_NAME || ' - ' ||
                         EMPLOYEE_RECORD.PHONE_NUMBER);
END;


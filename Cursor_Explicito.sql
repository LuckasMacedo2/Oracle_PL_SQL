 /*
    Cursor
    
    Oracle tem um gerenciamento de memória robusto
    Utiliza uma área de memória
    Pode-se utilizar cursores para acessar as áreas de memória
    
    Tipos:
    Implícito           Declarados implicitamente em todos os comandos DML e para comandos select que retornem uma única linha
    Explicito           Para consultas que retornam mais de uma linha, um cursor pode ser declarado e nomeado pelo programador e manipulado através de comandos específicos no bloco PL/SQL.
                        Programador pode manipular o cursor
                        
    O conjunto de linhas retornadas por uma consulta multi-row é denominada result set.
    Um programa PL/SQL abre um cursor, processa as linhas retornadas pela consulta e então fecha o cursor
    Comando FETCH abre o cursor
    Comando CLOSE fecha o cursor
    
    Passos:
    Declarar o cursor e associa-lo a um cursor >
        OPEN abrir o cursor (result set) os dados vão para a memória do ORACLE (Trabalho pesado) >
        Fetch carrega a linha atual para as variáveis, faz isso enquanto não estiver vazio
        CLOSE libera o result set
        
        Um ponteiro fica apontando para linha atual
        
    Declaração
    DECLARE
        CURSOR nome_cursor 
        IS comando SELECT
    ...
    OPEN nome_cursor
    ...
    FETCH nome_cursor
    INTO variaveis
    
    Atributos de cursor explícito
    Método      Tipo        Tipo de collection
    %ISOPEN     Boolean     Retorna TRUE se o cursor testiver aberto
    %NOTFOUND   Boolean     Retorna TRUE se o último FETCH não retornou uma linha
    %FOUND      Boolean     Retorna TRUE se o último FETCH retornou uma linha
    %ROWCOUNT   Number      Retorna o número de linhas recuperadas por FETCH até o momento
    
    CURSOR FOR LOOP
        Foreach para o cursor
        Faz o close automaticado cursor
        
    CURSOR com parâmetros
    parâmetros passados no open do cursor
    
    CURSOR Explicito com select for update
        O select faz um lock nas linhas selecionadas  e elas são liberadas ao final
        Muito raro de ser utilizado e para recuperar poucas linhas
 */  
 
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE 
    CURSOR EMPLOYEES_CURSOR IS 
    SELECT * 
    FROM EMPLOYEES;
    
    EMPLOYEES_RECORD EMPLOYEES_CURSOR%ROWTYPE;
BEGIN

    OPEN EMPLOYEES_CURSOR;
    
    LOOP
        FETCH EMPLOYEES_CURSOR
        INTO EMPLOYEES_RECORD;
        EXIT WHEN EMPLOYEES_CURSOR%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(EMPLOYEES_RECORD.EMPLOYEE_ID || ' - ' ||
                             EMPLOYEES_RECORD.FIRST_NAME || ' - ' ||
                             EMPLOYEES_RECORD.LAST_NAME || ' - ' ||
                             EMPLOYEES_RECORD.PHONE_NUMBER || ' - ' ||
                             EMPLOYEES_RECORD.JOB_ID || ' - ' ||
                             LTRIM(TO_CHAR(EMPLOYEES_RECORD.SALARY, 'L99G99G99D99')));
    END LOOP;
    
    CLOSE EMPLOYEES_CURSOR;
    
END;

SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE 
    CURSOR EMPLOYEES_CURSOR IS 
    SELECT * 
    FROM EMPLOYEES;
    
    EMPLOYEES_RECORD EMPLOYEES_CURSOR%ROWTYPE;
BEGIN

    OPEN EMPLOYEES_CURSOR;
    
    FETCH EMPLOYEES_CURSOR
    INTO EMPLOYEES_RECORD;
    
    WHILE EMPLOYEES_CURSOR%FOUND LOOP

        
        DBMS_OUTPUT.PUT_LINE(EMPLOYEES_RECORD.EMPLOYEE_ID || ' - ' ||
                             EMPLOYEES_RECORD.FIRST_NAME || ' - ' ||
                             EMPLOYEES_RECORD.LAST_NAME || ' - ' ||
                             EMPLOYEES_RECORD.PHONE_NUMBER || ' - ' ||
                             EMPLOYEES_RECORD.JOB_ID || ' - ' ||
                             LTRIM(TO_CHAR(EMPLOYEES_RECORD.SALARY, 'L99G99G99D99')));
        
        FETCH EMPLOYEES_CURSOR
        INTO EMPLOYEES_RECORD;
    END LOOP;
    
    CLOSE EMPLOYEES_CURSOR;
    
END;


SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE 
    
BEGIN
    
    FOR EMPLOYEES_RECORD IN (SELECT * 
                             FROM EMPLOYEES)
    LOOP
        
        DBMS_OUTPUT.PUT_LINE(EMPLOYEES_RECORD.EMPLOYEE_ID || ' - ' ||
                             EMPLOYEES_RECORD.FIRST_NAME || ' - ' ||
                             EMPLOYEES_RECORD.LAST_NAME || ' - ' ||
                             EMPLOYEES_RECORD.PHONE_NUMBER || ' - ' ||
                             EMPLOYEES_RECORD.JOB_ID || ' - ' ||
                             LTRIM(TO_CHAR(EMPLOYEES_RECORD.SALARY, 'L99G99G99D99')));
    END LOOP;
        
END;

-- Cursor com parâmetros
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE 
    CURSOR EMPLOYEES_CURSOR 
    (PDEPARTMENT_ID NUMBER, PJOB_ID VARCHAR2)
    IS 
    SELECT * 
    FROM EMPLOYEES
    WHERE department_id = PDEPARTMENT_ID AND
    job_id = PJOB_ID;
    
BEGIN

    FOR EMPLOYEES_RECORD IN EMPLOYEES_CURSOR(60, 'IT_PROG')
    LOOP
        
        DBMS_OUTPUT.PUT_LINE(EMPLOYEES_RECORD.EMPLOYEE_ID || ' - ' ||
                             EMPLOYEES_RECORD.FIRST_NAME || ' - ' ||
                             EMPLOYEES_RECORD.LAST_NAME || ' - ' ||
                             EMPLOYEES_RECORD.PHONE_NUMBER || ' - ' ||
                             EMPLOYEES_RECORD.JOB_ID || ' - ' ||
                             LTRIM(TO_CHAR(EMPLOYEES_RECORD.SALARY, 'L99G99G99D99')));
    END LOOP;
    
END;

-- Cursor com for update
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE 
    CURSOR EMPLOYEES_CURSOR 
    (PJOB_ID VARCHAR2)
    IS 
    SELECT * 
    FROM EMPLOYEES
    WHERE job_id = PJOB_ID
    FOR UPDATE; -- Faz o lock nas linhas recuperadas
    
BEGIN

    FOR EMPLOYEES_RECORD IN EMPLOYEES_CURSOR('ad_vp')
    LOOP
        UPDATE EMPLOYEES
        SET SALARY = SALARY * (1 + 10 / 100)
        WHERE CURRENT OF EMPLOYEES_CURSOR;
    END LOOP;
    COMMIT;
END;
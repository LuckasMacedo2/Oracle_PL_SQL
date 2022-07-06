 /*
    Exceções = erros inesperados
    A exceção se propaga até encontrar um tratamento ou retornar um erro Oracle
    
    Exceções pré-definidas Oracle
        TOO_MANY_ROWS Select que recupera mais de uma linha
        NO_DATA_FOUND Select que não retorna nenhuma exceção
        RAISE Permite que o programador dispare uma exceção
        EXCEPTION_INIT
        
        Quando ocorre uma exceção o programa procura o tratamento de exceção
        
        Erro Oracle começa com ORA-código
        
        A exceção vai se propagando até encontrar uma exceção ou ao final do programa
        
    Sintaxe
        EXCEPTION 
            WHEN excecao1 OR excecao2
        THEN
        ...
        WHEN OTHERS -- Outras exceções
        THEN
        ...
        END
    
    WHEN OTHERS
        Trata exceções não especificadas
    
    Exceções pré-definidas ORACLE
    Nome                     Erro Oracle      Descrição
    COLLECTION_IS_NULL       ORA-06531        Tentativa de aplciar métodos que o não EXISTS para uma collection não inicializada
    CURSOR_ALREADY_OPEN      ORA-06511        Tentativa de abrir um cursor que já está aberto
    DUP_VAL_ON_INDEX         ORA-00001        Tentativa de inserir um valor duplicado em um índice Único
    INVALID_CURSOR           ORA-01001        Ocorreu uma operação ilegal em um cursor
    INVALID_NUMBER           ORA-01722        Falha na conversão de uma strin caractere para númerica
    LOGIN_DENIED             ORA-01017        Conexão ao banco Oracle com um nome de usuário e/ou senha inválida
    NO_DATA_FOUND            ORA-01403        SELECT do tipo single-row não retornou nenhuma linha
    NOT_LOGGED_ON            ORA-01012        Programa PL/SQL executou uma chamada ao banco de dados sem estar conectado ao Oracle
    TIMEOUT_ON_REOURCE       ORA-00051        Ocorreu um time-out enquanto o Oracle aguardava um recurso
    TOO_MANY_ROWS            ORA-01422        SELECT do tipo single row retornou mais que uma linha
    VALUE_ERROR              ORA-06502        Ocorreu um erro de aritmética, conversão ou truncamento
    ZERO_DIVIDE              ORA-01476        Tentativa de divisão por zero
    
    Procedure RAISE_APPLICATION_ERROR(codigoErro [-20000, -20999], msgErro, boleano pouco usado) -> Exceção com a intenção de encerrar o programa
    SQLCODE -> Código do erro Oracle que disparou a exceção
    SQLERRM -> Mensagem do erro Oracle
    
    Exceções definidas pelo desenvolvedor
    Usa um identificador.
    O RAISE desvia a exceção
    RAISE é equivalente ao GOTO
    
    PRAGMA EXCEPTION INIT
    Pode se vincular uma exception Oracle a uma exception pré-definida
 */
 
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT PEMPLOYEE_ID PROMPT 'Digite o Id do empregado: '
DECLARE
    VFIRST_NAME EMPLOYEES.FIRST_NAME%TYPE;
    VLAST_NAME EMPLOYEES.LAST_NAME%TYPE;
    VEMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE := &PEMPLOYEE_ID;
BEGIN
    SELECT FIRST_NAME, LAST_NAME  
    INTO VFIRST_NAME, VLAST_NAME
    FROM EMPLOYEES
    WHERE employee_id = VEMPLOYEE_ID;
    
    DBMS_OUTPUT.PUT_LINE('Empregado: ' || VFIRST_NAME || ' ' || VLAST_NAME);
    
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Empregado não encontrado, id = ' || TO_CHAR(VEMPLOYEE_ID));
    WHEN OTHERS
    THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle - ' || SQLCODE || SQLERRM);
END;

-- Exceção definida pelo programador
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT PEMPLOYEE_ID PROMPT 'Digite o Id do empregado: '
DECLARE
    VFIRST_NAME EMPLOYEES.FIRST_NAME%TYPE;
    VLAST_NAME EMPLOYEES.LAST_NAME%TYPE;
    VJOB_ID EMPLOYEES.JOB_ID%TYPE;
    VEMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE := &PEMPLOYEE_ID;
    EPRESIDENT EXCEPTION;
BEGIN
    SELECT FIRST_NAME, LAST_NAME, JOB_ID  
    INTO VFIRST_NAME, VLAST_NAME, VJOB_ID
    FROM EMPLOYEES
    WHERE employee_id = VEMPLOYEE_ID;
    
    IF VJOB_ID = 'AD_PRES'
    THEN
        RAISE EPRESIDENT;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Empregado: ' || VFIRST_NAME || ' ' || VLAST_NAME);
    
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Empregado não encontrado, id = ' || TO_CHAR(VEMPLOYEE_ID));
    WHEN EPRESIDENT
    THEN
        UPDATE EMPLOYEES
        SET SALARY = SALARY * 1.5
        WHERE EMPLOYEE_ID = VEMPLOYEE_ID;
        COMMIT;
    WHEN OTHERS
    THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle - ' || SQLCODE || SQLERRM);
END;

-- PRAGMA EXCEPTION INIT
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    VFIRST_NAME EMPLOYEES.FIRST_NAME%TYPE := 'Robert';
    VLAST_NAME EMPLOYEES.LAST_NAME%TYPE := 'Ford';
    VJOB_ID EMPLOYEES.JOB_ID%TYPE := 'XX_YYYY';
    VPHONE_NUMBER EMPLOYEES.PHONE_NUMBER%TYPE := '650.511.9844';
    VEMAIL EMPLOYEES.EMAIL%TYPE := 'RFORD';
    EFK_INEXISTENTE EXCEPTION; -- EXCEPTION definida pelo programador
    PRAGMA EXCEPTION_INIT(EFK_INEXISTENTE, -2291); -- Erro de foreing key
    
BEGIN
    INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER, EMAIL, HIRE_DATE, JOB_ID)
    VALUES(EMPLOYEES_SEQ.NEXTVAL, VFIRST_NAME, VLAST_NAME, VPHONE_NUMBER, VEMAIL, SYSDATE, VJOB_ID);
    COMMIT;    
EXCEPTION
    WHEN EFK_INEXISTENTE
    THEN 
        RAISE_APPLICATION_ERROR(-20003, 'Job inexistente!');
    WHEN OTHERS
    THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle - ' || SQLCODE || SQLERRM);
END;


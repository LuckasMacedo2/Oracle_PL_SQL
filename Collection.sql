/*
    Collection = array de uma dimensão
    Tipos de collection
        Associative Array 
            Estruturas unidimensionais
            Pode ser indexado por valores númericos ou caracteres
            Não é armazenado
            Pode ter intervalos
        Associative Array of Records - Bulk Collection
            Cada ocorrência do associative array vai ter a estrutura de campos de um tipo record
        Nested Table
            Array de uma dimensão
            Pode deletar linhas
            Pode ser armazenados em tabela - cria atributos multivalorados
            Precisa ser alocado com o método EXTEND
            Indice apenas positivos (1 a N)
            Não utiliza INDEX BY e é necessário ser inicializado
        Nested Table of Records - Bulk Collection
            -
        VArray
            Semelhante ao Nested Table
            Vetor de uma dimensão
            Precisa de um tamanho máximo, precisa de um limte
        VArray of records - Bulk Collection
            -
        
        Pode consumir muita memória para tabelas muito grandes é recomendado utilizar cursores
        
        Associative Array -> mais utilizado
        Varray quase nunca utilizado
        
        Métodos para controlar a collection
        NOME_COLLECTIO.NOME_METODO[(parametros)]
        Métodos:
        Método           Descrição              
        EXISTS(N)        Retorna true se o elemento N existe       
        COUNT            Retorna o número de elementos
        FIRST            Retorna o primeiro número do índice. Retorna NULL se a collection está vazia
        LAST             Retorna o último número do índice. Retorna NULL se a collection está vazia
        LIMIT (VARRAY)   Retorna o maior possível índice            
        PIOR(N)          Retorna o número do índice anterior a n
        NEXT(N)          Retorna o número do índice posterior a n
        EXTEND(N)(nested table e v array)
                         Oara aumentar o tamanho
                         EXTEND adiciona um elemento nulo
                         EXTEND(N) adiciona n elementos nulos
                         EXTEND(N, I) adiciona n cópias do elemento i.
        TRIM (Nested Table)
                         TRIM Remove um elemento do final da collection
                         TRIM(N) Remove n elementos do final da collectoin
        DELETE (Nested Table ou associative array)           
                         DELETE remove todos os elementos de uma collection
                         DELETE(N) Remove o elemento n da collection
                         DELETE (m, n) remove todos os elementos da faixa m..n da collection
        N = íNDICE
        
*/

-- Associative array
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE NUMERO_TABLE_TYPE IS TABLE OF NUMBER(2)
    INDEX BY BINARY_INTEGER;
    NUMERO_TABLE NUMERO_TABLE_TYPE;
BEGIN
    FOR I IN 1..10
    LOOP
        NUMERO_TABLE(I) := i;
    END LOOP;
    
    FOR I IN 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE('ARRAY: INDICE = ' || TO_CHAR(I) || ' , VALOR = ' || TO_CHAR(NUMERO_TABLE(I)));
    END LOOP;
END;

-- Associative array de records - Bulk Collection
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE EMPLOYEES_TABLE_TYPE IS TABLE OF EMPLOYEES%ROWTYPE
    INDEX BY BINARY_INTEGER;
    EMPLOYEES_TABLE EMPLOYEES_TABLE_TYPE;
BEGIN
   SELECT * 
    BULK COLLECT INTO EMPLOYEES_TABLE
    FROM EMPLOYEES;
    
    DBMS_OUTPUT.PUT_LINE('ID - NOME - SOBRENOME - NÚM. TELEFONE - ID JOB - SALÁRIO');
    FOR I IN 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMPLOYEES_TABLE(I).EMPLOYEE_ID || ' - ' ||
                             EMPLOYEES_TABLE(I).FIRST_NAME || ' - ' ||
                             EMPLOYEES_TABLE(I).LAST_NAME || ' - ' ||
                             EMPLOYEES_TABLE(I).PHONE_NUMBER || ' - ' ||
                             EMPLOYEES_TABLE(I).JOB_ID || ' - ' ||
                             TO_CHAR(EMPLOYEES_TABLE(I).SALARY, '99G99G99D99'));
    END LOOP;
END;

-- Nested Table
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE NUMERO_TABLE_TYPE IS TABLE OF INTEGER(2);
    NUMERO_TABLE NUMERO_TABLE_TYPE := NUMERO_TABLE_TYPE();
BEGIN
    FOR I IN 1..10
    LOOP
        NUMERO_TABLE.EXTEND; -- PARA O NESTED TABLE É NECESSÁRIO UTILIZAR
        NUMERO_TABLE(I) := i;
    END LOOP;
    
    FOR I IN 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE('NESTED TABLE: INDICE = ' || TO_CHAR(I) || ' , VALOR = ' || TO_CHAR(NUMERO_TABLE(I)));
    END LOOP;
END;

-- Nested Table of Records - Bulk Collection
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE EMPLOYEES_TABLE_TYPE IS TABLE OF EMPLOYEES%ROWTYPE;
    EMPLOYEES_TABLE EMPLOYEES_TABLE_TYPE := EMPLOYEES_TABLE_TYPE();
BEGIN
   SELECT * 
    BULK COLLECT INTO EMPLOYEES_TABLE
    FROM EMPLOYEES;
    
    DBMS_OUTPUT.PUT_LINE('ID - NOME - SOBRENOME - NÚM. TELEFONE - ID JOB - SALÁRIO');
    FOR I IN 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMPLOYEES_TABLE(I).EMPLOYEE_ID || ' - ' ||
                             EMPLOYEES_TABLE(I).FIRST_NAME || ' - ' ||
                             EMPLOYEES_TABLE(I).LAST_NAME || ' - ' ||
                             EMPLOYEES_TABLE(I).PHONE_NUMBER || ' - ' ||
                             EMPLOYEES_TABLE(I).JOB_ID || ' - ' ||
                             TO_CHAR(EMPLOYEES_TABLE(I).SALARY, '99G99G99D99'));
    END LOOP;
END;

-- Varray
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE NUMERO_TABLE_TYPE IS VARRAY(10) OF INTEGER(2);
    NUMERO_TABLE NUMERO_TABLE_TYPE := NUMERO_TABLE_TYPE();
BEGIN
    FOR I IN 1..10
    LOOP
        NUMERO_TABLE.EXTEND;
        NUMERO_TABLE(I) := i;
    END LOOP;
    
    FOR I IN 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE('VARRAY: INDICE = ' || TO_CHAR(I) || ' , VALOR = ' || TO_CHAR(NUMERO_TABLE(I)));
    END LOOP;
END;

-- VArray of records - Bulk Collection
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    TYPE EMPLOYEES_TABLE_TYPE IS VARRAY(200) OF EMPLOYEES%ROWTYPE;
    EMPLOYEES_TABLE EMPLOYEES_TABLE_TYPE := EMPLOYEES_TABLE_TYPE();
BEGIN
   SELECT * 
    BULK COLLECT INTO EMPLOYEES_TABLE
    FROM EMPLOYEES;
    
    DBMS_OUTPUT.PUT_LINE('ID - NOME - SOBRENOME - NÚM. TELEFONE - ID JOB - SALÁRIO');
    FOR I IN EMPLOYEES_TABLE.FIRST..EMPLOYEES_TABLE.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMPLOYEES_TABLE(I).EMPLOYEE_ID || ' - ' ||
                             EMPLOYEES_TABLE(I).FIRST_NAME || ' - ' ||
                             EMPLOYEES_TABLE(I).LAST_NAME || ' - ' ||
                             EMPLOYEES_TABLE(I).PHONE_NUMBER || ' - ' ||
                             EMPLOYEES_TABLE(I).JOB_ID || ' - ' ||
                             TO_CHAR(EMPLOYEES_TABLE(I).SALARY, '99G99G99D99'));
    END LOOP;
END;
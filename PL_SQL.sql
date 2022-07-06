/*
    PL/SQL = Performance
    PL/SQL -> linguagem procedural para cria��o de programas usadas com SQL
    Estende as funcionalidades do SQL
    Permite tratamento de exce��es
    
    AAmbiente SQL
        IDE > rede > banco > rede > ide
    
    Ambiente PL / SQL (performance)
        Bloco PL/SQL > execu��o dos comandos linha a linha no Oracle Engine 
            Tudo � executado no banco, ganha performance e menos trafego de rede
            
    Comandos PL/SQL s�o executados pelo SQL Statement Executor que fica no servidor Oracle
    
    O melhor local para salvar o c�digo PL/SQL � no banco de dados Oracle.
    
    DML = Insert, Update e delect
    
    Tipos de constru��o PL/SQL
        - Blocos an�nimos: Bloco sem nome
        - Fun��es/procedures salvas no banco, possuem nome e lista de par�metros
        - Packages (pacotes): conjunto de fun��es que tem algo em comum
        - Trigger: Disparados quando acontece um evento de banco de dados
        - Trigger de aplica��o: Em aplica��es constru�das com tecnologias Oracle
        - Fun��es/procedures de aplica��o: Em aplica��es constru�das com tecnologias Oracle
    
    Bom gerenciamento de mem�ria
    
    ----------------------------------------------------------------------------
    Estrutura de um bloco an�nimo ** Entre [ � opcional
    [DECLARE
        -- Declara��o de variaveis constatntes
        -- Declara��o de cursores, exce��es, etc.
    BEGIN
        -- Comandos SQL
        -- Comandos PL/SQL
    [EXCEPTION
        -- Tratamento de exce��es
    END;
    ----------------------------------------------------------------------------
    
    
    Vantagens
        - Integra��o
        - Performance
        - Controle l�gico
        - Modulariza��o
        - Portabiblidade
        - Seguran�a e integridade dos dados
            N�o � necess�rio prover o privilegio em cada tabela que o bloco utiliza
            basta prover o privil�gio na procedure
        - Reutiliza��o de c�digo
        - Declara��o de vari�veis dinamicamente
        - Estruturas de controle
        - Tratamento de exce��es
*/

SELECT * FROM EMPLOYEES;

-- Exemplo bloco PL / SQL
-- hello world
SET SERVEROUTPUT ON -- Habilita o DBMSOUTPUT para imprimir os valores. SET altera o valor de uma variavel do SQLPLUS

DECLARE
    VTEXTO VARCHAR2(100) := 'Hello World!'; -- := atribui, os comandos finalizam com ;
BEGIN
    DBMS_OUTPUT.PUT_LINE(VTEXTO); -- Imprime algo
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('Erro' || SQLCODE || SQLERRM); -- SQLCODE = C�digo do erro; SQLERRM = mensagem do erro
END;


-- Soma de dois n�meros
SET SERVEROUTPUT ON -- Habilita o DBMSOUTPUT para imprimir os valores. SET altera o valor de uma variavel do SQLPLUS

DECLARE
    VNUMERO1 NUMBER(11,2) := 500;
    VNUMERO2 NUMBER(11,2) := 400;
    VMEDIA NUMBER(11,2); -- Default = null
BEGIN
    VMEDIA := (VNUMERO1 + VNUMERO2) / 2;
    DBMS_OUTPUT.PUT_LINE('M�dia = ' || VMEDIA); -- Imprime algo
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('Erro' || SQLCODE || SQLERRM); -- SQLCODE = C�digo do erro; SQLERRM = mensagem do erro
END;

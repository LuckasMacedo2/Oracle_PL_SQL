/*
    PL/SQL = Performance
    PL/SQL -> linguagem procedural para criação de programas usadas com SQL
    Estende as funcionalidades do SQL
    Permite tratamento de exceções
    
    AAmbiente SQL
        IDE > rede > banco > rede > ide
    
    Ambiente PL / SQL (performance)
        Bloco PL/SQL > execução dos comandos linha a linha no Oracle Engine 
            Tudo é executado no banco, ganha performance e menos trafego de rede
            
    Comandos PL/SQL são executados pelo SQL Statement Executor que fica no servidor Oracle
    
    O melhor local para salvar o código PL/SQL é no banco de dados Oracle.
    
    DML = Insert, Update e delect
    
    Tipos de construção PL/SQL
        - Blocos anônimos: Bloco sem nome
        - Funções/procedures salvas no banco, possuem nome e lista de parâmetros
        - Packages (pacotes): conjunto de funções que tem algo em comum
        - Trigger: Disparados quando acontece um evento de banco de dados
        - Trigger de aplicação: Em aplicações construídas com tecnologias Oracle
        - Funções/procedures de aplicação: Em aplicações construídas com tecnologias Oracle
    
    Bom gerenciamento de memória
    
    ----------------------------------------------------------------------------
    Estrutura de um bloco anônimo ** Entre [ é opcional
    [DECLARE
        -- Declaração de variaveis constatntes
        -- Declaração de cursores, exceções, etc.
    BEGIN
        -- Comandos SQL
        -- Comandos PL/SQL
    [EXCEPTION
        -- Tratamento de exceções
    END;
    ----------------------------------------------------------------------------
    
    
    Vantagens
        - Integração
        - Performance
        - Controle lógico
        - Modularização
        - Portabiblidade
        - Segurança e integridade dos dados
            Não é necessário prover o privilegio em cada tabela que o bloco utiliza
            basta prover o privilégio na procedure
        - Reutilização de código
        - Declaração de variáveis dinamicamente
        - Estruturas de controle
        - Tratamento de exceções
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
        DBMS_OUTPUT.PUT_LINE('Erro' || SQLCODE || SQLERRM); -- SQLCODE = Código do erro; SQLERRM = mensagem do erro
END;


-- Soma de dois números
SET SERVEROUTPUT ON -- Habilita o DBMSOUTPUT para imprimir os valores. SET altera o valor de uma variavel do SQLPLUS

DECLARE
    VNUMERO1 NUMBER(11,2) := 500;
    VNUMERO2 NUMBER(11,2) := 400;
    VMEDIA NUMBER(11,2); -- Default = null
BEGIN
    VMEDIA := (VNUMERO1 + VNUMERO2) / 2;
    DBMS_OUTPUT.PUT_LINE('Média = ' || VMEDIA); -- Imprime algo
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('Erro' || SQLCODE || SQLERRM); -- SQLCODE = Código do erro; SQLERRM = mensagem do erro
END;

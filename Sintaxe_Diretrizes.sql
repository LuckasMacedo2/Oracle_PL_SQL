/*
    SQL != PL/SQL
    
    Unidades léxicas podem ser separadas por um ou mais espaços
*/

SET SERVEROUTPUT ON

DECLARE
    VNUMERO1 NUMBER(13, 2);
    VNUMERO2 NUMBER(13, 2);
    VMEDIA NUMBER(13, 2);
BEGIN
    VNUMERO1 := 5000;
    VNUMERO2 := 5E3;
    VMEDIA := (VNUMERO1 + VNUMERO2) / 2;
    
    DBMS_OUTPUT.PUT_LINE('MÉDIA = ' || VMEDIA);
END;

/*
    Funções
        Funções númericas, caractere, conversão, data, genéricas e outras funções
    Funções SQL que só podem ser utilizadas em comandos SQL ou comandos SQL dentro de um 
    bloco PL/SQL
        DECODE, AVG, MIN, MAX, COUNT, SUM, STDDEV E VARIANCE
*/
DECLARE
    VNUMERO1 NUMBER(13, 2);
    VNUMERO2 NUMBER(13, 2);
    VMEDIA NUMBER(13, 2);
BEGIN
    VNUMERO1 := 5000.898989;
    VNUMERO2 := 12.8989898;
    VMEDIA := ROUND((VNUMERO1 + VNUMERO2) / 2, 2);
    
    DBMS_OUTPUT.PUT_LINE('MÉDIA = ' || TO_CHAR(VMEDIA, '99G999G99D99'));
END;

/*
    Blocos aninhados
    
    Pode dividir a lógica de um bloco em vários subblocos 
    Cada bloco pode ter uma seção EXCEPTION
    
    Um identificador é visivel no bloco que foi declarado e em todos os outros blocos aninhados.
*/
DECLARE
    VBLOCO1 VARCHAR2(20) := 'Bloco 1';
BEGIN
    DBMS_OUTPUT.PUT_LINE('VARIAVEL DO BLOCO 1 = ' || VBLOCO1);
    DECLARE 
        VBLOCO2 VARCHAR2(20) := 'Bloco 2';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('VARIAVEL DO BLOCO 1 = ' || VBLOCO1);
        DBMS_OUTPUT.PUT_LINE('VARIAVEL DO BLOCO 2 = ' || VBLOCO2);
    END;
    DBMS_OUTPUT.PUT_LINE('VARIAVEL DO BLOCO 1 = ' || VBLOCO1);
    -- VBLOCO2 NÃO EXISTE NESSE ESCOPO
END;



/*
    blocos como label
    <<label>>
    DECLARE
    
    BEGIN
    
    EXCEPTION
    
    END;
*/
<<BLOCO1>>
DECLARE
    VBLOCO1 VARCHAR2(20) := 'Bloco 1';
BEGIN
    DBMS_OUTPUT.PUT_LINE('VARIAVEL DO BLOCO 1 = ' || VBLOCO1);
    <<BLOCO2>>
    DECLARE 
        VBLOCO2 VARCHAR2(20) := 'Bloco 2';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('VARIAVEL DO BLOCO 1 = ' || VBLOCO1);
        DBMS_OUTPUT.PUT_LINE('VARIAVEL DO BLOCO 2 = ' || VBLOCO2);
    END;
    DBMS_OUTPUT.PUT_LINE('VARIAVEL DO BLOCO 1 = ' || VBLOCO1);
    -- VBLOCO2 NÃO EXISTE NESSE ESCOPO
END;

/*
    Convenções de codificação
    Categoria                                   Convenção sugerida
    Ccomandos SQL                               Letras maúsculas
    Palavras chave                              Letras maiúsculas
    Tipos de dados                              Letras maiúsculas
    Nomes de identificadores e parâmetros       Letras minúsculas
    Nomes de tabelas e colunas                  Letras minúsculas
    
    Convenções de nomenclatura
    Categoria                                   Convenção sugerida
    Variável                                    Prefixo v
    Constante                                   Prefixo c
    Cursor                                      Sufixo _cursor
    Exceção                                     Prefixo e
    Tipo Record                                 Sufixo _record_type
    Variável record                             Sufixo _record
    Parâmetro                                   Prefixo p
    Variável global                             Prefixo g
*/

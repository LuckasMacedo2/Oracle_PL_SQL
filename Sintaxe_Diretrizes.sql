/*
    SQL != PL/SQL
    
    Unidades l�xicas podem ser separadas por um ou mais espa�os
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
    
    DBMS_OUTPUT.PUT_LINE('M�DIA = ' || VMEDIA);
END;

/*
    Fun��es
        Fun��es n�mericas, caractere, convers�o, data, gen�ricas e outras fun��es
    Fun��es SQL que s� podem ser utilizadas em comandos SQL ou comandos SQL dentro de um 
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
    
    DBMS_OUTPUT.PUT_LINE('M�DIA = ' || TO_CHAR(VMEDIA, '99G999G99D99'));
END;

/*
    Blocos aninhados
    
    Pode dividir a l�gica de um bloco em v�rios subblocos 
    Cada bloco pode ter uma se��o EXCEPTION
    
    Um identificador � visivel no bloco que foi declarado e em todos os outros blocos aninhados.
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
    -- VBLOCO2 N�O EXISTE NESSE ESCOPO
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
    -- VBLOCO2 N�O EXISTE NESSE ESCOPO
END;

/*
    Conven��es de codifica��o
    Categoria                                   Conven��o sugerida
    Ccomandos SQL                               Letras ma�sculas
    Palavras chave                              Letras mai�sculas
    Tipos de dados                              Letras mai�sculas
    Nomes de identificadores e par�metros       Letras min�sculas
    Nomes de tabelas e colunas                  Letras min�sculas
    
    Conven��es de nomenclatura
    Categoria                                   Conven��o sugerida
    Vari�vel                                    Prefixo v
    Constante                                   Prefixo c
    Cursor                                      Sufixo _cursor
    Exce��o                                     Prefixo e
    Tipo Record                                 Sufixo _record_type
    Vari�vel record                             Sufixo _record
    Par�metro                                   Prefixo p
    Vari�vel global                             Prefixo g
*/

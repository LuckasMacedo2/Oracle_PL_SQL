/*
    Variaveis
    
    Identificadores = nome generico para uma variavel, exceções, cursores, procedures, funções e packages
        devem ter até 30 caracteres.
    Um identificador pode ser definido a partir de aspas duplas, não é considerada uma boa prática
    Ex.:
        "vNumber" NUMBER := 1; (Quoted identifier)
    
    String literal -> variavel do tipo VARCHAR2
    
    Booleano pode ser true, false ou null.
    
    As varaiveis são declaradas na seção DECLARE
    A variavel deve ser declarada antes de ser utilizada
    
    Declaração de varaivel:
        NomeIdentificador [CONSTANT] tipo_dado [NOT NULL] [:= | DEFAULT expressão]; 
    
*/

SET SERVEROUTPUT ON

-- VARIAVEL NÚMERICA
DECLARE
    VNUMERO NUMBER(11, 2) := 1200.50;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Número = ' || VNUMERO);
END;

-- VARIAVEL CHAR
DECLARE 
    VCARACTERTAMFIXO CHAR(2) := 'RS'; -- VARIAVEL COM O TAMANHO LIMITADO
    VCARACTERTAMVARIAVEL VARCHAR2(100) := 'PORTO ALEGRE, RS'; -- COM TAMANHO VARIAVEL, MAS USA APENAS O QUE É NECESSÁRIO
BEGIN
    DBMS_OUTPUT.PUT_LINE('String com tam fixo = ' || VCARACTERTAMFIXO);
    DBMS_OUTPUT.PUT_LINE('String com tam variavel = ' || VCARACTERTAMVARIAVEL);
END;

-- VARIAVEL DATE
DECLARE
    VDATA1 DATE := '29/04/20';
    VDATA2 DATE := '29/04/2020';
BEGIN
    DBMS_OUTPUT.PUT_LINE('DATA1 = ' || VDATA1);
    DBMS_OUTPUT.PUT_LINE('DATA2 = ' || VDATA2);
END;


/*CONSTATES -> Não pode alterar o valor, tem o mesmo valor durante toda a 
existência do bloco
*/
DECLARE
    VPI CONSTANT NUMBER(38,15) := 3.141592;
BEGIN
    DBMS_OUTPUT.PUT_LINE('PI = ' || VPI);
END;

DECLARE 
    VCARACTERTAMFIXO CONSTANT CHAR(2) := 'RS'; -- VARIAVEL COM O TAMANHO LIMITADO
    VCARACTERTAMVARIAVEL CONSTANT VARCHAR2(100) := 'PORTO ALEGRE, RS'; -- COM TAMANHO VARIAVEL, MAS USA APENAS O QUE É NECESSÁRIO
BEGIN
    DBMS_OUTPUT.PUT_LINE('String com tam fixo = ' || VCARACTERTAMFIXO);
    DBMS_OUTPUT.PUT_LINE('String com tam variavel = ' || VCARACTERTAMVARIAVEL);
END;

/*
    Tipo de dado escalar = armazena apenas um valor
    Tipos númericos
        NUMBER (p, s) -> p = número máximo de dígitos (precisão) e s = número de cadas decimais (escala)
        CHAR -> string de tamanho fixo, o tamanho máximo np PL/SQL é de 32767 bytes, enquanto no SQL 2 mil bytes
        VARCHAR2 -> tipo de dado base para strings de tamanho variavel, tam máximo = 32767 bytes, no SQL o tam máximo é de 4000 bytes. Só gasta o que é necessário
        BOOLEAN -> pode ser true, false ou null.
        LONG -> Alfanúmerico de tam variavel, parecido com o VARCHAR, tam máximo no PL/SQL = 32760 bytes. Tam máximo no SQL = 2GB - 1 bytes.
        LONG RAW -> tam máximo de até 32760 bytes no PL/SQL. Armazenamento de arquivos binários. Tam máximo no SQL = 2GB.
        ROWID -> Armazena o rowid de uma linha de uma tabela, endereço lógico de uma linha de uma tabela. É um cha de 18 caracteres.
        DATE -> Armazena datas. Intervalo: 4712 AC até 31/12/9999 DC.
        TIMESTAMP -> Armazena uma data com 9 dígitos de segundos para o segundos
        Suporte para qualquer linguagem do mundo.
        NCHAR -> Tam fixo. 
        NCHAR2 -> Tam variavel.
        BINARY_INTEGER -> Armazenamento de números inteiros são decimais
            Tem mais performance que o tipo de dado number
            
        BINARY_FLOAT -> Precisa simples - 32 bits
        BINARY_DOUBLE -> Precisa dupla - 64 bits     
        
        %TYPE -> Declara uma variavel de acordo com uma coluna do banco de dados ou de outra variavel.
            Define o tipo da variavel a partir do tipo da coluna da tabela
*/

DESC EMPLOYEES;

DECLARE
  vNumero              NUMBER(11,2) := 1200.50;
  vCaracterTamFixo     CHAR(100) := 'Texto de Tamanho Fixo de até 32767 bytes';
  vCaracterTamVariavel VARCHAR2(100) := 'Texto Tamanho variável de até 32767 bytes';
  vBooleano            BOOLEAN := TRUE;
  vData                DATE := sysdate;
  vLong                LONG := 'Texto Tamanho variável de até 32760 bytes';
  vRowid               ROWID;
  vTimestamp           TIMESTAMP := systimestamp;
  vTimestamptz         TIMESTAMP WITH TIME ZONE := systimestamp;
  vCaracterTamFixoUniversal     NCHAR(100) := 'Texto de Tamanho Fixo Universal de até 32767 bytes';
  vCaracterTamVariavelUniversal NVARCHAR2(100) := 'Texto Tamanho variável Universal de até 32767 bytes';
  vNumeroInteiro       BINARY_INTEGER := 1200;
  vNumeroFloat         BINARY_FLOAT := 15000000;
  vNumeroDouble        BINARY_DOUBLE := 15000000;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Numero = ' ||   vNumero);
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Fixo = ' || vCaracterTamFixo );
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Variável = ' || vCaracterTamVariavel );
  IF  vBooleano = TRUE
  THEN 
    DBMS_OUTPUT.PUT_LINE('Booleano = ' || 'TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Booleano = ' || 'FALSE OR NULL');
  END IF;
  DBMS_OUTPUT.PUT_LINE('Data = ' || vData);
  DBMS_OUTPUT.PUT_LINE('Long = ' || vLong );
  SELECT rowid
  INTO   vRowid
  FROM   employees
  WHERE  first_name = 'Steven' AND last_name = 'King';
  DBMS_OUTPUT.PUT_LINE('Rowid = ' || vRowid );
  DBMS_OUTPUT.PUT_LINE('Timestamp = ' || vTimestamp);
  DBMS_OUTPUT.PUT_LINE('Timestamp with time zone= ' || vTimestamptz);
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Fixo = ' || vCaracterTamFixoUniversal );
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Variável = ' || vCaracterTamVariavelUniversal );
  DBMS_OUTPUT.PUT_LINE('Numero Inteiro = ' || vNumeroInteiro);
  DBMS_OUTPUT.PUT_LINE('Numero Float = ' || vNumeroFloat);
  DBMS_OUTPUT.PUT_LINE('Numero Double = ' || vNumeroDouble);
END;

/*
    Variavel Bind
        Variavel declarada no ambiente externo ao bloco, e ela é passada em tempo de execução para um ou mais blocos PL/SQL que podem utilizá-la como qualquer outra variável.
        Você pode referenciar variaveis BINDo declaradas em um ambiente extreno ao bloco PL/SQL.
    EX.:
        VARIABLE gnumero NUMBER;
    Para referenciar uma variavel BIND a mesma deve ser prefoixada com o caracter (:) 
    
    Ex.:
*/

VARIABLE GMEDIA NUMBER;
DECLARE 
    VNUMERO1 NUMBER(11,2) := 2000;
    VNUMERO2 NUMBER(11,2) := 5000;
BEGIN
    :GMEDIA := (VNUMERO1 + VNUMERO2) / 2;
    DBMS_OUTPUT.PUT_LINE('Média = ' || TO_CHAR(:GMEDIA));
EXCEPTION 
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('ERRO ORACLE = ' || SQLCODE || SQLERRM);
END;
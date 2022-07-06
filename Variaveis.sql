/*
    Variaveis
    
    Identificadores = nome generico para uma variavel, exce��es, cursores, procedures, fun��es e packages
        devem ter at� 30 caracteres.
    Um identificador pode ser definido a partir de aspas duplas, n�o � considerada uma boa pr�tica
    Ex.:
        "vNumber" NUMBER := 1; (Quoted identifier)
    
    String literal -> variavel do tipo VARCHAR2
    
    Booleano pode ser true, false ou null.
    
    As varaiveis s�o declaradas na se��o DECLARE
    A variavel deve ser declarada antes de ser utilizada
    
    Declara��o de varaivel:
        NomeIdentificador [CONSTANT] tipo_dado [NOT NULL] [:= | DEFAULT express�o]; 
    
*/

SET SERVEROUTPUT ON

-- VARIAVEL N�MERICA
DECLARE
    VNUMERO NUMBER(11, 2) := 1200.50;
BEGIN
    DBMS_OUTPUT.PUT_LINE('N�mero = ' || VNUMERO);
END;

-- VARIAVEL CHAR
DECLARE 
    VCARACTERTAMFIXO CHAR(2) := 'RS'; -- VARIAVEL COM O TAMANHO LIMITADO
    VCARACTERTAMVARIAVEL VARCHAR2(100) := 'PORTO ALEGRE, RS'; -- COM TAMANHO VARIAVEL, MAS USA APENAS O QUE � NECESS�RIO
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


/*CONSTATES -> N�o pode alterar o valor, tem o mesmo valor durante toda a 
exist�ncia do bloco
*/
DECLARE
    VPI CONSTANT NUMBER(38,15) := 3.141592;
BEGIN
    DBMS_OUTPUT.PUT_LINE('PI = ' || VPI);
END;

DECLARE 
    VCARACTERTAMFIXO CONSTANT CHAR(2) := 'RS'; -- VARIAVEL COM O TAMANHO LIMITADO
    VCARACTERTAMVARIAVEL CONSTANT VARCHAR2(100) := 'PORTO ALEGRE, RS'; -- COM TAMANHO VARIAVEL, MAS USA APENAS O QUE � NECESS�RIO
BEGIN
    DBMS_OUTPUT.PUT_LINE('String com tam fixo = ' || VCARACTERTAMFIXO);
    DBMS_OUTPUT.PUT_LINE('String com tam variavel = ' || VCARACTERTAMVARIAVEL);
END;

/*
    Tipo de dado escalar = armazena apenas um valor
    Tipos n�mericos
        NUMBER (p, s) -> p = n�mero m�ximo de d�gitos (precis�o) e s = n�mero de cadas decimais (escala)
        CHAR -> string de tamanho fixo, o tamanho m�ximo np PL/SQL � de 32767 bytes, enquanto no SQL 2 mil bytes
        VARCHAR2 -> tipo de dado base para strings de tamanho variavel, tam m�ximo = 32767 bytes, no SQL o tam m�ximo � de 4000 bytes. S� gasta o que � necess�rio
        BOOLEAN -> pode ser true, false ou null.
        LONG -> Alfan�merico de tam variavel, parecido com o VARCHAR, tam m�ximo no PL/SQL = 32760 bytes. Tam m�ximo no SQL = 2GB - 1 bytes.
        LONG RAW -> tam m�ximo de at� 32760 bytes no PL/SQL. Armazenamento de arquivos bin�rios. Tam m�ximo no SQL = 2GB.
        ROWID -> Armazena o rowid de uma linha de uma tabela, endere�o l�gico de uma linha de uma tabela. � um cha de 18 caracteres.
        DATE -> Armazena datas. Intervalo: 4712 AC at� 31/12/9999 DC.
        TIMESTAMP -> Armazena uma data com 9 d�gitos de segundos para o segundos
        Suporte para qualquer linguagem do mundo.
        NCHAR -> Tam fixo. 
        NCHAR2 -> Tam variavel.
        BINARY_INTEGER -> Armazenamento de n�meros inteiros s�o decimais
            Tem mais performance que o tipo de dado number
            
        BINARY_FLOAT -> Precisa simples - 32 bits
        BINARY_DOUBLE -> Precisa dupla - 64 bits     
        
        %TYPE -> Declara uma variavel de acordo com uma coluna do banco de dados ou de outra variavel.
            Define o tipo da variavel a partir do tipo da coluna da tabela
*/

DESC EMPLOYEES;

DECLARE
  vNumero              NUMBER(11,2) := 1200.50;
  vCaracterTamFixo     CHAR(100) := 'Texto de Tamanho Fixo de at� 32767 bytes';
  vCaracterTamVariavel VARCHAR2(100) := 'Texto Tamanho vari�vel de at� 32767 bytes';
  vBooleano            BOOLEAN := TRUE;
  vData                DATE := sysdate;
  vLong                LONG := 'Texto Tamanho vari�vel de at� 32760 bytes';
  vRowid               ROWID;
  vTimestamp           TIMESTAMP := systimestamp;
  vTimestamptz         TIMESTAMP WITH TIME ZONE := systimestamp;
  vCaracterTamFixoUniversal     NCHAR(100) := 'Texto de Tamanho Fixo Universal de at� 32767 bytes';
  vCaracterTamVariavelUniversal NVARCHAR2(100) := 'Texto Tamanho vari�vel Universal de at� 32767 bytes';
  vNumeroInteiro       BINARY_INTEGER := 1200;
  vNumeroFloat         BINARY_FLOAT := 15000000;
  vNumeroDouble        BINARY_DOUBLE := 15000000;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Numero = ' ||   vNumero);
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Fixo = ' || vCaracterTamFixo );
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Vari�vel = ' || vCaracterTamVariavel );
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
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Vari�vel = ' || vCaracterTamVariavelUniversal );
  DBMS_OUTPUT.PUT_LINE('Numero Inteiro = ' || vNumeroInteiro);
  DBMS_OUTPUT.PUT_LINE('Numero Float = ' || vNumeroFloat);
  DBMS_OUTPUT.PUT_LINE('Numero Double = ' || vNumeroDouble);
END;

/*
    Variavel Bind
        Variavel declarada no ambiente externo ao bloco, e ela � passada em tempo de execu��o para um ou mais blocos PL/SQL que podem utiliz�-la como qualquer outra vari�vel.
        Voc� pode referenciar variaveis BINDo declaradas em um ambiente extreno ao bloco PL/SQL.
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
    DBMS_OUTPUT.PUT_LINE('M�dia = ' || TO_CHAR(:GMEDIA));
EXCEPTION 
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('ERRO ORACLE = ' || SQLCODE || SQLERRM);
END;
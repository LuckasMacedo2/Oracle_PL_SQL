/*
    Comandos PL/SQL s�o exwecutados pelo PL/SQL statement executor
    Comandos SQL s�o exwecutados pelo SQL statement executor
    
    O Context Switch ocorre quando o PL/SQL runtime encontra uma instru��o SQL
    e muda para o SQL statement executor, a informa��o � executada e retorna para
    o PL/SQL runtime. Cada troca de contexto coloca uma sobrecarga (overhead) que
    deteriora o programa.
    
    Bulk Collect melhora a performance, de forma que o comando SELECT retorne
    muitas linhas em um �nico FETCH
    Deve ser utilizada com modera��o
    Pode consumir muita mem�ria
    
    Associative Array of record: Toda a estrutura do array possui uma estrutura de 
    campos de um record
    
    Para tabelas muito grandes � recomendado utilizar um cursor
    Ao carregar uma tabela para a collection toda a tabela � carregada para a mem�ria
    
    Nested table of record
    
    VArray of records - Necess�rio saber o tamanho da tabela
    
    M�todos para controlar uma collection
    M�todo      Descri��o                                   Tipos de collection
    EXISTS(n)   True se o elemento n existe                 Todos
    COUNT       Retorna o n�mero de elementos               Todos
    FIRST       Retorna o primeiro n�mero do indice         Todos
                Retorna NULL se a collection est� vazia
    LAST        Retorna o �ltimo n�mero do indice           Todos
                Retorna NULL se a collection est� vazia
    LIMIT       Retorna o maior valor poss�vel do indice    VARRAY
    PRIOR(n)    Retorna o n�mero do �ndice anterior a n     Todos
    NEXT(n)     Retorno o n�mero do �ndice posterior a n    Todos
    EXTEND(n)   Aumenta o tamanho                           Nested Table e VARRAY
                EXTEND adiciona um elemento nulo
                EXTEND(n) adiciona n elementos nulos
                EXTEND(n, i) adiciona n c�pias do elemento i
    TRIM        Remove um elemento do final da collection
                TRIM(n) remove n elementos do final da collection
    DELETE      Remove todos os elementos da collection
                DELETE(n) remove o elemento n da collection
                DELETE(m, n) remove todos os elementos da faixa 
                m ..n da collection
    
*/

-- Associative Array of Records - Bulk Collect
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  TYPE employees_table_type IS TABLE OF employees%rowtype
  INDEX BY BINARY_INTEGER;  -- Type Associative Array
  employees_table  employees_table_type;
BEGIN
  SELECT *
    BULK COLLECT INTO employees_table 
  FROM employees;
  FOR i IN employees_table.first..employees_table.last  
  LOOP
    DBMS_OUTPUT.PUT_LINE(employees_table(i).employee_id || ' - ' || 
                         employees_table(i).first_name || ' - ' || 
                         employees_table(i).last_name || ' - ' ||
                         employees_table(i).phone_number || ' - ' ||
                         employees_table(i).job_id || ' - ' ||
                         TO_CHAR(employees_table(i).salary,'99G999G999D99'));   
  END LOOP;
END;

-- NESTED TABLE
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  TYPE employees_table_type IS TABLE OF employees%rowtype;
  employees_table  employees_table_type := employees_table_type();
BEGIN
  SELECT *
    BULK COLLECT INTO employees_table 
  FROM employees;
  FOR i IN employees_table.first..employees_table.last  
  LOOP
    DBMS_OUTPUT.PUT_LINE(employees_table(i).employee_id || ' - ' || 
                         employees_table(i).first_name || ' - ' || 
                         employees_table(i).last_name || ' - ' ||
                         employees_table(i).phone_number || ' - ' ||
                         employees_table(i).job_id || ' - ' ||
                         TO_CHAR(employees_table(i).salary,'99G999G999D99'));   
  END LOOP;
END;

-- Varray of Records - Bulk Collect
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  TYPE employees_table_type IS VARRAY (200) OF employees%rowtype; -- 200 = limite da tabela
  employees_table  employees_table_type := employees_table_type();
BEGIN
  SELECT *
    BULK COLLECT INTO employees_table 
  FROM employees;
  FOR i IN employees_table.first..employees_table.last  
  LOOP
    DBMS_OUTPUT.PUT_LINE(employees_table(i).employee_id || ' - ' || 
                         employees_table(i).first_name || ' - ' || 
                         employees_table(i).last_name || ' - ' ||
                         employees_table(i).phone_number || ' - ' ||
                         employees_table(i).job_id || ' - ' ||
                         TO_CHAR(employees_table(i).salary,'99G999G999D99'));   
  END LOOP;
END;

-- M�todos para controlar collections
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  TYPE employees_table_type IS TABLE OF employees%rowtype;
  employees_table  employees_table_type := employees_table_type();
BEGIN
  SELECT *
    BULK COLLECT INTO employees_table 
  FROM employees;
  FOR i IN employees_table.first..employees_table.last  
  LOOP
    DBMS_OUTPUT.PUT_LINE(employees_table(i).employee_id || ' - ' || 
                         employees_table(i).first_name || ' - ' || 
                         employees_table(i).last_name || ' - ' ||
                         employees_table(i).phone_number || ' - ' ||
                         employees_table(i).job_id || ' - ' ||
                         TO_CHAR(employees_table(i).salary,'99G999G999D99'));   
  END LOOP;
END;
/*
    Comandos PL/SQL são exwecutados pelo PL/SQL statement executor
    Comandos SQL são exwecutados pelo SQL statement executor
    
    O Context Switch ocorre quando o PL/SQL runtime encontra uma instrução SQL
    e muda para o SQL statement executor, a informação é executada e retorna para
    o PL/SQL runtime. Cada troca de contexto coloca uma sobrecarga (overhead) que
    deteriora o programa.
    
    Bulk Collect melhora a performance, de forma que o comando SELECT retorne
    muitas linhas em um único FETCH
    Deve ser utilizada com moderação
    Pode consumir muita memória
    
    Associative Array of record: Toda a estrutura do array possui uma estrutura de 
    campos de um record
    
    Para tabelas muito grandes é recomendado utilizar um cursor
    Ao carregar uma tabela para a collection toda a tabela é carregada para a memória
    
    Nested table of record
    
    VArray of records - Necessário saber o tamanho da tabela
    
    Métodos para controlar uma collection
    Método      Descrição                                   Tipos de collection
    EXISTS(n)   True se o elemento n existe                 Todos
    COUNT       Retorna o número de elementos               Todos
    FIRST       Retorna o primeiro número do indice         Todos
                Retorna NULL se a collection está vazia
    LAST        Retorna o último número do indice           Todos
                Retorna NULL se a collection está vazia
    LIMIT       Retorna o maior valor possível do indice    VARRAY
    PRIOR(n)    Retorna o número do índice anterior a n     Todos
    NEXT(n)     Retorno o número do índice posterior a n    Todos
    EXTEND(n)   Aumenta o tamanho                           Nested Table e VARRAY
                EXTEND adiciona um elemento nulo
                EXTEND(n) adiciona n elementos nulos
                EXTEND(n, i) adiciona n cópias do elemento i
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

-- Métodos para controlar collections
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
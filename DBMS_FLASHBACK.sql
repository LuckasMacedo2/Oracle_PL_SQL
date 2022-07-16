/*
    Permite ao usuário uma image específica do banco de dados até um ponto especifico no passado
    Utiliza os segmentos de Undo para retornar o passado a partir deles
    Usada para:
        Transação errada
    
    Pode-se utilizar a package a partir de um momento no tempo 
    Ou a partir do valor da SYSTEM CHANGE NUMBER (SCN) (número da transação)
    
    Deve-se conceder o privilégio de execute na package a partir do DBA
    O tempo de undo é definido pelo DBA
    
    Para voltar no passado utiliza-se a procedure DBMS_FLASHBACK.ENABLE_AT_TIME
    passando a data ao qual se deseja voltar
    
    DBMS_FLASHBACK.DISABLE volta para o presente
    
    O flashback só pode ser utilizado em um PL/SQL com SQL dinâmico
    
    ** Comandos DDL tem commit automático **
*/

grant execute on DBMS_FLASHBACK to hr;

-- Conectar como hr

-- Causando um problema 

SELECT employee_id, first_name, last_name, job_id, salary
FROM   employees
WHERE  job_id = 'IT_PROG';
/*
214	ABACAXI	BATATA	IT_PROG	22500
209	KOBE	BRYANT	IT_PROG	33750
*/

UPDATE employees
SET    salary = salary * 2
WHERE  job_id = 'IT_PROG';

SELECT employee_id, first_name, last_name, job_id, salary
FROM   employees
WHERE  job_id = 'IT_PROG';

COMMIT;

-- Utilizando a Package DBMS_FLASHBACK
-- Resolve o problema usando a package
DECLARE
  CURSOR c_employees IS
    SELECT *
    FROM   employees
    WHERE  job_id = 'IT_PROG';
    
   r_employees  c_employees%ROWTYPE;
BEGIN
  DBMS_FLASHBACK.enable_at_time(sysdate - 30 / 1440);  -- Posicionando 10 minutos no passado
  
  OPEN c_employees; -- Select no momento do flashback
  
  DBMS_FLASHBACK.disable;  -- Posicionando de volta ao presente

  LOOP 
    FETCH c_employees INTO r_employees; 
    
    EXIT WHEN c_employees%NOTFOUND; 
    
    UPDATE employees 
    SET    salary = r_employees.salary
    WHERE  employee_id = r_employees.employee_id;
    
  END LOOP; 
  
  CLOSE c_employees;
  COMMIT;
END;

-- Consultando após a correção do problema

SELECT employee_id, first_name, last_name, job_id, salary
FROM   employees
WHERE  job_id = 'IT_PROG';

/*
    Flashback query
    Fazer um select para uma tabela em m tempo para ver como ela estava naquele momento.
    Select:
    SELECT COLUNAS FROM TABELA AS TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE)
    INTERVAL
    INTERVAL 'X' YEAR
    INTERVAL 'X' MONTH
    INTERVAL 'X' DAY
    INTERVAL 'X' HOUR
    INTERVAL 'X' MINUTE
    INTERVAL 'X' SECOND
    INTERVAL 'X-Y' YEAR TO MONTH
    INTERVAL 'X Y:Z' DAY TO MINUTE
    INTERVAL 'X:Y' HOUR TO MINUTE
    INTERVAL 'X:Y.Z' MINUTE TO SECOND 
*/

SELECT employee_id, first_name, last_name, job_id, salary
FROM   employees
WHERE  job_id = 'FI_ACCOUNT';

/*
109	Daniel	Faviet	FI_ACCOUNT	22275
110	John	Chen	FI_ACCOUNT	18450
*/

UPDATE employees
SET    salary = salary * 2
WHERE  job_id = 'FI_ACCOUNT';

SELECT employee_id, first_name, last_name, job_id, salary
FROM   employees
WHERE  job_id = 'FI_ACCOUNT';

COMMIT;


DECLARE
  CURSOR c_employees IS
    SELECT *
    FROM   employees as of timestamp (systimestamp - interval '15' minute);
    
  r_employees  c_employees%ROWTYPE;
  
BEGIN  
  OPEN c_employees;

  LOOP 
    FETCH c_employees INTO r_employees; 
    
    EXIT WHEN c_employees%NOTFOUND; 
    
    UPDATE employees 
    SET    salary = r_employees.salary
    WHERE  employee_id = r_employees.employee_id;
    
  END LOOP; 
  
  CLOSE c_employees;
  
  COMMIT;
END;

-- Consultando após a correção do problema

SELECT employee_id, first_name, last_name, job_id, salary
FROM   employees
WHERE  job_id = 'FI_ACCOUNT';

-- Executar no usuário sys
-- Verificando o parâmetro undo_retention que define o tempo de retenção do undo
SELECT NAME, VALUE FROM V$PARAMETER -- Visão de performance dinâmica v$Parameter
WHERE NAME LIKE '%undo%';
-- O que de fato define quanto tempo o undo ficará armazenado é o tamanho da tablespace de undo

/*
    Flashback drop
    
    Permite recuperar uma tabela deletada indevidamente
    
    Lixeira: Contém todos os objetos dropados 
    Ela fica na lixeira até que seja realizado o comando PURGE
    Ou quando a tablespace fica cheia
    Para restaurá-lo basta utilizar o objeto BEFORE DROP.
    Para remover da lixeira comando: PURGE TABLE nome_tabela;
    
    SELECT na USER_RECYCLEBIN / RECYCLEBIN -> objetos dropados
    
    Ao utilizar este método para recuperar os dados as contraints de foreign key não são trazidas
    
    
*/

CREATE TABLE employees_copia 
AS
SELECT *
FROM employees;

SELECT *
FROM   user_objects
WHERE  object_name = 'EMPLOYEES_COPIA';

SELECT *
FROM employees_copia;

-- Removendo um objeto

DROP TABLE employees_copia;

SELECT *
FROM   user_objects
WHERE  object_name = 'EMPLOYEES_COPIA';

SELECT *
FROM employees_copia;

-- Consultando a Lixeira

SELECT *
FROM   user_recyclebin
WHERE  original_name = 'EMPLOYEES_COPIA';

-- Confimando que o objeto foi removido

SELECT *
FROM   user_objects
WHERE object_name = 'EMPLOYEES_COPIA';

-- Restaurando o Objeto a partir da Lixeira

FLASHBACK TABLE EMPLOYEES_COPIA TO BEFORE DROP; -- Recupra a tabela

-- Confimando que o objeto foi restaurado

SELECT *
FROM user_objects
WHERE object_name = 'EMPLOYEES_COPIA';

SELECT *
FROM employees_copia;

SELECT *
FROM   user_recyclebin
WHERE  original_name = 'EMPLOYEES_COPIA';

/*
    Flashback table
    Permite recuperar uma ou mais tabelas para um determinado momento do tempo
    Volta a(s) tabela(s) para uma posição no passado
    Pode gerar problemas de inconsistências por causa das constraints
    Ao usar algum destes comandos não é possível mais voltar a tabela
    ALTER TABLE ... DROP COLUMN
    ALTER TABLE DROP PARTITION
    CREATE CLUSTER
    TRUNCATE TABLE
    ALTER TABLE ... MOVE
*/

CREATE TABLE employees_copia2
AS
SELECT *
FROM employees;

Conectado como SYS 

GRANT FLASHBACK ON hr.employees_copia2 TO hr;

Conectado como SYS ou HR

ALTER TABLE hr.employees_copia2 ENABLE ROW MOVEMENT;

-- Conectado como HR

SELECT *
FROM hr.employees_copia2 ;

DELETE FROM hr.employees_copia2 ;

COMMIT;

-- Consultando a Tabela

SELECT *
FROM hr.employees_copia2 ;

-- Resaurando a Tabela para posição de 5 minutos atras

FLASHBACK TABLE hr.employees_copia2 TO TIMESTAMP systimestamp - interval '5' minute;

-- Consultando a Tabela

SELECT *
FROM hr.employees_copia2;


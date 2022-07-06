 /*
    Função quando retornar valor
    Caso o bloco não retorne nada, usar Procedure
    Deve-se declarar o tipo de variavel
    O retorno ocorre no BEGIN
    Procedutre não tem retorno
    Função pode ter parâmetro OUT.
    
    Pode-se utilizar funções SQL em comandos SQL
    A função deve comtemplar o seguinte para pode ser utilizada em um comando SQL
        ser armazenada no servidor do banco de dados
        deve retornar uma linha
        não pode ter comandos DML
        deve conter apenas parâmetros do tipo IN
        não pode retornar boolean, record ou table
        procedures não pode ser utilizada
    
    DUAL tabela que existe no Oracle com apenas uma linha
    
    Recompilando funções 
        ALTER FUNCTION nome_funcao COMPILE;
        
    Removendo funções
        DROP FUNCTION nome_funcao
 */
CREATE OR REPLACE FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO
  (pemployee_id   IN NUMBER)
   RETURN NUMBER
IS 
  vSalary  employees.salary%TYPE;
BEGIN
  SELECT salary
  INTO   vsalary
  FROM   employees
  WHERE employee_id = pemployee_id;
  RETURN (vsalary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20001, 'Empregado inexistente');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || ' - ' || SQLERRM);
END;

SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT pemployee_id PROMPT 'Digite o Id do empregado: '
DECLARE
  vEmployee_id  employees.employee_id%TYPE := &pemployee_id;
  vSalary       employees.salary%TYPE;
BEGIN
  vsalary := FNC_CONSULTA_SALARIO_EMPREGADO(vEmployee_id);
  DBMS_OUTPUT.PUT_LINE('Salario: ' || vsalary);
END;

CREATE OR REPLACE FUNCTION FNC_CONSULTA_TITULO_CARGO_EMPREGADO
  (pjob_id   IN jobs.job_id%TYPE)
   RETURN VARCHAR2
IS 
  vJob_title jobs.job_title%TYPE;
BEGIN
  SELECT job_title
  INTO   vJob_title
  FROM   jobs
  WHERE  job_id = pjob_id;
  RETURN (vJob_title);
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20001, 'Job inexistente');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || ' - ' || SQLERRM);
END;

-- Utilizando Funções em comandos SQL
-- Semelhante a um inner join
SELECT employee_id, first_name, last_name, job_id, FNC_CONSULTA_TITULO_CARGO_EMPREGADO(job_id) "JOB TITLE"
FROM   employees;

-- Executando a Função pelo comando SELECT
SELECT FNC_CONSULTA_TITULO_CARGO_EMPREGADO('IT_PROG')
FROM   dual;

-- Executando a Função pelo comando SELECT
SELECT FNC_CONSULTA_SALARIO_EMPREGADO(130)
FROM   dual;

-- Recompilando uma função
ALTER FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO COMPILE;

-- Deletando uma função
DROP FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO;
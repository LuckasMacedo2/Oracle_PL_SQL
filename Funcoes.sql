 /*
    Fun��o quando retornar valor
    Caso o bloco n�o retorne nada, usar Procedure
    Deve-se declarar o tipo de variavel
    O retorno ocorre no BEGIN
    Procedutre n�o tem retorno
    Fun��o pode ter par�metro OUT.
    
    Pode-se utilizar fun��es SQL em comandos SQL
    A fun��o deve comtemplar o seguinte para pode ser utilizada em um comando SQL
        ser armazenada no servidor do banco de dados
        deve retornar uma linha
        n�o pode ter comandos DML
        deve conter apenas par�metros do tipo IN
        n�o pode retornar boolean, record ou table
        procedures n�o pode ser utilizada
    
    DUAL tabela que existe no Oracle com apenas uma linha
    
    Recompilando fun��es 
        ALTER FUNCTION nome_funcao COMPILE;
        
    Removendo fun��es
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

-- Utilizando Fun��es em comandos SQL
-- Semelhante a um inner join
SELECT employee_id, first_name, last_name, job_id, FNC_CONSULTA_TITULO_CARGO_EMPREGADO(job_id) "JOB TITLE"
FROM   employees;

-- Executando a Fun��o pelo comando SELECT
SELECT FNC_CONSULTA_TITULO_CARGO_EMPREGADO('IT_PROG')
FROM   dual;

-- Executando a Fun��o pelo comando SELECT
SELECT FNC_CONSULTA_SALARIO_EMPREGADO(130)
FROM   dual;

-- Recompilando uma fun��o
ALTER FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO COMPILE;

-- Deletando uma fun��o
DROP FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO;
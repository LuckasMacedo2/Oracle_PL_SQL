/*
    Table Function
*/

DROP TYPE employees_row;
CREATE TYPE employees_row AS OBJECT
( e_employee_id   NUMBER(6),
  e_first_name    VARCHAR2(20),
  e_last_name     VARCHAR2(25),
  e_email         VARCHAR2(25),
  e_phone_number  VARCHAR2(20),
  e_hire_date     DATE,
  e_job_id        VARCHAR2(10),
  e_salary        NUMBER(8,2),
  e_commission_pct NUMBER(2,2),
  e_manager_id     NUMBER(6,0),
  e_department_id  NUMBER(4,0));
  
-- Criação de Table utilizando Tipos no Banco de Dados
DROP TYPE employees_table;
CREATE TYPE employees_table IS TABLE OF employees_row;

CREATE OR REPLACE FUNCTION FNC_FETCH_EMPLOYEES_TABLE
  (pdepartment_id IN NUMBER)
   RETURN employees_table
IS 
  v_employees_table  employees_table := employees_table();
BEGIN
  FOR e IN 
    (SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, 
            salary, commission_pct, manager_id, department_id
     FROM   employees
     WHERE  department_id = pdepartment_id)
  LOOP
    v_employees_table.EXTEND;
    v_employees_table(v_employees_table.LAST) := employees_row(e.employee_id, e.first_name, e.last_name, e.email, e.phone_number,
                                                                e.hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id, 
                                                                e.department_id);
  END LOOP;
  RETURN v_employees_table;
END;

-- Utilizando a Table Function
SELECT *
FROM   TABLE(FNC_FETCH_EMPLOYEES_TABLE(60));

/*
    Pipelined Function alternativas a table function
    Uma table function retorna uma collection
    Uma collection muito grande pode consumir muita memória
    Uma pipelined function já retorna a linha assim que ela é criada. Retorna uma de cada vez
*/


CREATE OR REPLACE FUNCTION FNC_FETCH_EMPLOYEES_TABLE_PIPELINE
  (pdepartment_id IN NUMBER)
   RETURN employees_table
   PIPELINED
IS 
  v_employees_table  employees_table := employees_table();
BEGIN
  FOR e IN 
    (SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, 
            salary, commission_pct, manager_id, department_id
     FROM   employees
     WHERE  department_id = pdepartment_id)
  LOOP
    PIPE ROW(employees_row(e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, -- PIPE ROW retorna uma linha
                           e.hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id, 
                           e.department_id));
  END LOOP;
END;

-- Utilizando a Pipelined Function

SELECT *
FROM   TABLE(FNC_FETCH_EMPLOYEES_TABLE_PIPELINE(60));
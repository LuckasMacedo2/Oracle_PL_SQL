/*
    Package UTL_FILE
        Comandos necessários para ler e escrever dados em arquivos
        Precisa-se criar um diretório com o sys
        Deve-se criar um objeto directory para que seja lido apenas diretórios 
        por quem tem permissões
    Criar o objeto directory > passar o privilégio para o usuário
*/

CREATE OR REPLACE DIRECTORY ARQUIVOS AS 'F:\Estudos\Bootcamps e Cursos\SQL Oracle\Arquivos';

GRANT READ, WRITE ON DIRECTORY Arquivos TO hr;

-- Gravando um arquivo texto
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  vfile  UTL_FILE.FILE_TYPE; -- Id de um arquivo
  CURSOR employees_c IS
  SELECT employee_id, first_name, last_name, job_id, salary
  FROM   employees;
BEGIN
  vfile := UTL_FILE.FOPEN('ARQUIVOS', 'employees.txt','w',32767); -- Abre o arquivo recebe o id, nome do arquivo a ser aberto, tipo de arquivo w = write r = read, tamanho do buffer
  FOR  employees_r IN employees_c LOOP
    UTL_FILE.PUT_LINE(vfile, employees_r.employee_id || ';' || 
                             employees_r.first_name || ';' || 
                             employees_r.last_name || ';' ||
                             employees_r.job_id || ';' || 
                             employees_r.salary);
  END LOOP;
  UTL_FILE.FCLOSE(vfile); -- Fecha o arquivo
  DBMS_OUTPUT.PUT_LINE('Arquivo Texto employees.txt gerado com sucesso');
EXCEPTION
  WHEN UTL_FILE.INVALID_PATH THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Diretório Inválido');
  WHEN UTL_FILE.INVALID_OPERATION THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Operação invalida no arquivo');
  WHEN UTL_FILE.WRITE_ERROR THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro de gravação no arquivo');     
  WHEN UTL_FILE.INVALID_MODE THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Modo de acesso inválido');
  WHEN OTHERS THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro Oracle:' || SQLCODE || SQLERRM);
END;

-- Lendo um arquivo Texto

SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  vfile  UTL_FILE.FILE_TYPE;
  vregistro  VARCHAR2(400);
BEGIN
  vfile := UTL_FILE.FOPEN('ARQUIVOS', 'employees.txt','r',32767);
  LOOP  
    UTL_FILE.GET_LINE(vfile, vregistro);
    DBMS_OUTPUT.PUT_LINE(vregistro);
  END LOOP;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Arquivo Texto employees.txt lido com sucesso');
  WHEN UTL_FILE.INVALID_PATH THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Diretório Inválido');
  WHEN OTHERS THEN
      UTL_FILE.FCLOSE(vfile);
      DBMS_OUTPUT.PUT_LINE('Erro Oracle:' || SQLCODE || SQLERRM);
END;

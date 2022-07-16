/*
    LOBs = Large Objects
    Permitem armazenar dados desestruturados no banco de dados, como, PDF, imagens, m�sicas etc.
    Podem ser lidos por linguagens de programa��o
    Categorias
        LOB interno: Ficam dentro do banco de dados
            Participam da transa��o do banco de dados
            CLOB -> LOB do tipo de caracter, armazena o arquivo no formato do padr�o de texto definido no banco
            O tamanho m�ximo � de (4GB - 1) * DB_BLOCK_SIZE. DB_BLOCK_SIZE = par�metro que define o tamanho do bloco do banco de dados pode ir de 2KB para 32 KB.
            DB_BLOCK_SIZE � definido na cria��o do banco e ap�s criar n�o pode ser alterado
            BLOB -> LOB bin�rio, como, v�deo, pdf etc.
            NCLOB -> varia��o do CLOB que permite armazenar dados multiple-byte. De qualquer l�ngua do mundo
        LOB externo: Ponteiro para o arquivo
            Ficam em arquivos do SO
            Na coluna existe apenas uma refer�ncia ao arquivo externo, n�o faz parte de transa��o
        BFILE -> coluna que armazena um LOB externo, s� pode referenciar um arquivo de 4G, tam m�ximo do nome do arquivo = 255 caracteres, tam. m�x do nome do diret�rio = 30 caracteres
        
    LOBs n�o podem ser utilizados em tabelas clustered table
    LOBs n�o podem ser analisados utilizando o comando ANALYZE
    LOBS n�o podem ser inclu�dos em um �ndice particionado
    LOBs n�o podem ser utilizados em um VARRAY
    Tamb�m n�o podem ser utilizados em alguma parte de algum dos comandos a seguir:
        GROUP BY
        ORDER BY
        SELECT DISTINCT
        JOIN
        Fun��es de agrega��o
    Ao referenciar um LOB o Oracle tr�s um locator que � um ponteiro que aponta para a localiza��o do LOB
    Ele � retornado o valor do LOB
    
*/

/*
    CLOB -> Caractere LOB
    Quando o CLOB possuir menos que 100k pode se utilizar as fun��es do SQL
    Quando possui mais de 100k deve-se utilizar as fun��es da package DBMS_LOB
    Os dados de uma CLOB podem ficar em outro bloco diferente do bloco da tabela
    
    EMPTY_CLOB() -> Cria o localizador para o CLOB
*/

DROP TABLE job_resumes;
CREATE TABLE job_resumes
(resume_id   NUMBER,
 first_name  VARCHAR2(200),
 last_name   VARCHAR2(200),
 resume      CLOB);
 
INSERT INTO job_resumes
VALUES (1, 'Paul', 'Jones', EMPTY_CLOB());

COMMIT;
 
SELECT resume_id, first_name, last_name, SUBSTR(resume,1,30)
FROM   job_resumes;

SELECT LENGTH(resume), DBMS_LOB.GETLENGTH(resume)
FROM   job_resumes;

SELECT DBMS_LOB.SUBSTR(resume,DBMS_LOB.GETLENGTH(resume),1) 
FROM   job_resumes;

-- Inserindo dados na coluna CLOB

INSERT INTO job_resumes 
VALUES  (2, 'Robert','Johnson' , 'Project Manager - Scrum Master, Porto Alegre, RS, Brasil');

SELECT resume_id, first_name, last_name, SUBSTR(resume,1,30)
FROM   job_resumes;

SELECT LENGTH(resume), DBMS_LOB.GETLENGTH(resume)
FROM   job_resumes;

SELECT DBMS_LOB.SUBSTR(resume,DBMS_LOB.GETLENGTH(resume),1) 
FROM   job_resumes;

COMMIT;

CREATE OR REPLACE PROCEDURE PRC_INSERE_RESUME
(presume_id IN job_resumes.resume_id%TYPE, presume IN VARCHAR2) 
IS
   vresume_localizador    CLOB; -- Localizador do CLOB
   vTamanho_Texto         NUMBER;
   vDeslocamento          NUMBER;
BEGIN
   SELECT resume
   INTO   vresume_localizador -- Tr�s o localizador da coluna CLOB
   FROM   job_resumes
   WHERE  resume_id = presume_id
   FOR UPDATE; -- Seleciona a linha para o update

   vDeslocamento := 1;
   vTamanho_Texto := LENGTH(presume);
   DBMS_LOB.WRITE(vresume_localizador,vTamanho_Texto,vDeslocamento,presume);
   COMMIT;
END;

exec PRC_INSERE_RESUME(1,'DBA - Database administrator , Porto Alegre, RS, Brasil')

SELECT resume_id, first_name, last_name, SUBSTR(resume,1,30)
FROM   job_resumes;

SELECT LENGTH(resume), DBMS_LOB.GETLENGTH(resume)
FROM   job_resumes;

SELECT DBMS_LOB.SUBSTR(resume,DBMS_LOB.GETLENGTH(resume),1) 
FROM   job_resumes;

CREATE OR REPLACE PROCEDURE PRC_EXIBE_RESUME
(presume_id IN job_resumes.resume_id%TYPE) 
IS
   vresume_localizador    CLOB;
   vTamanho_Texto         NUMBER;
   vDeslocamento          NUMBER;
   vTexto                 VARCHAR2(32767);
   vLoop                  NUMBER;
   vQuantidade            NUMBER := 1;
   vExibe                 VARCHAR2(240);
BEGIN
   SELECT resume
   INTO   vresume_localizador
   FROM   job_resumes
   WHERE  resume_id = presume_id
   FOR UPDATE;

   vDeslocamento := 1;
   vTamanho_Texto := DBMS_LOB.GETLENGTH(vresume_localizador);
   DBMS_LOB.READ(vresume_localizador,vTamanho_Texto,vDeslocamento,vTexto);  -- Lendo o CLOB
   vLoop := TRUNC((LENGTH(vTexto))/240)+1;
   FOR i IN 1 .. vLoop LOOP
     vExibe := SUBSTR(vTexto,vQuantidade,240);
     vQuantidade := vQuantidade + 240;
     DBMS_OUTPUT.PUT_LINE(vExibe);
   END LOOP;
   COMMIT;
END;

SET SERVEROUTPUT ON
exec PRC_EXIBE_RESUME(1)

exec PRC_EXIBE_RESUME(2)

/*
    BLOB -> LOB bin�rio
    Armazena dados bin�rios
    EMPTY_CLOB() -> Inicia o BLOB criando o inicializador para a mesma
*/

DROP TABLE job_profiles;
CREATE TABLE job_profiles
(resume_id   NUMBER,
 first_name  VARCHAR2(200),
 last_name   VARCHAR2(200),
 profile_picture  BLOB);
 
-- Conectar como SYS

CREATE DIRECTORY IMAGENS AS 'F:\Estudos\Bootcamps e Cursos\SQL Oracle\Imagens';
GRANT READ, WRITE ON DIRECTORY imagens TO hr;

-- Criar uma pasta C:\imagens no windows

-- Importando uma imagens de um arquivo bin�rio para uma coluna BLOB

DECLARE
  vArquivoOrigem   BFILE;  -- Arquivo externo 
  vBlobDestino     BLOB;
  vNomeArquivo     VARCHAR2(100) := '1583857436185192120.png';
  vDiretorio       VARCHAR2(100) := 'IMAGENS';
BEGIN
  vArquivoOrigem := BFILENAME(vDiretorio,vNomeArquivo);
  
  IF DBMS_LOB.FILEEXISTS(vArquivoOrigem) = 1 THEN
     INSERT INTO job_profiles
     VALUES (1, 'Oracle', 'Man', EMPTY_BLOB())
       RETURNING profile_picture INTO vBlobDestino;
    
    DBMS_LOB.OPEN(vArquivoOrigem, DBMS_LOB.LOB_READONLY);
    DBMS_LOB.LOADFROMFILE(vBlobDestino, vArquivoOrigem, DBMS_LOB.GETLENGTH(vArquivoOrigem)); -- Carrega o arquivo
    DBMS_LOB.CLOSE(vArquivoOrigem);
  
    COMMIT;
  ELSE 
    DBMS_OUTPUT.PUT_LINE('Arquivo: ' || vNomeArquivo || ' n�o existe!');
  END IF;
EXCEPTION
  WHEN others THEN
    DBMS_LOB.CLOSE(vArquivoOrigem);
    RAISE_APPLICATION_ERROR(-20001,'Erro Oracle ' || SQLCODE || SQLERRM);
END;

SELECT *
FROM job_profiles;

-- Exportando uma imagens a partir de uma coluna BLOB para um arquivo do S.O.
--

DECLARE
  vArquivoDestino   UTL_FILE.FILE_TYPE;  -- Armazena o ponteiro do arquivo
  vBuffer           RAW(32767);
  vQuantidade       BINARY_INTEGER := 32767;
  vPosicao          INTEGER := 1;
  vBlobOrigem       BLOB;
  vTamanhoBlob      INTEGER;
  vNomeArquivoDestino  VARCHAR2(100) := 'CursoOracleCompletoCopia.png';
  vDiretorioDestino    VARCHAR2(100) := 'IMAGENS';
  vResumeId         NUMBER := 1;
BEGIN
  SELECT profile_picture
  INTO   vBlobOrigem
  FROM   job_profiles
  WHERE  resume_id = vResumeId
  FOR UPDATE;
  
  vTamanhoBlob := DBMS_LOB.GETLENGTH(vBlobOrigem);
  DBMS_OUTPUT.PUT_LINE('Tamanho do arquivo: '||vTamanhoBlob);      

-- Cria o arquivo bin�rio de destino
  vArquivoDestino := UTL_FILE.FOPEN(vDiretorioDestino,vNomeArquivoDestino,'wb',32767);
  
  -- Leitura do BLOB e escrita no arquivo
  WHILE vPosicao < vTamanhoBlob LOOP
    DBMS_LOB.READ (vBlobOrigem, vQuantidade, vPosicao, vBuffer);
    UTL_FILE.PUT_RAW(vArquivoDestino,vBuffer , TRUE); -- Gravando um arquivo bin�rio
    vPosicao := vPosicao + vQuantidade;
  END LOOP;
  -- Fecha o arquivo.
  UTL_FILE.FCLOSE(vArquivoDestino);

EXCEPTION
  WHEN others THEN
    IF UTL_FILE.is_open(vArquivoDestino) THEN
       UTL_FILE.FCLOSE(vArquivoDestino);
       RAISE_APPLICATION_ERROR(-20001,'Erro Oracle ' || SQLCODE || SQLERRM);
    END IF;
    RAISE_APPLICATION_ERROR(-20001,'Erro Oracle ' || SQLCODE || SQLERRM);
END;


-- Exemplo de Atualiza��o de uma coluna BLOB

DECLARE
  vArquivoOrigem   BFILE;  
  vBlobDestino     BLOB;
  vNomeArquivo     VARCHAR2(100) := 'PLEspecialista.jpg';
  vDiretorio       VARCHAR2(100) := 'IMAGENS';
BEGIN
  vArquivoOrigem := BFILENAME(vDiretorio,vNomeArquivo);
  
  IF DBMS_LOB.FILEEXISTS(vArquivoOrigem) = 1 THEN
     SELECT profile_picture
     INTO vBlobDestino
     FROM job_profiles
     WHERE resume_id = 1
     FOR UPDATE;
    
    DBMS_LOB.OPEN(vArquivoOrigem, DBMS_LOB.LOB_READONLY);
    DBMS_LOB.TRIM(vBlobDestino, 0);
    DBMS_LOB.LOADFROMFILE(vBlobDestino, vArquivoOrigem, DBMS_LOB.GETLENGTH(vArquivoOrigem));
    DBMS_LOB.CLOSE(vArquivoOrigem);
  
    COMMIT;
  ELSE 
    DBMS_OUTPUT.PUT_LINE('Arquivo: ' || vNomeArquivo || ' n�o existe!');
  END IF;
EXCEPTION
  WHEN others THEN
    DBMS_LOB.CLOSE(vArquivoOrigem);
    RAISE_APPLICATION_ERROR(-20001,'Erro Oracle ' || SQLCODE || SQLERRM);
END;

/*
    BFILE -> Um tipo de LOB
    Ponteiro que aponta para um arquivo ou diret�rio
    Forma de controlar um arquivo
    N�o interfere na transa��o do banco de dados
*/

DROP TABLE job_Profiles;
CREATE TABLE job_Profiles
(resume_id   NUMBER,
 first_name  VARCHAR2(200),
 last_name   VARCHAR2(200),
 profile_picture  BFILE);
 
 DESC job_profiles
 
-- Armazenando imagens em uma coluna BFILE

DECLARE
  vNomeArquivo   VARCHAR2(100) := '1583857436185192120.png';
  vDiretorio     VARCHAR2(100) := 'IMAGENS';
  vArquivoOrigem   BFILE;  
BEGIN

  vArquivoOrigem := BFILENAME(vDiretorio,vNomeArquivo);
  
  IF DBMS_LOB.FILEEXISTS(vArquivoOrigem) = 1 THEN
     INSERT INTO job_profiles
     VALUES (1, 'Oracle', 'Man', vArquivoOrigem);
     COMMIT;
  END IF;
   
EXCEPTION
  WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,'Erro Oracle ' || SQLCODE || SQLERRM);
END;

SELECT *
FROM job_Profiles;
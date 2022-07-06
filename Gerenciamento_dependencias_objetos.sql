 /*
    Sempre que um objeto no banco de dados for alterado
    Todos os objetos que referenciam o objeto modificado ficaram INVALID
    Quando o objeto � utilizado o Oracle tenta automaticamente recompilar o objeto
    N�o � uma boa pr�tica deixar o objeto INVALID
    
    Depend�ncia direta: h� uma refer�ncia direta do objeto
    Depend�ncia indireta: quando depende-se do objeto de forma indireta a partir 
    de refer�ncia de outra fun��o ou procedure
    Depend�ncia local: um objeto depende de outro objeto do mesmo banco de dados
    Depend�ncia remota: um objeto depende de outro objeto que est� em outro banco
    de dados, s�o referenciados atrav�s de um database link
    
    Consulta de depend�ncia
    USER_DEPENDENCIES
    ALL_DEPENDENCIES
    DBA_DEPENDENCIES
    
    -- EXECUTAR O COMANDO PARA CRIAR O DEPTREE
    E:\Oracle\OracleDataBase21XE\dbhomeXE\rdbms\admin\utldtree.sql
    
    DEPTREE
        
    IDEPTREE
    
 */
 
SELECT * FROM USER_DEPENDENCIES;
 
-- DEPENDENCIAS DIRETAS
SELECT * FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = 'EMPLOYEES' AND REFERENCED_TYPE = 'TABLE';

-- REFERENCIAS INDIRETAS
SELECT * FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = 'EMPLOYEES' AND REFERENCED_TYPE = 'TABLE'
CONNECT BY PRIOR -- SQL HIERARQUICO
NAME = REFERENCED_NAME AND
TYPE = REFERENCED_TYPE;

-- NO USU�RIO SYSTEM
DESC DBA_DEPENDENCIES;

SELECT      *
FROM        dba_dependencies
START WITH  referenced_owner = 'HR' AND
            referenced_name = 'EMPLOYEES' AND
            referenced_type = 'TABLE'
CONNECT BY PRIOR  owner = referenced_owner AND
                  name =  referenced_name   AND
                  type =  referenced_type;
                  
-- Consultando objetos Inv�lidos do schema do seu usu�rio 

DESC USER_OBJECTS

SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   user_objects
WHERE  status = 'INVALID';

-- utldtree
@E:\Oracle\OracleDataBase21XE\dbhomeXE\rdbms\admin\utldtree.sql

-- EXEC DEPTREE_FILL(Tipo_Objeto, Usuario_dono_objeto, objeto)
EXEC DEPTREE_FILL('TABLE', 'HR', 'EMPLOYEES')

-- Nivel 0 = objeto
-- Nivel 1 = deped�ncia direta com o objeto
SELECT * FROM DEPTREE ORDER BY SEQ#

-- Mostra as depend�ncia a partir da identa��o
SELECT * FROM IDEPTREE

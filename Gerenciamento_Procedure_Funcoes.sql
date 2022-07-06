/*
    Consultar objetos e fun��es do Oracle
    USER_OBJECTS -> Consulta os objetos do usu�rio logado
    ALL_OBJECTS -> Consulta os objetos do usu�rio logado e que ele tenha permiss�o
    DBA_OBJECTS -> Acesso a todos os objetos do banco de dados, mas apenas o DBA tem acesso
    
    Consultar o c�digo fonte dos objetos
    USER_SOURCE -> Consulta os objetos do usu�rio logado
    ALL_SOURCE -> Consulta os objetos do usu�rio logado e que ele tenha permiss�o
    DBA_SOURCE -> Acesso a todos os objetos do banco de dados, mas apenas o DBA tem acesso    
    
    DESC 
    
    SHOW ERROS PROCEDURES | FUNCTION | PACKAGE nome -> Mostrar os erros de compila��o;
    
    USER_ERRORS -> Erros do usu�rio logado
    ALL_ERRORS -> Erros do usu�rio logado e que ele tenha permiss�o
    DBA_ERRORS -> Todos os erros
*/
SELECT * FROM USER_OBJECTS; -- TIMESTAMP = DATA DA �LTIMA COMPILA��O - STATUS = VALID COMPILA��O OK - OBJECT_TYPE = TIPO DO OBJETO
SELECT * FROM ALL_OBJECTS;
SELECT * FROM DBA_OBJECTS;

SELECT * FROM USER_SOURCE;
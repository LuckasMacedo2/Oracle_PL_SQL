/*
    Consultar objetos e funções do Oracle
    USER_OBJECTS -> Consulta os objetos do usuário logado
    ALL_OBJECTS -> Consulta os objetos do usuário logado e que ele tenha permissão
    DBA_OBJECTS -> Acesso a todos os objetos do banco de dados, mas apenas o DBA tem acesso
    
    Consultar o código fonte dos objetos
    USER_SOURCE -> Consulta os objetos do usuário logado
    ALL_SOURCE -> Consulta os objetos do usuário logado e que ele tenha permissão
    DBA_SOURCE -> Acesso a todos os objetos do banco de dados, mas apenas o DBA tem acesso    
    
    DESC 
    
    SHOW ERROS PROCEDURES | FUNCTION | PACKAGE nome -> Mostrar os erros de compilação;
    
    USER_ERRORS -> Erros do usuário logado
    ALL_ERRORS -> Erros do usuário logado e que ele tenha permissão
    DBA_ERRORS -> Todos os erros
*/
SELECT * FROM USER_OBJECTS; -- TIMESTAMP = DATA DA ÚLTIMA COMPILAÇÃO - STATUS = VALID COMPILAÇÃO OK - OBJECT_TYPE = TIPO DO OBJETO
SELECT * FROM ALL_OBJECTS;
SELECT * FROM DBA_OBJECTS;

SELECT * FROM USER_SOURCE;
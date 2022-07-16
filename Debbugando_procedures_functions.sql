 /*
    Efetuar o grant dos privilégios de DEBUG, CONNECT SESSION e DEBUG ANY PROCEDURE
    para o usuário que irá debbugar a procedure ou function
    O usuário deve ser o owner ou possuir o privilégio de EXECUTE da procedure ou function a que deseja debugar
    A procedure ou function deve ser compilada para debug (Compiled for Debug)
    
    Passos:
    - Executar os passos com o usuário sys
    - Compilar para debbug;
    - Privilegios para debbug
        GRANT DEBUG CONNECT SESSION, DEBUG ANY PROCEDURE TO HR;
    - Habilita o JDWP para conectar a sessão do banco do cliente
      Executar o comando abaixo
        BEGIN
         DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE
         (
         host => '127.0.0.1',
         lower_port => null,
         upper_port => null,
         ace => xs$ace_type(privilege_list => xs$name_list('jdwp'),
         principal_name => 'hr',
         principal_type => xs_acl.ptype_db)
         );
        END;
 */
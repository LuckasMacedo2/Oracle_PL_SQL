/*
    Package para agendar tarefas, executar jobs
    Scheduler prov� funcionalidades de um agendador
    
    Componentes do scheduler
    Program: Cole��o de metadados que ser� executado o Scheduler.
    Um programa pode ser uma procedure, um programa externo como um exe, script etc
    Schedule: Agenda, quando deve ser executado
    Job: Job que ser� executado combina o programa ao schedule


    Criar um programa
    Cole��o de metadados que ser� executado no scheduler
    Para criar uma job � necess�rio ter o crit�rio CREATE JOB ou CREATE ANY JOB
    Um programa s� � executado quando est� com o status habilitado
    Sintaxe: 
    
    DBMS_SCHEDULER.CREATE_PROGRAM
    (PROGRAM_NAME IN VARCHAR2, -- Nome do programa
     PROGRAM_TYPE IN VARCHAR2, -- Tipo do programa
     PROGRAM_ACTION IN VARCHAR2, -- A��o do programa
     NUMBER_OF_ARGUMENTS IN PLS_INTEGER default 0, -- Quantidade de argumentos do programa
     ENABLE IN BOOLEAN, -- Se o programa estar� ou n�o habilitado
     COMMENTS IN VARCHAR2 DEFAULT NULL -- Coment�rios do programa       
    )
    Tipos de programa
        plsql_block - bloco anonimo, pouco usado
        stored_procedure - procedure
        executable - programa externo
        
    Criar a agenda
    DBMS_SCHEDULER.CREATE_SCHEDULE
    (SCHEDULE_NAME IN VARCHAR2, -- Nome da agenda
     START_DATE IN TIMESTAMP WITH TIMEZONE DEFAULT NULL, -- Data ao qual o schedule ser� iniciado. Quando o schedule para ficar ativo
     REPEAT_INTERVAL IN VARCHAR2, -- intervalo de repeti��o. Formado por tr�s partes: a cl�usla de frequ�ncia (Yearly, mounthly ...), o intervalo de repeti��o (0..99) e a outra cl�sula de frequ�ncia (BYMOUNTH)
     END_DATE IN TIMESTAMP WITH TIMEZONE DEFAULT NULL, -- Data ao qual o schedule ser� encerrado. Quando o schedule para ficar inativo
     COMMENTS IN VARCHAR2 DEFAULT NULL -- coment�rios da schedule         
    ); 
    
    Criar uma job
    Job = vincula��o do schedule e da agenda
    DBMS_SCHEDULER.CREATE_JOB
    (JOB_NAME IN VARCHAR2, -- Nome da job
     PROGRAM_NAME IN VARCHAR2, -- Nome do programa
     SCHEDULE_NAME IN VARCHAR2 -- Nome da agenda
    );
    Quando n�o possui nem o programa nem o schedule � poss�vel colocar tudo
    na cria��o da job
    Para o job
    DBMS_SCHEDULER.STOP_JOB
    (JOB_NAME IN VARCHAR2,
     FORCE IIN BOOLEAN 
    );
    
    Vis�es de Jobs
    Vis�o                           Descri��o
    USER_SCHEDULER_JOB_ARGS         Argumentos configurados para todos os jobs
    USER_SCHEDULER_JOB_LOG          Log de todos os jobs
    USER_SCHEDULER_JOB_RUN_DETAILS  Detalhes da execu��o de todas as jobs
    USER_SCHEDULER_JOBS             Lista das jobs agendadas
    USER_SCHEDULER_PROGRAM_ARGS     Argumentos de todos os programas agendados
    USER_SCHEDULER_PROGRAMS         Lista dos programas agendados
    USER_SCHEDULER_SCHEDULES        Agendamentos pertencentes ao usu�rio
*/

-- Privilegio de criar job, no usu�rio Sys
GRANT CREATE JOB TO HR;

DROP TABLE AGENDA;

CREATE TABLE AGENDA (AGENDA_ID NUMBER,
                     AGENDA_DATA DATE);

DROP SEQUENCE AGENDA_SEQ;

CREATE SEQUENCE AGENDA_SEQ  START WITH 1
INCREMENT BY 1
NOCACHE
NOMAXVALUE
NOCYCLE;


CREATE OR REPLACE PROCEDURE PRC_INSERE_DATA_AGENDA
IS
BEGIN
    INSERT INTO HR.AGENDA
    VALUES (AGENDA_SEQ.NEXTVAL, SYSDATE);
    COMMIT;
END;

BEGIN 
    DBMS_SCHEDULER.CREATE_PROGRAM(
        PROGRAM_NAME => 'HR.PRC_INSERE_AGENDA',
        PROGRAM_ACTION => 'HR.PRC_INSERE_DATA_AGENDA',
        PROGRAM_TYPE => 'STORED_PROCEDURE',
        NUMBER_OF_ARGUMENTS => 0,
        COMMENTS => 'Insere dados na agenda',
        ENABLED => TRUE
    );
    
    -- DBMS_SCHEDULER.ENABLE(NAME => 'HR.PRC_INSERE_AGENDA');
END;

BEGIN
    DBMS_SCHEDULER.CREATE_SCHEDULE
    (    SCHEDULE_NAME => 'SCH_A_CADA_10_SEGUNDOS', -- Nome da agenda
         START_DATE => SYSTIMESTAMP, -- Data ao qual o schedule ser� iniciado. Quando o schedule para ficar ativo
         REPEAT_INTERVAL => 'FREQ=SECONDLY;INTERVAL=10', -- intervalo de repeti��o. Formado por tr�s partes: a cl�usla de frequ�ncia (Yearly, mounthly ...), o intervalo de repeti��o (0..99) e a outra cl�sula de frequ�ncia (BYMOUNTH)
         END_DATE => TO_TIMESTAMP_TZ('2022-07-23 14:28:36 AMERICA/SAO_PAULO','YYYY-MM-DD HH24:MI:SS.FF TZR'), -- Data ao qual o schedule ser� encerrado. Quando o schedule para ficar inativo
         COMMENTS => 'A cada 10 segundos' -- coment�rios da schedule         
    );
END;

SELECT SYSTIMESTAMP FROM DUAL;

-- Criar job
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"HR"."JOB_INSERE_DATA_AGENDA"',
            program_name => '"HR"."PRC_INSERE_AGENDA"',
            schedule_name => '"HR"."SCH_A_CADA_10_SEGUNDOS"',
            enabled => TRUE,
            auto_drop => FALSE, -- Ao executar o job e der erro o job � removido
            comments => 'Job Insere Data na Agenda',             
            job_style => 'REGULAR');
/*
    DBMS_SCHEDULER.enable(
             name => '"HR"."JOB_INSERE_DATA_AGENDA"');
*/
END;

-- Consultando a tabela AGENDA

SELECT agenda_id, TO_CHAR(agenda_data,'dd/mm/yyyy hh24:mi:ss') AGENDA_DATA
FROM   agenda
ORDER BY agenda_id;

-- Conectar como SYS

-- Remover o job

BEGIN
	DBMS_SCHEDULER.DROP_JOB (
	     job_name => '"HR"."JOB_INSERE_DATA_AGENDA"',
	     force => TRUE);
END;




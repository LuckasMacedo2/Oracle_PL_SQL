/*
    Operadores l�gicos
    
    Operador            Resultado
    +                   Soma
    -                   Subtra��o
    *                   Multiplica��o
    /                   Divis�o
    **                  Exponencia��o
    NOT                 Nega��o l�gica
    =, <, >, <=, >=,    Compara��o
    IS NULL, LIKE, 
    BETWEEN, IN, !=, 
    <>, ^=, ~=
    AND                 Operador l�gico AND
    OR                  Operador l�gico OR
    
    Regra de preced�ncia: da esquerda para a direita
    Ordem               Operador
    1                   **
    2                   +, - (sinais)
    3                   *, /
    4                   +, -, ||
    5                   =, <, >, <=, >=, <>, !=, ~=, ^=, BETWEEN, IN, IS NULL, LIKE
    6                   AND
    7                   NOT
    8                   OR
    Parenteses quebra a precedencia
*/
SET SERVEROUTPUT ON
DECLARE
    VNOTA1 NUMBER(11,2) := 7.0;
    VNOTA2 NUMBER(11,2) := 6.0;
    VNOTA3 NUMBER(11,2) := 9.0;
    VNOTA4 NUMBER(11,2) := 6.0;
    VMEDIA NUMBER(11,2);
BEGIN
    VMEDIA := (VNOTA1 + VNOTA2 + VNOTA3 + VNOTA4)/ 4;
    DBMS_OUTPUT.put_line('M�DIA: ' || VMEDIA);
END;

/*
    Comandos IF
             ELSIF
             CASE - Usa a primeiram cl�usula verdadeira
    Qualquer compara��o com NULL retorna o pr�prio NULL que � false
    Usar IS NULL, ou NVL ou NVL2
    
            LOOP
                O comando EXIT encerra o LOOP e passa ele para o pr�ximo comando ap�s o LOOP
                O EXIT tem uma condi��o
            FOR LOOP
                O indice do loop � criado automaticamente
                Para usar o indice deve se utilizar o REVERSE
*/
SET SERVEROUTPUT ON
ACCEPT pdepartment_id PROMPT 'Digite o Id do departamento: ' -- Comando do SQLPLUS que permite inserir dados (cout)
-- pdepartment_id � uma variavel de substitui��o, para utiliz�-la usar o &
DECLARE
    VPERCENTUAL NUMBER(3);
    VDEPARTMENT_ID employees.employee_id%TYPE := &pdepartment_id;
BEGIN
    IF VDEPARTMENT_ID = 80
    THEN 
        VPERCENTUAL := 10; -- SALES
    ELSE
        IF VDEPARTMENT_ID = 20
        THEN 
            VPERCENTUAL := 15;
        ELSE
            IF VDEPARTMENT_ID = 60
            THEN 
                VPERCENTUAL := 20;
            ELSE
                VPERCENTUAL := 5;
            END IF;
        END IF;
    END IF;
    
    DBMS_OUTPUT.put_line('ID DO DEPARTAMENTO: ' || VDEPARTMENT_ID);
    DBMS_OUTPUT.put_line('PERCENTUAL: ' || VPERCENTUAL);
    
    UPDATE EMPLOYEES
    SET SALARY = SALARY * (1 + VPERCENTUAL / 100)
    WHERE VDEPARTMENT_ID = VDEPARTMENT_ID;
END;

-- ELSIF
SET SERVEROUTPUT ON
ACCEPT pdepartment_id PROMPT 'Digite o Id do departamento: ' -- Comando do SQLPLUS que permite inserir dados (cout)
-- pdepartment_id � uma variavel de substitui��o, para utiliz�-la usar o &
DECLARE
    VPERCENTUAL NUMBER(3);
    VDEPARTMENT_ID employees.employee_id%TYPE := &pdepartment_id;
BEGIN
    IF VDEPARTMENT_ID = 80
    THEN 
        VPERCENTUAL := 10; -- SALES
    ELSIF VDEPARTMENT_ID = 20
    THEN 
        VPERCENTUAL := 15;
    ELSIF VDEPARTMENT_ID = 60
    THEN 
        VPERCENTUAL := 20;
    ELSE
        VPERCENTUAL := 5;
    END IF;
    
    DBMS_OUTPUT.put_line('ID DO DEPARTAMENTO: ' || VDEPARTMENT_ID);
    DBMS_OUTPUT.put_line('PERCENTUAL: ' || VPERCENTUAL);
    
    UPDATE EMPLOYEES
    SET SALARY = SALARY * (1 + VPERCENTUAL / 100)
    WHERE VDEPARTMENT_ID = VDEPARTMENT_ID;
END;

-- CASE
SET SERVEROUTPUT ON
ACCEPT pdepartment_id PROMPT 'Digite o Id do departamento: ' -- Comando do SQLPLUS que permite inserir dados (cout)
-- pdepartment_id � uma variavel de substitui��o, para utiliz�-la usar o &
DECLARE
    VPERCENTUAL NUMBER(3);
    VDEPARTMENT_ID employees.employee_id%TYPE := &pdepartment_id;
BEGIN
    CASE VDEPARTMENT_ID
    WHEN 80
    THEN
         VPERCENTUAL := 10; -- SALES
    WHEN 20
    THEN 
         VPERCENTUAL := 15;
    WHEN 60
    THEN
         VPERCENTUAL := 20;
    ELSE
         VPERCENTUAL := 5;
    END CASE;
    
    DBMS_OUTPUT.put_line('ID DO DEPARTAMENTO: ' || VDEPARTMENT_ID);
    DBMS_OUTPUT.put_line('PERCENTUAL: ' || VPERCENTUAL);
    
    UPDATE EMPLOYEES
    SET SALARY = SALARY * (1 + VPERCENTUAL / 100)
    WHERE VDEPARTMENT_ID = VDEPARTMENT_ID;
END;

SET SERVEROUTPUT ON
ACCEPT pdepartment_id PROMPT 'Digite o Id do departamento: ' -- Comando do SQLPLUS que permite inserir dados (cout)
-- pdepartment_id � uma variavel de substitui��o, para utiliz�-la usar o &
DECLARE
    VPERCENTUAL NUMBER(3);
    VDEPARTMENT_ID employees.employee_id%TYPE := &pdepartment_id;
BEGIN
    CASE 
    WHEN VDEPARTMENT_ID = 80
    THEN
         VPERCENTUAL := 10; -- SALES
    WHEN VDEPARTMENT_ID = 20
    THEN 
         VPERCENTUAL := 15;
    WHEN VDEPARTMENT_ID = 60
    THEN
         VPERCENTUAL := 20;
    ELSE
         VPERCENTUAL := 5;
    END CASE;
    
    DBMS_OUTPUT.put_line('ID DO DEPARTAMENTO: ' || VDEPARTMENT_ID);
    DBMS_OUTPUT.put_line('PERCENTUAL: ' || VPERCENTUAL);
    
    UPDATE EMPLOYEES
    SET SALARY = SALARY * (1 + VPERCENTUAL / 100)
    WHERE VDEPARTMENT_ID = VDEPARTMENT_ID;
END;

-- LOOP b�sico
SET SERVEROUTPUT ON
ACCEPT plimite PROMPT 'Digite o valor do limite: ' -- Comando do SQLPLUS que permite inserir dados (cout)

DECLARE
    VNUMERO NUMBER(38) := 1;
    VLIMITE NUMBER(38) := &plimite;
BEGIN
    
    LOOP    
        DBMS_OUTPUT.put_line('N�MERO: ' || TO_CHAR(VNUMERO));
    EXIT WHEN VNUMERO = VLIMITE;
        VNUMERO  := VNUMERO + 1;
    END LOOP;
    
END;

-- FOR LOOP
SET SERVEROUTPUT ON
ACCEPT plimite PROMPT 'Digite o valor do limite: ' -- Comando do SQLPLUS que permite inserir dados (cout)

DECLARE
    VINICIO INTEGER(3) := 1;
    VFIM NUMBER(38) := &plimite;
BEGIN
    
    FOR I IN VINICIO..VFIM LOOP
        DBMS_OUTPUT.put_line('N�MERO: ' || TO_CHAR(I));
    END LOOP;
    
END;

-- WHILE
SET SERVEROUTPUT ON
ACCEPT plimite PROMPT 'Digite o valor do limite: ' -- Comando do SQLPLUS que permite inserir dados (cout)

DECLARE
    VNUMERO NUMBER(38) := 1;
    VLIMITE NUMBER(38) := &plimite;
BEGIN
    
    WHILE VNUMERO <= VLIMITE LOOP
        DBMS_OUTPUT.put_line('N�MERO: ' || TO_CHAR(VNUMERO));
        VNUMERO := VNUMERO + 1;
    END LOOP;
    
END;

-- CONTROLE DE LOOP ALINHADO
SET SERVEROUTPUT ON
DECLARE
    VTOTAL NUMBER(38) := 1;

BEGIN
    <<LOOP1>>
    FOR I IN 1..8 LOOP
        DBMS_OUTPUT.put_line('I: ' || TO_CHAR(I));
        <<LOOP2>>
        FOR J IN 1..8 LOOP
            DBMS_OUTPUT.put_line('J: ' || TO_CHAR(J));
            DBMS_OUTPUT.put_line('VTOTAL: ' || TO_CHAR(VTOTAL, '99G99G99G99G99G99G99G99G99G99D99'));
            VTOTAL := VTOTAL *2;
            EXIT LOOP1 WHEN VTOTAL > 1000000000; -- SAI DOS DOIS LOOPS
        END LOOP;
    END LOOP;
    
    DBMS_OUTPUT.put_line('VTOTAL FINAL: ' || TO_CHAR(VTOTAL, '99G99G99G99G99G99G99G99G99G99D99'));
    
END;





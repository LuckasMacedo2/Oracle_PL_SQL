grant execute on DBMS_FLASHBACK to hr;

-- Verificando o par�metro undo_retention que define o tempo de reten��o do undo
SELECT NAME, VALUE FROM V$PARAMETER -- Vis�o de performance din�mica v$Parameter
WHERE NAME LIKE '%undo%';
-- O que de fato define quanto tempo o undo ficar� armazenado � o tamanho da tablespace de undo
grant execute on DBMS_FLASHBACK to hr;

-- Verificando o parâmetro undo_retention que define o tempo de retenção do undo
SELECT NAME, VALUE FROM V$PARAMETER -- Visão de performance dinâmica v$Parameter
WHERE NAME LIKE '%undo%';
-- O que de fato define quanto tempo o undo ficará armazenado é o tamanho da tablespace de undo
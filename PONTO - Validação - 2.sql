-- VALIDAÇÃO 2
-- Busca as descrições repetidas na turma

select list(i_entidades) as entidades, 
       list(i_turmas) as turma, 
       descricao,
       count(descricao) as quantidade 
  from bethadba.turmas
 group by descricao 
having quantidade > 1;

-- CORREÇÃO
update bethadba.turmas t
   set descricao = t.i_turmas || '-' || t.descricao
 where exists (
   select 1
     from bethadba.turmas t2
    where trim(t2.descricao) = trim(t.descricao)
    group by trim(t2.descricao)
    having count(*) > 1
 );
--
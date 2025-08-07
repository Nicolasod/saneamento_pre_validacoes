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
-- Atualiza as descrições repetidas para que sejam únicas

update bethadba.turmas
   set descricao = i_turmas || ' - ' || descricao
 where exists (select 1 
                 from bethadba.turmas t2
                where t1.descricao = t2.descricao
                  and t1.i_turmas <> t2.i_turmas);
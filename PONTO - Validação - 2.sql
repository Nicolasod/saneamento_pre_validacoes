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
   set descricao = concat(i_turmas, ' - ', descricao)
 where i_turmas in (select i_turmas
                      from bethadba.turmas
                     group by descricao, i_turmas
                    having count(descricao) > 1);
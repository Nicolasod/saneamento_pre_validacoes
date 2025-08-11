-- VALIDAÇÃO 17
-- Verifica os atos repetidos

select list(i_atos) as idatos,
       num_ato,
       i_tipos_atos,
       count(num_ato) as quantidade
from bethadba.atos 
group by num_ato, i_tipos_atos 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os atos repetidos para evitar duplicidade, adicionando o i_atos ao nome do ato

update bethadba.atos
   set num_ato = i_atos || ' - ' || num_ato
 where i_atos in (select i_atos
                    from bethadba.atos
                   where atos.i_atos in (select i_atos
                                          from bethadba.atos
                                         where (select count(i_atos)
                                                  from bethadba.atos b
                                                 where trim(b.num_ato) = trim(atos.num_ato)
                                                   and atos.i_tipos_atos = b.i_tipos_atos) > 1));

-- Substituir o update atual pela procedure procedure_unificacao_atos.sql
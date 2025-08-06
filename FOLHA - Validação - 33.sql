-- VALIDAÇÃO 33
-- Busca os tipos de atos repetidos

select list(i_tipos_atos) as ttt, 
       nome,
       count(nome) as quantidade 
  from bethadba.tipos_atos 
 group by nome 
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os tipos de atos repetidos para evitar duplicidade, adicionando o i_tipos_atos ao nome do tipo de atos

update bethadba.tipos_atos
   set tipos_atos.nome = tipos_atos.i_tipos_atos || '-' || tipos_atos.nome
 where tipos_atos.i_tipos_atos in(select i_tipos_atos
                                    from bethadba.tipos_atos
                                   where (select count(i_tipos_atos)
                                            from bethadba.tipos_atos t
                                           where trim(t.nome) = trim(tipos_atos.nome)) > 1);
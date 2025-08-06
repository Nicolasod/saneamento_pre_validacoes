-- VALIDAÇÃO 01
-- Descricao de Logradouros Duplicadas

select list(i_ruas) as ruas, 
       trim(nome) as nome,
       i_cidades, 
       count(nome) as quantidade
  from bethadba.ruas 
 group by nome, i_cidades
having quantidade > 1;


-- CORREÇÃO
-- Atualiza os nomes dos logradouros duplicados para evitar duplicidade

update bethadba.ruas
   set nome = i_ruas || '-' || nome
 where i_ruas in (select i_ruas
                    from bethadba.ruas
                   where (select count(1)
                            from bethadba.ruas r
                           where (r.i_cidades = ruas.i_cidades or r.i_cidades is null)
                             and trim(r.nome) = trim(ruas.nome)) > 1);
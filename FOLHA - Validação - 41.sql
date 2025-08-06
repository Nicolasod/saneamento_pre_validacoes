-- VALIDAÇÃO 41
-- Verifica os cargos com descrição repetidos

select cargos.i_entidades as identidade,
       cargos.nome as nome,
       count(cargos.nome) as quantidade,
       list(cargos.i_cargos) as codigos
  from bethadba.cargos
 group by cargos.i_entidades, cargos.nome
having count(cargos.nome) > 1;


-- CORREÇÃO
-- Atualiza os nomes dos cargos repetidos para evitar duplicidade, adicionando o i_cargos ao nome do cargo
   
update bethadba.cargos
   set cargos.nome = trim(cargos.i_cargos) || '-' || trim(cargos.nome)
 where cargos.i_cargos in(select i_cargos
                            from bethadba.cargos
                           where (select count(i_cargos)
                                    from bethadba.cargos c
                                   where trim(c.nome) = trim(cargos.nome)) > 1);
-- VALIDAÇÃO 194
-- Configuração sem responsável

select pr.i_entidades,
       pr.i_parametros_rel,
       tipoInscricao = tipo_insc,
       nome = isnull(nome_resp,''),
       pessoaJuridicaAx = isnull((select first i_pessoas
                                    from bethadba.pessoas
                                   where SIMILAR(nome,nome_resp) >= 80),0),
       pessoaFisicaAx = isnull((select first i_pessoas
                                  from bethadba.pessoas
                                 where SIMILAR(nome,nome_resp) >= 80),0)
  from bethadba.parametros_rel as pr
 where pr.i_parametros_rel = 2        
   and ((tipoInscricao = 'J' and pessoaJuridicaAx = 0)
    or (tipoInscricao = 'F' and pessoaFisicaAx = 0));


-- CORREÇÃO
-- Exclui os registros de parâmetros de relatório que estejam com tipo de inscrição
-- 'J' e sem pessoa jurídica associada ou com tipo de inscrição 'F' e sem pessoa física associada

update bethadba.parametros_rel pr
   set pr.nome_resp = (select nome
   						           from bethadba.pessoas_nomes
   						          where i_pessoas = (select top 1 e.i_pessoas
                                   					 from bethadba.hist_entidades_compl e
					                                  where e.i_entidades = pr.i_entidades
                                              and i_pessoas is not null
                    					              order by i_competencias desc))
 where pr.i_parametros_rel = 2
   and ((pr.tipo_insc = 'J'
   and isnull((select first i_pessoas
                 from bethadba.pessoas
                where SIMILAR(nome, pr.nome_resp) >= 80),0) = 0)
    or (pr.tipo_insc = 'F'
   and isnull((select first i_pessoas
                 from bethadba.pessoas
                where SIMILAR(nome, pr.nome_resp) >= 80),0) = 0));
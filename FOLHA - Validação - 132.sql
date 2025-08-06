-- VALIDAÇÃO 132
-- Obrigatório informar a entidade educacional (S/N)

select i_entidades,
	     indicativo_entidade_educativa
  from bethadba.hist_entidades_compl as hec
 where indicativo_entidade_educativa is null;


-- CORREÇÃO
-- Atualiza o campo indicativo_entidade_educativa para 'N' onde está nulo (considerando que a entidade educacional não é obrigatória)

update bethadba.hist_entidades_compl
   set indicativo_entidade_educativa = 'N'
 where indicativo_entidade_educativa is null;
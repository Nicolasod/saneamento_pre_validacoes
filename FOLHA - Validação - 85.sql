-- VALIDAÇÃO 85
-- Pessoas fisicas com nome da afiliação repetidos

select i_pessoas as pessoa,
       nome_pai as nm_pai,
       nome_mae as nm_mae
  from bethadba.pessoas_fis_compl 
 where nome_pai = nome_mae 
   and nome_pai is not null 
   and nome_pai <> '';


-- CORREÇÃO
-- Atualiza o nome do pai para um valor fictício quando o nome do pai é igual ao nome da mãe e o nome do pai não é nulo ou vazio.

update bethadba.pessoas_fis_compl
   set nome_pai = 'PAI_FICTICIO_' || cast(i_pessoas as varchar)
 where nome_pai = nome_mae
   and nome_pai is not null
   and nome_pai <> '';
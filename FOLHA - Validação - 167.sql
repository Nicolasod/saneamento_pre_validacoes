-- VALIDAÇÃO 167
-- Ceritidão de obito nulas

select i_pessoas,
       dt_obito,
       ehfalecido 
  from bethadba.pessoas_fis_obito as pfo
 where ehfalecido = 'S'
   and certidao is null;

-- CORREÇÃO
-- Atualizar a certidão de óbito para 'N' onde ehfalecido é 'S' e certidão é nula

update bethadba.pessoas_fis_obito
   set ehfalecido = 'N'
 where ehfalecido = 'S'
   and certidao is null;
-- VALIDAÇÃO 118
-- Verifica quantidade de licenças prêmios

select i_licpremio_config,
       i_faixas
  from bethadba.licpremio_faixas
 where i_faixas > 99;


-- CORREÇÃO
-- Atualiza as faixas de licenças prêmios para o valor 99, que é o valor máximo permitido

update bethadba.licpremio_faixas
   set i_faixas = 99
 where i_faixas = 999;
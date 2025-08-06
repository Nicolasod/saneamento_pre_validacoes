-- VALIDAÇÃO 75
-- Verifica Estagiário(s) sem número da apólice de seguro informado

select estagios.i_funcionarios
  from bethadba.estagios
 where num_apolice is null;


-- CORREÇÃO
-- Atualiza o número da apólice de seguro dos estagiários que não possuem número da apólice informado para 0

update bethadba.hist_funcionarios
   set num_apolice_estagio = 0
 where num_apolice_estagio is null 
   and i_funcionarios in (select estagios.i_funcionarios
   					                from bethadba.estagios
          				         where num_apolice is null);

update bethadba.estagios
   set num_apolice = 0
 where num_apolice is null;
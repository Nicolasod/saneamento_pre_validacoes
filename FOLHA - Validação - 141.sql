-- VALIDAÇÃO 141
-- Data do processo de homologação maior que a data atual do sistema

select pj.i_entidades,
       pj.i_pessoas,
       pj.i_funcionarios,
       pj.dt_homologacao,
       pj.dt_final,
       dataAtual = getDate()
  from bethadba.processos_judiciais pj 
 where pj.dt_homologacao > dataAtual 
    or pj.dt_homologacao > pj.dt_final;


-- CORREÇÃO
-- Atualiza a data de homologação para a data atual se for maior que a data final

update bethadba.processos_judiciais
   set dt_homologacao = getDate()
 where pj.dt_homologacao > getDate() 
    or pj.dt_homologacao > pj.dt_final;
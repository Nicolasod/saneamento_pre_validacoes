-- VALIDAÇÃO 188
-- Data do historico do cadastro anterior a data de nascimento atual

select pf.i_pessoas,
       pf.dt_nascimento,
       hpf.dt_alteracoes
  from bethadba.hist_pessoas_fis as hpf 
  join bethadba.pessoas_fisicas as pf 
 where hpf.dt_alteracoes < pf.dt_nascimento;


-- CORREÇÃO
-- Atualiza a data de alteração do histórico para a data de nascimento atual para os registros onde a data de alteração é anterior à data de nascimento

update hist_pessoas_fis as hpf
   set hpf.dt_alteracoes = case when exists (select 1
                                               from hist_pessoas_fis hpf2
                                              where hpf2.i_pessoas = hpf.i_pessoas
                                                and hpf2.dt_alteracoes = pf.dt_nascimento)
                                then
                                  dateadd(day, 1, pf.dt_nascimento)
                                else
                                  pf.dt_nascimento
                                 end
  from pessoas_fisicas as pf
 where hpf.i_pessoas = pf.i_pessoas
   and hpf.dt_alteracoes < pf.dt_nascimento;
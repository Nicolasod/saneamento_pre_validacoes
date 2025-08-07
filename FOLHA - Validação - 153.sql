-- VALIDAÇÃO 153
-- Lotação fisica principal

select i_entidades,
       i_funcionarios,
       count(*) as total 
  from bethadba.locais_mov lm 
 where principal = 'S'
 group by i_entidades, i_funcionarios  
having total > 1
 order by 1,2 asc;


-- CORREÇÃO
-- Atualizar a lotação fisica principal 'S' para apenas uma por funcionário, setando as demais para 'N' considerando como principal a lotação física com data inicial menor e sem data final
-- ou com data final maior que as demais.

update bethadba.locais_mov lm1
   set principal = 'S'
 where principal = 'N'
   and not exists (select 1
                     from bethadba.locais_mov lm2 
                    where lm2.i_entidades = lm1.i_entidades
                      and lm2.i_funcionarios = lm1.i_funcionarios
                      and lm2.principal = 'S'
                      and (lm2.data_inicial < lm1.data_inicial 
                       or (lm2.data_inicial = lm1.data_inicial 
                      and (lm2.data_final is null
                       or lm2.data_final > lm1.data_final))));

update bethadba.locais_mov lm
   set principal = 'N'
 where principal = 'S'
   and exists (select 1
                 from bethadba.locais_mov lm2 
                where lm2.i_entidades = lm.i_entidades
                  and lm2.i_funcionarios = lm.i_funcionarios
                  and lm2.principal = 'S'
                  and (lm2.data_inicial < lm.data_inicial 
                   or (lm2.data_inicial = lm.data_inicial 
                  and (lm2.data_final is null
                   or lm2.data_final > lm.data_final))));
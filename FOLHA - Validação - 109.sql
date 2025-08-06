-- VALIDAÇÃO 109
-- Busca as pessoas estrangeiras com data de nascimento maior que data de chegada

select pf.i_pessoas,
       pf.dt_nascimento,
       pe.data_chegada  
  from bethadba.pessoas_fisicas pf 
  join bethadba.pessoas_estrangeiras pe
    on pf.i_pessoas = pe.i_pessoas 
 where pf.dt_nascimento > pe.data_chegada;


-- CORREÇÃO
-- Atualiza a data de chegada para ser igual à data de nascimento + 1 dia se a data de nascimento for maior que a data de chegada

update bethadba.pessoas_fisicas a
  join bethadba.pessoas_estrangeiras b
    on (a.i_pessoas = b.i_pessoas)
   set data_chegada = dateadd(dd,1,dt_nascimento)
 where a.dt_nascimento > b.data_chegada;
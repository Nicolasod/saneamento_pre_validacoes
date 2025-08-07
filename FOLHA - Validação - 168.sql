-- VALIDAÇÃO 168
-- Data de CNH menor que a data de nascimento

select pf.i_pessoas,
       pf.dt_nascimento,
       pfc.dt_primeira_cnh 
  from bethadba.pessoas_fis_compl pfc 
  join bethadba.pessoas_fisicas pf
    on pfc.i_pessoas = pf.i_pessoas 
 where dt_primeira_cnh < pf.dt_nascimento
   and dt_primeira_cnh is not null;


-- CORREÇÃO
-- Atualiza a data de primeira CNH para 18 anos após a data de nascimento para os registros onde a data de CNH é anterior à data de nascimento

update bethadba.pessoas_fis_compl pfc
  join bethadba.pessoas_fisicas pf
    on pfc.i_pessoas = pf.i_pessoas
   set pfc.dt_primeira_cnh = DATEADD(year, 18, pf.dt_nascimento)
 where pfc.dt_primeira_cnh < pf.dt_nascimento
   and pfc.dt_primeira_cnh is not null;
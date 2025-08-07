-- VALIDAÇÃO 170
-- Data de vencimento da CNH menor que a da emissão da CNH

select pfc.i_pessoas,
       pfc.dt_vencto_cnh,
       pfc.dt_emissao_cnh
  from bethadba.pessoas_fis_compl pfc
 where pfc.dt_vencto_cnh < pfc.dt_emissao_cnh
   and pfc.dt_vencto_cnh is not null
   and pfc.dt_emissao_cnh is not null;


-- CORREÇÃO
-- Atualiza a data de vencimento da CNH para um dia após a data de emissão da CNH

update bethadba.pessoas_fis_compl pfc 
   set dt_vencto_cnh = DATEADD(DAY, 1, dt_emissao_cnh)
 where pfc.dt_vencto_cnh < pfc.dt_emissao_cnh 
   and pfc.dt_vencto_cnh is not null
   and pfc.dt_emissao_cnh is not null;
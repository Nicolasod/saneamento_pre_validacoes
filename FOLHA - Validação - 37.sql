-- VALIDAÇÃO 37
-- Ter ao menos um tipo de afastamento na configuração do cancelamento de férias

select i_canc_ferias,descricao
  from bethadba.canc_ferias as cf
 where not exists (select i_tipos_afast
                     from bethadba.canc_ferias_afast as cfa
                    where cfa.i_canc_ferias = cf.i_canc_ferias);


-- CORREÇÃO

insert into bethadba.canc_ferias_afast (i_canc_ferias, i_tipos_afast)
values (2, 1);
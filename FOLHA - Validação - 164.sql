-- VALIDAÇÃO 164
-- Autônomos com categorias diferentes de contribuinte individual

select f.i_entidades,
       f.i_funcionarios,
       f.tipo_func, 
       hf.i_vinculos, 
       v.categoria_esocial  
  from bethadba.funcionarios f 
  join bethadba.hist_funcionarios hf
    on f.i_entidades = hf.i_entidades
   and f.i_funcionarios = hf.i_funcionarios
  join bethadba.vinculos v
    on hf.i_vinculos = v.i_vinculos 
 where f.tipo_func = 'A'
   and v.categoria_esocial not in ('701')
   and f.conselheiro_tutelar = 'N';

-- CORREÇÃO
-- Atualizar categoria do eSocial para 701 (Contribuinte Individual) para autônomos

update bethadba.vinculos v
   set v.categoria_esocial = '701'
 where v.i_vinculos in (select hf.i_vinculos
                          from bethadba.funcionarios f 
                          join bethadba.hist_funcionarios hf
                            on f.i_entidades = hf.i_entidades
                           and f.i_funcionarios = hf.i_funcionarios
                         where f.tipo_func = 'A'
                           and f.conselheiro_tutelar = 'N'
                           and v.categoria_esocial not in ('701'));
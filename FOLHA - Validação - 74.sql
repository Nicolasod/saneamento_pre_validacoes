-- VALIDAÇÃO 74
-- Verifica vinculo com tipo diferente de outros do conselheiro tutelar

select funcionarios.i_entidades entidade,
       funcionarios.i_funcionarios func,
       vinculos.i_vinculos vinc
  from bethadba.funcionarios 
  join bethadba.hist_funcionarios
    on (funcionarios.i_entidades = hist_funcionarios.i_entidades
   and funcionarios.i_funcionarios = hist_funcionarios.i_funcionarios)
  join bethadba.vinculos
    on (hist_funcionarios.i_vinculos = vinculos.i_vinculos)
 where funcionarios.tipo_func = 'A'
   and funcionarios.conselheiro_tutelar = 'S'
   and vinculos.tipo_vinculo <> 3
   and hist_funcionarios.dt_alteracoes = (select max(dt_alteracoes)
                                            from bethadba.hist_funcionarios hf
                                           where hf.i_entidades = funcionarios.i_entidades
                                             and hf.i_funcionarios = funcionarios.i_funcionarios);


-- CORREÇÃO
-- Atualiza o tipo de vínculo para 3 (Conselheiro Tutelar) onde o funcionário é conselheiro tutelar e o tipo de vínculo é diferente de 3

update bethadba.vinculos
   set tipo_vinculo = 3
 where i_vinculos in (select vinculos.i_vinculos
                        from bethadba.funcionarios
                        join bethadba.hist_funcionarios
                          on (funcionarios.i_entidades = hist_funcionarios.i_entidades
                         and funcionarios.i_funcionarios = hist_funcionarios.i_funcionarios)
                        join bethadba.vinculos
                          on (hist_funcionarios.i_vinculos = vinculos.i_vinculos)
                       where funcionarios.tipo_func = 'A'
                         and funcionarios.conselheiro_tutelar = 'S'
                         and vinculos.tipo_vinculo <> 3
                         and hist_funcionarios.dt_alteracoes = (select max(dt_alteracoes)
                                                                  from bethadba.hist_funcionarios hf
                                                                 where hf.i_entidades = funcionarios.i_entidades
                                                                   and hf.i_funcionarios = funcionarios.i_funcionarios));
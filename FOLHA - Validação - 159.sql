-- VALIDAÇÃO 159
-- Averbação sem tipo de conta

select distinct hf.i_entidades,
       hf.i_funcionarios 
  from bethadba.hist_funcionarios hf 
  join bethadba.vinculos v
    on hf.i_vinculos = v.i_vinculos
 where v.i_adicionais is not null
   and exists (select 1
                 from bethadba.funcionarios f
                where f.i_entidades = hf.i_entidades
                  and f.i_funcionarios = hf.i_funcionarios
                  and f.tipo_func  = 'F'
                  and f.conta_adicional = 'N');


-- CORREÇÃO
-- Atualiza conta_adicional para 'S' para funcionários com tipo_func = 'F' e conta_adicional = 'N' e possui vinculo com adicionais

update bethadba.funcionarios
   set conta_adicional = 'S'
 where i_entidades in (select distinct hf.i_entidades
                         from bethadba.hist_funcionarios hf
                         join bethadba.vinculos v
                           on hf.i_vinculos = v.i_vinculos
                        where v.i_adicionais is not null
                          and exists (select 1
                                        from bethadba.funcionarios f
                                       where f.i_entidades = hf.i_entidades
                                         and f.i_funcionarios = hf.i_funcionarios
                                         and f.tipo_func = 'F'
                                         and f.conta_adicional = 'N'))
   and i_funcionarios in (select distinct hf.i_funcionarios
                            from bethadba.hist_funcionarios hf
                            join bethadba.vinculos v
                              on hf.i_vinculos = v.i_vinculos
                           where v.i_adicionais is not null
                             and exists (select 1
                                           from bethadba.funcionarios f
                                          where f.i_entidades = hf.i_entidades
                                            and f.i_funcionarios = hf.i_funcionarios
                                            and f.tipo_func = 'F'
                                            and f.conta_adicional = 'N'));
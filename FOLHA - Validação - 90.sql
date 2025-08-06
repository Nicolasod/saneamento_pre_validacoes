-- VALIDAÇÃO 90
-- O campo do codigoesocial esta duplicado

select a.i_entidades as entidades,
       a.codigo_esocial as codigo_esocial,
       count(codigo_esocial) as total
  from bethadba.funcionarios as a
 group by entidades, codigo_esocial
having total > 1;


-- CORREÇÃO
-- Atualiza o campo codigo_esocial para remover o último digito e adicionar o correto se o último digito for 2, adiciona 3, se for 1, adiciona 2
-- A atualização é feita apenas para os funcionarios que possuem o codigo_esocial duplicado

update bethadba.funcionarios 
   set codigo_esocial = (substring(codigo_esocial,0, length(codigo_esocial) -1) || case when substring(codigo_esocial,length(codigo_esocial)) = 2 then 3 when substring(codigo_esocial,length(codigo_esocial)) = 1 then 2 end)
 where i_funcionarios in (select funcionarios
                            from (select max(f.i_funcionarios) as funcionarios,
                                         teste.codigo_esocial
                                    from (select a.i_entidades as entidades,
                                                 a.codigo_esocial as codigo_esocial,
                                                 count(codigo_esocial) as total
                                            from bethadba.funcionarios as a
                                           group by entidades, codigo_esocial
                                          having total > 1) as teste
                                    join bethadba.funcionarios f
                                      on (f.codigo_esocial = teste.codigo_esocial)
                                   group by teste.codigo_esocial) as correto);
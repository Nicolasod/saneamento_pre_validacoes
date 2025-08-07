-- VALIDAÇÃO 174
-- Quantidades de digitos menores a configuração

select o.i_config_organ,
       o.i_organogramas,
       o.descricao,
       nivel_maximo = (select max(no2.i_niveis_organ)
                         from bethadba.niveis_organ as no2
                        where no2.i_config_organ = o.i_config_organ), 
       total_digitos = (select no2.tot_digitos
                          from bethadba.niveis_organ as no2
                         where no2.i_config_organ = o.i_config_organ
                           and no2.i_niveis_organ = nivel_maximo),
       total_digito_org = length(o.i_organogramas)                        
  from bethadba.organogramas as o
 where total_digito_org < total_digitos
    or total_digito_org > total_digitos;


-- CORREÇÃO
-- Atualizar o campo i_organogramas com a quantidade correta de digitos conforme configuração
-- Exemplo: Configuração com 3 niveis e 2 digitos cada nivel = 6 digitos

Update bethadba.organogramas
   set i_organogramas = right(i_organogramas + replicate('0', (select max(no2.tot_digitos)
                                                                 from bethadba.niveis_organ as no2
                                                                where no2.i_config_organ = o.i_config_organ)),
                                                              (select max(no2.tot_digitos)
                                                                 from bethadba.niveis_organ as no2
                                                                where no2.i_config_organ = o.i_config_organ))
  from bethadba.organogramas as o
 where length(o.i_organogramas) < (select max(no2.tot_digitos)
                                     from bethadba.niveis_organ as no2
                                    where no2.i_config_organ = o.i_config_organ)
    or length(o.i_organogramas) > (select max(no2.tot_digitos)
                                     from bethadba.niveis_organ as no2
                                    where no2.i_config_organ = o.i_config_organ);
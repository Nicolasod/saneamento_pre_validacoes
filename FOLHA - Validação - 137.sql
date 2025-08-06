-- VALIDAÇÃO 137
-- Verifica os funcionarios que não contém rescisão

select fpa.i_entidades,
       fpa.i_funcionarios
  from bethadba.funcionarios_prop_adic fpa
 where fpa.i_caracteristicas = 20369
   and fpa.valor_caracter = '2'
   and fpa.i_funcionarios not in (select i_funcionarios
                                    from bethadba.beneficiarios)
 order by fpa.i_funcionarios;


-- CORREÇÃO

-- Altera o tipo para 'B'
update bethadba.funcionarios
   set tipo_func = 'B'
 where i_entidades = 2
   and i_funcionarios = 938;

-- Insere um registro na tabela de beneficiários
insert into bethadba.beneficiarios (i_entidades, i_funcionarios, i_entidades_inst, i_instituidor, duracao_ben, perc_recebto)
values (2,938,2,938,'V',0);
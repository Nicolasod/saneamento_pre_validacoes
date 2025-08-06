-- VALIDAÇÃO 10
-- Tipo de diaria sem valor - É obrigatorio o valor para um tipo de diaria

select i_tipos_diarias,
       descricao
  from bethadba.tipos_diarias as td
 where vlr_diaria is null;


-- CORREÇÃO
-- Atualiza o valor nulo para 0 (zero)

update bethadba.tipos_diarias
   set vlr_diaria = 0
 where vlr_diaria is null;
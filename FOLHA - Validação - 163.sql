-- VALIDAÇÃO 163
-- Processo trabalhista não contém pagamento de encargo

select pj.i_entidades,
       pj.i_funcionarios,
       pj.i_processos_judiciais
  from bethadba.processos_judiciais pj
 where pj.i_funcionarios not in (select i_funcionarios
                                   from bethadba.processos_judic_pagamentos_encargos);


-- CORREÇÃO
-- 1. Realizar update para inserir um valor no campo vlr_prev_oficial
-- 2. Inserir na tabela processos_judic_pagamentos_det o relacionamento com os processos judiciais
-- 3. Inserir na tabela processos_judic_pagamentos_encargos o relacionamento com os processos judiciais

-- Update para o campo vlr_prev_oficial
update bethadba.processos_judic_compet
   set vlr_prev_oficial = 1;

-- Insert para o relacionamento com a tabela processos_judic_pagamentos_det
insert into bethadba.processos_judic_pagamentos_det
      (i_entidades, i_funcionarios, i_processos_judiciais, i_competencias, i_tipos_proc, data_referencia)
select pj.i_entidades,
       pj.i_funcionarios,
       pj.i_processos_judiciais,
       pj.dt_final,
       11,
       pj.dt_final
  from bethadba.processos_judiciais pj
 where pj.i_funcionarios not in (select i_funcionarios
                                   from bethadba.processos_judic_pagamentos_encargos);
                  
-- Insert para o relacionamento com a tabela processos_judic_pagamentos_encargos
insert into bethadba.processos_judic_pagamentos_encargos
      (i_entidades, i_funcionarios, i_processos_judiciais, i_competencias, i_tipos_proc, data_referencia, i_receitas, aliquota, valor_inss)
select 1,
       pj.i_funcionarios,
       pj.i_processos_judiciais,
       pj.dt_final,
       11,
       pj.dt_final,
       113851,
       null,
       null
  from bethadba.processos_judiciais pj
 where pj.i_funcionarios not in (select i_funcionarios
                                   from bethadba.processos_judic_pagamentos_encargos)
   and pj.i_processos_judiciais not in (select i_processos_judiciais
                                          from bethadba.processos_judic_pagamentos_encargos);
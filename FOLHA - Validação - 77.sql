-- VALIDAÇÃO 77
-- Verifica Estagiário(s) sem responsável informado
                  
select estagios.i_entidades entidade, 
       estagios.i_funcionarios func
  from bethadba.estagios,
       bethadba.hist_funcionarios
 where hist_funcionarios.i_entidades = estagios.i_entidades
   and hist_funcionarios.i_funcionarios = estagios.i_funcionarios
   and hist_funcionarios.i_supervisor_estagio is null
   and hist_funcionarios.dt_alteracoes = (select max(dt_alteracoes)
   											from bethadba.hist_funcionarios hf
                                           where hf.i_entidades = estagios.i_entidades
                                             and hf.i_funcionarios = estagios.i_funcionarios)
 order by estagios.i_entidades,
          estagios.i_funcionarios;


-- CORREÇÃO
-- Atualiza o supervisor de estágio para o funcionário correspondente, onde o supervisor de estágio é nulo
 
update bethadba.hist_funcionarios 
   set hist_funcionarios.i_supervisor_estagio = (select i_pessoas
                                                   from bethadba.funcionarios
                                                  where hist_funcionarios.i_entidades = funcionarios.i_entidades
                                                    and hist_funcionarios.i_funcionarios = funcionarios.i_funcionarios)
 where bethadba.hist_funcionarios.i_funcionarios in(select hist_funcionarios.i_funcionarios
													  from bethadba.estagios, bethadba.hist_funcionarios
													 where hist_funcionarios.i_entidades = estagios.i_entidades
													   and hist_funcionarios.i_funcionarios = estagios.i_funcionarios
													   and hist_funcionarios.i_supervisor_estagio is null
													   and hist_funcionarios.dt_alteracoes = (select max(dt_alteracoes)
													   											from bethadba.hist_funcionarios hf
												                                               where hf.i_entidades = estagios.i_entidades
                                                												 and hf.i_funcionarios = estagios.i_funcionarios)
													 order by estagios.i_entidades,
															  estagios.i_funcionarios);
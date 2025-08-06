-- VALIDAÇÃO 100
-- Estagiários sem informação na tabela estagios

select i_funcionarios
  from bethadba.hist_funcionarios as hf,
       bethadba.vinculos as v
 where v.i_vinculos = hf.i_vinculos
   and v.categoria_esocial = 901
   and hf.i_funcionarios not in (select e.i_funcionarios
   								   from bethadba.estagios as e
   							      where e.i_entidades = hf.i_entidades
									and e.i_funcionarios = hf.i_funcionarios);


-- CORREÇÃO
-- Insere os estagiários na tabela estagios com informações padrão

insert into bethadba.estagios (i_entidades, i_funcionarios, i_formacoes, i_atos, i_pessoas, dt_inicial, dt_final, nivel_curso, periodo, fase, num_contrato, dt_prorrog, objetivo, seguro_vida, num_apolice, estagio_obrigatorio)
  with FirstRight as (select *,
	         				 row_number() over (partition by i_funcionarios order by i_funcionarios) as rn
					    from bethadba.hist_funcionarios)
select fu.i_entidades, fu.i_funcionarios, ISNULL(fu.i_formacoes_estagio, '1') as i_formacoes, null as i_atos, 513, fu.dt_admissao as dt_inicial, '2999-12-31' as dt_final, '2' as nivel_curso, '1' as periodo, 'NI' as fase, fu.i_funcionarios as num_contrato, null as dt_prorrog, 'COMPLEMENTACAO ENSINO' as objetivo, 'N' as seguro_vida, null as num_apolice, 'N' as estagio_obrigatorio
  from bethadba.funcionarios as fu
  left join FirstRight as f
    on (f.i_entidades = fu.i_entidades
   and f.i_funcionarios = fu.i_funcionarios and f.rn = 1)
  join bethadba.vinculos as v
    on v.i_vinculos = f.i_vinculos
 where v.categoria_esocial = 901
   and fu.i_funcionarios not in (select e.i_funcionarios
				        		   from bethadba.estagios as e
						          where e.i_entidades = fu.i_entidades
						            and e.i_funcionarios = fu.i_funcionarios);
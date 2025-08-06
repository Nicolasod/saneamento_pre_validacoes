-- VALIDAÇÃO 23
-- Verifica as folhas de ferias sem data de pagamento

select bethadba.dbf_getdatapagamentoferias(ferias.i_entidades,ferias.i_funcionarios,ferias.i_periodos,ferias.i_ferias) as dataPagamento,
       i_entidades,
       i_ferias,
       i_funcionarios,
       i_periodos
  from bethadba.ferias
 where dataPagamento is null;


-- CORREÇÃO 1
-- Atualiza as folhas de férias sem data de pagamento, definindo a data de pagamento como o último dia do mês da competência

insert into bethadba.ferias_proc
select i_entidades,
  	   i_funcionarios,
 	   i_ferias,
  	   80,
       date(year(dt_gozo_ini) || '-' || month(dt_gozo_ini) || '-01') as competencia, 
	   1,
       1
  from bethadba.ferias
 where not exists(select 1
  		            from bethadba.ferias_proc
           	       where ferias_proc.i_entidades = ferias.i_entidades
               		 and ferias_proc.i_funcionarios = ferias.i_funcionarios
                     and ferias_proc.i_ferias = ferias.i_ferias);

-- CORREÇÃO 2
-- Atualiza as folhas de férias sem data de pagamento, definindo a data de pagamento como o último dia do mês da competência

begin
	declare w_i_entidades integer;
    declare w_competencias timestamp;
	
	llloop: for ll as meuloop1 dynamic scroll cursor for
        select i_entidades,
               i_funcionarios,
               i_ferias,
               80,
               date(year(dt_gozo_ini) || '-' || month(dt_gozo_ini) || '-01') as competencia_calculada,
               (select p.i_processamentos
             	  from bethadba.processamentos p
             	 where p.i_tipos_proc = 80
             	   and p.i_competencias = competencia_calculada) as processamentos_consulta
          from bethadba.ferias
         where not exists(select 1
                       		from bethadba.ferias_proc
                       	   where ferias_proc.i_entidades = ferias.i_entidades
                       		 and ferias_proc.i_funcionarios = ferias.i_funcionarios
                       		 and ferias_proc.i_ferias = ferias.i_ferias) 
		   and processamentos_consulta is null
	do
		set w_i_entidades = i_entidades;
		set w_competencias = competencia_calculada;

		insert into bethadba.processamentos (i_entidades,i_tipos_proc,i_competencias,i_processamentos,dt_fechamento,dt_pagto,simulado,dt_liberacao,pagto_realizado) 
		values (w_i_entidades,80,w_competencias,1,w_competencias,w_competencias,'N',w_competencias,'S');
	end for;
end;
-- VALIDAÇÃO 60
-- Busca os afastamentos com data inicial menor que data de admissão

select (select dt_admissao
          from bethadba.funcionarios
         where i_funcionarios = a.i_funcionarios
           and i_entidades = a.i_entidades) as data_admissao,
	    dt_afastamento,
       dt_ultimo_dia,
       i_entidades,
       i_funcionarios
  from bethadba.afastamentos as a
 where a.dt_afastamento < data_admissao;


-- CORREÇÃO
-- Atualiza a data de afastamento para um dia após a data de admissão do funcionário onde a data de afastamento é menor que a data de admissão

begin
	declare w_dt_afastamento timestamp;
   declare w_dt_ultimo_dia timestamp;
   declare w_i_entidades integer;
   declare w_i_funcionarios integer;
   declare w_dt_admissao timestamp;
   declare w_nova_data timestamp;
	
   llLoop: for ll as cur_01 dynamic scroll cursor for	
      select (select dt_admissao
                from bethadba.funcionarios
               where i_funcionarios = a.i_funcionarios
                 and i_entidades = a.i_entidades) as data_admissao,
             dt_afastamento,
             dt_ultimo_dia, 
             i_entidades, 
             i_funcionarios, 
             i_tipos_afast
        from bethadba.afastamentos as a
       where a.dt_afastamento < data_admissao
       order by a.i_funcionarios ASC
   do
      set w_dt_afastamento = dt_afastamento;
      set w_dt_ultimo_dia = dt_ultimo_dia;
      set w_i_entidades = i_entidades;
      set w_i_funcionarios = i_funcionarios;
      set w_dt_admissao = data_admissao;
      set w_nova_data = dateadd(day, 1, w_dt_admissao);
      
   update bethadba.afastamentos as a
      set dt_afastamento =  w_nova_data
    where i_funcionarios = w_i_funcionarios
      and dt_afastamento = w_dt_afastamento
      and i_entidades = w_i_entidades
   end for;
end;
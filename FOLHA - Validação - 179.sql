-- VALIDAÇÃO 179
-- Lançamentos de gozo com datas divergentes da data de inicio de gozo

select p.i_entidades,
       p.i_funcionarios,
       pf.i_periodos,
       pf.dt_periodo,
       f.dt_gozo_ini,
       pf.i_periodos_ferias,
       f.i_ferias
  from bethadba.periodos as p 
  join bethadba.periodos_ferias as pf
    on p.i_entidades = pf.i_entidades 
   and p.i_funcionarios = pf.i_funcionarios
   and p.i_periodos = pf.i_periodos 
  join bethadba.ferias as f
    on pf.i_entidades = f.i_entidades
   and pf.i_funcionarios = f.i_funcionarios
   and pf.i_periodos = f.i_periodos
   and pf.i_ferias = f.i_ferias
 where pf.manual = 'N' 
   and pf.dt_periodo <> f.dt_gozo_ini
   and pf.tipo = 2;


-- Correção
-- O script abaixo irá atualizar a data do período de férias com a data de início do gozo

begin
    declare w_dt_gozo_ini date;
    declare w_dt_periodo date;
    declare w_i_funcionarios integer;
    declare w_i_periodos_ferias integer;
    declare w_i_ferias integer;
    declare w_i_periodos integer;
    declare w_i_entidades integer;
    
    llloop: for ll as meuloop2 dynamic scroll cursor for
      select p.i_entidades,
             p.i_funcionarios,
             pf.i_periodos,
             pf.dt_periodo,
             f.dt_gozo_ini,
             pf.i_periodos_ferias,
             f.i_ferias
        from bethadba.periodos p 
        join bethadba.periodos_ferias pf
          on p.i_entidades = pf.i_entidades 
         and p.i_funcionarios = pf.i_funcionarios
         and p.i_periodos = pf.i_periodos 
        join bethadba.ferias f
          on pf.i_entidades = f.i_entidades
         and pf.i_funcionarios = f.i_funcionarios
         and pf.i_periodos = f.i_periodos
         and pf.i_ferias = f.i_ferias
       where pf.manual = 'N' 
         and pf.dt_periodo <> f.dt_gozo_ini
         and pf.tipo = 2

    do
        set w_dt_gozo_ini = dt_gozo_ini;
        set w_dt_periodo = dt_periodo;
        set w_i_funcionarios = i_funcionarios;
        set w_i_periodos_ferias = i_periodos_ferias;
        set w_i_ferias = i_ferias;
        set w_i_periodos = i_periodos;
        set w_i_entidades = i_entidades;

        update bethadba.periodos_ferias 
           set dt_periodo = w_dt_gozo_ini
         where i_funcionarios = w_i_funcionarios 
           and i_ferias = w_i_ferias
           and i_periodos = w_i_periodos
    end for;
end;
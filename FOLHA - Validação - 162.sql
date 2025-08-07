-- VALIDAÇÃO 162
-- Lançamentos sem dados de ferias

select pf.i_entidades,
       pf.i_funcionarios,
       pf.i_periodos,
       pf.i_periodos_ferias
  from bethadba.periodos_ferias pf 
 where not exists(select 1
                    from bethadba.ferias f
                   where f.i_entidades = pf.i_entidades
                     and f.i_funcionarios = pf.i_funcionarios
                     and f.i_periodos = pf.i_periodos
                     and f.i_ferias = pf.i_ferias)
   and pf.manual = 'N'
   and pf.tipo not in (1, 6, 7);


-- CORREÇÃO
-- Exclui os lançamentos de períodos de férias que não possuem dados de férias associados e que não são do tipo manual, férias coletivas ou férias de rescisão

delete bethadba.periodos_ferias
 where i_funcionarios in (select pf.i_funcionarios
                            from bethadba.periodos_ferias pf 
                           where not exists(select 1
                                              from bethadba.ferias f
                                             where f.i_entidades = pf.i_entidades
                                               and f.i_funcionarios = pf.i_funcionarios
                                               and f.i_periodos = pf.i_periodos
                                               and f.i_ferias = pf.i_ferias)
                             and pf.manual = 'N'
                             and pf.tipo not in(1, 6, 7))
   and i_periodos in (select pf.i_periodos
                        from bethadba.periodos_ferias pf 
                       where not exists(select 1
                                          from bethadba.ferias f
                                         where f.i_entidades = pf.i_entidades
                                           and f.i_funcionarios = pf.i_funcionarios
                                           and f.i_periodos = pf.i_periodos
                                           and f.i_ferias = pf.i_ferias)
                         and pf.manual = 'N'                                
                         and pf.tipo not in(1, 6, 7))
   and i_periodos_ferias in (select pf.i_periodos_ferias
                               from bethadba.periodos_ferias pf 
                              where not exists(select 1
                                                 from bethadba.ferias f
                                                where f.i_entidades = pf.i_entidades
                                                  and f.i_funcionarios = pf.i_funcionarios
                                                  and f.i_periodos = pf.i_periodos
                                                  and f.i_ferias = pf.i_ferias)
                                and pf.manual = 'N'                                
                                and pf.tipo not in(1, 6, 7));
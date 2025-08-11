-- VALIDAÇÃO 78
-- Tipo de afastamento deve possuir movimentação de pessoal quando possuir um ato

select af.i_entidades entidade,
       af.i_funcionarios func, 
       af.dt_afastamento dt_afast, 
       af.i_tipos_afast tp_afast
  from bethadba.afastamentos af,
       bethadba.tipos_afast ta
 where af.i_tipos_afast = ta.i_tipos_afast
   and af.i_atos is not null
   and ta.i_tipos_movpes is null
   and ta.i_tipos_afast <> 7
 order by af.i_entidades, af.i_funcionarios, af.dt_afastamento;


-- CORREÇÃO
-- Criar um tipo de movimentação de pessoal genérico para atualizar os tipos de afastamentos
insert into bethadba.tipos_movpes (i_tipos_movpes, descricao, classif, codigo_tce)
values ((select max(i_tipos_movpes) + 1 from bethadba.tipos_movpes),'Afastamento - Genérico',0,null);

-- Atualiza os tipos de afastamento para que possuam a movimentação de pessoal genérica vinculada
update bethadba.tipos_afast
   set i_tipos_movpes = (select max(i_tipos_movpes)
                           from bethadba.tipos_movpes
                          where descricao = 'Afastamento - Genérico')
 where i_tipos_movpes is null
   and i_tipos_afast <> 7;
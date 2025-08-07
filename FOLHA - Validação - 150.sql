-- VALIDAÇÃO 150
-- Pensionistas que não possuí cessação do benefício e que o instituidor não possui rescisão com motivo de morte ou possui rescisão com motivo de morte, mas com data de cancelamento

select f.i_entidades, 
       f.i_funcionarios,
       b.i_entidades_inst,
       b.i_instituidor,
       f.tipo_pens
  from bethadba.funcionarios f 
  join bethadba.beneficiarios b
    on f.i_entidades = b.i_entidades
   and f.i_funcionarios = b.i_funcionarios 
 where f.tipo_func = 'B' 
   and f.tipo_pens = 1
   and exists (select 1 from bethadba.rescisoes r 
                 join bethadba.motivos_apos ma
                   on r.i_motivos_apos = ma.i_motivos_apos 
                 join bethadba.tipos_afast ta
                   on ma.i_tipos_afast = ta.i_tipos_afast
                where r.i_entidades = b.i_entidades_inst 
                  and r.i_funcionarios = b.i_instituidor
                  and r.i_motivos_apos is not null
                  and r.dt_canc_resc is null
                  and ta.classif = 9)
   and not exists (select 1
                     from bethadba.rescisoes resc
                     join bethadba.motivos_resc mot
                       on (resc.i_motivos_resc = mot.i_motivos_resc)
                    where resc.i_entidades = b.i_entidades_inst
                      and resc.i_funcionarios = b.i_instituidor
                      and mot.dispensados = 4
                      and resc.dt_canc_resc is null)
 order by f.i_entidades, f.i_funcionarios asc;


-- CORREÇÃO
-- Atualizar o beneficiário inserindo data final de cessação do benefício

update bethadba.beneficiarios b
  join bethadba.funcionarios f
    on f.i_entidades = b.i_entidades
   and f.i_funcionarios = b.i_funcionarios
   set b.dt_cessacao = convert(varchar(10), getdate(), 120)
 where f.tipo_func = 'B'
   and f.tipo_pens = 1
   and exists (select 1
                 from bethadba.rescisoes r 
                 join bethadba.motivos_apos ma
                   on r.i_motivos_apos = ma.i_motivos_apos 
                 join bethadba.tipos_afast ta
                   on ma.i_tipos_afast = ta.i_tipos_afast
                where r.i_entidades = b.i_entidades_inst 
                  and r.i_funcionarios = b.i_instituidor
                  and r.i_motivos_apos is not null
                  and r.dt_canc_resc is null
                  and ta.classif = 9)
   and not exists (select 1
                     from bethadba.rescisoes resc 
                     join bethadba.motivos_resc mot
                       on (resc.i_motivos_resc = mot.i_motivos_resc)
                    where resc.i_entidades = b.i_entidades_inst 
                      and resc.i_funcionarios = b.i_instituidor 
                      and mot.dispensados = 4                                
                      and resc.dt_canc_resc is null);
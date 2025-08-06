-- VALIDAÇÃO 160
-- Averbação sem tipo de conta

select distinct hf.i_entidades,
       hf.i_funcionarios
  from bethadba.hist_funcionarios as hf 
  join bethadba.vinculos as v
    on hf.i_vinculos = v.i_vinculos
 where v.gera_licpremio = 'S'
   and exists (select 1
                 from bethadba.funcionarios as f
                where f.i_entidades = hf.i_entidades
                  and f.i_funcionarios = hf.i_funcionarios
                  and f.tipo_func = 'F'
   and f.conta_licpremio = 'N');


-- CORREÇÃO

update bethadba.funcionarios
set conta_licpremio = 'S'
where tipo_func = 'F'
  and conta_licpremio = 'N'
  and exists (
      select 1
        from bethadba.hist_funcionarios as hf
        join bethadba.vinculos as v
          on hf.i_vinculos = v.i_vinculos
       where v.gera_licpremio = 'S'
         and hf.i_entidades = funcionarios.i_entidades
         and hf.i_funcionarios = funcionarios.i_funcionarios
  );
/*
 -- VALIDA��O 159
 * Averba��o sem tipo de conta
 */

select distinct hf.i_entidades, hf.i_funcionarios 
          from  bethadba.hist_funcionarios hf 
          join bethadba.vinculos v on hf.i_vinculos = v.i_vinculos
          where v.i_adicionais is not null
          and exists (select 1 from bethadba.funcionarios f where f.i_entidades = hf.i_entidades and f.i_funcionarios = hf.i_funcionarios and f.tipo_func  = 'F'
      and f.conta_adicional = 'N')

/*
 -- CORRE��O
 */

update bethadba.funcionarios
set conta_adicional = 'S'
where i_entidades in (
    select distinct hf.i_entidades
    from bethadba.hist_funcionarios hf
    join bethadba.vinculos v on hf.i_vinculos = v.i_vinculos
    where v.i_adicionais is not null
    and exists (
        select 1
        from bethadba.funcionarios f
        where f.i_entidades = hf.i_entidades
        and f.i_funcionarios = hf.i_funcionarios
        and f.tipo_func = 'F'
        and f.conta_adicional = 'N'
    )
);

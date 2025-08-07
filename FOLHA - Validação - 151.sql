-- VALIDAÇÃO 151
--  = "Pensionistas sem dependente

select f.i_funcionarios,
          b.i_instituidor,
          f.i_pessoas,
          pessoaBeneficiario = (select f2.i_pessoas from bethadba.funcionarios f2 
                                      where f2.i_entidades = b.i_entidades_inst and f2.i_funcionarios = b.i_instituidor)
            from bethadba.funcionarios f
            join bethadba.beneficiarios b on f.i_entidades = b.i_entidades  and f.i_funcionarios = b.i_funcionarios 
                where f.i_entidades in (" + @gaEntidades + ")
                and f.tipo_func = 'B' 
                and f.tipo_pens in (1,2)
                and not exists (select 1 from bethadba.dependentes d
                    where d.i_pessoas = pessoaBeneficiario and d.i_dependentes = f.i_pessoas)


-- CORREÇÃO

insert into bethadba.dependentes (i_pessoas, i_dependentes, grau)
select 
    (select f2.i_pessoas
       from bethadba.funcionarios f2
      where f2.i_entidades = b.i_entidades_inst
        and f2.i_funcionarios = b.i_instituidor
    ) as pessoaBeneficiario,
    f.i_pessoas,
    1
from bethadba.funcionarios as f
join bethadba.beneficiarios as b
  on f.i_entidades = b.i_entidades
 and f.i_funcionarios = b.i_funcionarios
where f.tipo_func = 'B'
  and f.tipo_pens in (1,2)
  and (select f2.i_pessoas
         from bethadba.funcionarios f2
        where f2.i_entidades = b.i_entidades_inst
          and f2.i_funcionarios = b.i_instituidor
      ) <> f.i_pessoas
  and not exists (
      select 1
        from bethadba.dependentes as d
       where d.i_pessoas = (
                select f2.i_pessoas
                  from bethadba.funcionarios f2
                 where f2.i_entidades = b.i_entidades_inst
                   and f2.i_funcionarios = b.i_instituidor
            )
         and d.i_dependentes = f.i_pessoas
  );
-- VALIDAÇÃO 141
-- Data do processo de homologação maior que a data atual do ou da competência final

select pj.i_entidades,
       pj.i_pessoas,
       pj.i_funcionarios,
       pj.dt_homologacao,
       pj.dt_final,
       dataAtual = getDate()
  from bethadba.processos_judiciais pj 
 where pj.dt_homologacao > dataAtual 
    or pj.dt_homologacao > pj.dt_final;


-- CORREÇÃO

update bethadba.processos_judiciais
set dt_homologacao = 
    case 
        when dt_final < getDate() then dt_final
        else getDate()
    end
where dt_homologacao > getDate()
   or dt_homologacao > dt_final;

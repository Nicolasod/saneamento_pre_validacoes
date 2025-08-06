-- VALIDAÇÃO 45
-- Verifica os funcionários sem previdência

select hf.i_funcionarios,
       hf.i_entidades,
       hf.prev_federal,
       hf.prev_estadual,
       hf.fundo_ass,
       hf.fundo_prev,
       f.tipo_func
  from bethadba.hist_funcionarios hf
 inner join bethadba.funcionarios f
    on (f.i_funcionarios = hf.i_funcionarios
   and f.i_entidades = hf.i_entidades)
 where hf.prev_federal = 'N'
   and hf.prev_estadual = 'N'
   and hf.fundo_ass = 'N'
   and hf.fundo_prev = 'N'
   and f.tipo_func = 'F'
 group by hf.i_funcionarios,
 		      hf.i_entidades,
 	        hf.prev_federal,
       	  hf.prev_estadual,
       	  hf.fundo_ass,
       	  hf.fundo_prev,
       	  f.tipo_func
 order by hf.i_funcionarios;


-- CORREÇÃO
-- Altera a previdência federal para 'Sim' quando o histórico da matrícula não possuí nenhuma previdência marcada

update bethadba.hist_funcionarios hf
   set hf.prev_federal = 'S'
  from bethadba.funcionarios f
 where hf.i_funcionarios = f.i_funcionarios
   and f.tipo_func = 'F'
   and coalesce(hf.prev_federal, 'N') = 'N'
   and coalesce(hf.prev_estadual, 'N') = 'N'
   and coalesce(hf.fundo_ass, 'N') = 'N'
   and coalesce(hf.fundo_prev, 'N') = 'N'
   and coalesce(hf.fundo_financ, 'N') = 'N';
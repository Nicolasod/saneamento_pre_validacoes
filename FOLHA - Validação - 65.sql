-- VALIDAÇÃO 65
-- Verificar Teto Remuneratório

select e.i_entidades as entidade,
       ta.i_tipos_adm as tp_adm,
       competencia = (select max(a.i_competencias)
                        from bethadba.hist_tipos_adm as a 
                       where a.i_tipos_adm = ta.i_tipos_adm), 
       ta.vlr_sub_teto
  from bethadba.hist_tipos_adm as ta
  join bethadba.entidades as e
    on (ta.i_tipos_adm = e.i_tipos_adm)
 where vlr_sub_teto is null
 group by e.i_entidades,
          ta.i_tipos_adm,
          ta.i_competencias, 
          ta.vlr_sub_teto;


-- CORREÇÃO
-- Atualiza o valor do sub-teto para 99999 onde o valor é nulo, garantindo que todos os tipos administrativos tenham um valor definido para o sub-teto
                
update bethadba.hist_tipos_adm as hta
   set hta.vlr_sub_teto = '99999'
  from bethadba.entidades as e
 where hta.i_tipos_adm = e.i_tipos_adm
   and hta.i_competencias = (select max(x.i_competencias)
                               from bethadba.hist_tipos_adm as x
                              where x.i_tipos_adm = hta.i_tipos_adm
                                and x.vlr_sub_teto is null);
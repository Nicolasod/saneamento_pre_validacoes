-- VALIDAÇÃO 93
-- Históricos na matricula posterior a data de cessação da aposentadoria

/* RODAR VARIAS VEZES */
select distinct funcionarios.i_entidades as chave_dsk1,
       			funcionarios.i_funcionarios as chave_dsk2,
        		tipo as chave_dsk3,
        		dataAlteracao = hist_funcionarios.dt_alteracoes,
        		inicioVigencia = hist_funcionarios.dt_alteracoes,
        		codigoMatriculaNumero = if(select ctr_contrato_matric from bethadba.parametros_folha) = 'S' then string(left(funcionarios.i_funcionarios,length(funcionarios.i_funcionarios)-(select digitos_matric from bethadba.parametros_folha))) else string(funcionarios.i_funcionarios) endif,
        		codigoMatriculaContrato = if(select ctr_contrato_matric from bethadba.parametros_folha) = 'S' then string(right(funcionarios.i_funcionarios,(select digitos_matric from bethadba.parametros_folha))) else ' ' endif,
        		codigoMatriculaDigitoVerificador = funcionarios.dv,
        		numero = codigoMatriculaNumero,
        		contrato = codigoMatriculaContrato,
        		tipo = 'APOSENTADO',
        		rendimentoMensal = isnull((select sum(valor)
        									 from bethadba.calc_apos_pens cap
        									where cap.i_entidades = funcionarios.i_entidades
                                              and cap.i_funcionarios = funcionarios.i_funcionarios),
                                   		  (select hs.salario
                                   		     from bethadba.hist_salariais hs
                                   		    where hs.i_entidades = funcionarios.i_entidades
                                   		      and hs.i_funcionarios = funcionarios.i_funcionarios
                                   		      and hs.dt_alteracoes = bethadba.dbf_getdatahissal(funcionarios.i_entidades, funcionarios.i_funcionarios, getdate()))),
       			atoAposentadoria = (select max(aposent_pensoes.i_atos)
       								   from bethadba.aposent_pensoes
       								  where funcionarios.i_entidades = aposent_pensoes.i_entidades
       								    and funcionarios.i_funcionarios = aposent_pensoes.i_funcionarios),    
         		dataCessacaoAposentadoria = isnull(rescisoes.dt_canc_resc,(select resc.dt_rescisao
                                                                   		     from bethadba.rescisoes resc
                                                                   		     join bethadba.motivos_resc mot
                                                                   		       on (resc.i_motivos_resc = mot.i_motivos_resc)
                                                                            where resc.i_entidades = funcionarios.i_entidades
                                                                        	  and resc.i_funcionarios = funcionarios.i_funcionarios
                                                                       		  and mot.dispensados = 4                                
                                                                       		  and resc.dt_canc_resc is null)),
        		situacao = if dataCessacaoAposentadoria is not null then 'CESSADO' else 'APOSENTADO' endif                                                                    
    	   from bethadba.funcionarios ,
        		bethadba.hist_funcionarios , 
        		bethadba.rescisoes , 
        		bethadba.motivos_resc , 
        		bethadba.motivos_apos ,
        		bethadba.tipos_afast
    	  where funcionarios.i_entidades = rescisoes.i_entidades
    	    and funcionarios.i_funcionarios = rescisoes.i_funcionarios
    	    and funcionarios.i_entidades = hist_funcionarios.i_entidades
    	    and funcionarios.i_funcionarios = hist_funcionarios.i_funcionarios
    	    and hist_funcionarios.dt_alteracoes = bethadba.dbf_getdatahisfun(funcionarios.i_entidades, funcionarios.i_funcionarios, getdate())
    	    and rescisoes.i_motivos_resc = motivos_resc.i_motivos_resc
    	    and rescisoes.i_motivos_apos = motivos_apos.i_motivos_apos
    	    and motivos_apos.i_tipos_afast = tipos_afast.i_tipos_afast
    	    and tipos_afast.classif = 9
    	    and datacessacaoaposentadoria < dataalteracao;


-- CORREÇÃO
-- Exclui os registros de histórico de funcionários e de histórico de funcionários com proventos adicionais que estejam com data de alteração posterior a data de cessação da aposentadoria

delete from bethadba.hist_funcionarios
 where exists (select 1
				 from bethadba.funcionarios f
				 join bethadba.rescisoes r
				   on f.i_entidades = r.i_entidades
				  and f.i_funcionarios = r.i_funcionarios
				 join bethadba.motivos_resc mr
				   on r.i_motivos_resc = mr.i_motivos_resc
				 join bethadba.motivos_apos ma
				   on r.i_motivos_apos = ma.i_motivos_apos
				 join bethadba.tipos_afast ta
				   on ma.i_tipos_afast = ta.i_tipos_afast
				where ta.classif = 9
				  and f.i_entidades = hist_funcionarios.i_entidades
				  and f.i_funcionarios = hist_funcionarios.i_funcionarios
				  and hist_funcionarios.dt_alteracoes > isnull(r.dt_canc_resc, (select resc.dt_rescisao
																	   			  from bethadba.rescisoes resc
																				  join bethadba.motivos_resc mot
																					on resc.i_motivos_resc = mot.i_motivos_resc
																				 where resc.i_entidades = f.i_entidades
																				   and resc.i_funcionarios = f.i_funcionarios
																				   and mot.dispensados = 4
																				   and resc.dt_canc_resc is null)));
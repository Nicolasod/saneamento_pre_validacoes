-- VALIDAÇÃO 128
-- Pessoa fisica sem historico

select i_pessoas 
  from bethadba.pessoas_fisicas pf 
 where i_pessoas not in (select distinct(i_pessoas)
 						   from bethadba.hist_pessoas_fis hpf);


-- CORREÇÃO
-- Insere os registros de pessoas fisicas que não possuem historico na tabela de historico de pessoas fisicas.

insert into bethadba.hist_pessoas_fis (i_pessoas, dt_alteracoes, dt_nascimento, sexo, rg, orgao_emis_rg, uf_emis_rg, dt_emis_rg, cpf, num_pis, dt_pis, carteira_prof, serie_cart, uf_emis_carteira, dt_emis_carteira, zona_eleitoral, secao_eleitoral, titulo_eleitor, grau_instrucao, estado_civil, cnh, categoria_cnh, dt_vencto_cnh, dt_primeira_cnh, observacoes_cnh, dt_emissao_cnh, i_estados_cnh, ric, orgao_ric, dt_emissao_ric, raca, certidao, ddd, telefone, ddd_cel, celular, email, tipo_validacao, tipo_pessoa, ident_estrangeiro, dt_validade_est, tipo_visto_est, cart_trab_est, serie_cart_est, dt_exp_cart_est, dt_val_cart_est, i_paises, orgao_emissor_est, dt_emissao_est, i_paises_nacionalidade, data_chegada_est, ano_chegada_est, casado_brasileiro_est, filho_brasileiro_est, i_situacao_estrangeiro, residencia_fiscal_exterior, i_pais_residencia_fiscal, indicativo_nif, numero_identificacao_fiscal, forma_tributacao)
select i_pessoas, '2024-01-01', dt_nascimento, sexo, rg, orgao_emis_rg, uf_emis_rg, dt_emis_rg, cpf, num_pis, dt_pis , carteira_prof , serie_cart , uf_emis_carteira , dt_emis_carteira, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'F', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
  from bethadba.pessoas_fisicas 
 where i_pessoas in (select i_pessoas 
		       from bethadba.pessoas_fisicas as pf 
		      where i_pessoas not in (select distinct(i_pessoas)
					  	from bethadba.hist_pessoas_fis as hpf));
-- VALIDAÇÃO 63
-- Quantidade de vagas nos cargos não pode ser maior que 99999

select c1.i_cargos,
       isnull(c1.qtd_vagas,0), 
       isnull(c2.vagas_acresc,0)
  from bethadba.cargos_compl c1
  left join bethadba.mov_cargos c2
    on c1.i_cargos = c2.i_cargos
 where c1.qtd_vagas > 9999
    or c2.vagas_acresc > 9999;


-- CORREÇÃO
-- Atualiza os cargos que possuem quantidade de vagas maior que 9999 e as vagas acrescidas para 9999

update bethadba.cargos_compl a
   set a.qtd_vagas = 9999,
       b.vagas_acresc = 9999
  from bethadba.mov_cargos b
 where a.qtd_vagas > 9999
   and a.i_cargos = b.i_cargos
   and b.vagas_acresc > 9999;
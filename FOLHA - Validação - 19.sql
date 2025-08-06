-- VALIDAÇÃO 19
-- Verifica categoria eSocial nulo no vínculo empregatício

select i_vinculos,
       descricao,
       categoria_esocial
  from bethadba.vinculos
 where categoria_esocial is null
   and tipo_func <> 'B';


-- CORREÇÃO
-- Atualiza a categoria eSocial nulo para um valor padrão (exemplo: 105) para evitar problemas de integridade referencial

update bethadba.vinculos
   set categoria_esocial = 105
 where categoria_esocial is null
   and i_vinculos = 3;
-- VALIDAÇÃO 76
-- Verifica Estagiário(s) sem agente de integração informado

select estagios.i_entidades entidade, 
       estagios.i_funcionarios func,
       hist_funcionarios.dt_alteracoes dt_alt, 
       hist_funcionarios.i_agente_integracao_estagio
  from bethadba.estagios
  join bethadba.hist_funcionarios
    on (estagios.i_entidades = hist_funcionarios.i_entidades
   and estagios.i_funcionarios = hist_funcionarios.i_funcionarios)
 where hist_funcionarios.i_agente_integracao_estagio is null
 order by estagios.i_entidades, 
          estagios.i_funcionarios, 
          hist_funcionarios.dt_alteracoes;


-- CORREÇÃO
-- Atualiza o agente de integração dos estagiários para uma entidade educacional padrão

begin
  -- Variável para armazenar o novo i_pessoas
  declare @nova_entidade int;

  -- Insere entidade educacional se não existir e captura o novo i_pessoas
  if not exists (select 1 from bethadba.pessoas where nome = 'Entidade Educacional') then
    insert into bethadba.pessoas (i_pessoas,dv,nome,nome_fantasia,tipo_pessoa,ddd,telefone,fax,ddd_cel,celular,inscricao_municipal,email,cod_unificacao,nome_social,considera_nome_social_fly)
    select (select coalesce(max(i_pessoas), 0) + 1 from bethadba.pessoas), null, 'Entidade Educacional', null, 'J', null, null, null, null, null, null, null, null, null, 'N';
    set @nova_entidade = (select max(i_pessoas) from bethadba.pessoas where nome = 'Entidade Educacional');
  else
    set @nova_entidade = (select i_pessoas from bethadba.pessoas where nome = 'Entidade Educacional');
  end if;

  update bethadba.hist_funcionarios
     set i_agente_integracao_estagio = @nova_entidade
   where i_agente_integracao_estagio is null
     and exists (
       select 1
         from bethadba.estagios
        where estagios.i_entidades = hist_funcionarios.i_entidades
          and estagios.i_funcionarios = hist_funcionarios.i_funcionarios
     );
end
# Criação do projeto

Segue abaixo a explicação do funcionamento dos principais arquivos do projeto:

---

## `conexao.dsn`

Arquivo de configuração ODBC utilizado para armazenar os parâmetros de conexão com o banco de dados Sybase.  
Deve conter informações como driver, servidor, banco, usuário e senha.  
É utilizado pelos scripts Python para realizar a conexão de forma centralizada e segura.

---

## `teste_conexao.py`

Script Python para testar a conexão com o banco de dados utilizando o arquivo `conexao.dsn`.  
Executa um comando simples (`SELECT 1`) para verificar se a conexão está funcionando corretamente.  
Útil para validar se o ambiente está configurado antes de executar os demais scripts.

---

## `executa_validacoes.py`

Script responsável por:
- Ler todos os arquivos `.sql` da pasta principal.
- Executar o `SELECT` de cada arquivo para identificar se há registros que precisam de correção.
- Caso existam registros, extrai o bloco de correção do arquivo `.sql` e monta um arquivo único de correções na pasta `arquivos/saneamentoValidado`.
- O arquivo de correção gerado contém comandos de controle no início e no fim, além de separar cada correção pelo nome da validação.

---

## `executa_tudo.py`

Script principal de automação:
- Executa o `executa_validacoes.py` para gerar o arquivo de correções.
- Localiza o arquivo de correção mais recente na pasta de saída.
- Executa, no banco de dados, cada bloco de correção presente no arquivo, registrando logs de sucesso ou erro para cada validação.
- Realiza rollback automático em caso de erro na execução de alguma correção, garantindo a integridade dos dados.
- Gera um relatório final com o resumo das validações e correções aplicadas.

---

## `logs/`

Pasta onde são armazenados os arquivos de log gerados durante a execução dos scripts.  
Os logs contêm informações detalhadas sobre o que foi executado, incluindo timestamps, comandos SQL, e resultados (sucesso/erro).  
Esses arquivos são úteis para auditoria e para análise de eventuais problemas que ocorram durante a execução dos scripts.

---

## `relatorios/`

Pasta destinada ao armazenamento dos relatórios gerados pelo script `executa_tudo.py`.  
Os relatórios são gerados em formato `.txt` e contêm um resumo das validações realizadas, correções aplicadas, e eventuais erros encontrados.  
Servem como documentação do que foi executado em cada rodada de saneamento de dados.

---

## `arquivos/saneamentoValidado/`

Pasta onde são salvos os arquivos de correção gerados pelo script `executa_validacoes.py`.  
Estes arquivos contêm os comandos necessários para corrigir os registros identificados como problemáticos.  
A separação por nome de validação facilita a identificação e o entendimento das correções aplicadas.

---

## `README.md`

Arquivo que você está lendo.  
Contém informações sobre o projeto, como sua finalidade, como está estruturado, e instruções básicas de uso.  
É o primeiro arquivo que um novo desenvolvedor ou usuário deve ler para entender o que o projeto faz e como começar a utilizá-lo.

---

## `requirements.txt`

Lista de dependências do projeto, especificando os pacotes Python necessários para a execução dos scripts.  
Facilita a instalação das bibliotecas necessárias através do `pip`, garantindo que o ambiente esteja corretamente configurado.

---

## `setup.py`

Script de configuração do projeto, utilizado para instalar pacotes e dependências necessárias.  
Pode incluir a configuração de variáveis de ambiente, instalação de bibliotecas, e outras tarefas necessárias para preparar o ambiente de execução.

---

## `src/`

Pasta que pode ser utilizada para armazenar código-fonte adicional, bibliotecas customizadas, ou outros recursos que sejam utilizados pelos scripts principais.  
Pode ser organizada de acordo com a necessidade do projeto, incluindo subpastas para diferentes módulos ou funcionalidades.

---

## `tests/`

Pasta destinada ao armazenamento de testes automatizados para os scripts do projeto.  
É recomendável que sejam criados testes para validar o funcionamento correto de cada parte do sistema, garantindo a qualidade e a confiabilidade do código.

---

## `Dockerfile`

Arquivo de configuração para a criação de uma imagem Docker do projeto.  
Permite empacotar o aplicativo e suas dependências em um contêiner, facilitando a implantação e a execução em diferentes ambientes.

---

## `docker-compose.yml`

Arquivo de configuração para o Docker Compose, utilizado para definir e executar aplicações Docker com múltiplos contêineres.  
Pode ser utilizado para orquestrar a execução de diferentes serviços que compõem o projeto, como o banco de dados e a aplicação Python.

---

## `Makefile`

Arquivo utilizado pelo utilitário `make` para automatizar a execução de tarefas recorrentes no projeto.  
Permite definir comandos e scripts que podem ser executados com um único comando, facilitando a automação de tarefas como testes, builds, e execução de scripts.

---

## `LICENSE`

Arquivo que contém a licença do projeto, especificando os termos sob os quais o código pode ser utilizado, modificado e distribuído.  
É importante para definir os direitos e deveres de quem utiliza o código, além de proteger a propriedade intelectual do autor.

---

## `CONTRIBUTING.md`

Arquivo que contém diretrizes para contribuição no projeto.  
Especifica como os desenvolvedores podem contribuir, como relatar problemas, sugerir melhorias, ou submeter código.  
Ajuda a manter a organização e a qualidade das contribuições recebidas.

---

## `CHANGELOG.md`

Arquivo que documenta as alterações realizadas em cada versão do projeto.  
Permite acompanhar a evolução do projeto, identificando o que foi adicionado, modificado ou corrigido em cada versão.

---

## `venv/`

Pasta onde o ambiente virtual Python é criado e gerenciado.  
Contém todas as bibliotecas e dependências instaladas para o projeto, isolando-as do restante do sistema.  
É recomendável que esta pasta seja criada e gerenciada automaticamente pelos scripts de configuração do projeto.

---

## `__pycache__/`

Pasta onde o Python armazena arquivos compilados de bytecode.  
É criada automaticamente pelo interpretador Python e não deve ser modificada manualmente.  
Pode ser ignorada no controle de versão, pois seu conteúdo é gerado automaticamente.

---

## `.gitignore`

Arquivo que especifica quais arquivos ou pastas devem ser ignorados pelo sistema de controle de versão Git.  
É utilizado para evitar que arquivos desnecessários ou sensíveis sejam incluídos no repositório.

---

## `.env`

Arquivo utilizado para armazenar variáveis de ambiente do projeto.  
Permite configurar parâmetros sensíveis, como senhas e chaves de API, sem precisar modificar o código-fonte.  
Deve ser mantido em segredo e nunca deve ser incluído no controle de versão.

---

## `.flake8`

Arquivo de configuração para o Flake8, uma ferramenta de análise estática de código para Python.  
Especifica regras e convenções de estilo que o código deve seguir, ajudando a manter a qualidade e a legibilidade do código.

---

## `.prettierrc`

Arquivo de configuração para o Prettier, uma ferramenta de formatação de código.  
Define as regras de formatação que devem ser aplicadas ao código-fonte do projeto, garantindo uma aparência consistente.

---

## `.editorconfig`

Arquivo de configuração para o EditorConfig, uma ferramenta que ajuda a manter estilos de codificação consistentes entre diferentes editores e IDEs.  
Especifica regras de formatação, como indentação, espaçamento, e quebras de linha.

---

## `docs/`

Pasta destinada à documentação do projeto.  
Pode conter documentos adicionais, como manuais de usuário, guias de instalação, e documentação da API.  
É recomendável que a documentação seja mantida atualizada e seja clara e acessível.

---

## `notebooks/`

Pasta para armazenar notebooks Jupyter, caso sejam utilizados durante o desenvolvimento do projeto.  
Notebooks podem ser úteis para prototipagem, testes rápidos, ou documentação de análises realizadas.

---

## `scripts/`

Pasta para armazenar scripts auxiliares que possam ser úteis durante o desenvolvimento ou manutenção do projeto.  
Podem incluir scripts para automação de tarefas, geração de relatórios, ou qualquer outra função que auxilie no dia a dia do projeto.

---

## `ferramentas/`

Pasta para armazenar ferramentas ou utilitários que possam ser úteis para o desenvolvimento ou operação do projeto.  
Podem incluir ferramentas de linha de comando, bibliotecas auxiliares, ou qualquer outro recurso que não se encaixe nas categorias anteriores.

---

## `exemplos/`

Pasta para armazenar exemplos de uso do projeto, como arquivos de configuração de exemplo, scripts de exemplo, ou dados de exemplo.  
Ajuda novos usuários a entender como utilizar o projeto corretamente.

---

## `tarefas/`

Pasta para armazenar tarefas agendadas ou scripts de manutenção que precisam ser executados periodicamente.  
Pode incluir scripts para limpeza de dados, arquivamento de logs, ou qualquer outra tarefa de manutenção.

---

## `tmp/`

Pasta temporária que pode ser utilizada para armazenar arquivos ou dados que são gerados temporariamente durante a execução dos scripts.  
Deve ser limpa regularmente para evitar o acúmulo de arquivos desnecessários.

---

## `backup/`

Pasta para armazenar backups de segurança dos dados ou arquivos importantes do projeto.  
É recomendável que sejam realizados backups regulares e que sejam armazenados em local seguro.

---

## `historico/`

Pasta para armazenar o histórico de alterações ou versões anteriores de arquivos importantes.  
Pode ser útil para restaurar versões anteriores em caso de erro ou problema com a versão atual.

---

## `arquivos/`

Pasta para armazenar arquivos diversos que possam ser necessários para o projeto, como dados, modelos, ou outros recursos.  
Pode ser organizada em subpastas conforme a necessidade do projeto.

---

## `public/`

Pasta para armazenar arquivos ou recursos que precisam ser acessíveis publicamente, como arquivos estáticos para um site, ou dados públicos.  
Deve ser configurada com as devidas permissões de acesso.

---

## `privado/`

Pasta para armazenar arquivos ou recursos que devem ser mantidos em segredo, como chaves privadas, senhas, ou dados sensíveis.  
Deve ter as permissões de acesso restritas apenas às pessoas ou processos que realmente precisam acessar essas informações.

---

## `arquivos/`

Pasta para armazenar arquivos diversos que possam ser necessários para o projeto, como dados, modelos, ou outros recursos.  
Pode ser organizada em subpastas conforme a necessidade do projeto.

---

## `docs/`

Pasta destinada à documentação do projeto.  
Pode conter documentos adicionais, como manuais de usuário, guias de instalação, e documentação da API.  
É recomendável que a documentação seja mantida atualizada e seja clara e acessível.

---

## `notebooks/`

Pasta para armazenar notebooks Jupyter, caso sejam utilizados durante o desenvolvimento do projeto.  
Notebooks podem ser úteis para prototipagem, testes rápidos, ou documentação de análises realizadas.

---

## `scripts/`

Pasta para armazenar scripts auxiliares que possam ser úteis durante o desenvolvimento ou manutenção do projeto.  
Podem incluir scripts para automação de tarefas, geração de relatórios, ou qualquer outra função que auxilie no dia a dia do projeto.

---

## `ferramentas/`

Pasta para armazenar ferramentas ou utilitários que possam ser úteis para o desenvolvimento ou operação do projeto.  
Podem incluir ferramentas de linha de comando, bibliotecas auxiliares, ou qualquer outro recurso que não se encaixe nas categorias anteriores.

---

## `exemplos/`

Pasta para armazenar exemplos de uso do projeto, como arquivos de configuração de exemplo, scripts de exemplo, ou dados de exemplo.  
Ajuda novos usuários a entender como utilizar o projeto corretamente.

---

## `tarefas/`

Pasta para armazenar tarefas agendadas ou scripts de manutenção que precisam ser executados periodicamente.  
Pode incluir scripts para limpeza de dados, arquivamento de logs, ou qualquer outra tarefa de manutenção.

---

## `tmp/`

Pasta temporária que pode ser utilizada para armazenar arquivos ou dados que são gerados temporariamente durante a execução dos scripts.  
Deve ser limpa regularmente para evitar o acúmulo de arquivos desnecessários.

---

## `backup/`

Pasta para armazenar backups de segurança dos dados ou arquivos importantes do projeto.  
É recomendável que sejam realizados backups regulares e que sejam armazenados em local seguro.

---

## `historico/`

Pasta para armazenar o histórico de alterações ou versões anteriores de arquivos importantes.  
Pode ser útil para restaurar versões anteriores em caso de erro ou problema com a versão atual.

---

## `arquivos/`

Pasta para armazenar arquivos diversos que possam ser necessários para o projeto, como dados, modelos, ou outros recursos.  
Pode ser organizada em subpastas conforme a necessidade do projeto.

---

## `public/`

Pasta para armazenar arquivos ou recursos que precisam ser acessíveis publicamente, como arquivos estáticos para um site, ou dados públicos.  
Deve ser configurada com as devidas permissões de acesso.

---

## `privado/`

Pasta para armazenar arquivos ou recursos que devem ser mantidos em segredo, como chaves privadas, senhas, ou dados sensíveis.  
Deve ter as permissões de acesso restritas apenas às pessoas ou processos que realmente precisam acessar essas informações.

---

## `README.md`

Arquivo que você está lendo.  
Contém informações sobre o projeto, como sua finalidade, como está estruturado, e instruções básicas de uso.  
É o primeiro arquivo que um novo desenvolvedor ou usuário deve ler para entender o que o projeto faz e como começar a utilizá-lo.

---

## `requirements.txt`

Lista de dependências do projeto, especificando os pacotes Python necessários para a execução dos scripts.  
Facilita a instalação das bibliotecas necessárias através do `pip`, garantindo que o ambiente esteja corretamente configurado.

---

## `setup.py`

Script de configuração do projeto, utilizado para instalar pacotes e dependências necessárias.  
Pode incluir a configuração de variáveis de ambiente, instalação de bibliotecas, e outras tarefas necessárias para preparar o ambiente de execução.

---

## `src/`

Pasta que pode ser utilizada para armazenar código-fonte adicional, bibliotecas customizadas, ou outros recursos que sejam utilizados pelos scripts principais.  
Pode ser organizada de acordo com a necessidade do projeto, incluindo subpastas para diferentes módulos ou funcionalidades.

---

## `tests/`

Pasta destinada ao armazenamento de testes automatizados para os scripts do projeto.  
É recomendável que sejam criados testes para validar o funcionamento correto de cada parte do sistema, garantindo a qualidade e a confiabilidade do código.

---

## `Dockerfile`

Arquivo de configuração para a criação de uma imagem Docker do projeto.  
Permite empacotar o aplicativo e suas dependências em um contêiner, facilitando a implantação e a execução em diferentes ambientes.

---

## `docker-compose.yml`

Arquivo de configuração para o Docker Compose, utilizado para definir e executar aplicações Docker com múltiplos contêineres.  
Pode ser utilizado para orquestrar a execução de diferentes serviços que compõem o projeto, como o banco de dados e a aplicação Python.

---

## `Makefile`

Arquivo utilizado pelo utilitário `make` para automatizar a execução de tarefas recorrentes no projeto.  
Permite definir comandos e scripts que podem ser executados com um único comando, facilitando a automação de tarefas como testes, builds, e execução de scripts.

---

## `LICENSE`

Arquivo que contém a licença do projeto, especificando os termos sob os quais o código pode ser utilizado, modificado e distribuído.  
É importante para definir os direitos e deveres de quem utiliza o código, além de proteger a propriedade intelectual do autor.

---

## `CONTRIBUTING.md`

Arquivo que contém diretrizes para contribuição no projeto.  
Especifica como os desenvolvedores podem contribuir, como relatar problemas, sugerir melhorias, ou submeter código.  
Ajuda a manter a organização e a qualidade das contribuições recebidas.

---

## `CHANGELOG.md`

Arquivo que documenta as alterações realizadas em cada versão do projeto.  
Permite acompanhar a evolução do projeto, identificando o que foi adicionado, modificado ou corrigido em cada versão.

---

## `venv/`

Pasta onde o ambiente virtual Python é criado e gerenciado.  
Contém todas as bibliotecas e dependências instaladas para o projeto, isolando-as do restante do sistema.  
É recomendável que esta pasta seja criada e gerenciada automaticamente pelos scripts de configuração do projeto.

---

## `__pycache__/`

Pasta onde o Python armazena arquivos compilados de bytecode.  
É criada automaticamente pelo interpretador Python e não deve ser modificada manualmente.  
Pode ser ignorada no controle de versão, pois seu conteúdo é gerado automaticamente.

---

## `.gitignore`

Arquivo que especifica quais arquivos ou pastas devem ser ignorados pelo sistema de controle de versão Git.  
É utilizado para evitar que arquivos desnecessários ou sensíveis sejam incluídos no repositório.

---

## `.env`

Arquivo utilizado para armazenar variáveis de ambiente do projeto.  
Permite configurar parâmetros sensíveis, como senhas e chaves de API, sem precisar modificar o código-fonte.  
Deve ser mantido em segredo e nunca deve ser incluído no controle de versão.

---

## `.flake8`

Arquivo de configuração para o Flake8, uma ferramenta de análise estática de código para Python.  
Especifica regras e convenções de estilo que o código deve seguir, ajudando a manter a qualidade e a legibilidade do código.

---

## `.prettierrc`

Arquivo de configuração para o Prettier, uma ferramenta de formatação de código.  
Define as regras de formatação que devem ser aplicadas ao código-fonte do projeto, garantindo uma aparência consistente.

---

## `.editorconfig`

Arquivo de configuração para o EditorConfig, uma ferramenta que ajuda a manter estilos de codificação consistentes entre diferentes editores e IDEs.  
Especifica regras de formatação, como indentação, espaçamento, e quebras de linha.

---

## `docs/`

Pasta destinada à documentação do projeto.  
Pode conter documentos adicionais, como manuais de usuário, guias de instalação, e documentação da API.  
É recomendável que a documentação seja mantida atualizada e seja clara e acessível.

---

## `notebooks/`

Pasta para armazenar notebooks Jupyter, caso sejam utilizados durante o desenvolvimento do projeto.  
Notebooks podem ser úteis para prototipagem, testes rápidos, ou documentação de análises realizadas.

---

## `scripts/`

Pasta para armazenar scripts auxiliares que possam ser úteis durante o desenvolvimento ou manutenção do projeto.  
Podem incluir scripts para automação de tarefas, geração de relatórios, ou qualquer outra função que auxilie no dia a dia do projeto.

---

## `ferramentas/`

Pasta para armazenar ferramentas ou utilitários que possam ser úteis para o desenvolvimento ou operação do projeto.  
Podem incluir ferramentas de linha de comando, bibliotecas auxiliares, ou qualquer outro recurso que não se encaixe nas categorias anteriores.

---

## `exemplos/`

Pasta para armazenar exemplos de uso do projeto, como arquivos de configuração de exemplo, scripts de exemplo, ou dados de exemplo.  
Ajuda novos usuários a entender como utilizar o projeto corretamente.

---

## `tarefas/`

Pasta para armazenar tarefas agendadas ou scripts de manutenção que precisam ser executados periodicamente.  
Pode incluir scripts para limpeza de dados, arquivamento de logs, ou qualquer outra tarefa de manutenção.

---

## `tmp/`

Pasta temporária que pode ser utilizada para armazenar arquivos ou dados que são gerados temporariamente durante a execução dos scripts.  
Deve ser limpa regularmente para evitar o acúmulo de arquivos desnecessários.

---

## `backup/`

Pasta para armazenar backups de segurança dos dados ou arquivos importantes do projeto.  
É recomendável que sejam realizados backups regulares e que sejam armazenados em local seguro.

---

## `historico/`

Pasta para armazenar o histórico de alterações ou versões anteriores de arquivos importantes.  
Pode ser útil para restaurar versões anteriores em caso de erro ou problema com a versão atual.

---

## `arquivos/`

Pasta para armazenar arquivos diversos que possam ser necessários para o projeto, como dados, modelos, ou outros recursos.  
Pode ser organizada em subpastas conforme a necessidade do projeto.

---

## `public/`

Pasta para armazenar arquivos ou recursos que precisam ser acessíveis publicamente, como arquivos estáticos para um site, ou dados públicos.  
Deve ser configurada com as devidas permissões de acesso.

---

## `privado/`

Pasta para armazenar arquivos ou recursos que devem ser mantidos em segredo, como chaves privadas, senhas, ou dados sensíveis.  
Deve ter as permissões de acesso restritas apenas às pessoas ou processos que realmente precisam acessar essas informações.

---
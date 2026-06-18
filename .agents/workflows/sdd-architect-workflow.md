---
description: Fluxo interativo de Spec-Driven Development (SDD). Ingestão de Issues via GitHub MCP, prototipação via Stitch e fatiamento da arquitetura orientada a Angular e Supabase.
---

Workflow: SDD Architect

Objetivo: Ingerir contexto via MCP, gerar os Critérios de Aceitação rigorosos e criar o spec.json (ou .md). Proibido escrever código de produção.

Descrição: Fluxo interativo de Spec-Driven Development (SDD). Ingestão de Issues via GitHub MCP, prototipação via Stitch e fatiamento da arquitetura orientada a Angular e Supabase.

Step 0: Setup Inicial (A Entrevista)
Inicie a conversa fazendo EXATAMENTE estas duas perguntas:

"Qual é o ID ou link da Issue do GitHub que vamos detalhar?"

"Existe alguma tela no Stitch para esta Issue? Se sim, qual é o nome/link?"
🛑 PARE A EXECUÇÃO AQUI E AGUARDE AS RESPOSTAS DO USUÁRIO.

Step 1: Ingestão de Especificações (A Bússola)
Após receber as respostas, inicie a fase de Research profundo:

Research do Problema: Use o MCP do GitHub para ler a Issue na íntegra.

Research de Governança: Inspecione o arquivo global @docs/sdd.md para absorver os Padrões Globais (stack, UI, segurança, tratamento de erros).

Research de Código (Anti-Duplicação): Antes de propor novos arquivos, utilize as suas ferramentas de leitura de repositório para pesquisar se já existem Entidades, Services (ex: SupabaseService), Tipagens ou Componentes de UI genéricos no projeto que possam ser reaproveitados para esta Issue.

Refinamento Técnico: Identifique se há ambiguidades. Se a Issue exigir algo não coberto pelo código/documentação atual, faça perguntas diretas ao usuário antes de prosseguir.

Step 2: Geração de Contratos e Critérios
Não escreva código de produção. Escreva um Plano de Ação detalhado contendo:

Critérios de Aceitação: Formule RIGOROSAMENTE no formato: Given / When / Then / Shall. Nenhuma regra de negócio deve ficar ambígua (mapeie os cenários felizes e de erro).

Contratos de Dados: Defina as estruturas de dados (DTOs/Interfaces) esperadas pelo front-end e os códigos de erro padrão da API do Supabase que precisaremos tratar.

Data Layer: Liste tabelas, colunas, tipos de dados e relacionamentos a serem criados ou alterados no PostgreSQL do Supabase.

Step 3: O Fatiamento de Fases (O Mapa de Execução)
Divida a implementação ESTRITAMENTE nestas quatro fases sequenciais. Para CADA FASE, você deve detalhar minuciosamente o escopo de trabalho antes de gerar a especificação. Você DEVE detalhar:

Fase 1: Data Layer (Supabase/PostgreSQL):

Quais tabelas, colunas (com tipos de dados explícitos) e relacionamentos (Foreign Keys) serão afetados.

O arquivo SQL de Migration que será gerado na pasta supabase/migrations/.

Quais colunas precisam de Índices, Unique, ou regras de deleção em cascata (OnDelete).

Fase 2: Security & Database Logic (Supabase):

Quais políticas de segurança RLS (Row Level Security) precisam ser escritas para proteger as tabelas (garantindo que usuários só leiam/editem seus próprios dados).

Necessidade de Triggers ou Functions no PostgreSQL, se a regra de negócio for estritamente de banco de dados.

Fase 3: UI Design (Angular):

Quais arquivos .html e .ts de componentes (Pages ou UI Components) serão gerados.

Consulte o @docs/sdd.md para identificar a Biblioteca de Componentes UI oficial do projeto (ex: Spartan, daisyUI, Angular Material, etc.). Baseado nela, liste explicitamente quais componentes pré-fabricados serão utilizados para materializar a referência visual do Stitch.

Indique exatamente em quais momentos os componentes de Loading e Empty State (já padronizados no sistema) deverão ser acionados nesta tela.

Fase 4: Frontend Logic (Angular):

Quais arquivos de Services ou Stores (SignalStore) serão afetados/criados.

Quais métodos usarão o @supabase/supabase-js para integração com o backend.

Indique quais mensagens de erro (Toasts/Modais) deverão ser disparadas pelo serviço global de erros quando as requisições ao Supabase falharem.

Exiba o plano completo, fase a fase, e pergunte: "O detalhamento técnico das Fases, as políticas sugeridas e os Critérios de Aceitação estão aprovados para gerarmos o artefato de especificação final?"
🛑 PARE A EXECUÇÃO AQUI E AGUARDE A APROVAÇÃO DO USUÁRIO.

Step 4: Artefato Final
Se aprovado, gere o ficheiro specs/spec-issue-X.json preenchendo EXATAMENTE o template abaixo com as informações decididas nos passos anteriores. Encerre sua execução instruindo o usuário a abrir uma nova janela de chat com o agente de TDD.

{
  "issue_id": "ID_DA_ISSUE",
  "feature_name": "NOME_DA_FUNCIONALIDADE",
  "acceptance_criteria": ["Given [condição], When [ação], Then [resultado] shall [obrigação]"],
  "technical_setup": {
    "supabase_contracts": {},
    "database_schema": {}
  },
  "execution_phases": [
    {
      "phase": "1_database_layer",
      "skill": "@postgres-dba",
      "artifacts": [],
      "details": ""
    },
    {
      "phase": "2_security_rls_supabase",
      "skill": "@postgres-dba",
      "artifacts": [],
      "policies": [],
      "details": ""
    },
    {
      "phase": "3_ui_design_angular",
      "skill": "@angular-expert",
      "artifacts": [],
      "ui_library_components": [],
      "ui_states": { "loading": "", "empty": "" },
      "details": ""
    },
    {
      "phase": "4_frontend_logic_angular",
      "skill": "@angular-expert",
      "artifacts": [],
      "store_affected": false,
      "error_handling": ""
    }
  ]
}
# 📐 Software Design Document (SDD) - Tirei-Você

**Projeto:** Tirei-Você (Plataforma de Sorteio de Amigo Secreto)  
**Versão:** 1.0.0  
**Status:** 🟢 Pronto para Implementação  
**Stack Principal:** NestJS, Angular, Prisma ORM, PostgreSQL.

---

## 🏗️ 1. Arquitetura do Sistema (Estrutura Monorepo)

O projeto utiliza uma arquitetura de Monorepo gerenciada para manter a consistência de tipagem ponta a ponta. O Agente de IA deve respeitar a seguinte estrutura de pastas:

- **`apps/api`**: Servidor Backend (NestJS).
- **`apps/web`**: Aplicação Client / PWA (Angular 17+).

## 🤖 2. Orquestração e Ecossistema de Contexto (MCP)

> **Instrução para a IA:** Este projeto utiliza o Model Context Protocol (MCP) para garantir a paridade entre a especificação e a execução técnica. Sempre utilize as ferramentas abaixo antes de propor alterações estruturais.

- **GitHub Projects MCP:** Utilize para sincronizar o status das User Stories (PRD) com o desenvolvimento técnico. As definições de "Done" devem seguir estritamente os Critérios de Aceitação mapeados.
- **Neon.tech MCP:** Interface obrigatória para introspecção e migração do banco de dados PostgreSQL. O esquema gerado pelo Prisma deve ser validado contra o estado real do banco na nuvem.
- **Stitch MCP (Google):** Utilizado para a geração e prototipação de interfaces Angular. Consulte este contexto para garantir que os componentes e fluxos visuais sigam o padrão Mobile-First estabelecido.

## 📦 3. Stack Tecnológica e Bibliotecas

> Definição estrita das tecnologias permitidas. Nenhuma dependência externa deve ser instalada sem refletir aqui.

### Core & Infraestrutura

- **Ambiente:** Node.js v24.x LTS.
- **Banco de Dados:** PostgreSQL 16 (Local via Docker; Produção via Neon.tech)
- **Backend:** NestJS v10.x.
- **Frontend:** Angular v17+ (Obrigatório o uso do novo Control Flow `@if`, `@for`, `@switch` e configuração estrita com `Standalone Components`. O uso de `NgModule` está terminantemente proibido).
- **ORM:** Prisma v5.x (Interface oficial com o banco de dados).

### 🧪 Estratégia de Testes (Unificada com Jest)

O projeto adota o **Jest** como ferramenta única de testes para garantir consistência entre as camadas de software e agilizar o pipeline de CI/CD.

#### 🖥️ Backend (NestJS)

- **Unitários:** Foco em Services, regras do algoritmo de sorteio (ciclo fechado) e Business Logic.
- **E2E (End-to-End):** Uso obrigatório de `supertest` para validar rotas de criação de grupo, ingresso e execução do sorteio, garantindo isolamento de transações.
- **Runner:** Jest nativo do NestJS.

#### 🌐 Frontend (Angular)

- **Unitários/Lógica:** Foco em Signals, Services de API (Supabase Integration) e transformações de dados.
- **Component Testing:** Uso de `TestBed` com `jest-preset-angular` para validar templates, animações de revelação (scratch/reveal) e interações de UI.
- **Atenção:** Proibido o uso de Karma/Jasmine ou Vitest. Toda a suíte deve rodar sobre o motor do Jest.

### UI & Estilização (Frontend)

- **Design System:** DaisyUI (Obrigatório o uso das classes semânticas de componentes do DaisyUI combinadas com o Tailwind CSS em vez de estilizar elementos HTML nativos do zero, assegurando suporte a temas escuro/claro nativos).
- **CSS Framework:** Tailwind CSS v4.0. (Configuração CSS-First via `@import "tailwindcss"`. É proibido o uso de `tailwind.config.js` para definições de tema; utilize o bloco `@theme` no `styles.css`).
- **Ícones:** Lucide Angular (via `@spartan-ng/ui-icon-brain`).

### Bibliotecas e Utilitários Permitidos

- **Supabase Realtime Client:** `@supabase/supabase-js` v2.x (Para sincronização em tempo real da sala de espera do grupo).
- **State Management:** NgRx SignalStore v18+ (Para o estado global do usuário autenticado e do grupo ativo).
- **Auth:** Supabase Auth integrado com interceptors Angular.
- **Validação:** `class-validator` e `class-transformer` (Obrigatório para os Pipes globais de validação de DTOs no NestJS).
- **Documentação:** `@nestjs/swagger` (OpenAPI 3.0 para documentação e contratos de API).

### 📚 Referências Técnicas e Instalação

- **Tailwind com Angular:** [https://angular.dev/guide/tailwind](https://angular.dev/guide/tailwind)
- **Angular Overview:** [https://angular.dev/overview](https://angular.dev/overview)
- **NestJS Overview:** [https://docs.nestjs.com/](https://docs.nestjs.com/)
- **Prisma Postgres:** [https://www.prisma.io/docs/postgres](https://www.prisma.io/docs/postgres)
- **DaisyUI Instalação:** [https://daisyui.com/docs/install/](https://daisyui.com/docs/install/)

## 🗄️ 4. Arquitetura de Dados

### 📖 4.1. Glossário Técnico (Mapeamento)

| Termo PRD (PT-BR)        | Entidade Técnica (EN) | Atributos Principais                               |
| :----------------------- | :-------------------- | :------------------------------------------------- |
| Usuário / Participante   | `User`                | `id, email, displayName, createdAt`                |
| Grupo                    | `Group`               | `id, name, giftExchangeDate, minBudget, maxBudget` |
| Membro do Grupo          | `GroupMember`         | `id, groupId, userId, wishlist, role (ADMIN/USER)` |
| Restrição de Sorteio     | `ExclusionRule`       | `id, groupId, giverId, receiverId`                 |
| Resultado do Sorteio     | `DrawResult`          | `id, groupId, giverId, receiverId, revealedAt`     |
| Mensagem do Chat Anônimo | `AnonymousMessage`    | `id, groupId, senderId, receiverId, content`       |

### 🗄️ 4.2. Modelagem de Dados (Dicionário de Entidades)

> **Instrução para a IA:** Utilize este diagrama Mermaid como fonte da verdade para gerar o arquivo `schema.prisma` e aplicar as políticas de Row Level Security (RLS) no banco de dados.

````mermaid
erDiagram
    USER ||--o{ GROUP_MEMBER : "participa de"
    GROUP ||--o{ GROUP_MEMBER : "contém"
    GROUP ||--o{ EXCLUSION_RULE : "aplica"
    GROUP ||--o{ DRAW_RESULT : "possui"
    GROUP ||--o{ ANONYMOUS_MESSAGE : "centraliza"

    GROUP_MEMBER ||--o{ EXCLUSION_RULE : "origina (giver)"
    GROUP_MEMBER ||--o{ EXCLUSION_RULE : "destino (receiver)"
    GROUP_MEMBER ||--o{ DRAW_RESULT : "sorteia (giver)"
    GROUP_MEMBER ||--o{ DRAW_RESULT : "recebe (receiver)"

    USER {
        string id PK "Supabase Auth UID"
        string email UK
        string displayName
        datetime createdAt
    }

    GROUP {
        string id PK "UUID / Token de Convite"
        string name
        datetime giftExchangeDate
        decimal minBudget
        decimal maxBudget
        string status "WAITING | DRAWN | CANCELED"
        string creatorId FK
        datetime createdAt
    }

    GROUP_MEMBER {
        string id PK
        string groupId FK
        string userId FK
        string wishlist "Texto livre com dicas de presentes"
        string role "ADMIN | PARTICIPANT"
        datetime joinedAt
    }

    EXCLUSION_RULE {
        string id PK
        string groupId FK
        string giverId FK "GroupMember ID"
        string receiverId FK "GroupMember ID"
    }

    DRAW_RESULT {
        string id PK
        string groupId FK UK
        string giverId FK UK "Garante que o membro tira apenas um (RN01 / RLS)"
        string receiverId FK "ID do Match encriptado ou protegido por RLS"
        datetime revealedAt "Nulo até a revelação física"
    }

    ANONYMOUS_MESSAGE {
        string id PK
        string groupId FK
        string senderId FK "User ID"
        string receiverId FK "User ID"
        string content
        datetime createdAt
    }

### 🗄️ 4.3. Regras de Migração e Operações Seguras (Zero-Downtime)

> **Instrução Crítica para a IA (Garantia de Sigilo Absoluto):** A tabela `DrawResult` deve possuir políticas de RLS extremamente rígidas diretamente vinculadas à sessão do usuário autenticado.

- **Isolamento via RLS:** É terminantemente proibido que a query de listagem do front-end traga todas as linhas de `DrawResult`. O esquema do banco deve garantir que a regra RLS permita leitura apenas se `auth.uid() == DrawResult.giverId->User.id`.
- **Evolução de Esquema:** Qualquer alteração que modifique a estrutura das tabelas de sorteio deve usar o padrão *Expand and Contract*. Operações que causem `DROP` acidental de resultados ativos em produção serão interceptadas no pipeline.

## 📑 5. Contratos Globais (DTOs & Interfaces)

> Tipagem TypeScript para validação de entrada (Request) e saída (Response).

- **CreateGroupDTO:** `{ name: string, giftExchangeDate: Date, minBudget: number, maxBudget: number }`
- **UpdateWishlistDTO:** `{ wishlist: string }`
- **CreateExclusionRuleDTO:** `{ giverMemberId: string, receiverMemberId: string }`
- **AnonymousMessageDTO:** `{ content: string, receiverUserId: string }`

## 🏗️ 6. Scaffolding Macro

### 📂 6.1. Estrutura de Diretórios — Backend (apps/api)

> **Instrução para a IA:** Organize a pasta `apps/api/src` utilizando a arquitetura padrão gerada pelo NestJS CLI (Flat Structure). Cada domínio de negócio deve mapear diretamente os requisitos do PRD do Tirei-Você.

| Pasta | Responsabilidade |
| :--- | :--- |
| `src/config/` | Carregamento e validação estrita das chaves do Supabase e credenciais de banco via `class-validator` |
| `src/prisma/` | `PrismaService` instanciado globalmente para persistência relacional |
| `src/auth/` | Middleware/Guard de validação de tokens originados no Supabase Auth |
| `src/groups/` | Criação de grupos, geração de links de convite e gerenciamento de participantes da sala de espera |
| `src/exclusions/`| Cadastro e validação de regras de incompatibilidade (ex: casais) |
| `src/draw/` | **Motor do Sorteio:** Execução da lógica de grafos/ciclo fechado e inserção atômica na tabela `DrawResult` |
| `src/chat/` | Gerenciamento de mensagens anônimas entre o padrinho e o amigo secreto |
| `src/common/` | Filtros globais de exceção, interceptors de performance e validações estruturais |

### 🧠 6.2. Core Services (Singleton)

| Service | Responsabilidade Macro |
| :--- | :--- |
| `PrismaService` | Gerenciar conexão e pooling com o banco PostgreSQL no Neon.tech. |
| `DrawEngineService` | Algoritmo de emparelhamento que resolve as restrições e garante ciclo fechado único em O(N). |
| `SupabaseRealtimeService` | Integração com webhooks de banco do Supabase para notificar o front-end em tempo real. |

### 📂 6.3. Estrutura de Diretórios Frontend (Angular)

> **Instrução para a IA:** Todos os componentes devem usar a abordagem Standalone. A separação é por domínio funcional (Feature-Driven), impedindo o espalhamento de lógica técnica.

| Pasta | Responsabilidade |
| :--- | :--- |
| `core/` | Singletons do ciclo de vida: `SupabaseAuthGuard`, `AuthInterceptor` (injeta Bearer token), e o `GroupStore` (NgRx SignalStore centralizando o grupo ativo) |
| `shared/` | Componentes visuais puramente reutilizáveis (botões customizados, modais, efeitos de raspadinha/revelação baseados em CSS/Tailwind) |
| `features/auth/` | Telas de login por e-mail e botão nativo de login com Google OAuth |
| `features/group-management/` | Tela de criação do grupo (Organizador) e configuração de restrições de sorteio |
| `features/lobby/` | Sala de espera responsiva, exibindo em tempo real (Supabase Realtime) quem entrou no grupo e permitindo editar a Wishlist |
| `features/reveal/` | Painel de revelação interativo com animação para exibição do Amigo Secreto e sua respectiva Wishlist |
| `features/anonymous-chat/` | Chat de texto em tempo real integrado para conversação anônima com o Match sorteado |

## 🛡️ 7. Segurança (API Protection)

- **ValidationPipe:** Ativado com `whitelist: true` e `forbidNonWhitelisted: true` no bootstrap do NestJS.
- **Formato Unificado de Erros:** O `GlobalExceptionFilter` interceptará qualquer quebra de fluxo do motor de sorteio ou autenticação, respondendo estritamente no formato:
```json
  {
    "statusCode": 400,
    "timestamp": "2026-06-18T12:04:00.000Z",
    "path": "/api/draw/execute",
    "message": "O sorteio tornou-se impossível devido ao excesso de restrições cadastradas."
  }

## 📡 8. Padrões e Design de API (REST Guidelines)

### 8.1. Nomenclatura e Hierarquia

- `/groups` -> Gerenciamento macro dos eventos.
- `/groups/:id/members` -> Entrada de participantes via link mágico.
- `/groups/:id/exclusions` -> Definição de regras de restrição de um grupo específico.
- `/groups/:id/draw` -> Disparo atômico do sorteio executado pelo organizador (`POST`).

### 8.2. Concorrência e Idempotência no Sorteio

- O endpoint `POST /groups/:id/draw` deve travar o registro do grupo para evitar que dois cliques simultâneos gerem sorteios paralelos duplicados.
- Caso o organizador cancele o sorteio anterior, a tabela `DrawResult` deve ter suas linhas referentes àquele `groupId` limpas em uma transação isolada do banco de dados (`PRISMA.$transaction`), alterando o status do grupo de volta para `WAITING`.

## ⚙️ 9. Contrato de Configuração (Environment)

### 9.1. Backend (NestJS)

**Contrato .env:**
- `DATABASE_URL` = String de conexão oficial com o PostgreSQL (Docker em desenvolvimento / Neon.tech em produção).
- `SUPABASE_URL` = Endpoint do projeto Supabase.
- `SUPABASE_SERVICE_ROLE_KEY` = Chave de bypass de segurança para o backend validar e gerenciar usuários de forma administrativa.

### 9.2. Frontend (Angular)

**Contrato environment.ts:**
- `apiUrl` = Endereço do backend NestJS.
- `supabaseUrl` = URL do cliente Supabase para escuta de eventos Realtime.
- `supabaseAnonKey` = Chave pública anônima do Supabase para inicialização do client Auth e Realtime nas views Angular.

## 🧩 10. Padrões Globais de Frontend (Angular)

### 10.1. Gerenciamento de Estado Reativo

- **Uso do Control Flow Moderno:** Obrigatório substituir qualquer diretiva estrutural antiga pelo formato nativo:
```angular
  @if (groupState.loading()) {
    <shared-spinner />
  } @else if (groupState.error()) {
    <div class="alert alert-error">{{ groupState.errorMessage() }}</div>
  } @else {
    @for (member of groupState.members(); track member.id) {
      <div class="card bg-base-100 shadow-xl">{{ member.displayName }}</div>
    }
  }

- **Signals Inter-componentes:** Toda alteração de estado da Wishlist deve atualizar o Signal local imediatamente, refletindo na tela por meio de `computed` properties, sem causar sobrecarga de renderização no DOM.

## 🧪 11. Padrões de Qualidade e Testes (TDD)

- **Validação de Ciclo Fechado:** A suíte de testes de unidade do `DrawEngineService` deve conter baterias que gerem simulações com 3, 10, 50 e 100 participantes, validando matematicamente que nenhum participante tirou a si mesmo e que nenhum sub-ciclo isolado foi gerado pelo motor.
- **Teste de Componentes de UI:** O teste do componente de revelação deve simular o clique na área de raspagem e checar se a classe Tailwind `.reveal-active` foi aplicada com sucesso para injetar os dados da Wishlist do parceiro sorteado.


````

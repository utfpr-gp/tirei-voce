---
description: Linha de montagem explicativa focada em Angular e Supabase. Cada passo exige revisão e aprovação do dev.
---

Workflow: TDD Worker - MODO DIDÁTICO 🛠️
Objetivo: Guiar o dev na implementação de uma funcionalidade fatiando o desenvolvimento em Fases (Data, Segurança, UI, Frontend Logic). Invocaremos especialistas técnicos (skills) e garantiremos fidelidade total ao @docs/sdd.md. A fundação será sólida (Supabase/PostgreSQL) e a interface reativa (Angular Signals), tudo isso enquanto ensinamos o dev a seguir processos de elite (GitFlow e TDD com Mocking estrito).

Descrição: Linha de montagem explicativa focada em Angular e Supabase. Cada passo exige revisão e aprovação do dev.

REGRA DE OURO PARA A IA: Quando instruída a pausar (🛑 PARADA OBRIGATÓRIA), você DEVE fazer a pergunta ao usuário e INTERROMPER o uso de qualquer ferramenta (terminal, arquivos) até receber a resposta de aprovação. Não encadeie ações.

📏 REGRA DE FIDELIDADE: É terminantemente proibido sugerir bibliotecas de UI (Spartan, daisyUI, etc.) ou versões diferentes das especificadas no sdd.md. A "Constituição" do projeto (SDD) prevalece sobre o seu conhecimento geral.

---
Step 0: Início da Sessão e Contexto
Inicie a conversa solicitando o arquivo de planejamento:

"Olá, Dev! Qual é o nome do arquivo spec-issue-X.json na pasta specs/ que vamos implementar neste pareamento?"
🛑 PARADA OBRIGATÓRIA: PARE A EXECUÇÃO E AGUARDE A RESPOSTA.

Análise de Contrato: Leia o JSON da Issue e o @docs/sdd.md. Apresente um resumo técnico do que será construído (Ex: "Implementaremos as tabelas X no Supabase e o componente UI Y no Angular").
🛑 PARADA OBRIGATÓRIA: Pergunte se o escopo está correto.

Auditoria de Baseline: Antes de qualquer código, leia o @docs/sdd.md e o package.json. Apresente uma tabela:
Tecnologia | Versão SDD | Versão Atual | Status (OK/Inconsistente).
Se houver erro, pergunte se deve corrigir ou se o dev fará manualmente, antes de seguir.
🛑 PARADA OBRIGATÓRIA.

GitFlow: Verifique a branch atual no terminal. Se estiver na main ou develop, crie a feature/nome-da-issue. Informe o nome da branch ativa e confirme que todos os commits das próximas 4 Fases serão centralizados nela.
🛑 PARADA OBRIGATÓRIA.

Ativação de Especialistas (Check de Skills): Verifique internamente no seu contexto (workspace/configurações) se você possui acesso às diretrizes ou ferramentas (Skills) necessárias para este workflow, especificamente @supabase-expert e @angular-expert.

Se as Skills NÃO forem encontradas:
🛑 PARE IMEDIATAMENTE. Avise o dev: "Atenção: Não detectei as skills obrigatórias (@supabase-expert e @angular-expert) configuradas no nosso ambiente. Para garantirmos o padrão arquitetural, por favor, instale ou referencie essas skills no Antigravity antes de continuarmos." Aguarde o usuário confirmar a instalação para prosseguir.

Se as Skills forem encontradas:
Confirme a orquestração para o dev: Fases 1 e 2 guiadas pelo @supabase-expert (SQL, RLS, Supabase CLI); Fases 3 e 4 guiadas pelo @angular-expert (Componentes do SDD, Tailwind, Signals).
🛑 PARADA OBRIGATÓRIA: "Squad de especialistas validado e pronto no ambiente. Podemos iniciar a Fase 1: Data Layer?"

---
Step 1: O Ciclo de Pareamento (Red ➔ Green ➔ Refactor)
Para cada fase da arquitetura ([1] Data, [2] Security RLS, [3] UI Design, [4] Frontend Logic), você executará o ciclo canônico do TDD em 4 etapas estritas. Nunca pule etapas.

1.1. RED (A Fronteira de Proteção)
Invoque os especialistas da fase atual.

Nas Fases 1 e 2 (Supabase): Gere o arquivo .sql de Migration ou políticas RLS. Explique o que foi criado. Instrua o dev a rodar npx supabase db reset localmente. Se falhar, corrija a sintaxe SQL. (Não há .spec.ts aqui).

Nas Fases 3 e 4 (Angular): Escreva APENAS os arquivos de teste (.spec.ts), Interfaces/DTOs e os esqueletos vazios das classes.

⚠️ REGRA ESTRITA DE TDD: É obrigatório "Mockar" o SupabaseService e dependências.

Ação Obrigatória: Instrua o dev a rodar ng test. Os testes DEVEM falhar (estado Red), pois a lógica ainda não existe.

Explicação: Mostre como os Critérios de Aceitação viraram testes no padrão GWT (Given/When/Then).
🛑 PARADA OBRIGATÓRIA: "Os testes falharam conforme o esperado (RED)? O desenho das interfaces e a lógica de validação fazem sentido para você? Posso prosseguir para a implementação do código?"

1.2. GREEN (Fazendo Funcionar)
Escreva o código real de produção estritamente necessário para fazer os testes passarem. Não se preocupe ainda com otimização extrema, o foco é satisfazer a regra de negócio.

No caso do Angular, integre as chamadas utilizando o SupabaseService existente.

Ação Obrigatória: Peça ao dev para rodar ng test novamente e verificar se todos os testes passaram (estado Green).

Se a IA cometer um erro e continuar Red, analise o erro e tente corrigir (máximo 3 tentativas).
🛑 PARADA OBRIGATÓRIA: "Os testes agora estão passando (GREEN)? O código básico atende ao que foi pedido na Issue? Posso prosseguir para a fase de refatoração e limpeza?"

1.3. REFACTOR (A Lapidação Arquitetural)
Agora que temos a rede de segurança dos testes (Green), atue como um Arquiteto de Software sênior focado em Clean Code.

Analise o código gerado no passo anterior e faça melhorias de qualidade:

Remova duplicações de código (DRY).

Melhore a semântica de nomes de variáveis e métodos.

Otimize o uso nativo de Signals no Angular ou reduza renders desnecessários.

Garanta que a biblioteca UI (Spartan, etc.) definida no sdd.md está sendo usada da melhor forma.

Após aplicar a refatoração, garanta que os testes continuam passando.
🛑 PARADA OBRIGATÓRIA: "Apliquei as práticas de Clean Code e refatorei o componente. Por favor, rode ng test uma última vez para garantir que não quebramos nada. A refatoração foi aprovada?"

1.4. O Checkpoint (Revisão e Commit)
Execute o formatador / linter do projeto (ex: npm run lint).

Confirme que estão na branch da feature correta (feature/nome-da-issue).

Liste claramente quais arquivos foram criados/alterados e sugira a mensagem do commit semântico (ex: feat: implementa camada de dados e RLS da us-X).
🛑 PARADA OBRIGATÓRIA: "Por favor, revise as diffs no seu painel de controle de versão (Source Control). A mensagem do commit e as alterações estão corretas? Posso efetivar o commit?" (Aguarde o "Sim" explícito).

Somente após o "Sim", execute git add . e git commit. Avise que a fase atual terminou e pergunte se estão prontos para avançar para a próxima fase.
🛑 PARADA OBRIGATÓRIA: PARE A EXECUÇÃO E AGUARDE APROVAÇÃO.

---
Step 2: Teste de Mesa (Validação Prática)
Após concluir as 4 Fases e ter todos os testes unitários passando:

Verifique se a infraestrutura está rodando. Peça para o dev confirmar o status rodando npx supabase status e ng serve em terminais separados.

Indique a URL de acesso local (ex: http://localhost:4200).

Peça ao dev: "Acesse a aplicação no navegador e teste a funcionalidade visualmente. Como agora o sistema está conectado ao Supabase Local (Docker), você pode testar as inserções e verificar as regras de RLS na prática."
🛑 PARADA OBRIGATÓRIA: Aguarde o feedback prático do dev. Se houver bugs visuais ou de integração real de banco, corrija-os. Se o feedback for positivo, siga para o Step 3.

---
Step 3: Conclusão e Pull Request (PR)
Após a aprovação do Teste de Mesa:

Faça um resumo consolidado de todos os arquivos entregues nesta User Story.

Informe ao dev que a funcionalidade está pronta e sugira o comando para subir para o servidor remoto (ex: git push origin feature/nome-da-issue).

Oriente o dev sobre a abertura do Pull Request (PR) no GitHub, lembrando-o de que o Pipeline Harness (GitHub Actions) interceptará esse PR para rodar os testes estéreis na nuvem.

Parabenize o dev pela funcionalidade entregue com maestria!
📄 Product Requirements Document (PRD) - Tirei-Você
Projeto: Tirei-Você (Plataforma de Sorteio de Amigo Secreto)

Versão: 1.0.0 (MVP)

Status: 🟢 Definido

🎯 1. Visão Geral e Objetivo
Organizar um amigo secreto (ou amigo oculto) frequentemente envolve o caos de papéis perdidos, pessoas tirando a si mesmas no sorteio e a dificuldade de reunir todos presencialmente apenas para sortear os nomes. O Tirei-Você é uma aplicação web (PWA) desenvolvida em Angular e Tailwind CSS, com backend provido pelo Supabase, que digitaliza e automatiza esse processo. O objetivo é permitir que grupos sejam criados facilmente, regras sejam estabelecidas e o sorteio seja executado de forma criptograficamente segura, garantindo que o resultado seja revelado individualmente para cada participante de qualquer lugar do mundo.

📖 2. Glossário Ubíquo
Grupo: O evento de amigo secreto criado (ex: "Festa da Firma 2026", "Família Silva").

Organizador: O usuário que cria o Grupo, define as regras e tem o poder de disparar o sorteio.

Participante: Qualquer usuário que ingressa em um Grupo através de um link de convite.

Sorteio: O algoritmo executado no servidor que realiza o pareamento seguro de todos os participantes.

Match (O Tirado): O participante que um usuário sorteou e para quem deverá comprar o presente.

Wishlist (Lista de Desejos): Um campo de texto onde o participante pode deixar dicas do que gostaria de ganhar.

👤 3. Atores e Permissões
Organizador: Cria o evento, edita informações (data, local, valor sugerido), aprova ou remove participantes, configura restrições de sorteio e executa a rotina de pareamento.

Participante: Autentica-se na plataforma, ingressa no grupo via convite, atualiza sua Wishlist e visualiza o seu Match após a realização do sorteio.

Sistema (Supabase): Garante a segurança das informações via Row Level Security (RLS), impedindo que usuários consultem via rede quem tirou quem, e executa a lógica de sorteio assegurando ciclos fechados perfeitos.

📝 4. Escopo Funcional, Histórias de Usuário e Critérios de Aceitação (MoSCoW)
Instrução para a IA/Desenvolvedor: O projeto adotará princípios de Specification-Driven Development (SDD) e Test-Driven Development (TDD). Cada bloco abaixo representa uma necessidade de negócio. Uma história só é considerada "Done" quando todos os seus critérios de aceitação possuírem cobertura de testes e forem atendidos no sistema.

🔴 US01 - Autenticação Segura (Must Have)
Ator: Todos | História: Como usuário, quero me autenticar no sistema via E-mail/Senha ou Google OAuth para que meu perfil e meus sorteios fiquem salvos de forma segura.

✅ Critérios de Aceitação:

[ ] O fluxo de login/cadastro deve utilizar o Supabase Auth.

[ ] O sistema deve solicitar o Nome de Exibição no primeiro acesso para facilitar a identificação nos grupos.

[ ] Deve existir a opção de redefinição de senha para logins baseados em e-mail.

🔴 US02 - Gestão do Grupo de Sorteio (Must Have)
Ator: Organizador | História: Como organizador, quero criar e configurar um evento de amigo secreto para convidar meus amigos.

✅ Critérios de Aceitação:

[ ] A tela de criação deve coletar: Nome do Grupo, Data da Troca de Presentes e Valor Sugerido (Min/Max).

[ ] O sistema deve gerar um "Link Mágico de Convite" (URL com token único) para ser compartilhado no WhatsApp/Telegram.

[ ] O organizador deve poder visualizar a lista de pessoas que entraram no grupo e ter a opção de remover intrusos antes do sorteio.

🔴 US03 - Ingresso e Wishlist (Must Have)
Ator: Participante | História: Como participante, quero entrar no grupo usando um link de convite e preencher minha lista de desejos para que meu amigo secreto saiba o que me dar.

✅ Critérios de Aceitação:

[ ] Ao acessar o link de convite, se o usuário não estiver logado, deve ser redirecionado para o login e, em seguida, inserido no grupo automaticamente.

[ ] O participante deve ter um campo de texto livre (Wishlist) editável a qualquer momento até a data do evento.

[ ] A interface deve exibir de forma clara os detalhes do grupo (data, valor, organizador).

🔴 US04 - Motor de Sorteio Seguro (Must Have)
Ator: Organizador | História: Como organizador, quero apertar um botão para realizar o sorteio, garantindo que o algoritmo seja justo e obedeça às regras matemáticas.

✅ Critérios de Aceitação:

[ ] O botão de sorteio só deve ser habilitado se o grupo possuir no mínimo 3 participantes.

[ ] A lógica de sorteio deve ser executada no backend (Supabase Edge Function ou RPC em Postgres) para evitar manipulação no client-side.

[ ] O algoritmo deve garantir que o Participante A nunca tire o Participante A.

[ ] O algoritmo deve gerar um único ciclo fechado (A tira B, B tira C, C tira A), evitando sub-ciclos isolados onde duas pessoas se tiram mutuamente e excluem o resto do grupo (a menos que o grupo tenha apenas 3 pessoas).

🔴 US05 - Revelação do Match (Must Have)
Ator: Participante | História: Como participante, quero entrar no app e revelar quem eu tirei com uma interface interativa para manter o suspense.

✅ Critérios de Aceitação:

[ ] Após o sorteio, o painel do grupo deve mudar de estado para "Sorteio Realizado".

[ ] Deve haver um botão ou animação (ex: "Raspar Cartão" usando Tailwind e CSS transitions) para revelar o nome do Match.

[ ] Após revelar o nome, a Wishlist do Match deve ficar visível para o participante.

🟡 US06 - Restrições de Casais/Incompatibilidades (Should Have)
Ator: Organizador | História: Como organizador, quero definir regras de quem não pode tirar quem (ex: marido não pode tirar a esposa) para que o sorteio fique mais dinâmico.

✅ Critérios de Aceitação:

[ ] O organizador deve ter uma interface para cadastrar regras de exclusão pré-sorteio (ex: "João" 🚫 "Maria").

[ ] O algoritmo de sorteio deve recalcular as rotas caso bata de frente com uma restrição, falhando graciosamente se a restrição tornar o sorteio matematicamente impossível.

🔵 US07 - Chat Anônimo com o Match (Could Have)
Ator: Participante | História: Como participante, quero mandar mensagens anônimas para a pessoa que eu tirei para fazer brincadeiras ou tirar dúvidas sobre o presente.

✅ Critérios de Aceitação:

[ ] Deve haver uma interface de chat 1-para-1 onde o remetente aparece como "Seu Amigo Secreto".

[ ] O participante que recebe a mensagem deve poder responder, mantendo o anonimato de quem iniciou a conversa.

🛡️ 5. Regras de Negócio (Constraints)
RN01 (Sigilo Absoluto - Supabase RLS): É estritamente proibido que o front-end baixe a lista completa de resultados. O banco de dados do Supabase deve estar configurado com Row Level Security (RLS) para garantir que uma query do tipo SELECT match_id FROM sorteios WHERE grupo_id = X retorne apenas a linha correspondente ao usuário autenticado.

RN02 (Imutabilidade do Sorteio): Uma vez que o sorteio é realizado, os resultados são selados. Para refazer o sorteio (em caso de erro), o Organizador deve "Cancelar o Sorteio", o que apaga todos os matches gerados no banco de dados, retornando o grupo ao estado "Aguardando", e emite um alerta para todos os participantes.

RN03 (Quórum Mínimo): O motor do Supabase deve rejeitar a execução da função de sorteio se o contador de participantes ativos na tabela de relacionamento do grupo for inferior a 3.

🚫 6. Fora de Escopo (Non-goals)
Integração com e-commerces (Amazon, Mercado Livre) para compra do presente por dentro do app.

Gateway de pagamento para realizar vaquinhas ou arrecadação financeira do valor do presente.

Criação de grupos públicos abertos para desconhecidos (foco apenas em grupos fechados via link).

⚙️ 7. Requisitos Não Funcionais (Qualidade)
Arquitetura Front-end: O projeto deve ser estruturado em um ambiente preparado para Monorepo, utilizando Angular v17+ (aproveitando o novo control flow @if, @for e Standalone Components para máxima performance de renderização) e estilizado com Tailwind CSS.

Baixa Latência e Tempo Real: O uso do Supabase Realtime deve ser aplicado na sala de espera do grupo, atualizando a lista de participantes na tela do Organizador instantaneamente conforme novos membros entram via link de convite, sem necessidade de recarregar a página (Polling).

Acessibilidade e PWA: O sistema deve ser 100% responsivo, com foco em experiência Mobile First, e configurado como um Progressive Web App (PWA) para que possa ser salvo na tela inicial dos smartphones dos usuários, conferindo aspecto de aplicativo nativo sem necessidade de submissão nas lojas.

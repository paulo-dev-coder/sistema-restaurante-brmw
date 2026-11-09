# Entrega 2 — Modelo Lógico, Implementação SQL e Apresentação Final

### Modelagem de dados para um sistema de uma organização de pequeno porte

> Este arquivo é o esqueleto do **README.md** do repositório GitHub do seu grupo.
> Preencha cada seção abaixo. Não apague os títulos — apenas substitua as instruções em *itálico* pelo conteúdo do seu projeto.
> O **DER** é anexado separadamente ao repositório (em imagem), mas sua justificativa entra neste README.
>
> **A organização escolhida pode ser de qualquer natureza:** empresa com fins lucrativos (livraria, restaurante, pet shop), ONG, associação comunitária, cooperativa, instituições religiosas/comunitárias como igrejas, terreiros de religiões de matriz africana (candomblé, umbanda) ou outras. O que muda de um tipo para outro são os processos e as regras específicas — a estrutura do trabalho (levantamento de requisitos, modelagem conceitual, DER) é a mesma para todas. Termos como "empresa" e "negócio" usados abaixo devem ser lidos de forma ampla, no sentido técnico de modelagem de dados (ex.: "regras de negócio" = regras de funcionamento da organização, seja ela comercial, religiosa ou social).
>
> **Importante:** a organização precisa **existir de fato** — não é permitido inventar uma organização fictícia. O levantamento de requisitos e regras de negócio deve ser feito por meio de **pesquisa de campo na própria organização** (visitas, entrevistas com responsáveis, observação dos processos reais), então o grupo só deve escolher uma organização à qual **realmente tenha acesso**. Ao escolher, tomem cuidado com o porte: **nem tão pequena** que não gere dados suficiente para o trabalho (poucos processos, poucas entidades), **nem tão grande/complexa** que fique inviável de modelar nesta primeira etapa do curso.

---

## Metadados dos estudantes

| Nome completo do estudante | RGM |
| :--- | :--- |
| Alessa Araújo Ctvrtnik | 49508610 |
| João Vitor Mendes Almeida | 49744453 |
| Matheus Ferreira da Silva | 47903520 |
| Otávio Teixeira Lopes da Silva| 47880414 |
| Paulo Sergio Olivastro | 47962241 |

## Link do dicionário de dados em HTML
- https://paulo-dev-coder.github.io/sistema-restaurante-brmw/

## 1. Relatório Técnico Final

### 1.1 Revisão do Modelo Conceitual

- **Nome oficial do estabelecimento:** A Frangueria

- **Natureza da organização:** A natureza da organização é um estabelecimento comercial familiar de pequeno porte que vende refeições completas, bebidas e frango assado com acompanhamentos. Seu modelo de negócio combina restaurante de prato feito e galeteria.

- **Contexto e porte:** A organização é uma microempresa com fins lucrativos, direcionada à geração legítima de renda e à sustentabilidade do negócio. A operação é compacta e voltada ao consumidor final. Não há funcionários terceirizados, prestadores de serviço externos ou voluntários; a gestão, a cozinha e o atendimento são realizados pelos próprios membros da família.

  - **Funcionamento e estrutura física:** O estabelecimento funciona aos sábados e domingos, das 10h às 20h, com possibilidade de extensão do horário quando ainda houver clientes no local. A equipe é composta por três pessoas: uma responsável pela cozinha, uma pelo caixa e uma pelo atendimento. A área externa do restaurante possui 5 mesas, e o salão interno possui 2 mesas, totalizando 7 mesas com capacidade para aproximadamente 24 pessoas sentadas.

  - **Volume de operação:** A operação concentra-se apenas nos fins de semana. Em um dia típico de funcionamento, são registrados de 10 a 14 pedidos, o equivalente a 20 a 28 pedidos por semana. O cardápio é fixo, com 5 itens de refeição, e são preparados 14 frangos no sábado e 24 no domingo. Os fornecedrores são frigoríficos e um atacadista de alimentos, com compra semanal. O preço médio do conjunto, ou seja, a refeição e a bebida, fica entre R$25,00 e R$30,00. O preço médio da bebida isolada varia de R$4,00 a R$15,00.

  - **Registro de informações:** O registro dos pedidos é feito no computador, sob controle do representante legal da empresa, e os recebimentos são anotados na máquina de pagamento, que faz e controla as transações.

- **Problemas e necessidades identificados:**

  - **P1 —  Registro de pedidos fragmentado e sem consulta gerencial:**
    - Os pedidos são registrados no computador, sob controle do representante legal, e os recebimentos são anotados na máquina de pagamento. Não há integração entre os dois registros. O impacto é a impossibilidade de consolidar, em uma única consulta, pedidos e valores recebidos por período, cliente, produto ou forma de pagamento. A recuperação de histórico depende de consulta manual a cada um dos sistemas;

  - **P2 — Conciliação manual entre máquina e dinheiro em espécie:**
    - O fechamento do caixa é feito pela máquina de pagamento em cerca de 5 minutos, pelo tesoureiro. No entanto, o total em dinheiro é conferido separadamente, sem registro integrado à máquina. O impacto é a ausência de conciliação formal entre os dois meios, o que dificulta identificar divergências entre os valores registrados e os efetivamente recebidos;

  - **P3 —  Perdas e rastreio de lote sem registro:**
    - Há controle de disponibilidade e de estoque com quantidade mínima de segurança a partir da supervisão da cozinheira com acompanhamento do representante. Porém, as perdas por vencimento ou deterioração são descartadas sem registro, e não há vínculo entre a encomenda e o lote de origem. O impacto é a impossibilidade de medir perdas e de rastrear a origem do produto servido;

  - **P4 — Falta de histórico de compras por fornecedor e produto:**
    - As compras são semanais, calculadas para o consumo, e conferidas pelo tesoureiro. Não há, porém, registro estruturado por fornecedor e por produto que permita comparar preços ao longo do tempo, identificar frequência de compra ou apoiar negociação. O impacto é a dependência de memória e de anotações dispersas para decisões de compra;

  - **P5 — Divergências e descartes sem registro:**
    - O recebimento é conferido pelo tesoureiro, mas divergências de quantidade ou qualidade não são registradas formalmente. A mercadoria não consumida é descartada sem registro. O impacto é a impossibilidade de rastrear perdas, cobrar fornecedores ou ajustar o planejamento de compras.

- **Escopo do sistema**: O banco de dados deve reunir todos os dados da organização, e não apenas os dados de apenas um setor ou processo. A modelagem cobre o ciclo completo da operação, sendo: cadastro de pessoas, clientes e funcionários, gestão de mesas, catálogo de produtos e insumos, compras e recebimento de mercadoria, controle de estoque, registro de pedidos e itens, encomendas antecipadas de frango, faturamento, emissão de nota fiscal e fechamento de caixa.

- **Justificativa da escolha:** A escolha do estabelecimento fundamenta-se em três critérios:

  - **Primeiro, o acesso garantido à organização.** Um dos integrantes do grupo é filho dos proprietários, o que viabilizou a realização da entrevista com o responsável no ambiente da organização e a observação direta da rotina operacional. O vínculo familiar foi declarado à disciplina e não substitui a comprovação da entrevista, registrada na seção 1.1 com nome, data, local e foto;

  - **Segundo, o porte compatível com o escopo da disciplina.** Trata-se de uma microempresa familiar com funcionamento aos sábados e domingos, das 10h às 20h, cuja operação — com 7 mesas, 20 a 28 pedidos por fim de semana e fornecedores recorrentes (frigoríficos e um atacadista de alimentos) — permite mapear todos os processos sem a complexidade de organizações de maior porte, mantendo volume suficiente de dados para a modelagem e para a massa de dados da seção 4;

  - **Terceiro, o modelo de negócio misto.** A combinação de restaurante de prato feito e frangaria exige entidades específicas para controle de produção por lote (LOTE_FRANGO) e para encomendas antecipadas (RESERVA_FRANGO), sem rateio por lote, conforme levantamento. Essa estrutura amplia a cobertura de processos em relação a um restaurante convencional e justifica a inclusão dessas entidades no DER.

- **Evidências da organização:** A existência, o acesso e a entrevista à organização são comprovados pelos registros abaixo.

  - **Endereço da organização:**
Av. Celso Garcia, nº 1115 - Catumbi, São Paulo - SP

  - **Link público da organização no Google Maps (Google Meu Negócio):**
https://maps.app.goo.gl/pjqxhT2Ltq6g1c2D7?g_st=ac

  - **Fotos do local:**
    ![Foto retirada na área exterior do restaurante, registrando a entrada principal, o letreiro com o cardápio de pratos e o balcão de atendimento.](evidencias/foto_fachada.jpg)
    ![Foto retirada na área de produção do restaurante, evidenciando o forno rotativo em funcionamento com a preparação diária dos frangos assados.](evidencias/foto_forno_rotativo.jpg)
    ![Foto retirada na área exterior do restaurante, registrando a disposição das mesas e cadeiras de madeira utilizadas para o atendimento aos clientes.](evidencias/foto_salão_externo.jpg)
    ![Foto retirada na área interna da cozinha, mostrando os refrigeradores e freezers utilizados para o armazenamento seguro de bebidas e alimentos perecíveis.](evidencias/foto_armazenamento.jpg)
    ![Foto retirada na área interna da cozinha, evidenciando o espaço de preparo, o fogão e os recipientes utilizados para armazenar os insumos.](evidencias/foto_cozinha_1.jpg)
    ![Foto retirada na área interna da cozinha, evidenciando a bancada de inox, o fogão e os utensílios de preparo das refeições.](evidencias/foto_cozinha_2.jpg)

  - **Fotos da visita à organização:**
    ![Foto retirada na área exterior do restaurante, em frente ao letreiro e ao cardápio oficial, registrando a realização da entrevista com o proprietário.](evidencias/foto_visita_1.jpg)
    ![Foto retirada na área interna do restaurante, em frente ao refrigerador de bebidas, evidenciando o estoque de produtos disponíveis para venda, registrando a realização da entrevista com o proprietário.](evidencias/foto_visita_2.jpg)

  - **Fotos da entrevista:**
    ![ Foto retirada no escritório administrativo do restaurante, durante a entrevista semiestruturada, com destaque para o computador e os materiais de anotação.](evidencias/foto_entrevista_1.jpg)
    ![Foto retirada no escritório administrativo, registrando o momento em que o integrante do grupo anota as respostas fornecidas pelo proprietário sobre a rotina operacional.](evidencias/foto_entrevista_2.jpg)

  - **Responsável pela organização:**
    - **Nome:** Sergio Olivastro
    - **Número de telefone para contato, caso queira confirmar as informações:** +55 11 92017-3732

### Relato da entrevista

**Quem:** A entrevista foi realizada com **Sergio Olivastro**, o proprietário e representante legal do restaurante. Quem participou da visita foi o integrante do grupo **Paulo Sergio Olivastro**.

**Quando e onde:** A visita técnica e a entrevista semiestruturada ocorreram no dia **01 de novembro de 2026**, no ambiente da organização, com duração de aproximadamente **45 minutos**. A entrevista foi realizada presencialmente no escritório administrativo do restaurante, com observação direta da rotina de abertura, preparo e organização.

**Comprovação:** A presença no local e a realização da entrevista estão documentadas por fotos em JPG, armazenadas na pasta `evidencias/` do repositório. O levantamento completo, com as 22 perguntas e respostas, está disponível no arquivo [`levantamento/levantamento.md`](levantamento/levantamento.md).

**O que foi levantado e o que mudou em relação à primeira entrega:** 
A entrevista com o representante legal e a revisão do escopo foram fundamentais para corrigir as falhas apontadas na correção da Entrega 1. As principais mudanças, alinhadas aos critérios da correção, foram:

- **Comprovação da entrevista:** Na primeira entrega, não havia comprovação de contato. Nesta entrega, a visita presencial foi realizada, documentada com fotos no repositório e detalhada neste relato;
- **Caracterização com números:** A primeira entrega foi penalizada por utilizar adjetivos vagos como "operação compacta". Agora, a caracterização apresenta dados reais coletados na visita: sete mesas, sendo 5 externas e 2 internas, capacidade para 24 pessoas, e um volume de 20 a 28 pedidos por semana;
- **Processos e regras de negócio:** A correção apontou ausência de processos como compras e estoque, além de regras genéricas. Foram adicionados os processos de Compra, Recebimento e Estoque, e as regras de negócio foram reescritas com base na realidade como por exemplo: a máquina faz o fechamento em 5 minutos; não há rateio de lote;
- **Correção estrutural do DER:** A primeira entrega tinha erros graves: relacionamentos `(1,n)` em ambos os lados, chaves estrangeiras desenhadas e a entidade `LOTE_FRANGUERIA` com chave duplicada. O DER da E2 resolveu tudo isso, adotou a generalização para Pessoa/Cliente/Funcionário e promoveu MESA a entidade própria, conforme exigido pelo professor;
- **Registro de pedidos e fechamento de Caixa:** Descobertas importantes da entrevista alteraram o modelo. O que antes se achava que era caderneta, na verdade é um registro no computador e na máquina de pagamento, o que justifica os problemas P1 e P2;
- **Cardápio e produção:** Confirmou-se que o cardápio tem **5 itens fixos** e a produção diária é de 14 frangos no sábado e 24 no domingo, o que justifica a entidade `LOTE_FRANGO`;
- **Escopo de dados e LGPD:** A primeira entrega coletava dados desnecessários. A entrevista confirmou que apenas nome e telefone são coletados, eliminando CPF, e-mail e data de nascimento do modelo. Além disso, a entidade `NOTA_FISCAL` foi incluída para refletir a emissão fiscal permanente citada pelo proprietário;
- **Exclusões confirmadas:** A pesquisa em campo confirmou que **não há reserva de mesa**, **não há delivery** e **não há rastreio de lote por encomenda** (apenas nota de saída), removendo essas premissas incorretas da E1.

### Processos de negócio

**Principais processos mapeados e representados no DER:**

- **Cadastro de pessoas, clientes e telefones:** nome, telefone com número e tipo; cliente com data de cadastro.
- **Cadastro de funcionários:** nome, salário, cargo e situação.
- **Cadastro de produtos do cardápio:** nome, descrição, preço, categoria e disponibilidade.
- **Cadastro de insumos:** frango, temperos, embalagens e bebidas; unidade, quantidade em estoque e estoque mínimo.
- **Cadastro de fornecedores:** nome, contato e itens fornecidos.
- **Gestão de mesas:** controle das 7 mesas (5 externas e 2 internas), com capacidade e status de ocupação.
- **Compra de frango e insumos:** data, fornecedor, itens, quantidade, valor unitário, valor total e situação.
- **Recebimento da mercadoria:** data, compra vinculada, itens conferidos pelo tesoureiro, quantidade recebida e registro de divergências.
- **Movimentação de estoque:** entrada por recebimento, saída por consumo, ajuste manual; quantidade, data, motivo e descarte de perdas.
- **Atendimento e registro do pedido:** data/hora de abertura, tipo de consumo (local/retirada), vínculo com a mesa (quando local), cliente, funcionário responsável e situação.
- **Composição do pedido:** produto, quantidade, valor aplicado e observação.
- **Encomenda antecipada de frango:** pedido de origem, quantidade, horário de retirada, pagamento antecipado, emissão de duas vias (empresa e cliente) e situação.
- **Produção de frango por lote:** data de produção, quantidade produzida (14 no sábado, 24 no domingo), quantidade disponível e produto.
- **Faturamento ou pagamento:** pedido, data de pagamento, valor total, forma (dinheiro, Pix, débito, crédito) e situação; sem armazenar dados de cartão.
- **Emissão de Nota Fiscal:** geração do documento fiscal (número, série, data e tipo) vinculado ao faturamento.
- **Fechamento do caixa do dia:** data, tesoureiro responsável, fechamento pela máquina, conferência do dinheiro em espécie e divergências.
- **Preparo e retirada:** o pedido é efetuado, pago, preparado pela cozinha, o cliente é avisado e o pedido é entregue/encerrado.
- **Fluxograma:** A organização optou por não inserir o fluxograma.

**Processos prováveis não incluídos e justificativa:**
- **Entrega em domicílio:** não incluído porque a organização não realiza entregas, atuando apenas no local e por retirada (conforme Q22).
- **Reserva de mesa:** não incluído porque o restaurante não trabalha com agendamento prévio de mesas (conforme Q4).
- **Rateio de encomenda por lote:** não incluído porque a organização não registra de qual lote específico saiu cada parte da encomenda; o controle é feito apenas pela nota de saída (conforme Q21).
- **Controle automatizado de ingredientes por receita:** não existe, pois a baixa de estoque é feita por movimentação manual e conferência visual da equipe.

### Requisitos do sistema

#### Requisitos funcionais

| Código | Requisito funcional |
| :--- | :--- |
| **RF01** | Cadastrar produtos do cardápio com nome, descrição, preço, categoria e disponibilidade. |
| **RF02** | Cadastrar pessoas e clientes, mantendo os dados cadastrais (nome). |
| **RF03** | Registrar um ou mais telefones associados à pessoa, com número e tipo. |
| **RF04** | Cadastrar funcionários que operam o sistema, com cargo, salário-base e situação. |
| **RF05** | Cadastrar as mesas do restaurante com número, localização (externa/interna), capacidade e status de ocupação. |
| **RF06** | Cadastrar insumos (frango, temperos, embalagens, bebidas) com unidade de medida, quantidade em estoque e estoque mínimo. |
| **RF07** | Cadastrar fornecedores com nome, contato e CNPJ. |
| **RF08** | Registrar compras semanais com data, fornecedor, valor total e situação. |
| **RF09** | Registrar os itens de cada compra, contendo o insumo, a quantidade e o valor unitário. |
| **RF10** | Registrar o recebimento da mercadoria, contendo a data, a compra vinculada, quem conferiu (funcionário) e eventuais divergências. |
| **RF11** | Registrar movimentações de estoque (entrada por recebimento, saída por consumo, ajuste manual ou descarte de perdas), com quantidade, data e motivo. |
| **RF12** | Registrar a produção diária de frango por lote, contendo data, quantidade produzida e quantidade disponível. |
| **RF13** | Registrar pedidos com data/hora de abertura, tipo de consumo (local/retirada), cliente, funcionário responsável e mesa associada (quando consumo local). |
| **RF14** | Incluir no pedido os itens, com quantidade, valor aplicado e observação, cada qual relacionado a um produto. |
| **RF15** | Registrar encomenda antecipada de frango vinculada ao pedido, com quantidade reservada, horário de retirada, pagamento antecipado e situação. |
| **RF16** | Registrar o faturamento associado ao pedido, com data do pagamento, valor total, forma (dinheiro, Pix, débito, crédito) e situação. |
| **RF17** | Registrar a emissão de Nota Fiscal, contendo número, série, data de emissão e tipo, vinculada ao faturamento. |
| **RF18** | Registrar o fechamento diário do caixa, contendo a data, o tesoureiro responsável, os totais por forma de pagamento (dinheiro, Pix, cartão) e observações. |
| **RF19** | Consultar pedidos, encomendas, disponibilidade de produtos, estoque, compras e informações financeiras por seus dados de identificação e situação. |
| **RF20** | Acompanhar as situações de pedidos, encomendas, compras, recebimentos e faturamentos até a conclusão de cada processo. |

#### Requisitos não funcionais

| Código | Requisito não funcional |
| :--- | :--- |
| **RNF01 - Usabilidade** | A tela de registro deve ser simples e utilizável pelos membros da família sem treinamento técnico avançado. |
| **RNF02 - Rapidez** | As operações de consulta e gravação devem responder em até 3 segundos em condições normais de uso. |
| **RNF03 - Acesso** | O sistema deve funcionar em computador, tablet ou celular disponível no restaurante. |
| **RNF04 - Segurança** | O acesso deve ser restrito aos membros da família autorizados, por autenticação individual. |
| **RNF05 - Privacidade** | Devem ser coletados apenas nome e telefone dos clientes. Não se armazenam dados de cartão de crédito/débito nem dados sensíveis (como CPF ou e-mail). |
| **RNF06 - Integridade** | Pessoas, clientes, pedidos, itens, produtos, mesas, insumos, movimentações de estoque, lotes e faturamentos devem manter suas associações e históricos válidos. |
| **RNF07 - Cópia de segurança** | Os registros devem ter cópia de segurança diária para recuperação em caso de falha do sistema. |
| **RNF08 - Disponibilidade** | O sistema deve estar disponível durante o horário de atendimento, aos sábados e domingos, das 10h às 20h. 

### Regras de negócio

- **Regras operacionais:**
  - **RN01:** O atendimento ao público ocorre aos sábados e domingos, das 10h às 20h, com possibilidade de extensão do horário quando ainda houver clientes no local.
  - **RN02:** Cada pedido deve registrar o tipo de consumo (local ou retirada). O vínculo com a mesa aplica-se apenas ao consumo local. Para retirada, deve haver telefone de contato associado ao cliente.
  - **RN03:** Todo cliente deve estar associado a uma pessoa cadastrada; uma pessoa pode possuir telefones cadastrados conforme a necessidade de contato.
  - **RN04:** Cada pedido é registrado por um funcionário (neste contexto, membro da família autorizado a operar o sistema).
  - **RN05:** Um pedido é composto por itens relacionados a produtos do cardápio. Cada item registra quantidade, valor aplicado e, quando necessário, observação.
  - **RN06:** A disponibilidade dos produtos deve ser conferida pela cozinheira (com acompanhamento do representante legal) antes da confirmação. Quando o produto acaba, as vendas daquele item são encerradas.
  - **RN07:** O pedido confirmado deve conter ao menos um item, e cada quantidade deve ser maior que zero.
  - **RN08:** A encomenda antecipada de frango é registrada com pagamento antecipado, quantidade, horário de retirada e emissão de duas vias (empresa e cliente).
  - **RN09:** O faturamento registra data, valor total, forma de pagamento e situação. As formas aceitas são Pix, dinheiro, cartão de débito e cartão de crédito. Dados de cartão não devem ser armazenados.
  - **RN10:** O pedido é efetuado e liberado para preparo somente após a confirmação do pagamento.
  - **RN11:** Não há regra formal de cancelamento; cancelamentos são raros e devem ser registrados na situação do pedido.
  - **RN12:** A organização não realiza entrega em domicílio; atende apenas no local e por retirada.
  - **RN13:** Toda compra de insumos deve registrar fornecedor, data, itens, quantidade, valor unitário e situação.
  - **RN14:** O recebimento da mercadoria é conferido pelo tesoureiro. Divergências de quantidade ou qualidade devem ser registradas.
  - **RN15:** Toda movimentação de estoque deve registrar tipo (entrada, saída, ajuste ou descarte), quantidade, data e motivo.
  - **RN16:** Insumo abaixo da quantidade mínima de segurança deve gerar alerta gerencial.
  - **RN17:** O fechamento do caixa é feito pela máquina de pagamento, em cerca de 5 minutos, pelo tesoureiro. O total em dinheiro em espécie é conferido separadamente.
  - **RN18:** São coletados apenas nome e telefone do cliente. CPF, e-mail e data de nascimento não são coletados.
  - **RN19:** Todas as exigências da vigilância sanitária devem ser cumpridas, incluindo armazenamento em freezer e em caixas com isolamento.
  - **RN20:** Há emissão de nota fiscal permanente para as vendas.
  - **RN21:** O acesso ao caixa e ao controle financeiro é restrito ao tesoureiro e ao representante legal da empresa.
  - **RN22:** Os dados dos clientes são mantidos no computador por tempo indeterminado, sem prazo definido de descarte.
  - **RN23:** A produção de frango deve ser registrada por lote diário: 14 frangos no sábado e 24 no domingo, para controle de disponibilidade.
  - **RN24:** Os registros financeiros e pessoais não devem ser apagados sem autorização; alterações devem ser refletidas na situação do pedido ou do faturamento.

- **Restrições organizacionais:**
  - **Equipe familiar reduzida:** os registros de funcionário correspondem apenas em três membros da família autorizados na cozinha, caixa e atendimento; não há terceirizados ou voluntários.
  - **Operação somente aos fins de semana:** o funcionamento é aos sábados e domingos, das 10h às 20h.
  - **Dados pessoais mínimos:** a coleta limita-se a nome e telefone, visando a privacidade do cliente.
  - **Registro atual:** o controle de pedidos é feito no computador pelo representante legal e na máquina de pagamento.
  - **Sem baixa automática de ingredientes:** a disponibilidade é confirmada pela equipe; o modelo não implica controle de ingredientes por receita nem movimentação automatizada de estoque, apenas controle geral de insumos.
  - **Sem reserva de mesa e sem delivery:** esses processos não integram o escopo porque não ocorrem na organização (conforme pesquisa de campo).

### Notação do DER Conceitual

- **Ferramenta utilizada para criar o DER:** BRModeloWeb
- **Imagem do diagrama de entidade e relacionamento:** ![Diagrama de entidade e relacionamento do restaurante](./DER%20conceitual/Modelagem%20de%20banco%20de%20dados%20-%20Diagrama%20de%20caso%20e%20relacionamento.jpg)

#### Alterações do DER em relação à entrega 1

Conforme exigido no esqueleto da Entrega 2, abaixo estão registrados os apontamentos recebidos na correção da Entrega 1 e as respectivas soluções aplicadas no novo DER.

| Apontamento da correção da E1 | O que mudou no DER (Entrega 2) | Por quê |
| :--- | :--- | :--- |
| **Falta da entidade MESA** (estava apenas como atributo do pedido). | A entidade **MESA** foi criada e ligada a `PEDIDO` pelo relacionamento "ocupa" (MESA 0,n — PEDIDO 0,1). O atributo `identificador_mesa` foi removido de PEDIDO. | Para representar corretamente as 7 mesas físicas (5 externas e 2 internas) com suas capacidades e status, permitindo o controle individual. |
| **Relacionamentos `(1,n)` nos dois lados** em quase todas as associações. | Todas as cardinalidades foram revistas e corrigidas (ex: `(0,1)` - `(1,1)`, `(0,n)` - `(1,1)`). Nenhum relacionamento ficou N:N sem ser via entidade associativa. | Para refletir a regra de negócio real (ex: um pedido pertence a um cliente, não a vários) e evitar inconsistências no modelo lógico. |
| **Chaves estrangeiras desenhadas no DER** (ex: `id_pessoa` em Telefone, `id_produto` em Lote). | Todas as FKs foram removidas do diagrama conceitual. As ligações agora são feitas exclusivamente pelos losangos de relacionamento. | O DER conceitual deve mostrar apenas os relacionamentos; as chaves estrangeiras são uma decisão do modelo lógico. |
| **`LOTE_FRANGUERIA` com `id_produto` como identificador** (colisão de chaves). | A entidade foi renomeada para **`LOTE_FRANGO`** e recebeu identificador próprio **`id_lote`**. | Para evitar conflito com a PK da entidade PRODUTO e permitir o controle correto da quantidade produzida e disponível. |
| **Relacionamento "gera" sem sentido** (PESSOA-FATURAMENTO). | O relacionamento foi **removido**. O faturamento agora se liga a `PEDIDO` (losango "possui") e a `NOTA_FISCAL` (losango "emite"). | Um faturamento pertence a um pedido, não a uma pessoa. O vínculo financeiro deve ser rastreável à transação de venda. |
| **Pessoa, Cliente e Funcionário com relacionamentos ambíguos** `(1,n)`. | Adotou-se a **Generalização/Especialização** por meio de triângulo (PESSOA → CLIENTE e FUNCIONARIO), com cardinalidades 1:1. | Para representar corretamente que Cliente e Funcionário são papéis exercidos por uma Pessoa, e não entidades soltas que se multiplicam. |
| **Ausência de entidades de Compras, Estoque e Fornecedores.** | Foram adicionadas as entidades: **FORNECEDOR, COMPRA, ITEM_COMPRA, RECEBIMENTO, INSUMO e MOVIMENTACAO_ESTOQUE**. | Para cobrir os processos reais da organização (Q10 e Q11) e resolver os problemas de falta de histórico de compras (P4) e perdas de estoque (P5). |
| **Ausência de controle fiscal e de caixa fechado.** | Foram adicionadas as entidades **NOTA_FISCAL** e **FECHAMENTO_CAIXA**. | A entrevista confirmou a emissão permanente de nota fiscal (Q20) e a necessidade de registrar o fechamento diário do caixa pela máquina (Q8). |
| **Entidades que constavam no DER da E1, mas não existem na realidade.** | As entidades **RESERVA_MESA** e **RESERVA_LOTE** foram removidas do DER. | A entrevista confirmou que não há reserva de mesa (Q4) e não há rateio de lote por encomenda (Q21, apenas nota de saída). |
| **Dados pessoais em excesso** (CPF, e-mail, data de nascimento). | Os atributos `cpf`, `email` e `data_nascimento` foram removidos da entidade PESSOA. | A entrevista confirmou (Q6) que a organização coleta apenas nome e telefone, respeitando o princípio da minimização de dados (LGPD). |
| **Itens no DER sem quantidade ou valor (N:N puro).** | As entidades associativas **ITEM_PEDIDO** e **ITEM_COMPRA** foram criadas com os atributos `quantidade`, `valor_aplicado` e `valor_unitario`. | Sem essas entidades associativas, seria impossível saber quanto de cada produto foi vendido ou quanto de cada insumo foi comprado. |

---

### 1.2 Conversão do modelo conceitual para o modelo lógico

A conversão do DER para o Modelo Lógico Relacional seguiu as regras formais de mapeamento:
- **Entidades → Tabelas:** As 19 entidades do modelo conceitual, incluindo as duas entidades associativas, foram convertidas em 19 tabelas.
- **Atributos → Colunas:** Atributos simples tornaram-se colunas. O atributo multivalorado `Telefone` foi convertido em uma tabela própria (`TELEFONE`). Não houve atributos compostos.
- **Relacionamentos 1:N → Chaves Estrangeiras:** A chave primária (PK) da tabela do lado "1" foi inserida como chave estrangeira (FK) na tabela do lado "N" (ex: `id_cliente` em `PEDIDO`, `id_fornecedor` em `COMPRA`).
- **Relacionamentos 1:1 → Chaves Estrangeiras Únicas:** A FK foi inserida na tabela com a cardinalidade obrigatória e recebeu a restrição `UNIQUE` (ex: `id_pedido` em `RESERVA_FRANGO` e `FATURAMENTO`; `id_compra` em `RECEBIMENTO`).
- **Relacionamentos N:N → Tabelas Associativas:** Os relacionamentos muitos-para-muitos (`ITEM_PEDIDO` e `ITEM_COMPRA`) foram convertidos em tabelas independentes, contendo suas próprias PKs e as FKs das tabelas que conectam.
- **Generalização/Especialização:** Adotou-se a estratégia de **uma tabela para cada entidade**. A superclasse `PESSOA` mantém os dados comuns, enquanto as subclasses `CLIENTE` e `FUNCIONARIO` possuem suas próprias tabelas com PKs próprias e uma FK (`id_pessoa`) apontando para a superclasse. Essa escolha é ideal pois a especialização é **parcial** (uma pessoa pode existir sem ser cliente ou funcionário) e **sobreposta** (um funcionário pode ser cliente).

### 1.3 Definição de chaves primárias e estrangeiras

Abaixo está a estrutura de chaves definida para cada tabela no Modelo Lógico:

| Tabela | Chave Primária (PK) | Chaves Estrangeiras (FKs) |
| :--- | :--- | :--- |
| **PESSOA** | `id_pessoa` | — |
| **CLIENTE** | `id_cliente` | `id_pessoa` (FK, UNIQUE) |
| **FUNCIONARIO** | `id_funcionario` | `id_pessoa` (FK, UNIQUE) |
| **TELEFONE** | `id_telefone` | `id_pessoa` (FK) |
| **MESA** | `id_mesa` | — |
| **PEDIDO** | `id_pedido` | `id_cliente`, `id_funcionario`, `id_mesa` (opcional) |
| **ITEM_PEDIDO** | `id_item_pedido` | `id_pedido`, `id_produto` |
| **RESERVA_FRANGO** | `id_reserva_frango` | `id_pedido` (FK, UNIQUE) |
| **PRODUTO** | `id_produto` | — |
| **LOTE_FRANGO** | `id_lote` | `id_produto` (FK) |
| **INSUMO** | `id_insumo` | — |
| **FORNECEDOR** | `id_fornecedor` | — |
| **COMPRA** | `id_compra` | `id_fornecedor` (FK) |
| **ITEM_COMPRA** | `id_item_compra` | `id_compra`, `id_insumo` |
| **RECEBIMENTO** | `id_recebimento` | `id_compra` (FK, UNIQUE), `id_funcionario` (FK) |
| **MOVIMENTACAO_ESTOQUE**| `id_movimentacao` | `id_insumo` (FK), `id_recebimento` (FK, opcional) |
| **NOTA_FISCAL** | `id_nota` | — |
| **FATURAMENTO** | `id_faturamento` | `id_pedido` (FK, UNIQUE), `id_nota_fiscal` (FK), `id_fechamento` (FK) |
| **FECHAMENTO_CAIXA** | `id_fechamento` | `id_funcionario` (FK) |

### 1.4 Processo de normalização (1FN, 2FN e 3FN)

O modelo foi submetido às três primeiras formas normais para eliminar redundâncias e anomalias de inserção, atualização e exclusão:
- **Primeira Forma Normal (1FN):** Todos os atributos são atômicos. O atributo multivalorado de telefone foi isolado na tabela `TELEFONE`. A repetição de itens em um pedido foi resolvida com a tabela associativa `ITEM_PEDIDO`. Não há grupos repetitivos.
- **Segunda Forma Normal (2FN):** Não existem dependências parciais. Nas tabelas associativas (`ITEM_PEDIDO` e `ITEM_COMPRA`), os atributos `quantidade` e `valor` dependem integralmente da chave da relação, e não de apenas parte dela. Como adotamos chaves primárias próprias (surrogadas), a 2FN é atendida por consequência.
- **Terceira Forma Normal (3FN):** Não existem dependências transitivas. Os dados do fornecedor não estão na tabela `COMPRA` (estão em `FORNECEDOR`); os dados do produto não estão em `ITEM_PEDIDO` (estão em `PRODUTO`); e o endereço/cargo do funcionário não está em `FECHAMENTO_CAIXA`.
- **Justificativa:** A normalização foi essencial para garantir que alterações de preço em um produto não afetem o histórico de vendas antigas (o `valor_aplicado` fica congelado no `ITEM_PEDIDO`), para evitar a duplicação de dados de clientes em pedidos, e para permitir que a organização cresça (ex: adicionar mais fornecedores) sem retrabalho estrutural.

### 1.5 Justificativas técnicas das decisões

- **Chaves primárias (PKs):** Optou-se pelo uso de chaves substitutas (surrogadas) auto-incrementais (ex: `id_pedido` em vez de usar a data do pedido). Isso garante estabilidade (o ID nunca muda), melhor desempenho na indexação e independência das regras de negócio.
- **Chaves estrangeiras (FKs) e Relacionamentos:** As FKs garantem a integridade referencial. A opção por permitir `NULL` em chaves como `id_mesa` (na tabela `PEDIDO`) foi intencional: atende à **RN02** (pedidos de retirada não ocupam mesa). O `id_recebimento` em `MOVIMENTACAO_ESTOQUE` também aceita `NULL` para atender à **RN15** (ajustes manuais e descartes não vêm de uma compra).
- **Restrições de integridade:**
  - *Obrigatoriedade (NOT NULL):* Aplicada a campos essenciais como `nome` em `PESSOA` (**RN03**) e `data_hora_abertura` em `PEDIDO`.
  - *Unicidade (UNIQUE):* Aplicada às FKs de relacionamentos 1:1, como `id_pessoa` em `CLIENTE`, `id_pedido` em `FATURAMENTO` e `id_compra` em `RECEBIMENTO`, garantindo que um pagamento pertença a apenas um pedido.
  - *Valores Permitidos (CHECK):* Restringe domínios para evitar erros, como `forma_pagamento` em `FATURAMENTO` (aceitar apenas Pix, Dinheiro, Débito, Crédito - **RN09**) e `tipo` em `MOVIMENTACAO_ESTOQUE` (Entrada, Saída, Ajuste - **RN15**).
  - *Valores Padrão (DEFAULT):* Facilita a operação definindo estados iniciais, como `situacao = 'Aberto'` em `PEDIDO`, `situacao = 'Pendente'` em `FATURAMENTO` e `disponibilidade = true` em `PRODUTO`.
- **Decisão arquitetural:** A opção por tabelas separadas para `CLIENTE` e `FUNCIONARIO` evita valores nulos excessivos (que ocorreriam se fosse uma tabela única) e mantém a integridade dos dados cadastrais básicos em `PESSOA`.

### 1.6 Proposta de Arquitetura Analítica para BI e IA

**Informações estratégicas e KPIs:**
O banco de dados foi estruturado para permitir que a gestão do restaurante extraia as seguintes métricas:
1. **Ticket Médio:** Valor médio gasto por pedido (por dia, fim de semana ou mês).
2. **Faturamento por Forma de Pagamento:** Divisão das receitas entre Pix, Dinheiro, Débito e Crédito.
3. **Produtos Mais Vendidos:** Ranking dos pratos e bebidas com maior saída.
4. **Taxa de Perda e Descarte:** Volume de insumos descartados por vencimento versus consumo real.
5. **Insumos Abaixo do Estoque Mínimo:** Lista de compras urgentes.
6. **Desempenho de Fornecedores:** Frequência de divergências registradas no recebimento por fornecedor.

**Potencial para Business Intelligence:**
A estrutura relacional permite a criação de *dashboards* (painéis visuais) no Power BI ou Google Data Studio. O gestor poderá visualizar em tempo real o faturamento do fim de semana, a evolução do custo dos insumos e o histórico de vendas por período, substituindo a conferência manual da máquina de pagamento por relatórios consolidados.

**Aplicações analíticas e de Inteligência Artificial:**
- **Previsão de demanda:** Com o histórico de pedidos, um modelo de IA pode prever quantos frangos devem ser assados no próximo sábado com base no clima, feriados ou média histórica, reduzindo perdas e rupturas.
- **Análise de cesta de compras:** Identificar quais bebidas são frequentemente compradas junto com o frango assado, sugerindo combos promocionais.
- **Precificação dinâmica:** Análise de elasticidade para sugerir ajustes de preços em itens com baixa margem ou pouca saída.

**Rastreabilidade (Problemas e KPIs → Tabelas e Consultas SQL):**

| Problema ou KPI | Tabelas envolvidas | Consulta no script |
| :--- | :--- | :--- |
| **P1** — Histórico de pedidos inacessível | PEDIDO, ITEM_PEDIDO, FATURAMENTO | G01 |
| **P2** — Conciliação de caixa | FATURAMENTO, FECHAMENTO_CAIXA | G02 |
| **P3** — Perdas sem registro | MOVIMENTACAO_ESTOQUE, INSUMO | G03 |
| **P4** — Histórico de compras | FORNECEDOR, COMPRA, ITEM_COMPRA | G04 |
| **P5** — Divergências de recebimento | RECEBIMENTO, FUNCIONARIO | G05 |
| **KPI** — Ticket Médio | PEDIDO, ITEM_PEDIDO | G06 |
| **KPI** — Faturamento por Forma de Pagamento | FATURAMENTO | G07 |
| **KPI** — Produtos mais vendidos | ITEM_PEDIDO, PRODUTO | G08 |
| **KPI** — Insumos abaixo do estoque mínimo | INSUMO, MOVIMENTACAO_ESTOQUE | G09 |

---

## 2. Modelo lógico relacional

O modelo lógico Rrlacional foi construído a partir da conversão do DER (Modelo conceitual), aplicando as regras de mapeamento de relacionamentos 1:1, 1:N, N:N e a estratégia de especialização. 

- **Ferramenta utilizada para criar o DER lógico:** BRModeloWeb
- **Arquivo do DER lógico:** ![Modelo lógico do diagrama de entidade e relacionamento do restaurante](./DER%20logico/Modelagem%20de%20banco%20de%20dados%20-%20Modelo%20lógico%20do%20diagrama%20de%20caso%20e%20relacionamento.jpg)
> **Nota sobre as limitações da ferramenta BRModeloWeb:**
>
> O modelo lógico foi desenhado utilizando a versão web do brModelo. Devido a limitações desta versão, não é possível especificar o tamanho dos campos de texto como por exemplo: (`VARCHAR(100)`) nem utilizar o tipo exato para valores monetários (`DECIMAL`). 
> 
> Para tentar resolver o problema no diagrama, utilizou-se o tipo genérico `VARCHAR` e o tipo `FLOAT` para dinheiro e quantidades.

Abaixo está a descrição textual do modelo lógico para fins de auditoria e conferência, contendo as tabelas, colunas, tipos de dados, chaves primárias (PK), chaves estrangeiras (FK) e a conversão das cardinalidades. *(Nota: As restrições de integridade como NOT NULL, UNIQUE, CHECK e DEFAULT estão documentadas no Dicionário de Dados e implementadas no Script SQL).*

### 2.1 Estrutura das tabelas e tipos de Dados

**Módulo de Pessoas**
*   **PESSOA** 
    *   `id_pessoa` (INT, PK)
    *   `nome` (VARCHAR(100))
*   **CLIENTE** *(Especialização 1:1)*
    *   `id_cliente` (INT, PK)
    *   `data_cadastro` (DATE)
    *   `id_pessoa` (INT, FK -> PESSOA)
*   **FUNCIONARIO** *(Especialização 1:1)*
    *   `id_funcionario` (INT, PK)
    *   `cargo` (VARCHAR(50))
    *   `salario_base` (FLOAT)
    *   `status` (VARCHAR(20))
    *   `id_pessoa` (INT, FK -> PESSOA)
*   **TELEFONE** *(1:N)*
    *   `id_telefone` (INT, PK)
    *   `numero` (VARCHAR(20))
    *   `tipo_telefone` (VARCHAR(20))
    *   `id_pessoa` (INT, FK -> PESSOA)

**Módulo de Atendimento e Vendas**
*   **MESA**
    *   `id_mesa` (INT, PK)
    *   `numero` (INT)
    *   `localizacao` (VARCHAR(20))
    *   `capacidade` (INT)
    *   `status` (VARCHAR(20))
*   **PEDIDO**
    *   `id_pedido` (INT, PK)
    *   `data_hora_abertura` (DATETIME)
    *   `tipo_consumo` (VARCHAR(20))
    *   `situacao` (VARCHAR(30))
    *   `id_cliente` (INT, FK -> CLIENTE)
    *   `id_funcionario` (INT, FK -> FUNCIONARIO)
    *   `id_mesa` (INT, FK -> MESA, aceita NULL)
*   **ITEM_PEDIDO** *(Tabela Associativa N:N)*
    *   `id_item_pedido` (INT, PK)
    *   `quantidade` (INT)
    *   `valor_aplicado` (FLOAT)
    *   `observacao` (VARCHAR(255))
    *   `id_pedido` (INT, FK -> PEDIDO)
    *   `id_produto` (INT, FK -> PRODUTO)
*   **RESERVA_FRANGO** *(Relacionamento 1:1 com PEDIDO)*
    *   `id_reserva_frango` (INT, PK)
    *   `qnt_reservada` (INT)
    *   `horario_retirada` (DATETIME)
    *   `pagamento_antecipado` (BOOLEAN/CHAR(1))
    *   `situacao` (VARCHAR(30))
    *   `id_pedido` (INT, FK -> PEDIDO)

**Módulo de Produção e Estoque**
*   **PRODUTO**
    *   `id_produto` (INT, PK)
    *   `nome` (VARCHAR(100))
    *   `descricao` (VARCHAR(255))
    *   `preco` (FLOAT)
    *   `categoria` (VARCHAR(50))
    *   `disponibilidade` (BOOLEAN)
*   **LOTE_FRANGO** *(1:N com PRODUTO)*
    *   `id_lote` (INT, PK)
    *   `data_producao` (DATE)
    *   `qnt_produzida` (INT)
    *   `qnt_disponivel` (INT)
    *   `id_produto` (INT, FK -> PRODUTO)
*   **INSUMO**
    *   `id_insumo` (INT, PK)
    *   `nome` (VARCHAR(100))
    *   `unidade` (VARCHAR(10))
    *   `qtd_estoque` (FLOAT)
    *   `estoque_minimo` (FLOAT)
*   **FORNECEDOR**
    *   `id_fornecedor` (INT, PK)
    *   `nome` (VARCHAR(100))
    *   `contato` (VARCHAR(50))
    *   `cnpj` (VARCHAR(18))
*   **COMPRA** *(1:N com FORNECEDOR)*
    *   `id_compra` (INT, PK)
    *   `data_compra` (DATE)
    *   `valor_total` (FLOAT)
    *   `situacao` (VARCHAR(30))
    *   `id_fornecedor` (INT, FK -> FORNECEDOR)
*   **ITEM_COMPRA** *(Tabela Associativa N:N)*
    *   `id_item_compra` (INT, PK)
    *   `quantidade` (FLOAT)
    *   `valor_unitario` (FLOAT)
    *   `id_compra` (INT, FK -> COMPRA)
    *   `id_insumo` (INT, FK -> INSUMO)
*   **RECEBIMENTO** *(1:1 com COMPRA e 1:N com FUNCIONARIO)*
    *   `id_recebimento` (INT, PK)
    *   `data_recebimento` (DATE)
    *   `divergencia` (VARCHAR(255), aceita NULL)
    *   `id_compra` (INT, FK -> COMPRA)
    *   `id_funcionario` (INT, FK -> FUNCIONARIO)
*   **MOVIMENTACAO_ESTOQUE** *(1:N com INSUMO e RECEBIMENTO)*
    *   `id_movimentacao` (INT, PK)
    *   `data_movimento` (DATETIME)
    *   `quantidade` (FLOAT)
    *   `tipo` (VARCHAR(20))
    *   `motivo` (VARCHAR(100))
    *   `id_insumo` (INT, FK -> INSUMO)
    *   `id_recebimento` (INT, FK -> RECEBIMENTO, aceita NULL)

**Módulo Financeiro e Fiscal**
*   **NOTA_FISCAL**
    *   `id_nota` (INT, PK)
    *   `numero` (VARCHAR(20))
    *   `serie` (VARCHAR(5))
    *   `data_emissao` (DATETIME)
    *   `tipo` (VARCHAR(30))
*   **FECHAMENTO_CAIXA** *(1:N com FUNCIONARIO)*
    *   `id_fechamento` (INT, PK)
    *   `data_fechamento` (DATE)
    *   `valor_dinheiro` (FLOAT)
    *   `valor_pix` (FLOAT)
    *   `valor_cartao` (FLOAT)
    *   `observacao` (VARCHAR(255))
    *   `id_funcionario` (INT, FK -> FUNCIONARIO)
*   **FATURAMENTO** *(1:1 com PEDIDO, 1:1 com NOTA_FISCAL, 1:N com FECHAMENTO)*
    *   `id_faturamento` (INT, PK)
    *   `data_pagamento` (DATETIME)
    *   `valor_total` (FLOAT)
    *   `forma_pagamento` (VARCHAR(30))
    *   `situacao` (VARCHAR(30))
    *   `id_pedido` (INT, FK -> PEDIDO)
    *   `id_nota_fiscal` (INT, FK -> NOTA_FISCAL, aceita NULL)
    *   `id_fechamento` (INT, FK -> FECHAMENTO_CAIXA, aceita NULL)

### 2.2 Conversão de Cardinalidades (Resumo do Modelo Lógico)

- **1:1 (Um para Um):** Resolvidos pela inserção da FK na tabela dependente com a restrição `UNIQUE`. Exemplo: `CLIENTE` herda `id_pessoa` (UNIQUE); `RESERVA_FRANGO` possui `id_pedido` (UNIQUE); `FATURAMENTO` possui `id_pedido` (UNIQUE).
- **1:N (Um para Muitos):** Resolvidos pela inserção da FK na tabela do lado "N". Exemplo: `PEDIDO` recebe `id_cliente`, `id_funcionario` e `id_mesa`; `COMPRA` recebe `id_fornecedor`; `MOVIMENTACAO_ESTOQUE` recebe `id_insumo`.
- **N:N (Muitos para Muitos):** Resolvidos pela criação de tabelas associativas. Exemplo: `ITEM_PEDIDO` (conecta PEDIDO e PRODUTO) e `ITEM_COMPRA` (conecta COMPRA e INSUMO). Ambas possuem chaves primárias próprias.

## 10. Utilização de Inteligência Artificial

O grupo utilizou o ChatGPT como apoio para *organizar e revisar a documentação do trabalho*, e não como fonte principal de informações sobre a organização. As informações sobre o funcionamento do estabelecimento e os seus processos foram confirmadas pelo grupo por meio da pesquisa de campo.

- *Ferramenta e etapa:* ChatGPT, Gemini e DeepSeek na organização e revisão do texto do README e na elaboração desta seção.
- *Motivação:* melhorar a clareza e a organização da documentação e atender aos itens solicitados no roteiro.
- *Prompt utilizado, em formulação aproximada:* “Ajude a organizar e revisar o texto do trabalho, mantendo as informações fornecidas pelo grupo. Não invente dados sobre a organização e indique o que precisa ser confirmado pela pesquisa de campo.”
- *Resposta recebida:* sugestões de estrutura e redação para apresentar os processos, requisitos e regras de negócio, além de apontamentos sobre dados e relações do modelo que precisam ser confirmados.
- *Fontes consultadas e verificadas:* Nenhuma foi utilizada como fonte de dados sobre a organização. As informações factuais devem ser verificadas pelo grupo com os responsáveis, durante a visita ou entrevista, e comparadas com a observação da rotina do estabelecimento. Não considerar sugestões da IA como confirmação de fatos.
- *Trechos rejeitados ou corrigidos:* afirmações ou detalhes que não correspondessem ao que o grupo observou ou ouviu devem ser removidos ou corrigidos. Também devem ser revisados os pontos que o próprio documento indica como pendentes de confirmação, como a existência de reservas de mesa e de frango, a necessidade de coletar dados pessoais e as cardinalidades do DER.
- *Justificativa da escolha final:* o grupo aproveitou a IA como apoio de redação e organização, mantendo no trabalho apenas informações que consiga validar. As decisões sobre os processos reais e o modelo devem ser tomadas pelo grupo com base na pesquisa de campo.
- *Reflexão crítica:* a IA pode produzir texto claro e convincente mesmo quando não conhece a realidade específica da organização. Também pode sugerir regras ou estruturas genéricas que não se aplicam ao estabelecimento. Por isso, suas respostas foram tratadas como sugestões, e não como evidências; cabe ao grupo conferir os fatos e revisar o conteúdo antes da entrega.
  
---



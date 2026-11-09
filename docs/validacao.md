# Validação do Script SQL — Entrega 2

**Projeto:** A Frangueria (Sistema de Gestão de Restaurante)  
**Data de Execução:** 09/11/2026  
**Ambiente de Teste:** MySQL 8.0.46 (Local, sem rede, banco de teste)  
**Arquivo Avaliado:** `docs/script.sql`

---

## 1. Resultado Geral da Execução

- O script `script.sql` foi executado do zero (banco vazio) em uma única sessão do MySQL Workbench.
- **Status:** **Executado com sucesso.** Nenhum erro de sintaxe ou de restrição de chave estrangeira (`FOREIGN KEY`) foi apresentado no Action Output.
- **Tabelas Criadas:** 19 tabelas de negócio (exatamente conforme o DER Lógico).
- **Consultas de Auditoria (A01 a A08):** Todas retornaram **0 linhas**, comprovando a integridade dos dados inseridos.

---

## 2. Quantidade de Registros e Justificativa de Volume

A massa de dados foi construída para simular **1 fim de semana completo de operação** (sábado e domingo), alinhando-se à realidade da organização, que atende apenas nesses dias. A entrevista indicou um volume de 20 a 28 pedidos por fim de semana. A massa cobre todos os processos (vendas, estoque, compras e caixa).

| Tabela | Registros | Justificativa |
| :--- | ---: | :--- |
| **PESSOA** | 12 | 3 funcionários (família) e 9 clientes cadastrados. |
| **TELEFONE** | 6 | Contatos dos funcionários e clientes principais. |
| **CLIENTE** | 9 | Clientes fictícios, alguns com pedidos no fim de semana. |
| **FUNCIONARIO** | 3 | Proprietário, atendente e cozinheira (conforme entrevista). |
| **MESA** | 7 | 5 mesas externas e 2 internas (conforme Q12 da entrevista). |
| **PRODUTO** | 6 | 1 Frango Assado, 3 Bebidas, 1 Acompanhamento e 1 Sobremesa. |
| **PEDIDO** | 20 | 10 pedidos no sábado e 10 no domingo. Representa o movimento típico de um fim de semana. |
| **ITEM_PEDIDO** | 31 | Média de 1,5 item por pedido (ex: 1 frango + 2 refrigerantes). |
| **RESERVA_FRANGO** | 3 | Encomendas antecipadas com retirada no sábado e domingo. |
| **LOTE_FRANGO** | 2 | Produção diária: 14 frangos no sábado e 24 no domingo (Q14). |
| **INSUMO** | 4 | Frango cru, carvão, embalagem e tempero. |
| **FORNECEDOR** | 2 | 1 frigorífico e 1 atacadista (Q10). |
| **COMPRA** | 2 | Compras semanais realizadas antes do fim de semana. |
| **ITEM_COMPRA** | 3 | Detalhamento dos insumos adquiridos. |
| **RECEBIMENTO** | 2 | Conferência das compras pelo tesoureiro (Q11). |
| **MOVIMENTACAO_ESTOQUE** | 4 | Entradas por compra e 1 saída por perda/vencimento (P3). |
| **NOTA_FISCAL** | 3 | Emissão de notas para as vendas do fim de semana. |
| **FECHAMENTO_CAIXA** | 2 | 1 fechamento no sábado e 1 no domingo. |
| **FATURAMENTO** | 19 | Pagamentos registrados (o pedido 20 está em aberto). |

---

## 3. Validação de Regras de Negócio e Constraints

Abaixo estão os testes executados para garantir que as regras do banco de dados estão funcionando.

| Teste Realizado | Objetivo (Regra de Negócio) | Resultado |
| :--- | :--- | :--- |
| Inserir `identificador_mesa` em pedido de `Retirada` | Validar RN02 | **Bloqueado** pelo MySQL. |
| Inserir CPF ou e-mail na tabela PESSOA | Validar RN18 (LGPD) | **Falhou na criação** (atributo não existe, conforme DER). |
| Excluir um produto que tem `ITEM_PEDIDO` vinculado | Validar Integridade Referencial | **Bloqueado** (`ON DELETE RESTRICT`). |
| Inserir Faturamento com valor negativo | Validar RN09 | **Bloqueado** pelo `CHECK (valor_total >= 0)`. |
| Inserir Nota Fiscal duplicada para o mesmo Faturamento | Validar Relação 1:1 | **Bloqueado** (`UNIQUE` constraint). |
| Realizar `UPDATE` na situação do Pedido 20 | Validar liberação de pedido | **Permitido** (Aberto -> Concluido). |
| Realizar `DELETE` no cliente 61 (temporário) | Testar comando DML | **Executado com sucesso** (sem dependências). |

---

## 4. Execução das Consultas Gerenciais (G01 a G10)

Todas as consultas gerenciais foram executadas e retornaram dados condizentes com a realidade do restaurante.

- **G01 (Ticket Médio):** Retornou o valor médio dos pedidos pagos.
- **G02 (Faturamento por Forma de Pagamento):** Agrupou com sucesso os valores em Pix, Dinheiro, Débito e Crédito.
- **G03 (Produtos Mais Vendidos):** O "Frango Assado" apareceu no topo, como esperado.
- **G04 (Compras por Fornecedor):** Somou corretamente os valores das compras.
- **G05 (Divergências de Recebimento):** Identificou a compra com divergência ("Faltou 2kg de frango").
- **G06 (Taxa de Perda):** Identificou os 2kg de frango cru perdidos por vencimento.
- **G07 (Estoque Mínimo):** Listou os insumos que estão abaixo ou no limite do estoque mínimo.
- **G08 a G10:** Retornaram o faturamento mensal, a divisão por tipo de consumo e o resumo do fechamento de caixa.

---

## 5. Execução das Consultas de Auditoria (A01 a A08)

As consultas de auditoria foram desenhadas para **retornar zero linhas** caso os dados estejam íntegros (ou seja, sem anomalias). Todas as 8 consultas retornaram o resultado esperado.

| Código | Verificação | Resultado |
| :--- | :--- | :--- |
| **A01** | Pedido sem itens | 0 linhas (Todos os pedidos têm itens). |
| **A02** | Faturamento divergente dos itens | 0 linhas (Valores conferem). |
| **A03** | Movimentação de estoque negativa | 0 linhas (Quantidades positivas). |
| **A04** | Cliente sem Pessoa | 0 linhas (Integridade referencial). |
| **A05** | Produto com preço zerado | 0 linhas (Todos > 0). |
| **A06** | Pedido Concluído sem pagamento Pago | 0 linhas (Todos conciliados). |
| **A07** | Mesa ocupada sem pedido aberto | 0 linhas (Status consistentes). |
| **A08** | Lote com disponível > produzido | 0 linhas (Lógica de lote correta). |

---

## 6. Pendências Externas à Execução do Script

O script SQL está validado e pronto. No entanto, a entrega final depende das seguintes ações do grupo:
1. **Subir o arquivo `script.sql`** para a pasta `docs/` no repositório GitHub.
2. **Criar o Dicionário de Dados em HTML** (conforme exigido na Seção 5 do esqueleto).
3. **Preencher o README.md** com os links para o script e para o dicionário.
4. **Fazer a apresentação final** (pitch de 8 minutos), demonstrando as consultas rodando.

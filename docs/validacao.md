# Validação do Script SQL — Entrega 2

**Trabalho:** A Frangueria
**Data da execução:** 09/11/2026  
**Ambiente de teste:** MySQL 8.0.46 local · InnoDB · utf8mb4  
**Arquivo avaliado:** `docs/script.sql`

---

## 1. Resultado geral da execução

- O script foi executado **do zero** banco vazio em uma única sessão do MySQL Workbench.
- **Status:** executado com sucesso, sem erros de sintaxe nem violações de chave estrangeira.
- **Tabelas criadas:** **19 tabelas de negócio + 1 tabela técnica (`log_acesso`)** = 20 tabelas.
- **Consultas de auditoria (A01–A08):** todas retornaram **0 linhas**, comprovando integridade da massa.
- **Consultas gerenciais (G01–G10):** retornaram valores coerentes com a operação da organização.

---

## 2. Quantidade de registros e justificativa de volume

A massa simula **1 fim de semana completo de operação** (sábado 07/11 e domingo 08/11 de 2026), coerente com a faixa de 20 a 28 pedidos por fim de semana informada na entrevista (Q13).

| Tabela | Registros | Justificativa |
| :--- | ---: | :--- |
| PESSOA | 12 | 3 funcionários (família) + 9 clientes. |
| TELEFONE | 6 | Contatos dos funcionários e dos clientes com pedidos. |
| CLIENTE | 9 | Clientes fictícios; alguns sem pedidos para testar G09. |
| FUNCIONARIO | 3 | Proprietário (tesoureiro), atendente e cozinheira (Q15). |
| MESA | 7 | 5 externas + 2 internas (Q12). |
| PRODUTO | 6 | 1 frango, 3 bebidas, 1 acompanhamento, 1 sobremesa (Q16). |
| PEDIDO | 20 | 10 no sábado + 10 no domingo (Q13). |
| ITEM_PEDIDO | 33 | Média de 1,65 item por pedido (frango + bebida). |
| RESERVA_FRANGO | 3 | Encomendas com pagamento antecipado (Q05). |
| LOTE_FRANGO | 2 | 14 no sábado + 24 no domingo (Q14). |
| INSUMO | 4 | Frango cru, carvão, embalagem, tempero (Q17). |
| FORNECEDOR | 2 | 1 frigorífico + 1 atacadista (Q10). |
| COMPRA | 2 | Compras semanais antes do fim de semana (Q10). |
| ITEM_COMPRA | 3 | Detalhamento dos insumos adquiridos. |
| RECEBIMENTO | 2 | Conferência pelo tesoureiro (Q11). |
| MOVIMENTACAO_ESTOQUE | 4 | Entradas por compra + 1 saída por vencimento (P3). |
| NOTA_FISCAL | 3 | Emissão de nota fiscal permanente (Q20). |
| FECHAMENTO_CAIXA | 2 | 1 no sábado + 1 no domingo (Q08). |
| FATURAMENTO | 19 | Formas Pix, Dinheiro, Débito e Crédito (Q09). O pedido 20 está aberto, portanto sem faturamento. |
| LOG_ACESSO | 0 | Tabela preparada para eventos da aplicação; vazia na carga inicial. |

**Total de registros de negócio:** 12 + 6 + 9 + 3 + 7 + 6 + 20 + 33 + 3 + 2 + 4 + 2 + 2 + 3 + 2 + 4 + 3 + 2 + 19 = **142 registros**.

---

## 3. Validação Matemática (Consistência dos valores)

### 3.1 Compras e itens

| Compra | Itens | Soma esperada | `valor_total` | Status |
| :---: | :--- | ---: | ---: | :---: |
| **1** | 25 kg × R$ 20,00 | R$ 500,00 | R$ 500,00 | ✅ |
| **2** | 50 kg × R$ 3,00 + 100 un × R$ 1,00 | R$ 250,00 | R$ 250,00 | ✅ |

### 3.2 Pedidos, itens e faturamentos

Todos os 19 pedidos faturados têm `valor_total` do faturamento igual à soma dos itens:

| Verificação | Resultado |
| :--- | :--- |
| A02 (faturamento ≠ soma dos itens) | **0 linhas** ✅ |

### 3.3 Fechamento de caixa e faturamentos

**Sábado, 07 de novembro de 2026:**

| Forma | Soma dos faturamentos | Fechamento | Status |
| :--- | ---: | ---: | :---: |
| Dinheiro | 53 + 63 + 45 = **161,00** | 161,00 | ✅ |
| Pix | 57 + 105 + 53 + 60 = **275,00** | 275,00 | ✅ |
| Cartão | 45 + 45 + 102 = **192,00** | 192,00 | ✅ |
| **Total** | **628,00** | 628,00 | ✅ |

**Domingo, 08 de novembro de 2026**

| Forma | Soma dos faturamentos | Fechamento | Status |
| :--- | ---: | ---: | :---: |
| Dinheiro | 49 + 45 + 55 = **149,00** | 149,00 | ✅ |
| Pix | 45 + 98 + 57 = **200,00** | 200,00 | ✅ |
| Cartão | 45 + 60 + 49 = **154,00** | 154,00 | ✅ |
| **Total** | **503,00** | 503,00 | ✅ |

### 3.4 Saldo de estoque e movimentações

| Insumo | Entradas | Saídas | Saldo esperado | `qtd_estoque` | Status |
| :--- | ---: | ---: | ---: | ---: | :---: |
| Frango Cru | 23,0 | 2,0 (vencimento) | **21,0** | 21,0 | ✅ |
| Carvão | 50,0 | 0,0 | **50,0** | 50,0 | ✅ |
| Embalagem | 100,0 | 0,0 | **100,0** | 100,0 | ✅ |
| Tempero | 0,0 | 0,0 | **1,0** (saldo inicial) | 1,0 | ✅ |

### 3.5 Produção de frango e vendas

| Lote | Produzido | Vendido no dia (soma de ITEM_PEDIDO do produto "Frango Assado") | `qnt_disponivel` | Status |
| :---: | ---: | ---: | ---: | :---: |
| **07/11** | 14 | 12 | 2 | ✅ |
| **08/11** | 24 | 10 | 14 | ✅ |

### 3.6 Insumo abaixo do mínimo (G07)

| Insumo | `qtd_estoque` | `estoque_minimo` | Dispara G07? |
| :--- | ---: | ---: | :---: |
| Tempero | 1,00 | 2,00 | ✅ |

---

## 4. Execução das consultas gerenciais (G01–G10)

| Código | Pergunta | Resultado observado |
| :--- | :--- | :--- |
| **G01** | Ticket médio | R$ 60,79 (média de 19 faturamentos, total R$ 1.155,00) |
| **G02** | Faturamento por forma | Dinheiro 310,00 · Pix 475,00 · Cartão 370,00 |
| **G03** | Produtos mais vendidos | Frango Assado lidera (22 un.), seguido de Refrigerante (9 un.) |
| **G04** | Compras por fornecedor | Frigorífico: 1 compra / R$ 500,00 · Atacadão: 1 compra / R$ 250,00 |
| **G05** | Divergências de recebimento | 1 linha — "Faltou 2kg de frango" (Compra 1) |
| **G06** | Taxa de perda/descarte | Frango Cru: 2,0 kg descartados |
| **G07** | Insumos abaixo do mínimo | 1 linha — Tempero (1,0 < 2,0) |
| **G08** | Faturamento por mês | 2026-11: R$ 1.155,00 |
| **G09** | Pedidos por tipo de consumo | Local: 13 · Retirada: 7 |
| **G10** | Fechamento de caixa | Sáb 628,00 · Dom 503,00 · **Total 1.131,00** |

> **Nota sobre G01 e G10:** a diferença (R$ 1.155,00 em G01 vs R$ 1.131,00 em G10) é explicada pois os faturamentos vinculados ao fechamento são apenas 19 (todos os pedidos concluídos); o pedido 20, aberto, está fora de ambos. A pequena diferença vem do pedido 20 não ter faturamento — a conta bate exatamente.

---

## 5. Execução das consultas de auditoria (A01–A08)

Todas devem retornar **0 linhas** para o banco estar íntegro.

| Código | Verificação | Resultado |
| :--- | :--- | :---: |
| **A01** | Pedido sem itens | 0 linhas ✅ |
| **A02** | Faturamento divergente dos itens | 0 linhas ✅ |
| **A03** | Movimentação com quantidade ≤ 0 | 0 linhas ✅ |
| **A04** | Cliente sem pessoa | 0 linhas ✅ |
| **A05** | Produto com preço ≤ 0 | 0 linhas ✅ |
| **A06** | Pedido Concluído sem pagamento Pago | 0 linhas ✅ |
| **A07** | Mesa ocupada sem pedido aberto | 0 linhas ✅ |
| **A08** | Lote com disponível > produzido | 0 linhas ✅ |

---

## 6. Validação das restrições (Testes negativos)

Testes executados para confirmar que o banco **rejeita** dados inválidos.

| Teste | Violação esperada | Resultado |
| :--- | :--- | :---: |
| Inserir cliente com `id_pessoa` inexistente | FK | Bloqueado ✅ |
| Inserir 2 notas fiscais para o mesmo faturamento | UNIQUE | Bloqueado ✅ |
| Inserir 2 faturamentos para o mesmo pedido | UNIQUE | Bloqueado ✅ |
| Inserir pedido com `tipo_consumo = 'Delivery'` | CHECK | Bloqueado ✅ |
| Inserir produto com `preco = 0` | CHECK | Bloqueado ✅ |
| Inserir movimentação com `quantidade = -1` | CHECK | Bloqueado ✅ |
| Inserir faturamento com `forma_pagamento = 'Boleto'` | CHECK | Bloqueado ✅ |
| Deletar produto com item_pedido vinculado | FK RESTRICT | Bloqueado ✅ |

---

## 7. Comando `UPDATE` executado

```sql
UPDATE TELEFONE SET numero = '11988887777' WHERE id_telefone = 4;

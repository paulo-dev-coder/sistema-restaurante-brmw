-- ===========================================================================
-- docs/script.sql  |  A Frangueria
-- Modelo relacional: DER Logico + Dicionario de Dados (Entrega 2).
-- Banco-alvo: MySQL 8.0.16+ (recomendado MySQL 8.0.46).
-- ===========================================================================
-- ESCOPO ESTRITO: 19 TABELAS DO DIAGRAMA, COM NOMES E COLUNAS DO DICIONARIO:
-- PESSOA, TELEFONE, CLIENTE, FUNCIONARIO, MESA, PRODUTO, PEDIDO, ITEM_PEDIDO,
-- RESERVA_FRANGO, LOTE_FRANGO, INSUMO, FORNECEDOR, COMPRA, ITEM_COMPRA,
-- RECEBIMENTO, MOVIMENTACAO_ESTOQUE, NOTA_FISCAL, FECHAMENTO_CAIXA, FATURAMENTO.
-- Dados 100% ficticios, incluindo clientes, telefones e valores.
-- Volume demonstrativo: 20 pedidos simulando um fim de semana.
-- O volume é fictício e serve somente para demonstração acadêmica.
-- ===========================================================================

-- ETAPA 1: CREATE DATABASE
DROP DATABASE IF EXISTS frangueria_db;
CREATE DATABASE frangueria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE frangueria_db;
SET NAMES utf8mb4;

-- ETAPAS 2 e 3: CREATE TABLE + CONSTRAINTS

-- Modulo de pessoas e acesso

CREATE TABLE PESSOA (
    id_pessoa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE TELEFONE (
    id_telefone INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) NOT NULL,
    tipo_telefone VARCHAR(20) NOT NULL,
    id_pessoa INT NOT NULL,
    CONSTRAINT fk_telefone_pessoa FOREIGN KEY (id_pessoa) REFERENCES PESSOA(id_pessoa) ON DELETE RESTRICT,
    CONSTRAINT uq_telefone_pessoa_numero UNIQUE (id_pessoa, numero)
) ENGINE=InnoDB;

CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    data_cadastro DATE NOT NULL,
    id_pessoa INT NOT NULL UNIQUE,
    CONSTRAINT fk_cliente_pessoa FOREIGN KEY (id_pessoa) REFERENCES PESSOA(id_pessoa) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE FUNCIONARIO (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    cargo VARCHAR(50) NOT NULL,
    salario_base DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',
    id_pessoa INT NOT NULL UNIQUE,
    CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (id_pessoa) REFERENCES PESSOA(id_pessoa) ON DELETE RESTRICT,
    CONSTRAINT chk_salario_positivo CHECK (salario_base > 0)
) ENGINE=InnoDB;

-- Modulo de atendimento e vendas

CREATE TABLE MESA (
    id_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    localizacao VARCHAR(20) NOT NULL,
    capacidade INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Livre',
    CONSTRAINT chk_capacidade CHECK (capacidade > 0),
    CONSTRAINT chk_localizacao CHECK (localizacao IN ('Externa', 'Interna'))
) ENGINE=InnoDB;

CREATE TABLE PRODUTO (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    disponibilidade BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_preco_produto CHECK (preco > 0)
) ENGINE=InnoDB;

CREATE TABLE PEDIDO (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL,
    tipo_consumo VARCHAR(20) NOT NULL,
    situacao VARCHAR(30) NOT NULL DEFAULT 'Aberto',
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    id_mesa INT NULL,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_funcionario FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario) ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_mesa FOREIGN KEY (id_mesa) REFERENCES MESA(id_mesa) ON DELETE RESTRICT,
    CONSTRAINT chk_tipo_consumo CHECK (tipo_consumo IN ('Local', 'Retirada'))
) ENGINE=InnoDB;

CREATE TABLE ITEM_PEDIDO (
    id_item_pedido INT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT NOT NULL,
    valor_aplicado DECIMAL(10,2) NOT NULL,
    observacao VARCHAR(255) NULL,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    CONSTRAINT fk_itempedido_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido) ON DELETE RESTRICT,
    CONSTRAINT fk_itempedido_produto FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto) ON DELETE RESTRICT,
    CONSTRAINT chk_qtde_itempedido CHECK (quantidade > 0)
) ENGINE=InnoDB;

CREATE TABLE RESERVA_FRANGO (
    id_reserva_frango INT AUTO_INCREMENT PRIMARY KEY,
    qnt_reservada INT NOT NULL,
    horario_retirada DATETIME NOT NULL,
    pagamento_antecipado BOOLEAN NOT NULL DEFAULT FALSE,
    situacao VARCHAR(30) NOT NULL DEFAULT 'Pendente',
    id_pedido INT NOT NULL UNIQUE,
    CONSTRAINT fk_reserva_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido) ON DELETE RESTRICT,
    CONSTRAINT chk_qnt_reservada CHECK (qnt_reservada > 0)
) ENGINE=InnoDB;

-- Modulo de produção e estoque

CREATE TABLE LOTE_FRANGO (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    data_producao DATE NOT NULL,
    qnt_produzida INT NOT NULL,
    qnt_disponivel INT NOT NULL,
    id_produto INT NOT NULL,
    CONSTRAINT fk_lote_produto FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto) ON DELETE RESTRICT,
    CONSTRAINT chk_qnt_lote CHECK (qnt_produzida >= 0 AND qnt_disponivel >= 0)
) ENGINE=InnoDB;

CREATE TABLE INSUMO (
    id_insumo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    unidade VARCHAR(10) NOT NULL,
    qtd_estoque DECIMAL(10,2) NOT NULL DEFAULT 0,
    estoque_minimo DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_qtd_estoque CHECK (qtd_estoque >= 0)
) ENGINE=InnoDB;

CREATE TABLE FORNECEDOR (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(50) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE COMPRA (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    data_compra DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,
    situacao VARCHAR(30) NOT NULL DEFAULT 'Pendente',
    id_fornecedor INT NOT NULL,
    CONSTRAINT fk_compra_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR(id_fornecedor) ON DELETE RESTRICT,
    CONSTRAINT chk_valor_compra CHECK (valor_total >= 0)
) ENGINE=InnoDB;

CREATE TABLE ITEM_COMPRA (
    id_item_compra INT AUTO_INCREMENT PRIMARY KEY,
    quantidade DECIMAL(10,2) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    id_compra INT NOT NULL,
    id_insumo INT NOT NULL,
    CONSTRAINT fk_itemcompra_compra FOREIGN KEY (id_compra) REFERENCES COMPRA(id_compra) ON DELETE RESTRICT,
    CONSTRAINT fk_itemcompra_insumo FOREIGN KEY (id_insumo) REFERENCES INSUMO(id_insumo) ON DELETE RESTRICT,
    CONSTRAINT chk_qtde_itemcompra CHECK (quantidade > 0)
) ENGINE=InnoDB;

CREATE TABLE RECEBIMENTO (
    id_recebimento INT AUTO_INCREMENT PRIMARY KEY,
    data_recebimento DATE NOT NULL,
    divergencia VARCHAR(255) NULL,
    id_compra INT NOT NULL UNIQUE,
    id_funcionario INT NOT NULL,
    CONSTRAINT fk_recebimento_compra FOREIGN KEY (id_compra) REFERENCES COMPRA(id_compra) ON DELETE RESTRICT,
    CONSTRAINT fk_recebimento_funcionario FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE MOVIMENTACAO_ESTOQUE (
    id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
    data_movimento DATETIME NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    motivo VARCHAR(100) NOT NULL,
    id_insumo INT NOT NULL,
    id_recebimento INT NULL,
    CONSTRAINT fk_mov_insumo FOREIGN KEY (id_insumo) REFERENCES INSUMO(id_insumo) ON DELETE RESTRICT,
    CONSTRAINT fk_mov_recebimento FOREIGN KEY (id_recebimento) REFERENCES RECEBIMENTO(id_recebimento) ON DELETE RESTRICT,
    CONSTRAINT chk_tipo_mov CHECK (tipo IN ('Entrada', 'Saida', 'Ajuste')),
    CONSTRAINT chk_qtde_mov CHECK (quantidade > 0)
) ENGINE=InnoDB;

-- Modulo financeiro e fiscal

CREATE TABLE NOTA_FISCAL (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) NOT NULL,
    serie VARCHAR(5) NOT NULL,
    data_emissao DATETIME NOT NULL,
    tipo VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE FECHAMENTO_CAIXA (
    id_fechamento INT AUTO_INCREMENT PRIMARY KEY,
    data_fechamento DATE NOT NULL,
    valor_dinheiro DECIMAL(10,2) NOT NULL DEFAULT 0,
    valor_pix DECIMAL(10,2) NOT NULL DEFAULT 0,
    valor_cartao DECIMAL(10,2) NOT NULL DEFAULT 0,
    observacao VARCHAR(255) NULL,
    id_funcionario INT NOT NULL,
    CONSTRAINT fk_fechamento_funcionario FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE FATURAMENTO (
    id_faturamento INT AUTO_INCREMENT PRIMARY KEY,
    data_pagamento DATETIME NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    situacao VARCHAR(30) NOT NULL DEFAULT 'Pago',
    id_pedido INT NOT NULL UNIQUE,
    id_nota_fiscal INT NULL UNIQUE,
    id_fechamento INT NULL,
    CONSTRAINT fk_faturamento_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido) ON DELETE RESTRICT,
    CONSTRAINT fk_faturamento_nota FOREIGN KEY (id_nota_fiscal) REFERENCES NOTA_FISCAL(id_nota) ON DELETE RESTRICT,
    CONSTRAINT fk_faturamento_fechamento FOREIGN KEY (id_fechamento) REFERENCES FECHAMENTO_CAIXA(id_fechamento) ON DELETE RESTRICT,
    CONSTRAINT chk_forma_pgto CHECK (forma_pagamento IN ('Pix', 'Dinheiro', 'Cartao de Debito', 'Cartao de Credito'))
) ENGINE=InnoDB;

-- Tabela técnica de auditiria

CREATE TABLE LOG_ACESSO (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    dh_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_ator VARCHAR(36) NULL,
    cd_operacao VARCHAR(48) NOT NULL,
    cd_recurso VARCHAR(40) NOT NULL,
    id_registro INT NULL,
    tp_resultado VARCHAR(12) NOT NULL,
    CONSTRAINT chk_log_resultado CHECK (tp_resultado IN ('sucesso', 'negado', 'erro'))
) ENGINE=InnoDB;

-- Indices para otimização
CREATE INDEX idx_pedido_data_situacao ON PEDIDO (data_hora, situacao);
CREATE INDEX idx_faturamento_pagamento ON FATURAMENTO (data_pagamento, forma_pagamento);
CREATE INDEX idx_mov_data ON MOVIMENTACAO_ESTOQUE (data_movimento, tipo);

-- ===========================================================================
-- ETAPA 4: INSERT INTO - MASSA DE DADOS CONSISTENTE
-- ===========================================================================

-- 1. Pessoas e subtipos
INSERT INTO PESSOA (nome) VALUES 
('Antonio Proprietario'), ('Ana Atendente'), ('Joao Cozinheiro'),
('Maria Souza'), ('Pedro Santos'), ('Lucia Oliveira'), ('Jose Silva'),
('Fernanda Lima'), ('Carlos Pereira'), ('Juliana Costa'), ('Marcos Rocha'), ('Patricia Alves');

INSERT INTO FUNCIONARIO (cargo, salario_base, id_pessoa) VALUES 
('Proprietario', 5000.00, 1), 
('Atendente', 2000.00, 2),
('Cozinheira', 2500.00, 3);

INSERT INTO CLIENTE (data_cadastro, id_pessoa) VALUES 
('2026-11-01', 4), ('2026-11-02', 5), ('2026-11-03', 6), 
('2026-11-04', 7), ('2026-11-05', 8), ('2026-11-06', 9), 
('2026-11-07', 10), ('2026-11-07', 11), ('2026-11-07', 12);

INSERT INTO TELEFONE (numero, tipo_telefone, id_pessoa) VALUES 
('11999990001', 'Celular', 1), ('11999990002', 'Celular', 2), ('11999990003', 'Celular', 3),
('11999990004', 'Celular', 4), ('11999990005', 'Celular', 5), ('11999990006', 'Celular', 6);

-- 2. Mesas e produtos

INSERT INTO MESA (numero, localizacao, capacidade) VALUES 
(1, 'Externa', 4), (2, 'Externa', 4), (3, 'Externa', 2), 
(4, 'Externa', 2), (5, 'Externa', 4), (6, 'Interna', 4), (7, 'Interna', 2);

INSERT INTO PRODUTO (nome, descricao, preco, categoria) VALUES 
('Frango Assado', 'Frango inteiro com arroz, farofa e salada', 45.00, 'Refeicao'),
('Refrigerante Lata', 'Coca-cola 350ml', 6.00, 'Bebida'),
('Suco Natural', 'Suco de laranja 500ml', 8.00, 'Bebida'),
('Agua Mineral', 'Garrafa 500ml', 4.00, 'Bebida'),
('Porcao Batata', 'Batata frita individual', 15.00, 'Acompanhamento'),
('Pudim', 'Pudim de leite condensado', 10.00, 'Sobremesa');

-- 3. Estoque e fornecedores

INSERT INTO INSUMO (nome, unidade, qtd_estoque, estoque_minimo) VALUES 
('Frango Cru', 'Kg', 21.0, 10.0),    
('Carvao', 'Kg', 50.0, 5.0),          
('Embalagem', 'Unidade', 100.0, 20.0), 
('Tempero', 'Kg', 1.0, 2.0);          

INSERT INTO FORNECEDOR (nome, contato, cnpj) VALUES 
('Frigorifico Boi Branco', '1140028922', '11.111.111/0001-11'),
('Atacadao Distribuidor', '11912345678', '22.222.222/0001-22');

INSERT INTO COMPRA (data_compra, valor_total, situacao, id_fornecedor) VALUES 
('2026-11-06', 500.00, 'Recebida', 1),
('2026-11-06', 250.00, 'Recebida', 2);

INSERT INTO ITEM_COMPRA (quantidade, valor_unitario, id_compra, id_insumo) VALUES 
(25.0, 20.00, 1, 1),   
(50.0, 3.00, 2, 2),    
(100.0, 1.00, 2, 3);   

INSERT INTO RECEBIMENTO (data_recebimento, divergencia, id_compra, id_funcionario) VALUES 
('2026-11-06', 'Faltou 2kg de frango', 1, 1),
('2026-11-06', NULL, 2, 1);

INSERT INTO MOVIMENTACAO_ESTOQUE (data_movimento, quantidade, tipo, motivo, id_insumo, id_recebimento) VALUES 
('2026-11-06 08:00:00', 23.0, 'Entrada', 'Recebimento de compra', 1, 1),
('2026-11-06 08:00:00', 50.0, 'Entrada', 'Recebimento de compra', 2, 2),
('2026-11-06 08:00:00', 100.0, 'Entrada', 'Recebimento de compra', 3, 2),
('2026-11-07 15:00:00', 2.0, 'Saida', 'Perda por vencimento', 1, NULL);

-- 4. Produção e pedidos

INSERT INTO LOTE_FRANGO (data_producao, qnt_produzida, qnt_disponivel, id_produto) VALUES 
('2026-11-07', 14, 2, 1),    
('2026-11-08', 24, 14, 1);   

-- Pedidos no sábado (10 pedidos)

INSERT INTO PEDIDO (data_hora, tipo_consumo, situacao, id_cliente, id_funcionario, id_mesa) VALUES 
('2026-11-07 11:30:00', 'Local', 'Concluido', 1, 2, 1),
('2026-11-07 12:00:00', 'Local', 'Concluido', 2, 2, 2),
('2026-11-07 12:30:00', 'Retirada', 'Concluido', 3, 2, NULL),
('2026-11-07 13:00:00', 'Local', 'Concluido', 1, 2, 3),
('2026-11-07 13:15:00', 'Local', 'Concluido', 4, 2, 4),
('2026-11-07 13:45:00', 'Retirada', 'Concluido', 2, 2, NULL),
('2026-11-07 14:00:00', 'Local', 'Concluido', 5, 2, 5),
('2026-11-07 18:00:00', 'Local', 'Concluido', 3, 2, 1),
('2026-11-07 19:00:00', 'Retirada', 'Concluido', 1, 2, NULL),
('2026-11-07 19:30:00', 'Local', 'Concluido', 2, 2, 2);

-- Pedidos no domingo (10 pedidos)

INSERT INTO PEDIDO (data_hora, tipo_consumo, situacao, id_cliente, id_funcionario, id_mesa) VALUES 
('2026-11-08 11:30:00', 'Local', 'Concluido', 3, 2, 6),
('2026-11-08 12:00:00', 'Local', 'Concluido', 4, 2, 7),
('2026-11-08 12:30:00', 'Retirada', 'Concluido', 5, 2, NULL),
('2026-11-08 13:00:00', 'Local', 'Concluido', 1, 2, 1),
('2026-11-08 13:30:00', 'Local', 'Concluido', 2, 2, 2),
('2026-11-08 14:00:00', 'Retirada', 'Concluido', 3, 2, NULL),
('2026-11-08 14:30:00', 'Local', 'Concluido', 4, 2, 3),
('2026-11-08 18:00:00', 'Local', 'Concluido', 5, 2, 4),
('2026-11-08 19:00:00', 'Retirada', 'Concluido', 1, 2, NULL),
('2026-11-08 19:30:00', 'Local', 'Aberto', 2, 2, 5);

-- 5. Itens dos pedidos (sábado: 12 frangos; domingo: 10 frangos)

INSERT INTO ITEM_PEDIDO (quantidade, valor_aplicado, id_pedido, id_produto) VALUES 
(1, 45.00, 1, 1), (2, 6.00, 1, 2), 
(1, 45.00, 2, 1), (1, 8.00, 2, 3),
(1, 45.00, 3, 1),
(2, 45.00, 4, 1), (1, 15.00, 4, 5),
(1, 45.00, 5, 1), (3, 6.00, 5, 2),
(1, 45.00, 6, 1),
(1, 45.00, 7, 1), (1, 8.00, 7, 3),
(1, 45.00, 8, 1),
(1, 45.00, 9, 1), (1, 15.00, 9, 5),
(2, 45.00, 10, 1), (2, 6.00, 10, 2),
(1, 45.00, 11, 1), 
(1, 45.00, 12, 1), (1, 4.00, 12, 4),
(1, 45.00, 13, 1),
(2, 45.00, 14, 1), (1, 8.00, 14, 3),
(1, 45.00, 15, 1),
(1, 45.00, 16, 1), (1, 15.00, 16, 5),
(1, 45.00, 17, 1), (2, 6.00, 17, 2),
(1, 45.00, 18, 1), (1, 10.00, 18, 6),
(1, 45.00, 19, 1), (1, 4.00, 19, 4),
(1, 45.00, 20, 1);

-- 6. Reservas, notas e faturamento

INSERT INTO RESERVA_FRANGO (qnt_reservada, horario_retirada, pagamento_antecipado, situacao, id_pedido) VALUES 
(1, '2026-11-07 18:00:00', TRUE, 'Retirado', 3),
(1, '2026-11-08 18:00:00', TRUE, 'Retirado', 13);

INSERT INTO NOTA_FISCAL (numero, serie, data_emissao, tipo) VALUES 
('000101', '1', '2026-11-07 11:50:00', 'Venda'),
('000102', '1', '2026-11-07 12:20:00', 'Venda'),
('000103', '1', '2026-11-07 12:50:00', 'Venda');

INSERT INTO FATURAMENTO (data_pagamento, valor_total, forma_pagamento, id_pedido, id_nota_fiscal) VALUES 
('2026-11-07 11:45:00', 57.00, 'Pix', 1, 1),
('2026-11-07 12:15:00', 53.00, 'Dinheiro', 2, 2),
('2026-11-07 12:45:00', 45.00, 'Cartao de Debito', 3, 3),
('2026-11-07 13:15:00', 105.00, 'Pix', 4, NULL),
('2026-11-07 13:30:00', 63.00, 'Dinheiro', 5, NULL),
('2026-11-07 14:00:00', 45.00, 'Cartao de Credito', 6, NULL),
('2026-11-07 14:15:00', 53.00, 'Pix', 7, NULL),
('2026-11-07 18:15:00', 45.00, 'Dinheiro', 8, NULL),
('2026-11-07 19:15:00', 60.00, 'Pix', 9, NULL),
('2026-11-07 19:45:00', 102.00, 'Cartao de Debito', 10, NULL),
('2026-11-08 11:45:00', 45.00, 'Pix', 11, NULL),
('2026-11-08 12:15:00', 49.00, 'Dinheiro', 12, NULL),
('2026-11-08 12:45:00', 45.00, 'Cartao de Credito', 13, NULL),
('2026-11-08 13:15:00', 98.00, 'Pix', 14, NULL),
('2026-11-08 13:45:00', 45.00, 'Dinheiro', 15, NULL),
('2026-11-08 14:15:00', 60.00, 'Cartao de Debito', 16, NULL),
('2026-11-08 14:45:00', 57.00, 'Pix', 17, NULL),
('2026-11-08 18:15:00', 55.00, 'Dinheiro', 18, NULL),
('2026-11-08 19:15:00', 49.00, 'Cartao de Credito', 19, NULL);

INSERT INTO FECHAMENTO_CAIXA (data_fechamento, valor_dinheiro, valor_pix, valor_cartao, id_funcionario) VALUES 
('2026-11-07', 161.00, 275.00, 192.00, 1),
('2026-11-08', 149.00, 200.00, 154.00, 1);

-- Associando faturamentos aos fechamentos

UPDATE FATURAMENTO SET id_fechamento = 1 WHERE id_pedido IN (1,2,3,4,5,6,7,8,9,10);
UPDATE FATURAMENTO SET id_fechamento = 2 WHERE id_pedido IN (11,12,13,14,15,16,17,18,19);

UPDATE MESA SET status = 'Ocupada' WHERE id_mesa = 5;

-- ===========================================================================
-- ETAPA 5: SELECT COM JOIN (Relacionamentos)
-- ===========================================================================

SELECT p.id_pedido, p.data_hora, p.tipo_consumo, c.nome AS cliente, f.nome AS atendente, m.numero AS mesa, p.situacao
FROM PEDIDO p
JOIN CLIENTE cl ON p.id_cliente = cl.id_cliente
JOIN PESSOA c ON cl.id_pessoa = c.id_pessoa
JOIN FUNCIONARIO fu ON p.id_funcionario = fu.id_funcionario
JOIN PESSOA f ON fu.id_pessoa = f.id_pessoa
LEFT JOIN MESA m ON p.id_mesa = m.id_mesa;

SELECT i.id_pedido, pr.nome AS produto, pr.categoria, i.quantidade, i.valor_aplicado, (i.quantidade * i.valor_aplicado) AS subtotal
FROM ITEM_PEDIDO i
JOIN PRODUTO pr ON i.id_produto = pr.id_produto;

-- ===========================================================================
-- ETAPA 6: UPDATE E DELETE (Manipulação de dados)
-- ===========================================================================
-- U01: Acrescentar telefone alternativo a cliente
UPDATE TELEFONE SET numero = '11988887777' WHERE id_telefone = 4;

-- D01: Inserir cliente temporário e deletar com segurança
INSERT INTO PESSOA (nome) VALUES ('Cliente Teste DELETE');
SET @id_novo_cliente = LAST_INSERT_ID();
INSERT INTO CLIENTE (data_cadastro, id_pessoa) VALUES ('2026-11-09', @id_novo_cliente);

DELETE FROM CLIENTE 
WHERE id_cliente = LAST_INSERT_ID() 
  AND NOT EXISTS (SELECT 1 FROM PEDIDO p WHERE p.id_cliente = CLIENTE.id_cliente);

DELETE FROM PESSOA WHERE id_pessoa = @id_novo_cliente;

-- ===========================================================================
-- ETAPA 7: CONSULTAS GERENCIAIS (G01 a G10)
-- ===========================================================================

-- G01 — Ticket medio dos pedidos faturados
SELECT ROUND(AVG(valor_total), 2) AS Ticket_Medio FROM FATURAMENTO;

-- G02 — Faturamento por forma de pagamento
SELECT forma_pagamento, SUM(valor_total) AS Total_Arrecadado
FROM FATURAMENTO
GROUP BY forma_pagamento;

-- G03 — Produtos mais vendidos (CORRIGIDO: Apenas pedidos concluídos)
SELECT pr.nome AS Produto, SUM(ip.quantidade) AS Total_Vendido
FROM ITEM_PEDIDO ip
JOIN PRODUTO pr ON ip.id_produto = pr.id_produto
JOIN PEDIDO pe ON ip.id_pedido = pe.id_pedido
WHERE pe.situacao = 'Concluido'
GROUP BY pr.nome
ORDER BY Total_Vendido DESC;

-- G04 — Valor comprado por fornecedor
SELECT f.nome AS Fornecedor, COUNT(c.id_compra) AS Qtd_Compras, SUM(c.valor_total) AS Total_Gasto
FROM COMPRA c
JOIN FORNECEDOR f ON c.id_fornecedor = f.id_fornecedor
GROUP BY f.nome;

-- G05 — Divergencias nos recebimentos
SELECT r.id_recebimento, c.id_compra, f.nome AS Fornecedor, r.data_recebimento, r.divergencia
FROM RECEBIMENTO r
JOIN COMPRA c ON r.id_compra = c.id_compra
JOIN FORNECEDOR f ON c.id_fornecedor = f.id_fornecedor
WHERE r.divergencia IS NOT NULL;

-- G06 — Taxa de perda/descarte de insumos
SELECT i.nome AS Insumo, SUM(m.quantidade) AS Total_Descartado
FROM MOVIMENTACAO_ESTOQUE m
JOIN INSUMO i ON m.id_insumo = i.id_insumo
WHERE m.motivo LIKE '%Perda%' OR m.motivo LIKE '%Vencimento%'
GROUP BY i.nome;

-- G07 — Insumos abaixo do estoque minimo
SELECT nome, qtd_estoque, estoque_minimo
FROM INSUMO
WHERE qtd_estoque < estoque_minimo;

-- G08 — Faturamento total por mes
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS Mes, SUM(valor_total) AS Total_Faturado
FROM FATURAMENTO
GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m');

-- G09 — Quantidade de pedidos por tipo de consumo
SELECT tipo_consumo, COUNT(*) AS Qtd_Pedidos
FROM PEDIDO
GROUP BY tipo_consumo;

-- G10 — Fechamento de caixa e totais
SELECT data_fechamento, valor_dinheiro, valor_pix, valor_cartao, 
       (valor_dinheiro + valor_pix + valor_cartao) AS Total_Caixa
FROM FECHAMENTO_CAIXA;

-- ===========================================================================
-- ETAPA 8: CONSULTAS DE AUDITORIA (A01 a A08)
-- Todas devem retornar 0 linhas para o banco estar integro.
-- ===========================================================================

-- A01 — Pedido sem nenhum item
SELECT p.id_pedido, p.data_hora FROM PEDIDO p
LEFT JOIN ITEM_PEDIDO ip ON p.id_pedido = ip.id_pedido
WHERE ip.id_item_pedido IS NULL;

-- A02 — Faturamento cujo valor difere da soma dos itens
SELECT f.id_faturamento, f.valor_total AS Valor_Faturado, SUM(ip.quantidade * ip.valor_aplicado) AS Valor_Itens
FROM FATURAMENTO f
JOIN PEDIDO p ON f.id_pedido = p.id_pedido
JOIN ITEM_PEDIDO ip ON p.id_pedido = ip.id_pedido
GROUP BY f.id_faturamento, f.valor_total
HAVING f.valor_total <> SUM(ip.quantidade * ip.valor_aplicado);

-- A03 — Movimentacao de estoque com quantidade negativa
SELECT id_movimentacao, quantidade, tipo
FROM MOVIMENTACAO_ESTOQUE
WHERE quantidade <= 0;

-- A04 — Cliente sem pessoa associada
SELECT c.id_cliente
FROM CLIENTE c
LEFT JOIN PESSOA p ON c.id_pessoa = p.id_pessoa
WHERE p.id_pessoa IS NULL;

-- A05 — Produto com preco zerado
SELECT id_produto, nome, preco
FROM PRODUTO
WHERE preco <= 0;

-- A06 — Pedido com situacao 'Concluido' mas sem faturamento pago
SELECT p.id_pedido, p.situacao 
FROM PEDIDO p
LEFT JOIN FATURAMENTO f ON p.id_pedido = f.id_pedido
WHERE p.situacao = 'Concluido' AND (f.situacao IS NULL OR f.situacao <> 'Pago');

-- A07 — Mesa com status inconsistente (ocupada sem pedido aberto)
SELECT m.id_mesa, m.status
FROM MESA m
WHERE m.status = 'Ocupada' AND NOT EXISTS (
    SELECT 1 FROM PEDIDO p WHERE p.id_mesa = m.id_mesa AND p.situacao = 'Aberto'
);

-- A08 — Lote de frango com quantidade disponivel maior que a produzida
SELECT id_lote, qnt_produzida, qnt_disponivel
FROM LOTE_FRANGO
WHERE qnt_disponivel > qnt_produzida;

-- ===========================================================================
-- FIM DO SCRIPT
-- ===========================================================================

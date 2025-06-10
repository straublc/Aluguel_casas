/* VALOR TOTAL ARRECADADO NO MES */

SELECT SUM(VALOR_ALUGUEL) AS TOTAL
FROM contrato;

--------------------------------------------------------------------------------

/* VALOR TOTAL ARRECADADO NO ANO */

SELECT SUM(valor_aluguel) * 12 AS TOTAL_ANUAL
FROM contrato;

--------------------------------------------------------------------------------

/* QUANTIDADE DE SEXO */

SELECT sexo, COUNT(*) as QTD
FROM CLIENTE
GROUP BY SEXO;

--------------------------------------------------------------------------------

/* QUANTIDADE DE SEXO EM CADA TIPO DE CASA */

SELECT tipo_casa, sexo, COUNT(*) AS quantidade
FROM cliente
INNER JOIN casa 
ON id_cliente = id_casa
GROUP BY tipo_casa, sexo
ORDER BY tipo_casa, sexo;

--------------------------------------------------------------------------------

/* NOME, TELEFONE, EMAIL, TIPO DE CASA E VALOR ALUGUEL */

SELECT cliente.nome, cliente.telefone, cliente.email, tipo_casa, contrato.valor_aluguel
FROM cliente cliente
INNER JOIN casa
ON id_cliente = id_casa
INNER JOIN contrato contrato
ON cliente.id_cliente = contrato.id_contrato
ORDER BY 5 DESC;

--------------------------------------------------------------------------------

/* CONFIRMAR SE O TIPO DE CASA CORRESPONDE AO VALOR CORRETO */

SELECT ID_CLIENTE, C.ID_CASA, CASA.TIPO_CASA, VALOR_ALUGUEL
FROM CONTRATO C
INNER JOIN CASA CASA
ON C.ID_CONTRATO = CASA.ID_CASA
ORDER BY 4 DESC;

--------------------------------------------------------------------------------

/* VERFIFICANDO PAGAMENTOS */

SELECT nome, 
	   tipo_casa, 
       numero, 
       valor, 
       data_vencimento, 
       IFNULL(data_pagamento,'NAO PAGO') AS data_pagamento, 
       IFNULL(valor_pago, 'NAO PAGO') AS valor_pago, 
       IFNULL(forma_pagamento,'NAO PAGO') AS forma_pagamento, 
       status_pagamento, 
       valor_atraso 
FROM cliente
INNER JOIN casa
ON id_cliente = id_casa
INNER JOIN pagamentos
ON id_cliente = id_pagamento
order by 9;
--------------------------------------------------------------------------------

/* PROCEDURE PARA UPDATE TABELA PAGAMENTOS*/

DELIMITER $

CREATE PROCEDURE p_pagamentos_atrasados_update (p_data_pagamento DATE,
												p_valor_pago DECIMAL (10,2),
                                                p_forma_pagamento VARCHAR (10),
                                                p_status_pagamento VARCHAR (10),
                                                p_valor_atraso DECIMAL (10,2),
												p_id_pagamento INT)
BEGIN
    UPDATE pagamentos
    SET data_pagamento = p_data_pagamento,
		valor_pago = p_valor_pago,
        forma_pagamento = p_forma_pagamento,
        status_pagamento = p_status_pagamento,
        valor_atraso = p_valor_atraso
    WHERE id_pagamento = p_id_pagamento;
END 
$

DELIMITER ;

CALL p_pagamentos_atrasados_update ('2025-01-21', 955.00, 'PIX', 'PAGO', 05.00, 7);
CALL p_pagamentos_atrasados_update ('2025-01-25', 775.00, 'DINHEIRO', 'PAGO', 25.00, 12);

--------------------------------------------------------------------------------

/* QUAL CLIENTE PAGOU MAIS - UTILIZACAO DE SUBQUERIES */

SELECT nome, valor_pago 
FROM cliente
INNER JOIN pagamentos
ON id_cliente = id_pagamento
WHERE valor_pago = (SELECT MAX(valor_pago) FROM pagamentos);

--------------------------------------------------------------------------------

/* ALTERANDO VALORES COM PROCEDURE */

DELIMITER $

CREATE PROCEDURE p_status_contrato_update (p_status_contrato VARCHAR(12),
										   P_data_recisao DATE,
										   p_id_contrato INT)
BEGIN
	DECLARE vmensagem VARCHAR (100);
    UPDATE contrato
    SET status_contrato = p_status_contrato,
		data_recisao = p_data_recisao
    WHERE id_contrato = p_id_contrato;
    
    SET vmensagem = 'Query realizada com sucesso!';
    SELECT vmensagem;
END 
$

CALL p_status_contrato_update ('INTERROMPIDO','2025-01-28',3);
CALL p_status_contrato_update ('INTERROMPIDO','2025-01-27',13);

/* VERIFICANDO STATUS DO CONTRATO */

SELECT status_contrato, data_recisao, id_contrato 
FROM contrato
ORDER BY 1;

/* PROCEDURE PARA ALTERAR DISPONIBILIDADE DO IMIVEL */

DELIMITER $

CREATE PROCEDURE p_casa_update (p_status_disponibilidade VARCHAR(10),
								p_id_casa INT)
BEGIN
	DECLARE vmensagem VARCHAR (100);
    UPDATE casa
    SET status_disponibilidade = p_status_disponibilidade
    WHERE id_casa = p_id_casa;
    
	SET vmensagem = 'Query realizada com sucesso!';
    SELECT vmensagem;
END 
$

DELIMITER ;

CALL p_casa_update ('MANUTENCAO', 3);
CALL p_casa_update ('DISPONIVEL', 13);

/* VERIFICANDO DISPONIBILIDADE DOS IMOVEIS */

SELECT tipo_casa, numero, status_disponibilidade
FROM casa
ORDER BY 3;

--------------------------------------------------------------------------------

/* EXCLUINDO OS CLIENTES QUE NAO SAO INQUILINOS */

DELETE FROM pagamentos WHERE id_contrato IN (3, 13);
DELETE FROM contrato WHERE id_contrato IN (3, 13);
DELETE FROM cliente WHERE id_cliente IN (3, 13);

--------------------------------------------------------------------------------

/* PROCEDURE PARA INSERT - CLIENTE */

DELIMITER $

CREATE PROCEDURE p_cliente(
						  nome VARCHAR (50),
						  rg VARCHAR(11),
						  cpf VARCHAR (11),
					      data_nasc DATE,
						  sexo ENUM ('M', 'F'),
						  email VARCHAR (100),
						  telefone VARCHAR (16))
BEGIN
	INSERT INTO cliente VALUES (NULL, nome, rg, cpf, data_nasc, sexo, email, telefone);
END
$

DELIMITER ;

CALL p_cliente ('MARLON RIBEIRO', 232345674, 109876534, '2001-04-30', 'M', 'MARLONRIB@YAHOO.COM', '(11) 95454-9901');

/* INSERINDO O RESTANTE DE DADOS DO NOVO CLIENTE */

INSERT INTO cliente VALUES (NULL,'MARLON RIBEIRO', 232345674, 109876534, '2001-04-30', 'M', 'MARLONRIB@YAHOO.COM', '(11) 95454-9901');

INSERT INTO contrato VALUES (NULL, 'ANUAL', '2025-02-05', '2026-02-05', 750.00, 100.00, 'ATIVO', '2025-01-31', NULL, 15,3);
INSERT INTO pagamentos VALUES (NULL, '2025-01-20', '2025-01-12', 750.00, 'PIX', 'PAGO', 00.00, 15);

--------------------------------------------------------------------------------

/* VIEW RELATORIO */

CREATE VIEW relatorio AS
SELECT cliente.nome, 
	   cliente.telefone,
       cliente.email, 
       tipo_casa, 
       numero,
       contrato.valor_aluguel,
       data_vencimento, 
       IFNULL(p.data_pagamento,'NAO PAGO') AS data_pagamento, 
       IFNULL(p.valor_pago, 'NAO PAGO') AS valor_pago, 
       IFNULL(p.forma_pagamento,'NAO PAGO') AS forma_pagamento, 
       p.status_pagamento, 
       p.valor_atraso 
FROM cliente cliente
INNER JOIN casa
ON id_cliente = id_casa
INNER JOIN contrato contrato
ON cliente.id_cliente = contrato.id_contrato
INNER JOIN pagamentos p
ON contrato.id_cliente = p.id_pagamento
ORDER BY 5;

SELECT * FROM relatorio;

/* TRIGGERS */

DELIMITER $

CREATE TRIGGER bkp_cliente_d
BEFORE DELETE ON cliente
FOR EACH ROW
BEGIN	
	INSERT INTO bkp_cliente_delete VALUES 
    (NULL, OLD.nome, OLD.rg, OLD.cpf, OLD.data_nasc, OLD.sexo, OLD.email, OLD.telefone);
END
$

CREATE TRIGGER bkp_cliente_u
BEFORE UPDATE ON cliente
FOR EACH ROW
BEGIN	
	INSERT INTO bkp_cliente_update VALUES 
    (NULL, OLD.nome, OLD.rg, OLD.cpf, OLD.data_nasc, OLD.sexo, OLD.email, OLD.telefone);
END
$

CREATE TRIGGER bkp_contrato_d
BEFORE DELETE ON contrato
FOR EACH ROW
BEGIN
	INSERT INTO bkp_contrato_delete VALUES 
    (NULL, OLD.tipo_contrato, OLD.data_inicio, OLD.data_fim, OLD.valor_aluguel, OLD.valor_caucao,
	 OLD.status_contrato, OLD.data_assinatura, OLD.data_recisao);
END
$

CREATE TRIGGER bkp_contrato_u
BEFORE UPDATE ON contrato
FOR EACH ROW
BEGIN
	INSERT INTO bkp_contrato_update VALUES 
    (NULL, OLD.tipo_contrato, OLD.data_inicio, OLD.data_fim, OLD.valor_aluguel, OLD.valor_caucao,
	 OLD.status_contrato, OLD.data_assinatura, OLD.data_recisao);
END
$

CREATE TRIGGER bkp_pagamnetos_d
BEFORE DELETE ON pagamentos
FOR EACH ROW
BEGIN 
	INSERT INTO bkp_pagamentos_delete VALUES 
    (NULL, OLD.data_vencimento, OLD.data_pagamento, OLD.valor_pago, OLD.forma_pagamento, OLD.status_pagamento,
	 OLD.valor_atraso);
END
$

CREATE TRIGGER bkp_pagamnetos_u
BEFORE UPDATE ON pagamentos
FOR EACH ROW
BEGIN 
	INSERT INTO bkp_pagamentos_update VALUES 
    (NULL, OLD.data_vencimento, OLD.data_pagamento, OLD.valor_pago, OLD.forma_pagamento, OLD.status_pagamento,
	 OLD.valor_atraso);
END
$
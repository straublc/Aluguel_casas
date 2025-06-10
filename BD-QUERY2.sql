/* UPDATE REGISTROS */

SELECT id_cliente, telefone
From cliente
order by 1;

UPDATE cliente
SET telefone = '(21) 90903-3333'
WHERE id_cliente = 1;

UPDATE cliente
SET telefone = '(13) 77777-3333'
WHERE id_cliente = 10;

SELECT id_backup, telefone
From bkp_cliente_update
order by 1;

----------------------------------------------------

UPDATE contrato
SET valor_aluguel = 700.00
WHERE id_contrato = 1;

UPDATE contrato
SET valor_aluguel = 720.00
WHERE id_contrato = 2;

SELECT id_backup, valor_aluguel
From bkp_contrato_update
order by 1;

----------------------------------------------------

UPDATE pagamentos
SET forma_pagamento = 'DINHEIRO'
WHERE id_contrato = 1;

SELECT id_backup, forma_pagamento
From bkp_pagamentos_update
order by 1;

---------------------------------------------------

/* DELETE REGISTROS */

DELETE FROM pagamentos
WHERE id_pagamento IN (1, 2, 4, 5);

SELECT * From bkp_pagamentos_delete;

----------------------------------------------------

DELETE FROM contrato
WHERE id_contrato IN (1, 2, 4, 5);

SELECT * From bkp_contrato_delete;

----------------------------------------------------

DELETE FROM cliente
WHERE id_cliente IN (1, 2, 4, 5);

SELECT * From bkp_cliente_delete;

----------------------------------------------------

/* PROCEDURE PARA UPDATE TABELA CASA*/

CALL p_casa_update ('DISPONIVEL', 1);
CALL p_casa_update ('DISPONIVEL', 2);
CALL p_casa_update ('DISPONIVEL', 4);
CALL p_casa_update ('DISPONIVEL', 5);

/* CHECANDO INFORMACOES */

SELECT * FROM cliente; 

SELECT * FROM casa; 

SELECT * FROM contrato
order by 11; 














-- Estudar essa parte 
DELIMITER $

CREATE PROCEDURE p_atrasos (p_data_vencimento DATE,
		                    p_data_pagamento DATE,
                            valor_pago DECIMAL (10,2),
		                    p_forma_pagamento VARCHAR(10),
		                    p_status_pagamento VARCHAR(10),
							p_valor_atraso DECIMAL(10,2),
							p_id_pagamento INT)
BEGIN
    DECLARE v_dias INT DEFAULT 0;  
    DECLARE v_calculo_atraso DECIMAL(10,2);  
    DECLARE v_valor_aluguel DECIMAL(10,2); 
    
    SET v_dias = DATEDIFF(p_data_pagamento, p_data_vencimento);
    SET v_calculo_atraso = v_dias * p_valor_atraso;
    
	SELECT valor_aluguel INTO v_valor_aluguel
    FROM contrato
    WHERE id_pagamento = p_id_pagamento;
    
    SET v_pagamento = valor_aluguel + v_calculo_atraso;
    

    INSERT INTO pagamentos VALUES (p_data_vencimento, 
								   p_data_pagamento,
                                   valor_pago,
								   p_forma_pagamento, 
								   p_status_pagamento, 
								   v_calculo_atraso,  
							       p_id_pagamento);
END
$

DELIMITER ;

CALL p_atrasos ('2025-01-20','2025-01-21', 'PIX', 'PAGO', 05.00, 7);
CALL p_atrasos ('2025-01-20','2025-01-25', 'DINHEIRO', 'PAGO', 05.00, 12);


drop procedure p_atrasos;






                             






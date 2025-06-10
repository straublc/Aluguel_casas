CREATE DATABASE aluguel_casas;

USE aluguel_casas;

CREATE TABLE cliente (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (50) NOT NULL,
    rg VARCHAR(11) NOT NULL UNIQUE,
    cpf VARCHAR (11) NOT NULL UNIQUE,
    data_nasc DATE NOT NULL,
    sexo ENUM ('M', 'F'),
    email VARCHAR (100) NOT NULL UNIQUE,
    telefone VARCHAR (16) NOT NULL UNIQUE
);

CREATE TABLE bkp_cliente_delete (
	id_backup INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (50),
    rg VARCHAR(11),
    cpf VARCHAR(11),
    data_nasc  DATE,
    sexo ENUM ('M', 'F'),
    email VARCHAR (100),
    telefone VARCHAR (16)
);

CREATE TABLE bkp_cliente_update (
	id_backup INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR (50),
    rg VARCHAR(11),
    cpf VARCHAR(11),
    data_nasc  DATE,
    sexo ENUM ('M', 'F'),
    email VARCHAR (100),
    telefone VARCHAR (16)
);

CREATE TABLE casa (
	id_casa INT PRIMARY KEY AUTO_INCREMENT,
    tipo_casa ENUM ('CASA', 'KITNET') NOT NULL,
    numero INT NOT NULL UNIQUE,
    valor DECIMAL (10,2) NOT NULL,
    status_disponibilidade ENUM ('ALUGADA', 'DISPONIVEL', 'MANUTENCAO') NOT NULL,
    descricao TEXT
);

CREATE TABLE contrato (
	id_contrato INT PRIMARY KEY AUTO_INCREMENT,
    tipo_contrato ENUM ('ANUAL', 'SEMESTRAL') NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor_aluguel DECIMAL (10,2) NOT NULL,
    valor_caucao DECIMAL (10,2),
    status_contrato ENUM ('ATIVO', 'FINALIZADO', 'INTERROMPIDO') NOT NULL,
    data_assinatura DATE NOT NULL,
    data_recisao DATE
); 

CREATE TABLE bkp_contrato_delete (
	id_backup INT PRIMARY KEY AUTO_INCREMENT,
    tipo_contrato ENUM ('ANUAL', 'SEMESTRAL'),
    data_inicio DATE,
    data_fim DATE,
    valor_aluguel DECIMAL (10,2),
    valor_caucao DECIMAL (10,2),
    status_contrato ENUM ('ATIVO', 'FINALIZADO', 'INTERROMPIDO'),
    data_assinatura DATE,
    data_recisao DATE
); 

CREATE TABLE bkp_contrato_update (
	id_backup INT PRIMARY KEY AUTO_INCREMENT,
    tipo_contrato ENUM ('ANUAL', 'SEMESTRAL'),
    data_inicio DATE,
    data_fim DATE,
    valor_aluguel DECIMAL (10,2),
    valor_caucao DECIMAL (10,2),
    status_contrato ENUM ('ATIVO', 'FINALIZADO', 'INTERROMPIDO'),
    data_assinatura DATE,
    data_recisao DATE
); 

CREATE TABLE pagamentos (
	id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    valor_pago DECIMAL (10,2) ,
    forma_pagamento ENUM ('DINHEIRO', 'PIX', 'BOLETO', 'CREDITO'),
    status_pagamento ENUM ('PAGO', 'ATRASADO') NOT NULL,
    valor_atraso DECIMAL (10,2) 
);

CREATE TABLE bkp_pagamentos_delete (
	id_backup INT PRIMARY KEY AUTO_INCREMENT,
    data_vencimento DATE,
    data_pagamento DATE,
    valor_pago DECIMAL (10,2) ,
    forma_pagamento ENUM ('DINHEIRO', 'PIX', 'BOLETO', 'CREDITO'),
    status_pagamento ENUM ('PAGO', 'ATRASADO'),
    valor_atraso DECIMAL (10,2) 
);

CREATE TABLE bkp_pagamentos_update (
	id_backup INT PRIMARY KEY AUTO_INCREMENT,
    data_vencimento DATE,
    data_pagamento DATE,
    valor_pago DECIMAL (10,2) ,
    forma_pagamento ENUM ('DINHEIRO', 'PIX', 'BOLETO', 'CREDITO'),
    status_pagamento ENUM ('PAGO', 'ATRASADO'),
    valor_atraso DECIMAL (10,2) 
);

/* ADICIONANDO AS FK */

ALTER TABLE contrato
    ADD COLUMN id_cliente INT,
    ADD CONSTRAINT fk_cliente_contrato
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente);

ALTER TABLE contrato
    ADD COLUMN id_casa INT,
    ADD CONSTRAINT fk_casa_contrato
    FOREIGN KEY (id_casa) REFERENCES casa(id_casa);


ALTER TABLE pagamentos
    ADD COLUMN id_contrato INT,
    ADD CONSTRAINT fk_contrato_pagamentos
    FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato);
    
    
    drop database aluguel_casas;
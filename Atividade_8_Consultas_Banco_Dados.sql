USE master;
GO

DROP DATABASE IF EXISTS agroindustria_db;
GO

CREATE DATABASE agroindustria_db;
GO

USE agroindustria_db;
GO

CREATE TABLE setor (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(40) NOT NULL,
    descricao VARCHAR(MAX)
);
GO

CREATE TABLE medidas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_setor INT NOT NULL,
    data_hora DATETIME NOT NULL,
    variavel VARCHAR(20) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_medidas_setor
        FOREIGN KEY (id_setor) REFERENCES setor(id)
);
GO

INSERT INTO setor (nome, descricao) VALUES
('Moagem', 'Responsável pela extração do caldo da cana-de-açúcar.'),
('Clarificação', 'Remove impurezas do caldo e ajusta pH.'),
('Evaporação', 'Concentra o caldo por remoção de água.'),
('Fermentação', 'Converte açúcares em etanol através de leveduras.'),
('Destilação', 'Separa o etanol produzido na fermentação.'),
('Caldeira', 'Gera vapor para os processos industriais.');
GO

INSERT INTO medidas (id_setor, data_hora, variavel, valor) VALUES
(1, '2025-10-09 08:00:00', 'VAZÃO', 210.50),
(1, '2025-10-09 08:10:00', 'TEMP', 32.80),
(2, '2025-10-09 08:20:00', 'PH', 6.45),
(2, '2025-10-09 08:30:00', 'BRIX', 13.20),
(3, '2025-10-09 08:40:00', 'TEMP', 78.50),
(3, '2025-10-09 08:50:00', 'BRIX', 36.70),
(4, '2025-10-09 09:00:00', 'PH', 4.60),
(4, '2025-10-09 09:10:00', 'TEMP', 33.90),
(5, '2025-10-09 09:20:00', 'ETOH', 92.10),
(6, '2025-10-09 09:30:00', 'PRESSÃO', 17.80);
GO

SELECT * FROM setor;
SELECT * FROM medidas;

SELECT id, variavel, valor
FROM medidas
ORDER BY data_hora DESC;

SELECT *
FROM medidas
WHERE variavel = 'TEMP'
ORDER BY valor DESC;

SELECT *
FROM medidas
WHERE variavel = 'BRIX'
AND valor BETWEEN 30 AND 80
ORDER BY valor ASC;

SELECT variavel, COUNT(*) AS quantidade
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY quantidade DESC;

SELECT variavel, AVG(valor) AS valor_medio
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY valor_medio DESC;

SELECT
    variavel,
    MIN(valor) AS valor_minimo,
    MAX(valor) AS valor_maximo
FROM medidas
WHERE variavel IN ('VAZÃO', 'TEMP', 'PH', 'BRIX', 'ETOH')
GROUP BY variavel
ORDER BY variavel ASC;

SELECT
    s.nome AS setor,
    AVG(m.valor) AS media_temperatura
FROM setor AS s
INNER JOIN medidas AS m
    ON s.id = m.id_setor
WHERE m.variavel = 'TEMP'
GROUP BY s.nome
ORDER BY media_temperatura DESC;

SELECT
    s.nome AS setor,
    MIN(m.valor) AS menor_ETOH,
    MAX(m.valor) AS maior_ETOH
FROM setor AS s
INNER JOIN medidas AS m
    ON s.id = m.id_setor
WHERE m.variavel = 'ETOH'
GROUP BY s.nome
ORDER BY s.nome ASC;

SELECT
    s.nome AS setor,
    COUNT(m.id) AS total_medicoes
FROM setor AS s
LEFT JOIN medidas AS m
    ON s.id = m.id_setor
GROUP BY s.nome
ORDER BY total_medicoes DESC;
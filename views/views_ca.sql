�ncreate function datetostr.DATETOSTR(DATE, varchar(20)) RETURNS varchar(20);
create function to_date.TO_DATE(varchar(20), varchar(20)) RETURNS DATE;
create function datetostr.TIMETOSTR(TIME, varchar(20)) RETURNS varchar(20);

DECLARE SET VARCHAR(18) @CODIGO_BARRA = '';
DECLARE SET SMALLINT @COMPRE_AGORA = 0;

CREATE OR REPLACE VIEW VW_CA_SALDO_ESTOQUE AS
SELECT  
  DATA_ESTOQUE,
  PRODUTO_CODBAR_UN PRODUTO_CODBAR,
  SALDO_AV SALDO
FROM 
  SALDO_ESTOQUE_PORTAL
INNER JOIN
  CADPRD06 ON VDPRDPRD_CFAM = PRODUTO_FAM AND
              VDPRDPRD_NRO = PRODUTO_NRO   
WHERE
  VDPRDPRD_FLAG = 'A' AND
  (PRODUTO_UN = 12 OR SALDO_AV > 0) AND
  (PRODUTO_CODBAR_UN = @CODIGO_BARRA OR @CODIGO_BARRA = '') AND
  (VDPRDPRD_COMPRA_AGORA = @COMPRE_AGORA OR @COMPRE_AGORA = 0)
UNION ALL
SELECT  
  DATA_ESTOQUE,
  PRODUTO_CODBAR_CX || 'C' || CAST(PRODUTO_QTDUN AS VARCHAR(9)) PRODUTO_CODBAR,
  SALDO_CX SALDO
FROM 
  SALDO_ESTOQUE_PORTAL
INNER JOIN
  CADPRD06 ON VDPRDPRD_CFAM = PRODUTO_FAM AND
              VDPRDPRD_NRO = PRODUTO_NRO   
WHERE
  VDPRDPRD_FLAG = 'A' AND
  (PRODUTO_UN <> 12 AND SALDO_CX > 0) AND
  (PRODUTO_CODBAR_CX = @CODIGO_BARRA OR @CODIGO_BARRA = '') AND
  (VDPRDPRD_COMPRA_AGORA = @COMPRE_AGORA OR @COMPRE_AGORA = 0);

CREATE OR REPLACE VIEW VW_CA_PRECO_PRODUTO AS
SELECT
  TRIM(VDPRDBAR_CODBAR),
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'DFL' PRICE_TP,
  'UN' UNIDADE          
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 2 AND
  VDPRDPRD_UNID = 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT
  TRIM(VDPRDBAR_CODBAR) || 'C' || CAST(VDPRDPRD_QTDUN AS VARCHAR(4)) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'DFL' PRICE_TP,
  'CX' UNIDADE          
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 1 AND
  VDPRDPRD_UNID <> 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT 
  TRIM(VDPRDBAR_CODBAR) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'CRL-7' PRICE_TP,
  'UN'UNIDADE
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 2 AND
  VDPRDPRD_UNID = 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT 
  TRIM(VDPRDBAR_CODBAR) || 'C' || CAST(VDPRDPRD_QTDUN AS VARCHAR(4)) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'CRL-7' PRICE_TP,
  'CX' UNIDADE
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 1 AND
  VDPRDPRD_UNID <> 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT 
  TRIM(VDPRDBAR_CODBAR) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'CRL-14' PRICE_TP,
  'UN'UNIDADE
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 2 AND
  VDPRDPRD_UNID = 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT 
  TRIM(VDPRDBAR_CODBAR) || 'C' || CAST(VDPRDPRD_QTDUN AS VARCHAR(4)) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'CRL-14' PRICE_TP,
  'CX'UNIDADE
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 1 AND
  VDPRDPRD_UNID <> 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT 
  TRIM(VDPRDBAR_CODBAR) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'CRL-21' PRICE_TP,
  'UN'UNIDADE
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 2 AND
  VDPRDPRD_UNID = 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT 
  TRIM(VDPRDBAR_CODBAR) || 'C' || CAST(VDPRDPRD_QTDUN AS VARCHAR(4)) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'CRL-21' PRICE_TP,
  'CX'UNIDADE
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 1 AND
  VDPRDPRD_UNID <> 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT 
  TRIM(VDPRDBAR_CODBAR) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'CRL-28' PRICE_TP,
  'UN'UNIDADE
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 2 AND
  VDPRDPRD_UNID = 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
UNION ALL
SELECT 
  TRIM(VDPRDBAR_CODBAR) || 'C' || CAST(VDPRDPRD_QTDUN AS VARCHAR(4)) CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN,
  'CRL-28' PRICE_TP,
  'CX'UNIDADE
FROM
  TABPRC01
INNER JOIN
  CADPRD01 ON VDPRDPRD_CFAM = VDTABPRD_CFAM AND VDPRDPRD_NRO = VDTABPRD_NRO
INNER JOIN 
  VDPRBA01 ON VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) AND
              VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDPRDBAR_CODPRD AS VARCHAR(6)))),CAST(VDPRDBAR_CODPRD AS VARCHAR(6))),3) AS INT) 
WHERE 
  VDPRDPRD_COMPRA_AGORA = 1 AND
  VDTABPRD_PRECO > 0 AND
  VDPRDBAR_UNIDADE = 1 AND
  VDPRDPRD_UNID <> 12 AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201))
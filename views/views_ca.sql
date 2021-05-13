create function datetostr.DATETOSTR(DATE, varchar(20)) RETURNS varchar(20);
create function to_date.TO_DATE(varchar(20), varchar(20)) RETURNS DATE;
create function datetostr.TIMETOSTR(TIME, varchar(20)) RETURNS varchar(20);

DECLARE SET VARCHAR(18) @CODIGO_BARRA = '';
DECLARE SET SMALLINT @COMPRE_AGORA = 0;

CREATE OR REPLACE VIEW VW_CA_SALDO_ESTOQUE AS
SELECT  
  DATA_ESTOQUE,
  PRODUTO_CODBAR,
  PRODUTO_QTDUN,
  SALDO
FROM 
  SALDO_ESTOQUE_PORTAL
INNER JOIN
  CADPRD06 ON VDPRDPRD_CFAM = PRODUTO_FAM AND
              VDPRDPRD_NRO = PRODUTO_NRO   
WHERE
  VDPRDPRD_FLAG = 'A' AND
  (PRODUTO_CODBAR = @CODIGO_BARRA OR @CODIGO_BARRA = '') AND
  (VDPRDPRD_COMPRA_AGORA = @COMPRE_AGORA OR @COMPRE_AGORA = 0);

DECLARE SET VARCHAR(20) @CODIGO_PRODUTO_CIA = '';

CREATE OR REPLACE VIEW VW_CA_PRECO_PRODUTO AS
SELECT 
  VDPRDBAR_CODBAR CODIGO_PRODUTO,
  VDTABPRD_PRECO PRECO_CX,
  VDTABPRD_PRECOUN PRECO_UN  
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
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201)) AND
  (VDTABPRD_ANO = (SELECT CAST(LEFT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),4) AS INT) FROM PAROC201) AND
  VDTABPRD_MES = (SELECT CAST(SUBSTRING(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),5,2) AS INT) FROM PAROC201) AND
  VDTABPRD_NMES = (SELECT CAST(RIGHT(CAST(VDPAROC2_TAB_VENDA2_CA AS VARCHAR(8)),2) AS INT) FROM PAROC201)) AND
  (VDPRDPRD_CODCIA3 = @CODIGO_PRODUTO_CIA OR @CODIGO_PRODUTO_CIA = '');
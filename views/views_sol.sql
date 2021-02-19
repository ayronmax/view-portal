create function datetostr.DATETOSTR(DATE, varchar(20)) RETURNS varchar(20);
create function to_date.TO_DATE(varchar(20), varchar(20)) RETURNS DATE;
create function datetostr.TIMETOSTR(TIME, varchar(20)) RETURNS varchar(20);

DECLARE SET VARCHAR(10) @CODIGO_CLIENTE = '';
DECLARE SET VARCHAR(1) @PARCEIRO = '';

CREATE OR REPLACE VIEW VW_SOL_CLLIENTES_PARCEIROS AS
SELECT 
  '' WERKS, 
  VDCLICLI_CODCLICIA KUNNR,
  CURDATE() DT_PROC,
  CASE WHEN VDCLIPRV_PARCEIRO_G01 = 1 THEN 'X' ELSE '' END PARC_COB,
  CASE WHEN VDCLIPRV_PARCEIRO_G01 = 1 THEN 'X' ELSE '' END PARC_POL,
  CASE WHEN VDCLIPRV_PARCEIRO_G01 = 1 THEN 'X' ELSE '' END PARC_RED,
  CASE WHEN VDCLIPRV_PARCEIRO_G01 = 1 THEN 'X' ELSE '' END PARC_DES,
  CASE WHEN VDCLIPRV_PARCEIRO_G01 = 1 THEN 'X' ELSE '' END PARC_FINAL,
  CASE WHEN VDCLIPRV_PARCEIRO_G01 = 1 THEN '241' ELSE '' END PARC_TAB,	
  '' PARC_PROC,
  1 PARC_STATUS
FROM
  VDCLPR06
INNER JOIN
  CADCLI06 ON VDCLICLI_REGI = VDCLIPRV_REGI AND
             VDCLICLI_NUM = VDCLIPRV_NUM
WHERE
  (VDCLICLI_CODCLICIA = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '') AND
  (CAST(VDCLIPRV_PARCEIRO_G01 AS VARCHAR(1)) = @PARCEIRO OR @PARCEIRO = '');
  
DECLARE SET VARCHAR(10) @CODIGO_CLIENTE = '';
DECLARE SET VARCHAR(10) @CODIGO_CATEGORIA = '';

CREATE OR REPLACE VIEW VW_SOL_COBERTURA_CALCULO_PARCERIA AS
SELECT 
  '' VSTEL, 
  VDCLICLI_CODCLICIA KUNNR,
  'COB' FLUXO,
  VDCLIFSP_CODCIA CRI_COD,
  VDPRDGPA_CODCIA CTG_COD,
  CURDATE() DOCDAT,
  'X' CRI_STS,
  CASE WHEN VDCLIIFP_SIT = 1 THEN 'X' ELSE '' END CTG_STS,
  CASE WHEN VDCLIIFP_SIT = 1 THEN '241' ELSE '' END CRI_TAB,
  VDCLIIFP_NUMDIAS_PERDE DIAS_PERDE,
  CURDATE() PRCDAT,
  CURTIME() PRCHOR,
  '' PRCUSR
FROM
  VDCLIF06
INNER JOIN
  VDCLFS06 ON VDCLIFSP_COD = VDCLIIFP_CODFSP  
INNER JOIN
  CADCLI06 ON VDCLICLI_REGI = CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLIIFP_CODCLI AS VARCHAR(8)))) || CAST(VDCLIIFP_CODCLI AS VARCHAR(8)) ,1,4) AS INT) AND
              VDCLICLI_NUM = CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLIIFP_CODCLI AS VARCHAR(8)))) || CAST(VDCLIIFP_CODCLI AS VARCHAR(8)),5,4) AS INT)
INNER JOIN
  VDPRGP06 ON VDPRDGPA_GRPPAR = VDCLIIFP_GRPPAR AND VDPRDGPA_CODPRD = 0
WHERE
  (VDCLICLI_CODCLICIA = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '') AND
  (VDPRDGPA_CODCIA = @CODIGO_CATEGORIA OR @CODIGO_CATEGORIA = '');

CREATE OR REPLACE VIEW VW_SOL_DIA_SEMANA AS 
SELECT DISTINCT 
  NUMERO_PASTA,
  CASE 
    WHEN
      DAYOFWEEK(TO_DATE(SUBSTRING(cast(DATA_VISITA as varchar(8)),7,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),5,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),1,4), 'DDMMYYYY')) = 1
    THEN
      1
    ELSE
      0  
  END DIA_SEMANA_1,
  CASE
    WHEN
      DAYOFWEEK(TO_DATE(SUBSTRING(cast(DATA_VISITA as varchar(8)),7,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),5,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),1,4), 'DDMMYYYY')) = 2
    THEN
      2
    ELSE
      0  
  END DIA_SEMANA_2,
  CASE
    WHEN
      DAYOFWEEK(TO_DATE(SUBSTRING(cast(DATA_VISITA as varchar(8)),7,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),5,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),1,4), 'DDMMYYYY')) = 3
    THEN
      3
    ELSE
      0  
  END DIA_SEMANA_3,
  CASE
    WHEN
      DAYOFWEEK(TO_DATE(SUBSTRING(cast(DATA_VISITA as varchar(8)),7,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),5,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),1,4), 'DDMMYYYY')) = 4
    THEN 
      4
    ELSE
      0  
  END DIA_SEMANA_4,
  CASE 
    WHEN
      DAYOFWEEK(TO_DATE(SUBSTRING(cast(DATA_VISITA as varchar(8)),7,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),5,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),1,4), 'DDMMYYYY')) = 5
    THEN
      5
    ELSE
      0  
  END DIA_SEMANA_5,
  CASE 
    WHEN
      DAYOFWEEK(TO_DATE(SUBSTRING(cast(DATA_VISITA as varchar(8)),7,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),5,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),1,4), 'DDMMYYYY')) = 6
    THEN
      6
    ELSE
      0  
  END DIA_SEMANA_6,
  CASE 
    WHEN
      DAYOFWEEK(TO_DATE(SUBSTRING(cast(DATA_VISITA as varchar(8)),7,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),5,2) || SUBSTRING(cast(DATA_VISITA as varchar(8)),1,4), 'DDMMYYYY')) = 7
    THEN
      7
    ELSE
      0  
  END DIA_SEMANA_7
FROM
  PASTA_VISITA;

CREATE OR REPLACE VIEW VW_SOL_CADASTRO_ROTA AS
SELECT DISTINCT
  VDCLIROC_ROMA COD_GRP_ANALISE,
  VDCLIROC_NOMEGRP DESCRICAO_ROTA
FROM
  ROCLI06
WHERE 
  VDCLIROC_ROTA = 1;  

DECLARE SET VARCHAR(10) @CODIGO_CLIENTE = '';
DECLARE SET INT @DATA_INICIAL = 0;
DECLARE SET INT @HORA_INICIAL = 0;

CREATE OR REPLACE VIEW VW_SOL_ALT_PLANO_VISITAS AS
SELECT 
  'NORS' ORG_VENDAS,
  'TRNO' CENTRO,
  F.DESCRICAO_ROTA ROTA,
  A.VDCLICLI_CODCLICIA CLIENTE,  
  CASE WHEN B.FREQUENCIA = 'S' THEN 7
       WHEN B.FREQUENCIA = 'Q' THEN 14
       WHEN B.FREQUENCIA = 'M' THEN 21
       ELSE 7 END CICLO,       
  REPLACE(CAST(MAX(C.DIA_SEMANA_1) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_2) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_3) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_4) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_5) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_6) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_7) AS VARCHAR(1)), '0', '') VISITA,
  MIN(B.DATA_VISITA) DATA_SEMANA1,
  MAX(B.DATA_VISITA) DATA_SEMANA2
FROM     
  CADCLI06 A
INNER JOIN
  PASTA_VISITA B ON B.NUMERO_PASTA = A.VDCLICLI_CODPASTA1
INNER JOIN
  VW_SOL_DIA_SEMANA C ON C.NUMERO_PASTA = A.VDCLICLI_CODPASTA1
INNER JOIN
  (SELECT
     CAST(LEFT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_REGI,
     CAST(RIGHT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_NUM 
   FROM 
     VDCADFLT
   WHERE  
     VDCADFLT_COD_PROCESSO = 3 AND
     VDCADFLT_DATA >= @DATA_INICIAL AND 
     VDCADFLT_HORA >= @HORA_INICIAL) D 
   ON 
     D.CLI_REGI = A.VDCLICLI_REGI AND 
     D.CLI_NUM = A.VDCLICLI_NUM
INNER JOIN
  (SELECT
     CAST(LEFT(REPEAT('0',8-LENGTH(CAST(VDCLIROC_CCLI AS VARCHAR(8)))) || CAST(VDCLIROC_CCLI AS VARCHAR(8)),4) AS INT) CLI_REGI,
     CAST(RIGHT(REPEAT('0',8-LENGTH(CAST(VDCLIROC_CCLI AS VARCHAR(8)))) || CAST(VDCLIROC_CCLI AS VARCHAR(8)),4) AS INT) CLI_NUM, 
     VDCLIROC_ROMA COD_GRP_ANALISE  
   FROM 
     ROCLI06) E
   ON 
     E.CLI_REGI = A.VDCLICLI_REGI AND 
     E.CLI_NUM = A.VDCLICLI_NUM
INNER JOIN
  VW_SOL_CADASTRO_ROTA F ON F.COD_GRP_ANALISE = E.COD_GRP_ANALISE
WHERE
   A.VDCLICLI_CLASSE <> 20 AND    
   (A.VDCLICLI_CODCLICIA = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '')
GROUP BY
  F.DESCRICAO_ROTA,
  A.VDCLICLI_CODCLICIA,
  CASE WHEN B.FREQUENCIA = 'S' THEN 7
       WHEN B.FREQUENCIA = 'Q' THEN 14
       WHEN B.FREQUENCIA = 'M' THEN 21
       ELSE 7 END;  

DECLARE SET VARCHAR(10) @CODIGO_CLIENTE = '';
DECLARE SET INT @DATA_INICIAL = 0;
DECLARE SET INT @HORA_INICIAL = 0;

CREATE OR REPLAACE VIEW VW_CLIENTE_LIMITE_CREDITO AS 
SELECT 
  vdclicli_codclicia codigo_cliente, 
  vdclicli_cred_disponivel valor_limite
FROM 
  CADCLI06
INNER JOIN
  (SELECT
     CAST(LEFT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_REGI,
     CAST(RIGHT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_NUM 
   FROM 
     VDCADFLT
   WHERE  
     VDCADFLT_COD_PROCESSO = 1 AND
     VDCADFLT_DATA >= @DATA_INICIAL AND 
     VDCADFLT_HORA >= @HORA_INICIAL) VDCADFLT 
   ON 
     CLI_REGI = VDCLICLI_REGI AND 
     CLI_NUM = VDCLICLI_NUM
WHERE
   VDCLICLI_CLASSE <> 20 AND    
   (VDCLICLI_CODCLICIA = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '');

DECLARE SET VARCHAR(10) @CODIGO_CLIENTE = '';
DECLARE SET INT @DATA_INICIAL = 0;
DECLARE SET INT @HORA_INICIAL = 0;

CREATE OR REPLACE VIEW VW_SOL_ALT_CONDPAGTO AS
SELECT
  vdclicli_codclicia codigo_cliente,
  vdclicli_tpcobra tpcobranca,
  vdclicli_cpg condpagto
FROM
  CADCLI06
INNER JOIN
  (SELECT
     CAST(LEFT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_REGI,
     CAST(RIGHT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_NUM
   FROM
     VDCADFLT
   WHERE 
     VDCADFLT_COD_PROCESSO = 2 AND
     VDCADFLT_DATA >= @DATA_INICIAL AND
     VDCADFLT_HORA >= @HORA_INICIAL) VDCADFLT
   ON
     CLI_REGI = VDCLICLI_REGI AND
     CLI_NUM = VDCLICLI_NUM
WHERE
   VDCLICLI_CLASSE <> 20 AND   
   (VDCLICLI_CODCLICIA = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '');

DECLARE SET BIGINT @CODIGO_PROD = 0;
DECLARE SET INT @CODIGO_FAMILIA = 0;
DECLARE SET INT @CODIGO_SEQUENCIA = 0;
DECLARE SET INT @DATA_INICIAL = 0;
DECLARE SET INT @HORA_INICIAL = 0;

CREATE OR REPLACE VIEW VW_SLR_BLOQDES_PRODUTO AS
SELECT
  VDPRDPRD_CODCMP CODIGO_MATERIAL,
  CASE WHEN VDPRDPRD_FLAG  = 'A'
       THEN ' ' 
       ELSE 'X' 
  END AS ATIVO,
  1 ID_MTBLOQ
FROM
  CADPRD06
INNER JOIN
  (SELECT
     CAST(LEFT(REPEAT('0',6-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),3) AS INT) PRD_FAM,
     CAST(RIGHT(REPEAT('0',6-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),3) AS INT) PRD_NRO 
   FROM 
     VDCADFLT
   WHERE  
     VDCADFLT_COD_PROCESSO = 4 AND
     VDCADFLT_DATA >= @DATA_INICIAL AND 
     VDCADFLT_HORA >= @HORA_INICIAL) VDCADFLT 
   ON 
     PRD_FAM = VDPRDPRD_CFAM AND 
     PRD_NRO = VDPRDPRD_NRO  
WHERE
  vdprdprd_cfam > @CODIGO_FAMILIA AND 
  vdprdprd_nro > @CODIGO_SEQUENCIA AND 
  (vdprdprd_codr = @CODIGO_PROD OR @CODIGO_PROD = 0);
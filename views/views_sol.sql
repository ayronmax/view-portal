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
       ELSE 14 
  END CICLO,       
  REPLACE(CAST(MAX(C.DIA_SEMANA_1) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_2) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_3) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_4) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_5) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_6) AS VARCHAR(1)) || CAST(MAX(C.DIA_SEMANA_7) AS VARCHAR(1)), '0', '') VISITA,
  CASE WHEN DAYOFWEEK(CURDATE()) = 1 THEN CURDATE() 
       WHEN DAYOFWEEK(CURDATE()) = 2 THEN CURDATE() 
       WHEN DAYOFWEEK(CURDATE()) = 3 THEN CURDATE() - 1
       WHEN DAYOFWEEK(CURDATE()) = 4 THEN CURDATE() - 2
       WHEN DAYOFWEEK(CURDATE()) = 5 THEN CURDATE() - 3
       WHEN DAYOFWEEK(CURDATE()) = 6 THEN CURDATE() - 4
       WHEN DAYOFWEEK(CURDATE()) = 7 THEN CURDATE() - 5
  END DATA_SEMANA1,   
  CASE WHEN DAYOFWEEK(CURDATE()) = 1 THEN CURDATE() + 7 
       WHEN DAYOFWEEK(CURDATE()) = 2 THEN CURDATE() + 7
       WHEN DAYOFWEEK(CURDATE()) = 3 THEN (CURDATE() - 1) + 7
       WHEN DAYOFWEEK(CURDATE()) = 4 THEN (CURDATE() - 2) + 7 
       WHEN DAYOFWEEK(CURDATE()) = 5 THEN (CURDATE() - 3) + 7
       WHEN DAYOFWEEK(CURDATE()) = 6 THEN (CURDATE() - 4) + 7
       WHEN DAYOFWEEK(CURDATE()) = 7 THEN (CURDATE() - 5) + 7
  END DATA_SEMANA2
FROM     
  DBCONTROL6506006.CADCLI06 A
INNER JOIN
  DBCONTROL6506006.PASTA_VISITA B ON B.NUMERO_PASTA = A.VDCLICLI_CODPASTA1
INNER JOIN
  DBCONTROL6506006.VW_SOL_DIA_SEMANA C ON C.NUMERO_PASTA = A.VDCLICLI_CODPASTA1
INNER JOIN
  (SELECT
     CAST(LEFT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_REGI,
     CAST(RIGHT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_NUM 
   FROM 
     DBCONTROL6506006.VDCADFLT
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
     DBCONTROL6506006.ROCLI06) E
   ON 
     E.CLI_REGI = A.VDCLICLI_REGI AND 
     E.CLI_NUM = A.VDCLICLI_NUM
INNER JOIN
  DBCONTROL6506006.VW_SOL_CADASTRO_ROTA F ON F.COD_GRP_ANALISE = E.COD_GRP_ANALISE
WHERE
   A.VDCLICLI_CLASSE <> 20 AND    
   (A.VDCLICLI_CODCLICIA = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '')
GROUP BY
  F.DESCRICAO_ROTA,
  A.VDCLICLI_CODCLICIA,
  CASE WHEN B.FREQUENCIA = 'S' THEN 7
       WHEN B.FREQUENCIA = 'Q' THEN 14
       ELSE 14 
  END,
  CASE WHEN DAYOFWEEK(CURDATE()) = 1 THEN CURDATE() 
       WHEN DAYOFWEEK(CURDATE()) = 2 THEN CURDATE() 
       WHEN DAYOFWEEK(CURDATE()) = 3 THEN CURDATE() - 1
       WHEN DAYOFWEEK(CURDATE()) = 4 THEN CURDATE() - 2
       WHEN DAYOFWEEK(CURDATE()) = 5 THEN CURDATE() - 3
       WHEN DAYOFWEEK(CURDATE()) = 6 THEN CURDATE() - 4
       WHEN DAYOFWEEK(CURDATE()) = 7 THEN CURDATE() - 5
  END,   
  CASE WHEN DAYOFWEEK(CURDATE()) = 1 THEN CURDATE() + 7 
       WHEN DAYOFWEEK(CURDATE()) = 2 THEN CURDATE() + 7
       WHEN DAYOFWEEK(CURDATE()) = 3 THEN (CURDATE() - 1) + 7
       WHEN DAYOFWEEK(CURDATE()) = 4 THEN (CURDATE() - 2) + 7 
       WHEN DAYOFWEEK(CURDATE()) = 5 THEN (CURDATE() - 3) + 7
       WHEN DAYOFWEEK(CURDATE()) = 6 THEN (CURDATE() - 4) + 7
       WHEN DAYOFWEEK(CURDATE()) = 7 THEN (CURDATE() - 5) + 7
  END;
  
DECLARE SET VARCHAR(10) @CODIGO_CLIENTE = '';
DECLARE SET INT @DATA_INICIAL = 0;
DECLARE SET INT @HORA_INICIAL = 0;

CREATE OR REPLACE VIEW VW_CLIENTE_LIMITE_CREDITO AS 
SELECT 
  vdclicli_codclicia codigo_cliente, 
  vdclicli_cred_disponivel valor_limite,
   CASE WHEN substring(REPEAT('0',15-LENGTH(CAST(vdclicli_cgc AS VARCHAR(15)))) || CAST(vdclicli_cgc AS VARCHAR(15)),10,4) = '0000' THEN 
            substring(REPEAT('0',15-LENGTH(CAST(vdclicli_cgc AS VARCHAR(15)))) || CAST(vdclicli_cgc AS VARCHAR(15)),1,9) || 
            substring(REPEAT('0',15-LENGTH(CAST(vdclicli_cgc AS VARCHAR(15)))) || CAST(vdclicli_cgc AS VARCHAR(15)),14,2) 
       else
         REPEAT('0',15-LENGTH(CAST(vdclicli_cgc AS VARCHAR(14)))) || CAST(vdclicli_cgc AS VARCHAR(14))
       end cpf_cnpj 
FROM 
  CADCLI01
INNER JOIN
  (SELECT
     CAST(LEFT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_REGI,
     CAST(RIGHT(REPEAT('0',8-LENGTH(TRIM(VDCADFLT_CHAVE_ERP))) || TRIM(VDCADFLT_CHAVE_ERP),4) AS INT) CLI_NUM 
   FROM 
     VDCADFLT
   WHERE  
     VDCADFLT_COD_PROCESSO IN (1) AND
     VDCADFLT_DATA >= @DATA_INICIAL AND 
     VDCADFLT_HORA >= @HORA_INICIAL) VDCADFLT 
   ON 
     CLI_REGI = VDCLICLI_REGI AND 
     CLI_NUM = VDCLICLI_NUM
WHERE
   VDCLICLI_CLASSE <> 20 AND    
   VDCLICLI_CODCLICIA = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = ''
   
DECLARE SET VARCHAR(10) @CODIGO_CLIENTE = '';
DECLARE SET INT @DATA_INICIAL = 0;
DECLARE SET INT @HORA_INICIAL = 0;

CREATE OR REPLACE VIEW VW_SOL_ALT_CONDPAGTO AS
SELECT
  VDCLICLI_CODCLICIA CODIGO_CLIENTE,
  CASE WHEN VDCADTCC_COD_CIA IS NULL
       THEN ''
       ELSE VDCADTCC_COD_CIA
  END TPCOBRANCA,
  CASE WHEN VDCADPAG_CODCIA IS NULL
       THEN ''
       ELSE VDCADPAG_CODCIA
  END CONDPAGTO
FROM
  CADCLI06
LEFT JOIN
  VDCADTCC ON VDCADTCC_COD = VDCLICLI_TPCOBRA
LEFT JOIN
  CONDPG06 ON VDCADPAG_COD = VDCLICLI_CPG
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
  END AS MOTIVOBLOQ,
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

CREATE VIEW VW_SP_SOL_CALENDARIO AS 
SELECT 
  GEGENCAL_MES MES,
  1 DIA_MES,
  GEGENCAL_DD_1 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_1 IN ('N', 'R', 'D') OR GEGENCAL_DD_1 = '' THEN          
         GEGENCAL_FF_1
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  2 DIA_MES,
  GEGENCAL_DD_2 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_2 IN ('N', 'R', 'D')  OR GEGENCAL_DD_2 = '' THEN          
         GEGENCAL_FF_2
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  3 DIA_MES,
  GEGENCAL_DD_3 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_3 IN ('N', 'R', 'D')  OR GEGENCAL_DD_3 = '' THEN          
         GEGENCAL_FF_3
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  4 DIA_MES,
  GEGENCAL_DD_4 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_4 IN ('N', 'R', 'D')  OR GEGENCAL_DD_4 = '' THEN          
         GEGENCAL_FF_4
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  5 DIA_MES,
  GEGENCAL_DD_5 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_5 IN ('N', 'R', 'D')  OR GEGENCAL_DD_5 = '' THEN          
         GEGENCAL_FF_5
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  6 DIA_MES,
  GEGENCAL_DD_6 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_6 IN ('N', 'R', 'D')  OR GEGENCAL_DD_6 = '' THEN          
         GEGENCAL_FF_6
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  7 DIA_MES,
  GEGENCAL_DD_7 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_7 IN ('N', 'R', 'D')  OR GEGENCAL_DD_7 = '' THEN          
         GEGENCAL_FF_7
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  8 DIA_MES,
  GEGENCAL_DD_8 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_8 IN ('N', 'R', 'D')  OR GEGENCAL_DD_8 = '' THEN          
         GEGENCAL_FF_8
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  9 DIA_MES,
  GEGENCAL_DD_9 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_9 IN ('N', 'R', 'D')  OR GEGENCAL_DD_9 = '' THEN
         GEGENCAL_FF_9
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  10 DIA_MES,
  GEGENCAL_DD_10 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_10 IN ('N', 'R', 'D')  OR GEGENCAL_DD_10 = '' THEN          
         GEGENCAL_FF_10
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  11 DIA_MES,
  GEGENCAL_DD_11 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_11 IN ('N', 'R', 'D')  OR GEGENCAL_DD_11 = '' THEN          
         GEGENCAL_FF_11
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  12 DIA_MES,
  GEGENCAL_DD_12 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_12 IN ('N', 'R', 'D')  OR GEGENCAL_DD_12 = '' THEN          
         GEGENCAL_FF_12
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  13 DIA_MES,
  GEGENCAL_DD_13 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_13 IN ('N', 'R', 'D')  OR GEGENCAL_DD_13 = '' THEN          
         GEGENCAL_FF_13
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT   
  GEGENCAL_MES MES,
  14 DIA_MES,
  GEGENCAL_DD_14 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_14 IN ('N', 'R', 'D')  OR GEGENCAL_DD_14 = '' THEN          
         GEGENCAL_FF_14
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  15 DIA_MES,
  GEGENCAL_DD_15 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_15 IN ('N', 'R', 'D')  OR GEGENCAL_DD_15 = '' THEN          
         GEGENCAL_FF_15
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  16 DIA_MES,
  GEGENCAL_DD_16 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_16 IN ('N', 'R', 'D')  OR GEGENCAL_DD_16 = '' THEN          
         GEGENCAL_FF_16
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  17 DIA_MES,
  GEGENCAL_DD_17 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_17 IN ('N', 'R', 'D')  OR GEGENCAL_DD_17 = '' THEN          
         GEGENCAL_FF_17
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  18 DIA_MES,
  GEGENCAL_DD_18 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_18 IN ('N', 'R', 'D')  OR GEGENCAL_DD_18 = '' THEN          
         GEGENCAL_FF_18
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  19 DIA_MES,
  GEGENCAL_DD_19 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_19 IN ('N', 'R', 'D')  OR GEGENCAL_DD_19 = '' THEN          
         GEGENCAL_FF_19
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  20 DIA_MES,
  GEGENCAL_DD_20 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_20 IN ('N', 'R', 'D')  OR GEGENCAL_DD_20 = '' THEN          
         GEGENCAL_FF_20
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT
  GEGENCAL_MES MES,
  21 DIA_MES,
  GEGENCAL_DD_21 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_21 IN ('N', 'R', 'D')  OR GEGENCAL_DD_21 = '' THEN          
         GEGENCAL_FF_21
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  22 DIA_MES,
  GEGENCAL_DD_22 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_22 IN ('N', 'R', 'D')  OR GEGENCAL_DD_22 = '' THEN          
         GEGENCAL_FF_22
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  23 DIA_MES,
  GEGENCAL_DD_23 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_23 IN ('N', 'R', 'D')  OR GEGENCAL_DD_23 = ''THEN          
         GEGENCAL_FF_23
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  24 DIA_MES,
  GEGENCAL_DD_24 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_24 IN ('N', 'R', 'D')  OR GEGENCAL_DD_24 = '' THEN          
         GEGENCAL_FF_24
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  25 DIA_MES,
  GEGENCAL_DD_25 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_25 IN ('N', 'R', 'D')  OR GEGENCAL_DD_25 = '' THEN          
         GEGENCAL_FF_25
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  26 DIA_MES,
  GEGENCAL_DD_26 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_26 IN ('N', 'R', 'D')  OR GEGENCAL_DD_26 = '' THEN          
         GEGENCAL_FF_26
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  27 DIA_MES,
  GEGENCAL_DD_27 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_27 IN ('N', 'R', 'D')  OR GEGENCAL_DD_27 = '' THEN          
         GEGENCAL_FF_27
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  28 DIA_MES,
  GEGENCAL_DD_28 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_28 IN ('N', 'R', 'D')  OR GEGENCAL_DD_28 = '' THEN          
         GEGENCAL_FF_28
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  29 DIA_MES,
  GEGENCAL_DD_29 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_29 IN ('N', 'R', 'D')  OR GEGENCAL_DD_29 = '' THEN          
         GEGENCAL_FF_29
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  30 DIA_MES,
  GEGENCAL_DD_30 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_30 IN ('N', 'R', 'D')  OR GEGENCAL_DD_30 = '' THEN          
         GEGENCAL_FF_30
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21
UNION ALL
SELECT 
  GEGENCAL_MES MES,
  31 DIA_MES,
  GEGENCAL_DD_31 DIA_SEMANA,
  CASE WHEN GEGENCAL_FF_31 IN ('N', 'R', 'D')  OR GEGENCAL_DD_31 = '' THEN          
         GEGENCAL_FF_31
       ELSE
         'S'     
  END DIA_UTIL
FROM CALEND21

ORDER BY MES, DIA_MES;

CREATE VIEW SP_SOL_CALENDARIO_REGIONAL AS
SELECT 
  'XYZ' I_CENTRO,
  TO_DATE(LEFT(CAST(CURDATE() AS VARCHAR(10)), 4) || REPEAT('0', 2-LENGTH(CAST(MES AS VARCHAR(2)))) || CAST(MES AS VARCHAR(2)) || REPEAT('0', 2-LENGTH(CAST(DIA_MES AS VARCHAR(2)))) || CAST(DIA_MES AS VARCHAR(2)), 'YYYYMMDD') I_DATCAL,
  'FERIADO REGIONAL' I_DATA_MOT
FROM 
  VW_SP_SOL_CALENDARIO
WHERE 
  DIA_UTIL = 'R';
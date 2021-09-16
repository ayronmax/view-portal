CREATE OR REPLACE PROCEDURE SP_TM_PRE_PAGAMENTO(IN NREMP SMALLINT,
                                                IN CNPJ VARCHAR(15),
                                                IN TITULO CHAR(8),
                                                IN PARCELA CHAR(1),
                                                IN TIPO SMALLINT,
                                                IN EMISSAO INT,
                                                IN VENCIMENTO INT,
                                                IN PAGAMENTO  INT,
                                                IN VALOR DECIMAL(13,2),
                                                IN VALOR_PGTO DECIMAL(13,2),
                                                IN BANDEIRA VARCHAR(20),
                                                IN NUMERO_PEDIDO DECIMAL(12,0),
                                                IN PERCTRANSACAO DECIMAL(7,4),
                                                IN dataOperacao INTEGER,
                                                IN horaOperacao SMALLINT,      
                                                OUT COD_ERRO SMALLINT,
                                                OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN
  DECLARE COD_CLI INT;
  DECLARE PRE_PAG VARCHAR(8);

  IF NREMP IS NULL THEN
     SET NREMP = SELECT VDPAROCO_CODEMP FROM PAROCO03 LIMIT 1;
  END IF;

  SET COD_CLI = SELECT
                  CAST(REPEAT('0', 4 - LENGTH(CAST(VDCLICLI_REGI AS VARCHAR(4)))) ||
                  CAST(VDCLICLI_REGI AS VARCHAR(4)) ||
                  REPEAT('0', 4 - LENGTH(CAST(VDCLICLI_NUM AS VARCHAR(4)))) ||
                  CAST(VDCLICLI_NUM AS VARCHAR(4)) AS INT)
                FROM
                  CADCLI03
                WHERE
                  VDCLICLI_CGC = CAST(CNPJ AS DECIMAL(15));
   SET PRE_PAG = SELECT
                  CRMOVPRE_NDUPL
                FROM
                  CRMOVPRE
                WHERE
                  CRMOVPRE_NREMP = NREMP AND
                  CRMOVPRE_COD_CLI = COD_CLI AND
                  CRMOVPRE_NDUPL = TITULO || SPACE(8 - LENGTH(TITULO)) || PARCELA AND
                  CRMOVPRE_TPLANC = TIPO;

  IF PRE_PAG IS NULL THEN
     INSERT INTO CRMOVPRE (CRMOVPRE_NREMP,
                           CRMOVPRE_COD_CLI,
                           CRMOVPRE_NDUPL,
                           CRMOVPRE_TPLANC,
                           CRMOVPRE_LOGDT,
                           CRMOVPRE_INCLDT,
                           CRMOVPRE_INCLHR,
                           CRMOVPRE_INCLSIGLA,
                           CRMOVPRE_ALTEDT,
                           CRMOVPRE_ALTEHR,
                           CRMOVPRE_ALTESIGLA,
                           CRMOVPRE_CANCDT,
                           CRMOVPRE_CANCHR,
                           CRMOVPRE_CANCSIGLA,
                           CRMOVPRE_CANCSN,
                           CRMOVPRE_NIVELAUDIT,
                           CRMOVPRE_DT_EMIS,
                           CRMOVPRE_DT_VENC,
                           CRMOVPRE_DT_PGTO,
                           CRMOVPRE_VLR_TITULO,
                           CRMOVPRE_VLR_PGTO,
                           CRMOVPRE_PER_JUROS,
                           CRMOVPRE_VLR_JUROS,
                           CRMOVPRE_PER_MORA,
                           CRMOVPRE_VLR_MORA,
                           CRMOVPRE_PER_DESC,
                           CRMOVPRE_VLR_DESC,
                           CRMOVPRE_PER_TRANSACAO,
                           CRMOVPRE_VLR_TRANSACAO,
                           CRMOVPRE_COD_TRANSACAO,
                           CRMOVPRE_NUM_BOLETO,
                           CRMOVPRE_BX_USUARIO,
                           CRMOVPRE_BX_DATA,
                           CRMOVPRE_BX_HORA,
                           CRMOVPRE_BX_MSG1,
                           CRMOVPRE_BX_MSG2,
                           CRMOVPRE_BANDEIRA,
                           CRMOVPRE_NPED,
                           CRMOVPRE_NF,
                           CRMOVPRE_SERIE,
                           CRMOVPRE_NFMODELO,
                           CRMOVPRE_VLR_TX_COBRADA,
                           CRMOVPRE_CREDENCIADORA,
                           CRMOVPRE_4_DIGITOS,
                           CRMOVPRE_NUMDOC,
                           CRMOVPRE_ACQUIRER_ID)
                   VALUES (NREMP,
                           COD_CLI,
                           TITULO || SPACE(8 - LENGTH(TITULO)) || PARCELA,
                           TIPO,
                           CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT),
                           CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT),
                           CAST(LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4) AS INT),
                           'TdM',
                           0,
                           0,
                           '',
                           0,
                           0,
                           '',
                           0,
                           0,
                           EMISSAO,
                           VENCIMENTO,
                           PAGAMENTO,
                           VALOR,
                           VALOR_PGTO,
                           0,
                           0,
                           0,
                           0,
                           0,
                           0,
                           PERCTRANSACAO,
                           VALOR - VALOR_PGTO,
                           '',
                           '',
                           '',
                           0,
                           0,
                           '',
                           '',
                           BANDEIRA,
                           NUMERO_PEDIDO,
                           0,
                           '',
                           '',
                           0,
                           '',
                           '',
                           '',
                           '');

     UPDATE
       VDPEDTMC
     SET
       VDPEDTMC_OPER_ID_STT = 3,
       VDPEDTMC_RECO_DT_RET = dataOperacao,
       VDPEDTMC_RECO_HR_RET = horaOperacao
     WHERE 
       VDPEDTMC_NREMP = NREMP AND
       VDPEDTMC_NPED = NUMERO_PEDIDO AND
       VDPEDTMC_OPER_ID_STT = 1;                     

     SET COD_ERRO = 0;
     SET MSG_ERRO = 'Pre-pagamento incluido com sucesso!';                     
  ELSE
     UPDATE 
       CRMOVPRE
     SET
       CRMOVPRE_LOGDT = CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT),
       CRMOVPRE_ALTEDT = CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT),
       CRMOVPRE_ALTEHR = CAST(LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4) AS INT),
       CRMOVPRE_ALTESIGLA = 'TdM',
       CRMOVPRE_DT_EMIS = EMISSAO,
       CRMOVPRE_DT_VENC = VENCIMENTO,
       CRMOVPRE_VLR_TITULO = VALOR
     WHERE
       CRMOVPRE_NREMP = NREMP AND
       CRMOVPRE_COD_CLI = COD_CLI AND
       CRMOVPRE_NDUPL = TITULO || SPACE(8 - LENGTH(TITULO)) || PARCELA AND
       CRMOVPRE_TPLANC = TIPO;

     UPDATE
       VDPEDTMC
     SET
       VDPEDTMC_LOGDT = CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT),
       VDPEDTMC_ALTEDT = CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT),
       VDPEDTMC_ALTEHR = CAST(LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4) AS INT),
       VDPEDTMC_ALTESIGLA = 'TdM',
       VDPEDTMC_OPER_ID_STT = 3,
       VDPEDTMC_RECO_DT_RET = dataOperacao,
       VDPEDTMC_RECO_HR_RET = horaOperacao       
     WHERE 
       VDPEDTMC_NREMP = NREMP AND
       VDPEDTMC_NPED = NUMERO_PEDIDO AND
       VDPEDTMC_OPER_ID_STT = 0;

     SET COD_ERRO = 0;
     SET MSG_ERRO = 'Pre-pagamento alterado com sucesso!';
  END IF;
END;                                                                               
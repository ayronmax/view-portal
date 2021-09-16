CREATE OR REPLACE PROCEDURE SP_TM_APIOPERATION_CAPA(IN NREMP SMALLINT,
                                                    IN NPED DECIMAL(12,0),
                                                    IN OperationId INTEGER,
                                                    IN success SMALLINT,
                                                    IN reason CHAR(100),
                                                    IN authorizationStatus CHAR(40),
                                                    IN dataOperacao INTEGER,
                                                    IN horaOperacao SMALLINT,                                            
                                                    OUT COD_ERRO SMALLINT,
                                                    OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN
  DECLARE PEDIDO_CAPA DECIMAL(12,0);

  SET PEDIDO_CAPA = SELECT 
                      VDPEDTMC_NPED 
                    FROM 
                      VDPEDTMC 
                    WHERE 
                      VDPEDTMC_NREMP = NREMP AND
                      VDPEDTMC_NPED = NPED;

  IF PEDIDO_CAPA IS NOT NULL THEN
     IF OperationId > 0 THEN 
        UPDATE 
          VDPEDTMC 
        SET
          VDPEDTMC_LOGDT = CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT), 
          VDPEDTMC_ALTEDT = CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT),
          VDPEDTMC_ALTEHR = CAST(LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4) AS INT),
          VDPEDTMC_ALTESIGLA = 'TdM', 
          VDPEDTMC_OPER_ID = OperationId,
          VDPEDTMC_OPER_ID_STT = success,
          VDPEDTMC_OPER_ID_STT_MOTV = reason,
          VDPEDTMC_OPER_STT_AUTORIZ = authorizationStatus,
          VDPEDTMC_OPER_DT_RET = CASE WHEN success = 1 THEN dataOperacao ELSE 0 END,
          VDPEDTMC_OPER_HR_RET = CASE WHEN success = 1 THEN horaOperacao ELSE 0 END,
          VDPEDTMC_RECO_DT_RET = CASE WHEN success = 3 THEN dataOperacao ELSE 0 END,
          VDPEDTMC_RECO_HR_RET = CASE WHEN success = 3 THEN horaOperacao ELSE 0 END,
          VDPEDTMC_EXCE_DT_RET = CASE WHEN success = 4 THEN dataOperacao ELSE 0 END,
          VDPEDTMC_EXCE_HR_RET = CASE WHEN success = 4 THEN horaOperacao ELSE 0 END
        WHERE
          VDPEDTMC_NREMP = NREMP AND
          VDPEDTMC_NPED = NPED;
     ELSE  
        UPDATE 
          VDPEDTMC 
        SET
          VDPEDTMC_LOGDT = CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT), 
          VDPEDTMC_ALTEDT = CAST(REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') AS INT),
          VDPEDTMC_ALTEHR = CAST(LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4) AS INT),
          VDPEDTMC_ALTESIGLA = 'TdM', 
          VDPEDTMC_OPER_ID_STT = success,
          VDPEDTMC_OPER_ID_STT_MOTV = reason,
          VDPEDTMC_OPER_DT_RET = CASE WHEN success = 1 THEN dataOperacao ELSE 0 END,
          VDPEDTMC_OPER_HR_RET = CASE WHEN success = 1 THEN horaOperacao ELSE 0 END,
          VDPEDTMC_RECO_DT_RET = CASE WHEN success = 3 THEN dataOperacao ELSE 0 END,
          VDPEDTMC_RECO_HR_RET = CASE WHEN success = 3 THEN horaOperacao ELSE 0 END,
          VDPEDTMC_EXCE_DT_RET = CASE WHEN success = 4 THEN dataOperacao ELSE 0 END,
          VDPEDTMC_EXCE_HR_RET = CASE WHEN success = 4 THEN horaOperacao ELSE 0 END
        WHERE
          VDPEDTMC_NREMP = NREMP AND
          VDPEDTMC_NPED = NPED;  
     END IF;
     
     SET COD_ERRO = 0;
     SET MSG_ERRO = 'Atualizado com sucesso!';        
  ELSE
     SET COD_ERRO = 1;
     SET MSG_ERRO = 'Pedido nao localizado!';
  END IF;
END;
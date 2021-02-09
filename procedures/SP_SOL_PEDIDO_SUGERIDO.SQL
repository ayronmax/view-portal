CREATE OR REPLACE PROCEDURE SP_SOL_PEDIDO_SUGERIDO(IN ORGIN CHAR(4),
                                                   IN DT_REAL DATE,
                                                   IN CDPEDS CHAR(25),
                                                   IN WEEKS CHAR(4),                                                    
				                   IN CDCL CHAR(10),				                   
				                   IN CDPROD CHAR(18),
				                   IN ZROTA CHAR(5),
				                   IN QTSUG DECIMAL(13,3),
				                   IN MTV_BLQ CHAR(4),
				                   OUT COD_ERRO SMALLINT,
				                   OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN
  IF CDCL IS NOT NULL THEN
     IF CDPROD IS NOT NULL THEN
        DECLARE strUser VARCHAR(20);
        DECLARE strSql VARCHAR(1000);
        DECLARE intCodCli INTEGER;
        DECLARE intCodPro INTEGER;
        DECLARE strDataProc VARCHAR(10);
        DECLARE strHoraProc VARCHAR(8);
         
        SET strUser = SELECT TRIM(CURRENT_USER);
   
        SET strSql = 'SELECT CAST(REPEAT(' || '''0''' || ',4-LENGTH(CAST(VDCLICLI_REGI AS VARCHAR(4)))) || CAST(VDCLICLI_REGI AS VARCHAR(4)) ||';
        SET strSql = strSql || ' REPEAT(' || '''0''' || ',4-LENGTH(CAST(VDCLICLI_NUM AS VARCHAR(4)))) || CAST(VDCLICLI_NUM AS VARCHAR(4)) AS INT) CODIGO_CLIENTE';
        SET strSql = strSql || ' FROM ' || strUser || '.CADCLI06';
        SET strSql = strSql || ' WHERE VDCLICLI_CODCLICIA = ' || '''' || CDCL || '''';
  
        PREPARE stmt FROM strSql;
        EXECUTE stmt INTO intCodCli;
        DEALLOCATE PREPARE stmt;
  
        IF intCodCli IS NOT NULL THEN
           SET strSql = 'SELECT CAST(REPEAT(' || '''0''' || ',3-LENGTH(CAST(VDPRDPRD_CFAM AS VARCHAR(3)))) || CAST(VDPRDPRD_CFAM AS VARCHAR(3)) ||';
           SET strSql = strSql || ' REPEAT(' || '''0''' || ',3-LENGTH(CAST(VDPRDPRD_NRO AS VARCHAR(3)))) || CAST(VDPRDPRD_NRO AS VARCHAR(3)) AS INT) CODIGO_PRODUTO';
           SET strSql = strSql || ' FROM ' || strUser || '.CADPRD06';
           SET strSql = strSql || ' WHERE VDPRDPRD_CODCMP = ' || '''' || LEFT(CDPROD, 10) || '''';
  
           PREPARE stmt1 FROM strSql;
           EXECUTE stmt1 INTO intCodPro;
           DEALLOCATE PREPARE stmt1;
     
           IF intCodPro IS NOT NULL THEN
              SET strDataProc = REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '');
              SET strHoraProc = LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4);
              
              SET strSql = 'INSERT OR REPLACE INTO ' || strUser || '.CLCVTE06';
              SET strSql = strSql || ' (VDCLCVTE_CODCLI,'; 
              SET strSql = strSql || 'VDCLCVTE_CODPRD,';
              SET strSql = strSql || 'VDCLCVTE_LOGDT,';
              SET strSql = strSql || 'VDCLCVTE_INCLDT,';
              SET strSql = strSql || 'VDCLCVTE_INCLHR,';
              SET strSql = strSql || 'VDCLCVTE_INCLSIGLA,';
              SET strSql = strSql || 'VDCLCVTE_ALTEDT,';
              SET strSql = strSql || 'VDCLCVTE_ALTEHR,';
              SET strSql = strSql || 'VDCLCVTE_ALTESIGLA,';
              SET strSql = strSql || 'VDCLCVTE_CANCDT,';
              SET strSql = strSql || 'VDCLCVTE_CANCHR,';
              SET strSql = strSql || 'VDCLCVTE_CANCSIGLA,';
              SET strSql = strSql || 'VDCLCVTE_CANCSN,';
              SET strSql = strSql || 'VDCLCVTE_NIVELAUDIT,';
              SET strSql = strSql || 'VDCLCVTE_CIA_QTDCX,';
              SET strSql = strSql || 'VDCLCVTE_CIA_QTDUN,';
              SET strSql = strSql || 'VDCLCVTE_CEV_QTDCX,';
              SET strSql = strSql || 'VDCLCVTE_CEV_QTDUN,';
              SET strSql = strSql || 'VDCLCVTE_HIS_QTDCX,';
              SET strSql = strSql || 'VDCLCVTE_HIS_QTDUN,';
              SET strSql = strSql || 'VDCLCVTE_VIS_QTDMES,';
              SET strSql = strSql || 'VDCLCVTE_VIS_QTD_REAL,';
              SET strSql = strSql || 'VDCLCVTE_VIS_QTD_ACUMP,';
              SET strSql = strSql || 'VDCLCVTE_SUG_QTDCX,';
              SET strSql = strSql || 'VDCLCVTE_SUG_QTDUN,';
              SET strSql = strSql || 'VDCLCVTE_QTD_PEDIDOS,';
              SET strSql = strSql || 'VDCLCVTE_PROC_EXIG_ID,';
              SET strSql = strSql || 'VDCLCVTE_QTD_DIAS_FAT,';
              SET strSql = strSql || 'VDCLCVTE_ORIGEM_PROD,';
              SET strSql = strSql || 'VDCLCVTE_ORIGEM_INFO)';
              SET strSql = strSql || ' VALUES (';
              SET strSql = strSql || CAST(intCodCli AS VARCHAR(8)) || ',';             
              SET strSql = strSql || CAST(intCodPro AS VARCHAR(6)) || ',';
              SET strSql = strSql || strDataProc || ',';
              SET strSql = strSql || strDataProc || ',';
              SET strSql = strSql || strHoraProc || ',';
              SET strSql = strSql || '''' || 'SAP' || '''' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '''' || ' ' || '''' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '''' || ' ' || '''' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || CAST(CAST(QTSUG AS INT) AS VARCHAR(7)) || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '1' || ',';
              SET strSql = strSql || '99999' || ',';
              SET strSql = strSql || '30' || ',';
              SET strSql = strSql || '''' || ORGIN || '''' || ',';
              SET strSql = strSql || '''' || 'S' || '''' || ')';
              
              EXECUTE IMMEDIATE strSql;
                      
              SET COD_ERRO = 0;
              SET MSG_ERRO = 'Pedido Sugerido inserido com sucesso!';
           ELSE
              SET COD_ERRO = 1;
              SET MSG_ERRO = 'Código Produto Cia ' || CDPROD || ' não localizado!';
           END IF;
        ELSE
           SET COD_ERRO = 1;
           SET MSG_ERRO = 'Código Cliente Cia ' || CDCL || ' não localizado!';       
        END IF;
     ELSE
        SET COD_ERRO = 1;
        SET MSG_ERRO = 'Código Produto Cia é obrigatório!';
     END IF;   
  ELSE
     SET COD_ERRO = 1;
     SET MSG_ERRO = 'Código Cliente Cia é obrigatório!';
  END IF;   
END;
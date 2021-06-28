CREATE OR REPLACE PROCEDURE SP_SOL_INVENTARIO_SUGERIDO(IN CDPROD CHAR(25),
                                                       IN CDUNPR CHAR(25),
                                                       IN QTSUG INTEGER,
                                                       IN CDUNID CHAR(25),
                                                       IN CDROTA CHAR(25),
                                                       IN CDUSU CHAR(25),
                                                       IN CDPEDS CHAR(25),
                                                       IN QTDEST INTEGER,
                                                       IN UDFTIV CHAR(36),
                                                       IN DTPROC DATE,
                                                       IN NUPROC CHAR(25),
                                                       IN IDSIMP CHAR(1),
                                                       IN QTDSIN INTEGER,
                                                       IN QTDSLC INTEGER,
                                                       IN QTDSFN INTEGER,
                                                       IN NUPED CHAR(36),
                                                       IN CDTAB CHAR(25),                                     
				                       IN CDCL CHAR(36),
				                       OUT COD_ERRO SMALLINT,
				                       OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN
  IF CDCL IS NOT NULL THEN
     IF CDPROD IS NOT NULL THEN
        DECLARE strUser VARCHAR(20);
        DECLARE intNumEmp SMALLINT;
        DECLARE strSql VARCHAR(2000);
        DECLARE intCodCli INTEGER;
        DECLARE decCodPro DECIMAL(10,0);
        DECLARE strDataProc VARCHAR(10);
        DECLARE strHoraProc VARCHAR(8);
        DECLARE strDiaSemana VARCHAR(2);
        DECLARE strCodVen VARCHAR(3);
         
        SET strUser = SELECT TRIM(CURRENT_USER);
        
        SET strSql = 'SELECT VDPAROCO_CODEMP FROM ' || strUser || '.PAROCO06';
  
        PREPARE stmt FROM strSql;
        EXECUTE stmt INTO intNumEmp;
        DEALLOCATE PREPARE stmt;
  
        IF intNumEmp IS NULL THEN
           SET intNumEmp = 1;
        END IF;
  
        SET strSql = 'SELECT CAST(REPEAT(' || '''0''' || ',4-LENGTH(CAST(VDCLICLI_REGI AS VARCHAR(4)))) || CAST(VDCLICLI_REGI AS VARCHAR(4)) ||';
        SET strSql = strSql || ' REPEAT(' || '''0''' || ',4-LENGTH(CAST(VDCLICLI_NUM AS VARCHAR(4)))) || CAST(VDCLICLI_NUM AS VARCHAR(4)) AS INT) CODIGO_CLIENTE,';
        SET strSql = strSql || ' VDCLICLI_VEN CODIGO_VENDEDOR';
        SET strSql = strSql || ' FROM ' || strUser || '.CADCLI06';
        SET strSql = strSql || ' WHERE VDCLICLI_CODCLICIA = ' || '''' || LEFT(CDCL, 12) || '''';
  
        PREPARE stmt1 FROM strSql;
        EXECUTE stmt1 INTO intCodCli, strCodVen;
        DEALLOCATE PREPARE stmt1;
  
        IF intCodCli IS NOT NULL THEN
           SET strSql = 'SELECT VDPRDPRD_CODR CODIGO_PRODUTO';
           SET strSql = strSql || ' FROM ' || strUser || '.CADPRD06';
           SET strSql = strSql || ' WHERE VDPRDPRD_CODCMP = ' || '''' || LEFT(CDPROD, 10) || '''';
  
           PREPARE stmt2 FROM strSql;
           EXECUTE stmt2 INTO decCodPro;
           DEALLOCATE PREPARE stmt2;
     
           IF decCodPro IS NOT NULL THEN
              SET strDataProc = REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '');
              SET strHoraProc = LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4);
              SET strDiaSemana = REPEAT('0', 2-LENGTH(CAST(DAYOFWEEK(CURDATE()) AS VARCHAR(2)))) || CAST(DAYOFWEEK(CURDATE()) AS VARCHAR(2));
              
              SET strSql = 'INSERT OR REPLACE INTO ' || strUser || '.VDPEDINV';
              SET strSql = strSql || ' (VDPEDINV_NREMP,'; 
              SET strSql = strSql || 'VDPEDINV_CODCLI,';
              SET strSql = strSql || 'VDPEDINV_DIA,';
              SET strSql = strSql || 'VDPEDINV_CODVEN,';
              SET strSql = strSql || 'VDPEDINV_SEQCRG,';
              SET strSql = strSql || 'VDPEDINV_DATAPED,';
              SET strSql = strSql || 'VDPEDINV_HORAPED,';
              SET strSql = strSql || 'VDPEDINV_CODR_PRODUTO,';
              SET strSql = strSql || 'VDPEDINV_LOGDT,';
              SET strSql = strSql || 'VDPEDINV_INCLDT,';
              SET strSql = strSql || 'VDPEDINV_INCLHR,';
              SET strSql = strSql || 'VDPEDINV_INCLSIGLA,';
              SET strSql = strSql || 'VDPEDINV_ALTEDT,';
              SET strSql = strSql || 'VDPEDINV_ALTEHR,';
              SET strSql = strSql || 'VDPEDINV_ALTESIGLA,';
              SET strSql = strSql || 'VDPEDINV_CANCDT,';
              SET strSql = strSql || 'VDPEDINV_CANCHR,';
              SET strSql = strSql || 'VDPEDINV_CANCSIGLA,';
              SET strSql = strSql || 'VDPEDINV_CANCSN,';
              SET strSql = strSql || 'VDPEDINV_NIVELAUDIT,';
              SET strSql = strSql || 'VDPEDINV_DATACOLETA,';
              SET strSql = strSql || 'VDPEDINV_HORACOLETA,';
              SET strSql = strSql || 'VDPEDINV_PEDIDO,';
              SET strSql = strSql || 'VDPEDINV_HORI,';
              SET strSql = strSql || 'VDPEDINV_QTDE_CHEIO,';
              SET strSql = strSql || 'VDPEDINV_QTDE_VAZIO,';
              SET strSql = strSql || 'VDPEDINV_HOUVE_DIVERGENCIA,';
              SET strSql = strSql || 'VDPEDINV_NOME_FOTO_PROD,';
              SET strSql = strSql || 'VDPEDINV_NOME_FOTO_JUST,';
              SET strSql = strSql || 'VDPEDINV_CODJUSTIFICATIVA,';
              SET strSql = strSql || 'VDPEDINV_OBSERVACAO,';
              SET strSql = strSql || 'VDPEDINV_QTDE_SUG,';
              SET strSql = strSql || 'VDPEDINV_QTDE_MAX_VALIDADOR,';
              SET strSql = strSql || 'VDPEDINV_QTDE_DIVERGENCIA,';
              SET strSql = strSql || 'VDPEDINV_QTDE_SUG_CTG,';
              SET strSql = strSql || 'VDPEDINV_QTDE_SUG_LIM,';
              SET strSql = strSql || 'VDPEDINV_QTDE_VENDIDA,';
              SET strSql = strSql || 'VDPEDINV_TEVE_MOTNC,';
              SET strSql = strSql || 'VDPEDINV_COD_MOTNC,';
              SET strSql = strSql || 'VDPEDINV_ORIGEM_INFO)';
              SET strSql = strSql || ' VALUES (';
              SET strSql = strSql || CAST(intNumEmp AS VARCHAR(2)) || ',';
              SET strSql = strSql || CAST(intCodCli AS VARCHAR(8)) || ',';
              SET strSql = strSql || '''' || strDiaSemana || '''' ||  ',';
              SET strSql = strSql || '''' || strCodVen || '''' ||  ',';
              SET strSql = strSql || '1' || ',';
              SET strSql = strSql || strDataProc || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || CAST(decCodPro AS VARCHAR(10)) || ',';              
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
              SET strSql = strSql || strDataProc || ',';              
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || CAST(QTDEST AS VARCHAR(7)) || ',';              
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '''' || ' ' || '''' || ',';
              SET strSql = strSql || '''' || ' ' || '''' || ',';
              SET strSql = strSql || '''' || ' ' || '''' || ',';
              SET strSql = strSql || '''' || ' ' || '''' || ',';
              SET strSql = strSql || CAST(QTSUG AS VARCHAR(7)) || ',';              
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || '0' || ',';
              SET strSql = strSql || CAST(QTDSIN AS VARCHAR(7)) || ',';
              SET strSql = strSql || CAST(QTDSLC AS VARCHAR(7)) || ',';
              SET strSql = strSql || CAST(QTDSFN AS VARCHAR(7)) || ',';
              SET strSql = strSql || '''' || 'N' || '''' || ',';
              SET strSql = strSql || '''' || ' ' || '''' || ',';
              SET strSql = strSql || '''' || 'S' || '''' || ')';
              
              EXECUTE IMMEDIATE strSql;
                      
              SET COD_ERRO = 0;
              SET MSG_ERRO = 'Inventário Sugerido inserido com sucesso!';
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
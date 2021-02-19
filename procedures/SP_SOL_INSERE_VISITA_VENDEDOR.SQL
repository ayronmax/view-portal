CREATE OR REPLACE PROCEDURE SP_SOL_INSERE_VISITA_VENDEDOR(IN WERKS CHAR(4),
                                                          IN KUNNR CHAR(10),
                                                          IN NAME1 CHAR(30),
                                                          IN VPTYP CHAR(3),
                                                          IN ROUTE CHAR(6),
                                                          IN SEQU  SMALLINT,
                                                          IN EXDAT DATE,
                                                          IN DOW CHAR(20),
                                                          IN ERDAT DATE,
                                                          IN ERZET TIME,
                                                          OUT COD_ERRO SMALLINT,
				                          OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN
  IF KUNNR IS NOT NULL THEN
     DECLARE strUser VARCHAR(20);
     DECLARE strSql VARCHAR(2000);
     DECLARE intCodCli INTEGER;
     DECLARE strDataProc VARCHAR(10);
     DECLARE strHoraProc VARCHAR(8);
     DECLARE strDataVisita VARCHAR(10);
     DECLARE strCodVen VARCHAR(3);
         
     SET strUser = SELECT TRIM(CURRENT_USER);
     
     SET strSql = 'SELECT CAST(REPEAT(' || '''0''' || ',4-LENGTH(CAST(VDCLICLI_REGI AS VARCHAR(4)))) || CAST(VDCLICLI_REGI AS VARCHAR(4)) ||';
     SET strSql = strSql || ' REPEAT(' || '''0''' || ',4-LENGTH(CAST(VDCLICLI_NUM AS VARCHAR(4)))) || CAST(VDCLICLI_NUM AS VARCHAR(4)) AS INT) CODIGO_CLIENTE,';
     SET strSql = strSql || ' VDCLICLI_VEN CODIGO_VENDEDOR';
     SET strSql = strSql || ' FROM ' || strUser || '.CADCLI06';
     SET strSql = strSql || ' WHERE VDCLICLI_CODCLICIA = ' || '''' || KUNNR || '''';
  
     PREPARE stmt FROM strSql;
     EXECUTE stmt INTO intCodCli, strCodVen;
     DEALLOCATE PREPARE stmt;
  
     IF intCodCli IS NOT NULL THEN
        SET strDataProc = REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '');        
        SET strHoraProc = LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4);
        SET strDataVisita = REPLACE(CAST(EXDAT AS VARCHAR(10)), '-', '');
            
        SET strSql = 'INSERT OR REPLACE INTO ' || strUser || '.VDCLSV06';
        SET strSql = strSql || ' (VDCLISVI_CODCLI,'; 
        SET strSql = strSql || 'VDCLISVI_DTVISITA,';
        SET strSql = strSql || 'VDCLISVI_SEQVISITA,';
        SET strSql = strSql || 'VDCLISVI_LOGDT,';
        SET strSql = strSql || 'VDCLISVI_INCLDT,';
        SET strSql = strSql || 'VDCLISVI_INCLHR,';
        SET strSql = strSql || 'VDCLISVI_INCLSIGLA,';
        SET strSql = strSql || 'VDCLISVI_ALTEDT,';
        SET strSql = strSql || 'VDCLISVI_ALTEHR,';
        SET strSql = strSql || 'VDCLISVI_ALTESIGLA,';
        SET strSql = strSql || 'VDCLISVI_CANCDT,';
        SET strSql = strSql || 'VDCLISVI_CANCHR,';
        SET strSql = strSql || 'VDCLISVI_CANCSIGLA,';
        SET strSql = strSql || 'VDCLISVI_CANCSN,';
        SET strSql = strSql || 'VDCLISVI_NIVELAUDIT,';
        SET strSql = strSql || 'VDCLISVI_CODVEN,';
        SET strSql = strSql || 'VDCLISVI_HORAVISITA_INI,';
        SET strSql = strSql || 'VDCLISVI_HORAVISITA_FIM,';
        SET strSql = strSql || 'VDCLISVI_DURAVISITA,';
        SET strSql = strSql || 'VDCLISVI_PROG_ORIGEM)';
        SET strSql = strSql || ' VALUES (';
        SET strSql = strSql || CAST(intCodCli AS VARCHAR(8)) || ',';
        SET strSql = strSql || strDataVisita || ',';
        SET strSql = strSql || CAST(SEQU AS VARCHAR(4)) ||  ',';
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
        SET strSql = strSql || '''' || strCodVen || '''' ||  ',';
        SET strSql = strSql || '0' || ',';
        SET strSql = strSql || '0' || ',';
        SET strSql = strSql || '0' || ',';
        SET strSql = strSql || '''' || ' ' || '''' || ')';
            
        EXECUTE IMMEDIATE strSql;
                  
        SET COD_ERRO = 0;
        SET MSG_ERRO = 'Visita Vendedor inserido com sucesso!';
     ELSE
        SET COD_ERRO = 1;
        SET MSG_ERRO = 'Código Cliente Cia ' || KUNNR || ' não localizado!';       
     END IF;   
  ELSE
     SET COD_ERRO = 1;
     SET MSG_ERRO = 'Código Cliente Cia é obrigatório!';
  END IF;   
END;
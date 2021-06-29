CREATE OR REPLACE PROCEDURE SP_LANC_MOV_ESTOQUE(IN CODIGO_PRODUTO INTEGER,
                                                IN SAIDAS INTEGER,
                                                IN ENTRADAS INTEGER,
                                                IN CODIGO_ORDEM_PRODUTO INTEGER,
                                                IN DATA_MOVIMENTACAO DATE,
                                                OUT COD_ERRO SMALLINT,
                                                OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN  
  DECLARE dataAtual DATE;
  DECLARE intNumEmp SMALLINT;
  DECLARE intDataEstoque INTEGER;
  DECLARE strUser VARCHAR(20);
  DECLARE strSql VARCHAR(5000);
  DECLARE intUltNro INTEGER;
  DECLARE intProxNro INTEGER;
  DECLARE intFam SMALLINT;
  DECLARE intNro SMALLINT;
   
  SET strUser = SELECT TRIM(CURRENT_USER);
  
  SET strSql = 'SELECT VDPAROC2_DATA_ESTOQUE_FECHA FROM ' || strUser || '.PAROC201';
  
  PREPARE stmt1 FROM strSql;
  EXECUTE stmt1 INTO intDataEstoque;
  DEALLOCATE PREPARE stmt1;
   
  IF intDataEstoque IS NULL THEN
     SET intDataEstoque = 0;
  END IF;
  
  SET strSql = 'SELECT VDKARNRO_ULTNRO FROM ' || strUser || '.NROCEN01 WHERE VDKARNRO_COD = 1';  
  PREPARE stmt2 FROM strSql;
  EXECUTE stmt2 INTO intUltNro;
  DEALLOCATE PREPARE stmt2;
  
  SET intProxNro = intUltNro + 1;
  SET strSql = 'UPDATE ' || strUser || '.NROCEN01 SET VDKARNRO_ULTNRO = ' || CAST(intProxNro AS VARCHAR(9)) || ' WHERE VDKARNRO_COD = 1';  
  EXECUTE IMMEDIATE strSql;
      
  SET strSql = 'SELECT VDPRDPRD_CFAM, VDPRDPRD_NRO FROM ' || strUser || '.CADPRD01';
  SET strSql = strSql || ' WHERE CAST(TRIM(VDPRDPRD_CODCIA) AS INTEGER) = ?';
  PREPARE stmt3 FROM strSql;
  EXECUTE stmt3 INTO intFam, intNro USING CODIGO_PRODUTO;
  DEALLOCATE PREPARE stmt3;
       
  IF intFam IS NOT NULL THEN
     SET strSql = 'INSERT INTO ' || strUser || '.CPKARD01 (';
     SET strSql = strSql || 'VDKARKAR_NRC,';
     SET strSql = strSql || 'VDKARKAR_OCOKD,';
     SET strSql = strSql || 'VDKARKAR_SINAL,';
     SET strSql = strSql || 'VDKARKAR_NDOC,';
     SET strSql = strSql || 'VDKARKAR_CODCLI,';
     SET strSql = strSql || 'VDKARKAR_DIAOPER,';
     SET strSql = strSql || 'VDKARKAR_MESOPER,';
     SET strSql = strSql || 'VDKARKAR_ANOOPER,';
     SET strSql = strSql || 'VDKARKAR_DTSIS,';
     SET strSql = strSql || 'VDKARKAR_TIMESIS,';
     SET strSql = strSql || 'VDKARKAR_USUARIO,';
     SET strSql = strSql || 'VDKARKAR_TPDIG,';
     SET strSql = strSql || 'VDKARKAR_TPOCR,';
     SET strSql = strSql || 'VDKARKAR_NRCOLETA)';
     SET strSql = strSql || ' VALUES (';
     SET strSql = strSql || CAST(intProxNro AS VARCHAR(9)) || ',';             
     SET strSql = strSql || '38' || ',';
     SET strSql = strSql || '''' || '+' || '''' || ',';
     SET strSql = strSql || CAST(CODIGO_ORDEM_PRODUTO AS VARCHAR(9)) || ',';
     SET strSql = strSql || '0' || ',';
     SET strSql = strSql || RIGHT(CAST(intDataEstoque AS VARCHAR(8)), 2) || ',';
     SET strSql = strSql || SUBSTRING(CAST(intDataEstoque AS VARCHAR(8)), 5, 2) || ',';
     SET strSql = strSql || LEFT(CAST(intDataEstoque AS VARCHAR(8)), 4) || ',';
     SET strSql = strSql || REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') || ',';
     SET strSql = strSql || LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4) || ',';
     SET strSql = strSql || '''' || 'InT' || '''' || ',';
     SET strSql = strSql || '''' || 'D' || '''' || ',';
     SET strSql = strSql || '''' || ' ' || '''' || ',';
     SET strSql = strSql || '0' || ')';
     EXECUTE IMMEDIATE strSql;
     
     SET strSql = 'INSERT INTO ' || strUser || '.ITKARD01 (';
     SET strSql = strSql || 'VDKARITE_NRC,';
     SET strSql = strSql || 'VDKARITE_ITEM,';
     SET strSql = strSql || 'VDKARITE_PRD1,';
     SET strSql = strSql || 'VDKARITE_PRD2,';
     SET strSql = strSql || 'VDKARITE_QTDPRD,';
     SET strSql = strSql || 'VDKARITE_QTDAV,';
     SET strSql = strSql || 'VDKARITE_VLROPE,';
     SET strSql = strSql || 'VDKARKAR_DTSIS,';
     SET strSql = strSql || 'VDKARKAR_TIMESIS,';
     SET strSql = strSql || 'VDKARKAR_OCOKD,';
     SET strSql = strSql || 'VDKARKAR_USUARIO,';
     SET strSql = strSql || 'VDKARKAR_SIT,';
     SET strSql = strSql || 'VDKARKAR_LOTE)';
     SET strSql = strSql || ' VALUES (';
     SET strSql = strSql || CAST(intProxNro AS VARCHAR(9)) || ',';             
     SET strSql = strSql || '1' || ',';
     SET strSql = strSql || CAST(intFam AS VARCHAR(4)) || ',';
     SET strSql = strSql || CAST(intNro AS VARCHAR(4)) || ',';
     SET strSql = strSql || CAST(ENTRADAS AS VARCHAR(9)) || ',';
     SET strSql = strSql || '0' || ',';
     SET strSql = strSql || '0' || ',';
     SET strSql = strSql || REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '') || ',';
     SET strSql = strSql || LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4) || ',';
     SET strSql = strSql || '38' || ',';
     SET strSql = strSql || '''' || 'InT' || '''' || ',';
     SET strSql = strSql || '''' || ' ' || '''' || ',';
     SET strSql = strSql || '''' || ' ' || '''' || ')';
     EXECUTE IMMEDIATE strSql;
         
     SET COD_ERRO = 0;
     SET MSG_ERRO = 'Lançamento do estoque realizado com sucesso!';
  ELSE
     SET COD_ERRO = 1;
     SET MSG_ERRO = 'Produto ' || CODIGO_PRODUTO || ' não localizado!';   
  END IF;  
END;
CREATE OR REPLACE PROCEDURE SP_CRIA_SALDO_ESTOQUE_PORTAL(OUT COD_ERRO SMALLINT,
                                                         OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN  
  DECLARE dataAtual DATE;
  DECLARE intNumEmp SMALLINT;
  DECLARE intDataEstoque INTEGER;
  DECLARE dataEstoque DATE;
  DECLARE strDataEstoque VARCHAR(10);
  DECLARE strUser VARCHAR(20);
  DECLARE strSql VARCHAR(1000);
  DECLARE strTableName VARCHAR(20);
  DECLARE intAno SMALLINT;
  DECLARE intMes SMALLINT;
  DECLARE intDia SMALLINT;
  DECLARE strNomeTabela VARCHAR(20);
  DECLARE intProduto INTEGER;
  DECLARE intDiaSaldo SMALLINT;
  DECLARE decInicial DECIMAL(11,0);
  DECLARE decEntradas DECIMAL(11,0);
  DECLARE decSaidas DECIMAL(11,0);
  DECLARE strDiaEstoque VARCHAR(2);
  DECLARE strNumemp VARCHAR(2);
  DECLARE intFam SMALLINT;
  DECLARE intNro SMALLINT;
  DECLARE decCodR DECIMAL(10,0);
  DECLARE intQtdUn SMALLINT;
  DECLARE intProdutoFam SMALLINT;
  DECLARE intProdutoNro SMALLINT;
  DECLARE strCodBar VARCHAR(18);
  
  SET strUser = SELECT TRIM(CURRENT_USER);
    
  SET strSql = 'SELECT VDPAROCO_CODEMP FROM ' || strUser || '.PAROCO06';
  
  PREPARE stmt FROM strSql;
  EXECUTE stmt INTO intNumEmp;
  
  IF intNumEmp IS NULL THEN
     SET intNumEmp = 1;
  END IF;
  
  SET strNumEmp = REPEAT('0', 2 - LENGTH(CAST(intNumEmp AS VARCHAR(2)))) || CAST(intNumEmp AS VARCHAR(2));
  
  DEALLOCATE PREPARE stmt;  
  
  SET strSql = 'SELECT VDPAROC2_DATA_ESTOQUE_FECHA FROM ' || strUser || '.PAROC206';
  
  PREPARE stmt1 FROM strSql;
  EXECUTE stmt1 INTO intDataEstoque;
  
  IF intDataEstoque IS NULL THEN
     SET intDataEstoque = 0;
  END IF;
      
  DEALLOCATE PREPARE stmt1;
  
  SET strDataEstoque = LEFT(CAST(intDataEstoque AS VARCHAR(8)), 4) || '-' || SUBSTRING(CAST(intDataEstoque AS VARCHAR(8)), 5, 2) || '-' || RIGHT(CAST(intDataEstoque AS VARCHAR(8)), 2);
  SET dataAtual = CURDATE();  
  SET dataEstoque = TO_DATE(SUBSTRING(cast(intDataEstoque as varchar(8)),7,2) || SUBSTRING(cast(intDataEstoque as varchar(8)),5,2) || SUBSTRING(cast(intDataEstoque as varchar(8)),1,4), 'DDMMYYYY');
  
  SET strSql = 'SELECT table_name FROM systable WHERE table_type = ''TABLE'' AND table_owner = ''';
  SET strSql = strSql || strUser;
  SET strSql = strSql || ''' AND table_name = ''SALDO_ESTOQUE_PORTAL''';  
  
  PREPARE stmt2 FROM strSql;
  EXECUTE stmt2 INTO strTableName;
   
  IF strTableName IS NULL THEN
     SET strSql = 'CREATE TABLE ' || strUser || '.SALDO_ESTOQUE_PORTAL (NUMERO_EMP SMALLINT, DATA_ESTOQUE DATE, PRODUTO_FAM SMALLINT, PRODUTO_NRO SMALLINT, PRODUTO_REDUZ DECIMAL(10,0), PRODUTO_CODBAR VARCHAR(18), PRODUTO_QTDUN SMALLINT, SALDO DECIMAL(13,2), SALDO_UNID DECIMAL(11,0), PRIMARY KEY (NUMERO_EMP, DATA_ESTOQUE, PRODUTO_FAM, PRODUTO_NRO))';
     EXECUTE IMMEDIATE strSql;
  ELSE
     SET strSql = 'DELETE FROM ' || strUser || '.SALDO_ESTOQUE_PORTAL';
     EXECUTE IMMEDIATE strSql;   
  END IF;
    
  DEALLOCATE PREPARE stmt2;
  
  SET intAno = YEAR(dataAtual);
  SET intMes = MONTH(dataAtual);
  SET intDia = DAYOFMONTH(dataAtual);
  SET strNomeTabela = 'SL' || SUBSTRING(CAST(intAno AS VARCHAR(4)), 3, 2) || REPEAT('0', 2 - LENGTH(CAST(intMes AS VARCHAR(2)))) || CAST(intMes AS VARCHAR(2)) || strNumEmp;     
  
  SET strSql = 'SELECT table_name FROM systable WHERE table_type = ''TABLE'' AND table_owner = ''';
  SET strSql = strSql || strUser;
  SET strSql = strSql || ''' AND table_name = ''';
  SET strSql = strSql || strNomeTabela;
  SET strSql = strSql || '''';
  
  PREPARE stmt3 FROM strSql;
  EXECUTE stmt3 INTO strTableName;         
      
  IF strTableName IS NOT NULL THEN
     SET strSql = 'SELECT VDKARDIA_CPRD, VDKARDIA_DIA, VDKARDIA_INICIAL, VDKARDIA_ENTRADAS, VDKARDIA_SAIDAS FROM ' || strUser || '.' || strNomeTabela;
     SET strSql = strSql || ' WHERE VDKARDIA_DIA = ? AND (VDKARDIA_INICIAL + VDKARDIA_ENTRADAS - VDKARDIA_SAIDAS) > 0';
     SET strDiaEstoque = CAST(RIGHT(strDataEstoque, 2) AS SMALLINT);
     
     PREPARE stmt4 FROM strSql;
     DECLARE cursor1 CURSOR FOR stmt4;
     OPEN cursor1 USING strDiaEstoque;         
     FETCH cursor1 INTO intProduto, intDiaSaldo, decInicial, decEntradas, decSaidas;
     
     IF intProduto IS NOT NULL THEN
        WHILE intProduto IS NOT NULL DO
          SET intProdutoFam = Cast(left(concat(repeat('0',6-length(cast(intProduto AS varchar(6)))),cast(intProduto as varchar(6))),3) AS SMALLINT);
          SET intProdutoNro = Cast(right(concat(repeat('0',6-length(cast(intProduto as varchar(6)))),cast(intProduto as varchar(6))),3) AS SMALLINT);
       
          SET strSql = 'SELECT VDPRDPRD_CFAM, VDPRDPRD_NRO, VDPRDPRD_CODR, VDPRDPRD_QTDUN FROM ' || strUser || '.CADPRD06';
          SET strSql = strSql || ' WHERE VDPRDPRD_CFAM = ?';
          SET strSql = strSql || ' AND VDPRDPRD_NRO = ?';
        
          PREPARE stmt5 FROM strSql;
          EXECUTE stmt5 INTO intFam, intNro, decCodR, intQtdUn USING intProdutoFam, intProdutoNro;
       
          IF intFam IS NOT NULL THEN
             SET strSql = 'SELECT VDPRDBAR_CODBAR FROM ' || strUser || '.VDPRBA06';
             SET strSql = strSql || ' WHERE VDPRDBAR_CODPRD = ? AND VDPRDBAR_UNIDADE = 1';
       
             PREPARE stmt6 FROM strSql;
             EXECUTE stmt6 INTO strCodBar USING intProduto;
       
             IF strCodBar IS NOT NULL THEN
                SET strSql = 'INSERT INTO ' || strUser || '.SALDO_ESTOQUE_PORTAL (NUMERO_EMP, DATA_ESTOQUE, PRODUTO_FAM, PRODUTO_NRO, PRODUTO_REDUZ, PRODUTO_CODBAR, PRODUTO_QTDUN, SALDO, SALDO_UNID)';
                SET strSql = strSql || ' VALUES (' || strNumEmp || ',';
                SET strSql = strSql || '''' || strDataEstoque || '''' || ',';             
                SET strSql = strSql || CAST(intFam AS VARCHAR(3)) || ',';
                SET strSql = strSql || CAST(intNro AS VARCHAR(3)) || ',';
                SET strSql = strSql || CAST(decCodR AS VARCHAR(20)) || ',';
                SET strSql = strSql || '''' || strCodBar || '''' || ',';
                SET strSql = strSql || CAST(intQtdUn AS VARCHAR(4)) || ',';
                SET strSql = strSql || CAST(CAST((decInicial + decEntradas - decSaidas) / intQtdUn AS DECIMAL(13,3)) AS VARCHAR(20)) || ',';
                SET strSql = strSql || CAST(decInicial + decEntradas - decSaidas AS VARCHAR(20)) || ')';
                EXECUTE IMMEDIATE strSql;
             END IF;
          
             DEALLOCATE PREPARE stmt6;
          
          END IF;
       
          DEALLOCATE PREPARE stmt5;
       
          FETCH NEXT FROM cursor1 INTO intProduto, intDiaSaldo, decInicial, decEntradas, decSaidas;  
        END WHILE;
        
        SET COD_ERRO = 0;
        SET MSG_ERRO = 'Carga do estoque realizada com sucesso!';
     ELSE
        SET COD_ERRO = 1;
        SET MSG_ERRO = 'Não existem dados de estoque para carga!';   
     END IF;
     
     DEALLOCATE PREPARE stmt4;
     CLOSE cursor1;
  ELSE
     SET COD_ERRO = 1;
     SET MSG_ERRO = 'Tabela ' || strNomeTabela || ' não localizada!';
  END IF;
  
  DEALLOCATE PREPARE stmt3;  
END;
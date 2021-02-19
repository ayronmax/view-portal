CREATE OR REPLACE PROCEDURE SP_SOL_CRIA_VISITA(IN QTD_DIAS SMALLINT)

LANGUAGE SQL

BEGIN
  DECLARE dataAtual DATE;
  DECLARE dataVisita DATE;
  DECLARE intAno SMALLINT;
  DECLARE intMes SMALLINT;
  DECLARE intDia SMALLINT;
  DECLARE strNomeTabela VARCHAR(8);
  DECLARE strNomeCampo VARCHAR(16);
  DECLARE intCountDays SMALLINT;
  DECLARE strSql VARCHAR(200);
  DECLARE intPasta SMALLINT;
  DECLARE strCondicao1 VARCHAR(1);
  DECLARE strUser VARCHAR(20);
  DECLARE strTableName VARCHAR(15);
  DECLARE strTableNameExiste VARCHAR(15);
  DECLARE strDataVisita VARCHAR(10);
  DECLARE intFrequencia SMALLINT;
  DECLARE strFrequencia CHAR(1);
  
  SET dataAtual = CURDATE();
  SET dataVisita = dataAtual;
  SET intCountDays = 1;  
  SET strCondicao1 = '*';
  
  SET strUser = SELECT TRIM(CURRENT_USER);
  
  SET strSql = 'SELECT table_name FROM systable WHERE table_type = ''TABLE'' AND table_owner = ''';
  SET strSql = strSql || strUser;
  SET strSql = strSql || ''' AND table_name = ''PASTA_VISITA''';
  
  PREPARE stmt1 FROM strSql;
  EXECUTE stmt1 INTO strTableName;
     
  SET strTableNameExiste = TRIM(strTableName); 
     
  IF strTableNameExiste <> 'PASTA_VISITA' THEN
     SET strSql = 'CREATE TABLE ' || strUser || '.pasta_visita (numero_pasta SMALLINT, data_visita INTEGER, frequencia CHAR(1), PRIMARY KEY (numero_pasta, data_visita))';
     EXECUTE IMMEDIATE strSql;
  ELSE
     SET strSql = 'DELETE FROM ' || strUser || '.pasta_visita';
     EXECUTE IMMEDIATE strSql;   
  END IF;
  
  DEALLOCATE PREPARE stmt1;
  
  WHILE intCountDays <= QTD_DIAS DO
     SET strDataVisita = CAST(dataVisita AS VARCHAR(10)); 
     SET intAno = YEAR(dataVisita);
     SET intMes = MONTH(dataVisita);
     SET intDia = DAYOFMONTH(dataVisita);
     SET strNomeTabela = 'PASTAC' || SUBSTRING(CAST(intAno AS VARCHAR(4)), 3, 2);
     
     SET strSql = 'SELECT table_name FROM systable WHERE table_type = ''TABLE'' AND table_owner = ''';
     SET strSql = strSql || strUser;
     SET strSql = strSql || ''' AND table_name = ''';
     SET strSql = strSql || strNomeTabela;
     SET strSql = strSql || '''';
          
     PREPARE stmt2 FROM strSql;
     EXECUTE stmt2 INTO strTableName;
     
     SET strTableNameExiste = TRIM(strTableName); 
     
     IF strTableNameExiste <> strNomeTabela THEN
        BREAK;
     END IF;
     
     DEALLOCATE PREPARE stmt2;
     
     SET strNomeCampo = 'VDCLIPAS_V_' || CAST(intMes AS VARCHAR(2)) || '_' || CAST(intDia AS VARCHAR(2));     
          
     SET strSql = 'SELECT vdclipas_num, vdclipas_freq FROM ';
     SET strSql = strSql || strNomeTabela;
     SET strSql = strSql || ' WHERE ';
     SET strSql = strSql || strNomeCampo;
     SET strSql = strSql || ' = ''';     
     SET strSql = strSql || strCondicao1;
     SET strSql = strSql || '''';     
                  
     PREPARE stmt3 FROM strSql;
     DECLARE cursor1 CURSOR FOR stmt3;
     OPEN cursor1;
     FETCH cursor1 INTO intPasta, intFrequencia; 
          
     WHILE intPasta <> NULL DO
        IF intFrequencia = 1 THEN
           SET strFrequencia = 'S';
        ELSEIF intFrequencia >= 14 AND intFrequencia <= 15 THEN
           SET strFrequencia = 'Q';
        ELSEIF intFrequencia >= 28 AND intFrequencia <= 31 THEN        
           SET strFrequencia = 'M';
        ELSE
           SET strFrequencia = 'X';    
        END IF; 
            
        SET strSql = 'INSERT OR REPLACE INTO '      ||
                     strUser                        ||
                     '.pasta_visita VALUES ('       ||
                     CAST(intPasta AS VARCHAR(4))   ||
                     ', '                           ||
                     SUBSTRING(strDataVisita, 1, 4) ||
                     SUBSTRING(strDataVisita, 6, 2) ||
                     SUBSTRING(strDataVisita, 9, 2) ||
                     ', '''                         ||
                     strFrequencia                  ||
                     ''')';        
        EXECUTE IMMEDIATE strSql;
        FETCH NEXT FROM cursor1 INTO intPasta, intFrequencia;
     END WHILE;
     
     DEALLOCATE PREPARE stmt3;		
     CLOSE cursor1;
       			
     SET intCountDays = intCountDays + 1;
     SET dataVisita = ADD_DAYS(dataAtual, intCountDays);
  END WHILE;
END;
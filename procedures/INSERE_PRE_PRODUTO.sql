CREATE OR REPLACE PROCEDURE INSERE_PRE_PRODUTO (
IN NREMP SMALLINT,
IN CODPRD_CIA CHAR(20),
IN CGC DECIMAL(15,0),
IN DESCR_PRD CHAR(100),
IN UN_MED CHAR(5),
IN PESO DECIMAL(14, 6),
IN COD_EAN CHAR(30),
IN MARCA CHAR(50),
IN SABOR CHAR(50),
IN CATEGORIA CHAR(50),
IN CODPRD_CTRL INTEGER,
OUT COD_ERRO SMALLINT,
OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN
  DECLARE strUser VARCHAR(20);                                                                                                          
  DECLARE strSql VARCHAR(5000);                                                                                                         
  DECLARE strDataProc VARCHAR(10);                                                                                                      
  DECLARE strHoraProc VARCHAR(8);
  DECLARE produto VARCHAR(20);
  DECLARE integre int;

  IF NREMP IS NOT NULL AND 
     CODPRD_CIA IS NOT NULL THEN   
     SET strUser = SELECT TRIM(CURRENT_USER);
     SET strDataProc = REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '');
     SET strHoraProc = LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4);
     
     SET integre = SELECT VDPRDPPR_INTEGRADO FROM VDPRDPPR WHERE VDPRDPPR_NREMP = 1 AND VDPRDPPR_CODPRD_CIA = CODPRD_CIA;
     
     SET produto = SELECT VDPRDPRD_CODCIA2 FROM CADPRD01 WHERE VDPRDPRD_CODCIA2 = CODPRD_CIA;
     
     IF produto IS NULL THEN
        IF integre IS NULL OR integre = 0 THEN   
           SET strSql = 'INSERT OR REPLACE INTO ' || strUser || '.VDPRDPPR (';
           SET strSql = strSql || 'VDPRDPPR_NREMP,';
           SET strSql = strSql || 'VDPRDPPR_CODPRD_CIA,';
           SET strSql = strSql || 'VDPRDPPR_CGC,';
	   SET strSql = strSql || 'VDPRDPPR_LOGDT,';
	   SET strSql = strSql || 'VDPRDPPR_INCLDT,';
	   SET strSql = strSql || 'VDPRDPPR_INCLHR,';
	   SET strSql = strSql || 'VDPRDPPR_INCLUSER,';
	   SET strSql = strSql || 'VDPRDPPR_ALTEDT,';
	   SET strSql = strSql || 'VDPRDPPR_ALTEHR,';
	   SET strSql = strSql || 'VDPRDPPR_ALTEUSER,';
	   SET strSql = strSql || 'VDPRDPPR_CANCDT,';
	   SET strSql = strSql || 'VDPRDPPR_CANCHR,';
	   SET strSql = strSql || 'VDPRDPPR_CANCUSER,';
	   SET strSql = strSql || 'VDPRDPPR_CANCSN,';
	   SET strSql = strSql || 'VDPRDPPR_NIVELAUDIT,';
	   SET strSql = strSql || 'VDPRDPPR_INTEGRADO,';
	   SET strSql = strSql || 'VDPRDPPR_DESCR_PRD,';
	   SET strSql = strSql || 'VDPRDPPR_UN_MED,';
	   SET strSql = strSql || 'VDPRDPPR_PESO,';
	   SET strSql = strSql || 'VDPRDPPR_COD_EAN,';
	   SET strSql = strSql || 'VDPRDPPR_MARCA,';
	   SET strSql = strSql || 'VDPRDPPR_SABOR,';
	   SET strSql = strSql || 'VDPRDPPR_CATEGORIA,';
	   SET strSql = strSql || 'VDPRDPPR_CODPRD_CTRL,';
	   SET strSql = strSql || 'VDPRDPPR_FILLER)';
	   SET strSql = strSql || ' VALUES ('
           SET strSql = strSql || CAST (NREMP AS VARCHAR (15)) || ', ''' ||
		        CODPRD_CIA || ''' ,' ||
		        CAST (CGC AS VARCHAR (15)) || ',' ||
		        strDataProc || ',' ||
		        strDataProc || ',' ||
		        strHoraProc || ',''' ||
		        INCLUSER || ''','||
		        strDataProc || ',' ||
		        strHoraProc || ',''' ||
		        ALTEUSER || ''', 0, 0, '''', 0,' ||
		        '''0''' || ',' ||
		        '''0''' || ',' ||
		        DESCR_PRD || ''',''' ||
		        UN_MED ||  ''',' ||
		        CAST(PESO AS VARCHAR(15)) || ',''' ||
		        COD_EAN || ''',''' ||
		        MARCA  || ''',''' ||
		        SABOR  || ''',''' ||
		        CATEGORIA  || ''',''' ||
		        CAST(CODPRD_CTRL AS VARCHAR(15)) || ','''''');';
           EXECUTE IMMEDIATE strSql;
       
           SET COD_ERRO = 0;
           SET MSG_ERRO = 'Pre-produto inserido com sucesso!';                                                                         
        ELSE
           SET COD_ERRO = 1;
           SET MSG_ERRO = 'Pre-produto nao inserido, ja foi integrado!';
        END IF;
     ELSE
        SET COD_ERRO = 1;
        SET MSG_ERRO = 'Produto ja cadastrado no ERP!';   
     END IF;   
  ELSE
    SET COD_ERRO = 1;
    SET MSG_ERRO = 'NREMP e CODPRD_CIA sao obrigatorios!';
  END IF;
END;
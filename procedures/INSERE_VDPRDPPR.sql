CREATE OR REPLACE PROCEDURE INSERE_VDPRDPPR(
IN NREMP SMALLINT,
IN CODPRD_CIA CHAR(20),
IN CGC DECIMAL(15, 0),
IN INCLUSER CHAR(3),
IN ALTEUSER CHAR(3),
IN NIVELAUDIT SMALLINT,
IN INTEGRADO SMALLINT,
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

IF NREMP IS NOT NULL AND CODPRD_CIA IS NOT NULL AND CGC IS NOT NULL THEN
   DECLARE strUser VARCHAR(20);                                                                                                          
   DECLARE strSql VARCHAR(5000);                                                                                                         
   DECLARE strDataProc VARCHAR(10);                                                                                                      
   DECLARE strHoraProc VARCHAR(8);

   SET strUser = SELECT TRIM(CURRENT_USER);
   SET strDataProc = REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '');
   SET strHoraProc = LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4);
   
	SET strSql = 'INSERT OR REPLACE INTO ' || strUser ||
				 '.VDPRDPPR (VDPRDPPR_NREMP,VDPRDPPR_CODPRD_CIA,VDPRDPPR_CGC,'||
				 'VDPRDPPR_LOGDT,VDPRDPPR_INCLDT,VDPRDPPR_INCLHR,VDPRDPPR_INCLUSER,'||
				 'VDPRDPPR_ALTEDT,VDPRDPPR_ALTEHR,VDPRDPPR_ALTEUSER,VDPRDPPR_CANCDT,'||
				 'VDPRDPPR_CANCHR,VDPRDPPR_CANCUSER,VDPRDPPR_CANCSN,VDPRDPPR_NIVELAUDIT,'||
				 'VDPRDPPR_INTEGRADO,VDPRDPPR_DESCR_PRD,VDPRDPPR_UN_MED,VDPRDPPR_PESO,'||
				 'VDPRDPPR_COD_EAN,VDPRDPPR_MARCA,VDPRDPPR_SABOR,VDPRDPPR_CATEGORIA,'||
				 'VDPRDPPR_CODPRD_CTRL,VDPRDPPR_FILLER) VALUES (' ||
				 CAST (NREMP AS VARCHAR (15)) || ', ''' ||
				 CODPRD_CIA || ''' ,' ||
				 CAST (CGC AS VARCHAR (15)) || ',' ||
				 strDataProc || ',' ||
				 strDataProc || ',' ||
				 strHoraProc || ',''' ||
				 INCLUSER || ''','||
				 strDataProc || ',' ||
				 strHoraProc || ',''' ||
				 ALTEUSER || ''', 0, 0, '''', 0,' ||
				 CAST(NIVELAUDIT AS VARCHAR(15)) || ',' ||
				 CAST(INTEGRADO AS VARCHAR(15)) || ',''' ||
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
	SET MSG_ERRO = 'registro iserido com sucesso!';                                                                         
ELSE
	SET COD_ERRO = 1;
	SET MSG_ERRO = 'NREMP, CODPRD_CIA e CGC sao obrigatorios!';
END IF;

END;
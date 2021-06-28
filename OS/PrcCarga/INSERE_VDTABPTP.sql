CREATE OR REPLACE PROCEDURE INSERE_VDTABPTP(
IN NREMP SMALLINT,
IN CODTAB_CIA CHAR(15),
IN CODPRD_CIA CHAR(20),
IN CGC DECIMAL(15,0),
IN LOGDT INTEGER,
IN INCLDT INTEGER,
IN INCLHR SMALLINT,
IN INCLUSER CHAR(3),
IN ALTEDT INTEGER,
IN ALTEHR SMALLINT,
IN ALTEUSER CHAR(3),
IN CANCDT INTEGER,
IN CANCHR SMALLINT,
IN CANCUSER CHAR(3),
IN CANCSN SMALLINT,
IN NIVELAUDIT SMALLINT,
IN INTEGRADO SMALLINT,
IN DESC_FIXO DECIMAL(7,4),
IN DESC_MAX DECIMAL(7,4),
IN PRECO DECIMAL(14,6),
IN CODTAB_CTRL INTEGER,
IN FILLER CHAR(990),
OUT COD_ERRO SMALLINT,
OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN

IF NREMP IS NOT NULL AND CODPRD_CIA IS NOT NULL AND CODTAB_CIA IS NOT NULL AND CGC IS NOT NULL THEN
   DECLARE strUser VARCHAR(20);
   DECLARE strSql VARCHAR(5000);
   DECLARE strDataProc VARCHAR(10);
   DECLARE strHoraProc VARCHAR(8);
   
   SET strUser = SELECT TRIM(CURRENT_USER);
   SET strDataProc = REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '');
   SET strHoraProc = LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 4);
   
   SET strSql = 'INSERT OR REPLACE INTO ' || strUser ||
				 '.VDTABPTP (VDTABPTP_NREMP,VDTABPTP_CODTAB_CIA'||
				 ',VDTABPTP_CODPRD_CIA,'||
				 'VDTABPTP_CGC,VDTABPTP_LOGDT,'||
				 'VDTABPTP_INCLDT,VDTABPTP_INCLHR,'||
				 'VDTABPTP_INCLUSER,VDTABPTP_ALTEDT,'||
				 'VDTABPTP_ALTEHR,VDTABPTP_ALTEUSER,'||
				 'VDTABPTP_CANCDT,VDTABPTP_CANCHR,'||
				 'VDTABPTP_CANCUSER,VDTABPTP_CANCSN,'||
				 'VDTABPTP_NIVELAUDIT,VDTABPTP_INTEGRADO,'||
				 'VDTABPTP_DESC_FIXO,VDTABPTP_DESC_MAX,'||
				 'VDTABPTP_PRECO,VDTABPTP_CODTAB_CTRL,VDTABPTP_FILLER) VALUES (' ||
				 CAST(NREMP AS VARCHAR (15)) || ', ''' ||
				 CODTAB_CIA || ''', ''' ||
				 CODPRD_CIA || ''', ' ||
				 CAST(CGC AS VARCHAR (15)) || ', ' ||
				 CAST(LOGDT AS VARCHAR (15)) || ', ' ||
				 CAST(INCLDT AS VARCHAR (15)) || ', ' ||
				 CAST(INCLHR AS VARCHAR (15)) || ', ''' ||
				 INCLUSER || ''', ' ||
				 CAST(ALTEDT AS VARCHAR (15)) || ', ' ||
				 CAST(ALTEHR AS VARCHAR (15)) || ', ''' ||
				 ALTEUSER || ''', ' ||
				 CAST(CANCDT AS VARCHAR (15)) || ', ' ||
				 CAST(CANCHR AS VARCHAR (15)) || ', ''' ||
				 CANCUSER || ''', ' ||
				 CAST(CANCSN AS VARCHAR (15)) || ', ' ||
				 CAST(NIVELAUDIT AS VARCHAR (15)) || ', ' ||
				 CAST(INTEGRADO AS VARCHAR (15)) || ', ' ||
				 CAST(DESC_FIXO AS VARCHAR (15)) || ', ' ||
				 CAST(DESC_MAX AS VARCHAR (15)) || ', ' ||
				 CAST(PRECO AS VARCHAR (15)) || ', ' ||
				 CAST(CODTAB_CTRL AS VARCHAR (15)) || ', ''' ||
				 FILLER || ''');';

	EXECUTE IMMEDIATE strSql;
	
	SET COD_ERRO = 0;
	SET MSG_ERRO = 'registro iserido com sucesso!';                                                              
ELSE
	SET COD_ERRO = 1;
	SET MSG_ERRO = 'NREMP, CODPRD_CIA, CODTAB_CIA e CGC sao obrigatorios!';
END IF;

END;
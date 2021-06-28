create or replace procedure SP_ATUALIZA_PRODUTO(in codprd   varchar(010),
											   in descr_portal varchar(050),
											   out cod_status     smallint
											)
											
											
											
LANGUAGE SQL 
BEGIN 

declare existe BIGINT;
declare descricao varchar(050);
declare familia  int;
declare sequencia_prd int;

set familia = select VDPRDPRD_CFAM from CADPRD01 where codprd = VDPRDPRD_CODR;

set sequencia_prd = select VDPRDPRD_NRO from CADPRD01 where codprd = VDPRDPRD_CODR;

set existe = select VDPRDPCR_CODR from VDPRDPCR where codprd = VDPRDPCR_CODR;

	IF codprd = NULL or descr_portal = NULL THEN
set cod_status = 0;
		      
	ELSE
		IF existe = NULL THEN
		 insert into VDPRDPCR (
		VDPRDPCR_CODR,
		VDPRDPCR_LOGDT,
		VDPRDPCR_INCLDT,
		VDPRDPCR_INCLHR,
		VDPRDPCR_INCLSIGLA,
		VDPRDPCR_CANCSN,
		VDPRDPCR_NIVELAUDIT,
		VDPRDPCR_CFAM,
		VDPRDPCR_TRACO,
		VDPRDPCR_NRO,
		VDPRDPCR_CORINGA,
		VDPRDPCR_COB_ESP,
		VDPRDPCR_DESC_PRD_PORTAL) values(
		cast (codprd as INT),
		cast(DATETOSTR(Curdate(), 'yyyymmdd') as int),
		cast(DATETOSTR(Curdate(), 'yyyymmdd') as int),
		cast(cast(TIMETOSTR(Curtime(), 'hhmmss') as varchar(4)) as int),
		'POR',
		0,
		10,
		familia,
		'-',
		sequencia_prd,
		'N',
		'N',
		descr_portal
		);
		
		set descricao = select VDPRDPCR_DESC_PRD_PORTAL from VDPRDPCR where codprd = VDPRDPCR_CODR;
		
		    IF descr_portal = descricao THEN
				
				set cod_status = 1;
				
			ELSE
				set cod_status = 0;
				
			END IF;
		ELSE
		UPDATE VDPRDPCR SET VDPRDPCR_ALTEDT =cast(DATETOSTR(Curdate(), 'yyyymmdd') as int), VDPRDPCR_DESC_PRD_PORTAL = descr_portal,VDPRDPCR_ALTEHR=cast(cast(TIMETOSTR(Curtime(), 'hhmmss') as varchar(4)) as int),VDPRDPCR_ALTESIGLA = 'POR' where codprd = VDPRDPCR_CODR;
		
		set descricao = select VDPRDPCR_DESC_PRD_PORTAL from VDPRDPCR where codprd = VDPRDPCR_CODR;
		
			IF descr_portal = descricao THEN
			 
			set cod_status = 1;
				
			ELSE
				set cod_status = 0;
			
			END IF;
		END IF;
		
	END IF;		
END;
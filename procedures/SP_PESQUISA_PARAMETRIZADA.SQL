create or replace procedure sp_pesquisa_parametrizada(in CODQUES_PPRESPOSTA        SMALLINT,
                                                      in REGCLI_PPRESPOSTA         INTEGER,
                                                      in NUMCLI_PPRESPOSTA         INTEGER,
                                                      in QUESTPERGID_PPRESPOSTA    varchar(255),
                                                      in CODITEM_PPRESPOSTA        varchar(255),
                                                      in CODPERG_PPRESPOSTA        varchar(255),
                                                      in TIPOPERG_PPRESPOSTA       varchar(255),
                                                      in DATAPESQ_PPRESPOSTA       varchar(255),
                                                      in RESPOSTA_PPRESPOSTA       varchar(255),
                                                      in MOTIVO_PPRESPOSTA         varchar(255),
                                                      in MOTIVOITEMFORA_PPRESPOSTA varchar(255),
                                                      in FIXO_PPRESPOSTA           varchar(255),
                                                      in CAMPO_FIXO_PPRESPOSTA     varchar(255),
                                                      out cod_status               smallint,
                                                      out status_msg               varchar(255))																																	
LANGUAGE SQL 
BEGIN 

        DECLARE CODCLI             INTEGER;
		DECLARE CODIGOITEM         INTEGER;
		DECLARE CODQUESTAO         INTEGER;
		DECLARE CODPERGUNTA        INTEGER;
		DECLARE CODIGOITEMPERGUNTA INTEGER;
		DECLARE CODIGOPRODUTO      INTEGER;
		DECLARE PESQUISA           INTEGER;			
		
		
		DECLARE RESPOSTA_LOGICA    INT;
		DECLARE RESPOSTA_CODALT    INT;
		DECLARE RESPOSTA_QTD       INT;
		DECLARE RESPOSTA_VALOR     DECIMAL(11,2);	
				
		SET CODQUESTAO =  SELECT VDGERQUH_CODQUES FROM psqequ61 WHERE VDGERQUH_CODQUES = CODQUES_PPRESPOSTA ORDER  BY 1 DESC LIMIT 1;
		SET CODPERGUNTA = SELECT VDGERPEH_CODPERG FROM psqecp61 WHERE VDGERPEH_CODPERG = CODPERG_PPRESPOSTA;
		SET CODIGOPRODUTO = SELECT VDGERPEH_CODPRD FROM psqecp61 WHERE VDGERPEH_CODPERG = CODPERG_PPRESPOSTA;
		SET CODIGOITEMPERGUNTA = SELECT VDGERQIP_CODITE FROM PSQQIP61 WHERE VDGERQIP_CODITE = CAST(CODITEM_PPRESPOSTA AS INTEGER);
		
		IF CODITEM_PPRESPOSTA = SPACES OR
           CODITEM_PPRESPOSTA = '000' THEN
            SET CODIGOITEM  = 999;
		END IF;		
		
		SET RESPOSTA_LOGICA = 0;
		SET RESPOSTA_CODALT = 0;
		SET RESPOSTA_QTD    = 0;
		SET RESPOSTA_VALOR  = 0;	
		
		CASE TIPOPERG_PPRESPOSTA
		    WHEN 1 THEN 
			     SET RESPOSTA_CODALT = CAST(RESPOSTA_PPRESPOSTA AS INT);			
			WHEN 3 THEN  
			     IF UPPER(RESPOSTA_PPRESPOSTA)  = 'S' OR RESPOSTA_PPRESPOSTA  = '1' THEN 
				      SET RESPOSTA_LOGICA  =  CAST(RESPOSTA_PPRESPOSTA AS INT);
			     END IF;
			WHEN 4 THEN 
				SET RESPOSTA_QTD = CAST(RESPOSTA_PPRESPOSTA AS INT);
			WHEN 5 THEN 			
				SET RESPOSTA_VALOR = CAST(RESPOSTA_PPRESPOSTA AS DECIMAL(11,2));
		END CASE;		
		
		SET CODCLI = SELECT CAST(CONCAT(
                                    CONCAT(
                                    	REPEAT('0',4 _LENGTH(CAST(VDCLICLI_REGI AS VARCHAR(4)))),
                                    	CAST(VDCLICLI_REGI AS VARCHAR(4))
                                    ),
                                    CONCAT(
                                    	REPEAT('0',4 _LENGTH(CAST(VDCLICLI_NUM AS VARCHAR(4)))) ,
                                    	CAST(VDCLICLI_NUM AS VARCHAR(4))
                                    )
	                            )AS INTEGER) FROM CADCLI61 WHERE VDCLICLI_REGI = REGCLI_PPRESPOSTA AND VDCLICLI_NUM = NUMCLI_PPRESPOSTA;
	    
		IF CODCLI <> NULL AND CODPERGUNTA <> NULL THEN 		
		
		    SET PESQUISA = select VDGERRPP_CODCLI from PESQPP61 where VDGERRPP_CODCLI = CODCLI and VDGERRPP_CODQUES = CODQUESTAO and VDGERRPP_CODPERG = CODPERGUNTA  
			                                           and VDGERRPP_CODITE = CODIGOITEMPERGUNTA and  VDGERRPP_CODPRD = CODIGOPRODUTO;
		    IF PESQUISA <> NULL THEN 
			      UPDATE PESQPP61 SET VDGERRPP_CODCLI = CODCLI,
				      				  VDGERRPP_CODQUES = CODQUESTAO,
						    		  VDGERRPP_CODPERG = CODPERGUNTA,
							    	  VDGERRPP_CODITE = CODIGOITEMPERGUNTA,
								      VDGERRPP_CODPRD = CODIGOPRODUTO,
									  VDGERRPP_NPESQ = '',
									  VDGERRPP_PROGRAMA_ORIGEM = 'PROC',
									  VDGERRPP_PESQ_ENCERRADA = 0,
									  VDGERRPP_CODALT = RESPOSTA_CODALT,
									  VDGERRPP_LOGICA = RESPOSTA_LOGICA,
									  VDGERRPP_QTD  = RESPOSTA_QTD,
									  VDGERRPP_VALOR = RESPOSTA_VALOR,
									  VDGERRPP_NPESQ = MOTIVO_PPRESPOSTA								    
                            where VDGERRPP_CODCLI = CODCLI 
							  and VDGERRPP_CODQUES = CODQUESTAO 
							  and VDGERRPP_CODPERG = CODPERGUNTA  
							  and VDGERRPP_CODITE = CODIGOITEMPERGUNTA
							  and  VDGERRPP_CODPRD = CODIGOPRODUTO;  
		    ELSE 
			    INSERT INTO PESQPP61(VDGERRPP_CODCLI, 
				      				  VDGERRPP_CODQUES,
						    		  VDGERRPP_CODPERG,
							    	  VDGERRPP_CODITE,
								      VDGERRPP_CODPRD,
									  VDGERRPP_NPESQ,
									  VDGERRPP_PROGRAMA_ORIGEM,
									  VDGERRPP_PESQ_ENCERRADA,
									  VDGERRPP_CODALT,
                                      VDGERRPP_LOGICA,
									  VDGERRPP_QTD, 
									  VDGERRPP_VALOR,
									  VDGERRPP_NPESQ 
								    )
                            VALUES(CODCLI,
				                   CODQUESTAO,						  
						           CODPERGUNTA,
						           CODIGOITEMPERGUNTA,
						           CODIGOPRODUTO,
								   '',
								   'PROC',
								   0,		
                                   RESPOSTA_CODALT,		
                                   RESPOSTA_LOGICA,		
                                   RESPOSTA_QTD,
                                   RESPOSTA_VALOR,
                                   MOTIVO_PPRESPOSTA								   
						        );	
		    END IF;

       	END IF;		   
	    		
END;


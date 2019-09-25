create OR REPLACE procedure SP_RETIRADA_COMODATO_ITEM(IN COD_NEMP SMALLINT,
													  IN COD_PRE_PEDIDO BIGINT,
													  IN SEQ_ITEM SMALLINT,
											          IN COD_OCORRENCIA SMALLINT,
											          IN COD_RED BIGINT,											
											          IN QUANTIDADE_CX INTEGER,
											          IN QUANTIDADE_UN INTEGER,
											          IN TABLEPRECO INTEGER,
											          IN DESCONTO  DECIMAL(5,2),
											          IN VALOR_LIQ DECIMAL(11,2),
											          IN VALOR_BRUTO DECIMAL(11,2),
											          IN valorLiquidoUmaCaixa DECIMAL(13,4),
											          IN valorLiquidoUmAvulso DECIMAL(13,4),
                                                      IN ultimo_item  CHAR(001),
											          OUT STATUSMSG   SMALLINT,
											          OUT MSG          VARCHAR(255)) 	
LANGUAGE SQL  
BEGIN 
   
   declare prepedido bigint;
   declare ITEM bigint;
   declare ORIGEM char(001);
   
   declare codprd integer;
   
   
   set codprd = select cast(concat(repeat('0',3 - length(cast(VDPRDPRD_CFAM as varchar(3)))),cast(VDPRDPRD_CFAM as varchar(3)))||
       concat(repeat('0',3 - length(cast(VDPRDPRD_NRO as varchar(3)))), cast(VDPRDPRD_NRO as varchar(3))) as int)
       from cadprd61 where VDPRDPRD_CODR  = COD_RED;
   
    SET ITEM = SELECT VDPEDIPP_PRE_PED FROM VDPEDIPP WHERE VDPEDIPP_PRE_PED = COD_PRE_PEDIDO AND VDPEDIPP_NREMP = COD_NEMP AND VDPEDIPP_ITEM = SEQ_ITEM;
   
    IF ITEM <> NULL THEN
	    SET STATUSMSG = 0;
		SET MSG = 'ITEM JÁ EXISTE NESSA SEQUENCIA';
	ELSE   
		IF COD_NEMP <> NULL AND COD_PRE_PEDIDO <> NULL THEN
	
			SET prepedido =  SELECT VDPEDCPP_PRE_PED FROM VDPEDCPP WHERE VDPEDCPP_PRE_PED = COD_PRE_PEDIDO AND VDPEDCPP_NREMP = COD_NEMP;
   
			IF prepedido <> NULL THEN   			    
			
				IF  COD_NEMP                        = null or
				    COD_PRE_PEDIDO                  = null or
				    SEQ_ITEM                        = NULL OR 
					COD_OCORRENCIA                  = NULL OR 
					COD_RED                         = NULL OR 					
					TABLEPRECO                      = NULL OR 					
					VALOR_LIQ                       = NULL OR 
					VALOR_BRUTO                     = NULL OR
					(valorLiquidoUmaCaixa               = null or valorLiquidoUmAvulso               = null )
					THEN	   
					SET STATUSMSG = 0;
					SET MSG = 'CAMPOS SEQ_ITEM,COD_OCORRENCIA,COD_RED,TABLEPRECO,DESCONTO,VALOR_LIQ ,VALOR_BRUTO, PRECO_UNITARIO_CX ,NAO PODEM SER NULLO';
				ELSE
                    SET ORIGEM =  SELECT VDPEDCPP_FL_ORIGEM FROM VDPEDCPP WHERE VDPEDCPP_PRE_PED = COD_PRE_PEDIDO AND VDPEDCPP_NREMP = COD_NEMP;
					
                    IF ORIGEM = 'L' THEN 
					   INSERT INTO VDPEDIPP(
							VDPEDIPP_NREMP      ,      
							VDPEDIPP_PRE_PED    ,     
							VDPEDIPP_ITEM       ,                    
							VDPEDIPP_OCOKD      ,         
							VDPEDIPP_CODR       ,
                            VDPEDIPP_PROD       ,	
							VDPEDIPP_QTD        ,          
							VDPEDIPP_QTDS       ,          
							VDPEDIPP_TBPRD      ,          
							VDPEDIPP_DESC       ,          
							VDPEDIPP_VLR_LIQUIDO,         
							VDPEDIPP_VLR_BRUTO  ,          
							VDPEDIPP_PREPRDU    ,          
							VDPEDIPP_PREPRDUS       							
							)
							VALUES (
							COD_NEMP                         ,
							COD_PRE_PEDIDO                   ,
							SEQ_ITEM                         ,
							COD_OCORRENCIA                   ,
							COD_RED                          ,
							codprd                           ,
							QUANTIDADE_CX                    ,
							QUANTIDADE_UN                    ,
							TABLEPRECO                       ,
							DESCONTO                         ,
							VALOR_LIQ                        ,
							VALOR_BRUTO                      ,
							valorLiquidoUmaCaixa             ,
							valorLiquidoUmAvulso            
							);
						    IF ultimo_item = 'S' THEN 
			                   UPDATE VDPEDCPP SET VDPEDCPP_MOSTRA = 1 WHERE  VDPEDCPP_PRE_PED = COD_PRE_PEDIDO AND VDPEDCPP_NREMP = COD_NEMP;
				            END IF;	
							SET STATUSMSG = 1;
							SET MSG = 'ITEM INCLUIDO COM SUCESSO';	  
					END IF;
				END IF;
			ELSE 
				SET STATUSMSG = 0;
				SET MSG = 'CAPA DO PEDIDO NAO EXISTE';
			END IF;
		ELSE
			SET STATUSMSG = 0;
			SET MSG = 'NUMERO PRE PEDIDO E NUMERO EMPRESA NAO PODE SER NULO';
		END IF;
	END IF;
END;



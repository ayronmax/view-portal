create OR REPLACE procedure SP_RETIRADA_COMODATO ( in  NEMP          smallint,
												   in  CODCLI        INT, 
												   in  CNPJ_CPF      VARCHAR(015),
												   in  origem        Char(001),
												   in  codven        char(008),
												   in  tipocob       smallint,
												   in  condpagamento smallint, 											   
												   in  desconto      decimal(5,2), 
												   in  taxa_fin      decimal(5,2),												   
												   in  valor_liquido_portal decimal(13,2),
												   in  dataEmissao   INT,
												   OUT  NUMPREPEDIDO BIGINT,
												   OUT STATUSMSG     SMALLINT,
												   out msg           varchar(255)) 
																
		LANGUAGE SQL 
		BEGIN 

		declare prepedido bigint;
		DECLARE CGCNOVO VARCHAR(015);
		declare seq int;
		declare NUMEROPEDIDO BIGINT;
		
		   
		IF LENGTH(CGCNOVO) <= 11 THEN
			SET CGCNOVO =  CONCAT(CONCAT(SUBSTRING(CGCNOVO,1,9),'0000'),SUBSTRING(CGCNOVO,10,2));        	
		END IF;
			  
		  
		set NUMEROPEDIDO = select (MAX(VDPEDCPP_PRE_PED)+1) from VDPEDCPP where CAST(VDPEDCPP_PRE_PED AS VARCHAR(12)) LIKE   '%' || cast(dataEmissao as varchar(8)) || '%'; 	  
		  
		IF NUMEROPEDIDO = NULL THEN	       
			set NUMEROPEDIDO = cast(concat(cast(dataEmissao as varchar(8)),'0001') as BIGINT);
		END IF;
					  
		set prepedido = select VDPEDCPP_PRE_PED from VDPEDCPP where VDPEDCPP_PRE_PED = NUMEROPEDIDO;		
			
			
		if prepedido <> null then 			   
			set NUMPREPEDIDO = prepedido;
			set STATUSMSG = 0;		
			set msg = 'Capa de pre pedido já existe';
		else
		    if NEMP             = null or
			   dataEmissao      = null or 				   	 
			   CGCNOVO          = null or 
			   tipocob          = null or 
			   condpagamento    = null or
			   codven           = null or
			   UPPER(ORIGEM)    <> 'L'  then
			   set STATUSMSG = 0;		
			   set msg = 'os campos NEMP,dataEmissao, CGCNOVO, tipocob, condpagamento, valor_liquido_portal são obrigatorio e origem so pode ser R (SFA) e L (Portal)';		 
			else
			    IF UPPER(ORIGEM) = 'L' THEN 
				    INSERT INTO VDPEDCPP(VDPEDCPP_NREMP      ,
							 VDPEDCPP_PRE_PED    ,					 							 				 
							 VDPEDCPP_CODCLI     ,
							 VDPEDCPP_CGC        ,
							 VDPEDCPP_FL_ORIGEM  ,
							 VDPEDCPP_VEN        ,
							 VDPEDCPP_TPCOBR     , 	
							 VDPEDCPP_CPG        ,
							 VDPEDCPP_DESC       ,
							 VDPEDCPP_TXFIN      ,
							 VDPEDCPP_VLRTOTAL   
							 ) 
							 VALUES (   NEMP,
										NUMEROPEDIDO,										
										CODCLI,
										CAST(CGCNOVO AS DECIMAL(15,0)),
										UPPER(origem), 
										substring(codven,6,3),
										tipocob,
										condpagamento,																		
										desconto,
										taxa_fin,
										valor_liquido_portal
										);
			    end if;
				set prepedido = select VDPEDCPP_PRE_PED from VDPEDCPP where VDPEDCPP_PRE_PED = NUMEROPEDIDO;
					if prepedido <> null then
						set NUMPREPEDIDO = prepedido;
						set STATUSMSG = 1;	
						set msg = 'Incluido com sucesso';
					
					else
						set STATUSMSG = 0;		
						set msg = 'Erro ao incluir';	
					end if;	 
			end if;
	    end if;	
				
END;
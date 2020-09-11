create OR REPLACE procedure DBCONTROL2187002.SP_INSERT_CAPAPREPEDIDO ( in  NEMP          smallint,
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
												   IN REGIAO             INT,
												    IN dia                smallint,
													IN carga             SMALLINT,
													IN rota               CHAR(003),
													IN valorBruto           DECIMAL(11,2),
													IN valorLiquidoSFA             DECIMAL(11,2), 
													IN valorBonificado             DECIMAL(11,2), 
													IN valorDesconto             DECIMAL(11,2), 
													IN valorVerba           DECIMAL(11,2), 
													IN valorFinal             DECIMAL(11,2), 
													IN codigoMotivoNaoCompra            CHAR(003),
													in horaInicialPedido               bigINT,
													IN horaFinalPedido               bigINT,
													IN statusTransmitidoWebService            CHAR(001),
													IN pedidoAberto      CHAR(001),
													IN pedidoBloqueado          CHAR(001),													
													IN duracaoPedido            INT,
													IN gpsLatitude   DECIMAL(9,6),
													IN gpsLongitude   DECIMAL(9,6),
													IN tecnologiaUtiliz        CHAR(001),
													IN distanciaGPS          INT,
													IN qtdSatelites        SMALLINT,
													IN imediato           CHAR(001),
													IN bonusUtilizado    DECIMAL(10,2),  
													IN observacao                VARCHAR(044),
													IN valorImpostoBarreira  DECIMAL(10,2),
													IN valorVerbaGeradaGL   DECIMAL(11,2),
													IN valorVerbaUtilizadaGL   DECIMAL(11,2),
													IN pedidoTransmitido SMALLINT,
													IN desbloqueioGPSERP    SMALLINT,
													in dataPrimeiraParcela INT,
                                                                                                        in codigoErpTerceiro smallint,
                                                                                                        in vlrpagocielo DECIMAL(13,2),
                                                                                                        in bandeiracielo SMALLINT,
                                                                                                        in ordernumbercielo CHAR(068),
                                                                                                        in tidcielo CHAR(020),
                                                                                                        in digcartaocielo SMALLINT,
                                                                                                        in statuscielo CHAR(003),
                                                                                                        in datapagamentocielo CHAR(020),
                                                                                                        in protocolocanccielo CHAR(020),
                                                                                                        in datacanccielo CHAR(020),
                         									   OUT  NUMPREPEDIDO BIGINT, 
												   OUT STATUSMSG     SMALLINT,
												   out msg           varchar(255)
												   )
										



										
																
		LANGUAGE SQL 
		BEGIN 

		declare prepedido bigint;
		declare prepedidosemnumero bigint;
		DECLARE CGCNOVO VARCHAR(015);
		declare seq int;
		declare NUMEROPEDIDO BIGINT;
		declare _data varchar(8);
		  
		  SET CGCNOVO = CNPJ_CPF;
		   
		  IF LENGTH(CGCNOVO) <= 11 THEN
				SET CGCNOVO =  CONCAT(CONCAT(SUBSTRING(CGCNOVO,1,9),'0000'),SUBSTRING(CGCNOVO,10,2));        	
		  END IF;
			  
		  set _data = cast(dataEmissao as varchar(8)) ;		  
		  set NUMEROPEDIDO = select (MAX(VDPEDCPP_PRE_PED)+1) from VDPEDCPP where CAST(VDPEDCPP_PRE_PED AS VARCHAR(12)) LIKE   '%' || _data || '%'; 	  
		  
		  IF NUMEROPEDIDO = NULL THEN	       
			 set NUMEROPEDIDO = cast(concat(cast(dataEmissao as varchar(8)),'0001') as BIGINT);
		  END IF;
					  
			set prepedido = select VDPEDCPP_PRE_PED from VDPEDCPP where VDPEDCPP_PRE_PED = NUMEROPEDIDO;		
			
			
			if prepedido <> null then 
			   set prepedidosemnumero = select VDPEDCPP_PRE_PED from VDPEDCPP where VDPEDCPP_PRE_PED = NUMEROPEDIDO and VDPEDCPP_NPED is null;
			   if prepedidosemnumero <> null then
			      	update 	VDPEDCPP set VDPEDCPP_CANCSN = 1 where 	VDPEDCPP_PRE_PED = NUMEROPEDIDO;
				set NUMPREPEDIDO = prepedidosemnumero;
				set STATUSMSG = 1;	
				set msg = 'Cancelado com sucesso';
			   else
					set NUMPREPEDIDO = prepedido;
					set STATUSMSG = 0;		
					set msg = 'Capa de pre pedido j  existe';
			   end if;
			else
			   if NEMP             = null or
				   dataEmissao      = null or 				   	 
				   CGCNOVO          = null or 
				   tipocob          = null or 
				   condpagamento    = null or
				   codven           = null or
				   UPPER(ORIGEM)    <> 'R' and  		  
				   UPPER(ORIGEM)    <> 'L' then 
				   set STATUSMSG = 0;		
				   set msg = 'os campos NEMP,dataEmissao, CGCNOVO, tipocob, condpagamento, valor_liquido_portal s o obrigatorio e origem so pode ser R (SFA) e L (Portal)';		 
			    else
			       set prepedido = select VDPEDCPP_PRE_PED from VDPEDCPP where VDPEDCPP_NREMP = NEMP and VDPEDCPP_CODCLI = CODCLI and VDPEDCPP_VLRTOTAL = valor_liquido_portal and CAST(SUBSTRING(CAST(VDPEDCPP_PRE_PED AS VARCHAR(12)),1,8) AS INT) = dataEmissao and  VDPEDCPP_TPCOBR = tipocob and  VDPEDCPP_CPG = condpagamento;
			       
			       IF prepedido = null then
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
							 VDPEDCPP_VLRTOTAL   ,
							 VDPEDCPP_DT1VC
							 ) 
							 VALUES (   NEMP,
										NUMEROPEDIDO,										
										CODCLI,
										CAST(CGCNOVO AS DECIMAL(15,0)),
										UPPER(origem)    , 
										CASE WHEN LENGTH(TRIM(CODVEN)) <> 8 THEN
										    substring(codven,1,3)
											else
											substring(codven, 6, 3) end,
										tipocob   ,
										condpagamento       ,																		
										desconto      ,
										taxa_fin      ,
										valor_liquido_portal,
                                        dataPrimeiraParcela										
										);
				    ELSE 			
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
							 VDPEDCPP_VLRTOTAL   ,
							 VDPEDCPP_REGIAO     ,
								VDPEDCPP_DIA                 ,								
								VDPEDCPP_SEQCRG              ,
								VDPEDCPP_ROTA                ,
								VDPEDCPP_DTEMI               ,
								VDPEDCPP_VLRBRUTO            ,
								VDPEDCPP_VLRLIQ              ,
								VDPEDCPP_VLRBON              ,
								VDPEDCPP_VLRDSC              ,
								VDPEDCPP_VLRVERBA            ,
								VDPEDCPP_VLRFIN              ,								
								VDPEDCPP_MCOMPRA             ,
								VDPEDCPP_HORI                ,
								VDPEDCPP_HORF                ,
								VDPEDCPP_STATUS1             ,
								VDPEDCPP_PEDIDO_ABERTO       ,
								VDPEDCPP_BLOQUEADO           ,
								VDPEDCPP_DURACAO             ,
								VDPEDCPP_COORDENADA_X        ,
								VDPEDCPP_COORDENADA_Y        ,
								VDPEDCPP_TIPOCAPTURA         ,
								VDPEDCPP_DISTANCIA           ,
								VDPEDCPP_NRSATELITES         ,
								VDPEDCPP_IMEDIATO            ,
								VDPEDCPP_BONUS_UTILIZADO     ,  
								VDPEDCPP_OBS                 ,
								VDPEDCPP_VALOR_IMPBARREIRA   ,
								VDPEDCPP_VAL_VERBA_GERADA    ,
								VDPEDCPP_VAL_VERBA_UTILIZ    ,
								VDPEDCPP_PEDIDO_TRANSMITIDO  ,								
								VDPEDCPP_DESBLOQUEIO_GPS     ,
                                VDPEDCPP_DT1VC ,
                                VDPEDCPP_CODERP_TERCEIRO,
                                VDPEDCPP_VLR_PAGO_CIELO,
                                VDPEDCPP_BANDEIRA_CIELO,
                                VDPEDCPP_ORDER_NUMBER_CIELO,
                                VDPEDCPP_TID_CIELO,
                                VDPEDCPP_4_DIG_CARTAO_CIELO,
                                VDPEDCPP_STATUS_CIELO,
                                VDPEDCPP_DATA_PAGAMENTO_CIELO,
                                VDPEDCPP_PROTOCOLO_CANC_CIELO,
                                VDPEDCPP_DATA_CANC_CIELO        								
							 ) 
							 VALUES (   NEMP,
										NUMEROPEDIDO,
										
										CODCLI,
										CAST(CGCNOVO AS DECIMAL(15,0)),
										UPPER(origem)    , 
										CASE WHEN LENGTH(TRIM(CODVEN)) <> 8 THEN
										    substring(codven,1,3)
											else
											substring(codven, 6, 3) end,
										tipocob   ,
										condpagamento       ,																		
										desconto      ,
										taxa_fin      ,
										valorLiquidoSFA ,														 
										REGIAO            ,
										dia                            ,  
										carga                          ,  
										rota                           ,  
										dataEmissao                    ,  
										valorBruto                     ,  
										valorLiquidoSFA                ,  
										valorBonificado                ,  
										valorDesconto                  ,  
										valorVerba                     ,  
										valorFinal                     ,  
										codigoMotivoNaoCompra          ,  
										horaInicialPedido              ,  
										horaFinalPedido                ,  
										statusTransmitidoWebService    ,  
										pedidoAberto                   ,  
										pedidoBloqueado                ,  
										duracaoPedido                  ,  
										gpsLatitude                    ,  
										gpsLongitude                   ,  
										tecnologiaUtiliz               ,  
										distanciaGPS                   ,  
										qtdSatelites                   ,  
										imediato                       ,  
										bonusUtilizado                 ,  
										observacao                     ,  
										valorImpostoBarreira           ,  
										valorVerbaGeradaGL             ,  
										valorVerbaUtilizadaGL          ,  
										pedidoTransmitido              ,  										
										desbloqueioGPSERP              ,
										dataPrimeiraParcela            ,
                                                                                codigoErpTerceiro              ,
				                                                vlrpagocielo                 ,
                                                                                bandeiracielo                  ,
                                                                                ordernumbercielo               ,
                                                                                tidcielo                       ,
                                                                                digcartaocielo                ,
                                                                                statuscielo                    ,
                                                                                datapagamentocielo             ,
                                                                                protocolocanccielo     ,
                                                                                datacanccielo
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
			else
			  set NUMPREPEDIDO = prepedido;
			  set STATUSMSG = 0;		
			  set msg = 'Registro duplicado';   	 
			end if;
		 end if;	
	    end if;	
	END;
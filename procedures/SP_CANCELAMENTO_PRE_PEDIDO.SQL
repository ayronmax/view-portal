create OR REPLACE procedure SP_CANCELAMENTO_PRE_PEDIDO (in  NEMP               smallint,
														in  numeroPedido      bigint,
														OUT NUMPREPEDIDO       BIGINT, 
														OUT STATUSMSG          SMALLINT,
														out msg                varchar(255))
																
LANGUAGE SQL 
BEGIN 
		
	declare prepedido bigint;
	declare prepedidosemnumero bigint;

	set prepedido = select VDPEDCPP_PRE_PED from VDPEDCPP where VDPEDCPP_PRE_PED = NUMEROPEDIDO and VDPEDCPP_NREMP = NEMP;		
			
	if prepedido <> null then 
	   set prepedidosemnumero = select VDPEDCPP_PRE_PED from VDPEDCPP where VDPEDCPP_PRE_PED = NUMEROPEDIDO and VDPEDCPP_NPED is null;
	   
	   if prepedidosemnumero <> null then
	     update VDPEDCPP set VDPEDCPP_CANCSN = 1 where 	VDPEDCPP_PRE_PED = NUMEROPEDIDO;
	     set NUMPREPEDIDO = prepedidosemnumero;
		 set STATUSMSG = 1;	
		 set msg = 'Cancelado com sucesso';
	   end if;
	else
		set NUMPREPEDIDO = prepedido;
		set STATUSMSG = 0;		
		set msg = 'Pre Pedido ja efetivado';
	end if;		 
				
END;



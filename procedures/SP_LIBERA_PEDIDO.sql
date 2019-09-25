CREATE or replace PROCEDURE SP_LIBERA_PEDIDO(IN nremp SMALLINT,
                                  IN numeroPedido BIGINT, 
                            in codigoStatus smallint,
							out alterou  smallint)
							
LANGUAGE SQL 
BEGIN 
    
	
	declare pedido BIGINT;	
	declare capaPedido BIGINT;	
		
	set pedido = SELECT VDPEDCPE_NPED FROM PEDCP61 where VDPEDCPE_NPED =  numeroPedido;	
    set capaPedido = SELECT VDPEDFLC_NPED FROM VDPEDFLC where VDPEDFLC_NPED =  numeroPedido;	
	
	if pedido <> null then 
	    update PEDCP61 set VDPEDCPE_FL = codigoStatus where VDPEDCPE_NPED =numeroPedido; 	    
        IF capaPedido = null then
			INSERT INTO VDPEDFLC VALUES (nremp, numeroPedido, codigoStatus, numeroPedido, situacaoPedido, numeroPedido,0 ,' ', 0, 0, 0, 'D', 0,0,0);		
		else 
		    update VDPEDFLC set VDPEDFLC_SIT_NPED = codigoStatus 
	        where VDPEDFLC_NPED = numeroPedido;
		end if;		  
		INSERT INTO VDPEDFLI
	    VALUES (nremp, (Select  MAX( VDPEDFLI.VDPEDFLI_SEQUENCIA) + 1 from VDPEDFLI), Cast( Replace(Cast(Curdate() AS VARCHAR( 10)), '-', '') AS INT), Cast( REPLACE(CAST(CURTIME() AS VARCHAR(10)),':','') AS INT), Cast( Replace(Cast(Curdate() AS VARCHAR( 10)), '-', '') AS INT), 'POR','POR' ,'SP_LIBPD','18.01.001',1,002,numeroPedido,codigoStatus,numeroPedido,codigoStatus,0,0,'0',0,0,0);		
		set alterou = 0;
    else
	  set alterou = 1;
	end if;
	
	
END;



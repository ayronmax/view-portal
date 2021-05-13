CREATE OR REPLACE PROCEDURE DBCONTROL2016001.sp_pesquisa_mensal(
in cod_vendedor    varchar(008),
in regiao_cliente  varchar(004),
in numero_cliente  varchar(004),
in versao_pesq     VARCHAR(003),
in codigo_produto  varchar(010),
in concorrente     varchar(003),
in motivo          char(01),
in data_pesq       varchar(010),
in quant_compra    varchar(010),
in preco_compra_cx decimal(13,2),
in preco_venda_un  decimal(13,2),
out cod_status     smallint,
out status_msg     varchar(255))
											
LANGUAGE SQL 

BEGIN 

  declare produto_cfam int;
  declare produto_nro  int;
  declare cod_produto  bigint;
  declare vendedor char(003);           
  declare seq  int;
  declare pesquisa int;	           
  declare regiao_cli      int;
  declare num_cliente     int;
  declare versao_pesquisa int;				    
  declare qtd_compra  decimal(8,3);

  if cod_vendedor is null or 
     regiao_cliente is null or 
     numero_cliente is null or 
     versao_pesq    is null or
     codigo_produto is null then			  
     set cod_status = 1;
     set status_msg = 'Campos obrigatorios : cod_vendedor, regiao_cli, num_cliente, versao_pesquisa, cod_produto';									 
  else
     set cod_produto = CAST(codigo_produto AS BIGINT);					
     set produto_cfam = select VDPRDPRD_CFAM from cadprd01 where VDPRDPRD_CODR = cod_produto;
     set produto_nro = select VDPRDPRD_NRO  from cadprd01 where VDPRDPRD_CODR = cod_produto;
     SET regiao_cli = CAST(regiao_cliente AS INT);
     SET num_cliente = CAST(numero_cliente AS INT);
     SET versao_pesquisa = CAST(versao_pesq AS INT);
     set vendedor = SUBSTRING(cod_vendedor,6,4);					
     set seq = select VDGERCOC_SEQ from CONCOR01 where VDGERCOC_COD = concorrente;
     
     if motivo <> '*' then
        delete from pesqvd01 where VDGERPVD_VERSAO = versao_pesquisa and
         			   VDGERPVD_CFAM = produto_cfam and
		     		   VDGERPVD_NRO  = produto_nro and
		     		   VDGERPVD_REGI = regiao_cli and
		     		   VDGERPVD_NUM = num_cliente;
     else
        delete from pesqvd01 where VDGERPVD_VERSAO = versao_pesquisa and
         			   VDGERPVD_CFAM = produto_cfam and
		     		   VDGERPVD_NRO  = produto_nro and
		     		   VDGERPVD_REGI = regiao_cli and
		     		   VDGERPVD_NUM = num_cliente and
		     		   VDGERPVD_MOTIVO <> '*';		     		   
     end if;
     			 
     if quant_compra = '' then 
        set qtd_compra = 0;
     else
        set qtd_compra = CAST(quant_compra AS DECIMAL(08,3));
     end if;
   
     if seq = null then
        set seq = 1;
     end if;
		     
     if concorrente = '-1' then
        set concorrente = '';
     end if;
		     
     insert or replace into pesqvd01(VDGERPVD_VERSAO,
		     	    VDGERPVD_CFAM,
		     	    VDGERPVD_NRO,
		     	    VDGERPVD_SEQ,
		     	    VDGERPVD_CONCORRENTE,
		     	    VDGERPVD_REGI,
		     	    VDGERPVD_NUM,
		     	    VDGERPVD_VENDEDOR,
			    VDGERPVD_PRESSAO,
		     	    VDGERPVD_MOTIVO,
		     	    VDGERPVD_DATA_PESQ,
		     	    VDGERPVD_QTD_COMPRA,
		     	    VDGERPVD_PRE_COMPRA,
		     	    VDGERPVD_PRE_VENDA,
		     	    VDGERPVD_DATA_SIS)
	                values(versao_pesquisa,            
		     	       produto_cfam,            
		     	       produto_nro,            
		     	       seq,            
		     	       concorrente,            
		     	       regiao_cli,            
		     	       num_cliente,            
		     	       vendedor,            
		     	       '',
		     	       motivo,                                                    
                               cast(replace(data_pesq, '-', '') as int), 
		     	       qtd_compra,            
		     	       preco_compra_cx,            
		     	       preco_venda_un,            
		     	       cast(DATETOSTR(Curdate(), 'yyyymmdd') as int));
      
   end if;		

   if motivo <> '*' then
      set pesquisa = select VDGERPVD_CFAM from pesqvd01 where VDGERPVD_VERSAO = versao_pesquisa and
	      						      VDGERPVD_CFAM = produto_cfam and
		   					      VDGERPVD_NRO  = produto_nro and
		   					      VDGERPVD_REGI = regiao_cli and
		   					      VDGERPVD_NUM = num_cliente;
   else	   					   
      set pesquisa = select VDGERPVD_CFAM from pesqvd01 where VDGERPVD_VERSAO = versao_pesquisa and
	      						      VDGERPVD_CFAM = produto_cfam and
		   					      VDGERPVD_NRO  = produto_nro and
		   					      VDGERPVD_SEQ = seq and
		   					      VDGERPVD_CONCORRENTE = concorrente and
		   					      VDGERPVD_REGI = regiao_cli and
		   					      VDGERPVD_NUM = num_cliente;
   end if;
   		   					      
   if pesquisa <> null then
      set cod_status = 0;
      set status_msg = 'inserido com sucesso';
   else
      set cod_status = 1;
      set status_msg = 'erro ao inserir';
   end if;
    		
END;          
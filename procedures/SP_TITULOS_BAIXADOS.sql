create or replace procedure
		SP_TITULOS_BAIXADOS(in cpfCnpj VARCHAR(15),
											  in numeroTitulo VARCHAR(8),
											  in numeroParcela varchar(2),
											  in tipoTitulo smallint,
											  in dataEmissao INT,
											  in dataVencimento INT,
											  in dataPagamento INT,
											  in valorTitulo DECIMAL(13, 2),
 											  in bancoBaixa INT,
											  in tipoCobranca INT,
											  in nossoNumero varchar(10),
											  out cod_erro smallint,
											  out message_erro varchar(50))

language sql

begin
declare CODIGO_CLIENTE varchar(8);
declare movimento_cliente int;

set CODIGO_CLIENTE = select concat(cast (vdclicli_regi as VARCHAR(4)), concat(repeat('0', 4 -length(cast(vdclicli_num as VARCHAR(4)))), cast(vdclicli_num as VARCHAR(4)) ))  from cadcli61 where vdclicli_cgc =  cast(cpfCnpj as decimal(15,0));
    

	IF CODIGO_CLIENTE <> NULL then 
	   
	   
	   
	   insert into cadbai61(
						CRMOVBAI_CCLI,						
						CRMOVBAI_NDUPL,
						CRMOVBAI_TPLANC,
						CRMOVBAI_DTE,	
						CRMOVBAI_DTV,
						CRMOVBAI_DTP,
						CRMOVBAI_VALOR,
						CRMOVBAI_BCO,
						CRMOVBAI_MOD,
						CRMOVBAI_DOCCNT)
               values(cast(CODIGO_CLIENTE as int),
			          cast(concat(numeroTitulo, numeroParcela) as char),					  
					  tipoTitulo,				     
					  dataEmissao,
					  dataVencimento,
					  dataPagamento,
					  valorTitulo,
					  bancoBaixa,
					  tipoCobranca,
					  nossoNumero);
					  
		set movimento_cliente = select CRMOVBAI_CCLI from cadbai61 where CRMOVBAI_CCLI = cast(CODIGO_CLIENTE as int) 
								and CRMOVBAI_NDUPL = cast(concat(numeroTitulo, numeroParcela) as char) 
								and CRMOVBAI_TPLANC = tipoTitulo
								and CRMOVBAI_DTP = dataPagamento;
								
		if movimento_cliente <> null then
		   set cod_erro = 0;
		   set message_erro = 'Inserido com sucesso';
		else
           set cod_erro = 1;
		   set message_erro = 'Erro ao inserir o movimento de baixa'; 		
		end if;
	else 
	    set cod_erro = 1;
		set message_erro = 'Cliente com o cnpj ou cpf nao existe'; 		
	end if;

end;

CREATE OR REPLACE PROCEDURE SP_PRE_PAGAMENTOS(
				in numeroEmpresa        smallint,
        in codigoCliente        int,
				in numeroTitulo         varchar(30),
				in tipoLancamento       int,
				in dataEmissao          int,
				in dataVencimento       int,
				in dataPagamento        int,
				in valorTitulo          decimal(13,2),
				in valorPagamento       decimal(13,2),
				in percentualJuros      decimal(7,4),
				in valorJuros           decimal(13,2),
				in percentualMora       decimal(7,4),
				in valorMora            decimal(13,2),
				in percentualDesconto   decimal(7,4),
				in valorDesconto        decimal(13,2),
				in percentualTransacao   decimal(7,4),
				in valorTransacao        decimal(13,2),
				in codigoTransacao       varchar(30),
				in numeroBoleto         varchar(20),
				out status_msg          smallint,
				out msg                 varchar(255)
				)
				
LANGUAGE SQL

BEGIN
        declare dataSistemaOperacional int;
        set dataSistemaOperacional = SELECT CAST(REPLACE(CAST(CURDATE() AS CHAR(10)),'-','') AS INT);

        if (numeroEmpresa  = null or numeroEmpresa  = 0)  or
           (codigoCliente  = null or codigoCliente  = 0)  or
           (numeroTitulo   = null or numeroTitulo   = '') or
           (tipoLancamento = null or tipoLancamento = 0)  or
           (dataEmissao    = null or dataEmissao    = 0)  or
           (dataVencimento = null or dataVencimento = 0)  or
           (dataPagamento  = null or dataPagamento  = 0)  or
           (valorTitulo    = null or valorTitulo    = 0)  or
           (valorPagamento = null or valorPagamento = 0)  or
           (codigoTransacao = null or codigoTransacao = '')
           
           then
              set status_msg = 1;
              set msg = 'campo: numeroEmpresa, codigoCliente, numeroTitulo, tipoLancamento, dataEmissao, dataPagamento, dataVencimento, valorTitulo, valorPagamento, codigoTransacao, nÆo pode ser null';
        else
           
           
			     insert into CRMOVPRE(CRMOVPRE_NREMP,
                                CRMOVPRE_COD_CLI,
                                CRMOVPRE_NDUPL,
                                CRMOVPRE_TPLANC,
                                CRMOVPRE_LOGDT,
                                CRMOVPRE_INCLDT,
                                CRMOVPRE_INCLSIGLA,
                                CRMOVPRE_NIVELAUDIT,
                                CRMOVPRE_DT_EMIS,
                                CRMOVPRE_DT_VENC,
                                CRMOVPRE_DT_PGTO,
                                CRMOVPRE_VLR_TITULO,
                                CRMOVPRE_VLR_PGTO,
                                CRMOVPRE_PER_JUROS,
                                CRMOVPRE_VLR_JUROS,
                                CRMOVPRE_PER_MORA,
                                CRMOVPRE_VLR_MORA,
                                CRMOVPRE_PER_DESC,
                                CRMOVPRE_VLR_DESC,
                                CRMOVPRE_PER_TRANSACAO,
                                CRMOVPRE_VLR_TRANSACAO,
                                CRMOVPRE_COD_TRANSACAO,
                                CRMOVPRE_NUM_BOLETO)
			     values(numeroEmpresa,
			            codigoCliente,
			            upper (numeroTitulo),
			            tipoLancamento,
			            dataSistemaOperacional,
			            dataSistemaOperacional,
			            'POR',
			            10,
			            dataEmissao,
			            dataVencimento,
			            dataPagamento,
			            valorTitulo,
			            valorPagamento,
			            percentualJuros,
			            valorJuros,
			            percentualMora,
			            valorMora,
			            percentualDesconto,
			            valorDesconto,
			            percentualTransacao,
			            valorTransacao,
			            codigoTransacao,
			            numeroBoleto
			     				);
			     				
			     set status_msg = 0;
			     set msg = 'Cadastrado com sucesso'; 
           
           
        end if;


END;



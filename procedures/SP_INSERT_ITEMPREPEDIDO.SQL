CREATE OR REPLACE PROCEDURE SP_INSERT_ITEMPREPEDIDO (IN COD_NEMP SMALLINT,
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
IN valorLiquidoUmaCaixa DECIMAL(19,8),
IN valorLiquidoUmAvulso DECIMAL(19,8),
in carga             smallint,        
in valorBonificado         DECIMAL(9,2),    
in valorDesconto        DECIMAL(9,2),    
in valorVerba       DECIMAL(9,2),    
in numAtivoCev       CHAR(013),    
in codigoMotivoOcorrencia            CHAR(003),       
in flagDev           char(001),         
in codigoBandaPreco           CHAR(001),       
in codigoAcaoSolavanco       CHAR(001),       
in itemAlteradoBandaPreco        SMALLINT,        
in itemOrigemAcaoSolavanco     SMALLINT,        
in tipoRecolhimento      CHAR(001),       
in permiteAlterarQtdBonificada        CHAR(001),       
in acaoQtdAutorizada     INT,             
in bonusGerado      DECIMAL(8,2),    
in valorImpostoBarreira DECIMAL(8,2),    
in bonusUtilizado   DECIMAL(8,2),    
in faixaBandaOrigem  SMALLINT,        
in perfilTabela         SMALLINT,        
in valorVerbaUtilizadaGL  DECIMAL(11,2),   
in codigoVerbaGeradaGL  SMALLINT,        
in itemValidadoBonificaoAutomatica     CHAR(001),       
in horaInicialPedido              bigint,
                                                                                        in ultimo_item                    CHAR(001),
                                                                                        IN PRECO_NEGOCIADO SMALLINT,                                                                                        
                                                                                        IN VALOR_LIQ_UMA_CAIXA DECIMAL(11,4),
                                                                                        IN VALOR_LIQ_UM_AVULSO DECIMAL(11,4),
                                                                                        IN VALOR_LIQ_FINAL DECIMAL(9,2),
                                                                                        IN VALOR_ACRESCIMO_CAPA DECIMAL(7,2),
                                                                                        IN VALOR_DESCONTO_CAPA DECIMAL(7,2),
in aliq_pvv DECIMAL (4,2),
in QUANTIDADE_NA_CX INTEGER,
OUT STATUSMSG       SMALLINT,
OUT MSG             VARCHAR(255)
                        )
LANGUAGE SQL  
BEGIN 
   #ORIGEM = (L = PORTAL / R = SFA VIA PORTAL)
       
   declare prepedido bigint;

   declare ITEM bigint;
   
   declare ORIGEM char(001);
   
   declare codprd integer;
   
   declare QTD_CX integer;
   
   declare PREPRDUS DECIMAL(9,4);
   
   set QTD_CX = select VDPRDPRD_QTDUN FROM CADPRD01 where VDPRDPRD_CODR  = COD_RED;
   
   set codprd = select cast(concat(repeat('0',3 - length(cast(VDPRDPRD_CFAM as varchar(3)))),cast(VDPRDPRD_CFAM as varchar(3)))||
       concat(repeat('0',3 - length(cast(VDPRDPRD_NRO as varchar(3)))), cast(VDPRDPRD_NRO as varchar(3))) as int)
       from cadprd01 where VDPRDPRD_CODR  = COD_RED;
   
    SET ITEM = SELECT VDPEDIPP_PRE_PED FROM VDPEDIPP WHERE VDPEDIPP_PRE_PED = COD_PRE_PEDIDO AND VDPEDIPP_NREMP = COD_NEMP AND VDPEDIPP_ITEM = SEQ_ITEM;
   
    IF ITEM <> NULL THEN
    SET STATUSMSG = 0;
SET MSG = 'ITEM J ? EXISTE NESSA SEQUENCIA';
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
                    IF ORIGEM = 'L' and ORIGEM = null THEN 
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
VDPEDIPP_PREPRDUS ,
VDPEDIPP_MOTIVO,
VDPEDIPP_PRECO_NEGOC,
VDPEDIPP_VL_LIQ_UMA_CAIXA,
VDPEDIPP_VL_LIQ_UM_AVULSO,
VDPEDIPP_VL_LIQ_FINAL,
VDPEDIPP_VL_ACRESC_CAPA,
VDPEDIPP_VL_DESCONTO_CAPA,
VDPEDIPP_ALIQPVV_TBPRD 
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
(CAST(ROUND((valorLiquidoUmAvulso),4) AS DECIMAL(9,4)))             ,
codigoMotivoOcorrencia,
PRECO_NEGOCIADO,                                                                                        
                                                        VALOR_LIQ_UMA_CAIXA,
                                                        VALOR_LIQ_UM_AVULSO,
                                                        VALOR_LIQ_FINAL,
                                                        VALOR_ACRESCIMO_CAPA,
                                                        VALOR_DESCONTO_CAPA,
aliq_pvv														
);
    IF ultimo_item = 'S' THEN 
                   UPDATE VDPEDCPP SET VDPEDCPP_MOSTRA = 1 WHERE  VDPEDCPP_PRE_PED = COD_PRE_PEDIDO AND VDPEDCPP_NREMP = COD_NEMP;
            END IF;
SET STATUSMSG = 1;
SET MSG = 'ITEM INCLUIDO COM SUCESSO';
  
ELSE

--  IF VALOR_LIQ <> VALOR_BRUTO THEN 
--	SET PREPRDUS = CAST(ROUND(valorLiquidoUmaCaixa / QTD_CX,4) AS DECIMAL(9,4));
--  ELSE
--	SET PREPRDUS =CAST(ROUND(valorLiquidoUmAvulso,4) AS DECIMAL(9,4));
--	END IF;

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
VDPEDIPP_PREPRDUS   ,   
                           
VDPEDIPP_CARGA            ,
VDPEDIPP_VALORBON1        ,
VDPEDIPP_VALORDESC1       ,
VDPEDIPP_VALORVERBA1      ,
VDPEDIPP_NUM_ATV_CEV      ,
VDPEDIPP_MOTIVO           ,
VDPEDIPP_FLAGDEV          ,
VDPEDIPP_TPVENDA          ,
VDPEDIPP_ACAOMERCADO      ,
VDPEDIPP_FLAG_BANDA       ,
VDPEDIPP_FLAG_ACAOMERC    ,
VDPEDIPP_TIPO_RECOLHE     ,
   
VDPEDIPP_VENALTBONI       ,
VDPEDIPP_ACAO_QTD_AUTO    ,
VDPEDIPP_BONUS_GERADO     ,
VDPEDIPP_VALOR_IMPBARREIRA ,
   
VDPEDIPP_BONUS_UTILIZADO  ,
VDPEDIPP_FAIXA_BANDA_ORIG ,
VDPEDIPP_PERFILTAB        ,
VDPEDIPP_VAL_VERBA_UTILIZ ,
VDPEDIPP_COD_VERBA_GERADA ,
VDPEDIPP_APLICOU_VERBA,
VDPEDIPP_HORI,
VDPEDIPP_PREPRDT_CX,
VDPEDIPP_PREPRDT_AV,
VDPEDIPP_PRECO_NEGOC,
        VDPEDIPP_VL_LIQ_UMA_CAIXA,
        VDPEDIPP_VL_LIQ_UM_AVULSO,
        VDPEDIPP_VL_LIQ_FINAL,
        VDPEDIPP_VL_ACRESC_CAPA,
        VDPEDIPP_VL_DESCONTO_CAPA,
VDPEDIPP_ALIQPVV_TBPRD		
)
VALUES (
COD_NEMP          ,
COD_PRE_PEDIDO    ,
SEQ_ITEM          ,
COD_OCORRENCIA    ,
COD_RED           ,
codprd            ,
QUANTIDADE_CX     ,
QUANTIDADE_UN     ,
TABLEPRECO        ,
DESCONTO          ,
VALOR_LIQ         ,
VALOR_BRUTO       ,
valorLiquidoUmaCaixa ,
CASE WHEN VALOR_LIQ <> VALOR_BRUTO THEN CAST(ROUND(valorLiquidoUmaCaixa / QTD_CX,4) AS DECIMAL(9,4)) ELSE CAST(ROUND(valorLiquidoUmAvulso,4) AS DECIMAL(9,4)) END,
carga                           ,
valorBonificado                 ,
valorDesconto                   ,
valorVerba                      ,
numAtivoCev                     ,
codigoMotivoOcorrencia          ,
flagDev                         ,
codigoBandaPreco                ,
codigoAcaoSolavanco             ,
itemAlteradoBandaPreco          ,
itemOrigemAcaoSolavanco         ,
tipoRecolhimento                ,
permiteAlterarQtdBonificada     ,
acaoQtdAutorizada               ,
bonusGerado                     ,
valorImpostoBarreira            ,
bonusUtilizado                  ,
faixaBandaOrigem                ,
perfilTabela                    ,
valorVerbaUtilizadaGL           ,
codigoVerbaGeradaGL             ,
itemValidadoBonificaoAutomatica ,
horaInicialPedido               ,
CAST(ROUND((QUANTIDADE_CX  * valorLiquidoUmaCaixa),2) AS DECIMAL(11,2)),
CAST(ROUND((QUANTIDADE_UN  * valorLiquidoUmAvulso),2) AS DECIMAL(9,2)),
PRECO_NEGOCIADO,                                                                                        
VALOR_LIQ_UMA_CAIXA,
VALOR_LIQ_UM_AVULSO,
VALOR_LIQ_FINAL,
VALOR_ACRESCIMO_CAPA,
VALOR_DESCONTO_CAPA ,
aliq_pvv
);

IF ultimo_item = 'S' THEN 
                   UPDATE VDPEDCPP SET VDPEDCPP_MOSTRA = 1 WHERE VDPEDCPP_PRE_PED = COD_PRE_PEDIDO AND VDPEDCPP_NREMP = COD_NEMP;
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
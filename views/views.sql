create function datetostr.DATETOSTR(DATE, varchar(20)) RETURNS varchar(20);
create function to_date.TO_DATE(varchar(20), varchar(20)) RETURNS DATE;

CREATE OR REPLACE VIEW VW_DADOS_CLIENTE AS 
SELECT 
  *, 
  cast(concat(concat(repeat('0',4-length(cast(vdclicli_regi as varchar(4)))),cast(vdclicli_regi as varchar(4))),concat(repeat('0',4-length(cast(vdclicli_num as varchar(4)))),cast(vdclicli_num as varchar(4)))) as VARCHAR(8)) CODIGO_CLIENTE
FROM 
  CADCLI01
INNER JOIN 
  (SELECT DISTINCT 
     VDCLIREG_COD, 
     VDCLIREG_NUMSUBEMPRESA_BW 
   FROM CADREG01) CADREG01 
   ON VDCLIREG_COD = VDCLICLI_REGI AND 
      VDCLIREG_NUMSUBEMPRESA_BW 
   BETWEEN 0000 AND 9999;

DECLARE SET INT @CODIGOPEDIDO = 0;

CREATE OR REPLACE view  vw_acompanhamento_pedido 
AS 
SELECT 
  vdpedflc_nped NUMERO_PEDIDO_GESTAO, 
  vdpedflc_sit_nped SITUACAO_PEDIDO_GESTAO, 
  vdpedflc_pnped NUMERO_PRE_PEDIDO_GESTAO, 
  vdpedflc_croma NUMERO_ROMANEIO, 
  vdpedflc_sit_crom SITUACAO_ROMANEIO, 
  vdpedflc_serie SERIE_NFISCAL, 
  vdpedflc_nf NUMERO_NFISCAL, 
  vdpedflc_cod_bloq_ped CODIGO_BLOQ_PEDIDO,
  VDPEDFLC_NPED_REPROGRA numero_pedido_erp_reprogramado 
FROM
  vdpedflc 
WHERE
  VDPEDFLC_NREMP = 1 AND (vdpedflc_nped = @codigopedido OR @codigopedido = 0);

DECLARE SET INTEGER @CODIGO_BANDA = 0;

CREATE OR replace VIEW  vw_banda_preco_item AS
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP,
                bdapre01.vdprdbda_bandprec_1 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_1    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_1   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_1 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_1 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_1 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_1" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4)
UNION ALL 
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP, 
                bdapre01.vdprdbda_bandprec_2 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_2    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_2   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_2 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_2 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_2 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_2" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4)
UNION ALL 
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP, 
                bdapre01.vdprdbda_bandprec_3 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_3    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_3   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_3 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_3 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_3 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_3" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4)
UNION ALL 
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP, 
                bdapre01.vdprdbda_bandprec_4 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_4    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_4   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_4 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_4 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_4 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_4" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4)
UNION ALL 
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP, 
                bdapre01.vdprdbda_bandprec_5 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_5    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_5   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_5 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_5 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_5 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_5" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4)
UNION ALL 
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP, 
                bdapre01.vdprdbda_bandprec_6 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_6    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_6   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_6 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_6 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_6 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_6" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4)
UNION ALL 
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP, 
                bdapre01.vdprdbda_bandprec_7 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_7    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_7   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_7 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_7 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_7 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_7" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4)
UNION ALL 
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP, 
                bdapre01.vdprdbda_bandprec_8 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_8    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_8   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_8 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_8 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_8 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_8" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4)
UNION ALL 
SELECT DISTINCT(bdapre01. "vdprdbda_id" )    AS CODIGO_BANDA_PRECO_ERP, 
                bdapre01.vdprdbda_bandprec_9 AS QUANTIDADE , 
                bdapre01.vdprdbda_tab_x_9    AS CODIGO_TABPRECO_ERP, 
                bdapre01.vdprdbda_descto_9   AS DESCONTO_MAXIMO 
FROM            bdapre01 
INNER JOIN      tabprc01 
ON              tabprc01.vdtabprd_ano = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_9 AS  VARCHAR(8)), 1,4 ) AS INT)
AND             tabprc01.vdtabprd_mes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_9 AS  VARCHAR(8)), 5,2 ) AS INT)
AND             tabprc01.vdtabprd_nmes = Cast(Substring(Cast(bdapre01.vdprdbda_tab_x_9 AS VARCHAR(8)), 7,2 ) AS INT)
WHERE           bdapre01. "vdprdbda_bandprec_9" <> 0 
AND             bdapre01. "vdprdbda_cancsn" = 0 
AND             ( 
                                bdapre01. "vdprdbda_id" = @CODIGO_BANDA 
                OR              @CODIGO_BANDA = 0 ) 
AND             LEFT(Cast( tabprc01.vdtabprd_dtvgf AS VARCHAR(8)),4 )>= LEFT(Cast(Curdate() - 365 AS CHAR(4)),4);

CREATE OR replace VIEW  vw_banda_preco_rest 
AS 
  SELECT 1 
         AS ATIVO 
            , 
         Cast(Cast(bdapre01. "vdprdbda_fam" AS VARCHAR(3)) 
              || Cast(bdapre01. "vdprdbda_prd" AS VARCHAR(3)) 
              || Cast(bdapre01. "vdprdbda_grp" AS VARCHAR(2)) 
              || Cast(bdapre01. "vdprdbda_cat" AS VARCHAR(2)) 
              || Cast(bdapre01. "vdprdbda_mar" AS VARCHAR(2)) 
              || Cast(bdapre01. "vdprdbda_reg" AS VARCHAR(4)) 
              || Cast(bdapre01. "vdprdbda_pst" AS VARCHAR(4)) 
              || Cast(bdapre01. "vdprdbda_grpcli" AS VARCHAR(4)) 
              || Cast(bdapre01. "vdprdbda_ven" AS VARCHAR(3)) 
              || Cast(bdapre01. "vdprdbda_can" AS VARCHAR(2)) 
              || Cast(bdapre01. "vdprdbda_grpcan" AS VARCHAR(2)) 
              || Cast(bdapre01. "vdprdbda_cpg" AS VARCHAR(2)) 
              || Cast(bdapre01. "vdprdbda_grpesc" AS VARCHAR(3)) AS VARCHAR(50)) 
         AS 
         CODIGO_BANDA_PRECO_ERP, 
         bdapre01. "vdprdbda_ven" 
         AS 
            CODIGO_VENDEDOR_ERP 
  FROM    bdapre01 
  WHERE  bdapre01. "vdprdbda_cancsn" = 0 
         AND bdapre01. "vdprdbda_ven" <> '   ' ;

declare set varchar(255) @CODIGO_CANAL = '';

CREATE OR REPLACE view  vw_canal_venda 
AS 
  SELECT CASE 
           WHEN ccat01. "vdclicat_cancsn" = 0 THEN 1 
           ELSE 0 
         end                            AS ATIVO, 
         ccat01. "vdclicat_autoserv"    AS AUTO_SERVICO, 
         ccat01. "vdclicat_cod"         AS CODIGO_CANAL, 
         ccat01. "vdclicat_grpcan"      AS CODIGO_GRUPO_CANAL, 
         ccat01. "vdclicat_nome"        AS DESCRICAO, 
         ccat01. "vdclicat_descr_compl" AS DESCRICAO_COMPLEMENTAR, 
         ccat01. "vdclicat_divcan" AS DIVISAO_CANAL 
  FROM    ccat01 
  WHERE  ( ccat01. "vdclicat_cod" = @codigo_canal 
            OR @codigo_canal = '' ) ;

DECLARE SET INT @CODIGO_CATEGORIA_PRODUTO = 0;

CREATE OR REPLACE view  vw_categoria_produto 
AS 
  SELECT catprd01. "vdprdcat_nr"    AS CODIGO_CATEGORIA_PRODUTO_ERP, 
         catprd01. "vdprdcat_descr" AS DESCRICAO 
  FROM    catprd01 
  WHERE  ( catprd01. "vdprdcat_nr" = @codigo_categoria_produto 
            OR @codigo_categoria_produto = 0 ) ;

DECLARE SET INT @NNF = 0;
DECLARE SET CHAR @SNF = ' ';

CREATE OR REPLACE view  vw_ch_nfiscal 
AS 
  SELECT vdfatnfr_nnf, 
         vdfatnfr_serie, 
         vdfatnfr_ident_nf 
  FROM    vdfatn01 
  WHERE  ( ( vdfatnfr_nnf = @nnf 
              OR @nnf = 0 ) 
           AND ( vdfatnfr_serie = @snf 
                  OR @snf = ' ' ) ) 
         AND ( vdfatnfr_demi > ( Datetostr(Curdate() - 45, 'yyyy/mm/dd') ) ) ;

DECLARE SET INT @CODIGO_CLIENTE = 0;
CREATE OR replace VIEW  vw_cliente AS SELECT 0 AS abate_icms,
       CASE 
              WHEN VW_DADOS_CLIENTE. "vdclicli_classe" = 20 THEN 0 
              ELSE 1 
       END AS ativo, 
       trim(REPEAT('0', 4 - Length(Cast( VW_DADOS_CLIENTE. "vdclicli_regi" AS CHAR( 4)))) || Cast( VW_DADOS_CLIENTE. "vdclicli_regi" AS CHAR( 4))) ||
	   trim(repeat('0', 4-length(Cast( VW_DADOS_CLIENTE. "vdclicli_num" AS CHAR( 4)))) || Cast( VW_DADOS_CLIENTE. "vdclicli_num" AS CHAR( 4)))   AS codigo_cliente_erp, 
       NULL                        AS bonus_disponivel, 
       VW_DADOS_CLIENTE. "vdclicli_classe" AS classe, 
       Cast(vdparoco_anotab_carga AS VARCHAR(4)) 
              || 
       CASE 
              WHEN Length(Cast(vdparoco_mestab_carga AS VARCHAR(2))) = 1 THEN '0' 
                            ||Cast(vdparoco_mestab_carga AS VARCHAR(2)) 
              ELSE Cast(vdparoco_mestab_carga AS            VARCHAR(2)) 
       END 
              || RIGHT(Cast(VW_DADOS_CLIENTE.vdclicli_tbprd AS VARCHAR(8)),2) AS codigo_tabpreco, 
       VW_DADOS_CLIENTE. "vdclicli_contato"                                   AS contato, 
       CASE 
	      WHEN length(CAST(vdclicli_cgc as varchar(15))) <= 5 THEN 
	         REPEAT('0' ,15 -Length(CAST(vdclicli_cgc as varchar(15)))) || CAST(vdclicli_cgc as varchar(15))		  
          WHEN SUBSTRING(CAST(vdclicli_cgc as varchar(15)) ,Length(CAST(vdclicli_cgc as varchar(15)))-5,4) = '0000' THEN 
	         REPEAT('0' ,15 -Length(CAST(vdclicli_cgc as varchar(15)))) || CAST(vdclicli_cgc as varchar(15))		  
		  WHEN SUBSTRING(CAST(vdclicli_cgc as varchar(15)) ,Length(CAST(vdclicli_cgc as varchar(15)))-5,4) <> '0000' THEN 
			 REPEAT('0' ,14 -Length(CAST(vdclicli_cgc as varchar(14)))) || CAST(vdclicli_cgc as varchar(14))
          ELSE 	  
			CAST(vdclicli_cgc as varchar(15))		    
       END   AS cpf_cnpj, 
       VW_DADOS_CLIENTE. "vdclicli_abona_tx_financ"                           AS despreza_taxa_financeira,
       0                                                              AS dia_semana, 
       VW_DADOS_CLIENTE. "vdclicli_dias_entrega"                              AS dias_entrega , 
       VW_DADOS_CLIENTE. "vdclicli_email"                                     AS email, 
       VW_DADOS_CLIENTE. "vdclicli_ignora_banda_preco"                        AS ignora_banda_preco, 
       NULL                                                           AS inconformidade_cadastro,
       VW_DADOS_CLIENTE. "vdclicli_credito"                                   AS limite_credito , 
	   CASE 
	      WHEN VW_DADOS_CLIENTE. "vdclicli_motblo" = '   ' THEN 
			''
		  ELSE
		    REPEAT('0', 3 -Length(VW_DADOS_CLIENTE. "vdclicli_motblo") ) ||   VW_DADOS_CLIENTE. "vdclicli_motblo" 
       END AS motivo_bloq_classe_20, 
       VW_DADOS_CLIENTE. "vdclicli_motblo_jur"                                AS motivo_bloqueio_juridico,
       VW_DADOS_CLIENTE. "vdclicli_num"                                       AS numero_cliente , 
       VW_DADOS_CLIENTE. "vdclicli_codpasta1"                                 AS pasta, 
       VW_DADOS_CLIENTE. "vdclicli_razao50"                                   AS razao_social , 
       VW_DADOS_CLIENTE. "vdclicli_regi"                                      AS regiao_cliente , 
       NULL                                                           AS registro_alterado, 
       VW_DADOS_CLIENTE. "vdclicli_restr_comerciais"                          AS restircao_comercial, 
       VW_DADOS_CLIENTE. "vdclicli_sigla"                                     AS sigla, 
       VW_DADOS_CLIENTE. "vdclicli_subcanal"                                  AS sub_canal, 
       CASE WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR (12))) = 11 THEN Subblobtochar(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR(12)), 1, 2) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR (12))) = 12 THEN Subblobtochar(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR(12)), 1, 3) ELSE '0' END AS telefone_ddd,
       CASE WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR (12))) <= 9 THEN Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR ( 12)) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR (12))) = 12 THEN Subblobtochar(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR( 12)), 4, 12 ) ELSE CASE WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR(12 ))) = 1 THEN '0' ELSE Subblobtochar(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR( 12)), 3, 11 ) END END AS telefone_tronco, 
       VW_DADOS_CLIENTE. "vdclicli_verba_fin_pro"   AS uso_verba_restrito_produto, 
       VW_DADOS_CLIENTE. "vdclicli_cat"             AS codigo_canal_erp, 
       VW_DADOS_CLIENTE. "vdclicli_cpg"             AS codigo_condicao_pagamento_erp, 
       VW_DADOS_CLIENTE. "vdclicli_tpcobra"         AS codigo_tipo_cobranca_erp , 
       VW_DADOS_CLIENTE. "vdclicli_disp_portal_web" AS disponivel_portal ,
	   VW_DADOS_CLIENTE."VDCLICLI_CEL1" as celular
FROM    VW_DADOS_CLIENTE , 
        paroco01 
WHERE  
    VW_DADOS_CLIENTE."VDCLICLI_VEN" <> '   ' and 
    ( 
              Cast(
			  trim(REPEAT('0', 4 - Length(Cast( VW_DADOS_CLIENTE. "vdclicli_regi" AS CHAR( 4)))) || Cast( VW_DADOS_CLIENTE. "vdclicli_regi" AS CHAR( 4))) ||
			  trim(repeat('0', 4-length(Cast( VW_DADOS_CLIENTE. "vdclicli_num" AS CHAR( 4)))) || Cast( VW_DADOS_CLIENTE. "vdclicli_num" AS CHAR( 4))) 
			  AS INTEGER) = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = 0 );

DECLARE SET INT @codigo_cev = 0;

CREATE or replace VIEW VW_COMODATO AS
SELECT
  REPEAT('0',8-length(Cast(cevped01."vdcevpen_codcli" AS VARCHAR(8)))) || Cast(cevped01."vdcevpen_codcli" AS VARCHAR(8)) CODIGO_CLIENTE_ERP,
  NULL CODIGO_MODELO,
  NULL CODIGO_OCORRENCIA,
  NULL CODIGO_SITUACAO,
  CASE WHEN VDCEVPEN_DTE <> 0 THEN
         TO_DATE(SUBSTRING(cast(VDCEVPEN_DTE as varchar(8)),7,2) || SUBSTRING(cast(VDCEVPEN_DTE as varchar(8)),5,2) || SUBSTRING(cast(VDCEVPEN_DTE as varchar(8)),1,4), 'DDMMYYYY')
       ELSE
         NULL
  END DATA_CEV,
  NULL DATA_UTILMA_AUDITORIA,
  CASE WHEN VDCEVPEN_DTV <> 0 THEN
         TO_DATE(SUBSTRING(cast(VDCEVPEN_DTV as varchar(8)),7,2) || SUBSTRING(cast(VDCEVPEN_DTV as varchar(8)),5,2) || SUBSTRING(cast(VDCEVPEN_DTV as varchar(8)),1,4), 'DDMMYYYY')
       ELSE
         NULL
  END DATA_VENCIMENTO,
  NULL DESCRICAO_MODELO,
  NULL FAZ_INVENTARIO,
  NULL NOME_FABRICANTE,
  NULL NUMERO_ATIVO,
  vdcevpen_nrccev NUMERO_CEV,
  NULL NUMERO_CEV_ITEM,
  NULL PATRIMONIO_DOIS,
  (SELECT
     vdprdprd_codr
   FROM
     CADPRD01
   WHERE
     vdprdprd_cfam = cast(left(concat(repeat('0',6-length(cast(vdcevpen_prod AS varchar(6)))),cast(vdcevpen_prod as varchar(6))),3) AS SMALLINT) AND
     vdprdprd_nro = Cast(right(concat(repeat('0',6-length(cast(vdcevpen_prod as varchar(6)))),cast(vdcevpen_prod as varchar(6))),3) AS SMALLINT)
  ) CODIGO_PRODUTO_ERP,
  vdcevpen_qtdprd QUANTIDADE,
  NULL TABELA_PRECO_REC_ID,
  NULL TECNOLOGIA_UTILIZADA,
  NULL TIPO_STATUS,
  NULL VALOR_ITEM
FROM
  CEVPED01
WHERE
 (vdcevpen_nrccev = @codigo_cev OR @codigo_cev = 0);

DECLARE SET INT @CODIGO_CONDICAO_PAGAMENTO = 0;

CREATE
or replace VIEW VW_CONDICAO_PAGAMENTO AS
SELECT
    condpg01."vdcadpag_ativo" AS ATIVO,
    CASE
              WHEN Length(Cast(VDCADPAG_COD AS VARCHAR(2))) = 1 THEN Concat('0',Cast(VDCADPAG_COD AS VARCHAR(2)))
    ELSE
              Cast(VDCADPAG_COD AS VARCHAR(2)) END AS CODIGO_CONDICAO_PAGAMENTO_ERP,
    condpg01."vdcadpag_descr" AS DESCRICAO,
    CASE WHEN condpg01."vdcadpag_cod" = 1 THEN 1 ELSE 0 END AS INFORMA_PRIMEIRA_PARCELA,
    condpg01."vdcadpag_nrdias" AS NUMERO_DIAS,
    condpg01."vdcadpag_prazo" AS PRAZO,
VDCADPAG_SFA_DISP as disponivel
FROM
     CONDPG01
WHERE
    (
        condpg01."vdcadpag_cod" = @CODIGO_CONDICAO_PAGAMENTO
        OR @CODIGO_CONDICAO_PAGAMENTO = 0
    ); 

declare set int @pasta = 0;

CREATE or replace VIEW VW_DIAS_VISITA_VENDEDOR AS
select
    numero_pasta as numeroPasta,
    TO_DATE(SUBSTRING(cast(data_visita as varchar(8)),7,2) || SUBSTRING(cast(data_visita as varchar(8)),5,2) || SUBSTRING(cast(data_visita as varchar(8)),1,4), 'DDMMYYYY') AS diaVisita
from
     PASTA_VISITA
where
    (
        numero_pasta = @pasta
        or @pasta = 0
    )
order by
    1;

DECLARE SET INT @CODIGO_CLIENTE = 0;


CREATE
or replace VIEW  VW_ENDERECO AS
SELECT
    1 AS ATIVO,
    VW_DADOS_CLIENTE."vdclicli_baifat" AS BAIRRO,
    VW_DADOS_CLIENTE."vdclicli_cepfat" AS CEP_ENDERECO,
    VW_DADOS_CLIENTE."vdclicli_endfat" AS ENDERECO,
    VW_DADOS_CLIENTE."vdclicli_munfat" AS MUNICIPIO,
    VW_DADOS_CLIENTE."vdclicli_endfat_nr" AS NUMERO,
    VW_DADOS_CLIENTE.VDCLICLI_PTOREF AS PONTO_REFERENCIA,
    VW_DADOS_CLIENTE."vdclicli_estfat" AS UTF_ENDERECO,
	VW_DADOS_CLIENTE."vdclicli_endfat_compl" AS COMPLEMENTO,
    1 AS ORIGEM_LOGRADOURO_ERP,
    Concat(
        CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 1 THEN Concat(
            '000',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 2 THEN Concat(
            '00',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 3 THEN Concat(
            '0',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4)) END,
        CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 1 THEN Concat(
            '000',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 2 THEN Concat(
            '00',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 3 THEN Concat(
            '0',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR (4)) END
    ) AS codigo_cliente_erp,
    VW_DADOS_CLIENTE."vdclicli_endfat_tip" AS SIGLA_LOGRADOURO_ERP
FROM
     VW_DADOS_CLIENTE
WHERE
    (
        Cast(
            Concat(
                CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 1 THEN Concat(
                    '000',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 2 THEN Concat(
                    '00',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 3 THEN Concat(
                    '0',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR (4)) END,
                CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 1 THEN Concat(
                    '000',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 2 THEN Concat(
                    '00',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 3 THEN Concat(
                    '0',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR (4)) END
            ) AS INTEGER
        ) = @CODIGO_CLIENTE
        OR @CODIGO_CLIENTE = 0
    )
UNION ALL
SELECT
    1 AS ATIVO,
    VW_DADOS_CLIENTE."vdclicli_baicob" AS BAIRRO,
    VW_DADOS_CLIENTE."vdclicli_cepcob" AS CEP_ENDERECO,
    VW_DADOS_CLIENTE."vdclicli_endcob" AS ENDERECO,
    VW_DADOS_CLIENTE."vdclicli_muncob" AS MUNICIPIO,
    VW_DADOS_CLIENTE."vdclicli_endcob_nr" AS NUMERO,
    NULL AS PONTO_REFERENCIA,
    VW_DADOS_CLIENTE."vdclicli_estcob" AS UTF_ENDERECO,
	VW_DADOS_CLIENTE."vdclicli_endcob_compl" AS COMPLEMENTO,
    2 AS ORIGEM_LOGRADOURO_REC_ID,
    Concat(
        CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 1 THEN Concat(
            '000',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 2 THEN Concat(
            '00',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 3 THEN Concat(
            '0',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4)) END,
        CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 1 THEN Concat(
            '000',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 2 THEN Concat(
            '00',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 3 THEN Concat(
            '0',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR (4)) END
    ) AS codigo_cliente_erp,
    VW_DADOS_CLIENTE."vdclicli_endcob_tip" AS SIGLA_LOGRADOURO_REC_ID
FROM
     VW_DADOS_CLIENTE
WHERE
    (
        Cast(
            Concat(
                CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 1 THEN Concat(
                    '000',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 2 THEN Concat(
                    '00',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 3 THEN Concat(
                    '0',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR (4)) END,
                CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 1 THEN Concat(
                    '000',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 2 THEN Concat(
                    '00',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 3 THEN Concat(
                    '0',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR (4)) END
            ) AS INTEGER
        ) = @CODIGO_CLIENTE
        OR @CODIGO_CLIENTE = 0
    )
UNION ALL
SELECT
    1 AS ATIVO,
    VW_DADOS_CLIENTE."vdclicli_baient" AS BAIRRO,
    VW_DADOS_CLIENTE."vdclicli_cepent" AS CEP_ENDERECO,
    VW_DADOS_CLIENTE."vdclicli_endent" AS ENDERECO,
    VW_DADOS_CLIENTE."vdclicli_munent" AS MUNICIPIO,
    VW_DADOS_CLIENTE."vdclicli_endent_nr" AS NUMERO,
	NULL AS PONTO_REFERENCIA,    	
    VW_DADOS_CLIENTE."vdclicli_estent" AS UTF_ENDERECO,	
	VW_DADOS_CLIENTE."vdclicli_endent_compl" AS COMPLEMENTO,
    3 AS ORIGEM_LOGRADOURO_REC_ID,
    Concat(
        CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 1 THEN Concat(
            '000',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 2 THEN Concat(
            '00',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 3 THEN Concat(
            '0',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4)) END,
        CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 1 THEN Concat(
            '000',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 2 THEN Concat(
            '00',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 3 THEN Concat(
            '0',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR (4)) END
    ) AS codigo_cliente_erp,
    VW_DADOS_CLIENTE."vdclicli_endent_tip" AS SIGLA_LOGRADOURO_REC_ID
FROM
     VW_DADOS_CLIENTE
WHERE
    (
        Cast(
            Concat(
                CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 1 THEN Concat(
                    '000',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 2 THEN Concat(
                    '00',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 3 THEN Concat(
                    '0',
                    Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR (4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR (4)) END,
                CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 1 THEN Concat(
                    '000',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 2 THEN Concat(
                    '00',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 3 THEN Concat(
                    '0',
                    Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
                ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR (4)) END
            ) AS INTEGER
        ) = @CODIGO_CLIENTE
        OR @CODIGO_CLIENTE = 0
    );

DECLARE SET INT @CODIGO_FAMILIA = 0;

CREATE
or replace VIEW  VW_FAMILIA_PRODUTO AS
SELECT
    cadfam01."vdprdfam_fameb" AS CODIGO_FAMEB,
    cadfam01."vdprdfam_cod" AS CODIGO_FAMILIA_PRODUTO_ERP,
    cadfam01."vdprdfam_nome" AS DESCRICAO
FROM
     CADFAM01
WHERE
    (
        cadfam01."vdprdfam_cod" = @CODIGO_FAMILIA
        OR @CODIGO_FAMILIA = 0
    );

DECLARE SET INT @CODIGO_GRUPO_PRODUTO = 0;

CREATE
or replace VIEW  VW_GRUPO_PRODUTO AS
SELECT
    grpprd01."vdprdgrp_grupo" AS CODIGO_GRUPO_PRODUTO_ERP,
    grpprd01."vdprdgrp_descr" AS DESCRICAO,
	grpprd01."vdprdgrp_coderp_terceiro" as CODIGO_ERP_TERCEIRO
FROM
     GRPPRD01
WHERE
    (
        grpprd01."vdprdgrp_grupo" = @CODIGO_GRUPO_PRODUTO
        OR @CODIGO_GRUPO_PRODUTO = 0
    );

declare set bigint @cod_pre_pedido = 0;
DECLARE SET INT @codemp = 0;
CREATE
or replace VIEW  VW_ITEM_CORTADO_PRE_PEDIDO AS
select
    vdpedipp_pre_ped as PRE_PEDIDO,
    vdpedipp_item as ITEM,
    vdpedipp_codr as CODIGO_PRODUTO_ERP,
    vdpedipp_qtd as QTD_PRODUTO,
    vdpedipp_qtds as QTDS_PRODUTO,
    'SEM ESTOQUE' as MOTIVO
from
     VDPEDIPP
where
    vdpedipp_nremp = @codemp
    AND (
        vdpedipp_pre_ped = @cod_pre_pedido
        or @cod_pre_pedido = 0
    )
    AND vdpedipp_sem_estoq = 'S';

DECLARE SET INT @CODIGO_MARCA_PRODUTO = 0;
CREATE
or replace VIEW  VW_MARCA_PRODUTO AS
SELECT
    marprd01."vdprdmar_marca" AS CODIGO_MARCA_PRODUTO_ERP,
    marprd01."vdprdmar_descr" AS DESCRICAO
FROM
     MARPRD01
WHERE
    (
        marprd01."vdprdmar_marca" = @CODIGO_MARCA_PRODUTO
        OR @CODIGO_MARCA_PRODUTO = 0
    );




CREATE
or replace VIEW  VW_MOTIVO_GERAL AS
SELECT
    1 AS ativo,
    Cast(bnftip01."vdpedbnf_cod" AS CHAR(3)) AS codigo_motivo_geral,
    bnftip01."vdpedbnf_descricao" AS descricao,
    NULL AS descricao_reduzida,
    0 AS infui_venda,
    bnftip01."vdpedbnf_influi_verba" AS permite_venda,
    '01' AS tipo_motivo_geral_rec_id
FROM
     BNFTIP01
WHERE
    bnftip01."vdpedbnf_cancsn" = 0
    AND bnftip01."vdpedbnf_carrega_palm" = 1
UNION ALL
SELECT
    1 AS ativo,
    tbtroca."vdcadtro_cod" AS codigo_motivo_geral,
    tbtroca."vdcadtro_descr" AS descricao,
    tbtroca."vdcadtro_descrred" AS descricao_reduzida,
    0 AS infui_venda,
    0 AS permite_venda,
    CASE WHEN tbtroca."vdcadtro_tipo" = 1 THEN '02' ELSE '03' END AS tipo_motivo_geral_rec_id
FROM
     TBTROCA
WHERE
    tbtroca."vdcadtro_cancsn" = 0
UNION ALL
SELECT
    1 AS ativo,
    tipcev01."vdcevtip_cod" AS codigo_motivo_geral,
    tipcev01."vdcevtip_nome" AS descricao,
    NULL AS descricao_reduzida,
    0 AS infui_venda,
    0 AS permite_venda,
    CASE WHEN tipcev01."vdcevtip_operacao" = 1 THEN '04' ELSE CASE WHEN tipcev01."vdcevtip_operacao" = 3 THEN '03' ELSE '05' END END AS tipo_motivo_geral_rec_id
FROM
     TIPCEV01
UNION ALL
SELECT
    1 AS ativo,
	tbblocli."vdcadblo_cod" AS codigo_motivo_geral,
    tbblocli."vdcadblo_descr" AS descricao,
    tbblocli."vdcadblo_descrred" AS descricao_reduzida,
    tbblocli."vdcadblo_venda" AS infui_venda,
    tbblocli."vdcadblo_venda" AS permite_venda,
    '06' AS tipo_motivo_geral_rec_id
FROM
     TBBLOCLI
UNION ALL
SELECT
    1 AS ativo,
    Cast(motcanpd."vdcadmdc_cod" AS CHAR(3)) AS codigo_motivo_geral,
    motcanpd."vdcadmdc_descr" AS descricao,
    motcanpd."vdcadmdc_descrred" AS descricao_reduzida,
    0 AS infui_venda,
    0 AS permite_venda,
    '08' AS tipo_motivo_geral_rec_id
FROM
     MOTCANPD
UNION ALL
SELECT
    1 AS ativo,
    tbdevol."vdcaddev_cod" AS codigo_motivo_geral,
    tbdevol."vdcaddev_descr" AS descricao,
    tbdevol."vdcaddev_descrred" AS descricao_reduzida,
    0 AS infui_venda,
    0 AS permite_venda,
    '09' AS tipo_motivo_geral_rec_id
FROM
     TBDEVOL
WHERE
    tbdevol."vdcaddev_cancsn" = 0
UNION ALL
SELECT
    1 AS ativo,
    tbncol."vdcadnco_cod" AS codigo_motivo_geral,
    tbncol."vdcadnco_descr" AS descricao,
    tbncol."vdcadnco_descrred" AS descricao_reduzida,
    0 AS infui_venda,
    0 AS permite_venda,
    '10' AS tipo_motivo_geral_rec_id
FROM
     TBNCOL
UNION ALL
SELECT
    1 AS ativo,
    tbncol."vdcadnco_cod" AS codigo_motivo_geral,
    tbncol."vdcadnco_descr" AS descricao,
    tbncol."vdcadnco_descrred" AS descricao_reduzida,
    0 AS infui_venda,
    0 AS permite_venda,
    '18' AS tipo_motivo_geral_rec_id
FROM
     TBNCOL
WHERE
    tbncol."vdcadnco_cod" = 'I'
    OR tbncol."vdcadnco_cod" = 'F'
    OR tbncol."vdcadnco_cod" = 'N'
UNION ALL
SELECT
    1 AS ativo,
    Cast(tabblq01."vdcadbpd_cod" AS CHAR(3)) AS codigo_motivo_geral,
    tabblq01."vdcadbpd_descr" AS descricao,
    tabblq01."vdcadbpd_descr" AS descricao_reduzida,
    0 AS infui_venda,
    0 AS permite_venda,
    '99' AS tipo_motivo_geral_rec_id
FROM
     TABBLQ01
WHERE
    tabblq01."vdcadbpd_cancsn" = 0;

DECLARE SET INT @DATA_OPERACAO = 0;

CREATE or replace VIEW VW_MOVIMENTO_FINANCEIRO AS
SELECT
  REPEAT('0',8-length(Cast(crchqdep_codcli AS VARCHAR(8)))) || Cast(crchqdep_codcli AS VARCHAR(8)) CODIGO_CLIENTE_ERP,
  NULL CODIGO_PRODUTO_ERP,
  CASE WHEN crchqdep_dtv >= CAST(DATETOSTR(Curdate()-45,'yyyymmdd') AS INT) THEN
         TO_DATE(SUBSTRING(cast(crchqdep_dte as varchar(8)),7,2) || SUBSTRING(cast(crchqdep_dte as varchar(8)),5,2) || SUBSTRING(cast(crchqdep_dte as varchar(8)),1,4), 'DDMMYYYY')
       ELSE
         TO_DATE(SUBSTRING(cast(crchqdep_dtv as varchar(8)),7,2) || SUBSTRING(cast(crchqdep_dtv as varchar(8)),5,2) || SUBSTRING(cast(crchqdep_dtv as varchar(8)),1,4), 'DDMMYYYY')
  END DATA_OPERACAO,
  TO_DATE(SUBSTRING(cast(crchqdep_dtv as varchar(8)),7,2) || SUBSTRING(cast(crchqdep_dtv as varchar(8)),5,2) || SUBSTRING(cast(crchqdep_dtv as varchar(8)),1,4), 'DDMMYYYY') DATA_VENCIMENTO,
  CASE WHEN crchqdep_dte = crchqdep_dtv THEN
         1
       ELSE
         2
  END MOD,
  Cast(crchqdep_ndoc AS VARCHAR(255)) NUMERO_DOCUMENTO,
  CASE WHEN crchqdep_dtv >= CAST(DATETOSTR(Curdate()-45,'yyyymmdd') AS INT) THEN
        '1'
       ELSE
        '2'
  END TIPO_REGISTRO,
  crchqdep_nped NUMERO_PEDIDO,
  crchqdep_vldoc VALOR
FROM
  CHDEPO01
WHERE
  crchqdep_dtv >= CAST(DATETOSTR(Curdate()-45,'yyyymmdd') AS INT) AND
  (crchqdep_dte = @DATA_OPERACAO OR @DATA_OPERACAO = 0)
UNION ALL
SELECT
  REPEAT('0',8-length(Cast(crchqdvv_ccli AS VARCHAR(8)))) || Cast(crchqdvv_ccli AS VARCHAR(8)) CODIGO_CLIENTE_ERP,
  NULL CODIGO_PRODUTO,
  CASE WHEN crchqdvv_dtqui > 0 THEN
         TO_DATE(SUBSTRING(cast(crchqdvv_dtqui as varchar(8)),7,2) || SUBSTRING(cast(crchqdvv_dtqui as varchar(8)),5,2) || SUBSTRING(cast(crchqdvv_dtqui as varchar(8)),1,4), 'DDMMYYYY')
       ELSE
         NULL
  END DATA_OPERACAO,
  TO_DATE(SUBSTRING(cast(crchqdvv_dtvto as varchar(8)),7,2) || SUBSTRING(cast(crchqdvv_dtvto as varchar(8)),5,2) || SUBSTRING(cast(crchqdvv_dtvto as varchar(8)),1,4), 'DDMMYYYY') DATA_VENCIMENTO,
  0 MOD,
  CAST(crchqdvv_nchq AS VARCHAR(255)) NUMERO_DOCUMENTO,
  '3' TIPO_REGISTRO,
  crchqdvv_nped NUMERO_PEDIDO,
  crchqdvv_vlori VALOR
FROM
  CHDVV01
WHERE
  crchqdvv_dtqui = 0 AND
  crchqdvv_dtemi >= CAST(DATETOSTR(Curdate()-45,'yyyymmdd') AS INT) AND
  (crchqdvv_dtqui = @DATA_OPERACAO OR @DATA_OPERACAO = 0) 
UNION ALL
SELECT
  REPEAT('0',8-length(Cast(crmovbai_ccli AS VARCHAR (8)))) || Cast(crmovbai_ccli AS VARCHAR(8)) CODIGO_CLIENTE_ERP,
  NULL CODIGO_PRODUTO,
  TO_DATE(SUBSTRING(cast(crmovbai_dtp as varchar(8)),7,2) || SUBSTRING(cast(crmovbai_dtp as varchar(8)),5,2) || SUBSTRING(cast(crmovbai_dtp as varchar(8)),1,4), 'DDMMYYYY') DATA_OPERACAO,
  TO_DATE(SUBSTRING(cast(crmovbai_dtv as varchar(8)),7,2) || SUBSTRING(cast(crmovbai_dtv as varchar(8)),5,2) || SUBSTRING(cast(crmovbai_dtv as varchar(8)),1,4), 'DDMMYYYY') DATA_VENCIMENTO,
  crmovbai_mod MOD,
  crmovbai_ndupl NUMERO_DOCUMENTO,
  '2' TIPO_REGISTRO,
  crmovbai_nped NUMERO_PEDIDO,
  crmovbai_valor VALOR
FROM
  CADBAI01
WHERE
  crmovbai_dtp >= CAST(DATETOSTR(Curdate()-45,'yyyymmdd') AS INT) AND
  (crmovbai_dtp = @DATA_OPERACAO OR @DATA_OPERACAO = 0)
UNION ALL
SELECT
  REPEAT('0',8-length(Cast(crmovmov_ccli AS VARCHAR(8)))) || Cast(crmovmov_ccli AS VARCHAR(8)) CODIGO_CLIENTE_ERP,
  NULL CODIGO_PRODUTO,
  TO_DATE(SUBSTRING(cast(crmovmov_dte as varchar(8)),7,2) || SUBSTRING(cast(crmovmov_dte as varchar(8)),5,2) || SUBSTRING(cast(crmovmov_dte as varchar(8)),1,4), 'DDMMYYYY') DATA_OPERACAO,  
  TO_DATE(SUBSTRING(cast(crmovmov_dtv as varchar(8)),7,2) || SUBSTRING(cast(crmovmov_dtv as varchar(8)),5,2) || SUBSTRING(cast(crmovmov_dtv as varchar(8)),1,4), 'DDMMYYYY') DATA_VENCIMENTO,
  crmovmov_mod MOD,
  crmovmov_ndupl NUMERO_DOCUMENTO,
  '1' TIPO_REGISTRO,
  crmovmov_nped NUMERO_PEDIDO,
  crmovmov_valor VALOR
FROM
  CADMOV01
WHERE
  (crmovmov_dte = @DATA_OPERACAO OR @DATA_OPERACAO = 0)
ORDER BY
  3; 

DECLARE SET VARCHAR(255) @CODIGO_OCORRENCIA ='';

CREATE
or replace VIEW VW_OCORRENCIA AS
SELECT
    CASE WHEN cadoco01."vdnopoco_cancsn" = 0 THEN 1 ELSE 0 END AS ATIVO,
    cadoco01."vdnopoco_cod" AS CODIGO_OCORRENCIA_ERP,
    cadoco01."vdnopoco_nome" AS DESCRICAO,
    cadoco01."vdnopoco_nomer" AS DESCRICAO_REDUZIDA,
    cadoco01."vdnopoco_desdobro" AS DESDOBRO,
    NULL AS EMPRESA,
    CASE WHEN cadoco01."vdnopoco_totven" = 'S' THEN 1 ELSE 0 END AS GERA_MOTIVO_FINANC,
    VDNOPOCO_DISP_PORTAL_WEB AS OCORR_DISP_PORTAL,
    cadoco01."vdnopoco_sinal" AS SINAL,
    cadoco01."vdnopoco_tipo" AS TIPO,
    cadoco01."vdnopoco_tpprd" AS TIPO_PRODUTO,
    Concat(
        '0',
        Cast(cadoco01."vdnopoco_tipooco" AS VARCHAR(2))
    ) AS CODIGO_TIPO_OCORRENCIA_ERP,
    vdnoot01."vdnopotp_natop" AS NATUREZA_OPERACAO
FROM
     CADOCO01
    INNER JOIN  VDNOOT01 ON vdnoot01."vdnopotp_oco" = Cast(cadoco01."vdnopoco_cod" AS SMALLINT)
WHERE      
    vdnoot01."vdnopotp_tipo_prod" = 'P'
    AND (
        cadoco01."vdnopoco_cod" = @CODIGO_OCORRENCIA
        OR @CODIGO_OCORRENCIA = ''
);

DECLARE SET SMALLINT @CODIGO_EMPRESA = 0;

CREATE
or replace VIEW  VW_PAROCO AS
SELECT
    VDPAROCO_CODEMP AS CODIGO_EMPRESA,
    VDPAROCO_OCOKD_BIMOB_CL AS OCORRENCIA_BIMOB_CL,
    VDPAROCO_OCOKD_BIMOB_SL AS OCORRENCIA_BIMOB_SL,
    VDPAROCO_OCVDVAS AS OCORRENCIA_VENDA_VASILHAME,
    VDPAROCO_OCOKD_VIMOB_SL AS OCORRENCIA_VIMOB_SL,
    VDPAROCO_OCCEVSAI AS OCORRENCIA_CEV_SAIDA,
    VDPAROCO_OCCEVSAI_FE AS OCORRENCIA_CEV_SAIDA_FE,
    VDPAROCO_OCCEVREC AS OCORRENCIA_CEV_RECOLHIMENTO,
    VDPAROCO_OCCEVREC_FE AS OCORRENCIA_CEV_RECOLHIMENTO_FE,
    VDPAROCO_OCCEVSAI_SL AS OCORRENCIA_CEV_RECOLHIMENTO_SL,
    VDPAROCO_OCCEVSAI_FE_SL AS OCORRENCIA_CEV_RECOLHIMENTO_FE_SL,
    VDPAROCO_DEV_KAR_DIAANT_FIN AS OCORRENCIA_DEV_DIA_ANTERIOR_FIN,
    VDPAROCO_DEV_KAR_DIAANT_NFIN AS OCORRENCIA_DEV_DIA_ANTERIOR_NAO_FIN,
    VDPAROCO_OCOKD_COMPRA AS OCORRENCIA_COMPRA,
    VDPAROCO_OCOKD_COMPRA_BONIF AS OCORRENCIA_COMPRA_BONIFICADA,
    VDPAROCO_OCO_AUTOCONS AS OCORRENCIA_AUTOCONS,
    VDPAROCO_QUEBRA AS QUEBRA,
    VDPAROCO_QUEBRA2 AS QUEBRA2,
    VDPAROCO_QUEBRA3 AS QUEBRA3,
    VDPAROCO_OCO_VDA_DIRETA AS OCORRENCIA_VENDA_DIRETA,
    VDPAROCO_OCO_DIGPED AS OCORRENCIA_DIGIPED,
    VDPAROCO_OCCONSIG AS OCORRENCIA_CONSIG,
    VDPAROCO_OCOKDREM AS OCORRENCIA_REM,
    VDPAROCO_OCOKDREM_BONIF AS OCORRENCIA_REM_BONIFICADO,
    VDPAROCO_OCOKDREM_ESPECIAL AS OCORRENCIA_REM_ESPECIAL,
    VDPAROCO_OCBON1 AS OCORRENCIA_BONIFICADA_1,
    VDPAROCO_OCBON2 AS OCORRENCIA_BONIFICADA_2,
    VDPAROCO_OCBON3 AS OCORRENCIA_BONIFICADA_3,
    VDPAROCO_OCBON4 AS OCORRENCIA_BONIFICADA_4,
    VDPAROCO_OCB0N5 AS OCORRENCIA_BONIFICADA_5,
    VDPAROCO_OCTCA1 AS OCORRENCIA_TROCA1,
    VDPAROCO_OCTCA2 AS OCORRENCIA_TROCA2,
    VDPAROCO_OCTCA3 AS OCORRENCIA_TROCA3,
    VDPAROCO_OCTCA4 AS OCORRENCIA_TROCA4,
    VDPAROCO_OCTCA5 AS OCORRENCIA_TROCA5,
    VDPAROCO_SPREM_E AS SPREM_E,
    VDPAROCO_SPREM_I AS SPREM_I,
    VDPAROCO_OCOKDRETV AS COCORRENCIA_RETV,
    VDPAROCO_OCOKDSAIV AS COCORRENCIA_SAIV,
    VDPAROCO_OCO_INV_SABOR_E AS COCORRENCIA_INV_SABOR_E,
    VDPAROCO_OCO_INV_SABOR_S AS COCORRENCIA_INV_SABOR_S,
    VDPAROCO_OCO_INV_SABOR_E_ANT AS COCORRENCIA_INV_SABOR_E_ANT,
    VDPAROCO_OCO_INV_SABOR_S_ANT AS COCORRENCIA_INV_SABOR_S_ANT,
    VDPAROCO_TAB_CUSTO_PROD AS CODIGO_TABELA_CUSTO_ERP,
    VDPAROCO_TAB_PREMED_VDA AS COCORRENCIA_TAB_PREMED_VDA,
    CASE WHEN LENGTH(CAST(VDPAROCO_CLIENTE AS VARCHAR(008))) = 5 THEN CONCAT('000', CAST(VDPAROCO_CLIENTE AS VARCHAR(008))) WHEN LENGTH(CAST(VDPAROCO_CLIENTE AS VARCHAR(008))) = 6 THEN CONCAT('00', CAST(VDPAROCO_CLIENTE AS VARCHAR(008))) WHEN LENGTH(CAST(VDPAROCO_CLIENTE AS VARCHAR(008))) = 7 THEN CONCAT('0', CAST(VDPAROCO_CLIENTE AS VARCHAR(008))) ELSE CAST(VDPAROCO_CLIENTE AS VARCHAR(008)) END AS CODIGO_CLIENTE_ERP,
    VDPAROCO_TIPCLI AS TIPCLI,
    VDPAROCO_TIPPRD AS TIPPRD,
    VDPAROCO_TIPPLA AS TIPLA,
    VDPAROCO_VISFAT AS VISFAT,
    VDPAROCO_VERBA AS VERBA,
    VDPAROCO_INDENIZA AS INDENIZA,
    VDPAROCO_INTEGRA_FORMA_CONTBL AS INTREGRA_CONTABEL,
    VDPAROCO_IGUALLC AS IGUALIC,
    VDPAROCO_ANTECIPADO AS ANTECIPADO,
    VDPAROCO_SOLAVANCO AS SOLAVANCO,
    VDPAROCO_TIPFOR AS TIPFOR,
    VDPAROCO_TABCUSTO_FREPUXA AS TABCUSTO_PREPUXA,
    VDPAROCO_TABCUSTO_FREENTR AS TABELA_CUSTO_FRETE_ENTRGA,
    VDPAROCO_OCOKD_COMPRA_FE AS OCORRENCIA_COMPRA_FE,
    VDPAROCO_OCOTK_ENTFUTURA AS OCORRENCIA_ENTFUTURA,
    VDPAROCO_OCOTK_VENFAT AS OCORRENCIA_VENFAT,
    VDPAROCO_ANOTAB_CARGA AS ANO_TABELA_CARGA,
    VDPAROCO_MESTAB_CARGA AS MES_TABELA_CARGA,
    VDPAROCO_USA_BANDPREC AS USA_BANDEIRA,
    VDPAROCO_SENHA_LIB AS SENHA_LIB,
    VDPAROCO_CTRL_RESTRICOES AS RESTRICAO_FINANCEIRA,
    VDPAROCO_RESTR_COMERCIAL AS RESTRICAO_COMERCIAL,
    VDPAROCO_FAM_FAMC_BAND AS BANDA_FAM_FAMC,
    VDPAROCO_REG_PASTA_BANDPREC AS BANDA_REG_PASTA,
    VDPAROCO_BDA_VEN_SUP_GER AS BANDA_VEN_SUP_GER,
    VDPAROCO_CAN_GRPCAN_BANDPREC AS BANDA_CAN_GRPCAN,
    VDPAROC2_BLOQ_OCOR_DIST PERMITE_OCOR_DISTINTA,
    VDPAROC2_CTRL_PRAZOCLI_PALM CTRL_PRAZO_CLI_PALM,
    VDPAROC2_S_CANC_PED_PORTAL SENHA_CANC_PED_PORTAL
FROM
  PAROCO01
LEFT JOIN
  PAROC201 ON VDPAROC2_CODEMP = VDPAROCO_CODEMP
WHERE
    (
        VDPAROCO_CODEMP = @CODIGO_EMPRESA
        OR @CODIGO_EMPRESA = 0
    );
    
DECLARE SET VARCHAR(12) @CODIGO_PEDIDO = '';

CREATE OR REPLACE VIEW VW_PEDIDO_PENDENTE_LIBERACAO AS
SELECT
  CASE WHEN VDPEDCPE_FL = 9 THEN 0 ELSE 1 END ATIVO,
  TO_DATE(SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),7,2) || SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),5,2) || SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),1,4), 'DDMMYYYY') DATA_HORA_EMISSAO_PEDIDO,
  TO_DATE(SUBSTRING(cast(vdpedcpe_dt1vc as varchar(8)),7,2) || SUBSTRING(cast(vdpedcpe_dt1vc as varchar(8)),5,2) || SUBSTRING(cast(vdpedcpe_dt1vc as varchar(8)),1,4), 'DDMMYYYY') DATA_VENCIMENTO,
  vdpedcpe_descfi DESCONTO_FINANCEIRO,
  vdpedcpe_nped NUMERO_PEDIDO,
  vdpedcpe_desc PERCENTUAL_DESCONTO,
  CASE WHEN vdpedcpe_fl in (5,4,3,2,1) THEN 7 ELSE vdpedcpe_fl END STATUS_PEDIDO,
  (SELECT CASE WHEN vdcadbpd_descr = NULL THEN 'LIBERADO' ELSE vdcadbpd_descr END FROM TABBLQ01 WHERE vdcadbpd_cod = vdpedcpe_fl) DESCRICAO_BLOQUEIO,
  vdpedcpe_txfin TAXA_FINANCEIRO,
  vdpedcpe_vlr_fcem_r + vdpedcpe_vlr_fsem_r + vdpedcpe_vlr_fctr_r + vdpedcpe_vlr_fstr_r VALOR_DEVOLUCAO,
  vdpedcpe_vlr_fcem + vdpedcpe_vlr_fsem + vdpedcpe_vlr_fctr + vdpedcpe_vlr_fstr VALOR_PEDIDO,
  repeat('0',8-length(cast(vdpedcpe_codcli as varchar(8)))) || cast(vdpedcpe_codcli as varchar(8)) CODIGO_CLIENTE_REC_ID,
  vdpedcpe_cpg CODIGO_CONDICAO_PAGAMENTO_REC_ID,
  vdpedcpe_tpcobr CODIGO_TIPO_COBRANCA_REC_ID,
  (SELECT vdvenven_sigla FROM CADVEN01 WHERE vdvenven_sigla = vdpedcpe_ven) AS CODIGO_VENDEDOR,
  (SELECT vdvenven_nome FROM CADVEN01 WHERE vdvenven_sigla = vdpedcpe_ven) AS NOME_VENDEDOR
FROM
  PEDCP01
WHERE
  (Cast(vdpedcpe_nped AS VARCHAR(12)) = @CODIGO_PEDIDO OR @CODIGO_PEDIDO = '') AND
  ((vdpedcpe_fl IN (7,5,4,3,2,1) AND @CODIGO_PEDIDO = '') OR (vdpedcpe_fl IN (7,5,4,3,2,1,0) AND @CODIGO_PEDIDO <> ''));

CREATE OR REPLACE VIEW VW_PEDIDO_SUGESTAO AS
SELECT
  '0' AS COD_CLIENTE,
  VDCLIPVC_CODCAT COD_CANAL,
  (SELECT
     VDPRDPRD_CODR
   FROM
     CADPRD01
   WHERE
     VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDCLIPVC_CODPRD AS VARCHAR(6)))),CAST(VDCLIPVC_CODPRD AS VARCHAR(6))),3) AS INT) AND
     VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDCLIPVC_CODPRD AS VARCHAR(6)))),CAST(VDCLIPVC_CODPRD AS VARCHAR(6))),3) AS INT)
  ) COD_PRODUTO_REDUZIDO,
  VDCLIPVC_SUG_QTDECX QTD_CX,
  VDCLIPVC_SUG_QTDEUN QTD_AV
FROM
  VDCLPV01
UNION ALL
SELECT    
  CODIGO_CLIENTE COD_CLIENTE,    
  '00' AS COD_CANAL,
  (SELECT
     VDPRDPRD_CODR
   FROM
     CADPRD01
   WHERE
     VDPRDPRD_CFAM = CAST(LEFT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDCLCVTE_CODPRD AS VARCHAR(6)))),CAST(VDCLCVTE_CODPRD AS VARCHAR(6))),3) AS INT) AND
     VDPRDPRD_NRO = CAST(RIGHT(CONCAT(REPEAT('0',6-LENGTH(CAST(VDCLCVTE_CODPRD AS VARCHAR(6)))),CAST(VDCLCVTE_CODPRD AS VARCHAR(6))),3) AS INT)
  ) COD_PRODUTO_REDUZIDO,
  VDCLCVTE_SUG_QTDCX QTD_CX,
  VDCLCVTE_SUG_QTDUN QTD_AV
FROM
  CLCVTE01
INNER JOIN
  VW_DADOS_CLIENTE ON VDCLICLI_REGI = CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLCVTE_CODCLI AS VARCHAR(8)))) || CAST(VDCLCVTE_CODCLI AS VARCHAR(8)),1,4) AS INT) AND VDCLICLI_NUM = CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLCVTE_CODCLI AS VARCHAR(8)))) || CAST(VDCLCVTE_CODCLI AS VARCHAR(8)),5,4) AS INT);

DECLARE SET BIGINT @COD_PRODUTO = 0;
DECLARE SET BIGINT @COD_TABELA = 0;

CREATE or replace VIEW VW_PRECO_PRODUTO AS 
SELECT
  vdtabprd_aliqpvv aliq_pvv,
  1 AS ATIVO,
  cast(cast(vdtabprd_ano as varchar(4)) || 
  repeat('0',2-length(cast(vdtabprd_mes as varchar(2)))) || cast(vdtabprd_mes as varchar(2)) || 
  repeat('0',2-length(cast(vdtabprd_nmes as varchar(2)))) || cast(vdtabprd_nmes as varchar(2)) as bigint) codigo_tabpreco_erp,
  vdtabprd_daicmo da_icm_o,
  vdtabprd_desc desconto,
  vdtabprd_descmax desconto_maximo,
  vdtabprd_descvb desconto_verba,
  vdtabprd_despac despac,
  vdtabprd_tipotab origem_tabela,
  vdtabprd_participabda participa_banda_preco,
  NULL preco_custo_caixa,
  NULL preco_custo_un,
  vdtabprd_precopvv preco_pvv,
  NULL promocao,
  vdtabprd_restr_comerciais restricao,
  vdtabprd_selo selo,
  vdtabprd_tpcont tp_cont,
  NULL uf_table_preco,
  vdtabprd_valicm val_icms,
  vdtabprd_valipi val_ipi,
  vdtabprd_preco valor,
  vdprdprd_codr codigo_produto_erp,
  vdtabprd_dtvgf fim,
  vdtabprd_bloqueio bloqueio
FROM
  CADPRD01, PAROCO01
INNER JOIN 
  TABPRC01 ON vdprdprd_cfam = vdtabprd_cfam AND 
              vdprdprd_nro = vdtabprd_nro
WHERE	 
  (VDPRDPRD_CODR = @COD_PRODUTO OR @COD_PRODUTO = 0) AND 
  VDPRDPRD_DISP_PORTAL_WEB = 1 AND 
  vdtabprd_preco <> 0 AND
  ((cast(cast(vdtabprd_ano as varchar(4)) || 
  repeat('0',2-length(cast(vdtabprd_mes as varchar(2)))) || cast(vdtabprd_mes as varchar(2)) || 
  repeat('0',2-length(cast(vdtabprd_nmes as varchar(2)))) || cast(vdtabprd_nmes as varchar(2)) as bigint) = @COD_TABELA) OR 
  (@COD_TABELA = 0 AND vdtabprd_ano = VDPAROCO_ANOTAB_CARGA AND vdtabprd_mes = VDPAROCO_MESTAB_CARGA)) AND
  vdtabprd_dtvgf >= CAST(DATETOSTR(Curdate(),'yyyymmdd') AS INT);

DECLARE SET BIGINT @CODIGO_PROD = 0;
DECLARE SET INT @CODIGO_FAMILIA = 0;
DECLARE SET INT @CODIGO_SEQUENCIA = 0;

CREATE
or replace VIEW  VW_PRODUTO AS
SELECT
    CASE WHEN cadprd01."vdprdprd_flag" = 'A' THEN 1 ELSE 0 END AS ATIVO,
    cadprd01."vdprdprd_bonifica_unid" AS BONIFICA_UNIDADE,
    cadprd01."vdprdprd_clasf" AS CLASS_FISCAL,
    NULL AS CODIGO_EAN_FAB,
    cadprd01."vdprdprd_codr" AS CODIGO_PRODUTO_ERP,
    cadprd01."vdprdprd_descr" AS DESCRICAO,
    cadprd01."vdprdprd_descri" AS DESCRICAO_RED,
    cadprd01."vdprdprd_ipipauta" AS IPI_PAUTA,
    cadprd01."vdprdprd_linha" AS LINHA,
    cadprd01."vdprdprd_medida" AS LITRAGEM,
    NULL AS PERCENTUAL_BONUS_GERA,
    NULL AS PERCENTUAL_BONUS_USA,
    cadprd01."vdprdprd_permite_bonif" AS PERMITE_BONIFICACAO,
    cadprd01."vdprdprd_peso" AS PESO,
    cadprd01."vdprdprd_pesoemb" AS PESO_EMB,
    cadprd01."vdprdprd_qtdminvd" AS QTD_MIN_VENDA_AV,
    NULL AS QTD_MIN_VENDA_CX,
    cadprd01."vdprdprd_qtdun" AS QUANTIDADE_CX,
    cadprd01."vdprdprd_tipobanda" AS TIPO_BANDA,
    cadprd01."vdprdprd_tpprd" AS TIPO_PRODUTO,
    NULL AS UTILIZA_BANDA_PRECO_TIPO,
    NULL AS VALOR_MINIMO_BONUS,
    cadprd01."vdprdprd_tipoqtdvdcx" AS VENDA_MULTI_MIN_CX,
    cadprd01."vdprdprd_tipoqtdvd" AS VENDA_MULTI_MIN_AV,
    CASE WHEN cadprd01."vdprdprd_enc" = 'S' THEN 1 ELSE 0 END AS VENDA_AVULSO,
    CASE WHEN cadprd01."vdprdprd_tpprd" = 'A' THEN 0 ELSE 1 END AS VISIBILIDADE_PORTAL,
    cadprd01."vdprdprd_catprd" AS CODIGO_CATEGORIA_PRODUTO_ERP,
    cadprd01."vdprdprd_cfam" AS CODIGO_FAMILIA_PRODUTO_ERP,
    cadprd01."vdprdprd_grpprd" AS CODIGO_GRUPO_PRODUTO_ERP,
    cadprd01."vdprdprd_marprd" AS CODIGO_MARCA_PRODUTO_ERP,
    cadprd01."vdprdprd_disp_portal_web" AS DISP_PORTAL_WEB,
	cadprd01."vdprdprd_cev" AS PERMITE_CEV
FROM
     CADPRD01
WHERE
    cadprd01."vdprdprd_cfam" > @CODIGO_FAMILIA
    AND cadprd01."vdprdprd_nro" > @CODIGO_SEQUENCIA
    AND (  cadprd01."vdprdprd_codr" = @CODIGO_PROD 
                OR @CODIGO_PROD = 0) ;
	
	
declare set integer @id =0;

CREATE
or replace VIEW  VW_PRODUTOS_POR_CANAL AS
SELECT
    case when length(cast(VDPRDCAN_CODCLI as char(8))) = 5 then concat('000', cast(VDPRDCAN_CODCLI as char(8))) when length(cast(VDPRDCAN_CODCLI as char(8))) = 6 then concat('00', cast(VDPRDCAN_CODCLI as char(8))) when length(cast(VDPRDCAN_CODCLI as char(8))) = 7 then concat('0', cast(VDPRDCAN_CODCLI as char(8))) ELSE cast(VDPRDCAN_CODCLI as char(8)) END AS COD_CLIENTE,
    VDPRDCAN_CANAL AS ERP_CANAL,
    VDPRDCAN_SUB_CANAL AS SUB_CANAL,
    (
        SELECT
            CADPRD01."VDPRDPRD_CODR"
        FROM
             CADPRD01
        WHERE
            CADPRD01."VDPRDPRD_CFAM" = VDPRDCAN_FAMPRD
            AND CADPRD01."VDPRDPRD_NRO" = VDPRDCAN_NROPRD
    ) AS COD_PRODUTO,
    VDPRDCAN_GRPPRD AS ERP_COD_GRUPO,
    VDPRDCAN_CATPRD AS ERP_COD_CATEGORIA,
    VDPRDCAN_MARPRD AS ERP_MARCA
FROM
     VDPRDCAN
where(
        VDPRDCAN_ID = @id
        or @id = 0
    );

CREATE
or replace VIEW  VW_RESTRICAO_COMERCIAL_CAPA AS
SELECT CASE WHEN grptab01. "vdtabgrc_cancsn" = 0 THEN 1 ELSE 0 END AS ATIVO, grptab01. "vdtabgrc_grpcan" AS CODIGO_GRUPO_CANAL_ERP, grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP, grptab01. "vdtabgrc_divcan" AS DIVISAO_CANAL, grptab01. "vdtabgrc_valminped" AS VALOR_MINIMO_PEDIDO, grptab01. "vdtabgrc_canal" AS CODIGO_CANAL_ERP, CASE WHEN Length( Cast(grptab01. "vdtabgrc_cliente" AS VARCHAR(8)) ) = 5 THEN Concat( '000', Cast(grptab01. "vdtabgrc_cliente" AS VARCHAR(8)) ) ELSE CASE WHEN Length( Cast(grptab01. "vdtabgrc_cliente" AS VARCHAR(8)) ) = 6 THEN Concat( '00', Cast(grptab01. "vdtabgrc_cliente" AS VARCHAR(8)) ) ELSE CASE WHEN Length( Cast(grptab01. "vdtabgrc_cliente" AS VARCHAR(8)) ) = 7 THEN Concat( '0', Cast(grptab01. "vdtabgrc_cliente" AS VARCHAR(8)) ) ELSE CASE WHEN Length( Cast(grptab01. "vdtabgrc_cliente" AS VARCHAR(8)) ) = 8 THEN Cast(grptab01. "vdtabgrc_cliente" AS VARCHAR (8)) END END END END AS CODIGO_CLIENTE_ERP, grptab01. "vdtabgrc_condpag" AS CODIGO_CONDICAO_PAGAMENTO_ERP, grptab01. "vdtabgrc_tipcobr" AS CODIGO_TIPO_COBRANCA_ERP, VDTABGRC_VENDED CODIGO_VENDEDOR, VDTABGRC_GRPANALISE CODIGO_GRUPO_ANALISE, VDTABGRC_REGIAO REGIAO FROM  GRPTAB01;

CREATE or replace VIEW  VW_RESTRICAO_COMERCIAL_ITEM AS 
SELECT grptab01. "vdtabgrc_tab01" AS CODIGO_TABELA_PRECO,
       grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM  GRPTAB01
WHERE grptab01. "vdtabgrc_tab01" <> 0
UNION
SELECT grptab01. "vdtabgrc_tab02" AS CODIGO_TABELA_PRECO,
       grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM  GRPTAB01
WHERE grptab01. "vdtabgrc_tab02" <> 0
UNION
SELECT grptab01. "vdtabgrc_tab03" AS CODIGO_TABELA_PRECO,
              grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM  GRPTAB01
WHERE grptab01. "vdtabgrc_tab03" <> 0
UNION
SELECT grptab01. "vdtabgrc_tab04" AS CODIGO_TABELA_PRECO,
       grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM  GRPTAB01
WHERE grptab01. "vdtabgrc_tab04" <> 0
UNION
SELECT grptab01. "vdtabgrc_tab05" AS CODIGO_TABELA_PRECO,
       grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM  GRPTAB01
WHERE grptab01. "vdtabgrc_tab05" <> 0
UNION
SELECT grptab01. "vdtabgrc_tab06" AS CODIGO_TABELA_PRECO,
       grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM   GRPTAB01
WHERE grptab01. "vdtabgrc_tab06" <> 0
UNION
SELECT grptab01. "vdtabgrc_tab07" AS CODIGO_TABELA_PRECO,
       grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM  GRPTAB01
WHERE grptab01. "vdtabgrc_tab07" <> 0
UNION
SELECT grptab01. "vdtabgrc_tab08" AS CODIGO_TABELA_PRECO,
       grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM  GRPTAB01
WHERE grptab01. "vdtabgrc_tab08" <> 0
UNION
SELECT grptab01. "vdtabgrc_tab09" AS CODIGO_TABELA_PRECO,
       grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
FROM  GRPTAB01
WHERE grptab01. "vdtabgrc_tab09" <> 0 
UNION
  SELECT grptab01. "vdtabgrc_tab10" AS CODIGO_TABELA_PRECO,
         grptab01. "vdtabgrc_seq" AS CODIGO_RESTRICAO_COMERCIAL_ERP
  FROM  GRPTAB01 WHERE grptab01. "vdtabgrc_tab10" <> 0 ;

declare set varchar(255) @codigo_restricao = '';

CREATE
or replace VIEW  VW_RESTRICAO_FINANCEIRA_CAPA AS
SELECT
    1 AS ativo,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira,
    txpalm01."vdcnftxp_descto" AS desconto,
    txpalm01."vdcnftxp_descmax" AS desconto_maximo,
    txpalm01."vdcnftxp_taxa" AS taxa,
    txpalm01."vdcnftxp_vrpedmax" AS valor_maximo_pedido,
    txpalm01."vdcnftxp_vlrpedmin" AS valor_minimo_pedido,
    txpalm01."vdcnftxp_cpg" AS codigo_condicao_pagamento_rec_id,
    txpalm01."vdcnftxp_tpcobr" AS codigo_tipo_cobranca_rec_id
FROM
     TXPALM01
where
    (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    );

declare set varchar(255) @codigo_restricao = '';

CREATE
or replace VIEW  VW_RESTRICAO_FINANCEIRA_ITEM AS
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_1" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_1" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela_1" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_2" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_2" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela_2" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_3" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_3" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela_3" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_4" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_4" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela_4" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_5" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela_5" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela_5" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_1" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_1" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_1" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_2" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_2" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_2" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_3" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_3" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_3" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_4" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_4" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_4" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_5" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_5" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_5" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_6" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_6" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_6" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_7" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_7" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_7" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_8" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_8" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_8" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_9" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_9" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_9" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_10" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela2_10" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela2_10" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_1" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_1" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela3_1" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_2" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_2" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela3_2" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_3" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_3" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela3_3" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_4" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_4" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela3_4" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_5" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_5" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela3_5" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_6" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_6" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela3_6" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_7" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_7" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela3_7" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    )
UNION
SELECT
    concat(
        cast(VDPAROCO_ANOTAB_CARGA as varchar(4)),
        case when length(cast(VDPAROCO_MESTAB_CARGA as varchar(2))) = 1 then '0' || cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_8" as varchar(2)) else cast(VDPAROCO_MESTAB_CARGA as varchar(2)) || cast(txpalm01."vdcnftxp_tabela3_8" as varchar(2)) end
    ) AS CODIGO_TABELA_PRECO,
    concat(
        case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
        case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
    ) AS codigo_restricao_financeira
FROM
     TXPALM01,
     PAROCO01
WHERE
    txpalm01."vdcnftxp_tabela3_8" <> 0
    and (
        concat(
            case when length(Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_tpcobr" AS VARCHAR(2)) end,
            case when length(Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2))) = 1 then '0' || Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) else Cast(txpalm01."vdcnftxp_cpg" AS VARCHAR(2)) end
        ) = @codigo_restricao
        or @codigo_restricao = ''
    );

DECLARE SET INT @CODIGO_TIPO_COBRANCA = 0;

CREATE
or replace VIEW  VW_TIPO_COBRANCA AS
SELECT
    tpcobr01."vdcadtco_ativo" AS ATIVO,
    tpcobr01."vdcadtco_cod" AS CODIGO_TIPO_COBRANCA_ERP,
    tpcobr01."vdcadtco_descricao" AS DESCRICAO,
    tpcobr01."vdcadtco_prazo" AS PRAZO,
    tpcobr01."vdcadtco_redcnt" AS RED,
    tpcobr01."vdcadtco_redcnt" AS RED_F,
    tpcobr01."vdcadtco_perm01" AS PERM01,
    tpcobr01."vdcadtco_perm02" AS PERM02,
    tpcobr01."vdcadtco_perm03" AS PERM03,
    tpcobr01."vdcadtco_perm04" AS PERM04,
    tpcobr01."vdcadtco_perm05" AS PERM05,
    tpcobr01."vdcadtco_perm06" AS PERM06,
    tpcobr01."vdcadtco_perm07" AS PERM07,
    tpcobr01."vdcadtco_perm08" AS PERM08,
    tpcobr01."vdcadtco_perm09" AS PERM09             
FROM tpcobr01
WHERE
    (
        tpcobr01."vdcadtco_cod" = @CODIGO_TIPO_COBRANCA
        OR @CODIGO_TIPO_COBRANCA = 0
    );

DECLARE SET VARCHAR(255) @codigoclienteerp = '';


CREATE
or replace VIEW  VW_TIPO_COBRANCA_CLIENTE AS
SELECT
    1 AS ATIVO,
    Concat(
        CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 1 THEN Concat(
            '000',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 2 THEN Concat(
            '00',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 3 THEN Concat(
            '0',
            Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4)) END,
        CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 1 THEN Concat(
            '000',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 2 THEN Concat(
            '00',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 3 THEN Concat(
            '0',
            Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
        ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR (4)) END
    ) AS CODIGO_CLIENTE_ERP,
    VW_DADOS_CLIENTE."vdclicli_tpcobra" AS CODIGO_TIPO_COBRANCA_ERP
FROM
     VW_DADOS_CLIENTE
WHERE
    (
        Concat(
            CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 1 THEN Concat(
                '000',
                Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
            ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 2 THEN Concat(
                '00',
                Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
            ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 3 THEN Concat(
                '0',
                Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR(4))
            ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_regi" AS VARCHAR (4)) END,
            CASE WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 1 THEN Concat(
                '000',
                Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
            ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 2 THEN Concat(
                '00',
                Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
            ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 3 THEN Concat(
                '0',
                Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR(4))
            ) WHEN Length(Cast(VW_DADOS_CLIENTE."vdclicli_num" AS CHAR(4))) = 4 THEN Cast(VW_DADOS_CLIENTE."vdclicli_num" AS VARCHAR (4)) END
        ) = @codigoclienteerp OR @codigoclienteerp = ''
    );

DECLARE SET VARCHAR(255) @SIGLA ='';
DECLARE SET int @ATIVO =0;

CREATE
or replace VIEW  VW_TIPO_ENDERECO AS
SELECT
    @ATIVO AS ATIVO,
    "gegentip_cod" AS DESCRICAO_LOGRADOURO,
    "gegentip_sigla" AS SIGLA_LOGRADOURO
FROM
     CEPTIP
WHERE
    (
        "gegentip_cod" = @sigla
        OR @sigla = ''
    );

DECLARE SET INT @ATIVO = 1;

CREATE
or replace VIEW  VW_TIPO_OCORRENCIA AS
SELECT
    @ATIVO AS ATIVO,
    CASE cadoco01."vdnopoco_tipooco" WHEN 01 THEN 'Vendas' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 02 THEN 'Bonificacao' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 03 THEN 'Troca' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 04 THEN 'Indenizacao' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 05 THEN 'Cev Recolhimento' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 06 THEN 'Cev Recolhimento FE' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 07 THEN 'Cev Saida' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 08 THEN 'Cev Saida FE' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 09 THEN 'Cev Saida SL' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 10 THEN 'Cev Saida FESL' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 11 THEN 'Bonificacao Solavanco' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 12 THEN 'Recolhimento CEV' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 13 THEN 'Recolhimento CEV FE' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 14 THEN 'Recolhimento Vasilhame' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 15 THEN 'Recolhimento Vasilhame FE' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 16 THEN 'VIMOB' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 17 THEN 'Inventario' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 18 THEN 'Descarga' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 19 THEN 'Descarga Tipo01' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 20 THEN 'Venda Verba' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 21 THEN 'Bonificacao Automatica' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 22 THEN 'Transferencia' ELSE CASE cadoco01."vdnopoco_tipooco" WHEN 99 THEN 'Outros' END END END END END END END END END END END END END END END END END END END END END END END AS DESCRICAO,
    cadoco01."vdnopoco_tipooco" AS CODIGO_TIPO_OCORRENCIA_ERP
FROM
     CADOCO01
WHERE
    cadoco01."vdnopoco_tipooco" > 0
GROUP BY
    descricao,
    codigo_tipo_ocorrencia_erp
HAVING
    Count(
        DISTINCT cadoco01."vdnopoco_tipooco",
        cadoco01."vdnopoco_tipooco" > 0
    ) > 0;

DECLARE SET INT @CODIGO_CLIENTE = 0;
DECLARE SET INT @DATA_EMISSAO = 0;
DECLARE SET DECIMAL @VALORFINAL = 0;

CREATE
or replace VIEW  VW_VALIDA_DUP_PEDIDO AS
SELECT
    VDPEDCPP_PRE_PED
FROM
     VDPEDCPP
WHERE
    VDPEDCPP_CODCLI = @CODIGO_CLIENTE
    AND VDPEDCPP_DTEMI = @DATA_EMISSAO
    AND VDPEDCPP_VLRFIN = @VALORFINAL;


DECLARE SET VARCHAR(255) @CODIGO_VENDEDOR = '';

CREATE or replace VIEW  VW_VENDEDOR AS SELECT 1 AS ATIVO, cadven01. "vdvenven_sigla" AS CODIGO_VENDEDOR_ERP, cadven01. "vdvenven_nome" AS NOME, cadven01. "vdvenven_ddd" AS TELEFONE_DD, cadven01. "vdvenven_tel" AS TELEFONE_TRONCO, cast(cadven01. "vdvenven_nivel" as varchar(1)) AS TIPO, cadven01. "vdvenven_tpven" AS TIPO_VENDA FROM  CADVEN01 WHERE ( cadven01. "vdvenven_sigla" = @CODIGO_VENDEDOR OR @CODIGO_VENDEDOR = '' );


declare set varchar(255) @CODIGO_CLIENTE = '';

CREATE or replace VIEW VW_VENDEDOR_CLIENTE AS
SELECT
  1 ATIVO,
  CODIGO_CLIENTE CODIGO_CLIENTE_ERP,
  1 VENDEDOR,
  VDCLICLI_VEN CODIGO_VENDEDOR_ERP,
  VDCLICLI_CODPASTA1 PASTA_VISITA
FROM
  VW_DADOS_CLIENTE
WHERE
  CODIGO_CLIENTE = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = ''
UNION ALL
SELECT
  1 ATIVO,
  CODIGO_CLIENTE CODIGO_CLIENTE_ERP,
  2 VENDEDOR,
  VDCLICLI_VEN2 CODIGO_VENDEDOR_ERP,
  VDCLICLI_CODPASTA2 PASTA_VISITA
FROM
  VW_DADOS_CLIENTE
WHERE
  (CODIGO_CLIENTE = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '') AND VDCLICLI_VEN2 <> ''    
UNION ALL
SELECT
  1 ATIVO,
  CODIGO_CLIENTE CODIGO_CLIENTE_ERP,
  3 VENDEDOR,
  VDCLICLI_VEN3 CODIGO_VENDEDOR_ERP,
  VDCLICLI_CODPASTA3 PASTA_VISITA
FROM
  VW_DADOS_CLIENTE
WHERE
  (CODIGO_CLIENTE = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '') AND VDCLICLI_VEN3 <> ''    
UNION ALL
SELECT
  1 ATIVO,
  CODIGO_CLIENTE CODIGO_CLIENTE_ERP,
  4 VENDEDOR,
  VDCLICLI_VEN4 CODIGO_VENDEDOR_ERP,
  VDCLICLI_CODPASTA4 PASTA_VISITA
FROM
  VW_DADOS_CLIENTE
WHERE
  (CODIGO_CLIENTE = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '') AND VDCLICLI_VEN4 <> ''
UNION ALL    
SELECT
  1 ATIVO,
  CODIGO_CLIENTE CODIGO_CLIENTE_ERP,
  5 VENDEDOR,
  VDCLICLI_VEN5 CODIGO_VENDEDOR_ERP,
  VDCLICLI_CODPASTA5 PASTA_VISITA
FROM
  VW_DADOS_CLIENTE
WHERE
  (CODIGO_CLIENTE = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '') AND VDCLICLI_VEN5 <> '';    


declare set int @pasta = 0;
CREATE
or replace VIEW VW_VISITAS AS
select
    numero_pasta as numeroPasta,
TO_DATE(SUBSTRING(cast(data_visita as varchar(8)),7,2) || SUBSTRING(cast(data_visita as varchar(8)),5,2) || SUBSTRING(cast(data_visita as varchar(8)),1,4), 'DDMMYYYY') AS diaVisita

from
     PASTA_VISITA
where
    (
        numero_pasta = @pasta
        or @pasta = 0
    )
order by
    1;

DECLARE SET integer @nosso_numero = 0;
DECLARE SET smallint @sequencia_geracao =0;
DECLARE SET smallint @codigo_banco = 0;
DECLARE SET smallint  @numero_empresa =0;

CREATE OR replace VIEW vw_boleto                                                                      AS SELECT "vdfatblt_numero_banco"                                                                                         AS BANCO_BOLETO,
       "vdfatblt_area_digitacao"                                                                                       AS LINHA_DIGITAVEL_BOLETO,
        Concat(Repeat('0', 8 - Length(Cast(vdfatblt_codcli AS VARCHAR(8)))),Cast(vdfatblt_codcli AS VARCHAR(8)))       AS NUMERO_CLIENTE_BOLETO,
       "vdfatblt_cli_nome"                                                                                             AS NOME_CLIENTE_BOLETO,
       "vdfatblt_dt_emissao_e"                                                                                         AS DATA_EMISSAO_BOLETO,
       "vdfatblt_dt_vencimento_e"                                                                                      AS DATA_VENCIMENTO_BOLETO,
       "vdfatblt_ban_conta_corr"                                                                                       AS AGENCIA_CODIGO_BENEFICIARIO_BOLETO,
       "vdfatblt_nosso_numero"                                                                                         AS NOSSO_NUMERO_IMPRESSAO_BOLETO,
       "vdfatblt_num_doc"                                                                                              AS NUMERO_DOCUMENTO_BOLETO,
       "vdfatblt_valor_e"                                                                                              AS VALOR_DOCUMENTO_BOLETO,
       "vdfatblt_instrucao_1"                                                                                          AS INSTRUCAO1_BOLETO,
       "vdfatblt_instrucao_2"                                                                                          AS INSTRUCAO2_BOLETO,
       "vdfatblt_instrucao_3"                                                                                          AS INSTRUCAO3_BOLETO,
       "vdfatblt_instrucao_4"                                                                                          AS INSTRUCAO4_BOLETO,
       "vdfatblt_instrucao_5"                                                                                          AS INSTRUCAO5_BOLETO,
       "vdfatblt_instrucao_6"                                                                                          AS INSTRUCAO6_BOLETO,
       "vdfatblt_instrucao_7"                                                                                          AS INSTRUCAO7_BOLETO,
       "vdfatblt_instrucao_8"                                                                                          AS INSTRUCAO8_BOLETO,
       "vdfatblt_instrucao_9"                                                                                          AS INSTRUCAO9_BOLETO,
       "vdfatblt_local"                                                                                                AS LOCAL_DE_PAGAMENTO_BOLETO,
       "vdfatblt_emp_nome"                                                                                             AS BENEFICIARIO_BOLETO,
       "vdfatblt_emp_ender"                                                                                            AS ENDERECO_BENEFICIARIO_BOLETO,
       "vdfatblt_emp_cgc"                                                                                              AS CNPJ_BENEFICIARIO_BOLETO,
       "vdfatblt_par_data"                                                                                             AS DATA_BOLETO,
       "vdfatblt_espec_doc"                                                                                            AS ESPECIE_DOCUMENTO_BOLETO,
       "vdfatblt_aceite"                                                                                               AS ACEITE_BOLETO,
       "vdfatblt_par2_data"                                                                                            AS DATA_PROCESSAMENTO_BOLETO,
       "vdfatblt_usubco"                                                                                               AS USO_DO_BANCO_BOLETO,
       "vdfatblt_ban_carteira"                                                                                         AS CARTEIRA_BOLETO,
       "vdfatblt_especie"                                                                                              AS ESPECIE_MOEDA_BOLETO,
       "vdfatblt_qtd"                                                                                                  AS QUANTIDADE_MOEDA_BOLETO,
       "vdfatblt_valor_qtd"                                                                                            AS VALOR_MOEDA_BOLETO,
       "vdfatblt_instru"                                                                                               AS INSTRUCOES_BOLETO,
       "vdfatblt_descr_descto"                                                                                         AS DESCRICAO_DESCONTO_BOLETO,
       "vdfatblt_descr_outr"                                                                                           AS DESCRICAO_OUTRAS_DEDUCOES_BOLETO,
       "vdfatblt_descr_mora"                                                                                           AS DESCRICAO_MORA_MULTA_BOLETO,
       "vdfatblt_descr_outr_acresc"                                                                                    AS DESCRICAO_OUTROS_ACRESCIMOS_BOLETO,
       "vdfatblt_cli_docto"                                                                                            AS CNPJ_CLIENTE_BOLETO,
       "vdfatblt_cli_endereco"                                                                                         AS ENDERECO_CLIENTE_BOLETO,
       "vdfatblt_muni_cid_uf_pag"                                                                                      AS MUNICIPIO_UF_BOLETO,
       "vdfatblt_cli_cep"                                                                                              AS CEP_CLIENTE_BOLETO,
       "vdfatblt_pag_aval"                                                                                             AS PAGADOR_AVALISTA_BOLETO,
       "vdfatblt_cnpj_pag_aval"                                                                                        AS CNPJ_PAGADOR_AVALISTA_BOLETO,
       "vdfatblt_lin_sac1"                                                                                             AS LINHA_SAC1_BOLETO,
       "vdfatblt_lin_sac2"                                                                                             AS LINHA_SAC2_BOLETO,
       "vdfatblt_lin_sac3"                                                                                             AS LINHA_SAC3_BOLETO,
       "vdfatblt_lin_sac4"                                                                                             AS LINHA_SAC4_BOLETO,
       "vdfatblt_monta_barra"                                                                                          AS CODIGO_DE_BARRAS_BOLETO,
       "vdfatblt_cnpj_pagador"                                                                                         AS CNPJ_PAGADOR_BOLETO,
       "vdfatblt_val_descto"                                                                                           AS VALOR_DESCONTO_BOLETO,
       "vdfatblt_val_acresc"                                                                                           AS VALOR_ACRESCIMO_BOLETO,
       "vdfatblt_val_cobrado"                                                                                          AS VALOR_COBRADO_BOLETO,
       "vdfatblt_descr_pag"                                                                                            AS SACADOR_OU_PAGADOR_BOLETO,
       "vdfatblt_param1"                                                                                               AS TAMANHO_CODIGO_BARRAS,
       "vdfatblt_ordem"                                                                                                AS SEQUENCIA_BOLETO_GERACAO,
       "vdfatblt_bcoe"                                                                                                 AS NUMERO_BANCO_CNAB,
       "vdfatblt_nnum"                                                                                                 AS NOSSO_NUMERO
FROM   vdfatblt 
WHERE  ( 
              "vdfatblt_nnum" = @nosso_numero 
       OR     @nosso_numero = 0 ) 
AND    ( 
              "vdfatblt_bcoe" = @codigo_banco 
       OR     @codigo_banco = 0 ) 
AND    ( 
              "vdfatblt_ordem" = @sequencia_geracao 
       OR     @sequencia_geracao = 0 ) 
AND    vdfatblt_nremp = @numero_empresa;

DECLARE SET bigint @numero_pedido = 0;
DECLARE SET smallint  @numero_empresa = 0;

CREATE OR replace VIEW vw_boleto_por_pedido                                                           AS SELECT "vdfatbli_bcoe"                                                                                                 AS CODIGO_BANCO_BOLETO_POR_PEDIDO,
       "vdfatbli_nnum"                                                                                                 AS CODIGO_NOSSO_NUMERO_BOLETO_POR_PEDIDO,
       "vdfatbli_ordem"                                                                                                AS SEQUENCIA_BOLETO_POR_PEDIDO,
       "vdfatbli_nped"                                                                                                 AS NUMERO_PEDIDO_BOLETO_POR_PEDIDO,
       "vdfatbli_nnf"                                                                                                  AS NUMERO_NOTA_FISCAL_BOLETO_POR_PEDIDO,
       "vdfatbli_serie_nf"                                                                                             AS SERIE_NOTA_FISCAL_BOLETO_POR_PEDIDO,
              Concat(Repeat('0', 8 - Length(Cast(vdfatbli_codcli AS VARCHAR(8)))),Cast(vdfatbli_codcli AS VARCHAR(8))) AS CODIGO_CLIENTE_BOLETO_POR_PEDIDO,
       "vdfatbli_dt_emissao"                                                                                           AS DATA_EMISSAO_BOLETO_POR_PEDIDO,
       "vdfatbli_dt_vencimento"                                                                                        AS DATA_VENCIMENTO_BOLETO_POR_PEDIDO
FROM   vdfatbli 
WHERE  ( 
              "vdfatbli_nped" = @numero_pedido 
       OR     @numero_pedido = 0 ) 
AND    vdfatbli_nremp = @numero_empresa 
AND    vdfatbli_cancsn = 0;

DECLARE SET varchar(27) @CODIGO_COMBO = '';
DECLARE SET varchar(10) @CODIGO_PRODUTO_ERP = '';
DECLARE SET varchar(3) @CODIGO_OCORRENCIA_ERP = '';

CREATE OR replace VIEW vw_combo_produto       
  AS SELECT vdprdcbo."vdprdcbo_qtdcx"                                AS QUANTIDADE_CAIXA,
            vdprdcbo."vdprdcbo_qtdav"                                AS QUANTIDADE_AVULSO, 
            vdprdcbo."vdprdcbo_codrprd"                              AS CODIGO_PRODUTO_ERP, 
            vdprdcbo."vdprdcbo_ocor"                                 AS CODIGO_OCOR_ERP, 
            Cast(vdprdcbo_codcbo AS VARCHAR(10))               AS CODIGO_PRODUTO_COMBO_ERP 
FROM  vdprdcbo 
WHERE  vdprdcbo."vdprdcbo_codrprd" <> 0 
AND    (Cast(vdprdcbo.vdprdcbo_codcbo AS VARCHAR(10)) = @CODIGO_COMBO
       OR     @CODIGO_COMBO = '') 
AND    ( 
              Cast(vdprdcbo."vdprdcbo_codrprd" AS VARCHAR(10)) = @CODIGO_PRODUTO_ERP 
       OR     @CODIGO_PRODUTO_ERP = '') 
AND    ( 
              Cast(vdprdcbo."vdprdcbo_ocor" AS VARCHAR(3)) = @CODIGO_OCORRENCIA_ERP 
       OR     @CODIGO_OCORRENCIA_ERP = '');

CREATE OR replace VIEW  vw_seq_banda_preco 
AS 
  SELECT 1   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_1 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_1 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_1 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_1 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_1 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_1 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_1 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_1 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_1 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_1 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 2   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_2 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_2 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_2 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_2 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_2 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_2 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_2 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_2 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_2 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_2 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 3   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_3 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_3 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_3 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_3 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_3 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_3 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_3 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_3 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_3 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_3 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 4   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_4 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_4 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_4 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_4 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_4 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_4 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_4 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_4 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_4 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_4 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 5   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_5 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_5 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_5 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_5 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_5 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_5 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_5 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_5 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_5 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_5 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 6   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_6 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_6 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_6 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_6 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_6 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_6 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_6 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_6 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_6 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_6 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 7   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_7 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_7 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_7 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_7 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_7 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_7 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_7 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_7 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_7 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_7 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 8   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_8 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_8 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_8 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_8 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_8 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_8 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_8 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_8 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_8 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_8 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 9   SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_9 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_9 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_9 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_9 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_9 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_9 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_9 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_9 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_9 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_9 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 10  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_10 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_10 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_10 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_10 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_10 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_10 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_10 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_10 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_10 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_10 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 11  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_11 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_11 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_11 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_11 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_11 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_11 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_11 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_11 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_11 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_11 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 12  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_12 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_12 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_12 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_12 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_12 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_12 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_12 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_12 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_12 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_12 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 13  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_13 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_13 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_13 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_13 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_13 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_13 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_13 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_13 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_13 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_13 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 14  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_14 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_14 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_14 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_14 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_14 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_14 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_14 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_14 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_14 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_14 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 15  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_15 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_15 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_15 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_15 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_15 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_15 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_15 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_15 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_15 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_15 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 16  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_16 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_16 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_16 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_16 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_16 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_16 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_16 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_16 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_16 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_16 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 17  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_17 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_17 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_17 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_17 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_17 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_17 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_17 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_17 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_17 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_17 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 18  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_18 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_18 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_18 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_18 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_18 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_18 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_18 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_18 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_18 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_18 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 19  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_19 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_19 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_19 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_19 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_19 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_19 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_19 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_19 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_19 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_19 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 
  UNION ALL 
  SELECT 20  SEQUENCIA, 
         CASE 
           WHEN vdprdsbd_seq_1_20 = 1 THEN 1 
           ELSE 0 
         END FAMILIA, 
         CASE 
           WHEN vdprdsbd_seq_2_20 = 1 THEN 1 
           ELSE 0 
         END PRODUTO, 
         CASE 
           WHEN vdprdsbd_seq_3_20 = 1 THEN 1 
           ELSE 0 
         END GRUPO, 
         CASE 
           WHEN vdprdsbd_seq_4_20 = 1 THEN 1 
           ELSE 0 
         END CATEGORIA, 
         CASE 
           WHEN vdprdsbd_seq_5_20 = 1 THEN 1 
           ELSE 0 
         END MARCA, 
         CASE 
           WHEN vdprdsbd_seq_6_20 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CLIENTE, 
         CASE 
           WHEN vdprdsbd_seq_7_20 = 1 THEN 1 
           ELSE 0 
         END VENDEDOR, 
         CASE 
           WHEN vdprdsbd_seq_8_20 = 1 THEN 1 
           ELSE 0 
         END GRUPO_CANAL, 
         CASE 
           WHEN vdprdsbd_seq_9_20 = 1 THEN 1 
           ELSE 0 
         END COND_PAGTO, 
         CASE 
           WHEN vdprdsbd_seq_10_20 = 1 THEN 1 
           ELSE 0 
         END GRP_ESCALONADO 
  FROM    bdaseq01 ;
  
declare set bigint @CODIGO_BANDA = 0;

CREATE OR REPLACE VIEW VW_BANDA_PRECO_CAPA AS
SELECT DISTINCT
    1 ATIVO, 
    B.vdprdbda_id CODIGO_BANDA_PRECO_ERP, 
    NULL CODIGO_FAMEB, 
    B.vdprdbda_grpcli CODIGO_GRUPO_ANALISE_CLI, 
    B.vdprdbda_grpcan CODIGO_GRUPO_CANAL_CLI, 
    B.vdprdbda_pst CODIGO_PASTA_CLI, 
    NULL DESCRICAO, 
    CASE WHEN B.vdprdbda_importado = 'S' THEN 'IMPORTADO' ELSE 'MANUAL' END ORIGEM_BANDA, 
    CASE WHEN C.VDPAROCO_REG_PASTA_BANDPREC = 1 THEN B.vdprdbda_reg ELSE 0 END REGIAO_CLIENTE,
    CASE WHEN C.VDPAROCO_REG_PASTA_BANDPREC = 2 THEN B.vdprdbda_reg ELSE 0 END NUMERO_PASTA,
    CASE WHEN C.VDPAROCO_REG_PASTA_BANDPREC = 3 THEN B.vdprdbda_reg ELSE 0 END GRUPO_CLIENTE, 
    B.vdprdbda_caixa_unid UNIDADE, 
    CASE WHEN C.VDPAROCO_CAN_GRPCAN_BANDPREC = 1 THEN B.vdprdbda_can ELSE '' END CODIGO_CANAL_ERP,
    CASE WHEN C.VDPAROCO_CAN_GRPCAN_BANDPREC = 2 THEN B.vdprdbda_can ELSE '' END CODIGO_GRUPO_CANAL_ERP,
    B.vdprdbda_cat CODIGO_CATEGORIA_PRODUTO_ERP, 
    B.vdprdbda_fam CODIGO_FAMILIA_PRODUTO_ERP, 
    B.vdprdbda_grp CODIGO_GRUPO_PRODUTO_ERP, 
    B.vdprdbda_mar CODIGO_MARCA_PRODUTO_ERP, 
    B.vdprdbda_ven CODIGO_VENDEDOR_ERP, 
    B.vdprdbda_grpesc grupo_escalonado, 
    (SELECT vdprdprd_codr FROM cadprd01 WHERE vdprdprd_cfam = B.vdprdbda_fam AND vdprdprd_nro = B.vdprdbda_prd) CODIGO_PRODUTO_ERP, 
    B.vdprdbda_cpg CODIGO_CONDICAO_PAGAMENTO_ERP, 
    A.sequencia SEQUENCIA 
  FROM 
    (SELECT 
       * 
     FROM 
       vw_seq_banda_preco 
     WHERE 
       FAMILIA        = 1 OR 
       PRODUTO        = 1 OR 
       GRUPO          = 1 OR 
       CATEGORIA      = 1 OR
       MARCA          = 1 OR
       GRUPO_CLIENTE  = 1 OR 
       VENDEDOR       = 1 OR
       GRUPO_CANAL    = 1 OR 
       COND_PAGTO     = 1 OR
       GRP_ESCALONADO = 1
    ) A,
    bdapre01 B,
    PAROCO01 C 
  WHERE
    A.familia = CASE WHEN (B.vdprdbda_fam = NULL OR B.vdprdbda_fam = 0) THEN 0 ELSE 1  end AND
    A.produto = CASE WHEN (B.vdprdbda_prd = NULL OR B.vdprdbda_prd = 0) THEN 0 ELSE 1 end AND
    A.grupo = CASE WHEN (B.vdprdbda_grp = NULL OR B.vdprdbda_grp = 0) THEN 0 ELSE 1 end AND
    A.categoria = CASE WHEN (B.vdprdbda_cat = NULL OR B.vdprdbda_cat = 0) THEN 0 ELSE 1 end AND
    A.marca = CASE WHEN (B.vdprdbda_mar = NULL OR bdapre01.vdprdbda_mar = 0) THEN 0 ELSE 1 end AND
    A.grupo_cliente = CASE WHEN (B.vdprdbda_reg = NULL OR B.vdprdbda_reg = 0) THEN 0 ELSE 1 end AND
    A.vendedor = CASE WHEN (B.vdprdbda_ven = NULL OR B.vdprdbda_ven = '') THEN 0 ELSE 1 end AND
    A.grupo_canal = CASE WHEN (B.vdprdbda_can = NULL OR B.vdprdbda_can = '') THEN 0 ELSE 1 end AND
    A.cond_pagto = CASE WHEN (B.vdprdbda_cpg = NULL OR B.vdprdbda_cpg = 0) THEN 0 ELSE 1 end AND
    A.grp_escalonado = CASE WHEN (B.vdprdbda_grpesc = NULL OR B.vdprdbda_grpesc = 0) THEN 0 ELSE 1 end AND
    B.vdprdbda_cancsn = 0 AND
    (B.vdprdbda_id = @codigo_banda OR @codigo_banda = 0); 						

// Necessario informar o número da empresa (VDPEDFLC_NREMP = x)
CREATE OR REPLACE VIEW VW_DADOS_VDPEDFLC AS
SELECT 
  VDPEDFLC_NPED NUMERO_PEDIDO_VDPEDFLC,
  VDPEDFLC_NPED_REPROGRA numero_pedido_erp_reprogramado
FROM 
  VDPEDFLC 
WHERE
  VDPEDFLC_NREMP = 1 AND 
  VDPEDFLC_NPED >= cast(trim(DATETOSTR(Curdate()-45,'yyyymmdd')) || '0000' as bigint);

CREATE OR REPLACE VIEW VW_DADOS_OCORRENCIA AS 
SELECT 
  CAST(VDNOPOCO_COD AS INT) CODIGO_OCORRENCIA,
  VDNOPOCO_NOME DESCRICAO_OCORRENCIA
FROM
  CADOCO01;

DECLARE SET BIGINT @numero_pedido = 0;

CREATE
or replace VIEW VW_HISTORICO_PEDIDO_CAPA AS
SELECT
    CASE WHEN vdpedcpe_fl = 9 THEN 0 ELSE 1 END AS ATIVO,
    vdpedcpe_motdev CODIGO_MOTIVO_DEVOLUCAO,
    TO_DATE(SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),7,2) || SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),5,2) || SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),1,4), 'DDMMYYYY') AS DATA_HORA_EMISSAO_PEDIDO,
    CASE
    WHEN vdpedcpe_dt1vc = 0 THEN TO_DATE(SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),7,2) || SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),5,2) || SUBSTRING(cast(vdpedcpe_dtemiped as varchar(8)),1,4), 'DDMMYYYY')
    ELSE
    TO_DATE(SUBSTRING(cast(vdpedcpe_dt1vc as varchar(8)),7,2) || SUBSTRING(cast(vdpedcpe_dt1vc as varchar(8)),5,2) || SUBSTRING(cast(vdpedcpe_dt1vc as varchar(8)),1,4), 'DDMMYYYY') END AS DATA_VENCIMENTO,
    vdpedcpe_descfi DESCONTO_FINANCEIRO,
    vdpedcpe_nped NUMERO_PEDIDO,
    vdpedcpe_desc PERCENTUAL_DESCONTO,
    vdpedcpe_fl STATUS_PEDIDO,
    vdpedcpe_txfin TAXA_FINANCEIRO,
    numero_pedido_erp_reprogramado,
    vdpedcpe_vlr_fcem_r + vdpedcpe_vlr_fsem_r + vdpedcpe_vlr_fctr_r + vdpedcpe_vlr_fstr_r VALOR_DEVOLUCAO,
    vdpedcpe_vlr_fcem + vdpedcpe_vlr_fsem + vdpedcpe_vlr_fctr + vdpedcpe_vlr_fstr VALOR_PEDIDO,
    CODIGO_CLIENTE CODIGO_CLIENTE_REC_ID,
    vdpedcpe_cpg CODIGO_CONDICAO_PAGAMENTO_REC_ID,
    vdpedcpe_tpcobr CODIGO_TIPO_COBRANCA_REC_ID,
    VDCLICLI_CGC CNPJ_CPF,
    VDCLICLI_RAZAO50 RAZAO_CLIENTE,
    (SELECT VDCADPAG_DESCR FROM CONDPG01 WHERE vdcadpag_cod = vdpedcpe_cpg) DESCRICAO_CONDICAO_PAGAMENTO,
    (SELECT vdcadtco_descricao FROM TPCOBR01 WHERE VDCADTCO_COD = vdpedcpe_tpcobr) DESCRICAO_TIPO_COBRANCA,
    VDPEDCPE_SERIE SFISCAL,
    VDPEDCPE_NFIS NFISCAL_INI,
    VDPEDCPE_NFISULT NFISCAL_ULT
FROM
  PEDCP01
INNER JOIN
  VW_DADOS_VDPEDFLC ON NUMERO_PEDIDO_VDPEDFLC = VDPEDCPE_NPED
INNER JOIN 
  VW_DADOS_CLIENTE ON VDCLICLI_REGI = CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDPEDCPE_CODCLI AS VARCHAR(8)))) || CAST(VDPEDCPE_CODCLI AS VARCHAR(8)),1,4) AS INT) AND VDCLICLI_NUM = CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDPEDCPE_CODCLI AS VARCHAR(8)))) || CAST(VDPEDCPE_CODCLI AS VARCHAR(8)),5,4) AS INT)
WHERE
  vdpedcpe_nped >= cast(trim(DATETOSTR(Curdate()-45,'yyyymmdd')) || '0000' as bigint) AND
  (VDPEDCPE_NPED = @numero_pedido OR @numero_pedido = 0) AND
  CAST(SUBSTRING(CAST(VDPEDCPE_NPED AS VARCHAR(12)),9,4) AS INT) BETWEEN 1 AND 9999;

DECLARE SET BIGINT @NUMERO_PEDIDO = 0;

CREATE
or replace VIEW  VW_HISTORICO_PEDIDO_ITEM AS
SELECT
    vdpedipe_item NUMERO_ITEM_PEDIDO,
    vdpedipe_preprdt PRECO_ITEM_TOTAL,
    vdpedipe_qtds QUANTIDADE_AVULSA,
    vdpedipe_qtdprd QUANTIDADE_CAIXA,
    vdpedipe_nit NUMERO_PEDIDO_REC_ID,
    REPEAT('0',3-length(cast(vdpedipe_ocokd as char(3)))) || cast(vdpedipe_ocokd as char(3)) CODIGO_OCORRENCIA_REC_ID,
    vdpedipe_tbprd CODIGO_TABELA_PRECO_REC_ID,
    vdpedipe_codr CODIGO_PRODUTO_REC_ID,
    VDPRDPRD_DESCR DESCRICAO_PRODUTO,
    DESCRICAO_OCORRENCIA
FROM
    VW_HISTORICO_PEDIDO_CAPA
    INNER JOIN  PEDIT01 ON vdpedipe_nit = NUMERO_PEDIDO
    LEFT JOIN CADPRD01 ON VDPRDPRD_CODR = VDPEDIPE_CODR
    LEFT JOIN VW_DADOS_OCORRENCIA ON CODIGO_OCORRENCIA = VDPEDIPE_OCOKD
WHERE
   vdpedipe_nit = @numero_pedido OR @numero_pedido = 0;

declare set varchar(8) @codigo_cliente = '';
declare set int @CODIGO_GRUPO_ANALISE = 0;
CREATE OR REPLACE VIEW  VW_GRUPO_ANALISE AS 
SELECT 
  VDCLIROC_ROMA CODIGO_GRUPO_ANALISE,
  CODIGO_CLIENTE 
FROM 
  ROCLI01 
INNER JOIN  
  VW_DADOS_CLIENTE 
ON 
  VDCLICLI_REGI = CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLIROC_CCLI AS VARCHAR(8)))) || CAST(VDCLIROC_CCLI AS VARCHAR(8)) ,1,4) AS INT) AND 
  VDCLICLI_NUM = CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLIROC_CCLI AS VARCHAR(8)))) || CAST(VDCLIROC_CCLI AS VARCHAR(8)),5,4) AS INT) 
WHERE 
  VDCLIROC_CCLI > 0 AND
  (codigo_cliente = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = '' ) AND 
  (vdcliroc_roma = @CODIGO_GRUPO_ANALISE OR @CODIGO_GRUPO_ANALISE = 0);

DECLARE SET VARCHAR(3) @CODIGO_TIPO_PRODUTO = '';

CREATE OR REPLACE VIEW VW_TIPO_PRODUTO AS
SELECT 
  TRIM(GEGENCGM_NR) CODIGO_TIPO_PRODUTO,
  GEGENCGM_DESCRICAO_1 DESCRICAO_TIPO_PRODUTO
FROM
  GEGENCGM
WHERE 
  GEGENCGM_TIPO = 'TIPOPROD' AND
  TRIM(GEGENCGM_NR) = @CODIGO_TIPO_PRODUTO OR @CODIGO_TIPO_PRODUTO = ''; 

DECLARE SET INT @CODIGO_MENSAGEM = 0;

CREATE OR REPLACE VIEW VW_MENSAGENS_SFA AS
SELECT 
  VDCLIGMP_COD CODIGO_MENSAGEM,
  CASE WHEN VDCLIGMP_TIPO = 1 THEN 
         'SEMPRE' 
       ELSE 
         'PERIODO' 
  END PARAMETRO_EXIBICAO,
  CASE WHEN VDCLIGMP_TIPO = 1 THEN 
         '' 
       ELSE 
         CAST(VDCLIGMP_DTTPO1 AS VARCHAR(8))
  END PERIODO_INICIAL,
  CASE WHEN VDCLIGMP_TIPO = 1 THEN 
         '' 
       ELSE 
         CAST(VDCLIGMP_DTTPO2 AS VARCHAR(8))
  END PERIODO_FINAL,
  CASE WHEN VDCLIGMP_SELECAO = 1 THEN 
         'VENDEDOR'
       WHEN VDCLIGMP_SELECAO = 2 THEN
         'CLIENTE'
       WHEN VDCLIGMP_SELECAO = 3 THEN
         'CANAL'
       WHEN VDCLIGMP_SELECAO = 4 THEN
         'GRUPO_ANALISE'
       WHEN VDCLIGMP_SELECAO = 5 THEN 
         'ANIVERSARIANTES_AUTOMATICA'
       WHEN VDCLIGMP_SELECAO = 6 THEN 
         'COMODATOS_VENCIDOS_AUTOMATICA'
       WHEN VDCLIGMP_SELECAO = 7 THEN
         'FAMILIA_PRODUTO'
       WHEN VDCLIGMP_SELECAO = 8 THEN
         'TABELA_PRECO'
       WHEN VDCLIGMP_SELECAO = 9 THEN
         'OCORRENCIA'
       WHEN VDCLIGMP_SELECAO = 10 THEN
         'MOTIVO_BONIFICACAO'
       WHEN VDCLIGMP_SELECAO = 11 THEN
         'MOTIVO_TROCA'
       WHEN VDCLIGMP_SELECAO = 12 THEN
         'MOTIVO_COMODATO'
  END TIPO_SELECAO,
  CASE WHEN VDCLIGMP_SELECAO = 1 THEN 
         VDCLIGMP_VEN1
       WHEN VDCLIGMP_SELECAO = 2 THEN
         CAST(VDCLIGMP_COD1 AS VARCHAR(8))
       WHEN VDCLIGMP_SELECAO = 3 THEN
         VDCLIGMP_CANAL1
       WHEN VDCLIGMP_SELECAO = 4 THEN
         CAST(VDCLIGMP_GRPANALISE1 AS VARCHAR(4))
       WHEN VDCLIGMP_SELECAO = 5 THEN 
         ''
       WHEN VDCLIGMP_SELECAO = 6 THEN 
         ''
       WHEN VDCLIGMP_SELECAO = 7 THEN
         CAST(VDCLIGMP_CODPRD1 AS VARCHAR(6))
       WHEN VDCLIGMP_SELECAO = 8 THEN
         CAST(VDCLIGMP_TBPRD1 AS VARCHAR(8))
       WHEN VDCLIGMP_SELECAO = 9 THEN
         CAST(VDCLIGMP_OCORRENCIA1 AS VARCHAR(4))
       WHEN VDCLIGMP_SELECAO = 10 THEN
         CAST(VDCLIGMP_MOTBONIF1 AS VARCHAR(4))
       WHEN VDCLIGMP_SELECAO = 11 THEN
         VDCLIGMP_MOTTROCA1
       WHEN VDCLIGMP_SELECAO = 12 THEN
         VDCLIGMP_MOTCEV1
  END DADO_SELECAO_INICIAL,
  CASE WHEN VDCLIGMP_SELECAO = 1 THEN 
         VDCLIGMP_VEN2
       WHEN VDCLIGMP_SELECAO = 2 THEN
         CAST(VDCLIGMP_COD2 AS VARCHAR(8))
       WHEN VDCLIGMP_SELECAO = 3 THEN
         VDCLIGMP_CANAL2
       WHEN VDCLIGMP_SELECAO = 4 THEN
         CAST(VDCLIGMP_GRPANALISE2 AS VARCHAR(4))
       WHEN VDCLIGMP_SELECAO = 5 THEN ''
       WHEN VDCLIGMP_SELECAO = 6 THEN ''
       WHEN VDCLIGMP_SELECAO = 7 THEN
         CAST(VDCLIGMP_CODPRD2 AS VARCHAR(6))
       WHEN VDCLIGMP_SELECAO = 8 THEN
         CAST(VDCLIGMP_TBPRD2 AS VARCHAR(8))
       WHEN VDCLIGMP_SELECAO = 9 THEN
         CAST(VDCLIGMP_OCORRENCIA2 AS VARCHAR(4))
       WHEN VDCLIGMP_SELECAO = 10 THEN
         CAST(VDCLIGMP_MOTBONIF2 AS VARCHAR(4))
       WHEN VDCLIGMP_SELECAO = 11 THEN
         VDCLIGMP_MOTTROCA2
       WHEN VDCLIGMP_SELECAO = 12 THEN
         VDCLIGMP_MOTCEV2
  END DADO_SELECAO_FINAL,
  VDCLIGMP_DESCR MENSAGEM
FROM
  VDCLGM01
WHERE 
  VDCLIGMP_COD = @CODIGO_MENSAGEM OR @CODIGO_MENSAGEM = 0; 


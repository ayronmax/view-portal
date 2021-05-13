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
       CASE WHEN substring(REPEAT('0',15-LENGTH(CAST(vdclicli_cgc AS VARCHAR(15)))) || CAST(vdclicli_cgc AS VARCHAR(15)),10,4) = '0000' THEN 
            substring(REPEAT('0',15-LENGTH(CAST(vdclicli_cgc AS VARCHAR(15)))) || CAST(vdclicli_cgc AS VARCHAR(15)),1,9) || 
            substring(REPEAT('0',15-LENGTH(CAST(vdclicli_cgc AS VARCHAR(15)))) || CAST(vdclicli_cgc AS VARCHAR(15)),14,2) 
       else
         REPEAT('0',15-LENGTH(CAST(vdclicli_cgc AS VARCHAR(14)))) || CAST(vdclicli_cgc AS VARCHAR(14))
       end cpf_cnpj, 
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
       CASE WHEN VW_DADOS_CLIENTE. "vdclicli_fone" is null THEN'0' WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR (12))) <= 9 THEN Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR ( 12)) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR( 12)), 4, 12 ) ELSE CASE WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR(12 ))) = 1 THEN '0' ELSE substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR( 12)), 3, 11 ) END END AS telefone_tronco,
       VW_DADOS_CLIENTE. "vdclicli_verba_fin_pro"   AS uso_verba_restrito_produto, 
       VW_DADOS_CLIENTE. "vdclicli_cat"             AS codigo_canal_erp, 
       VW_DADOS_CLIENTE. "vdclicli_cpg"             AS codigo_condicao_pagamento_erp, 
       VW_DADOS_CLIENTE. "vdclicli_tpcobra"         AS codigo_tipo_cobranca_erp , 
       VW_DADOS_CLIENTE. "vdclicli_disp_portal_web" AS disponivel_portal ,
       CASE WHEN VW_DADOS_CLIENTE. "VDCLICLI_CEL1" is null then 0 else VW_DADOS_CLIENTE. "VDCLICLI_CEL1" end as celular,
       CASE WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR (12))) = 11 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR(12)), 1, 2) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR(12)), 1, 3) ELSE '0' END AS telefone2_ddd,
       CASE WHEN VW_DADOS_CLIENTE. "vdclicli_fone" is null or  Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR(12))) = 1 THEN '0' WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone" AS CHAR (12))) <= 9 THEN Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR (12)) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR(12)), 4, 12 )  ELSE substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fone2" AS CHAR(12)), 3, 11 ) END AS telefone2_tronco,
       CASE WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR (12))) = 11 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR(12)), 1, 2) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR(12)), 1, 3) ELSE '0' END AS celular_ddd,
       CASE WHEN VW_DADOS_CLIENTE. "vdclicli_cel1" is null or Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR(12))) = 1 THEN '0' WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR (12))) <= 9 THEN Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR (12)) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR(12)), 4, 12 ) ELSE substring(Cast( VW_DADOS_CLIENTE. "vdclicli_cel1" AS CHAR(12)), 3, 11 ) END AS celular_tronco,
       CASE WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR (12))) = 11 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR(12)), 1, 2) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR(12)), 1, 3) ELSE '0' END AS celular2_ddd,
       CASE WHEN VW_DADOS_CLIENTE. "vdclicli_cel2" is null or Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR(12))) = 1 THEN '0' WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR (12))) <= 9 THEN Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR (12)) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR(12)), 4, 12 )  ELSE substring(Cast( VW_DADOS_CLIENTE. "vdclicli_cel2" AS CHAR(12)), 3, 11 ) END AS celular2_tronco,
       CASE WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR (12))) = 11 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR(12)), 1, 2) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR(12)), 1, 3) ELSE '0' END AS telefone3_ddd,
       CASE WHEN VW_DADOS_CLIENTE. "vdclicli_fax" is null or Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR(12))) = 1 THEN '0' WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR (12))) <= 9 THEN Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR (12)) WHEN Char_length(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR (12))) = 12 THEN substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR(12)), 4, 12 ) ELSE substring(Cast( VW_DADOS_CLIENTE. "vdclicli_fax" AS CHAR(12)), 3, 11 ) END AS telefone3_tronco 
FROM    VW_DADOS_CLIENTE , 
        paroco01 
WHERE  
    VW_DADOS_CLIENTE."VDCLICLI_VEN" <> '   ' and 
    ( 
              Cast(
			  trim(REPEAT('0', 4 - Length(Cast( VW_DADOS_CLIENTE. "vdclicli_regi" AS CHAR( 4)))) || Cast( VW_DADOS_CLIENTE. "vdclicli_regi" AS CHAR( 4))) ||
			  trim(repeat('0', 4-length(Cast( VW_DADOS_CLIENTE. "vdclicli_num" AS CHAR( 4)))) || Cast( VW_DADOS_CLIENTE. "vdclicli_num" AS CHAR( 4))) 
			  AS INTEGER) = @CODIGO_CLIENTE OR @CODIGO_CLIENTE = 0 );
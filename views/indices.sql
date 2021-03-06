CREATE INDEX IDX_FAIXA_PEDIDO ON PEDCP01 (VDPEDCPE_NPED,CAST(SUBSTRING(CAST(VDPEDCPE_NPED AS VARCHAR(12)),9,4) AS INT));
CREATE INDEX IDX_CLIENTE ON PEDCP01 (CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDPEDCPE_CODCLI AS VARCHAR(8)))) || CAST(VDPEDCPE_CODCLI AS VARCHAR(8)),1,4) AS INT),CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDPEDCPE_CODCLI AS VARCHAR(8)))) || CAST(VDPEDCPE_CODCLI AS VARCHAR(8)),5,4) AS INT));
CREATE INDEX IDX_FAIXA_PEDIDO ON PEDIT01 (VDPEDIPE_NIT,CAST(SUBSTRING(CAST(VDPEDIPE_NIT AS VARCHAR(12)),9,4) AS INT));
CREATE INDEX IDX_FAIXA_PEDIDO ON VDPEDFLC (VDPEDFLC_NREMP,VDPEDFLC_NPED,CAST(SUBSTRING(CAST(VDPEDFLC_NPED AS VARCHAR(12)),9,4) AS INT));
CREATE INDEX IDX_REGIAO_CLIENTE ON CADCLI01 (VDCLICLI_REGI);
CREATE INDEX IDX_REGIAO_BW ON CADREG01 (VDCLIREG_COD, VDCLIREG_NUMSUBEMPRESA_BW);
CREATE INDEX IDX_CLIENTE ON ROCLI01 (CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLIROC_CCLI AS VARCHAR(8)))) || CAST(VDCLIROC_CCLI AS VARCHAR(8)),1,4) AS INT),CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLIROC_CCLI AS VARCHAR(8)))) || CAST(VDCLIROC_CCLI AS VARCHAR(8)),5,4) AS INT));
CREATE INDEX IDX_CLIENTE ON CLCVTE01 (CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLCVTE_CODCLI AS VARCHAR(8)))) || CAST(VDCLCVTE_CODCLI AS VARCHAR(8)),1,4) AS INT),CAST(SUBSTRING(REPEAT('0',8-LENGTH(CAST(VDCLCVTE_CODCLI AS VARCHAR(8)))) || CAST(VDCLCVTE_CODCLI AS VARCHAR(8)),5,4) AS INT));
CREATE OR REPLACE PROCEDURE SP_ATUALIZA_CLIENTE_SFA(
IN numeroEmpresa SMALLINT,
IN abateICMS SMALLINT,
IN alterou SMALLINT,
IN autor1 CHAR(80),
IN autor2 CHAR(80),
IN autor3 CHAR(80),
IN cpf1 DECIMAL(15,0),
IN cpf2 DECIMAL(15,0),
IN cpf3 DECIMAL(15,0),
IN regiaoInclusao SMALLINT,
IN codigoCliente INTEGER, 
IN rg1 CHAR(20),
IN rg2 CHAR(20),
IN rg3 CHAR(20),
IN barCode CHAR(1), 
IN bonusDisponivel DECIMAL(8,2), 
IN canalCandidato CHAR(1),
IN canalRegular CHAR(1),
IN cargo CHAR(30),
IN cevDiversos SMALLINT,
IN classe SMALLINT,
IN codigoCanal CHAR(2),
IN codigoTabelaPrecoCliente SMALLINT, 
IN codigoVendedor CHAR(8),
IN condicaoPagamentoCliente SMALLINT,
IN contato CHAR(60),
IN cpfCnpj DECIMAL(15,0),
IN dataNascimentoProprietario INTEGER, 
IN estabelecimento CHAR(2),
IN estadoCivil CHAR(1),
IN futebol CHAR(15),
IN hobby CHAR(19),
IN lazer CHAR(32),
IN proprietario CHAR(32),
IN qtdeFilhos SMALLINT,
IN curva CHAR(1),
IN desconsideraGpsPedido SMALLINT,
IN descontoFinanaceiro DECIMAL(4,2),
IN desprezaTaxaFinanceira SMALLINT,
IN diaSemana SMALLINT,
IN diasEntrega SMALLINT,
IN email CHAR(100),
IN bairroFat CHAR(60),
IN cepEnderecoFat INTEGER,
IN codigoCidadeFat INTEGER,
IN complementoFat CHAR(50),
IN enderecoFat CHAR(100),
IN municipioFat CHAR(60),
IN numeroFat INTEGER,
IN tipoLogradouroFat CHAR(40),
IN ufEnderecoFat CHAR(2),
IN bairroEnt CHAR(60),
IN cepEnderecoEnt INTEGER,
IN codigoCidadeEnt INTEGER,
IN complementoEnt CHAR(50),
IN enderecoEnt CHAR(100),
IN municipioEnt CHAR(60),
IN numeroEnt INTEGER,
IN tipoLogradouroEnt CHAR(40),
IN ufEnderecoEnt CHAR(2),
IN bairroCob CHAR(60),
IN cepEnderecoCob INTEGER,
IN codigoCidadeCob INTEGER,
IN complementoCob CHAR(50),
IN enderecoCob CHAR(100),
IN municipioCob CHAR(60),
IN numeroCob INTEGER,
IN tipoLogradouroCob CHAR(40),
IN ufEnderecoCob CHAR(2),
IN pontoReferencia CHAR(80),
IN sinalLatX CHAR(1),
IN coordenadaX CHAR(11),
IN sinalLatY CHAR(1),
IN coordenadaY CHAR(11),
IN grupoCanal CHAR(2),
IN horaFinalVisita DECIMAL(14,0),
IN horaFinalVisitaTZ CHAR(6),
IN horaInicialVisita DECIMAL(14,0),
IN horaInicialVisitaTZ CHAR(6),
IN icmsRetido CHAR(1),
IN ignoraBandaPreco SMALLINT,
IN inscricaoEstadual CHAR(25),
IN licenca SMALLINT,
IN limiteCredito DECIMAL(11,2),
IN motivoBloqClasse20 CHAR(3),
IN motivoBloqueioFinanceiro CHAR(3),
IN motivoBloqueioJuridico CHAR(3),
IN opina CHAR(1),
IN pasta SMALLINT,
IN pesquisaDiaria SMALLINT,
IN pesquisaDiariaRealizada SMALLINT,
IN pesquisaPPK SMALLINT,
IN pesquisaPPKEfetivada SMALLINT,
IN cerveja1 CHAR(10),
IN cerveja2 CHAR(10),
IN cerveja3 CHAR(10),
IN refrig1 CHAR(10),
IN refrig2 CHAR(10),
IN refrig3 CHAR(10),
IN jornal CHAR(10),
IN revista CHAR(10),
IN esporte CHAR(10),
IN qtdCevVasilhames INTEGER,
IN qtdComodatoFreezers SMALLINT,
IN razaoSocial CHAR(100),
IN restricaoComercial SMALLINT,
IN retornoTransmissaoWebService CHAR(10),
IN sequenciaVisita SMALLINT,
IN sigla CHAR(50),
IN statusTransmitidoWebService INTEGER,
IN subCanal SMALLINT,
IN taxaFinanceiraCliente DECIMAL(4,2),
IN telefoneDdd SMALLINT,
IN telefoneTronco INTEGER,
IN tipoCliente SMALLINT,
IN tipoCobrancaCliente SMALLINT,
IN transmitidoTX SMALLINT,
IN transmitirPortal SMALLINT,
IN urlPortal CHAR(100),
IN usoVerbaRestritoProduto SMALLINT,
IN utilizaVendaCruzada CHAR(1),
IN valorMinimoBoletoCliente DECIMAL(13,2),
IN verificadoCNPJ SMALLINT,
IN verificadoIE SMALLINT,
IN verificarCNPJ SMALLINT,
IN verificarIE SMALLINT,
IN dataBloqueio1 INTEGER,
IN dataBloqueio2 INTEGER,
IN dataBloqueio3 INTEGER,
IN codigoCliCia CHAR(12),
OUT COD_ERRO SMALLINT,
OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN

IF cpfCnpj IS NOT NULL THEN                                                                                                                 
   DECLARE strUser VARCHAR(20);                                                                                                          
   DECLARE strSql VARCHAR(5000);                                                                                                         
   DECLARE strDataProc VARCHAR(10);                                                                                                      
   DECLARE strHoraProc VARCHAR(8);
   DECLARE strSinalGpsLatitude VARCHAR(1);
   DECLARE strGpsLatitude VARCHAR(11);                                                                                                       
   DECLARE strSinalGpsLongitude VARCHAR(1);
   DECLARE strGpsLongitude VARCHAR(11);
   
   SET strUser = SELECT TRIM(CURRENT_USER);
   SET strDataProc = REPLACE(CAST(CURDATE() AS VARCHAR(10)), '-', '');
   SET strHoraProc = LEFT(REPLACE(CAST(CURTIME() AS VARCHAR(8)), ':', ''), 6);                
   
   SET strSinalGpsLatitude = sinalLatX;
   SET strSinalGpsLongitude = sinalLatY;
   SET strGpsLatitude = coordenadaX; 
   SET strGpsLongitude = coordenadaY;
   
   SET strSql = 'INSERT OR REPLACE INTO ' || strUser || '.VDCLIACL';                                                                                                                                      
   SET strSql = strSql || ' (VDCLIACL_NREMP,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_DT_EVENTO,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_HR_EVENTO,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_CGC,';                                                                                          
   SET strSql = strSql || 'VDCLIACL_LOGDT,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_INCLDT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_INCLHR,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_INCLUSER,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_ALTEDT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_ALTEHR,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_ALTEUSER,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_CANCDT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CANCHR,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CANCUSER,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_CANCSN,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_NIVELAUDIT,';                                                                                   
   SET strSql = strSql || 'VDCLIACL_INTEGRADO,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_REGIAO_CLI,';                                                                                   
   SET strSql = strSql || 'VDCLIACL_COD_CLI,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_RAZAO,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_SIGLA,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_CAT,';                                                                                          
   SET strSql = strSql || 'VDCLIACL_SUBCANAL,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_CLASSE,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_MOTBLO,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CURVA,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_OPINA,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_TIPCLI,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_GRUPO,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_TIPENDFAT,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_ENDFAT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_NUMFAT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_BAIFAT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CODCIDFAT,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_MUNFAT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_ESTFAT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CEPFAT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_COMPL_ENDFAT,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_TIPENDCOB,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_ENDCOB,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_NUMCOB,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_BAICOB,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CODCIDCOB,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_MUNCOB,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_ESTCOB,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CEPCOB,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_COMPL_ENDCOB,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_TIPENDENT,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_ENDENT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_NUMENT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_BAIENT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CODCIDENT,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_MUNENT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_ESTENT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CEPENT,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_COMPL_ENDENT,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_PTOREF,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_FONE,';                                                                                         
   SET strSql = strSql || 'VDCLIACL_CONTATO,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_CARGO,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_EMAIL,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_ICMRET,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_SUBSTFRE,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_INEST,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_VENDEDOR,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_ROTA,';                                                                                         
   SET strSql = strSql || 'VDCLIACL_PASTA,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_DIA_SEMANA,';                                                                                   
   SET strSql = strSql || 'VDCLIACL_SEQV,';                                                                                         
   SET strSql = strSql || 'VDCLIACL_CREDITO,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_TABELA,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_CPG,';                                                                                          
   SET strSql = strSql || 'VDCLIACL_TPCOBR,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_DSF,';                                                                                          
   SET strSql = strSql || 'VDCLIACL_DESCFIN,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_TXFIN,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_HORACES,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_DIGITO,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_XHORACES,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_XDIGITO,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_AUTOR1,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_P1_CPF,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_RGRESP1,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_DTBLO1,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_AUTOR2,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_P2_CPF,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_RGRESP2,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_DTBLO2,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_AUTOR3,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_P3_CPF,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_RGRESP3,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_DTBLO3,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_PROPRIETARIO,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_NASCPROP,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_QTDFILHOS,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_FUTEBOL,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_LAZER,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_HOBBY,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_PESQDIARIA,';                                                                                   
   SET strSql = strSql || 'VDCLIACL_PESQDIARIAEFET,';                                                                               
   SET strSql = strSql || 'VDCLIACL_SITDEV,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_RENDA,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_GRPCAN,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_PORTE,';                                                                                        
   SET strSql = strSql || 'VDCLIACL_TAB_POLAR,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_TAB_ESPECIAL,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_CERVEJA1,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_CERVEJA2,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_CERVEJA3,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_REFRIG1,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_REFRIG2,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_REFRIG3,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_REVISTA,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_JORNAL,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_ESPORTE,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_ESTABELEC,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_ESTCIVIL,';                                                                                     
   SET strSql = strSql || 'VDCLIACL_BARCODE,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_VERIFICAR_CGC,';                                                                                
   SET strSql = strSql || 'VDCLIACL_VERIFICAR_INEST,';                                                                              
   SET strSql = strSql || 'VDCLIACL_VERIFICADO_CGC,';                                                                               
   SET strSql = strSql || 'VDCLIACL_VERIFICADO_INEST,';                                                                             
   SET strSql = strSql || 'VDCLIACL_NAROTA,';                                                                                       
   SET strSql = strSql || 'VDCLIACL_BANDA_PRECO,';                                                                                  
   SET strSql = strSql || 'VDCLIACL_MOTBLO_JUR,';                                                                                   
   SET strSql = strSql || 'VDCLIACL_MOTBLO_CL,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_DIAS_ENTREGA,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_DESPREZA_TAXA,';                                                                                
   SET strSql = strSql || 'VDCLIACL_ALTEROU,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_SINAL_LAT_X,';                                                                                  
   SET strSql = strSql || 'VDCLIACL_COORDENADA_X,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_SINAL_LON_Y,';                                                                                  
   SET strSql = strSql || 'VDCLIACL_COORDENADA_Y,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_CEVS_GELADEIRA,';                                                                               
   SET strSql = strSql || 'VDCLIACL_CEVS_VASILHAME,';                                                                               
   SET strSql = strSql || 'VDCLIACL_CEVS_DIVERSOS,';                                                                                
   SET strSql = strSql || 'VDCLIACL_CANDIDATA,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_REGULAR,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_BONUS_DISPONIVEL,';                                                                             
   SET strSql = strSql || 'VDCLIACL_UTILIZA_VCRUZADA,';                                                                             
   SET strSql = strSql || 'VDCLIACL_PESQPPS,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_PESQPPSEFET,';                                                                                  
   SET strSql = strSql || 'VDCLIACL_VERBA_FIN_PRO,';                                                                                
   SET strSql = strSql || 'VDCLIACL_ABATEICMS,';                                                                                    
   SET strSql = strSql || 'VDCLIACL_PERMITE_PED_FORA_GPS,';                                                                         
   SET strSql = strSql || 'VDCLIACL_VLR_MIN_BOL,';                                                                                  
   SET strSql = strSql || 'VDCLIACL_CAMPO_FIXO_1,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_LICENCA,';                                                                                      
   SET strSql = strSql || 'VDCLIACL_DT_HR_VIS_INICIAL,';                                                                            
   SET strSql = strSql || 'VDCLIACL_TZ_VIS_INICIAL,';                                                                               
   SET strSql = strSql || 'VDCLIACL_DT_HR_VIS_FINAL,';                                                                              
   SET strSql = strSql || 'VDCLIACL_TZ_VIS_FINAL,';                                                                                 
   SET strSql = strSql || 'VDCLIACL_RESTR_COML,';                                                                                   
   SET strSql = strSql || 'VDCLIACL_RET_TRANS_WEBSERVICE,';                                                                         
   SET strSql = strSql || 'VDCLIACL_STA_TRANS_WEBSERVICE,';                                                                         
   SET strSql = strSql || 'VDCLIACL_TRANSMITIDO_TX,';                                                                               
   SET strSql = strSql || 'VDCLIACL_TRANSMITIR_PORTAL,';                                                                            
   SET strSql = strSql || 'VDCLIACL_URL_PORTAL,';
   SET strSql = strSql || 'VDCLIACL_CODCLICIA)';                                                                                   
   SET strSql = strSql || ' VALUES (';                                                                                              
   SET strSql = strSql || CAST(numeroEmpresa AS VARCHAR(3)) || ',';                                                                 
   SET strSql = strSql || strDataProc || ',';                                                                                       
   SET strSql = strSql || strHoraProc || ',';                                                                                       
   SET strSql = strSql || CAST(cpfCnpj AS VARCHAR(15)) || ',';                                                                      
   SET strSql = strSql || strDataProc || ',';                                                                                       
   SET strSql = strSql || strDataProc || ',';                                                                                       
   SET strSql = strSql || LEFT(strHoraProc, 4) || ',';                                                                                       
   SET strSql = strSql || '''' || 'SAP' || '''' || ',';                                                                             
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || CAST(regiaoInclusao AS VARCHAR(4)) || ',';                                                                 
   SET strSql = strSql || CAST(codigoCliente AS VARCHAR(8)) || ',';                                                                 
   SET strSql = strSql || '''' || razaoSocial || '''' ||  ',';                                                                      
   SET strSql = strSql || '''' || sigla || '''' ||  ',';                                                                            
   SET strSql = strSql || '''' || codigoCanal || '''' ||  ',';                                                                      
   SET strSql = strSql || CAST(subCanal AS VARCHAR(3)) || ',';                                                                      
   SET strSql = strSql || CAST(classe AS VARCHAR(2)) || ',';                                                                        
   SET strSql = strSql || '''' || motivoBloqueioFinanceiro || '''' ||  ',';                                                         
   SET strSql = strSql || '''' || curva || '''' ||  ',';                                                                            
   SET strSql = strSql || '''' || opina || '''' ||  ',';                                                                            
   SET strSql = strSql || CAST(tipoCliente AS VARCHAR(2)) || ',';                                                                   
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '''' || tipoLogradouroFat || '''' ||  ',';                                                                
   SET strSql = strSql || '''' || enderecoFat || '''' ||  ',';                                                                      
   SET strSql = strSql || CAST(numeroFat AS VARCHAR(6)) || ',';                                                                     
   SET strSql = strSql || '''' || bairroFat || '''' ||  ',';                                                                        
   SET strSql = strSql || CAST(codigoCidadeFat AS VARCHAR(5)) || ',';                                                               
   SET strSql = strSql || '''' || municipioFat || '''' ||  ',';                                                                     
   SET strSql = strSql || '''' || ufEnderecoFat || '''' ||  ',';                                                                    
   SET strSql = strSql || CAST(cepEnderecoFat AS VARCHAR(8)) || ',';                                                                
   SET strSql = strSql || '''' || complementoFat || '''' ||  ',';                                                                   
   SET strSql = strSql || '''' || tipoLogradouroEnt || '''' ||  ',';                                                                
   SET strSql = strSql || '''' || enderecoEnt || '''' ||  ',';                                                                      
   SET strSql = strSql || CAST(numeroEnt AS VARCHAR(6)) || ',';                                                                     
   SET strSql = strSql || '''' || bairroEnt || '''' ||  ',';                                                                        
   SET strSql = strSql || CAST(codigoCidadeEnt AS VARCHAR(5)) || ',';                                                               
   SET strSql = strSql || '''' || municipioEnt || '''' ||  ',';                                                                     
   SET strSql = strSql || '''' || ufEnderecoEnt || '''' ||  ',';                                                                    
   SET strSql = strSql || CAST(cepEnderecoEnt AS VARCHAR(8)) || ',';                                                                
   SET strSql = strSql || '''' || complementoEnt || '''' ||  ',';                                                                   
   SET strSql = strSql || '''' || tipoLogradouroCob || '''' ||  ',';                                                                
   SET strSql = strSql || '''' || enderecoCob || '''' ||  ',';                                                                      
   SET strSql = strSql || CAST(numeroCob AS VARCHAR(6)) || ',';                                                                     
   SET strSql = strSql || '''' || bairroCob || '''' ||  ',';                                                                        
   SET strSql = strSql || CAST(codigoCidadeCob AS VARCHAR(5)) || ',';                                                               
   SET strSql = strSql || '''' || municipioCob || '''' ||  ',';                                                                     
   SET strSql = strSql || '''' || ufEnderecoCob || '''' ||  ',';                                                                    
   SET strSql = strSql || CAST(cepEnderecoCob AS VARCHAR(8)) || ',';                                                                
   SET strSql = strSql || '''' || complementoCob || '''' ||  ',';                                                                   
   SET strSql = strSql || '''' || pontoReferencia || '''' ||  ',';                                                                  
   SET strSql = strSql || CAST(telefoneDdd AS VARCHAR(2)) || CAST(telefoneTronco AS VARCHAR(9)) || ',';                             
   SET strSql = strSql || '''' || contato || '''' ||  ',';                                                                          
   SET strSql = strSql || '''' || cargo || '''' ||  ',';                                                                            
   SET strSql = strSql || '''' || email || '''' ||  ',';                                                                            
   SET strSql = strSql || '''' || icmsRetido || '''' ||  ',';                                                                       
   SET strSql = strSql || '''' || 'N' || '''' || ',';                                                                               
   SET strSql = strSql || '''' || inscricaoEstadual || '''' ||  ',';                                                                
   SET strSql = strSql || '''' || codigoVendedor || '''' ||  ',';                                                                   
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || CAST(pasta AS VARCHAR(4)) || ',';                                                                         
   SET strSql = strSql || CAST(diaSemana AS VARCHAR(2)) || ',';                                                                     
   SET strSql = strSql || CAST(sequenciaVisita AS VARCHAR(3)) || ',';                                                               
   SET strSql = strSql || CAST(limiteCredito AS VARCHAR(11)) || ',';                                                                
   SET strSql = strSql || CAST(codigoTabelaPrecoCliente AS VARCHAR(2)) || ',';                                                      
   SET strSql = strSql || CAST(condicaoPagamentoCliente AS VARCHAR(4)) || ',';                                                      
   SET strSql = strSql || CAST(tipoCobrancaCliente AS VARCHAR(2)) || ',';                                                           
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || CAST(descontoFinanaceiro AS VARCHAR(4)) || ',';                                                           
   SET strSql = strSql || CAST(taxaFinanceiraCliente AS VARCHAR(4)) || ',';                                                         
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || '''' || autor1 || '''' ||  ',';                                                                           
   SET strSql = strSql || CAST(cpf1 AS VARCHAR(15)) || ',';                                                                         
   SET strSql = strSql || '''' || rg1 || '''' ||  ',';                                                                              
   SET strSql = strSql || CAST(dataBloqueio1 AS VARCHAR(8)) || ',';                                                                 
   SET strSql = strSql || '''' || autor2 || '''' ||  ',';                                                                           
   SET strSql = strSql || CAST(cpf2 AS VARCHAR(15)) || ',';                                                                         
   SET strSql = strSql || '''' || rg2 || '''' ||  ',';                                                                              
   SET strSql = strSql || CAST(dataBloqueio2 AS VARCHAR(8)) || ',';                                                                 
   SET strSql = strSql || '''' || autor3 || '''' ||  ',';                                                                           
   SET strSql = strSql || CAST(cpf3 AS VARCHAR(15)) || ',';                                                                         
   SET strSql = strSql || '''' || rg3 || '''' ||  ',';                                                                              
   SET strSql = strSql || CAST(dataBloqueio3 AS VARCHAR(8)) || ',';                                                                 
   SET strSql = strSql || '''' || proprietario || '''' ||  ',';                                                                     
   SET strSql = strSql || CAST(dataNascimentoProprietario AS VARCHAR(8)) || ',';                                                    
   SET strSql = strSql || CAST(qtdeFilhos AS VARCHAR(2)) || ',';                                                                    
   SET strSql = strSql || '''' || futebol || '''' ||  ',';                                                                          
   SET strSql = strSql || '''' || lazer || '''' ||  ',';                                                                            
   SET strSql = strSql || '''' || hobby || '''' ||  ',';                                                                            
   SET strSql = strSql || CAST(pesquisaDiaria AS VARCHAR(1)) || ',';                                                                
   SET strSql = strSql || CAST(pesquisaDiariaRealizada AS VARCHAR(1)) || ',';                                                       
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || '''' || grupoCanal || '''' ||  ',';                                                                       
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || '''' || cerveja1 || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || cerveja2 || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || cerveja3 || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || refrig1 || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || refrig2 || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || refrig3 || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || revista || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || jornal || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || esporte || '''' ||  ',';                                                                               
   SET strSql = strSql || '''' || estabelecimento || '''' ||  ',';                                                                  
   SET strSql = strSql || '''' || estadoCivil || '''' ||  ',';                                                                      
   SET strSql = strSql || '''' || barCode || '''' ||  ',';                                                                          
   SET strSql = strSql || CAST(verificarCNPJ AS VARCHAR(1)) || ',';                                                                 
   SET strSql = strSql || CAST(verificarIE AS VARCHAR(1)) || ',';                                                                   
   SET strSql = strSql || CAST(verificadoCNPJ AS VARCHAR(1)) || ',';                                                                
   SET strSql = strSql || CAST(verificadoIE AS VARCHAR(1)) || ',';                                                                  
   SET strSql = strSql || '''' || ' ' || '''' || ',';                                                                               
   SET strSql = strSql || CAST(ignoraBandaPreco AS VARCHAR(1)) || ',';                                                              
   SET strSql = strSql || '''' || motivoBloqueioJuridico || '''' ||  ',';                                                           
   SET strSql = strSql || '''' || motivoBloqClasse20 || '''' ||  ',';                                                               
   SET strSql = strSql || CAST(diasEntrega AS VARCHAR(2)) || ',';                                                                   
   SET strSql = strSql || CAST(desprezaTaxaFinanceira AS VARCHAR(1)) || ',';                                                        
   SET strSql = strSql || CAST(alterou AS VARCHAR(1)) || ',';                                                                       
   SET strSql = strSql || '''' || strSinalGpsLatitude || '''' ||  ',';      
   SET strSql = strSql || strGpsLatitude || ',';   
   SET strSql = strSql || '''' || strSinalGpsLongitude || '''' ||  ',';    
   SET strSql = strSql || strGpsLongitude || ',';
   SET strSql = strSql || CAST(qtdCevVasilhames AS VARCHAR(2)) || ',';                                                              
   SET strSql = strSql || CAST(qtdComodatoFreezers AS VARCHAR(5)) || ',';                                                           
   SET strSql = strSql || CAST(cevDiversos AS VARCHAR(5)) || ',';                                                                   
   SET strSql = strSql || '''' || canalCandidato || '''' ||  ',';                                                                   
   SET strSql = strSql || '''' || canalRegular || '''' ||  ',';                                                                     
   SET strSql = strSql || CAST(bonusDisponivel AS VARCHAR(8)) || ',';                                                               
   SET strSql = strSql || '''' || utilizaVendaCruzada || '''' ||  ',';                                                              
   SET strSql = strSql || CAST(pesquisaPPK AS VARCHAR(1)) || ',';                                                                   
   SET strSql = strSql || CAST(pesquisaPPKEfetivada AS VARCHAR(1)) || ',';                                                          
   SET strSql = strSql || CAST(usoVerbaRestritoProduto AS VARCHAR(1)) || ',';                                                       
   SET strSql = strSql || CAST(abateICMS AS VARCHAR(1)) || ',';                                                                     
   SET strSql = strSql || CAST(desconsideraGpsPedido AS VARCHAR(1)) || ',';                                                         
   SET strSql = strSql || CAST(valorMinimoBoletoCliente AS VARCHAR(13)) || ',';                                                     
   SET strSql = strSql || '0' || ',';                                                                                               
   SET strSql = strSql || CAST(licenca AS VARCHAR(4)) || ',';                                                                       
   SET strSql = strSql || CAST(horaInicialVisita AS VARCHAR(14)) || ',';                                                            
   SET strSql = strSql || '''' || horaInicialVisitaTZ || '''' ||  ',';                                                              
   SET strSql = strSql || CAST(horaFinalVisita AS VARCHAR(14)) || ',';                                                              
   SET strSql = strSql || '''' || horaFinalVisitaTZ || '''' ||  ',';                                                                
   SET strSql = strSql || CAST(restricaoComercial AS VARCHAR(1)) || ',';                                                            
   SET strSql = strSql || '''' || retornoTransmissaoWebService || '''' ||  ',';                                                     
   SET strSql = strSql || CAST(statusTransmitidoWebService AS VARCHAR(5)) || ',';                                                   
   SET strSql = strSql || CAST(transmitidoTX AS VARCHAR(1)) || ',';                                                                 
   SET strSql = strSql || CAST(transmitirPortal AS VARCHAR(1)) || ',';                                                              
   SET strSql = strSql || '''' || urlPortal || '''' || ',';
   SET strSql = strSql || '''' || codigoCliCia || '''' ||  ')';
   
   EXECUTE IMMEDIATE strSql;
                      
   SET COD_ERRO = 0;
   SET MSG_ERRO = 'Complemento de Cliente iserido com sucesso!';                                                                         
ELSE
  SET COD_ERRO = 1;
  SET MSG_ERRO = 'CPF ou CNPJ é obrigatório!';
END IF;

END;
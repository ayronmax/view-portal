CREATE OR REPLACE PROCEDURE SP_BW_ESTOQUE_CONSOLIDADO(IN SCHEMA_MATRIZ VARCHAR(20),
                                                      IN NUM_EMP_MATRIZ VARCHAR(2),
                                                      IN SCHEMA_FILIAL VARCHAR(1000),
                                                      IN NUM_EMP_FILIAL VARCHAR(500),
                                                      IN NUM_EMP_FILIAL_CONSOLIDA VARCHAR(500),
                                                      OUT COD_ERRO SMALLINT,
                                                      OUT MSG_ERRO VARCHAR(100))

LANGUAGE SQL

BEGIN
  -- SCHEMA_MATRIZ = Nome do schema da empresa matriz onde será consolidado o saldo do estoque das filiais (ex.: DBCONTROL1001001);
  -- NUM_EMP_MATRIZ = Número da empresa que compõe o nome da tabela de saldo do estoque com 2 dígitos (ex.: 01);
  -- SCHEMA_FILIAL = Nome dos schemas das empresas filiais separados por vírgula, que terão o saldo do estoque consolidado 
  -- (ex.: DBCONTROL1002002, DBCONTROL1003003, DBCONTROL1004004);
  -- NUM_EMP_FILIAL = Número das empresas filiais que compõem o nome das tabelas de saldo dos estoques com 2 dígitos, separados por vírgula
  -- (ex.: 02, 03, 04);
  -- NUM_EMP_CONSOLIDA = Número único para cada empresa filial separado por vírgula (ex.: 01, 02, 03, 04).
  
  DECLARE schema_filial_atual VARCHAR(20);
  DECLARE schema_filial_seg VARCHAR(1000);
  DECLARE num_emp_filial_atual VARCHAR(2);
  DECLARE num_emp_filial_seg VARCHAR(500);
  DECLARE num_emp_filial_consolida_atual VARCHAR(500);
  DECLARE num_emp_filial_consolida_seg VARCHAR(500);
  DECLARE data_atual DATE;
  DECLARE ano SMALLINT;
  DECLARE mes SMALLINT; 
  DECLARE dia SMALLINT;
  DECLARE tabela_matriz VARCHAR(20);
  DECLARE tabela_filial VARCHAR(20); 
  DECLARE sql_create_view VARCHAR(5000);
  DECLARE sql_cprd VARCHAR(5000);
  DECLARE sql_dia VARCHAR(5000);
  DECLARE sql_ocokd VARCHAR(5000);
  DECLARE sql_sldiniun VARCHAR(5000);
  DECLARE sql_sldentun VARCHAR(5000);
  DECLARE sql_sldsaiun VARCHAR(5000);
  DECLARE sql_csttotal VARCHAR(5000);
  DECLARE sql_csttotalun VARCHAR(5000);
    
  SET schema_filial_atual = TRIM(LEFT(SCHEMA_FILIAL, LOCATE(',', SCHEMA_FILIAL, 1) - 1));
  SET schema_filial_seg = TRIM(RIGHT(SCHEMA_FILIAL, LENGTH(SCHEMA_FILIAL) - LOCATE(',', SCHEMA_FILIAL, 1)));
  SET num_emp_filial_atual = TRIM(LEFT(NUM_EMP_FILIAL, LOCATE(',', NUM_EMP_FILIAL, 1) - 1));
  SET num_emp_filial_seg = TRIM(RIGHT(NUM_EMP_FILIAL, LENGTH(NUM_EMP_FILIAL) - LOCATE(',', NUM_EMP_FILIAL, 1)));
  SET num_emp_filial_consolida_atual = TRIM(LEFT(NUM_EMP_FILIAL_CONSOLIDA, LOCATE(',', NUM_EMP_FILIAL_CONSOLIDA, 1) - 1));
  SET num_emp_filial_consolida_seg = TRIM(RIGHT(NUM_EMP_FILIAL_CONSOLIDA, LENGTH(NUM_EMP_FILIAL_CONSOLIDA) - LOCATE(',', NUM_EMP_FILIAL_CONSOLIDA, 1)));
  SET data_atual = CURDATE();  
  SET ano = YEAR(data_atual);
  SET mes = MONTH(data_atual);
  SET dia = DAYOFMONTH(data_atual);
  SET tabela_matriz = 'SD' || RIGHT(CAST(ano AS VARCHAR(4)), 2) || REPEAT('0', 2 - LENGTH(CAST(mes AS VARCHAR(2)))) || CAST(mes AS VARCHAR(2)) || NUM_EMP_MATRIZ;
  SET sql_create_view = 'CREATE OR REPLACE VIEW ' || TRIM(SCHEMA_MATRIZ) || '.VDSLDCON AS SELECT ';
  SET sql_cprd = 'COALESCE(MATRIZ.VDKARSLD_CPRD';
  SET sql_dia = 'COALESCE(MATRIZ.VDKARSLD_DIA';
  SET sql_ocokd = 'COALESCE(MATRIZ.VDKARSLD_OCOKD';
  SET sql_sldiniun = 'COALESCE(MATRIZ.VDKARSLD_SLDINIUN,0)';
  SET sql_sldentun = 'COALESCE(MATRIZ.VDKARSLD_SLDENTUN,0)';
  SET sql_sldsaiun = 'COALESCE(MATRIZ.VDKARSLD_SLDSAIUN,0)';
  SET sql_csttotal = 'COALESCE(MATRIZ.VDKARSLD_CSTTOTAL,0)';
  SET sql_csttotalun = 'COALESCE(MATRIZ.VDKARSLD_CSTTOTALUN,0)';
      
  WHILE schema_filial_seg IS NOT NULL DO
    IF schema_filial_atual = NULL THEN
       SET schema_filial_atual = schema_filial_seg;
       SET num_emp_filial_atual = num_emp_filial_seg;
       SET num_emp_filial_consolida_atual = num_emp_filial_consolida_seg;
    END IF;
    
    SET tabela_filial = 'SD' || RIGHT(CAST(ano AS VARCHAR(4)), 2) || REPEAT('0', 2 - LENGTH(CAST(mes AS VARCHAR(2)))) || CAST(mes AS VARCHAR(2)) || num_emp_filial_atual;
    
    SET sql_cprd = sql_cprd || ',FILIAL' || num_emp_filial_atual || '.VDKARSLD_CPRD';
    SET sql_dia = sql_dia || ',FILIAL' || num_emp_filial_atual || '.VDKARSLD_DIA';
    SET sql_ocokd = sql_ocokd || ',FILIAL' || num_emp_filial_atual || '.VDKARSLD_OCOKD';
    SET sql_sldiniun = sql_sldiniun || '+COALESCE(FILIAL' || num_emp_filial_atual || '.VDKARSLD_SLDINIUN,0)';
    SET sql_sldentun = sql_sldentun || '+COALESCE(FILIAL' || num_emp_filial_atual || '.VDKARSLD_SLDENTUN,0)';
    SET sql_sldsaiun = sql_sldsaiun || '+COALESCE(FILIAL' || num_emp_filial_atual || '.VDKARSLD_SLDSAIUN,0)';
    SET sql_csttotal = sql_csttotal || '+COALESCE(FILIAL' || num_emp_filial_atual || '.VDKARSLD_CSTTOTAL,0)';
    SET sql_csttotalun = sql_csttotalun || '+COALESCE(FILIAL' || num_emp_filial_atual || '.VDKARSLD_CSTTOTALUN,0)';
           
    -- Implementar aqui
    
    SET schema_filial_atual = TRIM(LEFT(schema_filial_seg, LOCATE(',', schema_filial_seg, 1) - 1));
    SET schema_filial_seg = TRIM(RIGHT(schema_filial_seg, LENGTH(schema_filial_seg) - LOCATE(',', schema_filial_seg, 1)));
    SET num_emp_filial_atual = TRIM(LEFT(num_emp_filial_seg, LOCATE(',', num_emp_filial_seg, 1) - 1));
    SET num_emp_filial_seg = TRIM(RIGHT(num_emp_filial_seg, LENGTH(num_emp_filial_seg) - LOCATE(',', num_emp_filial_seg, 1)));  
    SET num_emp_filial_consolida_atual = TRIM(LEFT(num_emp_filial_consolida_seg, LOCATE(',', num_emp_filial_consolida_seg, 1) - 1));
    SET num_emp_filial_consolida_seg = TRIM(RIGHT(num_emp_filial_consolida_seg, LENGTH(num_emp_filial_consolida_seg) - LOCATE(',', num_emp_filial_consolida_seg, 1)));
     
    IF schema_filial_atual = NULL AND LENGTH(schema_filial_seg) = 16 THEN
       SET schema_filial_seg = NULL;
    END IF;
  END WHILE;
  
  SET MSG_ERRO = sql_create_view || sql_cprd || sql_dia || sql_ocokd; 
END;
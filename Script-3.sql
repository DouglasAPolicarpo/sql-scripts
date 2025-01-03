SELECT 
		LTRIM(RTRIM(ST9010.T9_CODBEM)) AS 'PLACA',
		LTRIM(RTRIM(ST9010.T9_NOME)) AS 'MODELO',
		LTRIM(RTRIM(CTD010.CTD_DESC03)) AS 'CLIENTE',
	LTRIM(RTRIM(CTD010.CTD_DESC05)) AS 'REGIONAL',
		LTRIM(RTRIM(CTD010.CTD_DESC02)) AS 'FILIAL',
	LTRIM(RTRIM(CTT010.CTT_DESC01)) AS 'CANAL',
		ST9010.T9_POSCONT AS 'HODÔMETRO',
		ST9010.T9_VARDIA AS 'KM DIÁRIO',
		LTRIM(RTRIM(ST9010.T9_CHASSI)) AS 'CHASSI',
	TRIM (SA1010.A1_NOME) AS 'COMODATO',
	TRIM (ST7010.T7_NOME) AS 'MARCA',
	TRIM (ST6010.T6_NOME) AS 'TIPO F',
	CASE
		--WHEN CTT010.CTT_DESC01 <> 'MOVIMENTACAO - FROTA' THEN ''
                    WHEN CTT010.CTT_DESC01 = 'MOVIMENTACAO - FROTA' THEN TRIM(ST9010.T9_SERIE)
		ELSE ''
	END AS 'SERIE',
        
        

		CASE
					WHEN ST6010.T6_NOME LIKE '% - ALUGADO%' THEN 'ALUGADA'
		WHEN ST6010.T6_NOME LIKE '% - COMODAT%' THEN 'COMODATO'
		--ALTERAÇÃO PARA SEGREGAR COMODATOS
		ELSE 'PROPRIA'
	END AS 'TIPO DE FROTA',
        
		CASE
		WHEN CTD010.CTD_DESC02 IS NOT NULL
                THEN 'BRASIL'
		ELSE 'BRASIL'
	END AS 'PAÍS'
FROM
		CKGMN8_143017_PR_PD.dbo.ST9010 ST9010
LEFT JOIN
		CKGMN8_143017_PR_PD.dbo.CTD010 CTD010 ON
	CTD010.D_E_L_E_T_ <> '*'
	AND CTD010.CTD_ITEM = ST9010.T9_ITEMCTA
LEFT JOIN
		CKGMN8_143017_PR_PD.dbo.CTT010 CTT010 ON
	CTT010.D_E_L_E_T_ <> '*'
	AND CTT010.CTT_CUSTO = ST9010.T9_CCUSTO
	AND CTT010.CTT_FILIAL = '01010001'
LEFT JOIN
		CKGMN8_143017_PR_PD.dbo.TQR010 TQR010 ON
	TQR010.D_E_L_E_T_ <> '*'
	AND TQR010.TQR_TIPMOD = ST9010.T9_TIPMOD
LEFT JOIN
		CKGMN8_143017_PR_PD.dbo.ST6010 ST6010 ON
	ST6010.D_E_L_E_T_ <> '*'
	AND ST6010.T6_CODFAMI = ST9010.T9_CODFAMI
LEFT JOIN

        CKGMN8_143017_PR_PD.dbo.SA1010 ON
	SA1010.A1_COD = ST9010.T9_CLIENTE
	-- PARA SABER COMODATO, ALTERADO POR TIAGO
	AND
        SA1010.D_E_L_E_T_ <> '*'
	AND
        SA1010.A1_LOJA <> '0000'
LEFT JOIN        

        CKGMN8_143017_PR_PD.dbo.ST7010 ON
	TRIM (ST7010.T7_FABRICA) = ST9010.T9_FABRICA
	-- PARA TRAZER MARCA, POR TIAGO
WHERE
		ST9010.D_E_L_E_T_ <> '*'
	AND ST9010.T9_CATBEM <> '3'
	AND ST9010.T9_SITBEM = 'A'
	AND CTD010.CTD_DESC03 != 'CERVEPAR'
	AND (ST9010.T9_CCUSTO LIKE '%08'
		OR ST9010.T9_CCUSTO LIKE '%09'
		OR ST9010.T9_CCUSTO LIKE '%10'
		OR ST9010.T9_CCUSTO LIKE '%16'
		OR ST9010.T9_CCUSTO LIKE '%01')
	AND T9_CODBEM = 'RQQ5J28'
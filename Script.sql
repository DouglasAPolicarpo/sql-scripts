select 
	cmta_login as LOGIN,
	cmta_nome as MOTORISTA,
	cvei_id as ID_VEICULO,
	cvei_placa as PLACA,
	lmac_numero as "NUMERO_MACRO",
	lmac_nome as NOME_MACRO,
	ttma_descricao as TIPO_MACRO,
	DATE(lmac_data_gps) as DATA_MARCACAO,
	TIME(lmac_data_gps) as HORA_MARCACAO,
	cvei_frota as CDD,
	cpnt_descricao as PONTO_REFERENCIA
from
	log_macro
inner join ctl_motorista_ativo on
	lmac_login = cmta_login
inner join cad_veiculo on
	lmac_cvei_id = cvei_id
inner join tab_tipo_macro on
	ttma_id = lmac_ttma_id
inner join ctl_veiculo_grupo on
	lmac_cvei_id = cvgr_cvei_id
inner join cad_ponto on
	lmac_cpnt_id = cpnt_id
where 
	lmac_data_gps between '2025-01-01 00:00:00' and '2025-01-31 23:59:59'
	and cvgr_cgru_id = 1
	and lmac_numero = 1 
	and cvei_placa like '%FAD%'
	-- GROUP BY 
	-- lmac_data_gps
order by 
	cmta_nome,
	lmac_data_gps
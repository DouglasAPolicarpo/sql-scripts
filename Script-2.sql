select
	*
from
	view_macro
where
	lmac_data_gps >= '2025-01-01 00:00:00'
	and lmac_nome like '%FATURAMENTO%'
	and cvgr_cgru_id = 1
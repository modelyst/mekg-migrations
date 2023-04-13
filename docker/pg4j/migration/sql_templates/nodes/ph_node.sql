select
	value as "pHID:ID(pH)",
	value as "value",
	'pH' as ":LABEL"
from
	generate_series(0, 14, 1) as value

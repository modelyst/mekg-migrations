select 
	pd.id as ":START_ID(ProcessDetail)",
	round((pd.parameters->>'solution_ph')::numeric,0) as ":END_ID(pH)",
	'PH' as ":TYPE"
from 
	"SCHEMA".process_detail pd
	where pd.parameters->'solution_ph' is not null

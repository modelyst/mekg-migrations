select 
    sample.id as ":START_ID(Sample)", 
    key as ":END_ID(Element)",
    sample.inkjet_composition->key as "atomic_fraction",
    'CONTAINS' as ":TYPE"
from
    "SCHEMA".sample, json_object_keys(inkjet_composition) as key 
where 
    (inkjet_composition->>key)::numeric>0 
select  
    distinct 
    json_object_keys(inkjet_composition) as "ElementID:ID(Element)",
    json_object_keys(inkjet_composition) as "symbol",
    'Element' as ":LABEL"
from 
    "SCHEMA".sample;
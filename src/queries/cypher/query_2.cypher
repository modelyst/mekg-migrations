match
    (s:Sample)<--(sp:SampleProcess)-->(p:Process)-->(pdet:ProcessDetail)
where
    s.inkjet_composition is not null
    and pdet.type = 'anneal'
    and apoc.convert.fromJsonMap(pdet.parameters).`max_temperature` = 350
return
    count(distinct s)
match
    (s1:Sample)--(sp1:SampleProcess)-[:NEXT]->(sp2:SampleProcess)-[:NEXT]->(sp3:SampleProcess)-[:NEXT]->(sp4:SampleProcess),
    (sp1)-->(p1:Process)-->(pdet1:ProcessDetail),
    (sp2)-->(p2:Process)-->(pdet2:ProcessDetail),
    (sp3)-->(p3:Process)-->(pdet3:ProcessDetail),
    (sp4)-->(p4:Process)-->(pdet4:ProcessDetail)
where
    pdet1.type = 'print'
    and pdet1.technique = 'INKJET'
    and pdet2.type = 'anneal'
    and apoc.convert.fromJsonMap(pdet2.parameters).`max_temperature` = 350
    and pdet3.type = 'eche'
    and pdet3.technique starts with 'CP'
    and apoc.convert.fromJsonMap(pdet3.parameters).`acquisition_time` >= 7
    and apoc.convert.fromJsonMap(pdet3.parameters).`acquisition_time` <= 15
    and apoc.convert.fromJsonMap(pdet3.parameters).`current_abs` = 0.00003
    and pdet4.type = 'eche'
    and pdet4.technique starts with 'CP'
    and apoc.convert.fromJsonMap(pdet4.parameters).`acquisition_time` >= 7
    and apoc.convert.fromJsonMap(pdet4.parameters).`acquisition_time` <= 15
    and apoc.convert.fromJsonMap(pdet4.parameters).`current_abs` = 0.0001
return
    count(distinct s1.sample)
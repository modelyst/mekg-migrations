MATCH
path=(sp1:SampleProcess)-[:NEXT]->(sp2)-[:NEXT]->(sp3)-[:NEXT]->(sp4)-[:NEXT]->(sp5),
(a1:Analysis)<--(pda1:ProcessData)<--(sp1)-->(p1:Process)-->(pd1:ProcessDetail),
(a2:Analysis)<--(pda2:ProcessData)<--(sp2)-->(p2:Process)-->(pd2:ProcessDetail),
(a3:Analysis)<--(pda3:ProcessData)<--(sp3)-->(p3:Process)-->(pd3:ProcessDetail),
(a4:Analysis)<--(pda4:ProcessData)<--(sp4)-->(p4:Process)-->(pd4:ProcessDetail),
(a5:Analysis)<--(pda5:ProcessData)<--(sp5)-->(p5:Process)-->(pd5:ProcessDetail)
WHERE
pd1.technique STARTS
WITH 'CA'
 AND pd2.technique STARTS
WITH 'CA'
 AND pd3.technique STARTS
WITH 'CA'
 AND pd4.technique STARTS
WITH 'CA'
 AND pd5.technique STARTS
WITH 'CV'
 AND a5.name = 'CV_FOMS_standard'
 AND apoc.convert.fromJsonMap(a1.output)['I.A_ave'] > 1e-7
 AND apoc.convert.fromJsonMap(a2.output)['I.A_ave'] > 1e-8
 AND apoc.convert.fromJsonMap(a3.output)['I.A_ave'] > 1e-9
 AND apoc.convert.fromJsonMap(a4.output)['I.A_ave'] > 1e-10
 AND apoc.convert.fromJsonMap(a5.output)['I.A_max'] > 1e-6
 AND apoc.convert.fromJsonMap(pd1.parameters)['electrolyte'] CONTAINS 'NaOH'
 AND apoc.convert.fromJsonMap(pd2.parameters)['electrolyte'] CONTAINS 'NaOH'
 AND apoc.convert.fromJsonMap(pd3.parameters)['electrolyte'] CONTAINS 'NaOH'
 AND apoc.convert.fromJsonMap(pd4.parameters)['electrolyte'] CONTAINS 'NaOH'
 AND apoc.convert.fromJsonMap(pd5.parameters)['electrolyte'] CONTAINS 'NaOH'
RETURN count(path)

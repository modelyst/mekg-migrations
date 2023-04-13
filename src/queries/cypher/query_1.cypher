match
    path=(s:Sample)<--(sp:SampleProcess)-->(p:Process)-->(pdet:ProcessDetail),
    (sp)-->(pd:ProcessData),
    (s)-->(bi:Element),
    (s)-->(v:Element)
where
    bi.symbol = 'Bi'
    and v.symbol = 'V'
    and pdet.type = 'eche'
return
    count(path)
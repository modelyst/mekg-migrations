select
    first_event.val as ":START_ID(SampleProcess)",
    second_event.val as ":END_ID(SampleProcess)",
    'NEXT' as ":TYPE"
from
    (
    select
        sample_id,
        array_agg(sp.id order by p."timestamp", p."ordering") as ordered_sps
    from
        "SCHEMA".sample_process sp
    join "SCHEMA".process p on
        p.id = sp.process_id
    group by
        sample_id
    having
        count(1)>1) as X,
    unnest(ordered_sps) with ordinality first_event (val,
    ord)
join unnest(ordered_sps[2:]) with ordinality second_event (val,
    ord) on
    first_event.ord = second_event.ord;


-- Ergodis evidence catalog for DuckDB (C1033).
--
-- Loads the private evidence tree as SQL views so that cross-task queries -- paired
-- A/B statistics, counter comparisons, campaign ledger timelines -- are one query
-- instead of a per-task Python script.  Read-only: nothing here writes to the tree.
--
-- Usage:
--   analysis/ergodis-sql                       -- interactive shell with these views
--   analysis/ergodis-sql -c "select * from ab_summary"
--
-- The catalog assumes the working directory is the ergodis-private root; the
-- wrapper script guarantees that.

-- ---------------------------------------------------------------------------
-- Raw benchmark rows.  Every interleaved A/B evidence file in evidence/ shares a
-- (round, backend, counters) shape; some also carry `mode` and `order` keys.
-- all_varchar keeps heterogeneous columns loadable; typed views cast below.
-- ---------------------------------------------------------------------------
create or replace view bench_raw as
select
    regexp_replace(filename, '.*/', '') as source_file,
    *
from read_csv(
    'evidence/*.tsv',
    delim = '\t',
    header = true,
    union_by_name = true,
    filename = true,
    all_varchar = true
);

-- Typed projection with a single canonical wall-time metric per row.  Files
-- report time as elapsed_ns, wall_seconds, or task_clock_ms; all three become
-- seconds so one comparison view covers the whole tree.
create or replace view bench as
select
    source_file,
    try_cast(round as bigint)                    as round,
    backend,
    coalesce(mode, '')                           as mode,
    coalesce("order", '')                        as ord,
    coalesce(threads, '')                        as threads,
    coalesce(
        try_cast(elapsed_ns as double) / 1e9,
        try_cast(wall_seconds as double),
        try_cast(task_clock_ms as double) / 1e3
    )                                            as seconds,
    try_cast(cycles as double)                   as cycles,
    try_cast(instructions as double)             as instructions,
    try_cast(branches as double)                 as branches,
    try_cast(branch_misses as double)            as branch_misses,
    try_cast(peak_rss_kib as double)             as peak_rss_kib
from bench_raw
where backend is not null;

-- The two arms of each interleaved comparison.
--
-- `round` is the global interleave slot, not a pair index: the arms alternate,
-- so within one comparison arm A holds the odd slots and arm B the even ones
-- (and `order` names which arm led that phase).  Pairs are therefore formed
-- positionally -- each arm's k-th observation against the other arm's k-th --
-- which is the comparison the interleaved protocol was designed to support.
-- An arm with one extra trailing observation loses it to the inner join.
--
-- Arms are ordered by name so the ratio is reproducible without a per-file rule;
-- `arm_a` and `arm_b` are always reported alongside the number.
create or replace view ab_slots as
select *,
       row_number() over (
           partition by source_file, mode, ord, threads, backend
           order by round
       ) as slot
from bench;

create or replace view ab_pairs as
with arms as (
    select source_file, mode, ord, threads,
           min(backend) as arm_a,
           max(backend) as arm_b
    from bench
    group by 1, 2, 3, 4
    having count(distinct backend) = 2
)
select
    a.source_file, a.mode, a.ord, a.threads,
    arms.arm_a, arms.arm_b, a.slot,
    a.round         as a_round,        b.round         as b_round,
    a.seconds       as a_seconds,      b.seconds       as b_seconds,
    a.cycles        as a_cycles,       b.cycles        as b_cycles,
    a.instructions  as a_instructions, b.instructions  as b_instructions,
    b.seconds / nullif(a.seconds, 0)           as time_ratio,
    b.cycles / nullif(a.cycles, 0)             as cycle_ratio,
    b.instructions / nullif(a.instructions, 0) as instruction_ratio
from arms
join ab_slots a
  on a.source_file = arms.source_file and a.mode = arms.mode
 and a.ord = arms.ord and a.threads = arms.threads and a.backend = arms.arm_a
join ab_slots b
  on b.source_file = arms.source_file and b.mode = arms.mode
 and b.ord = arms.ord and b.threads = arms.threads and b.backend = arms.arm_b
 and b.slot = a.slot;

-- Geometric-mean ratio and paired t on log ratios, per comparison.  A ratio
-- below one means arm_b is faster; `t` is the paired statistic on ln(ratio),
-- null when the design has a single round.
create or replace view ab_summary as
select
    source_file, mode, ord, threads, arm_a, arm_b,
    count(*)                                                   as rounds,
    exp(avg(ln(time_ratio)))                                   as time_geomean,
    exp(avg(ln(cycle_ratio)))                                  as cycle_geomean,
    exp(avg(ln(instruction_ratio)))                            as instruction_geomean,
    avg(ln(time_ratio))
        / nullif(stddev_samp(ln(time_ratio)) / sqrt(count(*)), 0) as t
from ab_pairs
where time_ratio > 0
group by 1, 2, 3, 4, 5, 6
order by time_geomean;

-- ---------------------------------------------------------------------------
-- Campaign feature batches: the labelled integer feature vectors that campaigns
-- and evolve runs search over (schema ergodis-campaign-data-v0).  The header
-- line and the data lines have different shapes, so they are split by key.
-- ---------------------------------------------------------------------------
create or replace view campaign_batch_lines as
select regexp_replace(filename, '.*/', '') as source_file, json
from read_json_objects('examples/data/campaign-*.jsonl',
                       format = 'newline_delimited', filename = true);

create or replace view campaign_batch_header as
select source_file,
       json_extract_string(json, '$.schema')       as schema,
       json_extract_string(json, '$.presentation') as presentation,
       json_extract_string(json, '$.problem')      as problem,
       json_extract(json, '$.fields')              as fields,
       try_cast(json_extract_string(json, '$.rows') as bigint) as declared_rows
from campaign_batch_lines
where json_extract(json, '$.fields') is not null;

create or replace view campaign_batch_row as
select source_file,
       json_extract_string(json, '$.id')       as id,
       try_cast(json_extract_string(json, '$.weight') as double)   as weight,
       try_cast(json_extract_string(json, '$.expected') as boolean) as expected,
       json_extract(json, '$.values')          as values
from campaign_batch_lines
where json_extract_string(json, '$.id') is not null;

-- ---------------------------------------------------------------------------
-- Exact-distance and other certificates.  Each file is one JSON document and
-- the documents do not share a schema, so they are kept as JSON values rather
-- than forced into one relational shape; project the fields a query needs with
-- json_extract_string.  `certificate_index` pulls out the fields the
-- exact-distance certificates agree on.
-- ---------------------------------------------------------------------------
create or replace view certificates as
select regexp_replace(filename, '.*/', '') as source_file, json
from read_json_objects('evidence/*.json', filename = true);

create or replace view certificate_index as
select source_file,
       json_extract_string(json, '$.candidate')             as candidate,
       json_extract_string(json, '$.certified_parameters')  as parameters,
       try_cast(json_extract_string(json, '$.certified_distance') as bigint)
                                                            as certified_distance,
       json_extract_string(json, '$.conclusion')            as conclusion,
       json_extract_string(json, '$.boundary')              as boundary
from certificates
where json_extract_string(json, '$.certified_parameters') is not null;

create or replace view native_scale as
select regexp_replace(filename, '.*/', '') as source_file, *
from read_json('evidence/*.jsonl', format = 'newline_delimited',
               union_by_name = true, filename = true, ignore_errors = true);

-- ---------------------------------------------------------------------------
-- Live campaign run directories.  A run directory holds manifest.json plus an
-- append-only ledger.jsonl of {seq, epoch, kind, synopsis, plan} events.  Point
-- ERGODIS_RUN_DIR at one and the timeline is queryable while the run is live,
-- because the ledger is flushed on every append.
-- ---------------------------------------------------------------------------
create or replace macro run_ledger(dir) as table
    select * from read_json(dir || '/ledger.jsonl',
                            format = 'newline_delimited', union_by_name = true);

create or replace macro run_manifest(dir) as table
    select * from read_json(dir || '/manifest.json', union_by_name = true);

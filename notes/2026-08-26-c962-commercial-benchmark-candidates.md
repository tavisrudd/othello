# C962 commercial benchmark candidates

**Date:** 2026-08-26

**Lane:** `complete-ports`

**Scope:** Identify storage and LDPC-adjacent workloads where ERGO-comp's
mathematical compilation, rather than Rust micro-optimization alone, can change
the feasible scale or operational latency.

## Selection rule

A commercial-facing benchmark is admissible only when the published system or
standard supplies the code/topology/problem data needed for an honest model.
The benchmark report must classify the source of advantage as mathematical,
implementation, or mixed. A large synthetic replication of a small code is not
enough by itself.

## Ranked candidates

| rank | application                                      | value driver                         | ERGO fit | expected source of win |
| ---: | :----------------------------------------------- | :----------------------------------- | :------- | :--------------------- |
|    1 | recursive Ceph LRC repair across racks           | degraded-read and rebuild latency    | direct   | mathematical           |
|    2 | Azure LRC multi-extent repair planning           | repair I/O, bandwidth, tail latency  | direct   | mixed                  |
|    3 | RepairBoost-style full-node repair scheduling    | rebuild throughput under link limits | partial  | mixed                  |
|    4 | QC-LDPC trapping/stopping-set design loops       | error floor and design turnaround    | research | mathematical           |
|    5 | GPU-cluster checkpoint parity recovery           | training restart time and lost work  | direct   | mathematical           |
|    6 | wide-stripe vector-code coefficient search       | low-overhead repair throughput       | research | mathematical           |

### 1. Recursive Ceph LRC

Ceph's public LRC plugin exposes recursive coding layers and explicitly permits
locality at host and rack failure domains. That is the closest deployed-system
analogue of the paper's concatenation tower. The benchmark should ingest a
real low-level Ceph `mapping`/`layers` profile, derive the labelled local costs,
and compare:

- ERGO-comp's associative min--sum composition;
- direct CP-SAT over all leaf coefficients; and
- CP-SAT given the same local labelled tables but forced to flatten the tower.

The third control isolates the theorem: both solvers receive identical local
preprocessing, but only ERGO-comp retains the closed compositional state. Scale
should increase the number of recursive rack/datacenter levels, not duplicate
independent stripes. Report exact helpers, cross-rack cost, witness path, time,
and RSS.

Primary source: Ceph, *Locally repairable erasure code plugin*, especially the
low-level recursive `layers`, `crush-locality`, and failure-domain interface:
<https://docs.ceph.com/en/latest/rados/operations/erasure-code-lrc/>.

### 2. Azure LRC multi-extent repair

The Windows Azure Storage LRC paper gives a production-motivated code and makes
the operational stakes explicit: coding/decoding must be scheduled alongside
critical rereplication while keeping pace with incoming data, and repair-read
I/O and latency are central. A fair benchmark would derive every bounded exact
recovery support for the published LRC, then solve batches of simultaneous
degraded reads under node/rack/link capacities.

The local recovery compilation is mathematical; the batch scheduler comparison
is mixed. The instance needs trace or distribution data from the source or a
separately cited workload study before it can support a production-scale claim.

Primary source: Huang et al., *Erasure Coding in Windows Azure Storage*, USENIX
ATC 2012: <https://www.microsoft.com/en-us/research/publication/erasure-coding-in-windows-azure-storage/>.

### 3. Full-node repair scheduling

RepairBoost models a single-chunk repair as a DAG and jointly balances upload,
download, and transmission scheduling. ERGO-comp could improve the front end by
generating exact alternative linear recovery systems rather than accepting a
fixed repair DAG, then pass the resulting supports and coefficient costs to a
capacity-aware scheduler. This is commercially meaningful, but exact comparison
requires adding time-indexed/link-direction constraints not present in the
current public scheduler.

Primary source: Lin et al., *Boosting Full-Node Repair in Erasure-Coded
Storage*, USENIX ATC 2021:
<https://www.usenix.org/conference/atc21/presentation/lin>.

### 4. QC-LDPC trapping and stopping sets

For QC-LDPC design, repeated exact searches for small trapping or stopping sets
drive error-floor reduction. The commercial connection is strongest for
standardized QC-LDPC families such as 5G NR. ERGO-comp already has the relevant
low-level ingredients--orbit quotienting, conserved syndromes, generated-span
states, and exact witnesses--but not the trapping-set objective or Tanner-graph
front end. This is therefore a high-upside research extension, not a current
benchmark claim.

The mathematical headline would be quotienting the lifted Tanner graph by its
cyclic action before exact search. The fair baseline is a published trapping-set
enumerator plus CP-SAT on the lifted graph; low-level Rust speed is secondary.

Primary sources:

- Karimi and Banihashemi, *Construction of QC-LDPC Codes with Low Error Floor
  by Efficient Systematic Search and Elimination of Trapping Sets*:
  <https://arxiv.org/abs/1902.07332>;
- 3GPP TS 38.212, *NR; Multiplexing and channel coding*:
  <https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=3214>.

### 5. GPU-cluster checkpoint parity recovery

REFT protects hybrid-parallel LLM checkpoints with dynamically selected
in-memory mechanisms including asynchronous erasure coding. Its topology has
exactly the heterogeneous resources relevant to recovery planning: device/host
copies, intra-node redundancy, inter-node checkpoint protection, and DP/PP/TP
sharding groups. It reports evaluation at 512 GPUs and shows in-memory loading
substantially faster than NFS recovery.

The ERGO-comp front end should compile the actual checkpoint generator matrix,
price helper shards by PCIe, same-rack, and cross-rack transfer, and schedule all
lost shards jointly. Hierarchical labelled composition applies when checkpoint
protection follows the nested DP/PP/TP grouping. A generic MDS/AEC model is a
valid capability demonstration, but a paper-specific benchmark requires the
exact AEC parameters and placement from the source artifact.

Primary source: Wang et al., *Fault-Tolerant Hybrid-Parallel Training at Scale
with Reliable and Efficient In-memory Checkpointing*, arXiv:2310.12670v4:
<https://arxiv.org/abs/2310.12670>.

### 6. Wide-stripe vector codes

Wide-stripe storage codes make coefficient-search and repair scheduling
important at roughly hundred-chunk stripes. This is valuable but lies beyond
the paper's one-base-field-symbol-per-helper model: vector download,
subpacketization, and streamed repair throughput must be represented before a
comparison is honest. Treat it as a later front end, not as evidence for the
current scalar-support engine.

Primary source: WiseCode, USENIX OSDI 2026 technical-session description:
<https://www.usenix.org/conference/osdi26/technical-sessions>.

## Recommendation

Implement the recursive Ceph LRC benchmark first. It is deployed-system-facing,
already within the mathematical model, and capable of isolating the min--sum
composition theorem with an equivalently preprocessed CP-SAT control. Follow it
with REFT-style GPU checkpoint recovery, whose commercial value and linear
erasure-coding fit are unusually direct. Keep the Jin--Fu Hamming-family row as
a mixed high-scale exact-solver result; do not use it as the main evidence that
the mathematics wins.

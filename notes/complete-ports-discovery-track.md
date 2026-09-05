# Complete-ports discovery track

Append-only companion for incidental observations and musings encountered in
the `complete-ports` lane.  Planned theorem, formalization, manuscript, and
verification work belongs in the task reports and control ledgers instead.

No incidental entry was found during C671.

2026-09-04, C1016, while profiling the plain spin-shard tabu step: on this host
and toolchain, the fastest short `i16` inner product is the one that emits no
vector instruction. Eight independent scalar accumulator lanes beat the
autovectorized loop by 1.10x in cycles at length 87, because widening `i16` to
`i32` on the baseline target spends a whole vector load per four elements
through `punpcklwd`. `-C target-cpu=native` then removes 27% of instructions but
only 7% of cycles. This is a general fact about short widening reductions in
Ergodis hot loops, not about supplementary difference sets; it is a candidate
line for the shared performance playbook, and the measurement is in
`2026-09-04-c1016-full-neighbourhood-tabu-spin-shard.md`.


2026-09-04, C1063, while adding evidence rows to
`ergodis-private/benchmarks/tiger-blossom/SHA256SUMS`: that manifest mixes two path conventions.
Thirty of its rows name a bare basename and two, added under C1061 probe 28g, name a path relative
to the repository root, so `sha256sum -c` fails on those two from inside the directory and would
fail on all the others from the root. Nothing is wrong with the recorded hashes; the manifest simply
cannot be checked in one command from either place. Any evidence manifest that accumulates rows
across tasks wants one stated convention and a check that runs in the reproducibility instructions,
which is a general point about our evidence bundles rather than about TigerBlossom.


2026-09-04, C1064, while comparing the phenomenological surface graph against the stim model of the
same code: `local_commit_predecoder::surface_graph` builds one stabilizer sector, not two. At
distance nine with a nine-round window it has 360 detectors where stim's rotated memory-Z model has
720, and the difference is exactly the X-type detectors, which stim's circuit produces and the
builder does not. For a memory experiment that is defensible — the omitted sector cannot flip the
reported class — but it means every certified-predecoder and margin-radius result on the surface
family is a statement about a single-sector graph of half the size, with half the detector density
and none of the second sector's defects competing for the workspace. Nothing measured here is wrong
because of it; it is a scope fact about the object those probes decode, and it is worth stating
wherever a surface-family number is carried over to a real device.


2026-09-05, C1016, while deciding whether a congruence constrains the q174 deviation: the obvious
tool for that question, an integer Hermite normal form of the difference lattice, does not survive
the dimension. Even from generators whose every coordinate is at most six, in 73 or 87 dimensions
the basis entries grow geometrically under both extended-gcd combination and Euclidean row
reduction, and the reduction overflows a 128-bit integer at rank eleven. The right tool is much
cheaper and strictly more complete for the question asked: a congruence with a modulus divisible by
the prime p exists exactly when the generators fail to span the lattice modulo p, so a rank over
the field of p elements decides it one prime at a time in machine integers, with no growth at all
and no lattice basis. That reframing turned a computation that could not finish into one that
sweeps every prime below a million in thirty-four seconds. It is a general point about congruence
hunts in this workspace rather than about the order-six fibre: ask for ranks over prime fields, not
for a Hermite basis.

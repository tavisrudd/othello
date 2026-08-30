# C80 ancestral-secant Hall probe

**Lane:** `cap`
**Task:** C80
**Date:** 2026-08-30
**Status:** diagnostic edge proposal passes the first four frozen witnesses;
charge-transport soundness remains open

## Result

The first projectively natural global-charge edge tested is:

> A genuinely new defect `z` is adjacent to a consumed old defect label `ell`
> when the line `z ell` contains a point selected before the complete
> opponent/reply exchange.

Call this the **ancestral-secant edge**.  It uses only bounded projective
incidence data and does not refer to minimax value, a strategy table, or a
fitted scalar feature.

It passes the frozen q11 one-to-many falsifier and all three retained q23
replacement types.

| case | new defects | consumed labels | ancestral-secant degrees | Hall result |
|---|---:|---:|---|---|
| q11 one-to-many | 2 | 7 | `3,2` | saturated |
| q23 type I | 1 | 34 | `15` | saturated |
| q23 type II | 1 | 23 | `10` | saturated |
| q23 type III | 1 | 26 | `14` | saturated |

The q11 matching is the substantive first gate:

```text
new (0,5) -> old (4,10), ancestral carrier (10,1)
new (6,5) -> old (3,7),  ancestral carrier (5,2)
```

It assigns distinct old labels without using the causal reply `(7,10)` that
was the shared old certificate for both new fibres.  Thus the edge proposal
escapes exactly the one-to-many collision that killed causal one-label
transport.

The three q23 cases establish broad local coverage but each has only one new
defect, so they test nonempty degree rather than a nontrivial Hall subset.
They cannot establish global rematching by themselves.

## Tool and certificate

The private Rust `HallWorkspace` consumes caller-owned CSR edges and performs
no allocation after sizing.  It emits either a saturating matching or the
alternating-reachable Hall-deficient set.  Its result agrees with brute force
on every one of the 65,536 bipartite `4 x 4` graphs.  The `hall-certify` binary
serializes certificates; a separate Python verifier checks edge membership,
injectivity, or exact deficient neighborhoods.

Evidence is under `ergodis-private/evidence/`:

- `c80-q11-ancestral-secant-hall-{graph,manifest,certificate}.json`;
- `c80-q23-ancestral-secant-manifest.json`;
- `c80-q23-ancestral-secant-type_{i,ii,iii}-{graph,certificate}.json`.

Replay the source falsifier and matching certificate with:

```bash
python3 rust/scripts/c80_causal_one_to_many.py --check
PYTHONPATH=ergodis-private/python python3 \
  ergodis-private/python/verify_hall_certificate.py \
  --graph ergodis-private/evidence/c80-q11-ancestral-secant-hall-graph.json \
  --certificate ergodis-private/evidence/c80-q11-ancestral-secant-hall-certificate.json
```

The q11 graph, manifest, and certificate SHA-256 values are respectively:

```text
16fc9151242b959952d8cd5698d52120bb46b268047efb0638df2f03201a8960
e925b55682c885ddb6fc6579e02b83ae8af399fe925a6ea1a4fa97dcfd2f8000
23d3830e4b0b0f47c5407462e4580be60d8e1c5101baa9ce0ae5cc10f53e4e1b
```

## Exact boundary

This does not prove that an ancestral-secant edge transports charge soundly.
At present it is a geometrically natural relation with exact finite coverage.
Before it can enter a survivor proof, one needs a local lemma explaining why a
selected carrier on `z ell` lets old label `ell` absorb the new fibre `z` while
preserving the hereditary boundary or the chosen support/Omega descent.

The next falsification gates are:

1. attach the edge to the full deterministic q11/q13 exchange sidecars;
2. emit the first zero-degree new defect or Hall-deficient subset;
3. profile any obstruction by carrier multiplicity, creator half-move, defect
   rank, and deletion mechanism;
4. if no obstruction appears, prove the bounded local transport packet and
   then test opponent completeness.

Do not weaken the edge by adding arbitrary old labels merely to repair a
failed graph.  Any enrichment must have its own projective transport lemma.

## Mystery ledger and EJ/TT closeout

- **Settled:** the q11 one-to-many collision does not kill global incidence
  transport; two distinct ancestral secants route around the shared causal
  reply.
- **Settled engineering:** exact Hall search and replay are no longer the
  bottleneck.
- **Surprising:** the same extremely weak incidence motif has large degree on
  all three q23 replacement types (`15,10,14`).
- **Open:** whether those many edges are genuinely sound charge transports or
  merely abundant incidences.
- **Open:** whether a multi-defect exchange in the retained corpus yields a
  Hall-deficient subset despite positive individual degrees.

**EJ.** If soundness holds, the carrier point gives a bounded packet label for
every edge.  Matching certificates can then be quotient by carrier-line orbit,
potentially reducing a growing matching to a finite catalogue of local
transport motifs plus a uniform Hall count.

**TT.** High degree is not the theorem.  The next move must attack the weakest
edge semantically: derive the exact before/after certificate relation along one
ancestral secant, and simultaneously search specifically for overlapping
neighborhoods in multi-defect exchanges.  Average surplus can hide the only
Hall obstruction that matters.

Vibe: genuinely promising first edge, but one local soundness lemma separates
it from being mathematics rather than a well-covered graph heuristic.

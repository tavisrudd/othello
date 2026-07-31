# C725 — terminal passant-arc orbit-DAG certificates

**Lane:** `clebsch`

**Date:** 2026-07-31

**Verdict:** complete.  The terminal $q=13,17,19$ searches are now
proof-carrying root-edge orbit DAGs.  Every transition orbit, terminal
obstruction, coverage identity, and sharp six-point witness is checked
directly; a separately specified ordered backtracking program reproduces all
labelled level counts without using projective canonical keys.

## Finite theorem

Fix the conic $XZ=Y^2$ and let vertices be its $q^2$ off-conic points.
Two vertices are adjacent when their join is passant.  A node of the DAG is a
pairwise-passant set with no collinear triple, rooted at one passant edge and
canonical under that edge's setwise stabilizer.

The exact census is:

| $q$ | passant edges | edge orbits | rooted DAG nodes | labelled six-arcs | projective six-arc orbits |
|---:|---:|---:|---:|---:|---:|
| 13 | 7,098 | 10 | 604 | 546 | 2 |
| 17 | 20,808 | 13 | 4,442 | 50,184 | 22 |
| 19 | 32,490 | 15 | 11,260 | 395,124 | 94 |

There is no node of size seven.  The two $q=13$ terminal orbits have
orbit-stabilizer pairs $(364,6)$ and $(182,12)$.  Their point-type counts
are respectively $3+3$ and $0+6$, and their passant-edge-orbit
fingerprints differ.  Pair fingerprints distinguish both q13 classes and all
22 q17 classes.  At q19 they distinguish 92 of 94 classes, reproducing the
two doubled fibres whose triple fingerprints were already separated in C611.

For a fixed root $B$, let $m_{B,k}$ be the sum of the root-stabilizer orbit
masses at level $k$.  The verifier partitions every valid extension under
the node stabilizer and checks

\[
 \sum_{A\in D_{B,k}} |\operatorname{Orb}_B(A)|\,e(A)
   =(k-1)m_{B,k+1}.
\]

Globally, if $M_k$ is the number of labelled $k$-arcs, it checks the
coverage identity

\[
 \sum_B |\operatorname{Orb}(B)|m_{B,k}=\binom{k}{2}M_k.
\]

Thus the complete edge-orbit partition and the local transition partitions
inductively cover every labelled arc.  Every terminal node stores one byte per
off-conic point: the byte names either a selected point, a selected vertex
joined nonpassantly to that point, or a selected pair collinear with it.  This
is an explicit obstruction assignment, not a terminal flag.

The labelled arc counts in sizes (2,ldots,6) are

```text
q=13:     7,098     71,526      123,123       15,288      546
q=17:    20,808    390,048    1,555,296      913,104   50,184
q=19:    32,490    782,325    4,301,220    3,962,412  395,124
```

The independent replay also exposes maximal arcs below the maximum: terminal
labelled counts in sizes (4,5,6) are (65,793,12,012,546) at q13,
(54,468,668,304,50,184) at q17, and
(56,430,2,145,708,395,124) at q19.

## Frozen Paper I boundary

The final claim-to-proof-mode ledger is
`verification/c725_finite_boundary_manifest.json`.

- The q13 weight-eight exclusion is structural: the five-row unique-closure
  lemma is load-bearing and the tangent-code execution is corroboration.
- The two q13 weight-ten profiles remain finite XOR-disjointness certificates
  with an independent full-fibre dynamic-programming replay.
- The q11 census, numerical gap, low-degree rigidity, and q11/q13 seven-arc
  leaves use C724's orbit masses, concurrence formulas, local minors, and
  normalized-domain audit.  The conic-distance gap retains exhaustive conic
  enumeration as its exact trust boundary.
- The q13/q17/q19 maximum-six assertion uses the new root-edge orbit DAG, the
  independent ordered replay, and the older cross-language C++/discriminant
  replay.  The q17/q19 22/94 coherent classification remains the C611
  certificate.

No claim in this ledger is an all-$q$ exterior-set theorem.  The failed
first-order LP remains excluded: its exact value is the smaller residual
passant-pencil size and already exceeds four for odd $q\ge13$.

## Replay and trust boundary

From `papers/clebsch-rigidity/` with Python 3.13.12:

```sh
python3 verification/c725_terminal_orbit_dag.py
python3 verification/c725_terminal_orbit_dag.py --check
python3 verification/c725_terminal_orbit_dag_replay.py --check
python3 verification/conic_filling_verify.py
```

The first command checks the tracked DAG directly in about fourteen seconds.
The second regenerates all 16,306 rooted quotient states and requires the
deterministic gzip bytes to agree.  The third performs increasing-index
backtracking over every labelled arc using discriminant passancy and bitset
line blockers; it computes no group action, stabilizer, or canonical key.  The
fourth is the unchanged C++ primary search plus the older discriminant-based
Python replay.  All arithmetic is exact over the three prime fields and no
randomness is used.

The gzip certificate expands to canonical JSON.  Compression changes only its
storage: all node representatives, transition orbits, terminal blocker bytes,
global terminal records, and mass identities remain in the proof object.

## Evidence manifest

| file | bytes | SHA-256 |
|---|---:|---|
| `c725_terminal_orbit_dag.py` | 25,994 | `a61ac489237ad5fc9571a7e435c401ff6d018584bf9ecc2d9943e4bae6cbf063` |
| `c725_terminal_orbit_dag.json.gz` | 1,118,752 | `8e18a337ed6a0c60633e8c3df901201fa08d1e04b1ad6d4d7e3aef04a6a111bd` |
| `c725_terminal_orbit_dag_replay.py` | 6,613 | `070562160723ab83fe3a7a40b03b65622af3969329581d7d1ac9586303266afb` |
| `c725_terminal_orbit_dag_replay.json` | 2,162 | `ba9d31b9b428cc8d2efc171293f4c9bf1d3d607371dabccc6049cba5f6bdbdc6` |
| `c725_finite_boundary_manifest.json` | 3,759 | `48d022da2cc6683b400dde7b0026816495c255a864ef1293d383334f67b3a89b` |

The adjacent `c725_terminal_orbit_dag.sha256` records the same hashes.

## `ej` + `tt` closeout

The free upgrade was to quotient the maximum level globally after constructing
the root DAGs and attach point-type and edge-orbit fingerprints to every
terminal class.  This turns q13's formerly aggregate maximum-six result into a
two-row classification and independently recovers the q17/q19 22/94 counts.
It also locates the exact first structural loss: pair data are complete through
q17 but acquire two doubled fibres at q19, where C611's triple data are needed.

The Tao-style check asks whether the root DAG suggests a uniform theorem.  It
does not.  The rapid growth in labelled four- and five-arcs, the many maximal
arcs below size six, and the q19 pair collisions show that the finite ternary
incidence layer remains active.  The certificate is the honest endpoint.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| The q13 maximum-six layer has exactly two orbits of masses 364 and 182. | partially settled | Point types and edge-orbit fingerprints distinguish them; no structural argument explains why these are the only two.  C726 needs only the certified classification. |
| Pair fingerprints distinguish 2/2 q13 and 22/22 q17 classes but only 92/94 q19 classes. | computational distinction settled | C611's triple fingerprints separate both doubled fibres.  A uniform reason for the two collisions is outside C725. |
| Many four- and five-arcs are already maximal. | settled as certificate content | Explicit blocker assignments certify every terminal node.  Their distribution is not used in Paper I and needs no successor. |
| A uniform maximum-six theorem might replace the finite boundary. | open outside scope | Pair coherence and the exact first-order LP are insufficient; no ternary all-$q$ mechanism was proved. |

No other genuine mystery remains within the three-field terminal certificate.

## Handoff

C726 may treat the final finite-boundary manifest, the 10/13/15 root-edge
partitions, the complete transition DAGs, the 2/22/94 terminal orbit ledgers,
the blocker assignments, and the ordered replay as frozen proof objects.
C726 alone owns manuscript integration, trust-class wording, standalone sync,
and the complete release gate.

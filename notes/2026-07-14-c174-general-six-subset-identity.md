# C174 — the six-arc chord–extension identity

**Date**: 2026-07-14
**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Status**: REPORTED. The queued conic identity holds in the stronger setting of every six-arc in
every finite projective plane; a tracked multi-field checker freezes the finite tables.

## The free upgrade

The conic hypothesis, Desarguesian coordinates, and characteristic restriction are all unnecessary.

> **Proposition (six-arc chord–extension identity).** Let `Π` be a finite projective plane of order
> `q` and let `H` be a six-arc. Let `L(H)` be its fifteen chord lines. For a point `P`, put
> \[
> m_H(P)=|\{\ell\in L(H):P\in\ell\}|,
> \qquad
> U(H)=\{P:m_H(P)=0\},
> \]
> and let
> \[
> t(H)=\sum_{P\in\Pi}\binom{m_H(P)}3.
> \]
> Equivalently, `t(H)` counts unordered triples of distinct chords concurrent at a point, with
> multiplicity and including the sixty triples forced at the six vertices of `H`. Then
> \[
> t(H)+|U(H)|=q^2-14q+115.
> \]

For a six-subset of a nonsingular conic in `PG(2,q)`, this is exactly the C174 identity. No
characteristic condition is needed when `t` is defined by chord concurrence. The equivalent
collinearity-of-chord-poles wording should be restricted to odd characteristic because conic
polarity has a nucleus in characteristic two.

## Proof

At each `h∈H`, exactly five chords meet, contributing
`6 binom(5,3)=60` forced concurrent triples. If `P∉H`, any two chords through `P` have disjoint
endpoint pairs: chords sharing an endpoint already meet at that endpoint. Hence `m_H(P)≤3`; in
particular, an accidental fourfold concurrence is impossible. Put

\[
c(H)=|\{P\notin H:m_H(P)=3\}|.
\]

Then `t(H)=60+c(H)`. The classical first and second secant-index equations at `k=6` give

\[
\sum_{P\notin H}m_H(P)=15(q-1),\qquad
\sum_{P\notin H}\binom{m_H(P)}2
=\binom{15}{2}-6\binom52=45.
\]

The first identity counts the `q-1` nonvertices on each chord. The second counts pairs of chords
meeting away from `H`: of the `binom(15,2)` pairs, `6 binom(5,2)` meet at a vertex. Since

\[
\mathbf 1_{m>0}=m-\binom m2+\binom m3\qquad(0\le m\le3),
\]

the number of covered points outside `H` is

\[
15(q-1)-45+c(H)=15q-60+c(H).
\]

There are `q²+q+1-6` points outside `H`, so

\[
|U(H)|=q^2-14q+55-c(H).
\]

Adding `t(H)=60+c(H)` proves the proposition. This is a clean specialization of the classical
secant-index equations already used in the companion relative-conic paper, not an independent
conic-specific theory.

## The q=11 specialization

At `q=11`,

\[
t(H)+|U(H)|=82.
\]

Combining this identity with C147's four `PGL₂(11)` orbits gives the exact table

| orbit size | stabilizer | `c(H)` | `t(H)` | `|U(H)|` |
|---:|:---:|---:|---:|---:|
| 264 | `C₅` | 0 | 60 | 22 |
| 330 | `V₄` | 2 | 62 | 20 |
| 220 | `S₃` | 3 | 63 | 19 |
| 110 | `D₁₂` | 4 | 64 | 18 |

Thus C147's hexads, the `t=60` orbit, are exactly the on-conic six-arcs with maximal extension
count `|U|=22`. The orbit sizes and stabilizers are classical (Cameron–Omidi–Tayfeh-Rezaie); the
concurrency/extension assignment is the bridge. The two-system identification remains subject to
C156's citation gate, and priority for the printed extension spectrum remains subject to C169.

## Tracked checker and independent recomputation

Source: `notes/2026-07-14-c174-general-six-subset-identity.py`

SHA-256:

```text
a12f424f87fb1783a43a92264c80e80bf090e2ac92a55a3c155f74e5d504269f
```

Command:

```text
python3 notes/2026-07-14-c174-general-six-subset-identity.py
```

The checker exhausts every conic six-subset over the prime fields `q=5,7,11,13`, asserts the two
secant-index sums, `m≤3` away from `H`, both formulas through `c(H)`, the final identity, and the
frozen joint tables:

```text
q=5:  constant=70,  subsets=1,
      {(70,0):1}
q=7:  constant=66,  subsets=28,
      {(64,2):28}
q=11: constant=82,  subsets=924,
      {(60,22):264, (62,20):330, (63,19):220, (64,18):110}
q=13: constant=102, subsets=3003,
      {(61,41):2184, (62,40):546, (64,38):182, (66,36):91}
all structural identities and frozen tables passed
```

An independent stdlib implementation, using direct chord-triple concurrence rather than the
incidence-sum route, reproduced all four tables exactly. The checker implements prime fields only;
the proof is what establishes the theorem for all finite projective planes and all prime powers.

## Definition and novelty cautions

- `t` counts triples with multiplicity, not distinct concurrency points, and includes the sixty
  forced vertex triples. If `t` means accidental triples only, the constant is
  `q²-14q+55`, not `q²-14q+115`.
- `U(H)` includes the `q-5` unused conic points in the conic specialization. Counting only uncovered
  off-conic points changes the constant to `q²-15q+120`.
- Tangents are not chords and are not included.
- The identity is an elementary six-point refinement of the chord/coverage count printed by BDMP
  at `w=5`; C155 should position it that way. The plausible contribution is the concurrency
  correction and its bridge to the Mathieu orbit, not the secant equations themselves.
- The `t=61` gap is special to q=11: q=13 has 2184 subsets with `(t,|U|)=(61,41)`.

## Questions exposed for the discovery track

- For every `k≤7`, an off-arc point lies on at most three secants, so the same inclusion-exclusion
  truncation gives a closed `k`-arc chord–extension formula. Is there a useful uniform statement, or
  is `k=6` the only case where it meets a named design?
- For `k≥8`, higher concurrence terms enter. Can the complete inclusion-exclusion hierarchy be
  organized by secant-index moments in a way that explains why the q=23 octad analogue fails?
- The q=7 table is completely uniform, while q=13 already realizes `t=61`. Which group-orbit fact
  controls the first appearance of each concurrence defect?

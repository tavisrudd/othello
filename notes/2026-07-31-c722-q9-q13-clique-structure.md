# C722 report — q9 and q13 clique equality-case structure

**Lane:** `clebsch`

**Date:** 2026-07-31

**Verdict:** complete with two exact stop-boundary results.  Neither branch
produces a new structural upper bound five, so neither replaces the existing
published or finite proof surface.  The q9 association-scheme bound is exactly
six and its equality data remain feasible.  The q13 Fourier blocks are now
diagonalized exactly, but their spectral and inertia consequences are weaker
than an exact six-color dual bound; the five-row unique-closure lemma remains
load-bearing.

## q9 Sylvester distance-two graph

Let (A_i) be the distance-(i) matrix of the Sylvester graph with
intersection array

```text
{5,4,2;1,1,4}.
```

Its adjacency eigenvalues and multiplicities are

```text
5^1, 2^16, (-1)^10, (-3)^9,
```

and (A_2=A_1^2-5I) therefore has exact spectrum

```text
20^1, 4^9, (-1)^16, (-4)^10.
```

For a clique of size (c), the inner distribution is
((1,0,c-1,0)).  The normalized distance-two cosine in the
(A_1)-eigenspace (-1) is (-1/5), so Delsarte positivity gives

```text
1-(c-1)/5 >= 0,
```

hence (cle6).  At (c=6) the four exact transformed coordinates are
((6,3/4,0,2)); only the (-1) coordinate vanishes.  If (chi) is the
putative clique vector and (n_i(y)) counts clique vertices at distance
(i) from (y), equality says

```text
E_{-1} chi = 0,
5 n0 - n1 - n2 + 2 n3 = 0,
2 n0 + n3 = 2,
A3 chi = 2(1-chi).
```

Thus every point outside the clique would be at distance three from exactly
two clique vertices.  This does not contradict the intersection array:
the exact intersection numbers (p_{33}^2=p_{13}^2=2) satisfy all resulting
pair counts.  In particular, the equality case survives the association-
scheme and first Terwilliger-layer tests.  The displayed proper six-coloring
also gives only six; excluding its rainbow equality case returns to the
existing reflected-prefix finite certificate.

There is one further exact equality-case compression.  Fix a clique vertex
(c).  Each of the five vertices in (Gamma_1(c)) is at distance three from
two of the other five clique vertices, while (p_{13}^2=2) makes every one of
those five clique vertices occur twice.  Hence these five two-subsets form a
2-regular five-edge multigraph: either a pentagon or a triangle together with
a doubled edge.  The intersection array permits both shapes, so this sharper
local form still does not close equality.

The five-clique witness is the vertex set

```text
0,4,9,18,21.
```

The q9 branch therefore stops exactly at six and does not alter the cited
value (omega=5) or its existing Lean certificate.

## q13 three-block tangent graph

With orbit order (A,B,C) and (z^{14}=1), the exact character block is

```text
B_k(a,b) = sum_{d in D_ab} zeta_14^(k d)       (a <= b),
B_k(b,a) = conjugate(B_k(a,b)).
```

The difference sets are precisely the six C721/companion rows.  The replay
computes the universal cubic

```text
det(lambda I-B(z))
```

in `Z[z]/(z^14-1)[lambda]`, then reduces it separately at all fourteen
characters in the canonical power bases for cyclotomic orders (1,2,7,14).
As an independent exact check, the character-block power traces reproduce
all forty-two traces of the integral (42\times42) adjacency matrix before
Newton reconstruction of its characteristic polynomial.

Sturm analysis, with squarefree multiplicities restored, gives adjacency
inertia

```text
(n+,n-,n0) = (19,23,0)
```

and complement inertia

```text
(22,20,0).
```

The direct interlacing and complement-inertia clique ceilings are therefore
24 and 20.  The orbit quotient has characteristic polynomial

```text
x^3-10x^2-24x+88,
```

so its Perron root lies strictly between 11 and 12; the raw Rayleigh ceiling
is only 12.  No ratio or inertia refinement approaches five.

An exact proper six-coloring has class sizes

```text
8,7,7,8,7,5,
```

and supplies the strongest dual bound found here, (omegale6).  Equality
would require a rainbow transversal.  The Fourier blocks impose no zero
character or inertia obstruction to that equality case.  Ruling it out by
compatible-prefix or maximal-clique enumeration would merely recreate a
finite certificate, not the requested structural replacement.

The preserved five-clique witness is

```text
A_0, B_6, B_12, C_1, C_3.
```

Its fourteen simultaneous translates are exactly the five-cliques already
closed by the companion's five-row unique-extension lemma.  That lemma, not
the Fourier bound, remains the proof of the exact upper bound five.

## Reproducibility and trust boundary

Run from `papers/clebsch-rigidity` with Python 3.13.12:

```sh
python3 verification/c722_clique_structure.py --check
```

The deterministic checker reconstructs both integral adjacency matrices,
checks the two five-clique witnesses and both six-colorings, verifies the q9
characteristic polynomial against the intersection-array spectrum, computes
the q13 Fourier group-ring cubic, cross-checks all Fourier and integral power
traces, reconstructs both q13 characteristic polynomials, and proves their
inertias by exact rational Sturm sequences.  It does not certify the absence
of a six-clique; that is the deliberate stop boundary.

Load-bearing files:

```text
verification/c722_clique_structure.py
  18506 bytes
  sha256 42e9285e7bedb1afcd5fdcdd7e97d16cf3bcf559d537bf352741e55beeaf0ec1
verification/c722_clique_structure.json
  14019 bytes
  sha256 f2b33d62c33b25470541e71ec45eeb2c0f0ed613bc58c3f983b95d77de78ca9d
```

The JSON artifact is canonical, sorted, timestamp-free, and contains the
complete q13 characteristic polynomials and every reduced character block.
The `--check` mode regenerates in memory and fails on any byte-level drift.

## Mystery ledger

- **q9 equality feasibility — open, bounded here.**  The Delsarte equality
  condition is unexpectedly coherent: even the first pair-intersection
  consequences match exactly.  The closeout pass reduces each local equality
  pattern to a pentagon or a triangle plus doubled edge.  A sharper
  obstruction would have to exclude both shapes through a genuinely local
  Terwilliger or two-graph constraint.  This task does not allocate that
  exploration.
- **q13 spectral weakness — settled for this interface.**  The exact Fourier
  decomposition has no singular character blocks and its global inertia is
  far too balanced to control a five-clique.  The gap is not numerical
  uncertainty: all character identities and signs are exact.
- **Why the q13 five-row closure is so small — passed to C723.**  The fourteen
  five-cliques all have orbit profile (1|2|2), but the spectral package does
  not explain that rigidity.  C723 may reuse the exact group-ring blocks and
  difference dictionary when testing the weight-ten profiles; no new clique
  task is implied.

## Handoff

C723 receives the exact six difference sets, the universal Fourier cubic,
all fourteen character reductions, both integral characteristic polynomials,
and the honest conclusion that the q13 spectral route stops at six.  It
should retain the five-row unique-closure lemma and must not advertise the
Fourier audit as a proof of (omega=5).

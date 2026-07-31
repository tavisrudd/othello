# C723 report — q13 weight-ten profile obstruction

**Lane:** `clebsch`

**Date:** 2026-07-31

**Verdict:** complete with a structural boundary and two minimized exact
certificates.  Pencil parity gives one common local description, but neither
the elliptic association algebra nor the C722 tangent/Fourier language
excludes both profiles.  The surviving finite boundary is now two canonical
XOR-disjointness certificates with a separate dynamic-programming replay.

## Exact parity reduction

Fix a hypothetical weight-ten kernel support (S) and a point (P\in S).
The seven passant lines through (P) partition its 42 passant-join neighbors
into seven fibres of size six.  Let (s(P)) be the number of the other nine
support points joined to (P) by secants.  Each passant row through (P)
must meet (S) evenly, so the seven fibre occupancies are positive odd
integers whose sum is (9-s(P)).  Hence (s(P)) is even and
(9-s(P)\ge7), leaving exactly

```text
s=0: 3,1,1,1,1,1,1;
s=2: 1,1,1,1,1,1,1.
```

This also gives the common global structure missed by the old case split:
every vertex of the secant-join graph induced on (S) has degree zero or
two.  That graph is therefore a disjoint union of cycles and isolated
vertices.  The two local profiles say only whether the chosen base point is
isolated or lies on a cycle; both possibilities are combinatorially feasible.

The exact raw domains are

```text
s=0: 7*C(6,3)*6^6 =   6,531,840;
s=2: 6^7*C(35,2)   = 166,561,920.
```

No support is omitted: the seven fibres are disjoint, every point outside
them is one of the 35 secant neighbors, and the two displayed odd partitions
are exhaustive.

## Why the structural routes stop

The C721 relation algebra records pair types and the preceding 0-or-2 secant
degree condition, but a union of cycles and isolated points satisfies those
first intersection constraints.  Thus no forced intersection-number
contradiction appears before the actual binary incidence equation is used.

The Segre tangent-product bridge from the weight-eight proof does not apply
uniformly.  In profile (s=0), the base point and the three selected points
in the exceptional fibre are four collinear support points, so the arc
hypothesis behind the tangent lemma is absent.  In profile (s=2), the base
already has two secant joins, so its other points do not form the C722 local
tangent clique.  These are hypothesis failures, not unsuccessful numerical
tests.

Finally, the parity-check equation is over (mathbf F_2), whereas the tangent
products and ordinary root-multiplicity arguments live over
(mathbf F_{13}).  Without an additional bridge turning binary even
incidence into characteristic-13 vanishing or multiplicity, a low-degree
polynomial argument does not inherit the load-bearing hypothesis.  No such
bridge is present in C721 or C722.  Promoting one would therefore require a
new theorem, not a reformulation of the current data.

## Minimized profile certificates

For each internal point (Q), let (m_Q) be its 78-bit passant-incidence
column.  A support is a codeword exactly when its selected columns XOR to
zero.  The primary checker fixes (P=(1:0:2)) and uses two disjoint syndrome
sets for each profile.

For (s=0), each choice of the exceptional fibre gives

```text
L = XORs of one point from three ordinary fibres:       216 values;
R = m_P XOR a triple in the exceptional fibre
        XOR one point from the other three fibres:     4320 values.
```

All values are distinct in both sets, and (L\cap R) is empty for each of
the seven exceptional fibres.  These seven disjointness checks cover all
(6,531,840) raw supports.

For (s=2), the split is

```text
L = XORs of one point from three fibres:                 216 values;
R = m_P XOR one point from each remaining four fibres
        XOR two distinct secant-neighbor columns:     771024 values
        from 771120 raw choices.
```

Again (L\cap R) is empty, covering all (166,561,920) raw supports.
The JSON stores canonical counts and SHA-256 digests of every sorted syndrome
set rather than the sets themselves.

The independent replay uses a different decomposition.  For (s=0), it
builds all 46,656 XORs from the six ordinary fibres and checks them against
the 20 exceptional-fibre triple targets.  For (s=2), it builds 279,744
distinct seven-fibre XORs and checks their shifted set against all 595 secant
pairs.  Both intersections are empty.  This replay reconstructs the finite
plane and incidence columns independently and shares no search routine with
the primary checker.

## Reproducibility and trust boundary

Run from `papers/clebsch-rigidity` with Python 3.13.12:

```sh
python3 verification/c723_q13_weight10_profiles.py --check
python3 verification/c723_q13_weight10_independent.py
python3 check_q13_tangent_code.py
```

The first command verifies the canonical artifact byte-for-byte.  The second
is the independent dynamic-programming proof.  The third is the unchanged
full companion replay and passed with
`omega = 5, d = 12, 364 minimum words, 78 rows recovered,
Aut = PGL(2,13)`.

Load-bearing files:

```text
verification/c723_q13_weight10_profiles.py
  7378 bytes
  sha256 96e95067a3ce8f0f69180c6d78049ddf94905091640a07dfe366234fd383dd78
verification/c723_q13_weight10_independent.py
  3368 bytes
  sha256 6cafb6ec9fc18feda15a3e0d9ab324b8e00b19d2f6281c822d84d22980f701a5
verification/c723_q13_weight10_profiles.json
  4209 bytes
  sha256 aebe48e831c9da14c33e3bf1ec1156ba8a7e0ee8bbe676b413e528fb83e87ff9
```

The proof objects establish only the two exhaustive q13 weight-ten domains.
They do not replace the structural q13 orbit-span and automorphism arguments,
the weight-eight five-row lemma, or any q17/q19 terminal classification.
C726 owns any final trust-ledger wording; no manuscript or trust class changes
are made here.

## Mystery ledger

- **The 0-or-2 secant graph — settled as far as parity goes.**  The closeout
  pass unifies the profiles as cycles plus isolated vertices.  This explains
  the two local shapes but supplies no contradiction; the missing datum is
  the full 78-row binary incidence equation captured by the certificates.
- **Characteristic mismatch — exact boundary.**  The tempting tangent and
  root-multiplicity arguments lack a bridge from (mathbf F_2) parity to
  (mathbf F_{13}) vanishing, and the two profiles separately violate the
  local hypotheses used in the weight-eight argument.  No residual spectral
  calculation is being left unfinished.
- **Near-injectivity of the compressed maps — unexplained but harmless.**  All
  (s=0) half-syndromes are distinct; the (s=2) right half has only 96
  collisions among 771,120 raw choices.  This makes the certificate unusually
  crisp but is not used beyond exact set disjointness.  Any conceptual account
  belongs to a future promoted task, not C725.

## Handoff

C725 should freeze the q13 weight-ten boundary as two binary XOR-reachability
certificates with the exact domains above.  It should not describe either
exclusion as a tangent-product, association-scheme, or polynomial proof.
C724 remains independently ready; C725 still waits for C724 before assembling
the terminal orbit DAG.

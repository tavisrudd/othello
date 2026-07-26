# C623: extension-field Clifford classification

**Date:** 2026-07-25

**Lane:** `ame-lu`

**Status:** complete; the Desarguesian-spread reconstruction gate fails

## Result

For the full six-arc pencil over \(\mathbb F_9,\mathbb F_{25},\mathbb
F_{27}\), with the four quotient-coordinate degeneracies excluded and the
GRS boundary included when it exists, the local-Clifford orbit partition is
exactly
\[
 \{\text{the GRS locus}\}\ \sqcup\
 \{\operatorname{Gal}(\mathbb F_q/\mathbb F_p)\text{-orbits of }z
   \text{ on the non-GRS locus}\}.
\]
This orbit statement does **not** mean that all identifications are
semilinear.  The \(q=9\) admitted non-GRS pencil has genuine
\(\mathbb F_3\)-symplectic, nonsemilinear local-Clifford identifications.
The four parameters all have \(z=1\), form one LC orbit, and every one of
their fixed-party kernels has order \(96\), of which only \(16\) elements
are semilinear.  Thus \(80\) fixed-party elements do not preserve the
Desarguesian \(\mathbb F_9\)-spread.

The \(q=25\) GRS boundary gives a second, structural obstruction.  At each
of its four parameters the shortened-plane intertwiner space is the whole
\[
 \operatorname{End}_{\mathbb F_5}(\mathbb F_{25}^{\,2}),
\]
so the fixed-party kernel is exactly
\(\operatorname{Sp}_4(5)\), of order \(9{,}360{,}000\).  Its semilinear
subgroup has order
\(2|\operatorname{SL}_2(25)|=31{,}200\), leaving \(9{,}328{,}800\)
genuinely nonsemilinear elements.

Consequently the overlapping shortened marginal planes do not reconstruct
the Desarguesian spread, even on the admitted non-GRS locus: \(q=9\) is an
explicit falsifier.  In accordance with the task gate, no general positive
reconstruction theorem is attempted.

## Census

| field | full pencil | non-GRS / GRS | LC orbits | fixed-party kernels |
|---|---:|---:|---:|---|
| \(\mathbb F_9\) | 4 | \(4/0\) | 1 | order \(96\); 16 semilinear, 80 genuine nonsemilinear |
| \(\mathbb F_{25}\) | 20 | \(16/4\) | 4 | non-GRS: order \(24\); GRS: \(\operatorname{Sp}_4(5)\), order \(9{,}360{,}000\) |
| \(\mathbb F_{27}\) | 24 | \(24/0\) | 2 | order \(26\), all semilinear |

The complete non-GRS pair census checked 10, 136, and 300 unordered
parameter pairs at \(q=9,25,27\), respectively.  At \(q=9\), every one of
the ten pairs has a genuine nonsemilinear witness.  At \(q=25\) and \(q=27\),
every non-GRS witness is semilinear.  The exact projective normalization
independently verifies the GRS orbit and the ordinary \(z\)-fibres before
Frobenius closure.

The \(q=9\) kernel is further certified to have center order \(4\), derived
subgroup order \(24\), and element-order distribution
\[
 1^1\,2^7\,3^8\,4^{32}\,6^8\,8^{24}\,12^{16}.
\]
These invariants delimit the exceptional group without assigning an
unproved abstract small-group name.

## Exact reduction

Write \(V_i=\mathbb F_q^2\) as a \(2e\)-dimensional symplectic
\(\mathbb F_p\)-space with trace form
\[
 \langle(x,z),(x',z')\rangle
   =\operatorname{Tr}_{q/p}(xz'-zx').
\]
Each four-party support \(S\) carries a two-dimensional shortened
\(\mathbb F_q\)-plane, and projection to any retained party is an
\(\mathbb F_p\)-linear isomorphism.  Let
\(R^C_{S,i\to j}:V_i\to V_j\) be the resulting transport.

For a party permutation \(\pi\), local blocks \(A_i\) must satisfy
\[
 A_jR^C_{S,i\to j}
   =R^D_{\pi S,\pi i\to\pi j}A_i.
\]
Choose party \(0\), propagate every \(A_i\) from \(A_0\), and impose the
remaining relations.  This is a homogeneous linear system over
\(\mathbb F_p\) in the \((2e)^2\) entries of \(A_0\).  The checker exhausts
its coefficient space, retains exactly the symplectic solutions on all six
parties, and directly verifies one accepted solution for every solution
permutation on the full prime-field-expanded CSS stabilizer Lagrangian.
A necessary, incidence-labelled holonomy trace filter removes permutations
but never accepts or rejects an equivalence by itself.

For the \(q=25\) GRS parameters the nullspace has dimension \(16\), the
entire endomorphism algebra.  Hence its symplectic units are exactly
\(\operatorname{Sp}_4(5)\); an explicit nonsemilinear symplectic
transvection in the certificate passes the full-Lagrangian replay.  This
also exposes the general mechanism: on the GRS/isodual locus the transport
maps are symplectic similitudes, so an arbitrary additive symplectic input
block propagates by conjugation to additive symplectic blocks on every
party.  The field-linear \(\operatorname{SL}_2(q)\) phase is therefore only
the \(\mathbb F_q\)-linear subgroup of the extension-field fixed-party
kernel.

## What the counterexample preserves

The nonsemilinear witnesses preserve every one of the fifteen shortened
four-party planes, all their transport and holonomy incidences, and the
full additive CSS stabilizer Lagrangian.  They fail the exact
\(\Gamma L_2(q)\) test: at least one local block is not linear after any
common Frobenius twist.  Since \(\Gamma L_2(q)\) is the normalizer of the
Desarguesian line spread, these blocks do not preserve that spread.  Thus
the shortened-plane configuration is strictly weaker than the spread it
was proposed to reconstruct.

## Reproducibility

Run from `rust/`:

```text
PYTHONDONTWRITEBYTECODE=1 python3 ../notes/2026-07-25-c623-ame-lu-extension-field-clifford.py --check
```

The generator uses only Python's standard library and canonical
low-to-high polynomial bases:
\[
 \mathbb F_9=\mathbb F_3[x]/(x^2+1),\quad
 \mathbb F_{25}=\mathbb F_5[x]/(x^2+2),\quad
 \mathbb F_{27}=\mathbb F_3[x]/(x^3-x+1).
\]
The tracked JSON records every parameter, orbit, kernel, solution count,
first witness, and exact group invariant.

Checksums and byte counts:

```text
53fb37956c80d832be81cf678c978c97570d72a4d2f9a0e16ec19fe8dcfc6421   54655  2026-07-25-c623-ame-lu-extension-field-clifford.py
cd1bd3841c5bd4854c16d9f315ac8bca39e88fe63d540991253e98102317b98b  493163  2026-07-25-c623-ame-lu-extension-field-clifford.json
```

The trusted boundary is the standard-library finite-field and row-reduction
implementation.  The independent checks are exact projective
canonicalization, the direct full-Lagrangian replay of shortened-plane
witnesses, group closure/inverse/commutator checks for explicitly enumerated
kernels, and the full-endomorphism-algebra proof for the large
\(\operatorname{Sp}_4(5)\) kernels.  The finite census proves only the
stated fields and pencil domain; it does not classify arbitrary
extension-field six-arcs.

## `ej` + `tt` closeout and mystery ledger

The closeout pass promoted two cheap consequences into the result rather
than leaving them as observations: the full \(q=25\) GRS boundary was added
to the initial non-GRS census, and its dimension-16 intertwiner algebra was
identified with the full \(\operatorname{Sp}_4(5)\) kernel.  It also checked
that the \(q=9\) counterexamples are genuinely nonsemilinear blockwise, not
merely semilinear with inconsistent Frobenius exponents.

- **Settled:** Galois-\(z\) gives the orbit partition in all three tested
  fields, after adjoining the single GRS class.
- **Settled:** Galois-\(z\) is not a complete description of the
  intertwiners; \(q=9\) supplies genuine nonsemilinear non-GRS maps.
- **Settled:** shortened marginal planes do not reconstruct the
  Desarguesian spread.
- **Settled:** the \(q=25\) GRS fixed-party kernel is the full
  \(\operatorname{Sp}_4(5)\), with an exact structural rather than sampled
  count.
- **Open mystery:** the \(q=9\) exceptional order-96 kernel has the exact
  invariants above, but no abstract group identification is claimed.  That
  identification is not needed for the falsifier or orbit theorem.
- **Open mystery:** whether Galois-\(z\) remains the orbit invariant for all
  extension fields away from exceptional characteristic-three degeneracy
  is not decided by this finite gate.  Any successor must use a new
  invariant or a restricted reconstruction statement; the original spread
  reconstruction route is closed.

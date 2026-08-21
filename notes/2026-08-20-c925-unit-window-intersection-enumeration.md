# Module 59. Common window generators and the relative wall defect

**Packet part:** Module 59. Stable index:
`notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`

**Status:** the bounded exact enumeration below is complete for the five
Module 41 completed signatures, both coordinate facet normals, every affine
wall level, and every open wall segment modulo the character lattice. All
sixteen adjacent-window cases have nonempty intersection; the minimum common
window size is two. Combined with Module 58, this rules out the separable
primitive-projector implementation on every completed unit pilot. The exact
moving-coordinate-complement calculation is mixed: on the formal diagonal
coefficient substitution, both flip--flip pilots have first-order normal defect in every direction, whereas every
blowup--blowdown direction and four of six directions in each mixed pilot
have order-zero defect. It does not identify any pilot with an actual
AKMW/QDM occurrence or construct an actual primitive receiver.

## 59.1 Exact window convention

For a completed weight multiset \(B=(b_i)_{i=1}^8\subset\mathbf Z^2\),
Spenko--Van den Bergh define the open zonotope

\[
 \Delta^\circ=\frac12\sum_i(-1,0)b_i
       =\sum_i(-1/4,1/4)b_i,                                 \tag{59.1}
\]

where the second equality uses \(\sum_i b_i=0\). For a chamber point
\(\nu\in-C\), the grade-restriction window is

\[
                    L_C=(\nu+\Delta^\circ)\cap\mathbf Z^2.   \tag{59.2}
\]

The checker uses the closed zonotope
\(\overline\Delta=\sum_i[-1/4,1/4]b_i\).  Every sampled chamber point is
generic, so no translated lattice point lies on its boundary and

\[
 (\nu+\Delta^\circ)\cap\mathbf Z^2
   =(\nu+\overline\Delta)\cap\mathbf Z^2.                    \tag{59.2a}
\]

The source convention \(\nu\in-C\) reverses the chamber label relative to
one common secondary-fan convention.  The enumeration includes both sides
of every wall and both transition directions, so this reflection does not
change the exhaustive periodic count.

The five inputs are exactly the genuine-wall signatures of Theorem 41.4:

\[
 (A,B,d,u)=(1,1,0,0),(1,2,0,0),(2,1,0,0),
             (2,2,1,0),(2,2,0,1).                            \tag{59.3}
\]

For each signature the enumeration takes both coordinate facet normals,
all facet levels modulo \(\mathbf Z^2\), and all connected open segments of
each wall after removing intersections with every other translated facet
hyperplane. It samples the two adjacent chambers by the exact rational
transverse displacement \(\varepsilon=1/10000\).  The exact minimum nonzero
crossing parameter to any competing translated facet is \(1/4\), so these
are the immediate adjacent chambers.  Halving \(\varepsilon\) gives the same
windows as an independent regression check.

## 59.2 Bounded exact result

### Proposition 59.1 -- unit-pilot window-intersection enumeration

The search domain in Section 59.1 contains sixteen adjacency cases. Every
case satisfies

\[
                           L_{C_-}\cap L_{C_+}\ne\varnothing. \tag{59.4}
\]

The exact common-size distribution is:

| completed signature | cases | common sizes |
|---|---:|---|
| blowup--blowdown | 2 | \(2,2\) |
| blowup--reverse-curve-flip | 3 | \(3,3,4\) |
| curve-flip--blowdown | 3 | \(3,3,4\) |
| flip--flip, anti-diagonal completion | 4 | \(4,4,4,4\) |
| flip--flip, diagonal completion | 4 | \(6,6,6,6\) |

In particular, the global minimum is two.

The nearest competing translated facet in transverse parameter is exactly
\(1/4\) in the full enumeration.  Thus the chosen displacement
\(1/10000\), not merely agreement after halving it, certifies immediate
adjacency.

The script uses two independent exact membership implementations for every
candidate lattice point:

1. all support half-spaces
   \( |\langle n,x\rangle|\le\frac14\sum_i|\langle n,b_i\rangle|\);
2. an exact rational convex hull of all signed zonotope endpoint sums,
   followed by oriented-edge point-in-polygon tests.

The script asserts equality of these two answers pointwise. Thus the
half-space derivation and the convex-hull implementation independently
cross-check the load-bearing window membership calculation.

### Corollary 59.1A -- separable source no-go on all five pilots

In the specialized schober common-window receiver, Proposition 12.6 fixes
every generator in \(L_{C_-}\cap L_{C_+}\), while Module 43's generic-rank
row takes value one on it. Therefore every case in Proposition 59.1 has a
rank-visible fixed generator.

Under a separable primitive realization

\[
 E_{\zeta_6}U\otimes W_{\rm full},\qquad
 r=p_{\zeta_6}\otimes\operatorname{rk},\qquad p_{\zeta_6}\ne0,              \tag{59.5}
\]

Theorem 58.1 forbids the Module 57 eigenrow law. Hence none of the five
completed unit pilots can use a base-only primitive projector tensor the
full window as its Module 56 producer.

This conclusion is exact for the stated pilot receiver. It does not rule out
a lawfully augmented moving receiver, a coupled projector, or a direct Module 54 projected-row
argument, and it does not assert that an actual weak-factorization occurrence
is one of these toric pilots.

## 59.3 The character-basis moving complement is only a partial repair

Write

\[
 W_\pm=\bigoplus_{\mu\in L_{C_\pm}}K[P_\mu],\qquad
 C=\bigoplus_{\mu\in L_{C_-}\cap L_{C_+}}K[P_\mu],\qquad
 W_\pm=C\oplus M_\pm,                                        \tag{59.6}
\]

where \(M_\pm\) is the direct sum on the noncommon character basis.  For the
specialized wall map \(F:W_-\to W_+\), let

\[
 D=\operatorname{pr}_{M_+}F|_{M_-},\qquad
 r_\pm^{\rm mov}(P_\mu)=1\quad(\mu\notin C).                 \tag{59.7}
\]

This is a basis-split **moving complement**, not an induced rank row on the
quotient \(W_\pm/C\): ordinary rank is one on every common generator, so it
does not descend through that quotient.  The new row in (59.7) is lawful in
the finite pilot because the character basis supplies the displayed
splitting.  An actual QDM use would need an independently typed split or
coupled fixed-phase reader.

Along the named diagonal arc \(z_j=q\) and at the rank character \(\eta=1\),
Proposition 12.6 writes the moving part of a basis vector as the sum over
the nonempty transition masks for weights negative on the traversal normal,
equivalently \(J_{-C_0,-C_2}\), shifted by minus their sum and retained in
\(M_+\).  In all sixteen
cases that mask set is nonempty and independent of the moved source basis
vector.  Moreover, in every directed transition, the uncollected
moved-to-common summands hit every common character basis vector.  Hence

\[
 r_+^{\rm mov}D=f(q)r_-^{\rm mov},\qquad
 A^{\rm mov}(q)=1-f(q),                                      \tag{59.8}
\]

and the checker computes the exact order of \(A^{\rm mov}\) at \(q=1\).

### Proposition 59.2 -- relative-defect order on the moving complement

Across the two directed transitions attached to every adjacency case, the
order distribution is:

| completed signature | directed transitions | \(\operatorname{ord}_{q=1}A^{\rm mov}=0\) | \(\operatorname{ord}_{q=1}A^{\rm mov}=1\) |
|---|---:|---:|---:|
| blowup--blowdown | 4 | 4 | 0 |
| blowup--reverse-curve-flip | 6 | 4 | 2 |
| curve-flip--blowdown | 6 | 4 | 2 |
| flip--flip, anti-diagonal completion | 8 | 0 | 8 |
| flip--flip, diagonal completion | 8 | 0 | 8 |

Thus the obvious moving-complement coefficient passes the necessary
positive-normal pilot test uniformly for both flip--flip signatures, but
fails it uniformly for blowup--blowdown and in four of six directions for
each mixed signature.  It is not a uniform source adapter.

This failure explains exactly what the quotient forgets.  The full
Proposition 12.6 sum also has terms from moved inputs landing in the common
span.  Those terms participate in the product cancellation
\(\prod_j(1-z_j\eta^{-d_j})\).  Projection to \(M_+\) discards them, and in
the order-zero cases it discards the cancellation needed for a positive
normal.  The missing datum is therefore a path-dependent common-output
cross term, not another scalar attached to the moving quotient alone.

The calculation is a pilot theorem only.  It uses the character splitting,
the formal diagonal substitution \(z_j=q\), and \(\eta=1\).  Module 61 now
certifies that substitution as an admissible normalized nonresonant trait for
all five pilots.  It is also a row law
between the distinct relative complements \(M_-\) and \(M_+\), not yet the
Module 57 eigenrow law for an endomorphism of one common receiver.  Promotion
therefore needs a based-loop or reindexing adapter in addition to the
primitive QDM and exact image/Malgrange readers.  By contrast, order zero at
the all-ones point is already a genuine no-go for this \(\eta=1\) complement,
independent of which lawful arc approaches that point.

## 59.4 Reproducibility bundle

Artifacts:

- generator/checker:
  `notes/cubic-threefolds-tasks/c925-unit-window-intersections.py`;
- canonical certificate:
  `notes/cubic-threefolds-tasks/c925-unit-window-intersections.json`.

Exact replay from `/home/tavis/src/othello`:

```sh
nix shell nixpkgs#python3 --command sh -c \
  'python3 notes/cubic-threefolds-tasks/c925-unit-window-intersections.py \
   | diff -u \
       notes/cubic-threefolds-tasks/c925-unit-window-intersections.json -'
```

Hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| script | 20056 | `d6118978c980368d2ab6530b7576348fd024f67a5a9dbe37dde60bdce7cd605e` |
| certificate | 6132 | `2e2685568fd1888fa9322f7cacdaff8477e12d16e2205c9c9647d5aa01356280` |

The certificate records the five exact weight multisets, sixteen-case
count, common-size and relative-defect-order histograms, exact transverse
clearance, per-signature hashes of the fully enumerated case records, script
hash, the two membership implementations, and the gcd-one augmented-minor
certificate used by Module 61. The claim is finite: it proves
nothing for non-unit weights, non-coordinate wall directions, alternative
completions, non-diagonal arcs, or unidentified geometric occurrences.

## 59.5 Source audit

- Spenko--Van den Bergh, *Perverse schobers and GKZ systems*,
  [arXiv:2007.04924](https://arxiv.org/abs/2007.04924), (3.5)--(3.7) for
  \(\Delta\), the translated facet arrangement, and \(L_C\); Proposition
  12.6 for fixed common generators and the literal transition variance
  \(J_{-C_0,-C_2}\), \(\mu\mapsto\mu-\sum_{j\in J}b_j\).
- Module 41, Theorem 41.4, supplies exactly the five completed input
  signatures.
- Module 43, (43.5), supplies generic rank one on character lines.
- Module 58 supplies the separable-projector no-go consumed in Corollary
  59.1A.

## 59.6 EJ/TT and mystery ledger

**EJ.** The common intersection is not marginal: its minimum is two and
rises to six in the diagonal flip--flip pilot. More usefully, the first
relative calculation distinguishes the overlap types. Flip--flip has the
desired first normal jet after the character-basis split; blowup--blowdown
does not. The common-output cross term is now a concrete typed target rather
than generic ``Stokes mixing.''

**TT.** A plain quotient was the wrong abstraction: rank does not descend,
and the discarded common-output term is sometimes exactly what creates the
normal zero.  Treat the wall map as an upper-triangular block
\(C\oplus M_-\to C\oplus M_+\). Retain the cross block as a Reader/lens from
the moving input into the common output, and ask whether the combined row is
the product normal. This is still smaller than a full resonant Stokes matrix.

| question | status | evidence or remaining gate |
|---|---|---|
| Do the five completed unit pilots have common coordinate-wall window generators? | **yes in all 16 enumerated cases** | Proposition 59.1 and certificate |
| What is the minimum common size? | **2** | certificate |
| Can a separable primitive projector on the full window work? | **no for every pilot case** | Corollary 59.1A |
| Does rank descend to the quotient by the common span? | **no** | rank is one on every common character generator |
| Does the basis-split moving complement have positive normal order? | **only for all flip--flip directions and two of six directions in each mixed pilot; never for blowup--blowdown** | Proposition 59.2 |
| What datum was lost in the failures? | **the moved-to-common cross block** | exact term classification; Module 60 retains it |
| Does this prove the actual overlap theorem? | **no** | pilot-to-occurrence and fixed-phase readers remain open |

## Boundary

The finite pilot question is settled: every completed unit adjacency has
common rank-visible fixed window generators, so the separable full-window
producer is impossible.  The naive moving complement is also not uniform.
Module 60 supplies the upper-triangular crossed consumer retaining the
moved-to-common block, and Module 61 supplies its pilot trait.  The
highest-EV remaining source calculation is now the fixed-phase QDM/Malgrange
realization of that relative edge and its based loop.

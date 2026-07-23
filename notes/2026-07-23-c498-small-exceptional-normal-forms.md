# C498 — intrinsic small exceptional normal forms

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Theorem

Let \(q\in\{7,8,9,11,13\}\), let \(f\in\mathbf P^5(\mathbf F_q)\) be a
trivial-gcd exceptional C498 syndrome, and let \(W_f\) be its Hankel-kernel
net of binary quartics.  The following projective-semilinear data form a
complete fingerprint on the frozen exceptional set:

1. the **pointed polar profile**: as \(r\) ranges over
   \(\mathbf P^1(\mathbf F_q)\), the multiset of factorization histograms of
   the quotient-cubic pencil at
   \(b(r)=(a_1-ra_0,\ldots,a_5-ra_4)\), including the infinity chart;
2. in odd characteristic only, the binary-quintic root-divisor type.

Two frozen exceptional \(PGL_2(q)\)-orbits have the same fingerprint if and
only if coefficientwise Frobenius joins them.  Hence the fingerprint
classifies the exceptional \(P\Gamma L_2(q)\)-orbits exactly.  The orbit
counts compress as

\[
\begin{array}{c|ccccc}
q&7&8&9&11&13\\ \hline
\#PGL_2\text{-orbits}&18&11&4&2&1\\
\#P\Gamma L_2\text{-orbits}&18&5&2&2&1.
\end{array}
\]

At \(q=8\), the eleven projective orbits consist of two Frobenius-fixed
classes and three cycles of length three.  At \(q=9\), they form two cycles
of length two.  All orbits are Frobenius-fixed in the prime fields.

The apolar-cubic strata give a short geometric first layer.  The numbers of
semilinear normal forms by Waring type are:

| \(q\) | \(1^3\) | \(1+1^2\) | \(1+2\) | \(3\) |
|---:|---:|---:|---:|---:|
| 7 | 1 | 5 | 9 | 3 |
| 8 | 1 | 1 | 2 | 1 |
| 9 | 0 | 2 | 0 | 0 |
| 11 | 1 | 0 | 1 | 0 |
| 13 | 0 | 1 | 0 | 0 |

The pointed polar profile alone already classifies all semilinear classes at
q=8,9,11,13 and separates 17 of the 18 q=7 classes.  Its unique q=7
collision is the pair of frozen projective representatives 17187 and 17194;
their quintic root types are respectively \(1+4\) and \(5\).  Thus the
two-component fingerprint above is minimal within these two ingredients.
The apolar-cubic Waring type, full net-member histogram, and stabilizer order
remain useful structural labels but are not needed for orbit separation.
This realizes the C498 re-foundation intrinsically: the small exceptions
are classified by the coherently parameterized first-polar line inside the
C491 syndrome space, rather than by coordinate labels alone.

## Normal forms and semilinear laws

The canonical certificate
`notes/2026-07-23-c498-small-exceptional-normal-forms.json` records one
coordinate normal form for every semilinear class, its constituent frozen
\(PGL_2\)-representative indices, its apolar cubic, complete net-member
histogram, pointed polar profile, projective and semilinear orbit sizes, and
both stabilizer orders.

The normal form is the lexicographically first frozen representative in its
Frobenius cycle.  This coordinate choice is only a reproducible section; the
fingerprint above is the intrinsic classifier.  In characteristic two the
old descriptive `quintic_factor_type` field is not Frobenius-stable in the
divided-power syndrome coordinates, but the pointed polar profile already
separates all five semilinear classes, so no substitute coordinate label is
needed.

The already-proved structural forms sit visibly inside the table:

- the characteristic-two \(3\)-nucleus line and its \(q=11\) trinomial echo
  have apolar type \(1^3\);
- the nonsquare split-involution class at \(q=11\) has apolar type \(1+2\);
- the unique \(q=13\) class and both \(q=9\) semilinear classes have apolar
  type \(1+1^2\).

Thus the bounded residue is no longer an unexplained list of coordinate
orbits: it has an intrinsic semilinear normal-form theorem, while the
all-field existence and persistent/modular orbit laws remain those proved
in the main C498 report.

## Evidence and trusted boundary

The generator/checker
`notes/2026-07-23-c498-small-exceptional-normal-forms.py` reads only the
frozen C498 census JSON and replay implementation.  It:

- reconstructs each unique apolar cubic by row reduction;
- independently reconstructs the same kernel vector from signed maximal
  minors and checks proportionality and annihilation;
- enumerates every marked quotient-cubic pencil and its complete
  projective member set;
- proves computationally that fingerprint classes equal Frobenius cycles;
  and
- checks every semilinear orbit/stabilizer identity against
  \(|P\Gamma L_2(q)|=m|PGL_2(q)|\).

From the repository root:

```sh
python3 notes/2026-07-23-c498-small-exceptional-normal-forms.py --summary
(cd notes && sha256sum -c 2026-07-23-c498-small-exceptional-normal-forms.sha256)
```

The computation is deterministic, uses the Python standard library only,
and has no randomness or timestamps.  Its load-bearing inputs are the
canonical C498 census and its independently implemented replay; their
SHA-256 hashes are embedded in the output certificate and checked on every
regeneration.

The trusted boundary is exact but bounded: this certificate classifies the
already-exhaustive exceptional sets over
\(\mathbf F_7,\mathbf F_8,\mathbf F_9,\mathbf F_{11},\mathbf F_{13}\).  It
does not re-establish census exhaustiveness, extrapolate a finite table to
other fields, or replace the all-field split-member theorem.  Those claims
remain supported by the original atomic C498 evidence bundle.

## Extra-juice closeout and mystery ledger

The free closeout upgrade was a minimality ablation.  The entire pointed
quotient-pencil distribution by itself separates every semilinear class
except one q=7 pair; the intrinsic root-divisor split \(1+4\) versus \(5\)
removes precisely that last collision.  The apolar type, net histogram, and
stabilizer are therefore explanatory rather than load-bearing.  Exact
semilinear stabilizer orders follow for free from the Frobenius cycle
lengths.

No genuine C498 mystery remains.  The all-field split-member theorem,
persistent fifth-power orbit law, modular nucleus recurrence, and bounded
exceptional semilinear normal forms are now all classified.  Further
compression into a single low-degree classical quintic invariant would be
a change of presentation, not an evidence gap or an unclassified orbit.

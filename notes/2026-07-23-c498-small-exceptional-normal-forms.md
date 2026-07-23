# C498 — intrinsic small exceptional normal forms

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Theorem

Let \(q\in\{7,8,9,11,13\}\), let \(f\in\mathbf P^5(\mathbf F_q)\) be a
trivial-gcd exceptional C498 syndrome, and let \(W_f\) be its Hankel-kernel
net of binary quartics.  The following projective-semilinear data form a
complete fingerprint on the frozen exceptional set:

1. the shared-root collision energy
   \[
   E_f=\sum_{r\in\mathbf P^1(\mathbf F_q)}\binom{I_f(r)}2,
   \]
   where \(I_f(r)\) is the number of irreducible cubic members in the
   quotient pencil at
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

The energy \(E_f\) alone classifies all semilinear classes at q=8,9,11,13
and separates 13 of the 18 q=7 classes.  Its q=7 collisions are all
separated by the quintic root-divisor type, giving all 18 classes.  The
first moment has the exact double-counting identity
\[
\sum_r I_f(r)=N_{1+3}(W_f),
\]
because every \(1+3\) quartic member has a unique rational root and hence
appears in exactly one marked quotient pencil.  Therefore
\[
\sum_r I_f(r)^2=N_{1+3}(W_f)+2E_f.
\]
The first moment is merely the old net-member histogram; \(E_f\) is the new
coherent incidence statistic.  It counts unordered pairs of \(1+3\) members
whose unique rational linear factors agree.
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
divided-power syndrome coordinates, but \(E_f\) already
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
- computes the irreducible-cubic polar moments and shared-root collision
  energy, proves that the energy fingerprint classes equal Frobenius cycles,
  and verifies the first/second-moment identity above;
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

The first free closeout upgrade reduced the full pointed quotient-pencil
distribution to its irreducible-cubic coordinate.  The second-order ablation
then reduced that spectrum to its second moment.  The third-order pass
subtracts the first-moment double count and isolates the actual new datum:
\(E_f\), the shared-root collision energy of \(1+3\) net members.  This is a
two-copy fibre-product incidence count, not an opaque hash.  In odd
characteristic the quintic root-divisor type supplies the remaining global
parent datum lost by the aggregated polar contractions.

No genuine C498 classification mystery remains.  The all-field split-member theorem,
persistent fifth-power orbit law, modular nucleus recurrence, and bounded
exceptional semilinear normal forms are now all classified.  Further
compression into a single low-degree classical quintic invariant would be
a change of presentation, not an evidence gap or an unclassified orbit.
The new research opportunity is external to C498: \(E_f\) is a two-copy
fibre-product count, suggesting that the arbitrary-redundancy monodromy gate
may admit a hierarchy of low-order polar moments before one attempts a full
splitting-cover monodromy theorem.

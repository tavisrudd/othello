# C904 independent review: prime gluing, Lefschetz defects, and elliptic support

Date: 2026-08-11

Status: theorem-level audit; all three independent replays pass; no
manuscript, Lean, or commit changes

## Verdict

The three central exact conclusions survive review:

1. for a prime-`p` gluing, the minimal-class divisor-product defect is
   `p`-primary and has exponent dividing `p^v_p((g-1)!)`;
2. the printed `p=3,g=4` graph has exact defect three; and
3. on the exotic non-CM `A5` fivefold, all elliptic curves generate an index
   `2^6` sublattice and the primitive minimal class has exact order two in
   the quotient.

The composite-isogeny extension is also correct: if `f:E^g -> A` has degree
`D` and `A` is principally polarized, then the defect order divides

\[
                 \prod_{p\mid D}p^{v_p((g-1)!)}.
\]

No hidden polarization multiplier is missing.  Four exposition corrections
are recommended before promotion:

- identify the so-called Bockstein as the connecting/Tor class explicitly;
- spell out the local-to-global saturation argument through integral Hodge
  lattices, not merely homology;
- justify invariance of the `p=2,g=4` defect under the source group used for
  orbit weighting; and
- narrow the general elliptic eigenline theorem to the `p`-elementary,
  compatible graph setting actually proved.

One census sentence should also be weakened: only the displayed regular
nilpotent representatives were tested for defect, not every regular
nilpotent symmetric slope counted by the script.

## 1. Local-to-global saturation

Let `P_A` be the ordinary integral divisor-product lattice in degree
`2(g-1)` and let

\[
 S_A=(P_A\otimes\mathbf Q)\cap
       \operatorname {Hdg}^{2g-2}(A,\mathbf Z)
\]

be its saturation.  The minimal class belongs to `S_A`: it is integral for
a principal polarization, and a rational multiple of the product
`Theta^(g-1)`.

For an isogeny `f:E^g -> A` of degree `D`, `f^*` is an isomorphism on
integral `q`-adic homology whenever `q` does not divide `D`.  The same is true
for the integral Neron--Severi lattice after tensoring with `Z_q`: the
rational Hodge subspace is preserved by the isogeny, while Lefschetz `(1,1)`
identifies its integral degree-two points with `NS`.  Cup product then gives

\[
       f^*(P_A\otimes\mathbf Z_q)
          =P_{E^g}\otimes\mathbf Z_q.
\]

Thus membership can be checked after localization at every prime, and the
quotient class of the minimal cycle has no support away from the isogeny
degree.  This supplies the missing explicit saturation sentence in both
reports.

For a prime-`p` gluing, the universal identity

\[
        (g-1)!\,c_A=\Theta_A^{g-1}\in P_A
\]

gives the remaining bound `p^v_p((g-1)!)`.  There is no extra factorial:
ordinary cup products are used on the right, while the factorial appears
exactly once in the definition of the divided minimal class.

## 2. Composite-degree corollary

Write `G` for the integral symmetric matrix of the pulled-back principal
polarization `f^*Theta_A` on the literal power.  Since `A` is principal,

\[
              \det G=(f^*\Theta_A)^g/g!=\deg f=D.
\]

Under the standard coefficient identification,

\[
                 f^*c_A\longleftrightarrow\operatorname {adj}(G).
\]

The adjugate is integral.  Rank-one matrices `vv^t` generate
`Sym_g(Z)`, and for primitive `v` the graph elliptic `E_v` is a complete
intersection of `g-1` kernel divisors on `E^g`.  Hence `f^*c_A` is an
integral signed sum of divisor products on the source.

At `q` not dividing `D`, the preceding local isomorphism descends this
membership to `A`.  At `p` dividing `D`, the universal factorial identity
bounds the local order by `p^v_p((g-1)!)`.  Multiplying the local exponents
gives the displayed composite bound.  In particular, `gcd(D,(g-1)!)=1`
forces primitive divisor-product saturation on `A`.

This argument requires the standing non-CM elliptic-power hypothesis so that
the coefficient matrix description is `Sym_g(Z)`.  Within that scope there
is no descent or polarization gap.

## 3. Exact Bockstein formulation

Put `P=P_{A,p}`, `S=S_{A,p}`, `Q=S/P`, and
`r=v_p((g-1)!)`.  Tensoring

\[
                  0\longrightarrow P\longrightarrow S
                    \longrightarrow Q\longrightarrow0
\]

with `Z/p^r` gives the Tor connecting injection

\[
 \delta_r:Q[p^r]\xrightarrow{\sim}
       \ker(P/p^rP\longrightarrow S/p^rS).
\]

For `q=c_A+P`, the explicit boundary formula is

\[
                       \delta_r(q)=p^r c_A\pmod {p^rP}.
\]

This vanishes exactly when `c_A` belongs to `P`, because `S` is torsion-free.
At the first wall `r=1` this is precisely the class printed in the reports.

Calling this an “internal divided-power Bockstein” is acceptable once this
Tor boundary is displayed, but it is not an ordinary Steenrod or
cohomological Bockstein.  “Tor boundary obstruction” is the least ambiguous
name.  For `r>1`, the single class detects membership but does not by itself
provide a named tower of successive Bocksteins; the reports correctly leave
that refinement open.

## 4. Counterexample and factorial audit

The independent Python certificate for `p=3,g=4` is correctly normalized.
It constructs the full rank-ten congruence lattice

\[
 \{T\in\operatorname {Sym}_4(\mathbf Z):TA-AT=0\pmod3\}
\]

by matching its determinant `3^5` to the rank-five commutator map.  Testing
the 220 unordered triple monomials therefore tests every divisor triple,
not a searched sublattice.

The functional `lambda` kills all those products and is nonzero on

\[
                      c_A=\Theta^3/6.
\]

The code explicitly wedges three copies of `Theta` and divides every
coefficient by six before evaluating `lambda`.  Thus the result is not an
artifact of evaluating the undivided cube.  The factorial ceiling and
prime-support theorem then force exact order three.

Both the focused SymPy certificate and the independent Sage graph replay
match their frozen outputs.

## 5. Census and orbit boundary

The complete domains are accurately stated:

- all Lagrangians for `(p,g)=(2,2),(2,3),(3,2),(3,3)`;
- all 2,295 Lagrangians for `(2,4)`, compressed to 57 source orbits; and
- one explicit graph for `(3,4)`.

The `p=2,g=4` weighted counts are exact, but the report should justify why
the defect is constant on the group orbits.  The `GL_2(F_2)` factor is the
reduction of diagonal `SL_2(Z)` acting on the two homology directions of
every elliptic factor; reduction is surjective.  This action preserves the
source alternating form and fixes the `SL_2`-invariant coefficient Hodge
tensors.  The `S_4` factor permutes coefficient axes.  Consequently both
the divisor-product lattice and the minimal class are carried isomorphically,
so one representative per orbit is sufficient.  It would be more precise to
call these **integral cohomological source symmetries**, since an arbitrary
diagonal `SL_2(Z)` matrix need not be an automorphism of the fixed complex
elliptic curve.

The counts `72/63`, `963/1332`, and the orbit counts `24/33` are therefore
licensed.  The claim that the listed coarse invariants do not classify the
defect is licensed only on the enumerated domains, as the reports currently
indicate.

One overstatement remains in the mystery ledger.  The script counts all
regular nilpotent symmetric matrices (`6` in rank three and `36` in rank
four) but computes the defect for `found[0]` only.  Replace

> Regular nilpotent symmetric slopes give the dyadic defect in dimensions
> three and four.

by

> The displayed regular-nilpotent representatives give the dyadic defect in
> dimensions three and four; uniformity across all such slopes remains
> unchecked unless their orbit equivalence is proved.

## 6. Non-axis elliptic-support theorem

The exact exotic-fivefold conclusion is sound.  For `End(E)=Z`, elliptic
subtori are rational coefficient lines.  The exotic mod-two graph operator
satisfies `omega^2+omega+1=0`; both `omega` and `omega-I` are invertible, so
it has no `F_2` eigenline.  Therefore no elliptic plane gains a half-lattice
vector.  Every elliptic class is two-adically integral in source
coordinates, while the minimal class corresponds to

\[
                         G^{-1}=(I+J)/6,
\]

which has half-integral off-diagonal entries.

The exact computation goes further.  The 121 short lines generate a
rank-fifteen lattice with Smith quotient `(Z/2)^6`; the two-adic parity map
on the saturated Hodge lattice has rank six and has precisely that short-line
lattice as kernel.  Hence this is the full elliptic span, not merely a finite
lower bound.  Adjoining `c` halves the index and `2c` is already present, so
the minimal class has exact order two.

The general eigenline lemma was slightly overbroad as written.  Its proof
requires a `p`-elementary discriminant graph using the same coefficient
module in the two homology directions.  That hypothesis is satisfied by the
exotic `A5` application and has now been added to the focused note.  A
higher-level or non-compatible discriminant graph needs a separate
formulation.

The low-degree census is complete: area denominators are only `1` and `3`,
so theta degree at most eight implies `q(v)<=24`; since the least eigenvalue
of `G` is one, every coordinate is at most four.  The enumerated box is
therefore exhaustive.  The counts and orbit sizes are licensed.  The phrase
“genuinely new degree-three packet” should be read only as new to this
dossier until a dedicated literature audit is complete; the focused note now
uses that narrower language.

The geometric identification of the degree-four orbit with the `V4`
elliptics is consistent and can be made intrinsic: its stabilizer has order
four, hence is a `V4`, and the unique character lines are exactly the paired
elliptic factors in the `g`-anti-invariant genus-two surfaces.  Printing this
one-sentence stabilizer argument would make the identification fully
auditable.

## 7. Replay status

The following frozen comparisons are clean:

```sh
diff -u notes/2026-08-11-c904-prime-gluing-divided-power-counterexample.out \
  <(uv run --with sympy python \
    notes/2026-08-11-c904-prime-gluing-divided-power-counterexample.py)

diff -u notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class-replay.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class-replay.sage").read()))')

diff -u notes/2026-08-11-c904-nonaxis-elliptic-support.out \
  <(nix shell nixpkgs#sage -c sage -c \
    'exec(preparse(open("notes/2026-08-11-c904-nonaxis-elliptic-support.sage").read()))')

diff -u notes/2026-08-11-c904-nonaxis-elliptic-support-replay.out \
  <(nix shell nixpkgs#sage -c sage -python \
    notes/2026-08-11-c904-nonaxis-elliptic-support-replay.py)
```

All four produce empty diffs.

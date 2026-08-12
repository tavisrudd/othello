# C909 — short nu6 quantum epilogue: exact wording and hostile checks

Date: 2026-08-12  
Status: wording/proof audit only; no manuscript, PDF, mirror, or Lean edit

## Definitions and hypotheses

Let `A` be the free abelian group on the relevant geometric `G=mu_2`
atomic F-bundle classes, with integral Tate twists identified for purposes of
formal monodromy. For a smooth projective variety `Z`, write
`CFF_G(Z)` for the maximal/big A-model chemical formula. Define
\[
 \nu_6(Z):=\#\{e^{\pi i/3},e^{-\pi i/3}\text{ in the formal monodromy of }
 \operatorname{CFF}_G(Z)\},
 \tag{1}
\]
with algebraic multiplicity and extended additively over `A`. Integral Tate
twists do not change (1).

The only low-dimensional input needed below is
\[
 \dim W\le2\quad\Longrightarrow\quad \nu_6(W)=0
 \tag{LD}
\]
for every smooth projective `W` and every geometric atom represented by such
a `W`. KKPYY's nef-canonical surface gauge, the surface classification, the
projective-bundle formula for ruled surfaces, and point blowups supply (LD);
curves contribute only `0` and `1/2` fractional residues.

## The exact short theorem

> **Theorem (fourfold birational and one-ℙ¹ obstruction).** Assume the
> KKPYY blowup/projective-bundle chemical-formula identities and (LD). Then:
>
> 1. If `Z,Z'` are smooth projective complex varieties of the same dimension
> `d <= 4` and `Z` and `Z'` are birational, then
> \[
> \nu_6(Z)=\nu_6(Z').
> \]
> 2. If `X,Y` are smooth projective threefolds and
> `X x P^1` and `Y x P^1` are birational, then
> \[
> \nu_6(X)=\nu_6(Y).
> \]
> 3. Let `V_14` be a smooth prime Fano threefold of degree 14. On any
> precisely specified Kuznetsov locus on which the theorem identifying its
> Kuznetsov component with a cubic component also identifies the corresponding
> parity-fixed zero quantum atom and its formal-monodromy block, one has
> \[
> \nu_6(V_{14})=2,
> \qquad V_{14}\times\mathbf P^1\text{ is irrational}.
> \]

The qualification in (3) is load-bearing: an abstract equivalence of
triangulated Kuznetsov components, without a theorem transporting the
maximal A-model/quantum atom and formal monodromy, does not imply the displayed
nu6 equality.

## Proof wording

By weak factorization, a birational map between smooth projective `d`-folds
is a chain of blowups and blowdowns along smooth centers of codimension at
least two. Hence every center `W` has `dim W <= d-2 <= 2`. The blowup
chemical formula changes `CFF_G` by Tate-shifted copies of `CFF_G(W)`. By
(LD) their nu6 contribution is zero. Integral Tate shifts also preserve
formal monodromy, so each elementary blowup and blowdown preserves nu6. This
proves (1). Projective space has only integral formal powers, so a rational
smooth `d <= 4`-fold has nu6 equal to zero.

For a rank-two bundle `E -> X`, KKPYY's projective-bundle formula gives
\[
 \nu_6(\mathbf P_X(E))=2\nu_6(X).
 \tag{2}
\]
In particular, `P_X(O_X^{\oplus2})` is isomorphic to `X x P^1`. Therefore a
birational equivalence of `X x P^1` and `Y x P^1`, together with (1) in
dimension four, gives
\[
 2\nu_6(X)=\nu_6(X\times\mathbf P^1)
 =\nu_6(Y\times\mathbf P^1)=2\nu_6(Y).
\]
Since nu6 is integer-valued (indeed a homomorphism to the torsion-free group
`Z`), cancellation of the common factor two gives (2). No division by two in
the atom group is being performed.

On the specified Kuznetsov locus, the exact comparison sends the cubic
zero-atom block to the `V_14` zero atom and preserves formal monodromy. Cai's
cubic block has eigenvalues `e^{+pi i/3}` and `e^{-pi i/3}`, one each, so
nu6(`V_14`) equals two. If `V_14 x P^1` were rational, (1) would compare it
birationally with `P^4` and force nu6 equal to zero, whereas (2) gives
nu6(`V_14 x P^1`) equal to four. This contradiction proves the last claim.

## Hostile checks

1. **Factor-two cancellation.** The target is `Z`, not `Z/2` or a quotient of
   atom classes. Equality `2a=2b` therefore implies `a=b`. The proof must not
   define a half-valued invariant or silently divide an atom class by two.
2. **Projectivization versus product.** A general `P^1`-bundle `P_X(E)` is
   not generally isomorphic to `X x P^1`. Only `E=O_X^{\oplus2}` gives the
   product used above. The projective-bundle formula still gives the rank-two
   factor for arbitrary `E`. If `X` is integral, `P_X(E)` is nevertheless
   birational (after choosing a basis over `K(X)`) to `X x P^1`; that
   birational trivialization is noncanonical and is not used in the proof.
3. **Weak-factorization orientation.** Centers are codimension at least two;
   divisor blowups are omitted because they are isomorphisms. The argument
   uses the blowup formula in both orientations, so it proves birational
   invariance rather than only a one-sided obstruction.
4. **Kuznetsov scope.** “`V_14` has a Kuznetsov component equivalent to a
   cubic component” is not by itself a quantum statement. The printed
   hypothesis must include the exact atom/F-bundle comparison and its
   formal-monodromy compatibility. Without that clause the `V_14` conclusion
   is MAJOR overreach; with it, the proof is the two displayed equations.

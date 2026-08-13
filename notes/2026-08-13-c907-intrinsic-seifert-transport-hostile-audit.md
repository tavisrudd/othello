# C907 hostile audit: intrinsic Seifert transport

**Target:** `2026-08-13-c907-intrinsic-seifert-transport-lemma.md`  
**Verdict:** **PASS conditional, with MINOR functoriality hypotheses to make explicit.**

Let `p:X' -> X` be a proper map over the parameter/value base, and let the two
open immersions satisfy `p o j'=j` and identify the same `U`. Then there are
canonical isomorphisms

\[
 Rp_*j'_!A\simeq j_!A,
 \qquad Rp_*Rj'_*A\simeq Rj_*A. \tag{1}
\]

The first is proper-modification extension-by-zero descent. The second is
ordinary derived functor composition:
`Rp_*Rj'_* = R(p o j')_*`; it does not require a boundary-stratum
comparison. Thus the natural maps `j_! -> Rj_*` commute with (1). Proper
duality, proper nearby/vanishing-cycle pushforward, and the naturality of
`can` and `var` then transport the relative intersection/Seifert package.
No constant sheaf on an exceptional divisor enters.

The three required precision clauses are:

1. Write (1) as canonical **isomorphisms**, not literal equalities, and
   require `p` to be over both functions before applying nearby/vanishing
   cycles.
2. Require constructibility and a proper compactification `bar a` for the
   displayed `K_!` and `K_*`; then Verdier duality gives
   `D(j_!A)=Rj_*D(A)` and proper pushforward commutes with duality.
3. For the Seifert form, retain one fixed value-loop/path-star convention,
   `can/var` normalization, and complex orientation. The natural map and
   duality alone give the compact/ordinary pairing; the directed Seifert
   ordering is supplied by that additional path data.

Under the target's nonbraiding Morse hypotheses, the oriented rank-one local
groups and all `can/var` pairings are local systems on the contractible
parameter disk. Their ordered matrix is therefore constant and equals its
central Thom--Sebastiani value. The two-complex-variable `ZU` suspension has
even sign, so the stated `P^3` matrix follows once the central orientation
calculation is fixed.

This is a valid replacement for a common collar in the pairing step. It does
not remove the still-explicit proper nearby-cycle/direct-image and orientation
identifications needed to connect the C907 ratio/exterior models to the
intrinsic nearby object.

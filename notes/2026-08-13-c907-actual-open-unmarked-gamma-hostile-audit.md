# C907 hostile audit: actual open and unmarked Gamma shear

**Targets:** `2026-08-13-c907-actual-open-preserving-tropical-model.md` and `2026-08-13-c907-unmarked-gamma-suffices-for-m2.md`.

**Verdict:** actual-open theorem **PASS** with two construction hypotheses. The \(N\)-adic algebra in the Gamma note is **PASS**; its claim about the full enriched/Stokes packet is **MAJORLY overbroad** unless that packet explicitly forgets directed Stokes flags.

## 1. Actual open

For the original open graph, `delta` and the `y_i,B,C` are units, while `U=1-B,V=1-C` may vanish. Thus the only non-Laurent directions have

\[
t=p_i=r_B=r_C=0,\qquad (B,C)\text{ of types }g\text{ or }1.
\]

Their six weights are \(0,0,0,0,0,-\beta-\gamma\). There is no interior graph wall, and the zero/ray tripod products are unimodular. A relative regular subdivision preserving those cones is available. Its toric map is an isomorphism on their affine charts, including the `U=0`, `V=0`, and double-translated points, not merely on their orbit generizations. Hence the strict transform is unchanged over the original open graph, repairing the extension-by-zero issue.

Two hypotheses must be explicit:

1. The supported fan maps to the fixed marked projective/y ambient and the relative regularization subdivides that fan, giving a direct `E -> X_0`.
2. `E` is the strict closure of the original graph and is proper over the bounded base.

Then `E -> X_0` is proper and an isomorphism on `G_orig`, so proper-support descent applies. Cone preservation alone does not make an arbitrary exterior closure proper or identify an arbitrary diagonal correspondence.

## 2. Logarithmic exterior descent

**Verdict: PASS conditional on the direct relative regular model just
described.** The revised 70 pivots are genuinely logarithmic residue fields.
On a regular toric chart, the ray span is saturated and the residue lattice is
free; the displayed `b,c,x_i` characters therefore give regular fields
`rho partial_rho` which fix the exceptional monomials. They are tangent to
every actual boundary component. The named factors are units on the stated
residue torus; when one becomes zero the point moves to a different tripod
type, which has its own record. Thus the old nonregular `partial_b/partial_c`
problem is removed. The checked replay correctly certifies 70 logarithmic
unit pivots and two excluded `L=0` masks.

The coverage trichotomy is sufficient only with these already stated inputs:
full-initial equality on every supported face, the positive-normalization
free-`L` result for noncompact double-marked faces, and a direct strict
tropical model whose relative regularization preserves the `t=0,g/1`
subfan. With them, no arbitrary-unimodular-refinement issue remains: a refined
cone lies in a certified cell, and its residue-chart field is regular.

One wording repair: do not call the result unconditional merely from the mask
replay. It is unconditional only after the direct-model/proper-map hypotheses
in §1 are made part of the theorem. The replay alone does not construct
`pi_ext:E -> X_0`; the actual-open theorem supplies that construction.

## 3. Gamma shear

For `F^k=N^k Lambda`, `N^4=0` and `S_r=1+rN^3` give

\[
S_r(F^k)=F^k,\qquad S_r|_{F^k}=1\quad(k\geq1).
\]

The induced map on each associated graded is identity. Thus `S_r` genuinely preserves the integral lattice, hyperplane action, Euler pairing, and actual **N-adic Rees filtration**. Rees length is unchanged in a category using only these data.

It need not preserve a full Stokes-filtered/Gamma object. For the directed hyperplane basis,

\[
\omega=e_0-3e_1+3e_2-e_3,\qquad S_r(e_0)=e_0+r\omega.
\]

For `r != 0` this does not preserve the rank-one Stokes flag `Z e_0`, nor the usual forward or reverse partial flags. A Stokes-matrix/Gram invariance is therefore not invariance of a sectorial Stokes filtration, a central-connection/asymptotic basis, or a specified Gamma comparison map. Those are structures required by the extant strict enriched Stokes/Rees programme.

The safe theorem is conditional: the shear is harmless to `m=2` if the enriched category retains only `(Lambda, Euler pairing, H, N-adic Rees filtration)`, or if invariance of its actual Stokes filtration under `S_r` is proved separately. The target's unconditional `Settled` wording is too strong.

## 4. Telescope

For a chosen weak factorization, marked-seed composition coherence is not needed after strict biproduct isomorphisms exist in that unmarked category: choose the maps and compose them. Center-summand automorphisms only conjugate intermediate isomorphisms and do not alter endpoint Krull--Schmidt signatures.

But strict blowup biproducts must exist in a category in which `S_r` is an allowed automorphism. If its object retains a directed Stokes filtration, the flag calculation leaves `r=0`, or a separate invariance theorem, as a live gate. Point-class normalization is optional only for the deliberately coarsened N-adic/Rees telescope, not yet for the full Stokes/Gamma programme.

# C909 — hostile audit of the proposed Eisenstein-unity lead

Date: 2026-08-12  
Status: editorial/mathematical audit; no manuscript, PDF, mirror, Lean, or
commit change

## Verdict: MINOR for the arithmetic analogy; MAJOR if stated as a common packet

There is a real common quadratic shadow, but not yet a common geometric
`Z[ζ_3]` packet.

* On the cycle side, the exotic pair is the Frobenius pair of roots of
  `x^2+x+1` in `F_4`.  Its chosen integral golden lift is instead a unit
  `φ` satisfying `φ^2-φ-1=0` on the saturated 2-adic lattice.  The local order
  `Z_2[φ]` is an unramified quadratic extension and is **noncanonically**
  isomorphic to `Z_2[ζ_3]`; there is no canonical/global `Z[ζ_3]` action in
  the printed cycle proof.
* On the quantum side, Cai's actual formal exponents are `-1/6` and `-5/6`,
  giving raw monodromy eigenvalues `e^{-πi/3}` and `e^{πi/3}`.  Negating
  these eigenvalues gives `ζ_3` and `ζ_3^2`, but that negation is an extra
  half-parity/Tate-style twist, not the framed invariant `ν_6` used in the
  epilogue.  The proof currently uses the primitive-sixth pair itself.
* Cai computes a complex formal block/eigenvalue pair, not an integral
  `Z[ζ_3]`-lattice or an action on the geometric cycle lattice.  The two
  complex eigendirections are not individually canonical; only the spectral
  summand and its polynomial action are canonical after the framed operator
  and a choice of the negation are fixed.

Therefore the safe synthesis is “the two arguments exhibit conjugate
quadratic packets with a shared residue/Eisenstein shadow,” not “they are the
same Eisenstein packet” or “both are fibers of `Spec Z[ζ_3]`.”  The latter
would overstate both the ring action and the cross-detector identification.

## 1. Cycle-side calculation

The manuscript's conference operator satisfies `B^2=5I` and, on the
canonical saturated lattice `D_6^∨`,

\[
 \varphi=(I+B)/2,
 \qquad \varphi^2-\varphi-1=0.
\tag{1}
\]

Reducing the commutator heart modulo `2` changes the signs, so (1) becomes

\[
 \bar\varphi^2+\bar\varphi+1=0.
\tag{2}
\]

The polynomial in (2) is irreducible over `F_2`; hence

\[
 F_2[\bar\varphi]=F_4,
 \qquad \bar\varphi\in\{\omega,\omega^2\}.
\]

Orientation reversal is `B↦-B`, hence

\[
 \varphi\longmapsto (I-B)/2=1-\varphi,
 \qquad
 \omega\longmapsto 1+\omega=\omega^2.
\tag{3}
\]

This verifies the exact sign and Frobenius claim in the envelope section.
The two exotic graph lines in `P^1(F_4)` are exchanged by (3), while the
three `F_2`-rational lines are fixed as a set by the larger simplex action.
The geometric argument needs the unordered exotic pair; a global choice of
one member requires the marked golden orientation.

There is an honest local quadratic order behind (1):

\[
 O_g:=Z_2[x]/(x^2-x-1).
\tag{4}
\]

Because the reduction of its defining polynomial is separable and
irreducible, `O_g` is the unramified quadratic extension of `Z_2`, with
residue field `F_4`.  The ring `Z_2[ζ_3]` is another presentation of the
same unramified quadratic extension, since `x^2+x+1` is also separable and
irreducible modulo `2`.  Thus `O_g ≅ Z_2[ζ_3]` as local rings, but the
isomorphism is noncanonical: it amounts to choosing which residue root maps
to `ζ_3 mod 2`.  Globally, `Z[x]/(x^2-x-1)` is the real quadratic order of
discriminant `5`, not `Z[ζ_3]` of discriminant `-3`; no global integral
identification is available.

More importantly, the current cycle theorem uses the reduction (2) to prove
squarefree graph descent and cofactor saturation.  It does not prove that the
whole integral NS/product/Hodge package is an `O_g`-module, nor that its
Frobenius torsor is functorially identified with a quantum packet.  The
available action is an action on the 2-primary coefficient/commutator heart
(and the selected saturated lift), not a canonical Eisenstein action on the
full geometric Jacobian cohomology.

## 2. Quantum-side calculation

Cai's small even cubic calculation uses the rank-two zero-eigenvalue block.
The indicial equation is

\[
 \rho^2+\rho+5/36=0,
 \qquad
 \rho=-1/6,-5/6.
\tag{5}
\]

The formal solutions therefore carry

\[
 e^{2\pi i(-1/6)}=e^{-\pi i/3},
 \qquad
 e^{2\pi i(-5/6)}=e^{-5\pi i/3}=e^{\pi i/3}.
\tag{6}
\]

This is the primitive-sixth pair, the roots of

\[
 x^2-x+1=0.
\tag{7}
\]

If one applies the extra scalar `-1`, then

\[
 -e^{-\pi i/3}=e^{2\pi i/3}=ζ_3,
 \qquad
 -e^{\pi i/3}=e^{4\pi i/3}=ζ_3^2,
\tag{8}
\]

and the polynomial becomes `x^2+x+1`.  Equation (8) is arithmetically
correct, but the scalar `-1` is not invisible in the epilogue's framed
definition: it changes the chosen monodromy spectrum.  It corresponds to a
half-integral exponent shift, whereas the proof only permits integral powers
of the original loop coordinate.  The raw invariant `ν_6` must therefore
remain a sixth-root count unless a separately normalized twisted invariant is
introduced.

The quantum calculation gives a complex formal differential-module summand.
Once the primitive-sixth spectral subspace `V_6` is isolated, its formal
monodromy `M_f` is canonical and `J=-M_f|_{V_6}` satisfies

\[
 J^2+J+1=0.
\tag{9}
\]

Consequently there is a formal `C`-linear action of `Z[ζ_3]` on `V_6` by
`ζ_3↦J`, provided the negation is explicitly part of the definition.  This
is only a complex operator action.  Cai does not construct an integral
`Z[ζ_3]` lattice, a 2-adic lattice, or a comparison map to the cycle-side
`F_4` heart.  If the full KKPYY zero atom contains additional odd summands,
the printed argument only gives `dim V_6≥2`; it does not identify the whole
atom with a rank-two Eisenstein module.

The two eigendirections in (6) are exchanged by complex conjugation, but
neither is selected canonically.  The canonical object is the unordered
spectral pair/subspace, matching the fact that the cycle proof only needs the
unordered exotic graph pair.

## 3. Why “both fibers of `Z[ζ_3]`” is misleading

At the prime `2`, `x^2+x+1` is irreducible, so `Spec Z[ζ_3]` has one
degree-two residue point over `F_2`, not two residue fibers.  Its two complex
embeddings are the pair `ζ_3,ζ_3^2`; the cycle exotic pair is two
`F_4`-rational graph lines exchanged by Frobenius.  These are analogous
conjugate torsors, but they live over different bases and are not identified
by the current theorems.

The clean diagram is therefore only a shadow diagram:

```text
cycle:   O_g = Z_2[golden unit]  --reduction-->  F_4, {ω,ω²}
quantum: C[M_f] on V_6 --(optional -1 twist)--> C[ζ_3], {ζ₃,ζ₃²}
```

The vertical comparison arrow is absent.  Adding it would require, at
minimum, a common coefficient field/lattice, a canonical twist convention,
and a functorial operation-preserving comparison between the graph gluing
and the quantum formal connection.  None is supplied by the cycle theorem,
Cai's computation, or KKPYY's atom formulas.

## 4. Editorial recommendation

Do not add a “common Eisenstein packet” master theorem to the current
epilogue.  It would create a new load-bearing comparison claim while neither
headline theorem needs it.  If the unity observation is retained in a future
perspective paragraph, use wording of this strength:

> The two mechanisms carry conjugate quadratic data: the exotic two-primary
> gluing has residue algebra `F_4` and a noncanonical unramified lift at `2`,
> while the cubic quantum block has primitive sixth formal monodromy; after
> an optional sign twist, both are governed by the polynomial
> `x^2+x+1`.  We use no identification between these packets.

Keep the exact current claims separate:

* cycle side: unordered exotic `F_4` pair, or one marked member after golden
  orientation; squarefree minimal polynomial modulo `2`;
* quantum side: raw primitive-sixth monodromy with `ν_6\ge2` in the even
  cubic block; no claim that the full atom has rank two or an integral
  Eisenstein action.

## `ej` + `tt` closeout / mystery ledger

Settled:

* orientation reversal is exactly `φ↦1−φ`, reducing to Frobenius
  `ω↦ω²`;
* Cai's signs are exactly `e^{-πi/3},e^{πi/3}` from residues
  `-1/6,-5/6`;
* negation converts the sixth-root polynomial `x²−x+1` to the Eisenstein
  polynomial `x²+x+1`.

Still open and not needed for the epilogue:

* a canonical choice of the local isomorphism `O_g≅Z_2[ζ_3]`;
* an integral quantum lattice carrying that action;
* a comparison map between the graph heart and the quantum formal block;
* whether the odd part of the KKPYY cubic atom contributes further primitive
  sixth roots.

No genuine common packet theorem remains justified by the current evidence;
the safe result is the residue-level/conjugacy analogy only.

## Follow-up hostile check: exact scope of “canonical”

The word *canonical* needs one qualification even on the cycle side.  The
map from the two conference orientations to the two exotic graph members is
equivariant once the conference operator, the saturated lattice, and the
embedding of its commutant as \(\F_4\) are fixed.  It is not a canonical
choice of one member, nor a canonical characteristic-zero identification
\(\mathbf Z_2[\varphi]\simeq\mathbf Z_2[\zeta_3]\).  Changing the residue
root exchanges the two identifications.  Thus “canonical Frobenius torsor”
is acceptable only as an equivariant two-element torsor statement.

The two characteristic-zero operators also have genuinely different
polynomials:

\[
 \varphi^2-\varphi-1=0,\qquad
 M_f^2-M_f+1=0.
\]

The first reduces to \(x^2+x+1\) only in characteristic two; the second
becomes \(x^2+x+1\) after the additional complex sign twist
\(J=-M_f\).  Consequently the common polynomial is not an equality of
characteristic-zero packets, but a comparison between a mod-\(2\) residue
shadow and a sign-normalized complex spectrum.

Finally, \(J=-M_f\) gives a formal \(\mathbf C\)-linear
\(\mathbf Z[\zeta_3]\)-action on the rank-two spectral block only if the
block is taken with the displayed semisimple primitive-sixth spectrum.
It does not produce a \(\mathbf Z[\zeta_3]\)-lattice, an action on the full
quantum connection, or a comparison to the geometric \(F_4\) heart.  Any
statement that the cycle and quantum objects are “the same packet” therefore
fails at the first missing comparison map, before any deeper geometric issue.

## Source records

### Jiaji Cai

* *The cubic threefold is symplectically irrational*, arXiv:2608.01577v1.
* Read depth: **full text**, all 8 pages; the cubic calculation on pp. 4--6
  and Proposition 6 were checked directly.
* Cache key: `arXiv:2608.01577`.
* SHA-256: `06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e`.

### Current epilogue sources

The cycle-side formulas audited here are the paper-local displayed formulas
in `sections/02-envelope.tex` and `sections/03-minimal-class.tex`; the
quantum-side framed definition and operation formulas are in
`sections/04-one-step.tex`.  No external priority claim was made and no new
literature search was needed for this hostile check.

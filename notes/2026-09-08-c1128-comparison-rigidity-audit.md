# C1128: comparison, rank-two rigidity, and first-reading audit

Date: 2026-09-08. Lane: `cubic-threefolds`.
Scope: the author's “1–3 go”; mathematics/source audit first, with proposed
expository changes kept outside the manuscripts.

## Verdict

The audited comparison and local-rigidity arguments support the stronger
canonical-lattice count, under the standard quantum-cohomology and
surface-classification inputs already used by the manuscript. Nonresonance
is not used in lattice transport, cyclic persistence, modified-base regularity,
or low-dimensional vanishing. The proposed resonant count is therefore a
deduction from these ingredients, not merely a conjecture suggested by its
finite matrix values. This is a targeted mathematical audit, not independent
certification of either full main theorem or of the proposed Fano applications.

No fatal defect was found in items 1–2. Two expository commitments need to be
made precise: distinguish a graded completed z-enhancement from an ordinary
polynomial scalar extension, and state the hypotheses of cyclic persistence
before applying its recursion. The current proof already supplies the relevant
arguments. Item 3 is delivered as a concrete replacement outline and prose in
`2026-09-08-c1128-proposed-proof-presentation.md`; no manuscript was edited.

The 2026-08-21 narrowing to exponent classes addressed a mismatch with the
then-advertised monodromy interpretation and a possible cubic-fourfold test.
The original referee report explicitly says that its computed rank-two
ambient piece is inside a rank-24 whole primary summand at the small point;
it does not exhibit a counted whole generic rank-two block on a rational
fourfold. Thus it is not a counterexample to the stronger invariant. Neither
that historical computation nor its generic-bulk prediction is independently
recomputed here. A direct generic cubic-fourfold test remains useful, but is
not a missing premise in the comparison/vanishing proof.

Two external primary works were read in targeted passages; zero were reread
in full. Their exact versions, passages, access and hashes are recorded below.
The new computation verifies local identities only. No Lean operation,
manuscript build, mirror synchronization, or external message occurred.

## 1. Explicit coefficient and connection statement

Let `Z -> Y` be a smooth connected center of codimension c >= 2. Put
`rho=c1(N_(Z/Y))`. Use numerical effective curve classes and even cohomology
throughout, setting odd bulk variables to zero. For any smooth projective W,
write

```text
R_W = C[[X_d, sigma']]_gr[sigma^0],
X_d = Q_W^d exp(sigma^(2) . d),
deg X_d = 2 c1(W).d,   deg sigma^alpha = 2-deg phi_alpha,
K_W = Frac(R_W).
```

Here the combined symbols X_d form the numerical effective monoid, sigma'
contains the even nonunit, nondivisor coordinates, and sigma^0 is polynomial.
The completion is graded, with the ample/parameter filtration in Iritani
Section 2.2. Divisor coordinates are not separate coefficients of R_W.

For the external direct sum, use

```text
A_c = C[q^(±1/scr_s)][[Q,t,s_0,...,s_(c-2)]]_gr,
B_c = C[z]((q^(-1/scr_s)))[[Q,t,s_0,...,s_(c-2)]]_gr,
scr_s in {c-1,2(c-1)}, as specified by Iritani (5.11),
F_c = algebraic closure of Frac(A_c).
```

All bulk coordinates for the ambient term and the separate center copies
are independent. There is an injective realization `B_c -> A_c[[z]]`
(ordinary z-adic power series suffice as an overring). In particular, an
isomorphism over B_c and its inverse both lie in `GL(F_c[[z]])`. This is
exactly the content needed from Iritani Remark 1.5. No z inversion or
ramification is needed for the comparison; fractional powers concern q.

**Completion wording repair.** The manuscript describes R_W as a coefficient
domain “whose C[z]-extension” is the reduced source. Read literally as
`R_W tensor C[z]`, this is too restrictive. For a bulk coordinate u of degree
-2, `sum_(n>=0) z^n u^n` belongs to the graded completed z-enhancement but
is not polynomial in z. Define R_W by omitting z before completion and
realize the completed z-enhancement in `K_W[[z]]`. The quantum matrices and
their finite z-jets are defined there; the required lattice argument is
unaffected. Do not replace the source by an unrestricted bulk completion.

### The maps

For the j-th center occurrence the reduced coefficient embedding is

```text
iota_j(X_d) = Q^(i_* d) q^(-rho.d/(c-1))
              exp((varsigma_j^(circ,(2)) + s_j^(2)).d),
iota_j(sigma') = varsigma_j^(circ,prime) + s_j',
iota_j(sigma^0) = varsigma_j^(circ,0) + s_j^0.
```

The fixed shifts are independent of t and s. Iritani Remarks 2.3/5.6,
(5.36), and (5.47) supply well-definedness on the reduced ring. The
source's first nonzero Novikov degree proves injectivity:

1. An ample class pulled back from Y restricts to an ample class on Z.
   A bounded-degree fibre of the untagged monomial map therefore contains
   finitely many numerical effective lattice points.
2. At one curve class, source coefficients in sigma',sigma^0 are polynomial:
   an element has finitely many homogeneous degrees, bounded unit degree,
   and all remaining even nondivisor coordinate degrees are negative.
3. At initial Novikov degree, only the zero-Novikov fixed shift enters.
   Polynomial translation in nondivisor/unit coordinates is injective over
   the Laurent coefficient field. The divisor shift gives nonzero scalar
   factors. These coefficients do not involve s_j^(2).
4. Distinct numerical classes have distinct divisor-pairing vectors. A
   one-parameter restriction separates the finite set of vectors; the
   derivatives at zero form an invertible Vandermonde matrix.

The same argument with zero shift proves injection into the reduced image
of (5.15)/(5.40) before translation. There is no recovery of information
after a genuinely noninjective quotient: the unrestricted source map and
its reduced-source restriction are different maps. The target divisor
characters must not be truncated to finite bulk order in this proof.

The ambient and blowup coefficient embeddings are Iritani (1.1),
(5.38) and (5.39). The invertible bulk-coordinate map in Section 5.8.2
identifies the presentation above with the original blowup coordinates.
This also handles the ambient term; only the center map needs the extra
divisor-character injection argument. After injection, fraction-field base
change is faithful. Primary factors are always formed over an algebraic
closure, so a later scalar extension cannot split an already-counted factor.

For a rank-r projective bundle, the corresponding target is
`C[z]((q^(-1/r')))[[Q,t_hat]]_hom`, with r'=r for r-1 even and r'=2r
for r-1 odd. Iritani–Koto (5.2) gives
`Q_B^d -> q^(-c1(V).d/r) Q^d`, explicitly an embedding. Their invertible
joint bulk Jacobian gives independent coordinates on the r copies of the
base. The same reduced-source/initial-degree argument permits their fixed
bulk shifts. Remarks 1.2 and 5.2 cover the line-bundle twist and the
intrinsic Novikov splitting. Remark 5.3 supplies the z-adic realization.

### Derivations and the lattice

On R_Z, divisor directions act as `D(X_d)=(D.d)X_d`; the nondivisor and
unit directions are the usual partial derivatives. In external coordinates
these are realized by the separate `partial_(s_j^alpha)` directions.
The Novikov logarithmic directions and q-direction include the chain-rule
terms from the fixed reconstruction parameters, exactly as in Iritani
(5.42)–(5.43) and Iritani–Koto Theorem 5.1. The z-direction keeps all
coefficient parameters fixed and is the actual intrinsic loop connection
`z partial_z - z^(-1)(E star) + mu` in each target factor.

The imported maps are connection-and-pairing isomorphisms, not merely
quantum-product algebra isomorphisms. Their parity-even constructions restrict
to even cohomology when odd coordinates are zero; the inverse is even too.
Their recorded homogeneous degrees (0/-c on the blowup terms and -(r-1)
for the projective-bundle map) are grading bookkeeping. Those degree statements
do not license separate integer shifts of residue eigenlines. The displayed
z-connection intertwinings are the stronger and decisive information.

Let M,M' be corresponding formal lattices after extension to F_c[[z]], and
let G be the regular comparison with regular inverse. Reduction at z=0
carries centered leading operators by G_0 and hence carries their image
lines L,L'. It follows directly from the definition that

```text
G({m in M : m mod z in L}) = {m' in M' : m' mod z in L'}.
```

Thus G induces an isomorphism of the canonical modified lattices. Reduction
of this modified isomorphism conjugates their regular-singular residues.
The conclusion is exact conjugacy in the source conventions. If an additional
convention adds a common scalar to both residue eigenvalues, their squared
difference is still unchanged. No independent eigenline shift is allowed.

**A useful first-jet detail:** in adapted frames with modification
`S=diag(1,z)`, if `G_0=[[alpha,beta],[0,epsilon]]`, then

```text
(S^(-1) G S)|_(z=0) = [[alpha,0],[(G_1)_21,epsilon]].
```

The residue-conjugating matrix is generally not G_0. This explains both why
the full connection comparison matters and why the first positive z-jet
cannot be discarded. The included checker verifies this identity and residue
conjugacy symbolically for a general linear-in-z regular gauge; the lattice
argument above proves naturality for every regular formal gauge.

Independent unit parameters shift the finite spectra in each comparison
summand independently. Their pairwise resultants are nonzero polynomials
in the unit differences. Consequently whole generic primary summands of
distinct copies do not merge. This is needed for either count.

## 2. Two local statements, with their hypotheses exposed

### Persistence of a cyclic double-primary cluster

Work over a characteristic-zero complete local formal bulk ring O, after
inverting the small-point Novikov parameters and making any needed separable
algebraic extension. Start with a rank-two spectral cluster separated from
the complement at the closed point, whose centered leading operator is a
nonzero rank-one nilpotent there. Formal spectral splitting supplies a
regular lattice for the whole cluster and its flat base equations. Center
the scalar exponential consistently in both loop and base equations.

Write

```text
A(z)=N/z + A_0 + z A_1 + ...,
B_partial(z)=C_partial/z + C_(partial,0) + ...,
partial A - z partial_z B_partial + [A,B_partial]=0.
```

Before nilpotence is known away from the closed point, a vector v with
v,Nv independent there remains a cyclic vector by Nakayama. The commutant
of N is O I + O N. The z^-2 flatness coefficient gives [N,C]=0; the
trace of the z^-1 coefficient, using tr N=0, gives tr C=0. Therefore
`C=q_partial N` with q_partial in O, without dividing by a function that
vanishes at the closed point. The next coefficient gives

```text
partial N = -q_partial N + [N, q_partial A_0-C_(partial,0)],
partial(N^2) = -2q_partial N^2 + [N^2,q_partial A_0-C_(partial,0)].
```

Coefficient recursion in the formal bulk parameters preserves N^2=0 from
its zero initial value. An entry of N nonzero at the closed point is a unit;
thus N has rank one throughout the formal germ. Its image/kernel line is a
direct summand. No exponent or discriminant assumption has been used.

This statement must not be replaced by “nilpotence is deformation invariant”
without the separated rank-two cluster, cyclicity, flatness, and regular
q_partial hypotheses. The current proof contains all these steps; named
statements would make their scope easier to check.

### Regularity and conjugacy of the modified residue

For an eligible rank-two block, pairing horizontality gives
`N^T P_0=P_0 N` and
`A_0^T P_0+P_0 A_0+N^T P_1-P_1 N=0`.
The nondegenerate even pairing makes L=im N isotropic with L^perp=L.
Evaluation of the second identity on L gives A_0 L subset L. In adapted
coordinates, the canonical modification has residue

```text
N=[[0,nu],[0,0]], A_0=[[a,b],[0,d]], (A_1)_21=c,
R=[[a,nu],[c,d-1]], nu a unit.
```

After modification, the only possible base pole is k E21/z. Flatness
gives `k E21+[R,k E21]=0`, whose diagonal entries are nu*k and -nu*k.
Hence k=0. The constant flatness coefficient is the Lax equation
`partial R=[G_partial,R]`. Trace, determinant and discriminant are constant.
Regular comparisons preserve them by the lattice argument in Section 1.
Again no nonresonance is used: nu, not the eigenvalue difference, kills
the residual base pole.

### Low-dimensional vanishing really is stronger

| Case | Reason the stronger count vanishes |
|---|---|
| Point | Only rank one. |
| P1 | Two simple generic eigenvalues; rank-one blocks. |
| Genus-one curve | Centered N=0. |
| Genus > 1 curve | The modified residue is `(2-2g)E21-I/2`, so delta=0 exactly. |
| Surface with nef canonical class | Centered Euler multiplication strictly raises degree; its whole even primary summand has rank at least three. |
| Minimal remaining surface | P2 is generically semisimple; a ruled surface is a projective bundle over a curve. |
| Nonminimal surface | Point blowups add only rank-one point factors. |

The surface degree inequality in the manuscript follows termwise from the
GW dimension axiom and c1.d <= 0. It holds with even bulk insertions, not
only at the small point. All Jordan blocks in its single eigenvalue sector
must stay together. Semisimplicity of P1/P2 persists from their small-point
relations by the nonzero characteristic discriminant. The minimal-surface
classification is retained as the same standard imported input; this audit
does not reread Beauville's book. Using the stronger operation formula to
prove ruled/point-blown-up surface vanishing is not circular: that formula
was established from comparisons before low-dimensional vanishing.

Therefore define I_lat by replacing the exponent-class exclusion with
delta != 0 on the same eligible whole blocks. Sections 1–2 give

```text
I_lat(Bl_Z Y)=I_lat(Y)+(c-1)I_lat(Z),
I_lat(P_Y(V))=rk(V) I_lat(Y),
I_lat(Z)=0 for dim Z<=2.
```

It follows that I_lat is birationally invariant for smooth projective
threefolds and fourfolds. The stronger discriminant spectrum follows by
the same blockwise argument and the existing differential-constant argument,
with nonzero complex discriminants as its indexing set. No rational
coefficient-model refinement or Fano-family quantum input is audited here.
In particular, this report does not yet assert the quartic-double-solid
application or the index-two classification.

## 3. Historical narrowing and negative controls

The exact historical source is
`notes/2026-08-21-epilogue-m1-red-team-referee.md`, especially its opening
verdict, formal-source audit, and Appendix C subsection 1(c). Its actual
conclusions are more qualified than the later repair summary:

- It correctly distinguishes residue separation from exponent-class separation.
- It explicitly confirms lattice-level regularity and inverse regularity of
  the cited comparisons in its formal-source audit.
- Its resonant cubic-fourfold value is for the ambient sub-QDM, not a
  counted whole small-point even primary factor. It states the whole factor
  has rank 24 and leaves its generic refinement uncomputed.
- The suggested narrowing aligns the count with the introduction's monodromy
  description; it does not disprove a separately named lattice invariant.

Keep I_exp with its current meaning. Do not silently redefine it as I_lat,
and replace the sentence “delta != 0 is insufficient” by “insufficient for
exponent-class separation.” That qualification is the precise repair.

The attached local checker also verifies two controls:

1. `diag(1,z)` is regular but has a nonregular inverse. “Regular comparison”
   must mean a lattice isomorphism, not just a matrix without negative powers.
2. Put `A_r=[[r,z^-1],[0,-r]]` and
   `F_r=[[z^r,-z^(-r-1)/(2r+1)],[0,z^-r]]`. For r=0 and r=2,
   `z F_r'=A_r F_r`, and F_r preserves the same sesquilinear hyperbolic
   pairing. The meromorphic comparison `F_0 F_2^-1` identifies the two
   connections, which have the same nonzero nilpotent leading matrix, but
   their canonical discriminants are 1 and 25. Their exponent classes are
   both [0],[0]. Thus retaining just the meromorphic connection, the pairing,
   and the leading Jordan type does not preserve the discriminant.

These are local formal examples, not counterexamples to either manuscript
or geometric QDM examples. They locate the exact role of the lattice.

## Evidence, read depth, and replay

Source metadata and source snapshots are pinned in
`2026-09-08-c1128-audit-sources.json`. Cached PDF bytes were rehashed against
their cache entries. The selected primary passages were read through cached
pdftotext and the matching versioned arXiv HTML; no figures or OCR scan
reconstructions were used.

| Source | Read depth and passages relied upon |
|---|---|
| Iritani, arXiv:2307.13555v3 | partial: (1.1), Theorem 1.1, Remarks 1.3–1.5; Sections 2.2–2.3 including Remark 2.3; Section 5.5.2/(5.15)–(5.20)/Remark 5.6; (5.36)–(5.43), Theorem 5.18; Section 5.8.2/(5.47)–(5.48). |
| Iritani–Koto, arXiv:2307.03696v4 | partial: Remark 1.2, Remarks 1.9–1.11; Section 5.1/(5.2)–(5.3), Theorem 5.1, Remarks 5.2–5.3. |
| Current m1 manuscript | partial: Sections 1–2, the threefold criterion in Section 3, and the constant-spectrum/intrinsic-formula statements in Section 4. |
| Historical 2026-08-21 red-team report | partial: opening verdict, formal-source audit, and Appendix C 1(c) plus persistence discussion. Its external cubic-fourfold calculations remain historical secondary evidence. |
| 2026-08-21 C910 repair report; 2026-09-07 C1116 foundations report | full text; used to locate previous decisions and repairs, not as substitutes for the primary comparison theorems. |
| 2026-08-19 C924 direct-QDM audit | partial: its proposed simplifications and dependency boundary. |
| Beauville, Complex Algebraic Surfaces, Chapter VI | secondary only: the current manuscript's use of the minimal-surface classification; not independently reread in this task. |

This audit makes no novelty or absence-of-prior-work claim. No forward-citation
closure was attempted. The source checks establish the hypotheses actually
used by the proposed lattice deduction, not publication priority.

Exact local replay, from `/home/tavis/src/othello`:

```sh
uv run --with sympy==1.14.0 python notes/2026-09-08-c1128-lattice-audit-checks.py
```

Generation adds `--write`. The committed JSON is deterministic. The checker
uses exact SymPy identities for the modification, first-jet conjugacy,
cyclic centralizer, nilpotence-transport identity, base-pole exclusion,
Lax discriminant identity, curve residue, and paired meromorphic control.
It independently checks one Vandermonde determinant with stdlib Fraction
elimination. The unrestricted local statements also have the hand proofs
above; there is no second symbolic engine, independent specialist reread,
or Lean kernel check. The finite computations do not prove the completions,
imported comparison theorems, formal-recursion existence, or geometry.

Script/output/source-ledger/proposal hashes and byte counts are committed in
`2026-09-08-c1128-audit.sha256.json`. The checksum manifest omits this report
and itself to avoid self-reference. No generated output was hand-edited.

## ej + tt closeout and Mystery ledger

Explicit ej pass: the cheap stronger result is the separate I_lat operation
and low-dimensional-vanishing statement above; neither requires a new finite
threefold calculation. This settles the originally assigned preservation
gate at the level of the audited inputs. Explicit tt pass: test what information
the comparison must retain. The paired meromorphic example shows that even
preserving N and pairing is insufficient; regularity of both maps is the
decisive stronger structure. Both upgrades are recorded and checked here.

- **Settled:** why the older “false positive” does not itself invalidate I_lat.
  It was an exponent-interpretation mismatch and a not-yet-counted ambient piece.
- **Settled:** whether resonant eigenvalues obstruct base regularity. The
  off-diagonal unit nu, not a nonintegral eigenvalue gap, forces k=0.
- **Settled:** which gauge coefficient conjugates the modified residue.
  It includes (G_1)_21; keeping only G_0 would lose the needed information.
- **Settled:** why all displayed normalized residues have trace -1. The
  constant pairing equation gives tr A_0=0, and modification subtracts one.
  The checker verifies the rank-two coefficient identity. This refers to the
  fixed paired normalization, before any additional common scalar convention.
- **Open, C1128 next audit:** verify the universal matrix normalization and
  primary quantum inputs for degree one/two before claiming new families.
- **Open, C1128 audit disposition:** direct generic cubic-fourfold refinement
  could independently stress-test the comparison consumption. No observed
  generic counted block or counterexample is supplied by the historical report.
- **Author decision pending:** whether to adopt the proposed manuscript
  presentation or any stronger theorem; the source files remain unchanged.

All observations above arose from the assigned audit questions; none requires
an incidental discovery-track entry. C1128 remains open for its later work
packages. The substantial 1–3 audit chunk is complete.

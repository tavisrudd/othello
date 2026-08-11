# Red team: Paper V and geometric epilogue plan

**Lane:** `clebsch`

**Date:** 2026-08-11

**Scope:** hostile review of
`2026-08-11-c904-paper-v-geometric-epilogue-plan.md`.  This is a publication-
architecture audit, not authorization to edit Papers I--V, their Lean
companions, or their public mirrors.

## Executive verdict

**MAJOR revision, with a strong surviving crown.**

The two-paper decision is right:

- Paper V should be the structural culmination of the reconstruction branch;
- the cubic/Chow/quantum theorem should be a self-contained unnumbered
  epilogue rather than a swollen Paper V or a Paper VI.

The proposed separation theorem remains genuinely high-level:

\[
Y_b=X_b\times\mathbf P^1
\quad\text{is universally }CH_0\text{-trivial and irrational}
\]

for a non-isotrivial family, with the stronger independent statement that
`X x P^1` is irrational for every smooth cubic threefold.  The fixed-fibre
Voisin implication is source-exact, and the enhanced sixth-root atom proof has
survived a theorem-level hostile audit with only local exposition repairs.

The current plan nevertheless does **not yet make the epilogue a logical
punchline of the series**.  It silently identifies three objects which are not
presently connected by one theorem:

1. the marked finite-field carrier reconstructed by Papers I--III and the
   existing Paper V;
2. a canonical integral rank-ten symplectic `A_5` carrier;
3. the integral polarized homology of the complex `A_5` cubic intermediate
   Jacobian.

The existing Paper V is an eleven-page theorem over `F_11`.  Its own claim
ledger marks the relative companion theorem over a localization of
`Z[sqrt(5)]` as unproved.  Reduction modulo eleven does not by itself recover a
unique integral lattice or principal polarization.  Theorem V.E in the plan is
therefore the load-bearing missing bridge, not a two-page extraction lemma.

Until that gap is repaired, the successor is a powerful paper inspired by the
series, but not forced by it.

## 1. The fatal conflation: finite, integral, and Hodge carriers

### 1.1 What Paper V currently proves

The frozen Paper V proves the marked companion round trip in characteristic
eleven:

- Paper II lands on the chordal member of the invariant cubic pencil;
- the singular quartic recovers the six matching axes;
- the normalized outer difference identifies the selected chordal line with
  the conference line;
- the marked transports are inverse on their declared image.

This is a precise finite-field result.  It does not presently construct an
integral variation of Hodge structure or a principally polarized abelian
scheme.

### 1.2 What the plan adds without proof

The planned formula

\[
\mathcal H=A_5^\vee e\oplus A_5f
\]

can be interpreted in three inequivalent ways:

1. a canonical abstract hyperbolic envelope of an oriented six-set;
2. an integral lift of the characteristic-eleven carrier;
3. the actual homology lattice of a cubic intermediate Jacobian.

Only the first can be obtained formally from an `A_5` six-set.  The second
needs an arithmetic spread-out or a universal property proving uniqueness of
the lift.  The third additionally needs a geometric realization theorem with
the correct principal polarization.  The six-axis form `6I-J` comes from the
cubic/Fano geometry; it is not automatically encoded in the finite companion
round trip.

Calling all three “the common integral carrier” hides the hardest causal step
in the whole proposed publication architecture.

### 1.3 Three honest repairs

#### Repair A: arithmetic Paper V

Prove the relative marked companion theorem over an explicit localization of
`Z[sqrt(5)]`, identify all bad primes, and construct the integral symplectic
envelope compatibly with the characteristic-eleven and complex fibres.

This is the strongest repair.  It makes the epilogue literally consume Paper
V's output.  It is also a substantial new theorem, and Paper V would likely be
24--32 pages rather than 14--18.

#### Repair B: canonical-envelope handoff

Keep Paper V finite and structural.  Let its output be only the oriented
`A_5` six-set and marked invariant pencil.  At the start of the epilogue,
define a functorial integral envelope of that finite object and prove its
universal property.  Then prove that the cubic axes realize this envelope with
form `6I-J`.

This is probably the best balance.  It preserves a short structural Paper V
while making the first theorem of the epilogue an exact bridge rather than a
narrative association.

#### Repair C: provenance only

Leave the two theories formally separate and say that the same abstract
`A_5` six-set appears in both.  The epilogue remains standalone and may still
be a very strong paper, but it should no longer be advertised as what the
recovered carrier “forces.”

The current plan oscillates between Repairs A and B without proving either.

## 2. Paper V theorem language needs categorical correction

### 2.1 “The same object” versus equivalence

The outputs of Papers I--III are not literally equal.  They are objects with
switching, relabelling, sheet, line, and orientation gauges.  The clean theorem
is an equivalence of explicitly marked groupoids, not the assertion that three
constructions produce “the same” object.

The round trips should be natural isomorphisms satisfying triangle identities.
Writing that the composites “are the identity” risks suppressing residual
automorphisms or choices of representatives.

### 2.2 Marking minimality is too broad

Theorem V.D claims that forgetting *any* load-bearing marking realizes the
corresponding ambiguity.  This is an independence theorem for the entire
marking lattice, stronger than the existing round-trip statement.  Unless the
stabilizer quotients are all proved exactly, restrict it to the two genuinely
load-bearing choices already established:

- selected chordal line;
- orientation/sheet sign.

The other marking boundaries can be a proposition or a table of known
automorphism quotients, with no assertion of logical independence.

### 2.3 V.E should move or weaken

Under Repair B, replace V.E by:

> The marked round trip canonically recovers an oriented `A_5` six-set and its
> invariant golden plane, functorially under the declared gauge.

The epilogue then owns the integral-envelope and polarization theorems.  This
keeps Paper V structural and prevents cubic geometry from entering through a
back door.

## 3. The exotic period theorem is overclaimed

The packet statement should say:

- three **`F_2`-rational** points of `P^1(F_4)`;
- one Frobenius-conjugate pair over `F_2`.

Calling the latter “non-rational slopes” is misleading because every point is
`F_4`-rational.

More importantly, the assertion that “the nonconstant principally polarized
realization of an exotic sheet is the intermediate-Jacobian variation” is a
uniqueness theorem not presently supplied by nonconstancy.  A nonconstant map
between irreducible curves proves dominance onto its image closure; it does not
identify parameter lines, degrees, boundary normalizations, or Hauptmoduln.

There are three safe levels.

1. **Minimum theorem:** the cubic period map lands in an exotic gluing sheet
   and is nonconstant.
2. **Strong theorem:** the normalization of its image closure is the exotic
   PEL curve, and the cubic parameter map is generically finite of a stated
   degree.
3. **Crown theorem:** the marked cubic base is identified with the normalized
   exotic PEL curve, including the boundary/cusp data.

The minimum theorem is enough for the family separation result.  The strong
or crown theorem is needed if the prose says that the recovered carrier
*forces* the cubic pencil.  The current plan uses crown language while
budgeting only the minimum proof.

## 4. The minimal-class spine is strong but needs one exact application lemma

The proposed primewise replacement of the saturation certificates is the
right compression.

- At `2`, squarefreeness of `x^2+x+1` puts the exotic graph slope under the
  proved semisimple graph-slope primitivity theorem, including at `p=2`.
- At `3`, the scalar/Jordan-scalar mixed-adjugate argument is the correct
  structural mechanism.
- Away from `2,3`, the lattice is unimodular.
- Local membership globalizes without a trace multiplier.

The publication proof still needs one proposition that writes the *actual*
exotic cubic homology lattice in the required local graph charts and checks
that the polarization and divided-power normalization used by the local
theorems are exactly those of `Theta^4/4!`.  Without that application lemma,
the plan replaces one certificate by two abstract theorems without proving
that the geometric lattice is their input.

This is a theorem-local gap, not a new research program.  It should be stated
as an acceptance gate and proved before any earlier paper promises the
epilogue.

## 5. The Voisin step is safe only in its fixed-fibre form

The source audit supports, for a smooth complex cubic threefold,

\[
\Theta^4/4!\text{ algebraic}
\quad\Longleftrightarrow\quad
CH_0(X)\text{ universally trivial}.
\]

Thus Theorem E.C is sound after E.B, fibre by fibre.  The epilogue should print
the exact chain of cited fixed-complex-fibre theorems rather than compressing
it to “apply Voisin.”

It must not claim:

- a horizontal minimal cycle;
- a relative integral universal cycle;
- a relative Chow decomposition over the pencil;
- descent over the function field of the base.

The plan currently respects this boundary.  Keep it.

## 6. The quantum theorem survives, but it is an independent spine

The hostile audit of the `X x P^1` argument is positive after two local
repairs:

1. use the integer multiplicity `nu_6` of primitive sixth-root formal
   monodromy eigenvalues, not a Boolean;
2. print the formal-isomonodromy lemma showing constancy along a connected
   reduced unramified spectral component, and identify Cai's rank-two block
   with the corresponding maximal big-quantum `F`-bundle block.

Then:

- the projective-bundle formula supplies two positive copies;
- every weak-factorization center has dimension at most two;
- point, curve, and surface atoms have `nu_6=0`;
- the additive free atom ledger prevents cancellation.

This proves `X x P^1` irrational for every smooth cubic threefold.

The result is not caused by the golden carrier.  It applies to all cubics.
The honest conceptual sentence is:

> the carrier constructs a family on which the diagonal obstruction vanishes,
> while a universal cubic atom shows that one stabilization remains
> irrational.

That is a strong conjunction.  It is weaker than saying the carrier itself
produces the quantum obstruction.

## 7. State the separation on one and the same variety

If `X` is universally `CH_0`-trivial, so is `X x P^1`.  The sharp headline
therefore concerns

\[
Y=X\times\mathbf P^1:
\qquad
Y\text{ universally }CH_0\text{-trivial but irrational}.
\]

The theorem should also record that `Y` is the first stabilization of a cubic
threefold.  This prevents the title from sounding like a generic supply of
universally `CH_0`-trivial irrational varieties, which is not the novelty.

Prefer “irrationality survives one stabilization” to “without one-step
rationality.”

## 8. The page budgets are too optimistic

### Paper V

- **Repair B:** 16--22 pages is realistic for a self-contained groupoid
  equivalence, human normalization proofs, and the finite output interface.
- **Repair A:** 24--32 pages is more realistic because arithmetic spread-out,
  bad-prime control, and integral comparison are genuine theorems.

Fourteen pages is possible only if Paper V remains close to its current
eleven-page form and does not own the integral bridge.

### Geometric epilogue

A referee-proof standalone paper needs approximately:

1. theorem and problem context -- 4--5 pages;
2. finite carrier and canonical integral envelope -- 6--8 pages;
3. exotic packet and cubic period realization -- 7--10 pages;
4. primewise minimal-class theorem and application -- 9--11 pages;
5. fixed-fibre Voisin consequence -- 3--4 pages;
6. enhanced atom and formal-isomonodromy lemma -- 6--8 pages;
7. low-dimensional centers and weak factorization -- 7--9 pages;
8. comparison and boundaries -- 2 pages.

**Realistic target:** 45--55 pages under Repair B.  A crown-level modular
normalization theorem can push it toward 55--65.  The proposed 38--42 pages
would force the paper to outsource exactly the two arguments most exposed to
referee attack.

## 9. Publication logistics and earlier-paper promises

The plan says that Papers I--IV are not published.  More precisely, Papers
I--III already have public GitHub/DOI versions; they may be strengthened only
by forward versions.  They may not be silently rewritten as if no public
predecessor existed.  Paper IV remains an active new-paper build.

Do not add the full epilogue promise to all four papers now.

1. Papers I--III may promise only the marked companion synthesis in Paper V.
2. Paper IV should retain one sentence identifying it as the independent
   lower branch; it has no causal arrow to the cubic theorem.
3. Paper V may announce the epilogue only after the finite-to-integral handoff
   and the quantum bridge are frozen.
4. Later forward versions of I--III may add a restrained retrospective pointer
   to the epilogue.

This avoids five manuscripts inheriting a failure if the recent quantum source
stack changes or the integral handoff does not close.

## 10. Venue verdict

### As currently planned

The paper is **Inventiones/JAMS-shaped, Annals-plausible but not yet truly
Annals-shaped**.  A hostile editor can describe it as the juxtaposition of:

- a special-cycle theorem for a symmetric cubic pencil; and
- an independent quantum obstruction valid for every cubic.

The series provenance alone does not defeat that objection.

### What makes it genuinely Annals-shaped

Require all four:

1. an exact finite-to-integral carrier handoff;
2. at least the strong period-realization theorem, not mere landing in an
   exotic sheet;
3. a self-contained special-case proof of the enhanced atom and all
   low-dimensional center exclusions;
4. a claim-specific priority audit showing that the non-isotrivial one-step
   separation answers the historical stabilization question in genuinely new
   form.

If these land, the paper gives one canonical mechanism producing a family on
which two central stable-birational detectors provably diverge.  That is a
credible Annals submission.

If only the endpoint conjunction lands, the theorem remains excellent but the
safer ceiling is Inventiones/JAMS.

## 11. Revised theorem architecture

### Paper V

1. Define the marked companion groupoids.
2. Prove their equivalence through one common marked carrier.
3. Prove the outer-difference bridge and natural triangle identities.
4. State the exact marking stabilizers actually used.
5. Output the oriented `A_5` six-set and golden plane.
6. Stop.

### Geometric epilogue

1. Construct the canonical integral envelope of the oriented six-set.
2. Classify its principal gluing packet as `P^1(F_4)`.
3. Prove the precise cubic period-realization theorem.
4. Prove primewise primitive minimal-class algebraicity.
5. Apply the fixed-fibre Voisin equivalence.
6. Prove the enhanced sixth-root stabilization theorem for all cubics.
7. Combine them on `Y_b=X_b x P^1`.

This architecture puts every genuinely geometric or integral theorem in the
epilogue and leaves V purely structural, as requested.

## 12. Revised acceptance order and kill criteria

### Acceptance order

1. Choose Repair A, B, or C explicitly.
2. Rewrite V's round trip as a groupoid equivalence.
3. Under Repair B, prove the canonical integral-envelope theorem.
4. Freeze the exact strength of the cubic period map.
5. Prove the geometric local-chart application of the primewise saturation
   theorems.
6. Print and independently review the special sixth-root atom proof.
7. Freeze the epilogue theorem, title, and priority claim.
8. Only then update promises in earlier-paper forward versions.

### Kill criteria

- If no exact finite-to-integral handoff is proved, do not call the epilogue
  what the reconstructed carrier “forces.”
- If only period-map landing is proved, say “an exotic realization,” not “the
  exotic realization.”
- If the special quantum proof cannot be made self-contained enough to survive
  changes in its recent source stack, publish the minimal-class/cubic-family
  theorem separately and do not promise the separation crown in Papers I--V.
- If V exceeds roughly 22 pages under Repair B, move all integral material to
  the epilogue rather than compromising the structural-only rule.

## Final verdict

The plan has the right two-paper shape and a potentially exceptional successor
theorem.  Its current weakest point is not Chow theory and not the sixth-root
argument.  It is the unproved claim that a finite companion reconstructed in
characteristic eleven already *is* the integral polarized carrier consumed by
the complex cubic geometry.

Repair that handoff explicitly--preferably by the canonical-envelope theorem
inside the epilogue--and the successor becomes a real culmination.  Leave it
implicit, and the same theorem package will read as two excellent but only
loosely connected papers.

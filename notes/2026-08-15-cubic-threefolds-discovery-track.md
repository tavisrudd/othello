# Cubic-threefolds discovery track

**Lane:** `cubic-threefolds`

Append-only catchment for incidental observations and musings noticed during
planned `cubic-threefolds` work — not a task queue, work list, or alternate
handoff. See `notes/discovery-track-conventions.md` for the boundary and
entry format.

Split off from `notes/2026-07-14-clebsch-discovery-track.md` on 2026-08-15
when the C907/C908/C909/C910/C911/C914 research program moved into its own
lane; that file's existing entries stay there as historical record and are
not copied here.

### 2026-08-18 — Guéré's heart invariant may give a second proof that no surface represents the cubic atom

**Provenance:** C917 source verification of Guéré, *On the irrationality of
cubic fourfolds*, arXiv:2603.04518v1, read while adding related-work prose.
**Was I looking for this?:** no — the task was to position the epilogue in
prose, with the proofs explicitly out of scope.
**Observed / musing:** Guéré's blowup-invariant property (his heart invariant,
the analogue of Katzarkov--Kontsevich--Pantev--Yu's club property) forces a
surface carrier to satisfy `c_1(K) = 0`, `h^{2,0} != 0`, and `h^1 = 0`, which
in his cubic-fourfold case pins the carrier to a K3 surface. The epilogue's
Proposition 4.17 excludes surface representatives of the cubic atom by a
different route: even parity rank at least three for nef-canonical minimal
models, plus the classification of minimal surfaces and the projective-bundle
formula for `P^2` and ruled surfaces. The two exclusions constrain the same
kind of object through unrelated numerics.
**Why it may matter / strongest question:** does Guéré's heart constraint,
applied to the rank-two even part of the cubic atom, give an independent
proof of Proposition 4.17 — and if it does, does it also survive to the
second stabilization, where the ordinary atom criterion fails because the
cubic atom already has a threefold representative? A surface-carrier
constraint that does not depend on the dimension bound in the ordinary
non-rationality criterion would be worth more than a second proof.
**Evidence:** OPEN — no attempt made; his evaluation maps are related to but
not identified with the atom construction, and the epilogue deliberately uses
only the ordinary, non-enhanced package.
**Recheck against Guéré v2 before use.** The heart invariant is read here from
arXiv:2603.04518v1, and Benedetti--Fay--Guéré--Manivel--Perrin Remark 4.2
announces a revision of that paper affecting exactly the evaluation-map
formalism this lead would rely on. Re-read the current version and confirm the
surface-carrier constraint still reads as stated before building anything on
it.
**Status:** open lead

### 2026-08-18 — a forthcoming revision of Guéré's paper is announced inside the joint criterion note

**Provenance:** C917 source verification of
Benedetti--Fay--Guéré--Manivel--Perrin, arXiv:2607.26718v1, Remark 4.2.
**Was I looking for this?:** no — the remark was read only to confirm that
nothing in it needed importing into the epilogue.
**Observed / musing:** their Remark 4.2 records a subtlety about maximal
spectra for evaluation maps defined relative to a blowup-center embedding
versus the identity morphism, and points to a forthcoming revision of Guéré's
paper. The epilogue is unaffected, since Section 4 uses no evaluation
argument.
**Why it may matter / strongest question:** any future lane work that does use
evaluation maps — including the lead logged above — should wait for or check
that revision before relying on the v1 evaluation formalism.
**Evidence:** CHECKED — read in the cached full text of arXiv:2607.26718v1.
**Status:** open lead

### 2026-08-18 — the spectrum-transfer proof needs no idempotent decomposition

**Provenance:** formalizing `lem:spectrum-transfer` of the cubic-stabilization
epilogue in Lean (`Quantum/ModuleSpectrumTransfer.lean`, terminal
`eulerMultiplication_eigenvalues_module_eq_algebra`).
**Was I looking for this?:** no — the task was to reach the manuscript's
conclusion in Lean by whatever route, not to shorten its proof.
**Observed / musing:** the manuscript proves equality of the eigenvalue sets by
decomposing the even algebra into generalized eigenspaces, extracting orthogonal
idempotents, and using nilpotence of `E - λᵢ` on each block. None of that is
needed. An eigenvalue on the full module makes `E - λ` a non-unit of the even
algebra; a non-unit of a finite-dimensional commutative algebra is a zero
divisor, which is an eigenvector inside the algebra. Conversely an eigenvector
of the algebra maps to a nonzero module element along the injection `b ↦ b · 1`,
which exists because the module structure restricts to the algebra's own
multiplication. Two lines, and it uses only finite dimensionality and that
injection.
**Why it may matter / strongest question:** it would shorten the corresponding
paragraph of Section 4 and remove a place where a reader has to check that each
`εᵢ M` is nonzero. The same non-unit argument may replace other spectral
bookkeeping in the atomic route, wherever the point is only which scalars occur.
**Evidence:** LEAN — the replacement argument is kernel checked for an arbitrary
finite-dimensional commutative algebra and a module with an injective unit
action.
**Status:** open lead

### 2026-08-18 — Mathlib has no unipotence of the exponential of a nilpotent element

**Provenance:** formalizing the nef-canonical clause of
`prop:direct-specialized-lowdim` of the cubic-stabilization epilogue in Lean
(`Quantum/ParityCorrectedUnipotentMonodromy.lean`, terminal
`specializedLowDimensional_exp_nilpotentResidue_unipotent`).
**Was I looking for this?:** no — the search was for an existing lemma to cite,
and the absence is the observation.
**Observed / musing:** at the pinned Mathlib revision nothing connects
`IsNilpotent x` to `IsNilpotent (NormedSpace.exp x - 1)`, in the matrix files or
the general exponential file; neither carries the word nilpotent at all. The
proof is short and needs no analysis beyond the tsum: with `x ^ k = 0` the
series is the finite sum of its first `k` terms, that sum is `1 + x * s` with `s`
a polynomial in `x`, and a commuting product with a nilpotent factor is
nilpotent. The statement holds verbatim in any topological ℚ-algebra where the
series is defined, not only for matrices.
**Why it may matter / strongest question:** it is the standard bridge from a
nilpotent residue of a regular-singular connection to unipotent monodromy, so
any later formalization of Levelt--Turrittin in this repository will want it,
and it is a small upstream contribution if the general form is proved. The open
question is how far the hypothesis can be weakened: for a topologically
nilpotent element the difference need not be nilpotent, so the finite-support
argument is the whole content.
**Evidence:** LEAN — the matrix form is kernel checked; the general
topological-algebra form is not stated.
**Status:** open lead

### 2026-08-18 — every separated-variable cubic threefold has an Eckardt point

**Provenance:** C914, while looking for a projective invariant separating the
nonstandard `A_5`-pencil from the Yang--Yu--Zhu coprime-degree family.
**Was I looking for this?:** no — the target was the Yang--Yu--Zhu comparison;
the separated-variable statement fell out of the same criterion.
**Observed / musing:** a point `p` of a smooth cubic threefold is an Eckardt
point exactly when the Hessian at `p` has rank at most two. If the equation is
a sum of cubic forms in pairwise disjoint groups of at most three variables,
then some group has size at most two; a point supported on that group and lying
on the threefold exists because a binary cubic has a root, and at such a point
every other diagonal Hessian block vanishes. So every member of
Colliot-Thélène's separated-variable class carries an Eckardt point. There is a
companion group-theoretic form: an Eckardt point produces an involution acting
on the ambient module with eigenvalue multiplicities `(4,1)`, so a cubic whose
automorphism group has no such reflection — for instance one with automorphism
group exactly `A_5` acting through `W_5`, where involutions have multiplicities
`(3,2)` — has no Eckardt point.
**Why it may matter / strongest question:** it reproves the epilogue's
Proposition `prop:A5-nonseparated` in three lines, replacing the present
argument through Hartlieb's closedness and irreducibility statements, and it
gives a cheap invariant for locating any explicit family against the
separated-variable class. Open question: which cubic threefolds with an Eckardt
point are *not* separated-variable, i.e. how far the converse fails.
**Evidence:** PROOF for both statements; the pencil side is computational, see
`notes/2026-08-18-c914-a5-pencil-vs-voisin-and-yyz.md`.
**Status:** open lead — promotion into the manuscript is a paper edit, not
allocated here.

### 2026-08-18 — the Hirzebruch Euler degeneracy is a degeneracy of the spectral cover, not of the eigenvalue map

**Provenance:** C920, while building an independent second route to the
discriminant of the odd Euler quartic of a Hirzebruch surface for the evidence
bundle `hirzebruch-euler-spectrum`.
**Was I looking for this?:** no — the task was to decide whether the specialized
Euler spectrum is separable at the centre specializations, and any correct
computation of the discriminant would have served.
**Observed / musing:** for odd index the four points of the specialized spectrum
are parametrized by the roots of `t^4 + w t^3 - u w^2`, through `S = t^2 / w` and
eigenvalue `2 t^2 / w + 3 t`, and that parametrizing quartic has discriminant
`-u^2 w^6 (256 u + 27 w^2)`.  Its degeneracy factor is exactly the factor
appearing cubed in the discriminant `-u^2 w^2 (256 u + 27 w^2)^3` of the Euler
quartic.  So the Euler spectrum degenerates precisely when the spectral cover
does, and never because the two-to-one map `t -> 2 t^2 / w + 3 t` identifies two
distinct points of the cover — even though that map is generically two-to-one
and a collision of the second kind is what one would expect to have to exclude.
**Why it may matter / strongest question:** it suggests that for a toric surface
the collision locus of Euler multiplication can be read off the spectral cover
alone, without forming the characteristic polynomial of the rank-four operator.
If that holds in general it would replace a quartic discriminant by a
lower-degree resultant in any similar specialization argument.  Strongest
question: for which toric surfaces is the eigenvalue map injective on the
spectral cover, and does injectivity have a fan-level characterization?
**Evidence:** CHECKED — the discriminant of the parametrizing quartic was
computed symbolically; the Euler discriminant is in the tracked certificate
`papers/cubic-stabilization-epilogue/verification/hirzebruch-euler-spectrum.json`.
**Status:** open lead

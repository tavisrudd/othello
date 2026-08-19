# Referee review: sharpening the A_5-pencil separation statements to a single exceptional point

Hostile review of the uncommitted change under `papers/cubic-stabilization-epilogue/`
(`git diff` plus the four untracked `verification/a5-pencil-eckardt-locus.*` /
`a5_pencil_eckardt_locus.py` files), dated 2026-08-19. Judged against
`papers/style-guide.md` and `notes/formal-annotation-conventions.md`.

## Verdict

The mathematics that was attacked mostly survives: the saturation is the right
operation, the Hessian is taken in legitimate coordinates, the coprimality of
`b^2+3b+9` with the singular-parameter polynomial is correct by hand, the
exclusion of `b=0` is sound, and both inclusions in `prop:A5-nonseparated` are
genuinely established. What does not survive is the write-up around it. The
proof of the headline theorem was not updated and still establishes only the old
finiteness statement, so as the tree stands `thm:separation-family` is stated
more strongly than it is proved. The paper's declared verification boundary
("No certificate, enumeration, or symbolic program is invoked as a premise") is
now flatly contradicted by the change, and no sentence anywhere in the
manuscript body discloses that a headline conclusion rests on an uncertified
Singular Groebner run — the disclosure lives only in `evidence.json`, and the
dependency graph carries no path from the new bundle to the theorem. The new
lattice remark contradicts itself within four lines ("it is not principally
polarized" / "the factor has exactly six principal polarizations") and, read
literally, closes the very route the surrounding prose says is open. Seven
further sites, including the abstract, still assert the superseded "all but
finitely many". The paper's own gate passes, which is the point: everything
below is in the prose the digests do not cover.

---

## 1. BLOCKER — the proof of `thm:separation-family` proves the old statement

**Location:** `sections/06-synthesis.tex:42-44`, inside
`\begin{proof}[Proof of Theorem~\ref{thm:separation-family}]`.

> Finally,
> Proposition~\ref{prop:A5-nonseparated} shows that all but finitely many
> points of this moduli curve lie outside the separated-variable locus.

The theorem it proves now reads (`sections/01-introduction.tex:167-170`):

> Every point of its coarse-moduli image
> except the one represented by the Fermat cubic threefold is not represented by
> any cubic whose defining form is a sum of cubic forms in disjoint groups of at
> most three variables.

The final clause of the theorem is strictly stronger than the final sentence of
its proof. The change sharpened the statement and left the proof behind. This is
not a stylistic lapse: as committed, the headline theorem is unproved.

**Required:** rewrite that sentence to invoke the sharpened
`prop:A5-nonseparated` and name the Fermat point. While there, note that this
proof carries no `\uses` annotation at all (`grep -n "uses{" sections/06-synthesis.tex`
returns nothing), which is the mechanism by which finding 2 became possible.

## 2. BLOCKER — the trust boundary is now misdeclared, and the graph hides it

Three separate failures, all one issue.

**(a) The verification README asserts the opposite of what is true.**
`verification/README.md:3-4`:

> The manuscript is intended to have a wholly human proof spine.  No certificate,
> enumeration, or symbolic program is invoked as a premise.

`verification/evidence.json` in the same diff says the spine is structural
"apart from three computations, all registered below". These two files
contradict each other, and the README was touched in this diff (the coverage
snapshot line) without the contradiction being fixed. Before the change one
could argue the Eckardt bundle only exhibited members and the finiteness was
structural; after the change the exact exceptional locus — and therefore the
final clause of a headline theorem — is the output of a Groebner elimination.
The claim is no longer defensible under any reading.

**(b) No sentence of the manuscript discloses the trust level.**
`grep -n "Singular\|trusted\|certificate" sections/*.tex cubic_stabilization_epilogue.tex`
returns nothing. The proof of `prop:A5-not-coprime` presents the computation as
plain mathematics (`sections/03-minimal-class.tex:511-514`):

> Saturating that ideal by the irrelevant ideal and eliminating the five
> coordinates gives \(b(b^2+3b+9)\), and doing the same for the Jacobian ideal
> alone gives the pencil's discriminant \(b(b+6)(b^2-3b-9)(7b^2+3b+9)\)

The style guide is explicit: "Say whether the claim is certificate-checked,
independently reproduced, or trusted as an execution," and requires the body to
carry enough to understand completeness. `evidence.json` correctly records
"trusted as an execution of Singular rather than certificate-checked"; the paper
does not. A referee reading only the manuscript cannot see the boundary.

**(c) The dependency graph has no path from the bundle to the theorem.**
`verification/dependency-graph.dot` records
`"a5-pencil-eckardt-locus" -> "prop:A5-not-coprime"` and
`"prop:A5-not-coprime" -> "prop:A5-nonseparated"`, but the only edge touching the
theorem is `"thm:separation-family" -> "prop:A5-not-coprime"` — the reverse
direction, inherited from the proof-level `\uses{lem:eckardt-rank,
thm:separation-family}` at `sections/03-minimal-class.tex:542`.
`thm:separation-family` carries no `\evidence` and its proof carries no `\uses`.
The graph therefore asserts, wrongly, that the headline theorem depends on no
computation.

**Required:** rewrite `verification/README.md:3-4` to state what is structural
and what is a trusted Singular execution; add one sentence to the body (in
`sections/03-minimal-class.tex`, at the elimination, or in the introduction's
verification paragraph) naming the trust category; add `\evidence` and/or the
missing `\uses` so the graph shows the dependency. Note that adding
`prop:A5-nonseparated -> thm:separation-family` while
`thm:separation-family -> prop:A5-not-coprime` stands makes the recorded graph
cyclic — the `B^\circ` reference in the proposition's proof should be detached
from the theorem first.

## 3. BLOCKER — `rem:four-dimensional-factor` contradicts itself and, read literally, closes the route it is introduced to keep open

**Location:** `sections/02-envelope.tex:699-706`.

> Consequently the four-dimensional factor has determinant \(25\) and
> polarization type \((1,1,1,5)\); it is not principally polarized.  Its
> discriminant group is canonically \(E[5]\), glued to that of the elliptic
> factor, and every subgroup of order five is isotropic, so the factor has
> exactly six principal polarizations, one for each of the six order-five
> subgroups of \(E[5]\).

"it is not principally polarized" and "the factor has exactly six principal
polarizations" cannot both describe the same object. The reasoning quoted —
isotropic order-five subgroups of the discriminant group — is the standard
descent construction, which produces six *principally polarized abelian
fourfolds isogenous to* the factor (the quotients by those subgroups), not six
principal polarizations on the factor itself. The remark names the wrong object.

This propagates into both rewritten sentences, which is why it is a blocker
rather than a wording slip. `sections/01-introduction.tex:345-347`:

> That would need both
> of the routes left open there to fail: no principal polarization of the
> four-dimensional factor of Proposition~\ref{prop:no-elliptic-product} may make
> it the Jacobian of an irreducible curve of genus four

and `sections/02-envelope.tex:675-679` likewise ("some principal polarization of
the four-dimensional factor of the second case may make it the Jacobian"). A
Jacobian is principally polarized. If the factor genuinely has no principal
polarization, as the remark states two sentences later, then route one is
*closed*, and the paper would be entitled to a stronger result than it claims.
Under the intended reading the route concerns the six quotients. As written the
manuscript says both things.

**Required:** decide which object route one is about, say so in one sentence,
and make the remark, the introduction, and the envelope discussion agree. "Six
principal polarizations" must become "six principally polarized abelian
fourfolds isogenous to it, one for each order-five subgroup of `E[5]`" or
equivalent.

## 4. SHOULD-FIX — `rem:four-dimensional-factor` asserts most of its content bare, with no proof, no computation pointer, and no annotation

Taking the claims in order, with what I could check:

| claim | status |
|---|---|
| `N = v^\perp = {x in Z^5 : sum x_i = 0}` with form `6<x,y>`, six times `A_4` | **derivable and correct**, granting the stated basis |
| splitting over `Z_2` and `Z_3` since 5 is a unit | **correct** |
| "the whole discriminant group is carried by `N`" | **correct** at 2 and 3, which is all that is used |
| `[Lambda : Zv + N] = 5` | **correct** |
| the four-dimensional factor has determinant 25, type `(1,1,1,5)` | **unsupported** |
| discriminant group canonically `E[5]`, glued to the elliptic factor | **asserted bare** |
| every order-five subgroup isotropic | correct, and trivially so (the pairing is alternating) |
| exactly six principal polarizations | **wrong object** (finding 3); "exactly" also unsupported |
| `D_5` acts through `\pm1` and fixes all six | **asserted bare**; given `\pm1`, "fixes all six" is immediate |

The first paragraph checks out and is internally consistent in a way that is not
automatic: if the five remaining axes are a basis with `kappa(v_i,v_i)=5`, the
form `6<x,y>` on the sum-zero sublattice forces `kappa(v_i,v_j) = -1`, and then
the sixth axis `-(v_1+...+v_5)` independently returns `kappa(v,v)=5` and
`[Lambda : Zv+N] = 5`. Good.

The second paragraph is where the problem is. "Consequently the four-dimensional
factor has determinant 25" does not follow from anything above it: `N` has rank
4 and determinant `6^4 * 5 = 6480`, whereas determinant 25 and type `(1,1,1,5)`
are statements about the alternating form on the rank-8 lattice of the abelian
fourfold `L cap (v^\perp \otimes M_Q)` from `prop:no-elliptic-product`. Those
are different lattices, and "Consequently" is carrying the entire passage
between them. The remark also uses "the four-dimensional factor" for both the
rank-4 lattice `N` ("the kernel ... lies inside the four-dimensional factor")
and the abelian fourfold, against the style guide's "Introduce one notation for
one role."

There is a tracked computation that presumably established some of this
(`notes/2026-08-19-c921-integral-glued-model.py`,
`notes/2026-08-19-c921-d5-genus-four-jacobians.py`), and the remark points at
none of it. Per `notes/formal-annotation-conventions.md`, `\evidence` records
the bundles a statement rests on; the remark carries no annotation of any kind.

Separately: **"whence the index \(25\) above" (`sections/02-envelope.tex:697`)
is a dangling back-reference.** `grep -n "25\b" sections/02-envelope.tex` finds
no occurrence of 25 earlier in the section. The reader is sent to a quantity
that is not there.

**Required:** either prove the determinant/type/discriminant-group chain or cite
the computation and register it as evidence; fix the dangling reference; stop
using one phrase for the lattice and the abelian variety.

## 5. SHOULD-FIX — "the pencil's discriminant" is the wrong object

**Location:** `sections/03-minimal-class.tex:513-515`, and
`verification/evidence.json` role text, and the claim-map cautions.

> doing the same for the Jacobian ideal
> alone gives the pencil's discriminant \(b(b+6)(b^2-3b-9)(7b^2+3b+9)\); both are
> squarefree.

The discriminant of a pencil of cubic forms in five variables is a binary form
of degree `5 * (3-1)^4 = 80`. What the elimination produces is the reduced locus
of singular parameters — the radical of the discriminant — a degree-6 polynomial.
Calling it "the discriminant" is a factual misstatement, and it invites a
referee to check a degree that will not match.

"both are squarefree" is decorative: nothing in the proof uses squarefreeness.
The coprimality argument in the next paragraph needs the two polynomials to
share no root, which is a different property.

**Required:** "the reduced locus of singular parameters", or "the radical of the
pencil's discriminant". Drop "both are squarefree" or say what it is for.

## 6. SHOULD-FIX — the elimination computes a closure; the proof never says so

**Location:** `sections/03-minimal-class.tex:508-513`.

> the parameters to be found are those for which the ideal generated by \(F_b\) and
> the three-by-three minors of its Hessian has a zero away from the origin.
> Saturating that ideal by the irrelevant ideal and eliminating the five
> coordinates gives \(b(b^2+3b+9)\)

Elimination gives the ideal of the Zariski *closure* of the projection, so the
displayed identification is `image ⊆ V(b(b^2+3b+9))` for free and the reverse
inclusion for nothing. The reverse is exactly the direction "Exactly two members
... carry an Eckardt point" needs.

It is true, and the fix is one sentence: the image is constructible by
Chevalley, its closure is finite, and a constructible subset of the affine line
with finite closure is finite hence closed, so image and closure agree. Without
it, a referee is entitled to say the proposition proves only "at most two".

Two related things that do **hold** and need no change, since they were the
obvious attacks:

- **Saturation by the irrelevant ideal is the right operation.** Over an
  algebraically closed field `V(I : J^\infty) = closure(V(I) \ V(J))`, so
  saturating by `(y_1,...,y_5)` removes exactly the zero section and nothing
  else, and by the argument above no spurious parameter survives. The script's
  docstring gets this right.
- **The Hessian is taken in legitimate coordinates.** `y_1..y_5` with
  `x_6 = -(y_1+...+y_5)` is a linear isomorphism onto the sum-zero subspace, and
  Hessian rank is invariant under linear change of coordinates
  (`H' = A^T H A`). Rank at most two transports. The 101 generators are `F`
  plus `C(5,3)^2 = 100` minors, as they should be.

## 7. SHOULD-FIX — the Fermat identification: one step is misstated and one citation over-reaches

**(a) `sections/03-minimal-class.tex:538-540`:**

> A conjugate of a form defined over \(\mathbf Q\) is
> projectively equivalent to it over \(\C\)

As literally written this is a triviality — the Galois conjugate of a form with
rational coefficients *is* that form — and it does not supply the step the proof
needs. `F_{3\omega}` is not defined over **Q**; it is defined over
**Q**(omega). The load-bearing statement is: if `X` is projectively equivalent
over **C** to a variety defined over **Q**, then so is every Galois conjugate of
`X`. That is true (apply sigma to the equivalence; the **Q**-form is fixed), and
it is what makes the two roots one moduli point. Rewrite it.

**(b) `sections/03-minimal-class.tex:506-507`:**

> They are the two
> Fermat members of Remark~\ref{rem:fermat-in-pencil}

`rem:fermat-in-pencil` (`sections/01-introduction.tex:186-205`) says:

> The pencil contains the Fermat cubic threefold; it is one of the two members
> that also admit the permutation action of \(A_5\)

That supplies **one** Fermat member, and its "two members" are the two admitting
the permutation action, of which the remark says only one is Fermat. The remark
does not contain "the two Fermat members"; that is the proposition's own
conclusion. The proof body gets this right — it derives the second member as a
Galois conjugate — so the fix is to stop attributing the conclusion to the
remark in the statement.

The argument the proof actually runs is sound: the Eckardt locus is `{0}` union
the two roots, `b=0` is singular, Fermat is a smooth member with an Eckardt
point, hence Fermat sits at a root. Good.

**(c) Model transport, unstated.** The `b` parameter lives in the six-point
model over **Q**; per `evidence.json` the Fermat form is exhibited in the
monomial model over **Q**(zeta_3). The proof moves "the pencil contains the
Fermat cubic threefold" between the two models without a word. One clause saying
the two models present the same pencil over **C** would close it.

## 8. SHOULD-FIX — seven sites still state the superseded "all but finitely many", including the abstract

The change updated the two propositions and the theorem and left everything that
describes them behind:

- `cubic_stabilization_epilogue.tex:94-95` (**the abstract**): "All but
  finitely many moduli points of this pencil lie outside the separated-variable
  locus covered by Colliot-Th\'el\`ene's criterion."
- `sections/01-introduction.tex:147`, the sentence immediately above the
  sharpened theorem: "all but finitely many moduli points represented by the
  pencil are not projectively equivalent to a cubic of separated-variable type."
- `sections/01-introduction.tex:331` and `:335`, the related-work survey, both
  "all but finitely many"; the second adds "the general member of the pencil
  carries none," which is now "every member but two".
- `sections/03-minimal-class.tex:619`: "All but finitely many moduli points of
  the pencil escape the separated-variable mechanism".
- `sections/06-synthesis.tex:43` (finding 1) and `:56`.

Plus two stale environment titles: `\begin{proposition}[Finite Eckardt locus]`
(`03:498`) and `\begin{proposition}[Finite separated-variable intersection]`
(`03:545`). Neither result is a finiteness statement any more.

Under the style guide's revision protocol ("Read only the theorem statements and
section openings. They should tell a coherent story"), the paper currently tells
two different stories.

## 9. SHOULD-FIX — the computation-free fallback no longer matches the statement it is attached to

**Location:** `sections/03-minimal-class.tex:574`.

> The order-three signatures give the same finiteness by a route that uses no
> computation.

It is no longer "the same". The signature route proves finiteness;
`prop:A5-nonseparated` now proves exactly one point. The value of the paragraph
— that the weaker conclusion survives without the registered computation — is
real and worth keeping, but the sentence must say that it gives *less* than the
proposition, so a reader knows precisely how much of the sharpened statement is
computation-dependent. This matters more after the change than before, because
the computation-dependent part is now load-bearing for the headline theorem
(finding 2).

The same defect is copied into the claim map: `prop:A5-nonseparated`'s
`hypotheses` field still reads "the order-three signature route printed after
the proof gives the same finiteness without any computation," while its
`conclusion` field was rewritten to "Exactly one moduli point".

## 10. SHOULD-FIX — claim-map rows: stale `hypotheses`, and a regression in `thm:separation-family`'s `cautions`

**(a) `lean/verification/claims.json`, `prop:A5-not-coprime`.** The `conclusion`
and `cautions` were rewritten; `hypotheses` was not, and still reads:

> Smoothness of the members, the Eckardt criterion of the preceding lemma, and
> the computed emptiness of the Eckardt scheme of the members listed in the
> registered evidence bundle.

The new proof does not use the emptiness of the Eckardt scheme of a list of
members at all; it uses the elimination over the whole pencil. The row's
recorded hypotheses describe the deleted proof. The digest gate cannot catch
this — it pins the statement and the terminals, not the row's own prose.

**(b) `thm:separation-family`'s `cautions` lost audit content.** Deleted:

> The typed irrationality input is the broader framed one-step input recorded
> under thm:every-cubic-conditional and does not use the A5 symmetry; the
> manuscript now takes its irrationality from the unconditional atomic route
> instead. Of its four clauses, the fibrewise triviality clause and the
> stabilization clauses are compositions of supplied premises with results
> registered elsewhere, and the non-isotriviality clause is the supplied
> predicate itself; the only clause consuming a nontrivial Lean argument is the
> irrationality one, through the one-step theorem.

None of that is implied by the new text, and it is exactly the kind of per-clause
audit the layer exists to carry. It should be restored alongside the new
separation-clause note.

What replaced it introduces a second problem: "since 2026-08-19 it is strictly
weaker than the manuscript statement" and "so the row is a fragment rather than a
conditional deduction until that field is sharpened" put a date-stamped timeline
and an open to-do into what is supposed to be a current-state record. State that
the Lean statement carries the finiteness shape and the manuscript names the
Fermat point; the pending work belongs in the task card.

The coverage move `conditional_deduction -> fragment` is itself right and
correctly propagated to `01-introduction.tex:151`, `dependency-graph.dot`, and
both README snapshots. The gate passes:
`PASS mode=source-only ... evidence=3 coverage={'absent': 3, 'complete': 1, 'conditional_deduction': 27, 'fragment': 28}`.

## 11. SHOULD-FIX — the evidence entry over-claims its cross-checks

`verification/evidence.json`, `a5-pencil-eckardt-locus.role`, and the matching
`cautions` in the claim map:

**(a) The `F_32003` cross-check has no tracked artifact.** The role says "the
same eliminations over F_32003 return the same Eckardt polynomial and the same
factor shape for the discriminant", and the claim map says "the registered
bundles record two independent cross-checks". Neither
`verification/a5-pencil-eckardt-locus.sha256` (three files, all from the run over
**Q**) nor `notes/2026-08-19-c921-pencil-tests.sha256` (seven files, none over
`F_32003`) contains any output of that run. It exists only as a prose sentence at
`notes/2026-08-19-c921-pencil-level-structure-and-eckardt.md:115` and `:235`.
`notes/research-reproducibility-conventions.md` is explicit that a claimed run is
never evidence. Either track the output or delete the claim.

**(b) The finite-field sweep is described as more than it is.** The role says the
enumeration over `F_11, F_19, F_29, F_31, F_41` "finds the same two loci". It
enumerates `P^4(F_q)` and therefore finds only `F_q`-rational Eckardt points; at
`q=11` and `q=29` it finds none at all, because `b^2+3b+9` is irreducible there
(`notes/2026-08-19-c921-pencil-eckardt-sweep.txt`). It corroborates the reduction
mod p, which is worth having, but "finds the same two loci" overstates a
rational-point count.

**(c) No toolchain version.** The replay command is
`nix shell nixpkgs#singular --command Singular -q ...` with no pin. The style
guide requires "toolchain version ... and archival version" for a trusted
execution. This matters here in a concrete way: see finding 12(c).

## 12. SHOULD-FIX — defects in the tracked artifacts themselves

Checksums verify and the generator reproduces the `.sing` byte-for-byte
(`sha256sum -c` passes; regeneration diffs clean). The problems are elsewhere.

**(a) The tracked `.sing` names a generator outside the paper.**
`verification/a5-pencil-eckardt-locus.sing:3` reads

> // notes/2026-08-19-c921-eckardt-elimination.py

while the registered generator is `verification/a5_pencil_eckardt_locus.py`. The
two differ only in their docstrings. `notes/formal-annotation-conventions.md`
requires that "every file the manuscript or its gate needs must live inside" the
paper directory, since the standalone export copies only that directory. A
replayer following the artifact's own header lands outside it.

**(b) The output's legend contradicts its own numbers.** The `.txt` prints

> dimension of its singular locus (-1 empty, so smooth):
> -2

and the same mismatch for the Eckardt scheme. Singular returns `-1` for the
dimension of the unit ideal, so an empty projective scheme prints `-2` after the
`- 1`. The value is right and the legend is wrong. A reader auditing the
certificate cannot tell whether `-2` means empty or means something went wrong —
which is the whole job of the legend. Fix the legend (or drop the `- 1`).

**(c) About 130 of the ~150 lines of the tracked certificate are
`// ** redefining ...` warnings** emitted by `LIB "primdec.lib";`. The script
calls no primary-decomposition routine — `sat` comes from `elim.lib`, `minor`
and `factorize` are builtins — so that library appears to be unused. Dropping it
would make the certificate readable and, more importantly, much less brittle:
as it stands the tracked SHA-256 changes on any Singular library update, for
reasons having nothing to do with the mathematics. Worth confirming the run
still works without it before removing.

**(d) JSON formatting.** The new `a5-pencil-eckardt-locus` block in
`evidence.json` is indented at 3/1 spaces against the file's 4/6, so the diff
shows the neighbouring `a5-pencil-eckardt` key as changed when only its position
moved.

## 13. MINOR — a loose end the sharpening creates and does not address

`prop:A5-not-coprime` now concludes "no other point is represented by a cubic
projectively equivalent to a member of the family of [YYZ]" — correctly hedged,
saying nothing about the Fermat point. But `rem:fermat-in-pencil` records that
"Yang--Yu--Zhu give that member an explicit degree-three unirational
parametrization \cite[Remark~3.6]{YYZ}". Whether the one exceptional moduli point
lies in the YYZ family is now the first question a referee will ask, and the
paper does not answer it. One sentence either way.

## 14. MINOR — the paragraph introducing the computation is superseded

`sections/03-minimal-class.tex:490-497`:

> The general member of the pencil carries no such point.  That is a
> computation, recorded in the evidence bundle named in the next proposition

This still advertises the older, weaker bundle (explicit members, empty Eckardt
scheme) and never mentions the elimination that now actually proves the
proposition. After the change it is orientation for a proof that no longer runs
that way. Either fold it into the new argument or cut it; the style guide's
"Delete repetition, throat-clearing" and "Preserve hierarchy" both apply.

## 15. MINOR — "wholly human proof spine"

`verification/README.md:3`. A trust boundary should name what is structural
argument and what is a trusted program execution. Labelling the proofs by who
wrote them tells a reader nothing about what is checked, and it is what made the
sentence in finding 2(a) survive a change that falsified it.

---

## What I checked and found sound

Stated briefly so these are not re-litigated.

- **Coprimality (attack 3) holds; verified by hand.** `b^2+3b+9` against each
  factor of `b(b+6)(b^2-3b-9)(7b^2+3b+9)`: at `b=0` it is `9`; at `b=-6` it is
  `36-18+9=27`; against `b^2-3b-9` the difference is `6(b+3)` and at `b=-3` it is
  `9`; against `7b^2+3b+9` the combination `7(b^2+3b+9)-(7b^2+3b+9)` is `18(b+3)`,
  same conclusion. No common root, so both Eckardt members are smooth. The
  identification of the roots as `b = 3\omega` is also right:
  `(-3 \pm 3i\sqrt3)/2 = 3 \cdot (-1 \pm i\sqrt3)/2`.
- **Excluding `b=0` (attack 2) is argued correctly.** `X_0` is singular, hence
  not in `B^\circ`, hence not a candidate for "smooth member with an Eckardt
  point". Restricting `lem:eckardt-rank` to smooth members is legitimate: an
  Eckardt point is defined through the tangent hyperplane section, which needs
  smoothness at `p`, and the lemma's proof uses `L \neq 0` exactly there. Two
  small gaps: that `p_3` restricted to the sum-zero subspace *is* the Segre cubic
  is stated nowhere in the manuscript, and its singularity is asserted without
  citation. Both are standard; one clause each would close them.
- **Both inclusions of `prop:A5-nonseparated` (attack 5) are established.**
  `\subseteq` runs through `lem:eckardt-rank`, whose proof does cover the
  separated-variable case explicitly (`03:469-479`, including the `3,1,1` and
  `1,1,1,1,1` partitions), into `prop:A5-not-coprime`; `\supseteq` is the Fermat
  form as five singleton groups. This one is clean.
- **The elimination's construction is right** in the two ways attacked:
  saturation by the irrelevant ideal, and the Hessian in `y_1..y_5`. See
  finding 6.
- **The lattice arithmetic in the remark's first paragraph is correct**, and
  internally consistent in a nontrivial way. See finding 4. `E[5]` does have
  exactly six order-five subgroups, and all are isotropic for an alternating
  pairing.
- **The gate passes and the coverage snapshots agree** across
  `lean/README.md`, `verification/README.md`, and `claims.json`. Which is the
  point of finding 8: every defect above lives in prose the digests do not
  cover, and `notes/formal-annotation-conventions.md` names that blind spot
  ("The digests cover theorem-like environments and terminals, not the prose
  between them"). This change is a live instance of it.

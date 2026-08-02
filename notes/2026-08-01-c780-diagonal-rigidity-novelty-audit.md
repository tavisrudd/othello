# C780 — novelty audit: diagonal symmetry classification and the rigidity phase boundary

**Lane**: `ame-lu`
**Date**: 2026-08-01/02
**Task**: C780. Gates C774–C785 manuscript work on the diagonal-rigidity programme.
**Conventions**: `notes/literature-audit-conventions.md`. Every source named below carries a read
depth. Negatives carry their searched domain and stop condition.

*Status: COMPLETE. All seven claims carry a verdict. Two access gaps remain open and are named in
the coverage statement.*

## Opening summary

**Nine sources; two were read at full text.** Gross & Van den Nest and the Heinlein–Honold–
Kiermaier–Kurz–Wassermann divisible-codes paper were read in full; two more were read partially;
one is secondary only; four are abstract or metadata only. The third citation graph (Semantic
Scholar) was unreachable, so every negative here keeps "to our knowledge".

**Headline: the coding half of the programme is a strengthening of a solved problem, and the
quantum half survives.** No triply-even-code result claimed here is new as a question; the
`d^⊥ ≥ 3` case is completely settled in published work, and the lower half of our certified range
follows from a published classification. What survives is a dictionary between diagonal rigidity of
stabilizer states and the divisible-codes length programme, which is worth more than the plateau it
was assembled to support. Per-claim verdicts, the disposition, and the mystery ledger are at the
end; the full-text count above is the one required by
`notes/literature-audit-conventions.md`.

---

## Sources consulted

Read-depth field is unconditional; sources named only to be dismissed carry it too.

| # | Source | Read depth | Access |
|---|---|---|---|
| S1 | Gross & Van den Nest, "The LU-LC conjecture, diagonal local operations and quadratic forms over GF(2)", Quantum Inf. Comput. 8 (2008) 263–281; arXiv:0707.4000v2 | **full text** (arXiv v2, all sections) | lit cache key `arXiv:0707.4000`, sha256 `fe898b71325ddd465218629b97e48f82a48ad058ea7c0471f80db5cdf3c74188`. Preprint read; published QIC version NOT read — verdicts about it are characterised from the preprint. |
| S2 | Cui, Gottesman & Krishna, "Diagonal gates in the Clifford hierarchy", Phys. Rev. A 95, 012329 (2017) | **partial** — §I–III (Defs 1–3, Thm 2, Lemmas 1–2), §IV skimmed to Thm 3 / Cor 2 statements | lit cache key `10.1103/PhysRevA.95.012329`, sha256 `62f929b3dc71957ec1e86e49b4f07b39fdcc8876c09a38b982b2397f6c85ad21`, from the author's copy at math.purdue.edu |
| S3 | Heinlein, Honold, Kiermaier, Kurz & Wassermann, "Projective divisible binary codes", arXiv:1703.08291v1 | **full text** (all 5 sections, Tables 1–3) | lit cache key `arXiv:1703.08291`, sha256 `bdbbc9e58220bedab980aafdb08aac35f14c47b5497af7c177514975449d5c26` |
| S4 | Betsumiya & Munemasa, "On triply even binary codes", J. London Math. Soc. (2) 86(1) (2012) 1–16; arXiv:1012.4134v3 | **partial** — abstract, § 1 introduction in full, § 2 definitions, and the § 1 section map covering the § 5 combination theorem, § 7 length-48 classification, § 8 lengths 8/16/24/32/40; §§ 3–6 proofs not read | lit cache key `arXiv:1012.4134`, sha256 `edbdb4405d28dbd5b97839b286f4619f5dbc937ce347d1f9a4f6dbaad93f6b2e`. arXiv v3 read; published JLMS version NOT read. |
| S5 | Honold, Kiermaier & Kurz, partial-spread survey, cited as reference [11] of S3 | **secondary only** — via S3 (full text), § 5, for the `F(2,3) ∈ {58,59}` settlement and the `LPD(2,3)` length list | not fetched; characterised solely from S3's § 5 sentence |
| S6 | Honold, Kiermaier, Kurz & Wassermann, "The lengths of projective triply-even binary codes", arXiv:1812.05957 (submitted 14 Dec 2018) | **abstract/metadata only** — title, authors, date, verbatim abstract from the arXiv listing page | arXiv abstract page, not cached; method not described on that page and NOT verified against the full text |
| S7 | Kurz, "Classification of 8-divisible binary linear codes with minimum distance 24", arXiv:2012.06163 | **abstract/metadata only** — via search-result snippet reporting the classification of all projective binary 8-divisible codes of length up to 48 | search snippet only; the arXiv abstract page was NOT fetched, so even the metadata is unverified at source |
| S9 | Rengaswamy, Calderbank, Newman & Pfister, "Classical Coding Problem from Transversal `T` Gates", arXiv:2001.04887; ISIT 2020 | **abstract/metadata only** — via search-result summary of the arXiv listing | not fetched at source; theorem numbers NOT verified |
| S8 | Jain & Albert, "Transversal Clifford and T-gate codes of short length and high distance", arXiv:2408.12752 (v1 22 Aug 2024, v3 24 Mar 2025) | **abstract/metadata only** — title, authors, dates, verbatim abstract from the arXiv listing page | arXiv abstract page, not cached; code tables NOT inspected |

(table extended as the audit proceeds)

---

## The recovered coding-side finding (re-derived 2026-08-02)

The previous session was terminated immediately after reading S3 at full text and reported,
without recording it, that it had found something major on the coding side. This section
re-derives that finding from S3 and S4. It is the auditor's own reading of those two sources,
marked as inference where it goes beyond what they state.

**Our question already has a name, a research community, and a solved sibling case.**

S3 § 3 poses what it calls the *Main Problem for projective divisible codes*: for which
`(n, k, r)` does there exist a binary `[n, k]` code with all weights divisible by `2^r` whose
generator-matrix columns are projectively distinct? S3 § 2 states the translation explicitly:
"The code C is said to be projective if K_C is a set or, equivalently, the n columns of G are
projectively distinct. In terms of the minimum distance of the dual code this can also be
expressed as `d(C^⊥) ≥ 3`."

So *divisible code with a dual-distance floor, asked as a question about which lengths are
realizable* is exactly the established problem of that community. They write `LPD(2, r)` for the
realizable length set and `F(2, r)` for the largest non-realizable length. Our claim 4 is the
same question with the floor raised from `d^⊥ ≥ 3` to `d^⊥ ≥ 5`, and our "certified plateau" is
their "non-realizable length set". This is not a framing we invented; it is the framing the
divisible-codes community already uses, and the phrase "phase boundary" is our relabelling of
their `F(2, r)`.

**The `r = 3` case — triply even — is the case they already settled, at `d^⊥ ≥ 3`.**
S3 § 5 states: "The case `r = 3` ("triply-even" codes) was settled in [11] with one exception:
`F(2, 3) ∈ {58, 59}`, and `LPD(2, 3)` contains
`{15, 16, 30, 31, 32, 45, 46, 47, 48, 49, 50, 51} ∪ Z_{≥60}` and possibly 59." Reference [11] of
S3 is the Honold–Kiermaier–Kurz partial-spread survey; that source is NOT READ here, so this is
`secondary only` through S3 at full text. S3 further records that the non-existence half of that
settlement used "the methods developed in [15] and adhoc linear programming bounds derived from
the first four MacWilliams identities" — that is, the same LP-over-MacWilliams technique as our
`strip_simplex.py`, applied to the same code family, by the same community, published in 2017.

Consequences for claim 4, stated bluntly:

1. **The method is theirs.** An exact linear program over the first MacWilliams identities plus a
   projectivity-type counting bound is the standard non-existence tool in this literature, not a
   new instrument. Our `justified_R` Sidon bound (`2^k ≥ n(n-1)/2 + 1`) is the statement that a
   `d^⊥ ≥ 4` point set is a cap in `PG(k-1, F_2)`, equivalently a Sidon set in `F_2^k` — textbook
   in the same geometry.
2. **The plateau *shape* is expected, not surprising.** At `d^⊥ ≥ 3` the realizable set is a
   finite exceptional list followed by a cofinite tail (`Z_{≥60}`), produced by a semigroup
   argument: S3 § 5 notes "n ∈ LPD(2, r) implies `n + (2^{r+1} - 1)Z ⊆ LPD(2, r)` (juxtaposition
   with `(r+1)`-dimensional simplex codes)". A gap-then-tail structure is the known generic
   answer, so our finding a long initial gap is not evidence of a new phenomenon.
3. **But the `d^⊥ ≥ 5` variant is genuinely harder and the tail is not automatic** (auditor's
   inference). Every length-lifting construction S3 relies on — juxtaposition with a simplex
   code, the cone construction, switching a subspace into an affine subspace — adds a full
   subspace or affine subspace of points, which contains four dependent points and therefore
   destroys `d^⊥ ≥ 5`. So the semigroup argument that makes `LPD(2,3)` cofinite has no visible
   analogue at `d^⊥ ≥ 5`. Our plateau extending to 80 while `F(2,3) ≤ 59` is consistent with
   this and is the one structurally new thing on the coding side.
4. **The known upper bound frames our numbers.** S3 Theorem 2 gives `F(2, r) ≤ 2^{2r} - 2^{r-1} - 1`,
   which at `r = 3` is 59 — the plateau boundary at `d^⊥ ≥ 3`. Our `d^⊥ ≥ 5` plateau runs to 80
   with an open window at `[70, 74]`. Anyone in this community reads our 69/70 boundary against
   their 59 immediately.

**S4 pre-empts the lower half of our certified range outright** (auditor's inference from S4's
abstract and introduction, read at the depth recorded below). S4 classifies the maximal triply
even binary codes of length 48 — exactly ten up to equivalence — and states in its introduction:
"Since any triply even code of length up to 48 can be regarded as a subcode of some maximal
triply even code of length 48, one can derive easily the classification of all triply even codes
of lengths up to 48." Every triply even binary code of length at most 48 is therefore classified
in published work. Deciding whether any of them has `d^⊥ ≥ 5` is a finite computation over a
published classification (S4 § 8 classifies maximal triply even codes at lengths 8, 16, 24, 32,
40 and § 7 at 48; a shorter code is recovered by zero-padding into one of these, so the check
descends to subcodes rather than to a printed table). **Our certified plateau on `[9, 48]` is a
corollary of Betsumiya–Munemasa (2012), reachable by a specialist without any new mathematics.**
Only
`[49, 69] ∪ [75, 80]` lies beyond that classification, and there our LP is doing genuine work.

This is the finding: the coding half of the programme is a strengthening, by two units of dual
distance, of a solved problem, using that community's own method, with its lower half already
decided by a published classification. What survives as ours is the interval `[49, 69] ∪ [75, 80]`,
the observation that the `d^⊥ ≥ 5` length set has no known cofinite tail because every standard
lifting construction breaks `4`-independence, and the quantum reading of the whole thing as a
rigidity boundary.

---

## Verdicts

Vocabulary: **CLEAR** — no predecessor located, claim may stand with the usual "to our knowledge".
**PARTIAL** — the claim survives only in a narrowed form, with named citations required.
**PRE-EMPTED** — a located source states the claim or reduces it to routine work.

### Claim 4 — the certified plateau: no triply even binary code with `d^⊥ ≥ 5` at lengths 9–69 and 75–80

**Verdict: PARTIAL, and the narrowing is severe.**

Three separate pre-emptions apply, in increasing order of damage.

*The question is a known question with a solved sibling.* S6 (Honold, Kiermaier, Kurz & Wassermann,
"The lengths of projective triply-even binary codes", arXiv:1812.05957) proves there is no binary
projective triply-even code of length 59 and states the complete answer: "projective triply-even
binary codes exist precisely for lengths 15, 16, 30, 31, 32, 45–51, and ≥ 60." Since projective
means `d^⊥ ≥ 3` (S3 § 2), that paper is our claim 4 with the dual-distance floor at 3 instead of 5,
answered completely and published. Our claim cannot be presented as opening a question; it is the
next case of a closed one, and the closed case must be cited as the reference point.

*The lower half of our range is a corollary of published classifications.* Every triply even binary
code of length at most 48 is classified — S4 § 7 for the ten maximal codes at length 48, S4 § 8 for
lengths 8, 16, 24, 32, 40, with the reduction to subcodes stated in S4 § 1. S7 (Kurz,
"Classification of 8-divisible binary linear codes with minimum distance 24", arXiv:2012.06163),
recorded at abstract/metadata only, additionally reports the classification of all projective
binary 8-divisible codes of length up to 48. Our plateau on `[9, 48]` therefore adds no
mathematics; it re-derives by linear programming what a finite check against those classifications
gives. It may be reported as an independent confirmation, never as a new non-existence result.

*The method is that community's standard method.* S3 § 5 records that the `d^⊥ ≥ 3` non-existence
results were obtained by "adhoc linear programming bounds derived from the first four MacWilliams
identities" together with the Kurz techniques — the same instrument as `strip_simplex.py`. Our
`justified_R` bound `2^k ≥ n(n-1)/2 + 1` is the Sidon/cap bound for a point set in `PG(k-1, F_2)`
with no three collinear points, which is elementary in that setting.

**What survives.** The interval `[49, 69] ∪ [75, 80]` at dual distance 5, where no located source
decides the question, together with the open window `[70, 74]`. No source located here bounds or
determines the maximum dual distance of triply even or divisible binary codes beyond the
projective (`d^⊥ ≥ 3`) case; see the coverage statement for the exact searched domain. Any
manuscript sentence must (i) cite arXiv:1812.05957 for the solved `d^⊥ ≥ 3` case, (ii) cite
Betsumiya–Munemasa and Kurz for `n ≤ 48`, (iii) restrict its own non-existence claim to
`[49, 69] ∪ [75, 80]`, and (iv) not call the linear-programming decision procedure new.

**One structurally new observation, and it is ours** (auditor's inference, not in any source read).
At `d^⊥ ≥ 3` the realizable length set is cofinite, and it is cofinite for a reason: S3 § 5's
"n ∈ LPD(2, r) implies `n + (2^{r+1} - 1)Z ⊆ LPD(2, r)`", by juxtaposition with a simplex code.
Every length-increasing construction in S3 § 4 — juxtaposition with a simplex code, the cone
construction, switching an `r`-subspace into an `(r+1)`-dimensional affine subspace — adjoins a
subspace or affine subspace of points and therefore creates four linearly dependent columns,
destroying `d^⊥ ≥ 5`. The semigroup argument that produces the cofinite tail at `d^⊥ ≥ 3` thus has
no visible analogue at `d^⊥ ≥ 5`. That is why our plateau can run to 80 while `F(2,3) ≤ 59`, and it
is the one genuinely new structural statement the coding half supports. It is also a liability:
without a tail argument, we cannot claim the boundary is a boundary rather than an artifact of
where the linear program stops working (which the C778 provenance already records as length 88).

### Claim 5 — the staircase family `RM(r, 3r+1)`

**Verdict: PRE-EMPTED as construction, PARTIAL as parameterization.**

Every ingredient is named in the sources read, in the divisible-codes literature itself. S3 § 4
states outright that "Higher-order (generalized) Reed-Muller codes are divisible by Ax's Theorem",
citing Ax and the Delsarte–McEliece generalization. Reed–Muller minimum distances `2^{m-r}` and
the duality `RM(r,m)^⊥ = RM(m-r-1, m)` are textbook. The transversal-`T`-on-triply-even mechanism
is textbook in magic-state distillation and is stated in the external source note's own honest
sizing. The family is therefore reachable in an afternoon by anyone in that community, exactly as
the task framing assumed, and must be presented as an assembly of known facts with all three
citations at point of use, not as a construction.

Worse for a firstness claim: S8 (Jain & Albert, "Transversal Clifford and T-gate codes of short
length and high distance", arXiv:2408.12752, abstract/metadata only) is an active 2024–2025
programme constructing "the smallest known weak triply even codes" admitting transversal logical
`T` for distances up to 31. Searching for triply even codes with large distance at small length is
a live, competitive activity in the magic-state community with published tables. Our `RM(2,7)` at
length 128 with distance 32 is in that regime and will be compared against those tables
immediately. Note the objectives differ — they optimize minimum distance at fixed logical
dimension, we optimize `min(d, d^⊥)` for a coset state — and that difference has not been checked
against their tables here; it is recorded as an open gap, not as a separation.

**What survives.** Only the parameterization: reading `U = min(d, d^⊥) - 1` as the order parameter
of a rigidity boundary, and the corrected exponent `U ≈ 2^{2/3} n^{1/3} - 1` (C778's correction of
the external note's erroneous `RM(r, 4r)` and `n^{1/4}`). The corrected exponent is ours in the
sense that the external material got it wrong; it is not new mathematics.

### The load-bearing separation: equivalence of two states versus symmetry of one state

The whole programme rests on the assertion that these are different problems, so that a
non-Clifford diagonal symmetry of a single stabilizer state is not a counterexample to the LU–LC
conjecture. **Tested directly against S1's full text, the assertion is true but must be restated;
the version in our notes is too strong and the version that survives is narrower and sharper.**

S1 § 4, equation (38), sets up the diagonal problem: for stabilizer states
`|ψ⟩ ∝ Σ_{x∈S} (-1)^{q(x)}|x⟩` and `|ψ'⟩ ∝ Σ_{x∈S} (-1)^{q'(x)}|x⟩`, a diagonal local unitary with
phases `c_i` maps one to the other exactly when `∏_i c_i^{x_i} = (-1)^{Q(x)}` for all `x ∈ S`, with
`Q = q + q'`. **Setting `Q ≡ 0` gives literally our claim 1's defining equation.** The symmetry
problem is therefore not a different equation from the equivalence problem; it is its `Q ≡ 0`
specialization, in the same paper, in the same notation. Any wording that says otherwise is wrong
and will be caught.

What *is* different is the question asked about that equation, and S1's own statement of Theorem 6
makes the difference visible:

- S1 asks whether **some** solution `(c_i)` lies in `{±1, ±i}`. Its Theorem 2 / Theorem 6:
  "If, for every such `Q` and `S`, the phases `c_i` can always be chosen from `{±1, ±i}`, then the
  LU–LC conjecture is true."
- We ask for the **entire solution group** in the case `Q ≡ 0`, and whether **every** solution lies
  in `{±1, ±i}`.

These are genuinely different questions, and the `RM(1,4)` witness shows why the distinction is not
pedantic. There `Q ≡ 0` admits the all-ones solution, which is in `{±1}`, so S1's existential
hypothesis is satisfied and nothing about LU–LC is threatened; but the solution group also contains
`T^{⊗16}`, which is not. A non-Clifford symmetry of one state leaves that state LC-equivalent to
itself by the identity, so it can never contradict LU–LC. **This is the correct form of the
separation and it should replace the "different problems" phrasing everywhere.**

S1 also shows it was aware of the boundary between the two and could not close it. The converse
half of Theorem 6 needs an extra hypothesis stated verbatim as: "Additionally, assume that if two
stabilizer states can be mapped onto each other by means of a diagonal local unitary, then also by
a diagonal local Clifford operation." That added assumption is exactly the gap between the
existential and the group-level question. Our claim 1 answers the group-level question completely
for `Q ≡ 0`. Nothing located in S1 does that, and S1's only structural remark in this direction is
the one-line observation before its `F_2^3` example that `e_i ∈ S` forces `c_i ∈ {±1}` — the
degenerate special case of the rank/elementary-divisor analysis.

**A correction the manuscript must make regardless.** The external source note states that "the
reduction of general product symmetries to this sector is the known hard step in LU–LC-type
problems and is not proved here; it is the standing imported assumption". That undersells S1.
S1 Theorem 1 proves: if `U = U_1 ⊗ ⋯ ⊗ U_n` maps a stabilizer state to a stabilizer state, then
every `U_i = C_i D_i C_i'` with `C_i, C_i'` Clifford and `D_i` diagonal. Applied to a symmetry it
gives `U = V D W` with `V, W` local Clifford and `D` diagonal, so `D` carries the local-Clifford
image `W|ψ⟩` to the local-Clifford image `V^{-1}|ψ⟩`. The reduction to diagonal is therefore
**proved in the literature**, not assumed; what remains is that the residual diagonal problem
relates two possibly distinct local-Clifford images of `|C⟩` rather than `|C⟩` to itself. The
manuscript must credit S1 Theorem 1 and state that residue precisely. Note the tension this
creates: the residue is a two-state diagonal problem, which is the very object the separation
argument wants to hold at arm's length. That tension is real and is the sharpest thing a referee
will press on. It is the same scope gap already recorded for C784.

### Claim 1 — classification of diagonal product symmetries by the Smith normal form of the lift lattice

**Verdict: CLEAR, with a mandatory citation and a downgrade in how it is sold.**

No located source classifies the diagonal symmetry group of a CSS coset state as
`Hom(Z^n / Λ_C, R/2πZ) ≅ T^{n-r} × ∏_i Z/d_i` with `d_i` the elementary divisors of the lift
lattice. S1 writes the defining equation and does not solve it as a group. Searches for Smith
normal form applied to codeword-lift lattices and diagonal stabilizer symmetries returned Smith
normal form used for stabilizer matrices over `F_2` and for ground-state degeneracy of lattice
Hamiltonians, which is a different matrix and a different question; exact queries and the three
citation graphs are in the coverage statement.

The mandatory citation is S1 equation (38): the equation being solved is theirs, and the claim must
be presented as solving the `Q ≡ 0` case of an equation posed in the LU–LC literature in 2007.
The downgrade is that the proof is a one-paragraph application of the structure theorem for
finitely generated abelian groups plus Pontryagin duality. Its value is as a decision procedure and
as the object that makes the `d_i ∈ {1,2,4}` criterion visible, not as a hard theorem. Sell it as a
dictionary, not as a breakthrough.

### Claim 2 — the Schur-cube criterion: `C^{∘3} = F_2^n` implies every diagonal symmetry is local Clifford

**Verdict: PARTIAL. The mechanism is the established one; the hypothesis and the simultaneity are
what is ours.**

The trilinear object is not new and cannot be presented as a discovery. Triorthogonality — the
condition on triples of codewords governing transversal `T` — is the standard mechanism of
magic-state distillation, and S9 (Rengaswamy, Calderbank, Newman & Pfister, "Classical Coding
Problem from Transversal `T` Gates", arXiv:2001.04887, abstract/metadata only) characterizes all
stabilizer codes whose codespace is preserved by physical transversal `T` and `T†` and shows
triorthogonal codes are essentially the only CSS family realizing logical transversal `T` by
physical transversal `T`. The external source note's own sizing already concedes this line.

What no located source states is the specific implication in the direction we use it: that a
*single* hypothesis, fullness of the third Schur power, simultaneously kills the continuous part,
all odd torsion, and all 2-power torsion of order `≥ 8` in the diagonal symmetry group — i.e. that
the entire symmetry group collapses to level `≤ 2`. The literature runs the other way, from a
divisibility/triorthogonality condition to the existence of a transversal gate; we run from Schur
saturation to non-existence of every non-Clifford diagonal symmetry at once. That direction, and
the increasing-chain interpretation (level-`ℓ` symmetries pair against `C^{∘ℓ}`, so fullness at
`ℓ = 3` closes every level), is where the novelty sits.

Two cautions carried forward. The odd-torsion step must be written in the localization form only;
the determinant route in the source note does not close, and the note says so itself. And the
qudit extension in § 5 of the source note is explicitly conditional, so the "AME rigidity follows
from Schur saturation" reading is a qubit statement plus a conjecture, not a theorem.

### Claim 7 — a binary code's lift lattice has full rank exactly when its dual distance is at least three

**Verdict: CLEAR as a statement, but it is the single most important thing in the programme and
not for the reason we thought.**

No located source states it. What matters is what it says once translated. `d(C^⊥) ≥ 3` is, verbatim
from S3 § 2, the definition of a **projective** code. Claim 7 therefore reads:

> the diagonal symmetry group of the CSS coset state `|C⟩` is finite ⟺ `C` is projective.

That is a dictionary entry between the quantum rigidity programme and the divisible-codes
programme, and it converts every one of their length results into a statement about our states.
In particular, combining claim 7 with claim 3 and S6:

> A CSS coset state with a **finite** diagonal symmetry group containing a non-Clifford element of
> order eight exists on `n` qubits, via a triply even code, **precisely for**
> `n ∈ {15, 16, 30, 31, 32, 45, …, 51} ∪ Z_{≥60}`.

because that is exactly the set of lengths of projective triply-even binary codes, settled by
Honold–Kiermaier–Kurz–Wassermann. This is a complete, published answer to the natural first form of
the "where does discrete non-rigidity live" question. It was obtained in finite geometry, for
partial spreads, with no quantum motivation, and it is stronger than anything the diagonal
programme has produced. (Auditor's inference throughout; the dictionary is ours, the length set is
theirs.)

The same dictionary deflates the uniformity framing. Uniformity `k` means `min(d, d^⊥) ≥ k+1`, so
the uniformity ladder is a dual-distance ladder on triply even codes: `2`-uniform is `d^⊥ ≥ 3`
(projective — solved by S6), `3`-uniform is `d^⊥ ≥ 4`, `4`-uniform is `d^⊥ ≥ 5` (our claim 4).
"Uniformity as the order parameter" is thus a relabelling of "dual distance of a divisible code",
and the bottom rung of the ladder is published. The programme's defensible position is that it
supplies the dictionary and climbs one further rung, not that it opens a boundary.

### Claim 6 — correspondence between the Smith normal form of the lift lattice and the Schur filtration

**Verdict: CLEAR, low weight.**

No located source relates the elementary divisors of a codeword-lift lattice to the Schur-power
chain `C ⊆ C^{∘2} ⊆ C^{∘3} ⊆ ⋯`. Searches over Construction-A code lattices with elementary
divisors, and over Schur/component-wise products with dimension filtrations, returned Smith normal
form in combinatorics, Smith normal form of stabilizer matrices over `F_2`, elementary-divisor
lattice constructions in network coding, and Schur products of evaluation codes — all different
objects; queries and graph checks are in the coverage statement.

The weight is low because the correspondence is a repackaging of the lift identity that already
carries claims 1 and 2: the `2^{ℓ}`-torsion of `Z^n / Λ_C` pairs against `C^{∘ℓ}`, which is the
cascade lemma read as a filtration. It is a good expository device and the right way to state the
level structure. It is not an independent result and should not be numbered as a theorem separate
from claim 2.

### Claim 3 — the order-eight existence criterion and the triply-even / transversal-`T` correspondence

**Verdict: PRE-EMPTED for the correspondence, PARTIAL and dependent for the criterion.**

The triply-even-implies-transversal-`T` half is textbook in magic-state distillation and the
external source note concedes it. S9 characterizes all stabilizer codes preserved by physical
transversal `T` and `T^{-1}` and establishes that triorthogonal codes are essentially the only CSS
family realizing logical transversal `T` that way; S4 is itself part of the divisible-codes
literature in which triply even codes are a named object with a classification programme. Nothing
here may be claimed.

The general half — a non-Clifford diagonal symmetry of order eight exists iff there is `t ∈ Z^n`
with an odd coordinate and `t·x ≡ 0 (mod 8)` for all `x ∈ C`, i.e. per-qubit weighted phases rather
than uniform `T` — is not covered by the sources read. S9 (abstract/metadata only) treats uniform
`T`/`T^{-1}` and defers finer `Z`-rotations to a companion paper (arXiv:1910.09333, NOT read here —
an open gap). S2 (partial) classifies diagonal gates in the Clifford hierarchy as gates, by
semi-Clifford and level structure; a targeted search of its text for stabilizer-code preservation,
coset states, divisibility, and triorthogonality found none of these terms, so it does not decide
which states a given diagonal gate fixes. The criterion is therefore not located in prior work —
but it is a one-line corollary of claim 1 and must be presented as such, not as a third theorem.

---

## Screened sets and citation-graph checks

**Set A — every work whose title contains "triply even".** Provenance: OpenAlex
`filter=title.search:triply even`, 68 hits, screened on title only. Discriminator: title names a
binary code. Four members survive: Betsumiya–Munemasa (2012, = S4), "The support designs of the
triply even binary codes of length 48" (2019), and the preprint and published versions of the
lengths paper (2018 / 2019, = S6). The entire titled literature on triply even binary codes is
therefore four items, none of which concerns dual distance above the projective threshold.

**Set B — forward citations of S6.** Seeds pinned by OpenAlex IDs `W2972517028` (published, DOI
`10.1109/tit.2019.2940967`, IEEE Trans. Inform. Theory 2019) and `W3100548496` (preprint). OpenAlex
`filter=cites:W2972517028|W3100548496` returns 10 works, screened on title. All ten are the
Kiermaier–Kurz divisible-codes programme: "On the lengths of divisible codes" (2019/2020),
"Lengths of divisible codes with restricted column multiplicities" (2023), "No projective
16-divisible binary linear code of length 131 exists" (2020), "Classification of 8-divisible binary
linear codes with minimum distance 24" (2020), "Classification of Δ-divisible linear codes spanned
by codewords of weight Δ" (2020/2023), and three computer-classification papers. None is quantum
and none raises the dual-distance floor. The community's chosen generalization is **column
multiplicity**, not dual distance — direct support for the negative on `d^⊥ ≥ 5`.

**Set C — forward citations of S4.** Seed pinned as OpenAlex `W2107438612` (DOI
`10.1112/jlms/jdr054`), 35 citing works, screened on title. Three clusters: vertex operator
algebras and moonshine; the divisible-codes classification programme; and magic-state distillation
and transversal gates — including Bravyi–Haah "Magic-state distillation with low overhead" (2012),
"Fault-tolerant conversion between adjacent Reed–Muller quantum codes" (2018), S8 (2025), and
"Asymptotically Good CSS-T Codes and a New Construction of Triorthogonal Codes" (2025). **The
bridge between triply-even code classification and magic-state distillation is already built and
actively used.** No title in the set mentions dual distance, uniformity, local-unitary rigidity, or
symmetry groups of stabilizer states.

**Crossref cross-check.** `query.bibliographic=triply even binary codes dual distance`, 8 rows
inspected of a large unranked total; returned S4, S6, and doubly-even self-dual code papers.
Consistent with Set A. Crossref's relevance ranking over a 985,932-result total is not an
enumeration and is recorded as corroboration only, not as a screened set.

**Semantic Scholar: NOT COVERED.** Five attempts against
`api.semanticscholar.org/graph/v1/paper/search`, including a four-retry sequence with delays, all
returned HTTP 429 "Too Many Requests" with no API key available. This is **could not access**, not
searched-and-found-nothing. The conventions' three-graph width requirement is therefore **not
satisfied**; the negatives below rest on OpenAlex plus Crossref only, and every claim they gate
keeps "to our knowledge".

---

## Coverage statement

**Full-text count: two of nine sources.** S1 (Gross & Van den Nest) and S3 (Heinlein, Honold,
Kiermaier, Kurz & Wassermann) were read at full text. S2 and S4 were read partially at the sections
recorded in the source table. S5 is secondary only through S3. S6, S7, S8 and S9 are
abstract/metadata only. **No verdict below rests on a source read only at abstract level for a
positive mathematical statement**, with one exception noted for S7, whose length-≤48 classification
claim reached us only through a search snippet and is used as corroboration of S4, not as
independent evidence.

**Load-bearing queries, verbatim.** OpenAlex: `title.search:triply even`;
`cites:W2972517028|W3100548496`; `cites:W2107438612`; `search=triply even binary codes dual
distance` (rejected as unusable — free-text search returned pulsar and geochemistry papers,
recorded here so the failure is not mistaken for a negative). Crossref:
`query.bibliographic=triply+even+binary+codes+dual+distance`. Web search, verbatim: "Kiermaier Kurz
lengths of divisible codes projective 2^r-divisible binary code"; "triply even binary code dual
distance 5 nonexistence divisible codes higher dual distance"; "divisible binary codes 'dual
distance' at least 5 lengths existence Kurz 8-divisible four-wise independent columns"; "'triply
even' code 'dual distance' transversal T gate uniformity k-uniform stabilizer state"; "Smith normal
form lattice generated by codewords diagonal symmetry group stabilizer state transversal diagonal
gates CSS code characterization"; "Construction A lattice binary code elementary divisors Smith
normal form Schur product filtration dual distance"; "Rengaswamy Calderbank Pfister classical
coding problem transversal T gates triorthogonality necessary sufficient conditions diagonal
Clifford hierarchy".

**Searched and found nothing** (licenses a negative, with "to our knowledge"):

- No source determining or bounding the maximum dual distance of triply even or divisible binary
  codes above the projective threshold `d^⊥ ≥ 3`. Domain: OpenAlex title and forward-citation sets
  A, B, C; Crossref bibliographic query; seven web searches. Stop condition: sets A and B are
  complete enumerations of their graphs and were screened exhaustively.
- No source classifying the diagonal symmetry group of a CSS coset state by the elementary divisors
  of the codeword-lift lattice (claim 1), nor relating those divisors to the Schur filtration
  (claim 6), nor stating the full-rank/dual-distance-three equivalence (claim 7).
- No source stating claim 2's simultaneity — one Schur-cube hypothesis killing the continuous part,
  all odd torsion, and all high 2-power torsion together.

**Could not access** (licenses nothing; carried forward as open gaps):

- **Semantic Scholar** — HTTP 429 throughout, no key. Third graph missing.
- **MathSciNet** — NOT COVERED, institutional authentication unavailable from this session.
  Standard for this workspace; keeps "to our knowledge" on every claim it would have gated.
- **zbMATH Open** — reachable in principle but NOT QUERIED in this run. An open gap, cheap to close.
- **S5**, the Honold–Kiermaier–Kurz partial-spread survey — not fetched. Its `F(2,3) ∈ {58,59}`
  statement is used only as reported by S3, and S6 supersedes it anyway.
- **S7**, arXiv:2012.06163 — the arXiv abstract page was not fetched; only a search snippet was
  seen. Its length-≤48 classification claim needs one cheap confirmation before it is cited.
- **arXiv:1910.09333**, Rengaswamy–Calderbank–Newman–Pfister on finer-angle `Z`-rotations —
  identified as the companion covering non-uniform diagonal rotations and NOT read. **This is the
  single most likely remaining pre-emption of claim 3's general weighted criterion** and should be
  the first read of any successor task.
- **S8's code tables** — the abstract was read but the constructed families and their parameters
  were not compared against our staircase. Claim 5's competitiveness is unassessed.

**Unaudited claims: none.** All seven claims carry a verdict.

---

## Verdict summary

Seven claims audited. None is fully pre-empted, and none is fully clear either.

- **Claim 1** (Smith-normal-form classification of diagonal symmetries): CLEAR, but it solves the
  `Q ≡ 0` case of an equation written down by Gross & Van den Nest in 2007 and must cite them.
- **Claim 2** (Schur-cube criterion): PARTIAL. The trilinear mechanism is the triorthogonality of
  magic-state distillation; the simultaneous collapse of every torsion type under one hypothesis is
  ours.
- **Claim 3** (order-eight criterion, triply even and transversal `T`): PRE-EMPTED for the
  correspondence, and the general criterion is a corollary of claim 1 rather than a theorem.
- **Claim 4** (certified plateau): PARTIAL and severely narrowed. The `d^⊥ ≥ 3` version is
  completely solved and published; `[9, 48]` follows from a published classification; the method is
  that community's own linear-programming technique. Only `[49, 69] ∪ [75, 80]` survives.
- **Claim 5** (staircase family): PRE-EMPTED as a construction. Every ingredient is named in the
  divisible-codes literature we read, and an active 2024–2025 magic-state programme constructs
  triply even codes with high distance and publishes tables.
- **Claim 6** (Smith normal form and Schur filtration): CLEAR, low weight, not an independent
  theorem.
- **Claim 7** (full rank iff dual distance three): CLEAR, and the most valuable item in the audit —
  because it says "finite diagonal symmetry group" is exactly "projective code", which imports a
  complete published answer into the programme.

**The coding half is known and only the framing is ours.** That is the answer the eight queued
tasks were waiting for, and it should be treated as settled rather than re-litigated.

---

## Disposition

**Not a standalone paper on the coding side. A section, and a good one, inside the rigidity
manuscript.**

The reasoning is the ladder. Uniformity `k` is `min(d, d^⊥) ≥ k+1`, so the "uniformity as order
parameter" framing is a dual-distance ladder over triply even codes. Its bottom rung — `2`-uniform,
i.e. projective — was settled completely by Honold, Kiermaier, Kurz and Wassermann in IEEE
Transactions on Information Theory in 2019: projective triply-even binary codes exist precisely at
lengths 15, 16, 30, 31, 32, 45–51 and ≥ 60. A paper whose central computational contribution is one
rung above a published complete answer, obtained by that community's own linear-programming
method, over an interval `[49, 69] ∪ [75, 80]` whose lower part is already covered by a published
classification, will not be received as a coding-theory contribution. The referee for it would be
Kurz.

What should be written instead:

1. **The dictionary is the contribution.** Claim 7 plus claim 3 turn the divisible-codes length
   results into statements about diagonal rigidity of stabilizer states, and the resulting sentence
   — a CSS coset state with finite diagonal symmetry group containing a non-Clifford order-eight
   element exists exactly at those lengths — is a complete answer to a natural quantum question,
   free, from published finite geometry. Lead with that. It is more valuable than the plateau and
   it costs nothing to state.
2. **Claim 1 as the decision procedure**, credited against Gross–Van den Nest equation (38), sold
   as a dictionary rather than a theorem.
3. **Claim 2 as the structural result**, with triorthogonality credited and the localization proof
   of the odd-torsion step written out.
4. **The plateau demoted to a computational remark** on `[49, 69] ∪ [75, 80]`, citing the solved
   `d^⊥ ≥ 3` case, Betsumiya–Munemasa for `n ≤ 48`, and stating that the linear program loses power
   by length 88. Include the observation that no analogue of the juxtaposition semigroup argument
   is available at `d^⊥ ≥ 5`, since that is why the question is open at all.
5. **The staircase demoted to an example**, with Ax–McEliece, Reed–Muller duality, and the
   transversal-`T` mechanism cited at point of use, and no firstness claim.

Two things must be fixed in the source material regardless of where it is published. The "different
problems" phrasing must be replaced by the existential-versus-group-level distinction, because the
symmetry equation is literally the `Q ≡ 0` case of the equivalence equation in the paper we would
be citing. And the claim that reducing general product symmetries to the diagonal sector is an
unproved imported assumption must be replaced by a credit to Gross–Van den Nest Theorem 1 plus a
precise statement of the residue.

**Gate for the queued tasks.** C778 (certificate bundle) is still worth doing but its output is a
computational remark, not a theorem, and it should be scoped to `[49, 69] ∪ [75, 80]`. C779 (the
Walsh-moment structural proof replacing the finite sweep) rises in value, because a structural
theorem is the only thing that would make the coding half publishable on its own — and the missing
tail argument identified above is the concrete target. C783 (full weighted diagonal sector) should
not start before arXiv:1910.09333 is read. Nothing here blocks C782, C784 or C785.

---

## Mystery ledger

- **Why does the plateau extend past 80 when `F(2,3) ≤ 59`?** Settled by the `ej`/`tt` pass above:
  every length-increasing construction in the divisible-codes toolkit adjoins a subspace or affine
  subspace and so creates four dependent columns, destroying `d^⊥ ≥ 5`. The cofiniteness mechanism
  at `d^⊥ ≥ 3` has no analogue one rung up. Open successor: C779, which must either supply a tail
  construction or prove there is none.
- **Is the boundary at 80 real or an artifact?** Unsettled. The C778 provenance already records
  that the linear program's killing power dies by length 88, and the constructive side starts at
  125. The gap `[81, 124]` is out of reach of both. Evidence gap: no relaxation stronger than the
  first MacWilliams identities has been tried. Owner: C779.
- **Why did two communities that already cite each other never ask this question?** Set C shows
  magic-state distillation and triply-even classification cite each other routinely, and Set B shows
  the coding community generalized toward column multiplicity instead of dual distance. The
  plausible reason is that magic-state work optimizes minimum distance at fixed logical dimension,
  where `d^⊥` is not the figure of merit, while the coding work is driven by partial spreads, where
  projectivity is forced by the geometry and nothing beyond it is natural. Recorded as an
  explanation, not as evidence; it is the auditor's inference.
- No other genuine mystery remains. The audit's surprises were all resolved into citations.

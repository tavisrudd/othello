# Outcome classes of the Nofil/cap achievement game on finite geometries

> **Superseded packaging notice (2026-07-23).** This early skeleton contains
> stale fixed-q trust rows, especially q=23 and q=25, and predates the current
> reproducibility and literature-audit conventions.  Use
> `notes/2026-07-23-c551-cap-paper-flagship-packaging.md` for the authoritative
> theorem/trust ledger and
> `notes/2026-07-23-c551-cap-paper-manuscript-skeleton.md` for the current
> architecture.  This file remains a historical source of proof-outline
> material only; its evidence table and novelty wording are not
> manuscript-licensed.

Status: manuscript skeleton for D1; not a submission draft.  Every mathematical or
bibliographic claim carries an evidence tag.  Proofs are deliberately stubbed.

## Evidence tags

- **[LEAN]** proved in the cited Lean source.  This tag certifies the formal statement, subject
  to the ordinary specification-match caveat between the formal game and the intended rules.
- **[PROVEN-PROSE]** supported by a proof in the project notes but not asserted here as a Lean
  theorem.
- **[COMPUTED]** solver or independent-checker evidence; not a theorem merely because the
  computation completed.
- **[COMPUTED, PARTIAL]** a sizing or representative computation that does not determine the
  board's outcome.
- **[CONDITIONAL]** depends on an open conjecture or an explicitly named missing obligation.
- **[PRIOR ART]** attributed to the cited external literature.
- **[VERIFY]** bibliographic metadata or a literature comparison that must be checked before
  submission.
- **[EDITORIAL]** proposed framing, organization, or interpretation rather than a mathematical
  claim.

## Abstract [skeleton]

**[LEAN]** We study the normal-play impartial game in which two players build a set of points in a
finite geometry without ever selecting three collinear points.  The second player wins on every
positive-dimensional finite affine space, every binary projective space of positive projective
dimension, every odd-dimensional projective space over a finite field of odd order, and every
projective plane over a finite field of even order.

**[EDITORIAL]** The game is the game-theoretic cousin of the cap-set problem: it asks who wins while
building a cap, rather than how large a cap can be.  The unusual output is an exact outcome class
for infinite geometric families.  We place the results inside the established Nofil/impartial
hypergraph-avoidance ruleset and the broader legal-complex language; we do not introduce a new
class of games.

**[COMPUTED]** For odd-order projective planes, exact computation and formal certificates support
the conjecture through order 23 at different trust tiers.  **[LEAN]** In rank three the conjecture
is equivalent to a residual escape statement: a counterexample exists exactly when some legal
size-three residual position has only N-valued size-four children.  **[CONDITIONAL]** The uniform
odd-order plane theorem remains open, as do the uniform higher-even-dimensional families over odd
fields.  **[COMPUTED]** The smallest board in the latter family has now been solved exactly:
`PG(4,3)` is P.

## 1. Introduction

### 1.1 The game-theoretic cap-set cousin

**[PRIOR ART]** Caps and cap sets are point sets with no three collinear; the 2016 polynomial-method
work of Croot--Lev--Pach and Ellenberg--Gijswijt concerns the extremal size of related progression-
free sets.  **[EDITORIAL]** Our question uses the same geometric objects but asks for the normal-play
outcome of building one point at a time.  This difference should be stated in the first page so no
extremal bound is mistaken for a game-value theorem.

**Claim stub 1.1 [LEAN].** The four infinite families in Theorem A below are P-positions.

**Claim stub 1.2 [PRIOR ART].** General Nofil positions inherit Node-Kayles-style hardness; the
structured affine and projective families are therefore a tractable geometric subfamily, not
evidence that general instances are easy.

### 1.2 Nofil, not a new game class

**[PRIOR ART]** Huggan--Huntemann--Stevens define Nofil as an impartial shared-point normal-play
avoidance game on block designs and allow the hypergraph formulation.  On `AG(n,3)` and `PG(n,2)`,
the present game is literally Nofil on the affine and projective Steiner triple systems.  For
`q > 2`, **[PROVEN-PROSE]** it is the same ruleset on the 3-uniform hypergraph of collinearity
triples, not Nofil on projective lines as blocks.

**[EDITORIAL]** A useful umbrella is line-capacity avoidance: queens is the capacity-one,
four-direction affine-grid case, whereas the cap game is the capacity-two, all-line case.  This is
a structured finite-incidence subfamily of known hypergraph building-avoidance and legal-complex
frameworks.  It is not proposed as a new ambient game class.

### 1.3 Main theorem and the organizing dichotomy

**Theorem A [LEAN].** Under the hypotheses quoted exactly in Sections 3--6:

1. `AG(n,K)` is P for every positive finite dimension over a finite field;
2. `PG(n,2)` is P for every `n >= 1`;
3. `PG(2m-1,q)` is P for every `m >= 1` and every finite field of odd order `q`;
4. `PG(2,q)` is P for every finite field of even order `q`.

**[EDITORIAL]** The proof mechanisms expose a genuine characteristic/dimension split.  Translation
and fixed-point-free involution mirrors close the four families, while projective planes of odd
order have an odd number of points and resist a fixed-point-free projective involution.  The paper
should use this contrast as organization, not imply that parity alone proves any open case.

**Open-family warning [CONDITIONAL + COMPUTED].** The open set is larger than the odd-plane row:
the uniform family `PG(2m,q)`, `m >= 2`, over odd fields remains open.  C43 supplies the first
direct exact-outcome evidence, `PG(4,3) = P` (25,258 orbit-canon memo states, independently
cross-checked).  C32 tested and rejected one composite-mirror policy on the same board; that
method-negative must not be confused with C43's P outcome.  No second board in this open family
has been solved.

## 2. Preliminaries

### 2.1 Finite build games and outcome classes

**Definition stub [LEAN].** Cite `FiniteBuildGame` from
[`CapGame/BuildGame.lean`](../lean/CapGame/BuildGame.lean).  A position is a finite valid set; a
move inserts a fresh element while preserving validity.  `IsP` means the next player loses under
normal play, and `Win` is the corresponding finite recursive predicate.

**[PRIOR ART]** Add a concise Sprague--Grundy paragraph and cite a standard source.  The four family
theorems need only P/N outcomes, while the residual conic discussion uses Node-Kayles nimbers.

### 2.2 Affine and projective caps

**Definition stub [LEAN].** Quote `CapGame.Affine.Cap` and `ProjectiveCap.Projective.Cap`: a valid
position contains no three distinct collinear selected points.  State separately that for `q > 2`
the forbidden hyperedges are triples, not whole projective lines.

### 2.3 Line capacity and legal complexes

**[EDITORIAL]** Present `|S intersection L| <= c(L)` only as a unifying language.  Capacity one is
graph independence/Node-Kayles on the conflict graph; capacity two retains genuine triple
constraints.  The legal sets form a simplicial complex and fit the impartial strong-placement-game
legal-complex language.  Add the Faridi--Huntemann--Nowakowski citations only after bibliographic
verification.

### 2.4 Mirror strategies and the pair-extension obligation

**Claim stub [LEAN].** A fixed-point-free symmetry is not sufficient by itself.  The reply strategy
requires validity of `S union {x, sigma(x)}` for every legal opponent move `x`; a mirror chord can
otherwise meet already selected structure.  Cite the generic mirror engine in
[`CapGame/Mirror.lean`](../lean/CapGame/Mirror.lean) and its projective specialization.  This is a
method lemma, not a claim that every P-family has the same mirror.

## 3. Finite affine spaces

### 3.1 Exact Lean statement

Ambient namespace: `CapGame.Affine`.  The coordinate theorem below inherits `[Field K]`; its
displayed finite-field and positive-dimension hypotheses are part of the source declaration.
All displayed declarations in Sections 3--7 are exact signatures with proof bodies omitted.

**Theorem 3.1 [LEAN]**
([`CapGame/Affine.lean`, `initialP_fin`](../lean/CapGame/Affine.lean)):

```lean
theorem initialP_fin (n : ℕ) [Fintype K] [DecidableEq K] (hn : 0 < n) :
    InitialPStatement (K := K) (V := Fin n -> K)
```

The underlying representation-independent theorem is also available:

```lean
theorem initialP_of_nontrivial [Nontrivial V] :
    InitialPStatement (K := K) (V := V)
```

Here the surrounding game section assumes `[Fintype V] [DecidableEq V]`, and the file-wide context
assumes `[Field K] [AddCommGroup V] [Module K V]`.

### 3.2 Proof-mechanism stub

**[LEAN]** If `(2 : K) = 0`, translate by a nonzero vector; this is a fixed-point-free involution.
If `(2 : K) != 0`, answer the opening move with a distinct point and reflect about their midpoint.
The center is fixed but already illegal because it lies on the line through the opening pair.  The
remaining proof is the checked pair-extension mirror argument.

### 3.3 Nofil specialization

**Corollary stub [LEAN + PRIOR ART].** At `q = 3`, the theorem gives Nofil value P on the affine
Steiner triple systems `STS(3^n)`.  HHS compute the `STS(9)` base instance with nim-value zero;
cite this as agreement and prior-art context, not as the proof of the infinite family.

## 4. Binary projective spaces

### 4.1 Exact Lean statements

Ambient namespace: `ProjectiveCap.Projective`.  The surrounding source context assumes
`[AddCommGroup V] [Module (ZMod 2) V] [Fintype V] [DecidableEq V]` and finite projective points.

**Theorem 4.1 [LEAN]**
([`ProjectiveCap/Binary.lean`, `initialPStatement_binary_of_finrank_ge_two`](../lean/ProjectiveCap/Binary.lean)):

```lean
theorem initialPStatement_binary_of_finrank_ge_two
    (hfinrank : 2 ≤ Module.finrank (ZMod 2) V) :
    InitialPStatement (K := ZMod 2) (V := V)
```

**Corollary 4.2 [LEAN]**
([`ProjectiveCap/Binary.lean`, `initialPStatement_binary_of_projectiveDim_ge_one`](../lean/ProjectiveCap/Binary.lean)):

```lean
theorem initialPStatement_binary_of_projectiveDim_ge_one {n : ℕ}
    (hn : 1 ≤ n) (hfinrank : Module.finrank (ZMod 2) V = n + 1) :
    InitialPStatement (K := ZMod 2) (V := V)
```

### 4.2 Proof-mechanism stub

**[LEAN]** Over `F_2`, projective points identify with nonzero vectors and a projective line is
`{x,y,x+y}`.  The theorem transports the nonzero binary sum-free game through
`binaryPointEquivNonzero` and `binary_nonzeroValid_iff_cap`, then invokes
`Sumfree.Game.nonzero_initial_isP_zmod2_of_finrank_ge_two`.

### 4.3 Nofil specialization

**Corollary stub [LEAN + PRIOR ART].** This closes the projective binary Steiner triple systems
`STS(2^(n+1)-1)` for every `n >= 1`.  HHS's nim-value-zero result for the Fano plane is the smallest
agreement check, not the source of the infinite-family theorem.

## 5. Odd projective dimension over odd fields

### 5.1 Exact Lean statement

Ambient namespace: `ProjectiveCap.Projective`; the source context includes `[Field K]`.

**Theorem 5.1 [LEAN]**
([`ProjectiveCap/EllipticMirror.lean`, `initialPStatement_of_odd_card_finrank_eq_two_mul`](../lean/ProjectiveCap/EllipticMirror.lean)):

```lean
theorem initialPStatement_of_odd_card_finrank_eq_two_mul
    {V : Type*} [AddCommGroup V] [Module K V]
    [Fintype K] [Fintype (Point K V)] [DecidableEq (Point K V)]
    (hq : Odd (Fintype.card K)) {n : ℕ} (hn : 0 < n)
    (hrank : Module.finrank K V = 2 * n) :
    InitialPStatement (K := K) (V := V)
```

### 5.2 Proof-mechanism stub

**[LEAN]** Choose a nonsquare `delta`.  On each two-dimensional block use
`T(a,b) = (delta*b,a)`, so `T^2 = delta I`.  Projectivization makes this an involution, and
nonsquareness rules out projective fixed points.  The collinearity-preserving whole-board mirror
then proves the initial position P, and a linear equivalence transports the coordinate result to
any model of vector dimension `2*n`.

**Novelty guard [PRIOR ART + EDITORIAL].** Elliptic projective involutions and pairing strategies
are classical.  The conservative contribution claim is their application to close this infinite
family in the shared impartial cap/Nofil game.

## 6. Projective planes over even fields

### 6.1 Exact Lean statement

Ambient namespace: `ProjectiveCap`.  The surrounding context assumes `[Field K] [Fintype K]
[DecidableEq K]`, `[AddCommGroup V] [Module K V]`, and finite decidable projective points.

**Theorem 6.1 [LEAN]**
([`ProjectiveCap/PlaneOutcome.lean`, `initialPStatement_of_even_card_finrank`](../lean/ProjectiveCap/PlaneOutcome.lean)):

```lean
theorem initialPStatement_of_even_card_finrank
    (hcard : Even (Fintype.card K))
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V)
```

### 6.2 Proof-mechanism stub

**[LEAN]** Even field cardinality implies characteristic two.  After the projective opening/frame
reduction, the residual grid admits the characteristic-two translation mirror used by
`GridMirror.initialPStatement_of_charTwo_finrank`.  This is a residual mirror theorem, not the
odd-dimensional whole-board elliptic mirror of Section 5.

## 7. Odd-order projective planes: conjecture and evidence

### 7.1 Conjecture

**Conjecture 7.1 [CONDITIONAL].** `PG(2,q)` is P for every odd prime power `q`.

### 7.2 Exact falsification equivalence

Ambient namespace: `ProjectiveCap.GridGame.TrapConverse`; the source assumes a finite field `K`.

**Theorem 7.2 [LEAN]**
([`ProjectiveCap/TrapConverse.lean`, `initialPStatement_iff_oddEscapeStatement_finrank`](../lean/ProjectiveCap/TrapConverse.lean)):

```lean
theorem initialPStatement_iff_oddEscapeStatement_finrank
    {V : Type*} [AddCommGroup V] [Module K V]
    [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) ↔
      OddEscapeStatement (K := K)
```

**[LEAN]** Consequently, an odd-order plane is N exactly when a trapped legal size-three residual
position exists.  **[LEAN]** Every such position has exactly `q^2 - 9q + 21` legal size-four
extensions, so a trap means all children are N, not that no child exists.  Retain the ordinary
formal-specification caveat: Lean proves the equivalence for its definitions; cross-engine checks
are the external adequacy evidence.

### 7.3 Computational evidence table

This table follows the current project handoff.  The tag applies to the claimed value, not merely
to the existence of a partial experiment.

| q | Value | Evidence / proof state | Remaining gap |
|---|---|---|---|
| even `q` | **P [LEAN]** | `PlaneOutcome.initialPStatement_of_even_card_finrank`; characteristic-two residual translation mirror | none |
| 3 | P **[COMPUTED]** | exhaustive solve | no Lean theorem queued |
| 5 | **P [LEAN]** | `initialPStatement_of_card_eq_five_finrank` | none |
| 7 | **P [LEAN]** | `initialPStatement_of_card_eq_seven_finrank` | none |
| 9 | P **[COMPUTED]** | exhaustive solve; intrusion terminal-reply kernel isolated | Lean kernel/certificate open |
| 11 | **P [LEAN]** | `CertData.Q11.initialPStatement_finrank` | none |
| 13 | **P [LEAN]** | `CertData.Q13.initialPStatement_finrank` | none |
| 17 | P **[COMPUTED]** | anchored C30 certificate book, `210/210` independent rules checks PASS; all witnesses on-conic | generated Lean aggregate needs refactoring after `maxRecDepth`; no uniform proof |
| 19 | P **[COMPUTED]** | anchored C30 certificate book, `272/272` independent rules checks PASS; all witnesses on-conic | Lean data path gated behind the q=17 refactor; no uniform proof |
| 23 | P **[COMPUTED]** | all 22 full-`PGL(2,23)` on-conic buckets P; the orbit transport is the Lean theorem `Sym2Bridge.onconic_value_bridge` | bucket labels remain solver output; C54 rules-only certification is open |
| 25 | unknown **[COMPUTED, PARTIAL]** | one normalized S4 representative `{1,2,3,4}` computed P at about 26.3M private memo entries | no full `PGL(2,25)` bucket census, no plane outcome, no Lean result |
| all odd `q` | conjectural P **[CONDITIONAL]** | no counterexample in the classified/computed rows above | uniform defect/zone-steering or another strategy proof |

The q=23 row must not be promoted to **[LEAN]**: the orbit bridge is formal, but the 22 P labels
it consumes are not kernel-checked.  The q=25 row must not be described as evidence for the whole
plane outcome: it is a sizing datum for one S4 root.

### 7.4 Conic localization: why the conjecture is structured

**Claim stub [LEAN + PROVEN-PROSE].** Frame reduction turns the plane problem into a constrained
`q by q` residual grid.  A residual size-three position and the two burned directions form a
projective five-arc, which determines a unique conic.  Its remaining `q-4` cells are legal
size-four extensions.  Cite the exact Lean five-arc/conic and frame-grid statements when this
section is expanded.

**Claim stub [PROVEN-PROSE + COMPUTED].** Each off-conic intruder induces a Möbius involution
matching on the live conic.  At the first two-intruder layer, conic-restricted play is Node-Kayles
on paths, cycles, and isolated vertices; deeper layers can have degree greater than two, so the
path/cycle description is not a recursive invariant.  This is a forward pointer to D3, not a proof
of Conjecture 7.1.

**Queued finite illustration [COMPUTED INPUT; GAME PROOF OPEN].** C187 classifies equality
`U(A)=C(F_q)` for `4 <= |A| <= 7`: the only cases are the four-point frame in `PG(2,5)` and the
six-point Clebsch seed in `PG(2,11)`. C189 will test and certify the expected octahedral conflict
graph `K6-M3` and antipodal-copycat P-strategy for the former, then compare it with the already
proved icosahedral seeded P-position for the latter. Do not promote the q=5 graph or value from this
stub until C189's finite and sealing-transport gates pass. Even after they do, the pair illustrates
two exact-equality small-field base cases only: for `q>=13`, C187 does not exclude
`U(A)` being a proper subset of `C(F_q)`, other conic-localized seeds, or other sealed hole sets.
`(ON)` remains the weaker, value-sensitive demand for one P-valued on-conic child.

**Segre guard [PRIOR ART].** Segre's 1955 oval theorem is relevant odd-plane background, but the
localization step here uses uniqueness of the conic through a five-arc.  Do not claim that Segre's
oval theorem itself performs this reduction.

### 7.5 The higher even-dimensional hole

**Open problem [CONDITIONAL].** For odd `q`, the outcomes of `PG(2m,q)` with `m >= 2` remain open.
**[COMPUTED]** `PG(4,3) = P`, the first and currently only direct solved-board evidence in this
family; the exact orbit-canon solve used 25,258 memo states and passed independent move-order and
canonicalization cross-checks.  Place this immediately after the plane table so the paper records
both the positive first datum and the fact that the four uniform theorems do not classify all
projective dimensions.

## 8. Related work and novelty positioning

### 8.1 Ruleset and complexity

**[PRIOR ART]** HHS own the Nofil ruleset, small STS computations, the available-graph/
Node-Kayles connection, and STS hardness results.  **[PRIOR ART]** Schaefer proves general
Node-Kayles PSPACE-complete.  **[EDITORIAL]** Use these results to motivate structured geometric
families, not to claim a new hardness theorem here.

### 8.2 Extremal cap sets versus cap-game outcomes

**[PRIOR ART]** Cite Croot--Lev--Pach and Ellenberg--Gijswijt for the extremal polynomial-method
line.  **[EDITORIAL]** State explicitly that maximum cap size does not determine normal-play
outcome; the connection is the shared legal object.

### 8.3 Achievement games and colored avoidance

**[PRIOR ART]** Harary/Beck positional-game work supplies adjacent achievement-game vocabulary.
Those games are typically partizan Maker--Breaker or owned-set games.  **[VERIFY]** The accessible
description of Clark--Mancini--Van Hook concerns a colored/partizan avoidance game; retrieve the
full text before making any stronger comparison.  It must not be cited as proving the present
impartial shared-game results.

### 8.4 What is and is not claimed as new

**[EDITORIAL]** Conservative proposed wording:

> The game is Nofil/impartial hypergraph avoidance in the sense of
> Huggan--Huntemann--Stevens, applied to collinearity triples.  The fixed-point-free projective
> involutions and pairing strategies are classical.  To our knowledge, the contribution is the
> resulting exact outcomes for the stated infinite affine and projective families in this shared
> impartial game.

Do not claim a new general game class, a new projective involution, or that colored misere
tic-tac-toe implies these theorems.

## 9. Normal play versus misere play

**Rules caveat [LEAN + PRIOR ART].** Every result in this manuscript uses normal play: completing a
forbidden triple is illegal, and the player making the last legal move wins.  Misere variants,
including games in which a player loses by completing a block, have different recurrences and may
require misere quotients rather than ordinary Sprague--Grundy xor.  No theorem here classifies a
misere version.

## 10. Bibliography stub

Entries marked **[VERIFY]** deliberately omit unconfirmed metadata.

1. **[PRIOR ART]** B. Segre, *Ovals in a finite projective plane*, Canadian Journal of
   Mathematics 7 (1955), 414--416.  Used for: the odd-order oval/conic background; not the
   five-arc uniqueness step.
2. **[VERIFY]** E. Croot, V. Lev, P. Pach, 2016 polynomial-method paper (title, venue, pages to be
   verified).  Used for: the polynomial-method/cap-set-cousin framing.
3. **[PRIOR ART]** J. S. Ellenberg and D. Gijswijt, *On large subsets of `F_q^n` with no
   three-term arithmetic progression*, Annals of Mathematics 185 (2017).  Used for: the cap-set
   extremal-problem comparison; the result was circulated in 2016.
4. **[PRIOR ART]** T. J. Schaefer, *On the Complexity of Some Two-Person Perfect-Information
   Games*, Journal of Computer and System Sciences 16(2) (1978), 185--225.  Used for:
   PSPACE-completeness of Node-Kayles.
5. **[PRIOR ART]** M. A. Huggan, S. Huntemann, B. Stevens, *The combinatorial game Nofil played
   on Steiner triple systems*, Journal of Combinatorial Designs 30 (2022), 19--47;
   arXiv:2103.13501.  Used for: the ruleset, STS computations, Node-Kayles bridge, and hardness
   motivation.
6. **[VERIFY]** R. K. Guy, the relevant Dawson's-chess/octal-games source (exact edition/pages to
   be verified), together with OEIS A002187.  Used for: Dawson's chess/path Node-Kayles values in
   the D3 forward reference.
7. **[PRIOR ART]** J. Beck, *Combinatorial Games: Tic-Tac-Toe Theory*, Cambridge University Press
   (2008).  Used for: the pairing/positional achievement-game comparison.
8. **[VERIFY]** F. Harary, foundational achievement-game source, exact record to be verified.
   Used for: the achievement-game lineage and its distinction from impartial shared avoidance.
9. **[VERIFY]** Anderson--Harary, International Journal of Game Theory 16 (1987), exact title and
   pages to be verified.  Used for: the group achievement/avoidance-game lineage, as an adjacent
   rather than identical ruleset.
10. **[VERIFY]** Clark--Mancini--Van Hook, full bibliographic record and full-text game convention
   to be verified.  Used for: adjacent colored/partizan finite-geometry avoidance only.
11. **[VERIFY]** Faridi--Huntemann--Nowakowski, *Simplicial Complexes are Game Complexes*,
    Electronic Journal of Combinatorics (2019), full metadata to be checked.  Used for: legal-
    complex/strong-placement-game language.
12. **[VERIFY]** M. Huntemann, *Game Values of Strong Placement Games*, arXiv:1908.10182; final
    publication status to be checked.  Used for: the strong-placement-game framing.

## 11. Expansion checklist

- Replace each proof-mechanism stub with a proof outline tied line-by-line to the cited Lean
  theorem; do not reproduce implementation detail that belongs in a formalization appendix.
- Add exact definitions and a compact normal-play recurrence from `FiniteBuildGame`.
- Decide whether D4's checker architecture belongs in this paper or in a companion verification
  paper; the evidence table itself stays here either way.
- Decide whether the later C48/C51/C52 subboard families belong in this paper, an outlook section,
  or a separate harvest paper.  They are outside C34's four-family core.
- Retrieve and check Clark--Mancini--Van Hook before freezing novelty language.
- Verify every **[VERIFY]** bibliography record and add theorem/page pins for external claims.
- Preserve the distinction between **[LEAN]**, **[COMPUTED]**, and **[CONDITIONAL]** through all
  later prose edits.

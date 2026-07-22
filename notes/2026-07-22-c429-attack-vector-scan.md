# C429 attack-vector scan — intrinsic split/inert/ramified phase theorem over `Z[tau]`

**Lane:** `crowns`

**Date:** 2026-07-22

**Status:** proof-strategy dossier only; no computation run, no task executed. C429 is pegged
"after C427". C427 is still in the live queue (itself gated on C425/C426); its report file
`notes/2026-07-20-c427-clebsch-scheme-chirality-lean.md` says implementation is complete and
independent review is pending. So the dependency is near-closed but not closed: C429 execution
waits; this scan does not.

**Persona routing:** `notes/2026-07-07-named-expert-personas-context.md` has no row for
integral/modular representation-theory phase-theorem work; every listed dossier targets games,
arcs, cap-sets, or reliability. No persona dossier was loaded, per the index's own instruction to
consult only an applicable row.

**Assets read:** C430 (radical/socle line), C377 + both companions (integral golden map, Benson
fence), C459 (Q-form, S3 resolvent, two-character machine, char-5 degeneration), C466 (Dickson
hinge, conductor-40 package), C453 (mod-40 law), C468 (fusion-blind zeta), C486/C487 (one torsor
class, sgn character, char-zero realization row), C488 (q=23 rung, local/global caution),
and `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md` (anticipated statement
shape: "one descent datum controlling the two `A5` representations, the two arc chiralities, the
monomial-equivalence obstruction, and the two scheme fibres, with the q=5 internalization and a
Frobenius-semilinear inert statement"; and the directive "C429 should track this radical line
integrally and under Frobenius before introducing any larger descent object").

---

## (a) Assess — what the theorem can say, weakest to strongest

**The central structural observation.** The certified assets already name the candidate common
datum. Put

```text
R = Z[T]/(T^2 - T - 1),     sigma(T) = 1 - T,     delta = 2T - 1,
delta^2 = 5,                sigma(delta) = -delta.
```

`R` is C459's two-character sheet machine and C487's characteristic-zero realization row
(`Spec Q(sqrt5)` = the `S3`-resolvent). Its odd part `R^{sigma=-1} = Z*delta` is a free rank-one
module — the abstract sheet-sign line. Its behavior at a rational prime `p` is forced:

- **split** (`(5/p)=+1`): `R x F_p = F_p x F_p`; `delta` maps to a unit multiple of
  `e_+ - e_-`, the sheet-sign vector; the sheet pair is a free `C2`-set;
- **inert** (`(5/p)=-1`): `R x F_p = F_(p^2)` with `sigma` = Frobenius; the odd line is the
  trace-zero line; the swap is Frobenius-semilinear, and the fixed object is the fused connected
  point (C486 L3's trichotomy);
- **ramified** (`p=5`): `delta = 2*3-1 = 5 = 0` in the fibre; the odd line falls into the
  nilradical of the nonreduced fibre `F_5[eps]/eps^2`, the sheets coalesce, and the outer swap
  becomes internal (C377's order-120 enhancement; C459's flat char-5 degeneration).

So the ramified clause is a Fitting statement (`delta` generates the ideal `(sqrt5)`, whose
Fitting/Smith data localize the unique bad prime to 5), the split clause is a base-change
statement, and the inert clause is a semilinearity statement. The mathematical work of C429 is
**not** discovering this arithmetic — it is elementary — but proving that this one integral line
**is** (naturally, integrally, at every prime at once) the C430 outer-odd radical/socle line and
the exchange datum of the four certified realizations. The theorem's value is the naturality
package, not the character table.

**The one statement-shaping hazard (must be settled in the statement, not discovered mid-proof).**
C430's socle identification (`rad(L) = soc(P(1)_+) (+) soc(P(1)_-)`, Loewy series `1|9|1`) is a
*defining-characteristic* fact: it lives in the mod-11 representation theory of the q=11
configuration (and mod-7 for B3). The phase theorem varies the *arithmetic* prime `p` of `Z[tau]`.
These are different axes. At a general split `p`, the "two sheets" are the two golden `A5`
reductions / matchings / arc labels — there is no 2q-point C406 configuration and no `P(1)` socle
at that `p`. The correct statement therefore treats the outer-odd line **abstractly** (free
rank-one `sigma`-odd `R`-line) at every prime, and asserts the projective-cover-socle refinement
only at the defining characteristics where C430 certifies it (q=7, q=11). Writing the statement
the other way — as if a socle line existed fibrewise at every `p` — is unprovable as posed and
would be the likeliest silent failure mode of the task.

**What "intrinsic" must mean, given the Benson fence.** C377's audit is explicit: Benson owns the
generic golden intertwiner, the trivial relative-Brauer obstruction `lambda(rho)=1`, Hilbert-90
normalization, and — critically — "split, inert-semilinear, and ramified-linear specialization of
that datum is standard quadratic descent". So C429 may not present any of the following as new:
the intertwiner, the phase trichotomy of `x^2-x-1`, semilinear forms at inert primes, or Hilbert
90. What is *not* pre-empted (per C377's own hand-back and the plan review's item 1):

1. the identification of the phase carrier with a **module-theoretic** line (difference of the two
   projective-cover socles / the degree-two trade kernel) rather than a representation intertwiner
   — Benson has no radical/socle, no code, no torsor content;
2. the **naturality legs**: one integral carrier whose base changes are simultaneously the two
   `A5` representations' exchange (via C377's `J`), the arc chirality torsor (C373/C427), the
   monomial-equivalence obstruction of the two `[6,3,4]` codes, and the scheme fibres
   (C459/C487's `S3`-resolvent) — the finite instances of these identifications are certified
   (C486 L1/L2, C487), the all-prime statement is not;
3. the **q=5 internalization stated scheme-theoretically**: the odd line entering the nilradical
   of the nonreduced fibre = the outer element becoming internal = the three ramified length-two
   points of C459's flat degeneration, as one flat-family statement rather than three numerical
   coincidences.

"Intrinsic" therefore = *defined by the carrier `R` and its odd line, plus natural transformations
to the realizations that are themselves defined without choosing a golden root, a sheet name, or
coordinates*. It does not (and cannot, inside this task) mean "recovered from the unmarked code" —
that is the F0 gate of the Frobenius-chirality companion, a separate unallocated project.

**Statement ladder.**

- **S0 (weakest defensible).** *Phase law of the odd line.* For the frozen integral golden six-arc
  over `R` and its sheet-label algebra, reduction at `p` yields: split — rational sheet-sign line
  `e_+ - e_-` and a free `C2` sheet torsor; inert — a Frobenius-semilinear involution
  (`J` composed with `Frob_p`) whose fixed object is the single fused point; ramified — sheet
  coalescence with the odd line in the nilradical and the swap internal. Proof: base change of
  `R` plus the C377/C486 certified endpoints. Risk: read as pure restatement of quadratic descent;
  survives only as a lemma, not a theorem.
- **S1 (target; recommended).** *One-carrier theorem.* There is one integral datum — the
  `sigma`-odd line `Z*delta` of `R`, together with its certified realization as the C430
  degree-two trade kernel at the defining characteristics — and four natural transformations,
  defined over `Z[1/N]` with `N` explicit, from its base-change functor to (i) the exchange of the
  two golden three-dimensional `A5` representations, (ii) the unordered `10+10` arc-chirality
  torsor, (iii) the monomial-equivalence obstruction of the two Clebsch codes, and (iv) the
  `S3`-resolvent scheme fibres. Frobenius acts on every realization through the one character
  `(5/p)`; the inert action is semilinear through `J*Frob`; the fibre at 5 is the flat nonreduced
  degeneration and internalizes the swap. Evaluable at an arbitrary prime by base change.
- **S2 (strongest; stretch).** *Represented phase functor.* The assignment
  `p -> (sheet object, swap)` is represented by the finite flat `C2`-scheme
  `Spec Z[1/N][T]/(T^2-T-1)` in each of the four realization categories, i.e. S1's natural
  transformations are isomorphisms of functors, and the mod-40 refinement (adding `(2/p)`
  visibility, C466) is the pullback of the `sgn` character along the represented object. This is
  M5 of the integral-moduli companion restricted to the odd line — deliberately without the
  moduli stack. Only attempt after S1 is written and its N is known.

Epistemic key: the arithmetic of `R` is elementary/classical; the finite identifications are
certified (C486/C487/C377/C459); S1's all-prime naturality is plausible but unproved; S2 is
speculation until S1's `N` and unit-normalization issues are settled.

---

## (b) Attack vectors

### V1 — One-carrier route: Smith/Fitting normal form + naturality legs (primary)

- **What it proves at best:** S1 in full, with S2 in reach. The Smith/Fitting analysis is the
  integral half (bad-prime localization, ramified clause); the naturality legs are the intrinsic
  half (the four realizations as base changes of one line).
- **First concrete computation:** build the integral presentation of the sheet-sign line from the
  frozen data — C377's six columns `P(tau)` and `J` over `Z[tau]`, C459's descended integral
  sextuple and Gram `G`, C430's frozen B3/H3 rank/radical certificates — and compute Smith normal
  form of the relevant Gram/second-moment matrices over `Z` (via norms down from `Z[tau]` where
  needed). Acceptance: elementary divisors localize the bad set to `{5}` plus an explicit,
  explained finite set (candidates: 2 from the arrangement collapse, 11 or 7 from defining
  characteristic); reduction at 11 recovers `e_+ - e_-` = C430's line; reduction at 5 lands the
  line in the radical.
- **Second computation (naturality pilot):** at one fresh split prime (19 or 29) and one inert
  prime (13 or 3), push `delta` through each certified dictionary (C377 `J`-action on the
  representations and codes; C427's chirality torsor; C459/C487 reduction of the resolvent) and
  verify the induced swap matches on the nose, including unit normalization.
- **Kill-switch (cheapest test that could kill it):** a unit-normalization obstruction. Each
  realization fixes the odd line only up to a unit of `R`; if the four dictionaries require
  incompatible units that no single global rescaling fixes (a genuine `H^1(units)`-type mismatch),
  then no *single* integral carrier maps to all four, only a per-prime family — S1 dies, S0
  survives. Testable at two primes in one session before any theorem is written.
- **Consumes:** C430 (line + hypotheses), C377 (integral `J`, normalized cocycle), C459 (integral
  model, char-5 fibre), C486 L2/L3 (sgn identification, trichotomy), C487 (char-zero row).
- **Must not touch:** constructing any new intertwiner; restating the phase trichotomy of
  `x^2-x-1` as a contribution; Hilbert-90 machinery beyond citation; the moduli stack (M1–M3 of
  the integral-moduli companion); the unmarked-code intrinsic recovery gate (F0).

### V2 — Frobenius-semilinear inert clause as a standalone statement

- **What it proves at best:** the queue row's mandated inert clause in sharp form: at inert `p`,
  `J * Frob_p` is a semilinear involution on the `F_(p^2)` object whose fixed structure is
  exactly the fused connected point of C486 L3, and its outer label class is C377's `pi`
  independent of `p`. Feeds V1 as its inert leg; standalone it is a lemma-grade result.
- **First concrete computation:** pilot at `p=13` (inert, and C453's blocked prime — a useful
  boundary case since even the order-60 marker fails inside `PSL_2(13)`): compute the fixed
  points of `J*Frob` on the reduced six-arc and code and compare with the predicted fused datum;
  repeat at `p=3` for a small control.
- **Kill-switch:** if the fixed structure at an inert prime depends on the choice of `J` within
  its gauge orbit (i.e. the semilinear fixed object is not gauge-invariant), the clause is not
  intrinsic and must be weakened to a gauge-orbit statement. One-session check via C459's ten
  normalized cocycles.
- **Consumes:** C377 (`J`, cocycle), C486 L3, C459 (cocycle gauge orbit).
- **Must not touch:** presenting semilinear descent itself as new (it is textbook + Benson);
  identifying `J` at a split prime with arithmetic Frobenius (companion's explicit scope stop).

### V3 — Dickson/visibility refinement via C466

- **What it proves at best:** S2's mod-40 pullback clause: the `(2/p)` visibility layer as the
  `sgn`-character pullback along the represented carrier, unifying C453/C466 with the phase
  theorem in one two-layer statement.
- **First concrete computation:** none needed beyond bookkeeping — C466 already certifies the
  mechanism at five primes; the work is a statement-level splice.
- **Kill-switch:** if the splice requires the octahedral hinge to be defined over `R` (it is
  defined over `Z`), scope collides with C466's completed classification; stop and cite instead.
- **Consumes:** C466, C453.
- **Must not touch:** re-proving the fusion mechanism; the H4/icosian gated successor.
- **Verdict:** consumer, not core. Defer to the S2 stage or hand to the paper's mechanism section.

### V4 — Torsor/character route via C486's sgn identification

- **What it proves at best:** the phase theorem phrased entirely in torsor language: the class
  `[T_q] = sgn` of the finite rows is the reduction of the global class of `Spec Q(sqrt5)`
  (C487), and the split/inert/ramified phases are the three base-change behaviors of that one
  class. Cleanest paper phrasing; mathematically a corollary of V1.
- **First concrete lemma:** the compatibility square — global `sigma <-> Rz`-coset dictionary
  (C487) commutes with V1's naturality legs at every certified prime.
- **Kill-switch:** same unit-normalization switch as V1 (they share it).
- **Consumes:** C486 L2, C487, C473-via-C486 dictionaries.
- **Must not touch:** absolute-`H^1`/absolute-Galois claims (C487's stated boundary).

### V5 — Local-global via completions of `Z[tau]`

- **What it proves at best:** a classification of the outer datum over each completion, assembled
  into a global statement by class-field bookkeeping.
- **Why it is ranked last:** (i) it drifts directly toward Benson's relative-Brauer territory —
  the pre-empted fence; (ii) C488's fresh caution is a concrete warning shot: identical local
  data (the `D8` cohomology of `End(S)` vs `Hom(S*,S)`) produced different global answers, so a
  local-to-global inference here would need exactly the kind of global computation V1 does
  anyway; (iii) nothing in the target requires adelic language.
- **Kill-switch:** already effectively fired by the fence plus C488's caution.
- **Verdict:** do not open.

### V6 — C488 method imports (cross-cutting, not a standalone vector)

Two C488 methods transfer; its Galois-primes boundary does not bind here.

- **Index-subgroup exhaustion as an impossibility tool:** the same style (exhaust overgroups of a
  fixed Sylow to kill a hypothetical action) is the right shape for any C429 side-claim of the
  form "no rational/inner symmetry realizes the swap at prime p" — the analogue of C486's
  forced-outer M12 clause. Cheap, certifiable, and it converts "we did not find" into "there is
  none".
- **Direct global computation over local corroboration:** C429's certificates should compute the
  global object (Smith form, fixed structure, torsor class) directly and record local data as
  corroboration only — verbatim the C488 lesson.
- **Boundary note:** C488's `q in {5,7,11}` Galois-primality wall concerns degree-`q` permutation
  sheets for `PSL_2(q)`; C429's carrier is a rank-two étale algebra, not a permutation sheet, so
  the wall does not obstruct the phase theorem. It does mean any temptation to package the phase
  carrier as a permutation module at general `p` should be resisted — the packaging, not the
  carrier, is what failed at q=23.

---

## (c) Red team — top two vectors

### Against V1 (one-carrier route)

1. **"The carrier is just `sqrt5`."** The strongest objection: `Z*delta` with `delta^2=5` is the
   different/discriminant line of `Q(sqrt5)`, and its split/inert/ramified behavior is the
   splitting of `x^2-x-1` — content-free as arithmetic. If the naturality legs are judged to be
   "certified dictionaries already in hand (C486/C487) plus base change", the whole theorem
   compresses to bookkeeping and lands in classical territory. Defense: the legs at *general* `p`
   are genuinely unproved (C486/C487 certify q in {5,7,11} and the char-zero row); the
   unit-normalization question is a real global obstruction candidate; and the ramified clause as
   a flat-family statement is certified only fibrewise. But if the kill-switch test shows units
   align trivially and the legs reduce to one-line base-change arguments, the result is a strong
   *lemma bundle* for Paper 1/2 rather than a crown theorem — a real possible outcome that should
   be declared as the S0/S1 boundary in the report, not papered over.
2. **The two-characteristics conflation.** As flagged in (a): the queue row's phrase "starting
   from C430's canonical outer-odd radical/socle line" invites defining the fibrewise datum as a
   socle line at every `p`, which is false at non-defining primes. If the statement is not split
   into (abstract odd line, all `p`) + (socle refinement, defining characteristic only), the
   theorem as worded is unprovable and the task risks a late unforced stop. This is a statement
   defect to fix on day one, not a proof difficulty.
3. **Benson-fence perception risk.** Even a correct S1 will *look* like "Benson + functoriality"
   to a hostile reader unless the report leads with what Benson does not have (socle line, code,
   torsor, ramified internalization) and cites C377's audit verbatim. The mitigation is
   presentational but mandatory.

### Against V2 (Frobenius-semilinear standalone)

1. **Classical territory.** A semilinear involution on the inert fibre with fixed structure the
   descended form *is* Galois descent, verbatim. Standalone, V2 proves nothing Benson plus a
   first-year descent argument does not. It earns its place only as V1's inert leg, where the
   content is gauge-invariance and dictionary compatibility, not existence.
2. **Gauge dependence.** C459 proves the cocycle orbit has ten members with stabilizer `S3`; the
   semilinear fixed object could a priori vary over the orbit. If it does, the "intrinsic" inert
   statement weakens to an orbit statement — still usable, but the queue row's "Frobenius-
   semilinear inert statement" must then be worded on the orbit. The one-session gauge check
   decides this before any drafting.

---

## (d) EV ranking and cost

| Rank | Vector | Best outcome                                | Rough cost      | EV against general target |
|:----:|:------:|:--------------------------------------------|:----------------|:--------------------------|
| 1    | V1     | S1 proved; S2 in reach                       | 2–3 sessions    | high                       |
| 2    | V2     | inert clause, gauge-invariant, inside V1     | folded into V1; 1–2 standalone | medium (high as V1's leg) |
| 3    | V4     | torsor-language master statement             | 0.5 session on top of V1 | medium                     |
| 4    | V3     | mod-40 two-layer splice (S2 stage)           | 0.5 session, statement-level | low-medium (paper value)  |
| 5    | V6     | impossibility side-claims, certificate style | absorbed into V1 practice | method value only          |
| 6    | V5     | completions/class-field assembly             | not costed      | negative (fence + C488 caution) |

**Single highest-EV first move:** the V1 kill-switch computation, run *before* drafting any
theorem: at one split prime (19) and one inert prime (13), push the abstract odd line `Z*delta`
through all four certified dictionaries and check unit-compatible agreement; simultaneously
compute the Smith normal form of the frozen integral Gram/second-moment presentations and confirm
the elementary divisors localize the bad set to `{5}` plus an explained finite set. One session,
deterministic, standard-library. It settles: (i) whether one global carrier exists (S1) or only a
per-prime family (S0); (ii) the exact `N` in `Z[1/N]`; (iii) whether the socle-vs-odd-line
statement split is cleanly expressible. Every downstream decision — including whether C429 is a
theorem task or a lemma-bundle task — hangs on this one output.

---

## (e) Interactions

**Retroactive upgrades on a win.**

- **Paper 1 close.** C486/C487's "one torsor, one swap" rows become fibres of one integral object;
  the master-stroke sentence ("the missing bit is `Gal(Q(sqrt5)/Q)`, made finite") upgrades from a
  char-zero row plus finite instances to a theorem evaluable at arbitrary primes. This is the
  single largest reach extension available to the close.
- **Paper 2 mechanism section.** The mod-40 law factors cleanly into two proved layers: the
  `(5/p)` existence layer (C429) and the `(2/p)` visibility layer (C466's Dickson hinge), with
  C468's fusion-blindness as the negative control. The section writes itself as
  "one carrier, two characters, one blind spectator".
- **The q=31/mod-40 prophecy row.** C429 supplies the split layer at 31 as a fibre statement;
  fusion at 31 stays C466's. The prophecy row's remaining open face (a single geometric roof
  object producing all three conductor-40 characters, C466 mystery ledger) is *not* closed by
  C429 and should not be claimed.

**Task flow.**

- **Feeds C433** (canonical placement of the odd Fourier block relative to the socle seam,
  mod 11): C429 hands it the integral avatar of the seam; C433's defining-characteristic depth
  data are exactly the socle refinement C429's statement isolates at q=11. Clean division: C429
  owns the arithmetic axis, C433 the defining-characteristic axis.
- **Feeds C434** (`K\G/H` information-lattice functor): the carrier is the bottom rung — the
  `2 -> 1` level of the `22 -> 6 -> 2 -> 1` lattice made arithmetic; C434's functoriality demand
  (C430's algebra chain functorial under coset maps) inherits V1's naturality legs as its base
  case.
- **Fed by / feeds C417** (section obstruction): C459/C487 already pin C417's boundary to the
  labeling; a C429 win restates C417's obstruction as "the global object `Spec Q(sqrt5)` has no
  `Q`-point", making C417's finite instances corollaries. C417 in turn supplies the Čech-cocycle
  functor V4 needs.
- **Dependency:** C427 (chirality torsor in Lean) is the formal consumer of realization (ii); its
  pending review is why C429 is sequenced after it — the arc-chirality naturality leg should
  target C427's committed public surface, not a moving one.

**Downstream Lean.** S1's finite ingredients (Smith forms, reductions at pinned primes, dictionary
squares) are all kernel-scale by the C380 cost precedents; the abstract carrier argument is a few
lines of algebra. A future formalization slice is realistic, but allocating it is not C429's call.

---

## (f) Epistemic status key

| Section | Status |
|:--------|:-------|
| (a) carrier arithmetic (`R`, `delta`, phase trichotomy)          | proved (elementary/classical; not claimable as new) |
| (a) finite identifications (sgn class, char-zero row, `J`, socle line) | certified (C486, C487, C377, C430/C412)       |
| (a) S1 naturality at all primes; single global carrier            | plausible (unit-normalization risk named)          |
| (a) S2 represented functor                                        | speculation until S1's `N` and units settle        |
| (b) V1/V2 kill-switch designs                                     | plausible (designs only; nothing run)              |
| (b) V5 negative verdict                                           | reasoned from certified C488 caution + C377 fence  |
| (c) red-team items                                                | reasoned; item (c).2 is a statement fact, checkable by inspection of C430's hypotheses |
| (d) costs                                                         | estimates (speculation, calibrated on C486/C487 session shapes) |
| (e) interactions                                                  | reasoned from certified reports; no new claims     |

No computation was run for this dossier; every numerical or structural claim above is quoted from
the cited certified reports or is elementary ring arithmetic in `Z[T]/(T^2-T-1)`.

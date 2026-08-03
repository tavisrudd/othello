# Arcs complete outside a conic: math and novelty ceilings

**Date:** 2026-08-02

**Lane:** `relconic` (entry handoff `notes/handoffs/2026-07-17-c210.md`)

**Paper:** `papers/arcs_complete_outside_conic`, mirrored at
`~/src/math-papers/arcs-complete-outside-conic`

**Scope and status:** review pass in the shape of
`notes/2026-08-02-priority-judo-survey.md` and
`notes/2026-08-02-cross-paper-novelty-ceilings-and-level-ups.md`, neither of
which covered this paper in substance.  The ceilings document's stated scope was
`papers/ame_lu`, `papers/beyond4_prs`, and Clebsch Papers I--IV; the judo survey
gave the arcs paper one fully audit-gated item.  This pass reads the manuscript
itself.

**Writes:** this file, and the exhaustive script
`notes/2026-08-02-arcs-line-hole-equality-k6.py` recorded in the
reproducibility section.  No manuscript, mirror, queue, handoff, Lean source, or
task card was touched.  No new literature searches were run; every literature
verdict rests on the manuscript's own bibliography, the C349 closure report, and
the audits already in the repository, and every negative remains qualified
accordingly.

---

## Executive verdict

Three things, in decreasing certainty.

**One editorial regression is real and checkable.**  The
Korchmáros--Nagy--Szőnyi concession that the C349 novelty gate reports as
released wording is not in the current manuscript and not in the public mirror.
It was added by commit `a2b4efdf` and removed again by `b6ff4db5` (the sentence)
and `57f5de13` (the orphaned bibliography entry).  The paper today cites no prior
art for localization of an uncovered locus on a prescribed subgeometry, which is
exactly the claim C349 concluded it must concede.  This has to be restored before
any further release.

**Two proved results in this lane are missing from the paper.**  The manuscript
still says the exact values at `q=13,17,19` "remain undetermined here," but C637
determined them and C641 recorded the trust boundary: `rho_C(13)=8`,
`rho_C(17)=9`, `rho_C(19)=10`.  Separately, C627 proved that abstract
`MATCH(k,floor(k/2),1)` nonexistence forces defect at least two, which
strengthens the manuscript's Corollary "Six and seven points" part (b) from a
nonexistence statement into a quantitative gap that also covers `k=8` and
`k=12`.  Both are writing tasks, not research.

**The largest genuine level-ups are scope, not sharpness.**  The lower-bound
constant `3/2` has four recorded negative mechanisms behind it (C626, C627,
C638, C639) and should be left alone.  The two moves that pay are (a) the
observation, verified below, that the defect identity is not a 2-arc theorem at
all and generalizes verbatim to `(k,n)`-arcs and their `n`-secants, which is the
scope in which the closest cited prior art (Alabdullah--Hirschfeld,
Korchmáros--Nagy--Szőnyi) actually lives; and (b) a conjectural classification of
rank-three realizable maximum-matching designs as exactly the ovals and
hyperovals, for which the numerology closes exactly at every case the repository
has settled.

---

## Claim matrix

| Paper's theorem surface | Closest literature | Verdict | Surviving boundary |
|---|---|---|---|
| Prescribed-hole defect identity, any finite projective plane, any hole set | classical first/second index equations: Hirschfeld ch. 9, Ball, Alabdullah--Hirschfeld | **NO COLLISION LOCATED** for the split-and-factor step; the moment equations themselves are conceded in the text | the exact pointwise-nonnegative remainder after splitting the two moments over a prescribed hole and its complement |
| Zero defect produces a simple `MATCH(k,floor(k/2),1)` design | Alspach--Heinrich's matching-design framework; Mathon's two-class `MATCH(10,5,1)` list via Reichard--Woldar | **CLOSE CEILING**; the abstract design theory is imported and the paper says so | the geometric implication that a coverage-extremal arc produces the design, and the concurrency-point realization inside one plane |
| Rank-three ten-point realization theorem (only the regular-hyperoval design, only in characteristic two with `F_8` inside the field) | none located; the realizability of matching designs by concurrent arc secants appears to be a question the design literature has not asked | **NO COLLISION LOCATED** | the whole realizability question, which is the paper's strongest unclaimed asset |
| `rho_C(q) >= sqrt(2q) + 3/2 - 8/sqrt(2q)` | Kim--Vu upper bound; ordinary complete-arc lower bounds | **NO COLLISION LOCATED** on the relative problem | the relative notion itself, distinguished in the introduction from saturating sets, almost-complete conic subsets, and complete exterior sets |
| Line-hole specialization and complete affine arcs | hyperfocused arcs: Ng--Wild, Giulietti--Montanucci, Korchmáros--Szőnyi | **CLOSE CEILING, sharper than the text admits** | see item 5: the equality case *is* the hyperfocused condition, so this stratum is shared with that literature and the direction of the debt is not yet established |
| Uncovered locus localized on a prescribed subgeometry | Korchmáros--Nagy--Szőnyi, JCTA 204 (2024) 105851, Theorem 7.5 | **CONCEDED PRIOR ART, concession currently missing from the manuscript** | the arbitrary-hole identity and its equality/stability theory, which is what C349 said the paper retains |
| Uncovered-locus reconstruction coda and stabilizer equality | deep-hole and MDS-extension literature (Wu--Ding--Chen and successors), read only partially elsewhere in the repository | **UNAUDITED for this paper** | see item 6 |
| `q=16` exclusion and the `2633`-leaf classification | Al-Seraji--Al-Ogali's independent class count | **NO COLLISION**; agreement noted and explicitly not used | the quadratic-avoidance theorem and its kernel-checked certificate |
| Evaluation and line--triangle obstruction lemmas | Glynn, Ball on arcs and quadrics | **CLASSICAL TOOL**, conceded in the text | nothing claimed |

---

## 1. The missing Korchmáros--Nagy--Szőnyi concession

C349 closed the pre-publication novelty gate by conceding that
Korchmáros, Nagy, and Szőnyi already prove an exact proper-subplane
uncovered-locus theorem: for odd `q` and odd `r >= 5`, the points left uncovered
by the `(q+1)`-secants of their rational BKS `(k,q+1)`-arc in `PG(2,q^r)` are
exactly the points of `PG(2,q)` not on the arc.  The report records the primary
source hash, the version of record, the forward-citation check, and the exact
released wording.

That wording is not in the manuscript.  `Korchm` occurs twice in the current
`arcs_complete_outside_conic.tex`, both times in the unrelated
Korchmáros--Szőnyi hyperfocused citation.  The mirror is byte-identical to the
monorepo file, so the public artifact has the same gap.  The removal is visible
in history: `b6ff4db5` ("Sharpen arcs paper around defect identity") deleted the
sentence during the spine compression, and `57f5de13` ("Close arcs referee
verification gaps") deleted the now-unreferenced bibliography entry.  Nothing in
either commit message signals that a novelty concession was being dropped, which
is how it survived.

The fix is one paragraph plus one bibliography entry, and item 3 below offers a
strictly better version of that paragraph.

## 2. Proved in this lane, absent from the paper

**Exact values at `q = 13, 17, 19`.**  The manuscript's comparison table gives
`L_2(13)=7`, `L_2(17)=L_2(19)=8` and then says the entries "are lower bounds
only.  The present work supplies neither witnesses attaining these bounds nor
nonexistence proofs, so the corresponding exact values remain undetermined
here."  C637 supplies both halves: exact projective classification and
quadratic-rank evaluation reject sizes `7,8,9` at those orders and independently
checked witnesses attain `8,9,10`, giving `rho_C(13)=8`, `rho_C(17)=9`,
`rho_C(19)=10`.  C641 kernel-checks the normalizations, the pullbacks, the three
upper bounds, and `q=19` ordinary completeness, with the trust manifest stating
plainly that the three lower-bound classifications remain external computations.
C643 then replaces the full-rank predicate by elementary uncovered-locus
obstructions in every case but one `q=19` extension, and C644/C650 explain that
residue as a projective Heisenberg orbit pair.

That is four new table entries, one field-uniform structural theorem (an arc
complete outside a nonsingular conic has ordinary uncovered locus an arc of size
at most `q+1`, kernel-checked), and one genuinely interesting exceptional
mechanism.  It is the single largest free upgrade available to the paper, and it
also repairs an asymmetry the current text has: `q=16` gets a full finite
treatment while three comparable orders are declared open.

**The design-nonexistence defect gap.**  The manuscript's Corollary "Six and
seven points" part (b) says only that no seven-arc has zero defect, citing
Alspach--Heinrich for `MATCH(7,3,1)` nonexistence.  C627 proves the quantitative
form: a `v-1` packing of maximum-matching cliques always completes, its leave is
forced to be a single `K_m`, and therefore abstract design nonexistence gives
scaled defect at least `2m`, that is `Delta_H(A) >= 2`.  Stated that way the
corollary covers `k=7` and, through C573's arbitrary-plane `MATCH(12,6,1)`
exclusion and the `MATCH(8,4,1)` exclusion, also `k=8` and `k=12`.  The
manuscript already proves a discrete gap `m*Delta = 0` or `>= m-2`; this is the
complementary structural gap and belongs beside it.

## 3. Level-up A: the identity is not a 2-arc theorem

**The observation.**  The proof of the defect identity uses exactly two inputs:
that distinct secants through an external point have disjoint traces on the arc,
and that the two index moments are exactly computable.  Neither is special to
2-arcs.  Let `A` be a `(k,n)`-arc in a projective plane of order `q` (no line
meets `A` in more than `n` points), let `s` be its number of `n`-secants, let
`d(a)` be the number of `n`-secants through `a` in `A`, let `r(x)` be the number
of `n`-secants through `x` outside `A`, and put `m = floor(k/n)`.  Then:

- `r(x) <= m`, because `n`-secants through `x` meet `A` in disjoint `n`-sets;
- `sum_{x not in A} r(x) = s(q+1-n)`, since each `n`-secant has `q+1-n` points
  off `A`;
- `sum_{x not in A} binom(r(x),2) = binom(s,2) - sum_{a in A} binom(d(a),2)`,
  since two distinct `n`-secants meet in exactly one point, inside or outside
  `A`, and both cases are counted exactly once.

Every step of the manuscript's proof now goes through verbatim.  With
`H` a prescribed hole, `X_H(A)` the covered required points, and
`I_H(A) = sum_{y in H} r(y)`,

    Delta_H(A) = s(q+1-n)
               - (2/m) * ( binom(s,2) - sum_{a in A} binom(d(a),2) )
               - I_H(A)/m
               - |X_H(A)|,

    m * Delta_H(A) = sum_{x in X_H(A)} (r(x)-1)(m-r(x))
                   + sum_{y in H} r(y)(m-r(y)).

For `n=2` this is the manuscript's identity: `s = binom(k,2)`, `d(a) = k-1`, and
`binom(binom(k,2),2) - k*binom(k-1,2) = 3*binom(k,4)`, checked directly at
`k=4,5`.  Completeness transfers too: `A union {x}` is a `(k+1,n)`-arc exactly
when `x` lies on no `n`-secant, so "complete outside `H`" has the same meaning
and the coverage corollaries specialize the same way.

**Why this is one level higher, and why it is the right judo.**  The two pieces
of prior art the paper is closest to both live at `n > 2`.
Alabdullah--Hirschfeld's cited lower bound is a bound for the smallest complete
`(k,n)`-arc, and the paper currently cites it only as the classical comparison
point for the index equations.  Korchmáros--Nagy--Szőnyi's theorem, the one whose
concession went missing, is about `(k,q+1)`-arcs with the hole a proper subplane.
In the generalized identity, that configuration is not a neighbouring result at
all: it is a hole set on which `Delta_H` can be *computed*.  The rewrite that
should replace the deleted sentence is therefore not a concession but a
specialization statement of the form the judo survey prescribes for the AME--LU
paper: state the identity for arbitrary `(k,n)`-arcs and arbitrary holes, cite
their theorem as the instance that first exhibited a localized uncovered locus,
and then say what the identity adds there, namely a defect value, an equality
criterion, and a deletion-stability neighbourhood that their exact statement does
not carry.  If their arc turns out to have zero or small defect relative to the
subplane hole, the paper's equality theory applies to a published object, which
is the strongest available position.

**What must not be claimed without an audit.**  Whether the `H = empty` case of
the generalized bound implies, matches, or is weaker than
Alabdullah--Hirschfeld's `(k,n)`-arc bound is not settled here.  Their paper is
short and cached-or-cheap to obtain; that read is a blocking gate before any
subsumption language.  Likewise the `n`-secant index equations for `(k,n)`-arcs
are classical (Hirschfeld ch. 12), and only the split-and-factor remainder is
paper-owned, exactly as at `n=2`.

**Effort.**  The mathematics above is complete.  Writing is perhaps a section
plus adjustments to the conic specialization, which stays at `n=2`.  Formalizing
the generalized identity in Lean is a modest edit of an existing gate, since the
proof shape is unchanged.

## 4. Level-up B: rank-three realizations should be exactly ovals and hyperovals

**The theorem to seek.**  Let `D` be a simple `MATCH(k,floor(k/2),1)` design and
suppose it has a rank-three projective realization over a field `K`, in the
manuscript's sense: an injective assignment of the `k` labels to points of
`PG(2,K)` forming an arc, such that the `m` secants of every block are
concurrent.  Conjecture: `char K = 2`, and the arc lies in the subplane
`PG(2,k-2)` for even `k` and `PG(2,k-1)` for odd `k`, where it is respectively a
hyperoval and an oval.  In particular `F_{k-2}` (resp. `F_{k-1}`) is contained in
`K`, and `k-2` (resp. `k-1`) must be a power of two.

**Why the numerology says this is the right statement.**  The manuscript's
concurrency theorem gives the number of maximum-index centres as
`|Z| = (k-1)(k-3)` for even `k` and `k(k-2)` for odd `k`.  Compare with the
number of points off a `k`-arc in a plane of the conjectured order:

- even `k`, `q = k-2`: `q^2+q+1-k = (k-1)(k-3) = |Z|` exactly, so *every* point
  off the arc is a maximum-index centre, which is precisely the hyperoval
  property;
- odd `k`, `q = k-1`: `q^2+q+1-k = (k-1)^2 = |Z| + 1`, one point in excess, which
  is precisely the nucleus of an oval.

Every settled case in the repository agrees.  `k=6` gives the `F_4` hyperoval and
nothing else, proved in the manuscript's six-and-seven corollary.  `k=10` gives
the regular-hyperoval design over exactly the fields containing `F_8`, proved by
the manuscript's ten-point realization theorem, and `8 = 10-2`.  `k=7` predicts an
oval in a plane of order six, which does not exist, and Alspach--Heinrich indeed
prove no abstract `MATCH(7,3,1)` exists.  `k=8` predicts a hyperoval in order six
and `k=12` a hyperoval in order ten, and C573 records both exclusions, the latter
proved for arbitrary planes from the certified order-ten oval search.  `k=9`
predicts an oval of `PG(2,8)`, and the count checks: `73-9 = 64` points off it,
one of which is the nucleus, leaving `63 = k(k-2)` centres.  The conjecture is
also exactly what the paper's characteristic-two equality corollaries prove under
the extra hypothesis of a conic hole (`k = q+2` for even `k`, oval with nucleus
on the conic for odd `k`), so the conjecture is those theorems with the conic
hypothesis removed.

**Why this is one level higher.**  Alspach and Heinrich, and Mathon, classify
matching designs abstractly.  The paper introduces the realization question and
answers three instances by hand or by computer algebra.  The conjecture converts
all of it into one geometric statement, and at that point their small-case
results stop being inputs and become the low-order instances of a theorem the
paper owns.  It would also make the manuscript's ten-point Gröbner certificate a
worked example rather than the load-bearing proof of its own theorem, which is a
referee-facing improvement in its own right.

**Likely proof route.**  Show that the `|Z|` concurrency centres, together with
`A`, close up under the incidence operations of the design into a subplane; the
count above says the closure has exactly the right cardinality, so the work is to
produce the subplane structure rather than to discover its order.  The dual
star--matching pairwise-balanced design already in the manuscript is the natural
carrier: at zero defect the secants become points of a rank-three incidence
structure with `k` lines of size `k-1` and `|Z|` lines of size `m`, and the
question is whether that structure forces the subplane.  This is also where the
lane's own subplane-localization thread and Korchmáros--Nagy--Szőnyi meet, which
is a reason to expect the literature to be relevant rather than empty.

**Cheapest falsifier.**  `k=9`.  Enumerate the simple `MATCH(9,4,1)` designs and
test each for rank-three realizability by the manuscript's existing determinant
method.  The conjecture predicts exactly one realizable class, realized by the
oval of `PG(2,8)` and only over fields containing `F_8`.  A second realizable
class kills the statement; a clean single class at the first untested odd order,
after `k=6,7,10` even/odd cases already agree, is strong evidence.  The
machinery is the existing `check_match10_rank_three` pipeline with new blocks.

**Risk.**  The conjecture as stated is about realizations, not about abstract
designs, and must never be phrased as a classification of `MATCH(k,m,1)` designs;
Mathon's and Alspach--Heinrich's results stay cited as the abstract input.

## 5. Line-hole judo: equality is the hyperfocused condition, and one branch is empty

**The identification.**  At a line hole every secant meets the line exactly once,
so `I_L(A) = binom(k,2)` is not merely bounded but determined; the line is the
unique hole where the identity has no slack in the hole term.  Zero defect forces
every hole point to have index `0` or `m`, so the number of points of `L` met by
secants is exactly `binom(k,2)/m`, which is `k-1` for even `k` and `k` for odd
`k`.  A `k`-arc disjoint from a line whose secants meet that line in exactly
`k-1` points is precisely a hyperfocused arc in the sense of the three references
the manuscript already cites in passing.  So the equality stratum of the paper's
own affine corollary is the hyperfocused condition together with affine
completeness, and the manuscript does not say so.

This changes what the paper should claim there.  The judo survey's item 5 asked
whether the hyperfocused results become corollaries of the defect identity.  The
sharper reading is that the identity and that literature share a stratum, and the
paper's genuinely unasked question is the quantitative one: the deletion-stability
corollary bounds how far an arc can be from this configuration in terms of
`Delta`, which is a statement about *almost*-hyperfocused arcs that the
construction-oriented hyperfocused literature has no reason to have made.  That
is the defensible paper-owned position, and it does not require the corollary
claim the survey flagged as unaudited.

**A new exhaustive result.**  The manuscript's affine corollary says that for
even `k >= 6`, equality forces `q` in `{k-2, binom(k-1,2)+1}`, which at `k=6` is
`q` in `{4, 11}`.  The first is the hyperoval of `PG(2,4)` with an external line
at infinity.  The second is settled here negatively: an exhaustive search over
all `6`-arcs of `AG(2,11)` up to affine equivalence, normalizing three arc points
to an affine frame, finds `39,216` normalized `6`-arcs, of which none is
affinely complete and none is hyperfocused.  The maximum number of affine points
covered by the secants of a `6`-arc is `111` of `121`, and the minimum number of
directions determined is `6`, never the required `5`.  So the second branch is
empty at `k=6`, and moreover the line-hole analogue of `rho_C` at `q=11` exceeds
six.

This is a small result, but it is the first evidence about which branches of the
paper's own equality spectra are inhabited, and the same script generalizes to
`k=8` (`q in {6,22}`, both excluded already by plane order and by the manuscript's
small-even corollary) and to `k=10` (`q in {8,37}`), where `q=37` is the
outstanding odd-order candidate the manuscript explicitly leaves open.  `q=37`
with `k=10` is a larger but still bounded search and would close the last small
even case.

## 6. The reconstruction coda is a coding-theory theorem in disguise

The introduction already records that projective representatives of a `k`-arc
form a parity check matrix of a `[k,k-3,4]_q` MDS code and that `U(A)` is exactly
its projective deep-hole syndrome locus.  The reconstruction proposition then
says that for `q+1 > binom(k,2)` the locus determines the arc, and the corollary
adds that the two setwise stabilizers coincide.  Restated in the coding
vocabulary, that is: the deep-hole locus of such an MDS code determines the code
up to monomial equivalence, together with its automorphism group.

Nobody in this repository has audited that statement against the deep-hole
literature, which is active and which the cross-paper ceilings document reached
only at partial depth for a different paper (Wu--Ding--Chen on deep holes and MDS
extensions).  Two outcomes are possible and both are useful: either the statement
is known there, in which case the coda should cite it and keep the geometric
proof as an alternative, or it is not, in which case the coda is undersold and
should be stated in both vocabularies.  This is also the natural point of contact
with the `reed-solomon` and Clebsch Paper I inverse-deep-hole threads, which is a
reason to route the audit rather than run it inside this lane.

## Where the move is not available

- **The additive constant `3/2`.**  The manuscript's own scale remark explains
  why sharpening the conic-incidence term cannot help, and C626, C627, C638, and
  C639 are four recorded attempts at the required coupling of rank-three
  realization to matching structure, three of them closed negatively with exact
  falsifiers.  C627's surviving lever gives `Delta >= 2`, worth `O(1/sqrt q)` in
  `k`, which is useful for exact finite values and irrelevant asymptotically.  No
  reframing improves this; it needs a genuinely new mechanism.
- **The Kim--Vu transfer.**  The upper bound is an averaging argument over
  `PGL(3,q)` that does not use the conic, and the manuscript says so.  There is
  no predecessor to relocate against and no broader statement in reach; the
  `O(sqrt q (log q)^c)` gap is a construction problem, and C210 through C330
  closed the one construction architecture that was tried.
- **The abstract matching-design classifications.**  Mathon's two-class list and
  Alspach--Heinrich's nonexistence results are hard combinatorial facts at their
  parameters, not reprovable here.  Level-up B must be phrased as a realizability
  theorem or it becomes a forced reframing.
- **The `q=16` finite classification.**  A checked exhaustive covering list is
  what it is; the agreement with Al-Seraji--Al-Ogali is a cross-check the paper
  correctly declines to lean on.

## Ranking by strength gained

1. **Restore the Korchmáros--Nagy--Szőnyi concession** (item 1), preferably in
   the specialization form that item 3 makes available.  Not optional, and cheap.
2. **Promote the exact values at `q=13,17,19` and the `Delta >= 2` design gap**
   (item 2).  Already proved and formalized; pure writing.
3. **The `(k,n)`-arc prescribed-hole identity** (item 3).  Verified here, moves
   the paper into the scope where its closest prior art lives, and converts a
   concession into an instance.  Gated only on the Alabdullah--Hirschfeld read
   before any subsumption wording.
4. **Rank-three realization classification** (item 4).  The crown.  Every settled
   case agrees, the counting argument identifies the target structure, and the
   `k=9` falsifier is cheap.
5. **The hyperfocused identification and the empty `k=6` branch** (item 5).
   Small, already partly done here, and it corrects what the paper claims at the
   line hole.
6. **Route the deep-hole audit for the reconstruction coda** (item 6).

## Audit gates: nothing below may enter the manuscript yet

- Alabdullah--Hirschfeld's `(k,n)`-arc bound, full text, before any statement
  that the generalized identity implies or sharpens it.
- Giulietti--Montanucci, Korchmáros--Szőnyi, and Ng--Wild, full text, before any
  statement about who owns the hyperfocused equality stratum or about direction
  of implication.  The judo survey recorded the same gate; item 5 sharpens what
  to look for, namely whether uniform focus multiplicity is part of their
  definition and whether affinely complete hyperfocused arcs are classified.
- The deep-hole literature for the reconstruction coda (item 6), unaudited.
- The `k=6`, `q=11` computation is exhaustive and reproducible but is a
  scratch-quality artifact by the standards of
  `notes/research-reproducibility-conventions.md`; before it supports a
  manuscript sentence it needs a certificate and an independent replay, not just
  the script recorded below.
- Korchmáros--Nagy--Szőnyi itself needs no new audit: C349 read it at full text
  and recorded the hash, the version of record, and the forward citations.

## Mystery ledger

- **Settled here:** the second equality branch of the affine corollary at `k=6`,
  `q=11`, is empty, and no hyperfocused `6`-arc exists in `AG(2,11)`.
- **Settled here:** the defect identity does not depend on the arc being a
  2-arc; the `(k,n)` form is proved above and reduces correctly.
- **Open, and the reason to run item 4:** why do the concurrency-centre counts
  match the off-arc point counts of `PG(2,k-2)` and `PG(2,k-1)` exactly, in both
  parities, with the odd case off by exactly the nucleus?  Either this is a
  coincidence of two polynomial identities or it is the shadow of a subplane
  closure theorem.  The repository currently proves the consequence in every
  settled case and the mechanism in none.
- **Open:** is the `k=10`, `q=37` equality pair realized?  It is the last small
  even case the manuscript leaves genuinely undecided, and it is a bounded
  search.
- **Open:** does the Korchmáros--Nagy--Szőnyi rational BKS arc have zero or small
  defect relative to its subplane hole?  If it does, the paper's equality and
  stability theory applies to a published object and the concession becomes a
  worked example.  This is computable from their stated parameters once the
  `(k,n)` identity is written down.
- **Not a mystery:** the `3/2` constant.  Four mechanisms have been tried and the
  scale remark explains why the cheap ones cannot work.

## Reproducibility record

The exhaustive `k=6` search in item 5 is
`notes/2026-08-02-arcs-line-hole-equality-k6.py`, SHA-256
`26baf7f9a601eaf69322f02e51bcf28d8f5fd71b63941a5bf0158a66b07a3a07`.  Replay from
the repository root with

```bash
python3 notes/2026-08-02-arcs-line-hole-equality-k6.py
```

Expected output:

```text
q=11 k=6: zero-defect line-hole arcs found: 0
  hyperfocused but not affinely complete: 0
  affinely complete but not hyperfocused: 0
```

The auxiliary counts quoted in item 5 (`39,216` normalized `6`-arcs, maximum
affine coverage `111`, minimum direction count `6`) come from the same
enumeration run with the arc filter only.  The search is exhaustive up to affine
equivalence because the affine group is transitive on ordered triangles and every
`6`-arc contains one, so normalizing three of its points to `(0,0)`, `(1,0)`,
`(0,1)` loses nothing.  No independent replay exists yet, which is why the audit
gate above holds this result outside the manuscript.

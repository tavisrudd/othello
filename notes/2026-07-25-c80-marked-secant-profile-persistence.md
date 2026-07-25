# C80 — marked-secant profile persistence

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The natural persistent marked-secant exchange class is **falsified at
q=17**.

There are two precise levels.

1. The complete clocked marked-secant profile records every quantity in the
   retention inequality: opponent/reply sorts, the marked chord, the full
   histograms of active-line deficiencies deactivated through the reply and
   thinned away from it, killed legal-point count, boundary status,
   normalized retention, residual depth, and all four overload clocks. This
   profile is not a P-certificate. On the q=17 strict-kernel DAG it is
   kernel-membership-mixed in 3,702 profile classes, and its globally safe
   classes cover only 608 of the 610 fibres forced to remain at positive
   overload.
2. Adding the bounded conic/frame orbital data—selected conic parameters,
   all old/marked intruder product orders, all intruder-triple fixed-point
   counts, and live-conic counts—repairs the finite coverage to 610/610.
   But it produces 79,881 exact q=17 profiles and **not one profile recurs
   across the two positive-overload depths**. It is a finite lookup
   refinement, not a persistent exchange class.

Thus the retention algebra plus bounded conic-involution orbit type does
not yield the requested persistent class. This is a bounded falsification
of that proposed proof shape, not a proof that no different recursive
renormalization law exists and not a disproof of
`inf_q rho(S_q)>0`.

## 1. Exact class definitions

For a parent `S`, opponent move `o`, child `C=S+o`, and legal reply `p`,
the clocked marked-secant profile is

```text
(sort(o), sort(p),
 selected/parent-legal/child-legal loads on op,
 histogram{q-|L(C)∩ell| : active ell through p, overload(ell)>0},
 histogram{(q-|L(C)∩ell|, |K_p∩ell|, loss_ell)
           : active ell not through p, loss_ell>0},
 |K_p|,
 [Omega(C+p)=0],
 Omega(C+p)/M(S,o),
 |S|, Omega(S), Omega(C), Omega(C+p), M(S,o)).
```

Here `K_p` is the set of legal points killed by the new secants `pS`.
This contains the full data in the exact destruction identity and
retention inequality from the preceding C80 report.

The normalized orbital refinement drops the five absolute depth/overload
clocks and adds

```text
(selected conic parameters,
 old-old / old-opponent / old-reply product-order multisets,
 opponent-reply product order,
 fixed-point histogram of all intruder triples,
 live-conic counts before opponent / after opponent / after reply).
```

A profile is globally safe at strength `alpha` when every occurrence
targets `K_Omega` and is either an overload-zero boundary target or has
normalized retention at least `alpha`. A forced-positive fibre is a marked
fibre with a positive lower-kernel reply and no overload-zero lower-kernel
reply. Only these fibres test persistence; boundary absorption is admitted
for free.

## 2. Decisive P/N collision

At q=17, take the residual six-cap

```text
S_good = {(5,2),(7,0),(13,4),(14,11),(15,8),(16,16)}
```

with opponent `(8,9)` and reply `(6,12)`. It has

```text
Omega(S_good)=25,
Omega(S_good+o)=1,
Omega(S_good+o+p)=1,
M(S_good,o)=1.
```

The reply has retention ratio one and targets `K_Omega`, hence a proved P
position.

The same complete clocked marked-secant profile occurs for

```text
S_bad = {(2,14),(4,15),(13,4),(14,11),(15,8),(16,16)}
```

with opponent `(7,6)` and reply `(8,5)`. Its target also has positive
overload one and retention ratio one, but it is outside `K_Omega` and the
independent exact cap solver evaluates it **N**.

The common profile is especially rigid:

```text
opponent/reply sorts       intruder / intruder
marked chord loads         selected 0, parent-legal 3, child-legal 2
deactivated overload       none
thinned overload           none
killed legal points        5
depth / overload clocks    6 / 25 / 1 / 1 / 1
normalized retention       1
```

Therefore no union of clocked marked-secant profile classes can both
certify P and cover this forced-positive fibre. This is a literal P/N
collision, not merely a lower-kernel bookkeeping collision.

## 3. Persistence audit

| q | positive kernel states | forced-positive fibres | by residual size |
|---:|---:|---:|---|
| 13 | 32 | 0 | none |
| 17 | 1,083 | 610 | size 4: 513; size 6: 97 |

At `alpha=1/4`:

| profile family | exact profiles at q=17 | mixed | safe-fibre coverage | safe profiles recurring across depths |
|---|---:|---:|---:|---:|
| clocked marked secants | 36,253 | 3,702 | 608/610 | 0 |
| normalized orbital refinement | 79,881 | 122 | 610/610 | 0 |

The orbital refinement separates the displayed collision and every other
forced-positive q=17 fibre, but only by splitting the corpus more finely:
none of its safe profiles occurs at both residual sizes four and six. It
therefore supplies no induction step and cannot enter the required
`Theta(sqrt(q))` depth regime.

The stop condition was the complete chosen strict-kernel response DAG from
all five frozen q=13 and all five frozen q=17 kernel roots. No q=19 or q=23
census was run. The negative is exactly about the two recorded profile
families on this domain.

## 4. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello/rust
```

Generate and check:

```text
python3 scripts/c80_marked_secant_profile_persistence.py
python3 scripts/c80_marked_secant_profile_persistence.py --check
```

Evidence:

- `rust/scripts/c80_marked_secant_profile_persistence.py`, 21,481 bytes,
  SHA-256
  `76b6982a9e534db18b27a01711ffc11407c8516b8e2458096b351c05ed9551aa`;
- `notes/2026-07-25-c80-marked-secant-profile-persistence.json`, 11,417
  bytes, SHA-256
  `80abe5227cb0148b5236fa1fbfd7d2a4b5a966c9741fb9e176139866ff7bb00b`.

The script imports the committed strict-kernel and scale-survivor
implementations. Kernel labels inherit that trust boundary. The marked
profiles are recomputed directly from projective lines, legal masks, conic
involutions, and overload clocks. The bad collision is independently
evaluated with the exact cap minimax solver and is N. There is no second
implementation of the profile enumerator; `--check` is deterministic
content replay plus the exact P/N cross-check.

## `ej` + `tt` closeout

The cheap extra result is the quantifier correction: q=13 has no
forced-positive fibre at all, whereas q=17 has 513 at residual size four
and 97 at size six. Previous positive-target counts mixed these with fibres
that could already absorb at the boundary.

The Tao-style reformulation is that exact class recurrence is the wrong
object. The orbital quotient either forgets enough to suffer a P/N
collision or remembers enough to become a nonrecurring lookup table. A
viable successor must be a **renormalization morphism** between different
depth signatures—delete or contract the completed opponent/reply exchange
and prove that the remaining marked residual returns to a controlled
family. Another static profile enrichment cannot establish persistence.

No further finite feature enrichment is justified without first stating
that cross-depth morphism.

## Mystery ledger

- **[SETTLED negative] Does the exact marked-secant retention profile
  certify the good exchange?** No: the displayed q=17 profile has P and N
  targets.
- **[SETTLED finite] Does bounded conic/frame orbital data repair q=17
  coverage?** Yes, 610/610 at `alpha=1/4`.
- **[SETTLED negative] Does that repaired profile persist across the
  observed positive depths?** No: zero exact profile recurrences between
  residual sizes four and six.
- **[OPEN — cap successor] Is there a contraction/renormalization morphism
  carrying a good size-four exchange into a good size-six exchange
  family?** No candidate map or invariant is proved.
- **[OPEN — C80 crown] Is `inf_q rho(S_q)>0`?** This audit neither proves
  nor disproves it.

## Vibe

This is a clean negative: the most natural static exchange-class proof
shape is gone, but the failure exposes the right dynamic replacement—a
cross-depth renormalization map rather than another classifier.

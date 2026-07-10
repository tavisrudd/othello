# C73 — value-blind secant-packet theorem (off-conic escape structure at the knife edge)

**Date:** 2026-07-10
**Task:** queue §C73 (twelfth pass). Read-firsts: round-1 report §4/§6-Route-1
([`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md)),
the C44 off-conic rider ([`2026-07-10-offconic-escape-margin.md`](2026-07-10-offconic-escape-margin.md)),
C70/C71 (kill-set incidence as the only reply-varying quantity in dΨ).
**Data:** existing feat dumps `notes/data/codex-feat{5,7,11,13,17,19}*.out` only — no new solves.
Single core, RSS negligible (pure parse + prime-field arithmetic). The q=25 `s4arena` census
was not touched.

## Verdict (one line)

A **value-blind selector `L(A)` survives**: `L(A)` = the maximum-legal-incidence
frame-point/on-conic candidate secant. It **uniquely reproduces the observed packet at all three
q=17 extremal classes** and its selected line **carries a P escape in every one of the 68 classes
at q ∈ {11,13,17,19}** (0 failures; strongly non-trivial — the q=17 base rate is 49%). The
stronger on-conic form ("`L(A)`'s conic point is P") is q=17-clean (21/21) but misses at the two
q=11 knife-edge classes. **Failure gate 2 does NOT fire** — incidence alone recovers the P witness,
so the pivot layer is *not* irreducibly witness-anchored at q=17. The recursion lemma is **tested
(existence, 68/68), not proved** (the game-value reduction needs the game tree, which the feat
dumps do not expose).

---

## 0. Setup and the value-blind data

Board = affine plane AG(2,q), cells `(r,c) ∈ F_q²`. A canonical legal size-3 class is
`S3 = {(0,0),(1,1),(r3,c3)}` (partial-permutation cap). By the conic-localization lemma
([`2026-07-07-conic-localization-onconic-escape.md`](2026-07-07-conic-localization-onconic-escape.md)):
`S3` together with the two burned direction points `a=(1:0:0)`, `b=(0:1:0)` forms a projective
5-arc through a unique nondegenerate conic `C`, the hyperbola `(r−ρ)(c−A)=B`, `B≠0`, with `q−1`
affine cells (one per row `≠ρ`, one per column `≠A`). Its `q−4` non-`S3` cells are the on-conic
legal escapes.

**Value-blind reconstruction** (script `c73_secant_algebra.py`): the conic cell set is
`S3 ∪ {pos=on escapes}`. `ρ` = the one row absent from those cells, `A` = the one column absent,
`B = (r−ρ)(c−A)` (asserted constant over all q−1 cells). No P/N label enters. The projective
5-frame on the conic ≅ P¹ is `{0, ∞, t₁, t₂, t₃}` with `tᵢ = rᵢ − ρ`; the on-conic candidates are
the parameters `w ∈ F_q^* \ {t₁,t₂,t₃}` (asserted, q−4 of them). All parse/consistency asserts
pass for every class at every q.

## 1. Candidate-secant algebra (item 1)

A conic point at parameter `t ∈ F_q^*` is `(ρ+t, A+B/t)`. The two burned points are the parameter
values `0` and `∞`. The line through two conic parameters — the **secant** — is, by direct
elimination:

```text
  secant(u, v),  both finite:   u·v·(c−A) + B·((r−ρ) − (u+v)) = 0
  secant(w, 0)   [burned 0]  :  r = ρ + w                (row-parallel line)
  secant(w, ∞)   [burned ∞]  :  c = A + B/w              (col-parallel line)
```

(check: substituting the conic point at parameter `t` into `u·v·(c−A)+B((r−ρ)−(u+v))` gives
`B·(uv/t + t − u − v)`, which vanishes at `t=u` and `t=v`.)

The **full family of frame-point/on-conic-candidate secants** is therefore the `5·(q−4)` lines
`secant(w, F)` for `w` an on-conic candidate and `F ∈ {0, ∞, t₁, t₂, t₃}`. Each is an explicit
line; both of its conic intersection points are known (`F` and `w`), and every object here is
value-blind. The complete incidence table (per candidate secant: legal escapes it meets, and — for
scoring only — their P/N) is built by `c73_secant_algebra.py` / `c73_incidence.py` at
q=11,17 with q=13,19 controls.

### 1a. Independent third reproduction of the packet

Running the reconstruction and flagging classes whose *P* children are collinear reproduces the
round-1 §4 finding a third time, value-blind up to the final collinearity read
(`s4-dumps/2026-07-10/c73/recon.txt`):

```text
==== q=17  classes=21 ====
  cls= 2 ... rho=14 A=4 B=5 tframe=[3, 4, 5]  esc=5  ... ALL-P-COLLINEAR
  cls=17 ... rho=16 A=2 B=15 tframe=[1, 2, 5] esc=5  ... ALL-P-COLLINEAR
  cls=19 ... rho=11 A=7 B=9 tframe=[6, 7, 10] esc=5  ... ALL-P-COLLINEAR
  (all 18 other q=17 classes: not collinear)
==== q=11 classes=8 ====   (none collinear)
==== q=13 classes=12 ====  (none collinear)
==== q=19 classes=27 ====  (none collinear)
```

The three packet lines match round-1 exactly: cls 2 → `r=5` = `secant(w=8, 0)`; cls 17 → `c=r+1`
= `secant(w=14, t₃=5)`; cls 19 → `c=13r` = `secant(w=11, t₁=6)`. (Classes with ≤2 P children would
be trivially collinear — none occur; every q=17 class has ≥5 P children.)

## 2. Predeclare-then-unblind protocol (item 2)

Five value-blind selectors were **predeclared** (each maps a frame `A` to a *set* of candidate
secants, using only `S3`, the conic, and the legal-escape set — never P/N):

| id | selector | motivation |
|:---|:---------|:-----------|
| L1 | candidate secant(s) with the **most legal escape cells** on the line | inspection of cls 2 (§3): the packet was the unique nlegal=13 line |
| L2 | **all** candidate secants through a product point `tᵢtⱼ/tₖ`        | §3.2 product-point prior (the extremal on-conic P is a product point) |
| L3 | among secants through product points, the max-legal-incidence one    | product-point ∩ incidence |
| L4 | `secant(w_pp, 0)` and `secant(w_pp, ∞)` for each product point        | product-point → burned axis-parallel |
| L5 | L1 restricted to the classes where the argmax is **unique**           | uniqueness stress of L1 |

Unblind scoring (values used only here): `hasP_any` = some selected line carries a P escape;
`hasP_all` = every selected line does; `is_packet` = at the 3 extremal classes, the selected set
contains the packet line. Full log: `s4-dumps/2026-07-10/c73/selector_test.txt`. q=17 block and
per-q aggregates verbatim:

```text
########## q=17 ##########
  cls ext onP esc L1n L1P? L1pk   ... (L3, L4 columns omitted here)
    2   Y   1   5   1    Y    Y
   17   Y   1   5   1    Y    Y
   19   Y   1   5   1    Y    Y
  [L1] defined=21/21 hasP_any=21 hasP_all=21 unique=21 FAIL(no P)=[]  extremal_pk=3/3
  [L2] defined=21/21 hasP_any=21 hasP_all=4  unique=0  FAIL(no P)=[]  extremal_pk=3/3
  [L3] defined=21/21 hasP_any=20 hasP_all=19 unique=10 FAIL(no P)=[18] extremal_pk=3/3
  [L4] defined=21/21 hasP_any=20 hasP_all=5  unique=0  FAIL(no P)=[12] extremal_pk=1/3

########## q=11 ##########
  [L1] defined=8/8   hasP_any=8  hasP_all=8  unique=6  FAIL(no P)=[]  extremal_pk=0/0
  [L2] defined=8/8   hasP_any=8  hasP_all=5  unique=0  FAIL(no P)=[]  extremal_pk=0/0
  [L3] defined=8/8   hasP_any=8  hasP_all=8  unique=3  FAIL(no P)=[]  extremal_pk=0/0
  [L4] defined=8/8   hasP_any=8  hasP_all=6  unique=0  FAIL(no P)=[]  extremal_pk=0/0

########## q=13 ##########
  [L1] defined=12/12 hasP_any=12 hasP_all=12 unique=9  FAIL(no P)=[]  extremal_pk=0/0
########## q=19 ##########
  [L1] defined=27/27 hasP_any=27 hasP_all=27 unique=12 FAIL(no P)=[]  extremal_pk=0/0
```

**Negative record (part of the deliverable):**

- **L2 (product-point pencil) fails as a selector** — it returns 4–6 lines per class (`unique=0`),
  and its `hasP_all` collapses (4/21 at q=17): most secants through a product point carry no P.
  Product-point membership alone does not pick the packet.
- **L4 (product-point → burned) fails** — `hasP_all` 5/21 at q=17, and it **misses the packet at
  2 of 3 extremal classes** (`extremal_pk=1/3`; only cls 2's packet is a burned-point secant).
  It also selects a P-free line at q=17 cls 12 (`FAIL(no P)=[12]`). Refuted.
- **L3 (product-point ∩ max-incidence)** reproduces the 3 extremal packets but selects a **P-free
  line at q=17 cls 18** (`FAIL(no P)=[18]`) — so restricting L1 to product points *breaks* the
  no-failure property. The incidence extremum, not the product-point label, is load-bearing.
- **L1 (pure max-legal-incidence) is the winner:** `hasP_any = hasP_all` = 100% at every order,
  `FAIL(no P)=[]` everywhere, `extremal_pk=3/3`, and **`unique=21/21` at q=17** (a q=17-specific
  clean uniqueness; q=11/13/19 have some ties). L5 confirms L1's uniqueness is not needed for the
  no-failure property (the tied cases still satisfy `hasP_all`).

## 3. What L1 selects, and why (mechanism)

The maximum-incidence value is **exactly `q−4`** for every class at q=5,7,11,13,17 (at q=19 it is
q−4 or q−5; q=19 has `bad=0`, so its tie structure is degenerate). A candidate secant meets the
conic in 2 points and the 9 "used" lines (3 rows, 3 columns, 3 `S3`-secants) in the rest; the
max-incidence secant is the one whose used-line intersections **collapse** onto the fewest distinct
forbidden cells. Row-/column-parallel secants (through a burned point) avoid all three used rows
(resp. columns) at once, which is why cls 2's packet is `r=5`. Point-by-point dissection of that
line (`s4-dumps/2026-07-10/c73/null_and_dissect.txt`):

```text
q=17 cls=2 S3=[(0,0),(1,1),(2,5)] conic(rho=14,A=4,B=5)  L1 secant (F=0, w=8), nlegal=13
  line: r = rho+w = 5   (secant through burned point 0 = row-parallel)
  (5,0) usedCol  (5,1) usedCol  (5,4) illegal(S3-secant)  (5,5) usedCol       <- 4 forbidden
  (5,2)P (5,3)P (5,8)P (5,11)P-on (5,14)P  +  (5,6)N (5,7)N (5,9)N (5,10)N (5,12)N (5,13)N (5,15)N (5,16)N
  => 13 legal (5 P + 8 N); the on-conic P point is (5,11).
```

So `L(A)` picks the frame-point/on-conic secant that "wastes" the fewest cells on the used lines
and thereby carries the full `q−4` legal escapes — and at q=17 that secant is unique.

**L1 recovers an on-conic P witness, not just any escape.** `c73_characterize.py`
(`s4-dumps/2026-07-10/c73/characterize.txt`): the on-conic intersection point of L1's selected
secant is itself a **P** on-conic child in **21/21** q=17 classes, **12/12** q=13, **27/27** q=19,
and **6/8** q=11. The 2 q=11 exceptions are exactly the onP=2 knife-edge classes cls 4, 7 — where
L1 is a 5-way tie and the picked conic point is N (the line still carries 4 off-conic P). This
mirrors round-1 §1D (the q=11 extremal defeats value-blind involutive selectors). The L1 conic
point is a **product point in only 10/21** q=17 classes, so "product point" is *not* the selector —
incidence is strictly stronger.

## 4. Null-model control (is 68/68 meaningful?)

`c73_null_control.py` (`s4-dumps/2026-07-10/c73/null_and_dissect.txt`):

```text
  q  #cand/cls  anyP-rate  onP-rate |  L1 anyP   L1 onP
 11        35      0.957     0.607   |     8/8      6/8
 13        45      1.000     1.000   |   12/12    12/12
 17        65      0.490     0.209   |   21/21    21/21
 19        75      1.000     1.000   |   27/27    27/27
```

At q=17 a *random* candidate secant carries a P escape only **49.0%** of the time and has an
on-conic P point only **20.9%** of the time, whereas L1 hits **100% / 100%**. The q=13/19 controls
are uninformative here (`bad ≈ 0` ⇒ nearly every escape is P), which is exactly why the depleted
order q=17 — where N children dominate — is the discriminating test, and L1 is perfect there.

## 5. Recursion / propagation lemma (item 3)

**Claim (existence form):** for the value-blind selected line `L(A)`, some legal point of `L(A)` is
a P child. **Status: tested, holds 68/68** at q ∈ {11,13,17,19}, with the strong `hasP_all`
variant (every tied line carries a P) also 68/68, and it is meaningful (§4). At the three q=17
extremal classes `L(A)` carries **all five** P children (1 on-conic + 4 off-conic), i.e. the
packet.

**What is NOT closed:** the deeper propagation the spec asks for — "what does the game value of a
secant cell reduce to, one move deeper into the zone?" — cannot be derived from the feat dumps,
which record only the immediate P/N of each size-4 child, not the residual game one move below an
off-conic cell on `L(A)`. So the four off-conic P values on the packet are *observed*, not
*reduced*. Proving the propagation (why an off-conic cell on the max-incidence secant is P) needs
the size-4→ residual DAG, a solver query out of this task's data-only budget. This is the single
remaining gap between the surviving selector and a theorem.

C70/C71 convergence note: the only reply-varying quantity left in dΨ is kill-set incidence
(`|K_u ∪ K_v|`, and the `D(z)` deletion gate). `L(A)` is itself an incidence extremum over conic
secants; a natural way to close §5 is to express "off-conic cell on the max-incidence secant" in
kill-set/deletion-set terms and feed it to the C61-successor existential selector lemma. Recorded
as the recommended bridge; not attempted here (no game tree in the data).

## 6. Route verdict (success / failure gates)

| gate | outcome |
|:-----|:--------|
| **Success:** value-blind `L(A)` selecting the packet | **MET** — L1 (max-legal-incidence secant), unique at q=17, `extremal_pk=3/3`. |
| **Success:** local recursion lemma ⇒ P child on `L(A)` | **partial** — existence claim tested 68/68, 0 failures, non-trivial (q=17 base 49%); the game-value *reduction* is not derived (needs the tree). |
| **Failure gate 1:** a q=11/q=17 fan where every candidate formula selects no P child | **did NOT fire** — L1 selects a P-bearing line in all 8 q=11 + 21 q=17 classes. |
| **Failure gate 2:** selecting the secant *requires* knowing the unique P on-conic child | **did NOT fire — REFUTED.** Pure incidence recovers the P witness (q=17: on-conic point P 21/21 with 0 value input). The pivot layer is **not** irreducibly witness-anchored at q=17. |

**Net:** this is a **positive** result. The C44 branch-(ii) risk (that the off-conic pivot is
parasitic on the on-conic witness and therefore un-usable if (ON) fails) is *reduced*, not
confirmed: at q=17 the off-conic packet is recoverable value-blind by an incidence extremum, so a
hypothetical min-witness-0 class at a larger depleted order would still expose its P escapes to the
same selector — *provided* the recursion lemma is eventually proved and the q=11-style knife-edge
tie does not degrade the on-conic form to nothing. The residual worry is the q=11 signature: at the
sharpest depleted knife edge the on-conic form of L1 already fails (2/8), and the tie multiplicity
grows — the same "sharpens as depleted-q grows" trend C68/the C44 rider flagged.

## 7. Pre-registered q=25 out-of-sample test (item 5 — DO run this when q=25 labels land)

`L(A)` needs **no P/N labels** to be computed — only `S3`, the reconstructed GF(25) conic, and the
legal-escape set. So the selector can be evaluated *before* the labels are read. **This prediction
is fixed now, 2026-07-10, before any q=25 label is inspected.**

**Prediction (pre-registered):** for the first arc-depleted q=25 size-3 class (a class with
`onP < q−4 = 21`, the q=25 analogue of q=11/17 depletion), let `L(A)` = the unique-or-tied
maximum-legal-incidence frame-point/on-conic candidate secant. Then

1. **(ESC form, primary):** `L(A)` carries ≥1 P escape. *Predicted TRUE* (68/68 so far).
2. **(ON form, secondary):** the on-conic intersection point of `L(A)` is a P child. *Predicted
   TRUE at non-knife-edge depleted classes; predicted to possibly FAIL at the extremal
   (minimum-onP) q=25 class*, exactly as it fails at q=11 cls 4,7 (5-way tie, N conic point) —
   watch the tie multiplicity.

**Falsifiers:**
- **(ESC) fails** — a depleted q=25 class where `L(A)` carries **no** P escape ⇒ failure gate 1
  fires at q=25; the max-incidence selector is refuted and the pivot layer *is* label-dependent.
- **(ON) fails while (ESC) holds** ⇒ the q=11 knife-edge pattern recurs at q=25; the on-conic form
  is depleted-order-fragile but the off-conic pivot still works — the branch-(ii) structure holds
  in its ESC form.

**Exact command (run in this order — the FIRST two steps are label-blind):**

```bash
cd rust
# (0) obtain the q=25 feat layer (per size-3 class: children with pos=on/ext/int and P/N).
#     Gated per C44 item 5; do NOT launch under the running census. When affordable:
#       ./target/gridcap-c73 feat 25   > ../notes/data/codex-feat25.out     # (feat mode; GF(25))
#     (build the C73 binary from notes/2026-07-06-grid-cap-solver.rs as rust/target/gridcap-c73;
#      never touch rust/target/gridcap-arena.)
# (1) LABEL-BLIND: add q=25 to c73_secant_algebra.PRIME_FILES and extend inv()/mul to GF(25)
#     (irred x^2+3 over F5, per the solver's GF(25) path). Then compute L(A) and RECORD its
#     selected (F,w) + predicted cells WITHOUT reading val= fields:
#       python3 scripts/c73_characterize.py 25        # prints selF, selw, nlegal, tie per class
#     Freeze this output as the pre-registered prediction file.
# (2) UNBLIND: score against the withheld labels:
#       python3 scripts/c73_selector_test.py 25       # L1 hasP_any / hasP_all / FAIL(no P)
#       python3 scripts/c73_null_control.py 25        # base rate vs L1 at q=25
```

The GF(25) extension of `c73_secant_algebra.py` (currently prime-field `pow(x,q-2,q)`) is the only
code change; the selector logic is field-agnostic once `inv`/`mul` are correct.

## 8. Circularity / scope audit

- P/N labels never enter `L(A)`: it is `argmax` over legal incidence, and legality is the cap
  condition (value-blind). Values are used only to *score* the unblind and to *locate* the packet.
- The recursion lemma is reported as an **existence test**, not a proof; the game-value reduction
  is explicitly flagged as un-closed (no tree in the data).
- No exact Z / Grundy / remoteness / strategy depth appears in the selector.
- All algebra is over the prime field via the conic reconstruction; q=9 (GF(9)) is excluded from
  the modular reconstruction and noted as such; the depleted orders {11,17} and controls {13,19}
  are prime and fully covered.
- Failure gate 2's refutation is a claim about *value-blind recoverability of the witness*, not a
  game-value theorem — stated as such.
- The q=25 prediction is fixed before any q=25 label is read; the census process was not touched.

## 9. Reproduce

```bash
cd rust
python3 scripts/c73_secant_algebra.py  17 11 13 19 5 7   # reconstruction + ALL-P-COLLINEAR flags
python3 scripts/c73_incidence.py       17 2              # full candidate-secant incidence, one class
python3 scripts/c73_selector_test.py   17 11 13 19       # predeclare-unblind protocol log
python3 scripts/c73_characterize.py    17 11 13 19       # what L1 selects (ESC vs ON form)
python3 scripts/c73_null_control.py                      # base-rate control + cls-2 dissection
```

Durable scripts: `rust/scripts/c73_{secant_algebra,explore,incidence,selector_test,characterize,null_control}.py`.
Captured outputs: `rust/s4-dumps/2026-07-10/c73/{recon,selector_test,characterize,null_and_dissect}.txt`.

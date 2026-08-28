# C973 — verification of review Finding 1 (scope of the containment theorem)

**Lane:** `reed-solomon` · **Date:** 2026-08-28 · **Status:** verification pass
complete; conclusion CONFIRMED with two qualifications and one correction to the
reviewer's consequence list

Sources verified against: `c973-2026-08-28-review-geometry.md` (Finding 1,
lines 89–152), `c973-2026-08-26-simultaneous-marker-theorem.md` §§2–4,
`c973-2026-08-26-two-seam-reconstruction.md` §§1–2,
`c973-2026-08-26-first-lucas-boundary.md` §§1,4,
`c973-2026-08-27-gf64-trace-balance.md` §1 and closure,
`notes/2026-08-02-c620-higher-lucas-modular-carriers.md` §Result,
`notes/handoffs/2026-07-22-reed-solomon-deep-holes.md` (C532 statement).

## 0. Verdict

**CONFIRMED** on the mathematical substance, with two qualifications.

1. The escape argument uses the hypothesis on `f` exactly once, applied to `f`
   itself through the contrapositive of (6). There is no stagewise hypothesis on
   marker-contracted descendants, and the genus-one threshold inequality (13),
   which yields (15) and (17), is applied to the R5 contraction `b=kappa_f(R)`,
   whose required property is *supplied* by that single hypothesis rather than
   assumed afresh. The reviewer's structural reading is exact.
2. Proposition 2.1's proof does give the branchwise conclusions the reviewer
   lists, so the failure set of the escape mechanism is contained in
   `P_r ∪ M^max_{6,2} ∪ M^max_{7,2}`, and the sharpened form of (15) is a
   restatement, not a new theorem.
3. All three Hankel computations reproduce exactly, and an exhaustive extension
   over `GF(2)`, `GF(4)`, `GF(3)`, `GF(7)` (plus sampling over `GF(8)`, `GF(9)`)
   finds **no** point of any nonempty R11 maximal Lucas carrier whose `L_f` lies
   in `B_5^red`.

**Qualification A (resolved 2026-08-28).** As first written, this verification
held the strengthening back on two unproved inputs: the persistent-branch upward
induction (review Finding 2, TS-2.1a) and the characteristic-three wild-cone
ruling calculation (TS-2.1c, C597 input). Finding 2 is now closed by citation
repair — `c973-2026-08-28-level-uniform-polar-lemma.md` shows that C536 §2 (5)–(7)
and its Result (1) already prove the level-`n` coherent-Fano ideal identity
`J_n = I_n` for **every** `n >= 5` over `Z`, so the two-seam note was entitled to
the theorem and was merely citing it as a single-level fact. That note also
supplies the two-line `(*_d)` induction, the coefficientwise phrasing that
absorbs the rank-one polar case, and the caveat that the lemma must be quoted
over the algebraic closure (its "for every `F_q`-rational `lambda`" form is false
over `F_2`, counterexample `g = (0,1,…,1,0)`). The strengthening is therefore
banked and has been written into the notes; see §6. TS-2.1c remains an inherited
input, unchanged in status from the current (15), which depends on it identically.

**Qualification B (the `49 > 48` coincidence is not what the reviewer thinks).**
See §4.3. The `49` is the Hasse floor for *any* genus-one curve over `GF(64)` and
carries no information; the two `48`s have unrelated provenance, and the GF(64)
note's load-bearing closure is `52` versus `4`, not `49` versus `48`. The claim
that the two arguments are "the same count performed on two different models of
the same curve" is **not established**. The reviewer's more important consequence
— that GF(64)/R11 falls inside the theorem — follows from the strengthening alone
and does not need the coincidence.

**Correction to consequence 5.** The reviewer's list of still-open fields omits
`GF(49)`. In characteristic seven the R11 carrier `M^max_{11,7}=P<e_4,e_5,e_6>`
is nonempty, `49 < Q_11^* = 63`, and `c973-2026-08-26-first-lucas-boundary.md`
closes characteristic seven only for `q >= 343`, explicitly disclaiming fields
below it. So the open list is `GF(16)`, `GF(32)`, `GF(27)`, `GF(49)`.

## 1. Which hypotheses the escape argument actually uses

### 1.1 One hypothesis, applied to `f` itself

`simultaneous-marker-theorem.md` §2, immediately after the reduced carrier (7):

> Assume now that `f` is outside the upper carrier.  By the contrapositive of
> (6), `L_f` is not contained in (7).  Hence `D|L_f` is nonzero and at least one
> listed generator `A|L_f` is nonzero.  Since the coordinate ring of `L_f` is a
> domain,
>
>     F = D A                                      (8)
>
> is nonzero on `L_f`.

That is the entire use of the hypothesis. It is applied to `f`, once, and the
object it constrains is `L_f = P(im T_f)`, the projectivised row space of the
**composite** catalecticant `Cat_{m,4}(f)` of `f` — not of any contraction of `f`.

The note states this closure property twice more, in its own words:

> No intermediate lower package, old-marker divisor, or parameter-by-parameter
> escape assertion occurs in the proof.  (§Result)

> It removes every intermediate lower-package hypothesis.  (§4, after (15))

and the two-seam note opens with the matching claim:

> Neither statement assumes rational markers, a covering radius, an
> intermediate lower package, or a projectivized map at a zero contraction.
> (`two-seam-reconstruction.md` §Result)

### 1.2 The composite contraction is genuinely one-step

`two-seam-reconstruction.md` (1)–(2) defines, for `f ∈ Γ^{m+4}E` with `m=r-5`,

    T_f : Sym^m(E^vee) -> Γ^4 E,   R |-> iota_R f,
    h |-> h Cat_{m,4}(f),

    Cat_{m,4}(f) = ((m+1) x 5) matrix with (i,j) entry a_{i+j},  0<=i<=m, 0<=j<=4.

`simultaneous-marker-theorem.md` §1 justifies the one-step reading intrinsically:

> This definition is intrinsic, commutes with base change and `GL(E)`, and
> includes a factor at infinity without a separate coordinate convention.  It
> also agrees with any iterated contraction after factoring `R` over an
> extension field, because multiplication in the symmetric algebra is
> commutative.

So the stagewise picture is a *consequence* of the composite object, never an
input. This is the crux of Finding 1 and it holds.

### 1.3 Which curve the threshold inequality is applied to

`simultaneous-marker-theorem.md` §4:

> Put `b=kappa_f(R)`.  Because `b` is outside the R5 carrier, its off-diagonal
> fiber square is a geometrically integral curve of arithmetic genus one.

The genus-one curve, the exact R5 count (12), and hence the inequality (13) that
produces the thresholds (1)/(2) and the pointed inequality (17), all live on the
**terminal R5 syndrome** `b`, i.e. on the degree-`m` contraction of `f`. The
property "`b` outside the R5 carrier" is delivered by the Vandermonde grid lemma
applied to the single selector `S_f` of (9), which was built from the one
hypothesis on `f`. No hypothesis is ever imposed on an intermediate descendant.

**Consequence.** `M^max_{r,p}` enters the theorem at exactly one point: as the
right-hand side of (6). Any sharpening of (6) propagates verbatim to (15) and
(17) with no other edit to §§1–4.

### 1.4 Proposition 2.1's branchwise conclusions, quoted

`two-seam-reconstruction.md` §2, proof of Proposition 2.1, branch by branch:

- **Persistent** (`L_f ⊆ V(D)`): "Vary the fixed `m-1` factors and use density as
  in (4).  Repeating this argument upward one level at a time gives `f ∈ P_r`."
  (7). Carrier term absent.
- **Residual, `p ∉ {2,3}`**: "The projected Veronese contains no projective line.
  Hence a projective linear space contained in it has dimension zero.  Thus `T_f`
  has rank one … which places `f` on the rank-one normal rational curve and hence
  in `P_r`." Carrier term absent.
- **Residual, `p = 3`**: "A zero-dimensional `L_f` already means `rank T_f=1` and
  has the same conclusion.  Thus again `f in P_r`." Carrier term absent.
- **Residual, `p = 2`**: "Containment in the residual plane means that the first
  and last coordinates of every vector in `im T_f` vanish.  Equivalently, the
  first and last columns of (2) vanish: `a_0=…=a_m=0`, `a_4=…=a_{m+4}=0` (8).
  For `m=1` … `f ∈ P<e_2,e_3> = M^max_{6,2}` (9).  For `m=2`, only `a_3` may
  survive, giving `f=[e_3] ∈ M^max_{7,2}` (10).  For `m>=3`, the two intervals in
  (8) cover every coefficient index, forcing `f=0`, impossible projectively."

The union of the four outputs is `P_r ∪ M^max_{6,2} ∪ M^max_{7,2}`, which is what
Finding 1 asserts. Independent check of the two special carriers against the Lucas
definition (1) of `first-lucas-boundary.md`, `M^max_{r,p}=P<e_j : C(d,j) ≡ C(d,j-1) ≡ 0>`
with `d=r-2`: Pascal row 4 mod 2 is `1,0,0,0,1`, adjacent zero pairs at `j=2,3`, so
`M^max_{6,2}=P<e_2,e_3>`; Pascal row 5 mod 2 is `1,1,0,0,1,1`, adjacent zero pair at
`j=3` only, so `M^max_{7,2}=[e_3]`. Both match (9)–(10) exactly, so at `r ∈ {6,7}`
the char-2 residual branch returns the *whole* maximal carrier and at `r >= 8` it
returns nothing.

### 1.5 The identity of `D`

`two-seam-reconstruction.md` (5) calls `D` "the cubic Hankel determinant";
`simultaneous-marker-theorem.md` (7) records `deg D = 3`. The R5 syndrome is
`b = (c_0,…,c_4) ∈ Γ^4 E`, so `D` is the determinant of the `3x3` catalecticant

    H(b) = [[c_0,c_1,c_2],[c_1,c_2,c_3],[c_2,c_3,c_4]],

    D = c_0 c_2 c_4 - c_0 c_3^2 - c_1^2 c_4 + 2 c_1 c_2 c_3 - c_2^3.

This is pinned by the notes themselves rather than assumed: §2 of the theorem note
states that vanishing of the three minors `c_1c_3-c_2^2`, `c_1c_4-c_2c_3`,
`c_2c_4-c_3^2` "forces the Hankel determinant `D` to vanish", and expanding the
determinant above along its first row gives exactly
`c_0(c_2c_4-c_3^2) - c_1(c_1c_4-c_2c_3) + c_2(c_1c_3-c_2^2)`. `V(D)` is the
rank-at-most-two locus of binary quartics, the chordal cubic hypersurface of the
rational normal quartic in `P^4`.

Restrictions used below:

    D|{c_4=0}      = -c_0 c_3^2 + 2 c_1 c_2 c_3 - c_2^3
    D|{c_4=0}, p=2 =  c_0 c_3^2 + c_2^3                    (reviewer's formula)
    D|{c_3=c_4=0}  = -c_2^3                                (reviewer's formula)

Both of the reviewer's restricted formulas are correct.

## 2. The three computations

Method: `Cat_{m,4}(f)` built as (2) with `(i,j) |-> a_{i+j}`; row space by exact
Gaussian elimination over the stated field; `D` restricted to the row space by
symbolic expansion of `D(sum_i t_i B_i)` in the row-space basis `B`, then tested
for identical vanishing. Everything below is exact, not sampled. Script:
`hankel.py` / `carrier_scan.py` in the session scratchpad (throwaway; the results
are reproduced verbatim here).

Setting throughout: `r = 11`, `d = r-2 = 9`, `m = r-5 = 6`, `f ∈ Γ^{10}E`, so
`Cat_{6,4}(f)` is `7 x 5`.

### 2.1 `p = 2`, `f = e_3`

    Cat_{6,4}(e_3) =
        [0 0 0 1 0]
        [0 0 1 0 0]
        [0 1 0 0 0]
        [1 0 0 0 0]
        [0 0 0 0 0]
        [0 0 0 0 0]
        [0 0 0 0 0]

Rank 4, pivots `c_0,c_1,c_2,c_3`, so `L_f = {c_4 = 0}`, a hyperplane `P^3 ⊂ P^4`.

- `D|L_f = c_0 c_3^2 + c_2^3 ≠ 0` in char 2 (nonzero on 8 of the 15 `F_2`-points
  of `L_f`), so **`L_f ⊄ V(D)`**.
- `c_0` is not identically zero on `L_f` (nonzero on 8 of 15), so
  **`L_f ⊄ V(c_0,c_4)`**.

Hence `L_f ⊄ B_5^red`: `f = e_3` is **not** an obstruction to escape, although it
lies in `M^max_{11,2}`. The reviewer's description "a single nonzero anti-diagonal"
is right modulo the anti-diagonal occupying only rows 0–3 (rows 4–6 vanish).

### 2.2 `p = 2`, generic point of the R11 binary carrier

`first-lucas-boundary.md` (2) gives `M^max_{11,2} = P<e_3,e_4,e_5,e_6,e_7>`.
Representative full-rank point `f = e_6`:

    Cat_{6,4}(e_6) =
        [0 0 0 0 0]
        [0 0 0 0 0]
        [0 0 0 0 1]
        [0 0 0 1 0]
        [0 0 1 0 0]
        [0 1 0 0 0]
        [1 0 0 0 0]

Rank 5, so `L_f = P^4` and containment in `B_5^red` is impossible outright.

Exhaustive rank census of the whole carrier (all nonzero `(a_3,…,a_7)`):

| field   | nonzero carrier points | rank 3 | rank 4 | rank 5 | `L_f ⊆ V(D)` | `L_f ⊆ V(c_0,c_4)` |
|---------|-----------------------:|-------:|-------:|-------:|-------------:|-------------------:|
| `GF(2)` |                     31 |      0 |      3 |     28 |            0 |                  0 |
| `GF(4)` |                   1023 |      0 |     15 |   1008 |            0 |                  0 |
| `GF(8)` |     20000 (sampled)    |      0 |     42 |  19957 |            0 |                  0 |

### 2.3 `p = 3`, `f = e_2`

    Cat_{6,4}(e_2) =
        [0 0 1 0 0]
        [0 1 0 0 0]
        [1 0 0 0 0]
        [0 0 0 0 0]
        [0 0 0 0 0]
        [0 0 0 0 0]
        [0 0 0 0 0]

Rank 3, pivots `c_0,c_1,c_2`, so `L_f = {c_3 = c_4 = 0}`, a plane `P^2 ⊂ P^4`.
`D|L_f = -c_2^3 ≠ 0` (nonzero on 18 of the 26 `F_3`-points), so `L_f ⊄ V(D)`.
Being a plane, `L_f` is also not a ruling line of the wild cone, so
`L_f ⊄ V(I_{A,3})`. Hence `L_f ⊄ B_5^red`.

Note that `M^max_{11,3} = P<e_2,…,e_8>` (`first-lucas-boundary.md` (2)), not the
single point `[e_2]`; `e_2` is its most degenerate point and therefore the hardest
case for escape. Exhaustive census of the full char-3 carrier:

| field   | nonzero carrier points | rank 3 | rank 4 | rank 5 | `L_f ⊆ V(D)` |
|---------|-----------------------:|-------:|-------:|-------:|-------------:|
| `GF(3)` |                   2186 |      8 |    120 |   2058 |            0 |
| `GF(9)` |     30000 (sampled)    |      0 |     91 |  29909 |            0 |

### 2.4 Extension: characteristic seven, and a structural shortcut

`M^max_{11,7} = P<e_4,e_5,e_6>`. Exhaustive over `GF(7)`: all 342 nonzero carrier
points have `rank Cat_{6,4}(f) = 5`, so `L_f = P^4` and none lies in `B_5^red`.

The census suggests a computation-free replacement for the whole check, which is
the cheapest way to make the sharpening referee-proof:

> **Lemma (dimension obstruction).** `V(D) ⊂ P^4` is an irreducible cubic
> hypersurface (the chordal variety of the rational normal quartic), so it
> contains no linear subspace of dimension `>= 3`; and `V(c_0,c_4)` is a plane,
> so it contains no linear subspace of dimension `>= 3`. Hence
> `rank Cat_{m,4}(f) >= 4 ⟹ L_f ⊄ B_5^red` in characteristic two, and likewise
> in odd characteristic once the residual component is known to contain no
> `3`-plane.

Corroborating check: no `F_2`-rational hyperplane of `P^4` (0 of 31) has
`D` vanishing identically on it, consistent with `D` having no linear factor.
With the lemma, the R11 carrier tables above collapse to "min rank over the carrier
is 3 (char 3) or 4 (char 2, 7)", and the only case needing the explicit
`D`-restriction is the eight rank-3 char-3 points, all of which escape.

## 3. What the sharpening needs in writing

To turn Finding 1 into text, three edits and one prerequisite.

1. **Restate Proposition 2.1 branchwise instead of coarsening to a union.**
   Replace (6) by
   `L_f ⊆ B_5^red ⟹ f ∈ E_r`, where `E_r = P_r` if `p` is odd or (`p=2` and
   `r >= 8`), and `E_r = P_r ∪ M^max_{r,2}` if `p=2` and `r ∈ {6,7}`.
   The existing proof already establishes this verbatim; only the statement line
   and the closing sentence of the char-2 paragraph change.
2. **Propagate through the theorem note.** In §2 replace "Assume now that `f` is
   outside the upper carrier" by "outside `E_r`", and restate (15) as
   `SplitFree_r(F_q) ⊆ E_r(F_q)`. Nothing else in §§1–5 refers to `M^max_{r,p}`,
   so no other edit is required. The threshold arithmetic (1), (2), (13), (17) is
   untouched.
3. **Retire the crown sentence in §6.** "The remaining mathematical crown is now
   cleanly separated: determine the split-free points of `M^max_(r,p)`" is no
   longer the residue of this theorem. The residue is the sub-threshold regime
   `q < Q_r^*` (resp. `Q_{r,2}^*`) together with the two char-2 carriers at
   `r ∈ {6,7}`. The all-characteristic exact deep-hole list still needs the
   carrier analysis for those small-`q` fields, so the crown survives in reduced
   form rather than disappearing.
4. **Prerequisite: close review Finding 2 first — done, see §6.** The odd-characteristic half of
   the sharpening is carried entirely by the persistent branch's conclusion
   `f ∈ P_r`, which currently rests on "Repeating this argument upward one level
   at a time", i.e. on the unproved level-`n` coherent-Fano family for
   `n = 5,…,m+4`. Publishing the sharpened (15) before that lemma is stated and
   proved would put more weight on the weakest step in the chain. Adding the
   dimension lemma of §2.4 does not repair this: it repairs only the residual
   branch, not the persistent one.

Optional, cheap, and worth doing regardless: add the §2.4 dimension lemma as a
remark after (6). It makes the residual branch's emptiness for `m >= 3` visible
without the coefficient bookkeeping of (8), and it is the statement a referee will
want when asked why a five-row catalecticant cannot degenerate into a plane.

## 4. Reconciliation with the lane's prior results

### 4.1 C620 — consistent, and independent corroboration

`notes/2026-08-02-c620-higher-lucas-modular-carriers.md` proves, for
`k = F_{2^m}`, `m >= 4`, that the first fresh higher Lucas carrier
`M_9 = P<e_2,…,e_7> ⊂ P(Γ^9 E)` — that is, `M^max_{10,2}` — has empty split-free
locus:

> `M_9(k) ∩ {split-free syndromes} = ∅`  (1) … This holds over every field in
> which the full-length redundancy-ten PRS problem is admissible.

Finding 1 predicts exactly this for `r = 10` (`m = 5 >= 3`) at `q >= Q_{10,2}^* = 50`,
so the first binary field it reaches is `q = 64`. C620 proves the same emptiness
for **all** admissible binary fields including `q = 16` and `q = 32`. So:

- **not contradicted** — the two agree wherever both apply;
- **not subsumed** — C620 is strictly stronger, covering `q = 16, 32` below the
  simultaneous theorem's threshold, at the cost of an explicit orbit enumeration
  (292 and 1090 Borel orbits respectively);
- **corroborating** — C620 is an independent, harder proof of precisely the
  statement Finding 1 says Proposition 2.1 delivers for free above threshold. That
  a separate genus-one Artin–Schreier argument reached the same conclusion at
  `r = 10` is evidence for, not against, the reviewer's reading.

The apparent oddity — why C620's *asymptotic* block (`q >= 64`) was proved at all
if Proposition 2.1 makes it free — is chronological, not logical: C620 is dated
2026-08-02 and the simultaneous-marker theorem is dated 2026-08-26. There is no
inconsistency, only redundancy created after the fact.

### 4.2 C532 — consistent

C532 (recorded in `notes/handoffs/2026-07-22-reed-solomon-deep-holes.md`): "For
`q=2^m>=64`, every deep direction lies in the persistent/Lucas union; every
stratum in the finite-orbit block `P(U)` is shallow, and only the complementary
two-dimensional quotient remains as an explicit residue." This is the *unsharpened*
containment `SplitFree_10 ⊆ P_10 ∪ M^max_{10,2}` at `r = 10`, binary, `q >= 64` —
weaker than both C620 and the sharpened (15), and implied by either. Consistent;
Finding 1 makes C532's Lucas term at `r = 10` removable, which C620 had already
done by other means.

### 4.3 The `49 > 48` coincidence — partly, and not in the way claimed

The reviewer writes that (17) with `s=1, p=2, m=6` requires
`q+1-2 sqrt q > 6 + 6·7 = 48`, and that `q=64` gives `65-16 = 49 > 48`; he then
observes that the GF(64) programme's own margin is "at most 48 bad rational points
versus the Hasse lower bound 49", and infers the two arguments are the same count
on two models of the same curve. The arithmetic on both sides checks out
(`B_2 = 6`, `6(m+s) = 42`, total 48; `Q_{11,2}^* = 66-22+floor(2 sqrt 42) = 44+12 = 56`;
`Q_{11}^* = 66-16+floor(2 sqrt 48) = 50+13 = 63`). The inference does not.

- The `49` is `q+1-2 sqrt q` at `q = 64`: the Hasse floor for *any* genus-one
  curve over `GF(64)`. Both arguments run on genus-one curves over `GF(64)`, so
  both must produce `49`. It is a shared constraint, not a shared computation.
- The two `48`s are built from unrelated ingredients. In the theorem note,
  `48 = B_2 + 6(m+s) = 6 + 6·7`: a branch budget plus six ordered fiber-square
  points per retained marker root. In `c973-2026-08-27-gf64-trace-balance.md`,
  the `48` is an affine point count on the trace-one Artin–Schreier twist `C1`,
  converted by `48/2 = 24` rootless parameters and compared against the C620
  selector budget `23 = 22 + 1` (§"The complete C620 selector restricted to `h_a`
  has degree at most 22 … Requiring `a != 0` costs one further value", giving
  `32 > 22+1` at (7)). Nothing matches term by term.
- The GF(64) note's *final* closure does not use `49` versus `48` at all. Its
  load-bearing chain is "`#C1>=50`, hence uniformly `#C1>=52`. At most four
  rational points lie over the poles and infinity, so at least `(52-4)/2=24`
  finite parameters are rootless. Since `24>23`, all seven sextics close
  simultaneously." The `49`/`48` pair appears only in the superseded sharp-boundary
  localization paragraph, where "Hasse alone permits 23 rootless parameters there,
  while the selector budget is 23" — the one-point gap that the 3-isogeny/parity
  argument was invented to close.

So: the numerical coincidence is real but carries no structural content, and the
final GF(64) argument is a genuinely different count. What *is* correct is the
reviewer's larger consequence 4: if the sharpening holds, the plain (unpointed)
theorem at `r = 11`, `p = 2` needs only `q+1-2 sqrt q > B_2 + 6m = 6 + 36 = 42`,
and `q = 64` gives `49 > 42` with threshold `Q_{11,2}^* = 56 <= 64`. GF(64)/R11
falls inside the theorem, and the trace-balance / étale-cyclic-cubic / 3-isogeny
programme re-proves a special case — for reasons independent of the `48`
coincidence.

### 4.4 Effect on the R11 block

`c973-2026-08-26-first-lucas-boundary.md` §4 closes R11 at `q >= 128` (char 2),
`q >= 81` (char 3), `q >= 343` (char 7), and explicitly disclaims small binary
fields and characteristic-seven fields below 343. Under the sharpening the whole
R11 carrier block closes at `q >= Q_{11,2}^* = 56` (char 2) and
`q >= Q_{11}^* = 63` (odd), so:

| char | carrier                 | old closure | sharpened closure | fields left open   |
|------|-------------------------|------------:|------------------:|--------------------|
| 2    | `P<e_3,…,e_7>`          |    `q>=128` |           `q>=56` | `GF(16)`, `GF(32)` |
| 3    | `P<e_2,…,e_8>`          |     `q>=81` |           `q>=63` | `GF(27)`           |
| 7    | `P<e_4,e_5,e_6>`        |    `q>=343` |           `q>=63` | `GF(49)`           |

The gain is real at `GF(64)` (char 2) and nil in characteristic three and seven,
where the next prime power above the sharpened threshold is the one already
covered (`81` and `343`). `GF(49)` is open under both the old and the sharpened
statement, which is why it belongs on the reviewer's consequence-5 list.

## 5. Summary of what was checked and how

| item                                                          | method                                      | result |
|---------------------------------------------------------------|---------------------------------------------|--------|
| single hypothesis on `f`, no stagewise descendants             | full read of theorem note §§1–4, quoted     | CONFIRMED |
| threshold (13)/(15)/(17) applied to `b=kappa_f(R)`, not to `f` | quoted §4                                   | CONFIRMED |
| Prop 2.1 branch outputs = `P_r ∪ M^max_{6,2} ∪ M^max_{7,2}`     | full read of two-seam §2, quoted            | CONFIRMED |
| `M^max_{6,2}`, `M^max_{7,2}` match the Lucas definition         | Pascal rows 4, 5 mod 2 recomputed           | CONFIRMED |
| identity of `D` as the `3x3` catalecticant determinant          | cross-checked against the minors in §2      | CONFIRMED |
| `p=2, f=e_3`: `L_f={c_4=0}`, `D|≠0`, `c_0|≠0`                   | exact, `GF(2)`                              | CONFIRMED |
| `p=2` generic carrier point: rank 5, `L_f=P^4`                  | exhaustive `GF(2)`, `GF(4)`; sampled `GF(8)`| CONFIRMED |
| `p=3, f=e_2`: `L_f={c_3=c_4=0}`, `D|=-c_2^3≠0`                  | exact, `GF(3)`                              | CONFIRMED |
| no R11 carrier point anywhere has `L_f ⊆ B_5^red`               | exhaustive `GF(2),GF(4),GF(3),GF(7)`        | CONFIRMED |
| C620 consistency at `r=10` binary                               | read C620 §Result                           | consistent, C620 stronger |
| C532 consistency                                                | read handoff statement                      | consistent, C532 weaker |
| `49 > 48` = GF(64) genus-one budget                             | read GF(64) note §1 and closure             | REFUTED as an identification; coincidence only |
| reviewer's open-field list                                      | cross-check against R11 char-7 disclaimer   | incomplete: add `GF(49)` |

## 6. Applied repairs (2026-08-28)

Finding 2 was closed by citation repair in
`c973-2026-08-28-level-uniform-polar-lemma.md`, so the sharpening of §3 was
written into the notes rather than left as a recommendation. Files changed and
sections touched:

| file | section | change |
|---|---|---|
| `c973-2026-08-26-two-seam-reconstruction.md` | §2, Proposition 2.1 proof, "Persistent component" | Replaced the "repeating this argument upward one level at a time" paragraph. Introduces `Sigma_(2,n)` and records `P_r = Sigma_(2,m+4)`, `V(D) = Sigma_(2,4)`; states Lemma `(F_n)` coefficientwise as a displayed lemma; cites C536 §2 (5)–(7) plus Result (1) for the level-uniform ideal identity `J_n = I_n`, `n >= 5`, over `Z`, with a pointer to the lemma note §§2–5; notes that the coefficientwise hypothesis absorbs the zero and rank-one polar families with no case split and that the lemma must be read over the algebraic closure, with the `F_2` counterexample; runs the `(*_d)` induction, `4 <= d <= m+4`, to (7); records that no density step is used and that `n >= 5` is sharp. |
| `c973-2026-08-26-two-seam-reconstruction.md` | §5 Trust boundary, first bullet | Sharpened "C536's coherent-Fano identity for the persistent component" to the level-uniform ideal identity `J_n = I_n` for every `n >= 5`, with both citations. |
| `c973-2026-08-26-simultaneous-marker-theorem.md` | §6, crown paragraph | Added a "Superseded 2026-08-28" note pointing at (15') and stating the crown's reduced surviving form. |
| `c973-2026-08-26-simultaneous-marker-theorem.md` | §Open review gates | One paragraph recording that gates 1 and 5 are answered by the new section. |
| `c973-2026-08-26-simultaneous-marker-theorem.md` | new §"Strengthened containment (2026-08-28)" | Quotes the single-hypothesis sentence from §2; records that the threshold count runs on `b = kappa_f(R)`, not on `f`, and that `M^max_(r,p)` enters only through (6); lists Proposition 2.1's four branches with the repaired persistent branch; derives `E_r`; states Theorem (15') and its proof; states the pointed variant (17') with the previously implicit hypothesis `q + 1 > s`; gives the five consequences with the threshold arithmetic (`Q_11^* = 63`, `Q_(11,2)^* = 56`, `49 > 42` plain and `49 > 48` pointed at GF(64)); adds an Evidence-boundary paragraph separating the algebraic proof from the corroborating carrier scan and stating the scan's coverage and its non-load-bearing status under the reproducibility conventions, plus the dimension-obstruction shortcut; adds the two-layers-of-slack remark on `V(D)`. |
| `c973-2026-08-27-carrier-nucleus-compression.md` | §8.2, before (25u) | Replaced the imported "in the three-line coefficient formulas its parameters are `u=s=0` and `v=-eta^2`" with the inline expansion of `g = (L_p+eta)(L_p-eta)L_r`, giving `g_9=1`, `g_7=r-p`, `g_5=p(p-r)`, `g_3=p^2 r+v`, `g_1=rv`, all even coefficients zero, hence (25u) directly. The two vectors were verified by direct expansion before the edit; the imported claim was correct, and the derivation is short enough to inline rather than cite, which closes Finding 7's dependency on `c973-2026-08-27-gf27-three-line-reduction.md`. The consequent (25v), `lambda^2 = rv/(p^2(r-p))`, was rechecked against the new coefficients and is unchanged. |
| `c973-2026-08-26-digit-stripping-exact-sequence.md` | §5, after (7a) | Sharpened the codimension bound from three to four with the two-line reason (`nu(d) >= 2` for `d >= 1`; `eta(d) >= 2` for a nonempty carrier, since `eta(d) = 1` gives `dim C_d = dim Z_d = 0`), and recorded that `p=3`, `d=9` attains it. Note (7a) lives in this note, not in the carrier-nucleus note as the task brief supposed; the carrier-nucleus note contains no codimension claim. |
| `c973-2026-08-26-digit-stripping-exact-sequence.md` | §5, density sentence after (7b) | Density `q^(-nu(d)-eta(d))` now also recorded as at most `q^(-4)`. |
| `c973-2026-08-26-digit-stripping-exact-sequence.md` | §3 opening and §5 opening | Finding 8: the Lucas digit congruence relabelled from the duplicated `(3)` to `(Lu)`, with a parenthetical saying the numbered range (1)–(6) now refers only to the exact sequences and support formulas; the ambiguous "For completeness, (3) follows from the same calculation" now reads "the nucleus sequence (3) of §2". The nucleus sequence keeps the label `(3)`, so every downstream reference to it, including "(3)–(6) are the proof", is unchanged and now unambiguous. |
| `c973-2026-08-28-finding1-verification.md` | §0 Qualification A, §3 item 4, this §6 | Qualification A rewritten as resolved; the prerequisite item marked done; this repair record added. |

Verified before editing, not merely transcribed: the `(25u)` coefficient vectors
(direct expansion of `(L_p+eta)(L_p-eta)L_r` in characteristic three, matching
both vectors and reproducing (25v)); the sharpened codimension bound, including
its attainment at `p=3`, `d=9`, cross-checked against
`dim C_9 = 7 = dim M^max_(11,3)`, and against `p=2`, `d=9` (`nu=4`, `eta=2`,
`dim C_9 = 5 = dim M^max_(11,2)`) and `p=7`, `d=9` (`nu=6`, `eta=2`,
`dim C_9 = 3 = dim M^max_(11,7)`); and the Pascal rows 4 and 5 mod two behind
`M^max_(6,2)` and `M^max_(7,2)`.

Not changed, and still inherited on trust: C597's characteristic-three
linear-space classification (TS-2.1c), the exhaustive characteristic-wise
cyclic/inseparable terminal classification, and the exact R5 count with branch
budgets `B_2 = 6`, `B_p = 12`. The last is the most load-bearing unchecked number
in the programme — every threshold in (1), (2), (13), (17), (19) is a function of
`B_p`, and the GF(64) pointed margin `49 > 48` turns on `B_2 = 6` by exactly one.

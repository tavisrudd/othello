# C973 — independent cold-read review of the load-bearing geometry

**Lane:** `reed-solomon` · **Date:** 2026-08-28 · **Reviewer role:** external
cold-read specialist (finite geometry / algebraic curves), no prior C973 context
**Scope reviewed:**
`c973-2026-08-26-simultaneous-marker-theorem.md`,
`c973-2026-08-26-two-seam-reconstruction.md`,
`c973-2026-08-26-one-carry-module-theorem.md`,
`c973-2026-08-26-digit-stripping-exact-sequence.md`,
`c973-2026-08-27-carrier-nucleus-compression.md` (§1–§7, §10 in full; §8 skimmed
but §8.1–§8.3 checked in detail because their arithmetic is short and testable),
plus the card `c973-simultaneous-marker-prs-escape.md` §§ "Primary theorem
target", "Proof programme".
No file was missing. This review is read-only; nothing outside this file was
edited, no build or git operation was run.

## Summary verdict

The mathematics I could check is in good shape. Every purely combinatorial,
representation-theoretic and elementary-geometric step I recomputed came out
correct, often exactly: the genus/deletion arithmetic and all five threshold
values, the degree-six selector construction and its multidegree bookkeeping,
the Vandermonde grid lemma, the three Hankel minors and the catalecticant
expansion that force base-point-freeness, the entire digit-stripping filtration
including the determinant twists and the inversion scalars, the closed dimension
formula and the empty-carrier classification, the Pascal-identity proof that the
maximal adjacent-zero carrier is the penultimate osculating nucleus, the
split-quadric Frobenius-graph quotient at `d=p^s` (which I verified is an
*exact* module isomorphism `Gamma^{d+1}E/C_d = E ⊗ E^{(s)}`, no twist needed),
and the whole GF(27) numerology (819 sublines, 702 pointed ones, the syndrome
`e_2+e_4+e_6+e_8`, the 39 affine-plane locators, the seven Shintani/rank-one
quotient types and their checksum 20440). I also independently *proved* one
input the two-seam note leaves on the trust list: the projected Veronese in
`P^4` contains no line, because the kernel of `Sym^2(Sym^2 E^vee) -> Sym^4
E^vee` is the rank-three quadric `u_0u_2-u_1^2`, hence lies on no plane of a
Veronese conic. The single largest issue I found is not an error but a
mis-stated scope: **the exceptional set in the containment theorem is provably
much smaller than `P_r ∪ M^max_{r,p}`**, and taking the stated version at face
value appears to have caused substantial redundant downstream work (the whole
binary R11 GF(64) programme, and the `q>=128` binary R11 boundary, are already
subsumed at `q>=56`). The one genuine proof gap I could not close is the
level-uniformity of the persistent-component induction in Proposition 2.1: the
argument invokes the C536 coherent-Fano identity at the R5/R6 level and then
says "repeating this argument upward one level at a time", which needs a
level-indexed family of statements that is nowhere stated or proved.

## Table of statements and verdicts

| # | Statement (one line) | Verdict |
|---|---|---|
| MT-1 | Composite contraction `<i_R f,h> = <f,Rh>` is intrinsic and `g ∈ W_{i_R f} ⟺ Rg ∈ W_f` (marker thm §1, eqs (3)–(4)) | ACCEPT |
| MT-2 | `Rg` squarefree ⟺ `R`,`g` squarefree and coprime (marker thm §1) | ACCEPT |
| MT-3 | Selector `F=DA` is nonzero on `L_f` when `L_f ⊄ B_5^red`; `deg F ≤ 6` (≤4 char 2) (marker thm §2, eqs (7)–(8)) | ACCEPT |
| MT-4 | `S_f` is nonzero and multihomogeneous of degree `≤ 6` in each marker (marker thm eq (9)) | ACCEPT |
| MT-5 | `S_f ≠ 0` at `R` forces trivial gcd of the terminal pencil, via the three minors and `D` (marker thm §2) | ACCEPT (recomputed) |
| MT-6 | Vandermonde grid lemma: `q > d+m-1` gives distinct roots with `P ≠ 0` (marker thm §3, eq (10)) | ACCEPT |
| MT-7 | Selector field bound `q ≥ r+1` (`r-1` in char 2) (marker thm eq (11)) | ACCEPT |
| MT-8 | Terminal deletion is `B_p + 6m`, i.e. `6r-18` / `6r-24` (marker thm eqs (12)–(13)) | ACCEPT, conditional on the C881 count (12) |
| MT-9 | `H(Δ)=Δ+2+floor(2 sqrt Δ)` is the least `q` with `q+1-2 sqrt q > Δ`; gives (1),(2) and the R6–R10 table | ACCEPT (rederived; table exact) |
| MT-10 | Simultaneous-marker escape theorem, containment (15) | ACCEPT as stated, but **scope understated** — see Finding 1 |
| MT-11 | Pointed variant, eqs (16)–(17) | ACCEPT with one unstated hypothesis (Finding 5) |
| MT-12 | Witness-abundance bounds (18)–(21) | ACCEPT |
| TS-2.1a | Persistent branch: `L_f ⊆ V(D) ⟹ f ∈ P_r` (two-seam §2) | UNVERIFIED — level-uniformity gap, Finding 2 |
| TS-2.1b | Residual branch, `p ∉ {2,3}`: no line in projected Veronese ⟹ rank 1 ⟹ `f ∈ P_r` | ACCEPT (I proved the no-line input myself) |
| TS-2.1c | Residual branch, `p=3`: wild-cone rulings ⟹ `f ∈ P_r` | UNVERIFIED (C597 input) |
| TS-2.1d | Residual branch, `p=2`: columns vanish, giving `M^max_{6,2}`, `M^max_{7,2}`, nothing for `m ≥ 3` (eqs (8)–(10)) | ACCEPT (verified against the Pascal-row definition) |
| TS-2.2 | Degree-six selector proposition | ACCEPT |
| TS-3.1 | Terminal open = base-point-free, separable, `S_3` pencil stratum | ACCEPT for rank/gcd and the inseparable-branch identification (`e_2` recomputed); UNVERIFIED for "cyclic locus = residual component" |
| OC-1 | One-carry theorem `M^max_{r,p} ≅ P(Gamma^{p-a-3}E)` with basis `g_k = C(a+2+k,k) e_{a+2+k}` | ACCEPT (all scalars and the inversion sign recomputed) |
| OC-2 | Consequence table (`a=p-3,p-4,p-5` ↔ R13,R12,R11 at `p=7`); carrier dies at row `2p-2` | ACCEPT |
| DS-1 | Digit-stripping sequence (1), `0 ≤ a ≤ p-2` | ACCEPT (support split, submodule stability, quotient action all recomputed) |
| DS-2 | Terminal-digit sequence (2), `a=p-1` | ACCEPT |
| DS-3 | Nucleus sequence (3) | ACCEPT |
| DS-4 | Nonsplitting of (1),(2),(3) as rational `GL_2` modules | ACCEPT |
| DS-5 | Dimension formula (7), codimension (7a)/(7b) | ACCEPT (run-counting argument reproved; understated bound, Finding 6) |
| DS-6 | Empty-carrier classification (8), and (9) | ACCEPT |
| CN-2.1 | `P(C_d) = N^{(d-1)} Gamma_{d+1}` by Pascal (compression eqs (1),(3)–(5)) | ACCEPT (checked against the char-2/char-3 classical nuclei) |
| CN-3 | `C_d = <e_2,...,e_{d-1}>` at `d=p^s`; quotient graph `[1:t:t^d:t^{d+1}]` on `X_0X_3=X_1X_2`; `Gamma^{d+1}E/C_d ≅ E ⊗ E^{(s)}` | ACCEPT (module iso verified coordinate-by-coordinate, exact) |
| CN-4 | Locator/secant dictionary (13) and `NS(d,K)` (14) | ACCEPT |
| CN-5.1 | Subline circuit theorem (four points coplanar ⟺ `k`-subline) | ACCEPT (cross-ratio determinant recomputed as `mu - lambda`) |
| CN-5.2 | Relative-code reduction (19)–(23), polynomial model (23a)–(23g) | ACCEPT (all parameters and the coefficient windows recomputed) |
| CN-8.1 | Blocking-line duality (25a)–(25c'), spread sufficiency, coordinate obstruction (25d)–(25h) | ACCEPT (the 13 lines / 39 affine planes / 364 < 730 all recomputed) |
| CN-8.1b | Uniform inseparability obstruction (25j)–(25n) | ACCEPT |
| CN-8.2 | Digit-kernel saturation (25w) | REPAIRABLE — sound modulo an unchecked external input, Finding 7 |
| CN-8.3 | Seven-type quotient inventory, cocycle (25ae), cohomology (25ai)–(25aj) | ACCEPT (Shintani class sizes, checksum 20440, and the cocycle binomials all recomputed) |

## Detailed findings, ordered by severity

### Finding 1 (highest impact; not an error, a mis-stated scope)

**The exceptional set of the containment theorem is provably far smaller than
`P_r ∪ M^max_{r,p}`, and the notes' own Proposition 2.1 is what proves it.**

The escape argument in `simultaneous-marker-theorem.md` §2–§4 uses exactly one
hypothesis on `f`: that `L_f`, the projectivised row space of `Cat_{m,4}(f)`, is
not contained in `B_5^red = V(D) ∪ V(I_{A,p})`. Proposition 2.1 of the two-seam
note is the *implication* `L_f ⊆ B_5^red ⟹ f ∈ P_r ∪ M^max_{r,p}`, and its proof
gives strictly more than that:

- persistent branch (`L_f ⊆ V(D)`): conclusion is `f ∈ P_r`, no carrier term;
- residual branch, `p ∉ {2,3}`: conclusion is rank `T_f = 1`, hence `f ∈ P_r`;
- residual branch, `p = 3`: conclusion is `f ∈ P_r`;
- residual branch, `p = 2`: conclusion is `f ∈ M^max_{6,2}` (`m=1`) or
  `f = [e_3] ∈ M^max_{7,2}` (`m=2`), and `f = 0` for `m ≥ 3`.

So the set on which the escape mechanism fails is contained in
`P_r ∪ M^max_{6,2} ∪ M^max_{7,2}` — the Lucas carrier contributes **nothing for
any odd characteristic and nothing in characteristic two beyond `r ∈ {6,7}`**.

I checked this is not an artefact of the proof but the truth of the matter, by
computing `L_f` directly for carrier points. For `p=2`, `r=11` (`d=9`, carrier
`P<e_3,...,e_7>` in `Gamma^{10}E`, `m=6`), take `f=e_3`: the `7x5` catalecticant
has a single nonzero anti-diagonal and row space `{c_4=0}`, on which
`D = c_0c_3^2 + c_2^3 ≢ 0` in char 2 and `c_0 ≢ 0`, so `L_f ⊄ V(D)` and
`L_f ⊄ V(c_0,c_4)`. A generic carrier point gives a banded Hankel matrix of full
rank 5, i.e. `L_f = P^4`. The same holds for `p=3`, `r=11`, `f=e_2`: row space
`{c_3=c_4=0}`, `D|_{L_f} = -c_2^3 ≠ 0`. So *no* point of the R11 carrier is an
obstruction to the escape mechanism.

Consequences that should be checked and then acted on:

1. Statement (15) should be strengthened to
   `SplitFree_r(F_q) ⊆ P_r(F_q)` for every odd `p` and for `p=2, r ≥ 8`, with the
   carrier term retained only at `r ∈ {6,7}` in characteristic two. Equivalently
   the honest hypothesis is "`L_f ⊄ B_5^red`", and `P_r ∪ M^max` is a lossy
   over-approximation of it.
2. The "remaining mathematical crown … determine the split-free points of
   `M^max_{r,p}`" (marker thm §6) is then *not* the residue of this theorem. The
   residue is only the sub-threshold regime `q < Q_r` (resp. `Q_{r,2}`).
3. Concretely: the binary R11 asymptotic block, recorded in
   `c973-2026-08-26-first-lucas-boundary.md` as closed for `q ≥ 128`, is closed
   by the simultaneous theorem at `q ≥ Q_{11,2} = 6·11-22+floor(2 sqrt 42) =
   44+12 = 56`.
4. Most consequentially, **GF(64)/R11 already falls inside the theorem**, so the
   entire trace-balance / étale-cyclic-cubic / 3-isogeny programme summarised in
   the card appears to be re-proving a special case. Even the *pointed* variant
   suffices: (17) with `s=1`, `p=2`, `m=6` requires
   `q+1-2 sqrt q > 6 + 6·7 = 48`, and `q=64` gives `65-16 = 49 > 48`. I note that
   the GF(64) programme's own stated margin is "at most 48 bad rational points
   versus the Hasse lower bound 49" — numerically the identical inequality,
   which is strong evidence that the two arguments are the same count performed
   on two different models of the same curve.
5. The still-open fields are exactly those below threshold: GF(16) and GF(32)
   (binary, `< 56`) and GF(27) (`< Q_{11} = 63`; pointed needs
   `q+1-2 sqrt q > 12+42 = 54`, and `28-2 sqrt 27 ≈ 17.6`, far short). The
   GF(27) nucleus-saturation problem (15) is therefore genuinely open and is
   correctly identified as the frontier; GF(64) is not.

I flag this as the highest-value item because it is cheap to confirm (the
computations above are three small Hankel matrices) and, if confirmed, it
retires a large block of downstream work and simultaneously strengthens the
headline theorem.

### Finding 2 (real proof gap): level-uniformity of the persistent-component induction

`two-seam-reconstruction.md` §2, "Persistent component". The argument is: fix
`m-1` marker factors, contract, get `f' ∈ Gamma^5 E`; its first-polar line lies
in the quartic rank-`≤2` locus `V(D)`; C536's integral coherent-Fano identity
then forces `f'` into the quintic rank-`≤2` locus; vary and use density; then
"Repeating this argument upward one level at a time gives `f ∈ P_r`."

The repetition is not the same statement. Level `n` requires: *if every first
polar `i_lambda g` of `g ∈ Gamma^n E` lies in the `Gamma^{n-1}` rank-`≤2` locus,
then `g` lies in the `Gamma^n` rank-`≤2` locus*, for every `n = 5,…,m+4`. C536 is
cited only for the R5/R6 instance `n = 5`. Nothing in the reviewed files states
or proves the level-indexed family, and characteristic-`p` divided-power modules
are precisely where such a family can break at isolated `n` (Frobenius kernels
in the catalecticant). The statement is plausible — in characteristic zero it is
immediate, since for `g = l_1^n + l_2^n + l_3^n` the polar
`c_1 l_1^{n-1} + c_2 l_2^{n-1} + c_3 l_3^{n-1}` drops rank only for three special
`lambda` — but plausible is not proved.

Also, minor within the same paragraph: "the remaining contractions form the
first-polar *line*" is false when `rank T_f = 1`, where they form a point. That
case is harmless (rank one already gives `f ∈ P_r`) but should be split off
explicitly rather than left to the reader.

Verdict: TS-2.1a is UNVERIFIED. This is the one place where I think a referee
would stop. Repair route: state the level-`n` coherent-Fano lemma explicitly and
either cite the exact C536 statement that covers all `n`, or prove it directly
from the Hankel `2x2`-minor description (the inductive step looks routine, but
it must be written).

Note the interaction with Finding 1: TS-2.1a is precisely the branch whose
conclusion is `f ∈ P_r`. So the gap does not threaten the containment (15) as
*stated* (a failure would just enlarge the exceptional set inside the already
stated `P_r ∪ M^max`), but it does threaten the strengthened version in
Finding 1, and it threatens any claim that `P_r` is exactly the persistent
locus.

### Finding 3 (unproved-but-plausible, correctly declared): the five inherited inputs

The two-seam note's §5 trust boundary is accurate and I did not re-derive four
of its five items. I did close one of them independently:

- **No line on the projected Veronese (`p ∉ {2,3}`) — now VERIFIED.** The
  residual component is the `PGL_2`-orbit closure of the syndrome `e_2`, i.e.
  the squares of binary quadratics, i.e. the image of the Veronese surface
  `V ⊂ P^5 = P(Sym^2 W)`, `W = Sym^2 E^vee`, under projection from the kernel of
  the multiplication map `Sym^2 W -> Sym^4 E^vee`. A line in the projected
  surface would be a conic of `V` whose plane contains the centre; the conic
  planes are `P(Sym^2 U)` for two-dimensional `U ⊂ W`, so the centre would have
  to be a rank-`≤2` element of `Sym^2 W`. The centre is `u_0u_2 - u_1^2`, whose
  Gram matrix has determinant `1/4 ≠ 0` for `p ≠ 2`. Hence rank 3, hence no
  line. This also explains structurally why characteristic two needs a separate
  residual component.

Two further consistency checks I ran on the same seam, both of which passed and
which I record because they are good evidence the characteristic-wise carrier
list is right:

- The characteristic-two residual `V(c_0,c_4) = P<e_1,e_2,e_3>` is the
  annihilator of `span{X^4, Y^4}`, which in characteristic two is the image of
  the fourth-power Frobenius `{l^4 : l linear}` and therefore `PGL_2`-stable. Its
  dimension 2 matches the orbit of `e_2`, whose stabiliser is one-dimensional (I
  checked the upper unipotent moves `e_2` to `e_2 + t e_3 + …`). So the residual
  plane really is the closure of the cyclic locus.
- The characteristic-three inseparable branch is `e_2`: the pencil
  `<T^3,U^3>` is `ker H_c` exactly for `c = (0,0,c_2,0,0)`, and
  `D(e_2) = -c_2^3 ≠ 0`, so `e_2 ∉ V(D)`. It must therefore be carried by
  `V(I_{A,3})`, which is exactly what the note asserts (the wild cone with
  vertex `e_2`). Internally consistent.

Still on trust, unchecked: C536's identity itself; C597's characteristic-three
linear-space classification; the exhaustive characteristic-wise
cyclic/inseparable terminal classification; and the exact R5 split-witness count
with its branch budgets `B_2 = 6`, `B_p = 12`. The last of these is the single
most load-bearing unchecked number in the whole programme: every threshold in
(1), (2), (13), (17), (19) is a direct function of `B_p`, and Finding 1's GF(64)
conclusion turns on `B_2 = 6` giving `49 > 48` with a margin of one.

### Finding 4 (exposition, but it hides a real distinction): `B_5^red` over-approximates the R5 split-free locus

`V(D)` is exactly the locus where the terminal cubic pencil has a common
quadratic factor: `D(c) = 0` iff the apolar ideal of the quartic `c` contains a
quadric `q`, whence `W_c = q·<X,Y>`. But such a pencil still contains split
squarefree members whenever `q` itself is split (`q = XY` gives members `XY·l`).
So `V(D)` is a locus where the *counting argument* fails, not where split
witnesses fail to exist. The marker-theorem §6 bullet "fixed-gcd terminal systems
lie on the `D=0` side of the terminal carrier" gestures at this but does not say
that the containment is therefore lossy at both the terminal and the top level.
Combined with Finding 1 this means the theorem is stated with two independent
layers of slack. Worth one sentence in any paper version, because a referee who
notices it will ask whether the sharp statement was attempted.

### Finding 5 (minor, unstated hypothesis): the pointed-variant chart

`simultaneous-marker-theorem.md` §4, pointed variant: "Choose the affine marker
chart so that any point of `A` at infinity is already avoided." This needs a
rational point of `P^1(F_q)` outside `A`, i.e. `q + 1 > s`. It is implied by
(16) in every use case but is not stated as a hypothesis. Exposition only.

### Finding 6 (minor, understated bound): codimension in (7a)

The compression note and the digit note both say `codim(C_d) = nu(d) + eta(d) ≥ 3`
for every nonempty carrier with `d ≥ 1`. A nonempty carrier requires at least one
zero run, hence `eta(d) ≥ 2`, and `nu(d) ≥ 2` for `d ≥ 1`; so the sharp
elementary bound is `≥ 4`. Harmless, but the sharper constant improves the
density statement in (7b) for free.

### Finding 7 (dependency I could not close): the GF(27) digit-kernel saturation (25w)

`carrier-nucleus-compression.md` §8.2 is a nice argument and everything I could
check inside it is right: `L_p(t) = t^3 + pt` with `p = -alpha^2` a nonsquare
(because `-1` is a nonsquare in `F_27`) has a one-dimensional kernel; the count
`#{c : chi(c) = chi(c-1) = 1} = (27 - 4 - chi(-1))/4 = 6` is correct; the three
`F_3`-lines in `g = (L_p+eta)(L_p-eta)L_r` are pairwise disjoint exactly under
the stated choice of `eta`; the conic condition (25v) reduces to
`lambda^2 = rv / (p^2 (r-p))` which is (nonsquare · nonsquare)/(square ·
nonsquare) = nonsquare, so the line is external; and the pointedness count is
exact — the nonsplit torus of order `q+1 = 28` acts freely on `P^1(F_27)` (every
non-identity element has its two fixed points in the conjugate pair, never
rational), so `28 - 9 = 19` transforms avoid infinity.

What I cannot check is the one imported step: "In the three-line coefficient
formulas its parameters are `u = s = 0` and `v = -eta^2`. Therefore (25p) is the
line spanned by `(rv,0,r-p)` and `(0,p(p-r),0)`." That comes from
`c973-2026-08-27-gf27-three-line-reduction.md`, which is outside my review scope.
The whole anisotropic half of (25w) rests on those two vectors being correct.
Verdict REPAIRABLE: either inline the two-line derivation of `(g_1,g_4,g_7)` and
`(g_2,g_5,g_8)` for `g = (L_p+eta)(L_p-eta)L_r`, or cite the exact equation
number. Everything downstream of it is sound.

### Finding 8 (exposition): duplicate equation label

`digit-stripping-exact-sequence.md` uses the label `(3)` twice — once for the
nucleus exact sequence in §2 and once for the Lucas product identity in §3. The
sentence "For completeness, (3) follows from the same calculation" in §5 is
therefore ambiguous on a cold read.

## Small cases checked by hand

These are the checks the review brief asked for, plus the ones I needed to
convince myself of Finding 1.

**Genus/deletion arithmetic, rederived from scratch.** `q + 1 - 2 sqrt q > Δ`
iff `(sqrt q - 1)^2 > Δ` iff `q > (1 + sqrt Δ)^2`, so the least admissible `q`
is `floor((1+sqrt Δ)^2) + 1 = Δ + 2 + floor(2 sqrt Δ)`, which is (14). With
`Δ = B_p + 6m = 12 + 6(r-5) = 6r-18` this is `6r-16+floor(2 sqrt(6r-18))`,
exactly (1); with `Δ = 6 + 6(r-5) = 6r-24` it is `6r-22+floor(2 sqrt(6r-24))`,
exactly (2). The table is exact: `r=6..10` give `Δ = 18,24,30,36,42`,
`floor(2 sqrt Δ) = 8,9,10,12,12`, `Q_r^* = 28,35,42,50,56`, and the next prime
powers are `29,37,43,53,59` (36, 51, 52, 57, 58 are not prime powers). The `r=9`
row is the sharp one: `Δ = 36` makes `(1+6)^2 = 49` an integer, so `q = 49`
fails the strict inequality by exactly zero and `50` is forced — the strictness
matters and is used correctly.

**`d = 8`, `p = 2` (redundancy 10).** Digits of 8 are `(0,0,0,1)`, so
`nu = 2`, `t = 0`, `eta = 2`, and (7) gives `dim C_8 = 8+2-2-2 = 6`, matching
`C_8 = <e_2,…,e_7>` from the prime-power formula (6). The quotient graph is
`[1:t:t^8:t^9]` on `X_0X_3 = X_1X_2`, and I verified the module isomorphism
`Gamma^9 E / C_8 ≅ E ⊗ E^{(3)}` coordinatewise: `e_0 ↦ e_0 + u e_1 + u^8 e_8 +
u^9 e_9` (coefficients `C(1,0), C(8,0), C(9,0)`), `e_1 ↦ e_1 + u^8 e_9` (because
`C(8,1) ≡ 0` and `C(9,1) ≡ 1`), `e_8 ↦ e_8 + u e_9`, `e_9` fixed — exactly the
tensor-product translation, with no determinant twist. Over `F_64` the circuit
theorem gives `k = F_{2^gcd(3,6)} = F_8`, so the weight-four circuits are the
four-subsets of `F_8`-sublines, consistent with the note's remark that only at
`k = F_3` are the circuits the sublines themselves.

**`d = 9`, `p = 3` (redundancy 11).** `nu = 2`, `eta = 2`, `dim C_9 = 7`, so the
carrier is `PG(6,27)` with `(27^7-1)/26 = 402{,}321{,}277` points — the number
quoted on the card. `|PGL_2(27)|/|PGL_2(3)| = 19656/24 = 819` sublines, `819·4/28
= 117` through a prescribed point, `702` avoiding it. I computed the weight-four
codeword on the subline `{0,1,2,∞}` from scratch: the four conditions force
`c_0 = c_1 = c_2 = c_∞ = 1`, and its middle moments `j = 2,…,8` are
`(2,0,2,0,2,0,2)`, i.e. projectively `[e_2+e_4+e_6+e_8]` — equation (21) is
exact. The polynomial model (23b) is right: writing `c_t = h(t)` with
`deg h ≤ 26` and using `sum_t t^m = -[m = 26]`, the moment condition at `j` reads
`h_{26-j} = 0`, so `j = 0..10` gives `deg h ≤ 15` and `j ∈ {0,1,9,10}` gives
`h_{26} = h_{25} = h_{17} = h_{16} = 0`, leaving `a_{18},…,a_{24}` as the seven
quotient coordinates. The coordinate obstruction (25d)–(25g) is also exact: the
remainder of `h^3 + t` mod `g` kills `a` from its `t^7` coefficient and `c` from
`t^6`, leaving `d^3 = b^4`, `b^3 d = 1`, `e^3 = b^3 e`; hence `b^{13} = 1`
(13 values), `d = b^{-3}`, and `e ∈ {0, ±b^{3/2}}` (three values, since `b` lies
in the group of order 13, i.e. the squares) — 39 locators, which is exactly the
39 affine planes of `AG(3,3)` (13 directions times 3 cosets). Their Hankel lines
depend only on `[1:b^4]`, giving 13 lines. And the Shintani inventory checks:
`28 + 756 + 819 + 4914 + 2457 + 6552 + 4914 = 20440 = (27^4-1)/26`.

**One-carry module theorem.** With `s = a+2`, `m = p-a-3` all indices satisfy
`s+k ≤ p-1 < p`, so every `c_k = C(s+k,k)` is a nonzero residue and the
factorial cancellation `c_k C(s+l,s+k)/c_l = C(l,k)` is an identity of integers,
valid mod `p`. `c_k = C(p-m-1+k, k) ≡ (-1)^k C(m,k)` gives `c_{m-k} = (-1)^m c_k`,
so inversion is basis reversal times the single scalar `(-1)^m`; and since
`s + m = p - 1`, `(-1)^s (-1)^m = (-1)^{p-1} = 1` for odd `p`, which is why the
`det^s` twist absorbs it. The cross-check against the characteristic-two
Proposition 2.1 output is exact: Pascal row 4 has zeros at `1,2,3` so
`C_4 = <e_2,e_3> = M^max_{6,2}`; row 5 has zeros at `2,3` so `C_5 = <e_3> =
M^max_{7,2}`; row 6 has zeros at `1,3,5` with no adjacent pair, so `C_6 = 0` —
precisely the "`m ≥ 3` forces `f = 0`" conclusion of the two-seam note. And for
`p = 7` the table row `a = p-5 = 2` gives `r = 11` and
`M^max_{11,7} = P<e_4,e_5,e_6>`, matching the first-Lucas-boundary table.

**Digit stripping.** I recomputed the support split (4) and (6), the stability
of `span(A)` and of `Z_D` (both reduce to the Lucas implication: `C(D,h) = 0`,
`C(D,h') ≠ 0`, `h' ≥ h` force `C(h',h) = 0`), the translation matrix (5), the
inversion index maps `(k,h) ↦ (m-k, D-1-h)` and `(b,h) ↦ (a+1-b, D-h)` — both of
which I verified by evaluating `n - j` with `n = pD+a+1` — and the nonsplitting
leakages (`C(a+2,a+1) = a+2 ≠ 0` since `a ≤ p-3`; `C(1,0) = 1` for (2);
`C(a+1,a) = a+1 ≠ 0` for (3)). The run-count `eta` is right: fixing the digits
above position `t` makes the low part sweep `[0, (d_t+1)p^t - 1]`, an interval,
and consecutive high choices differ by at least `p^{t+1} > (d_t+1)p^t`, so the
`eta` intervals are separated. Hence `d+1-nu` zeros in `eta-1` runs and
`dim C_d = (d+1-nu) - (eta-1) = d+2-nu-eta`. The empty-carrier criterion (8)
follows and I spot-checked it at `p=2, d ∈ {4,5,6,7,9}` and `p=7, d=12`.

**Frobenius-graph circuits.** Normalising three points of the Segre quadric to
`(∞,∞),(0,0),(1,1)` and taking the fourth as `(lambda,mu)` gives the `4x4`
determinant `mu - lambda` (I expanded it), so coplanarity is `mu = lambda`; on
the graph `mu = lambda^d`, giving `lambda^d = lambda`, i.e. `lambda ∈
Fix(x ↦ x^d) ∩ K = F_{p^gcd(s,e)}`. The "no three dependent" step is right
because the graph meets each ruling line at most once.

**Cocycle (25ae).** Recomputed the binomials mod 3: `C(5,3) = 10 ≡ 1`,
`C(5,4) = 5 ≡ -1`, `C(8,3) = 56 ≡ -1`, `C(8,4) = 70 ≡ 1`, `C(8,6) = 28 ≡ 1`,
`C(8,7) = 8 ≡ -1`. Exactly the stated
`(q_3u^2 - q_4u)e_5 + (-q_3u^5 + q_4u^4 + q_6u^2 - q_7u)e_8`.

**Cohomology (25ai).** For `U = 1 + N` of order 3 in characteristic 3,
`1 + U + U^2 = 3 + 3N + N^2 = N^2`; for one Jordan block of size three
`ker N^2 = im N = (U-1)A`, so `H^1(C_3, A) = 0`. Transfer with index
`[S_4 : C_3] = 8` invertible mod 3 gives `H^1(S_4, A) = 0`. Both correct. The
stabiliser orders `702, 26, 24, 4, 8, 3, 4` leave the Frobenius-graph type
(order `702 = 2·27·13`) as the only one divisible by 27, so it is indeed the
unique wild fibre.

## Inputs taken on trust from prior tasks (not rechecked)

1. **C820** — the marker-catalecticant row-space theorem (eq (5), that the
   geometric image closure of composite contraction is the projectivised row
   space of `Cat_{m,4}(f)`), and the characteristic-wise generators of the
   reduced terminal carrier: the seven cubics generating `I_A` away from
   characteristics 2 and 3, the plane ideal `(c_0,c_4)` in characteristic 2, and
   the wild-cone generators in degrees two and three in characteristic 3. I did
   verify independently that the two-seam note's own derivation of (4) from
   dominance is self-contained, so the row-space identification is not really a
   trust item; the *generator lists* are.
2. **C881** — the exact R5 split-witness count (12) and its branch budgets
   `B_2 = 6`, `B_{p≠2} = 12`, together with the statement that a syndrome outside
   `B_5^red` has a geometrically integral off-diagonal fibre square of arithmetic
   genus one. Every threshold in the programme is a function of these two
   numbers.
3. **C536** — the integral coherent-Fano identity, used at the R5/R6 level and
   (per Finding 2) implicitly at all higher levels.
4. **C597** — the characteristic-three consecutive-row calculation classifying
   linear subspaces of the wild cone, and the exhaustive characteristic-wise
   terminal factorisation used for the inseparable branch.
5. **The exhaustive R5 cyclic/inseparable terminal classification** ("the cyclic
   locus is exactly the residual terminal component" in Prop 3.1). I verified the
   two endpoints of this claim by hand — `e_2` is the inseparable point in
   characteristic three and lies off `V(D)`; the characteristic-two plane is
   `PGL_2`-stable, two-dimensional and equals the orbit closure of `e_2` — but not
   the classification itself.
6. **Seroussi–Roth–Dür covering-radius gate**, used only for the promotion of
   (15) to a deep-hole statement when `p > r-1`. I did check the arithmetic
   `q ≥ 6r-16 ⟹ r ≤ floor(q/2)+2`.
7. **Gmainer–Havlicek 2013** for the osculating-nucleus coordinate criterion (3).
   I sanity-checked it against three classical cases (empty for the char-0 and
   char-2 twisted cubic, the conic nucleus `e_1` in char 2, the axis `<e_1,e_2>`
   of the char-3 twisted cubic) and it reproduces all of them.
8. **Durante–Longobardi–Pepe 2023** for the prior-art status of the subline /
   minimum-word theorem; I checked the mathematics of Theorem 5.1 but not the
   attribution.
9. **`c973-2026-08-27-gf27-three-line-reduction.md`** for the three-line
   coefficient formulas feeding (25u) — see Finding 7.
10. **`c973-digit-stripping-check.py`** (hash pinned in the digit note) was not
    run; the review is entirely by hand, which is the right division of labour
    since the note itself says the checker's bounded range is not evidence for
    the universal quantifier.

## What I would ask the authors for next

1. Confirm or refute Finding 1 with the three Hankel computations above. If
   confirmed, restate (15) with the hypothesis `L_f ⊄ B_5^red`, record the
   `P_r`-only corollary for odd `p` and for `p=2, r ≥ 8`, and re-scope the
   small-field programme to `q < Q_r` only.
2. Write out the level-`n` coherent-Fano lemma (Finding 2) or cite the exact
   C536 statement covering all levels; this is the one step a referee will stop
   on.
3. Inline the `(g_1,g_4,g_7)`, `(g_2,g_5,g_8)` computation for the three-line
   seed so §8.2 is self-contained (Finding 7).
4. Independently recheck `B_2 = 6` in (12). Finding 1's GF(64) conclusion has a
   margin of exactly one point (`49 > 48`), so this constant is load-bearing at
   the sharp end.

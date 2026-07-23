# C498 math referee review: persistent-stratum results of the redundancy-six report

**Lane**: `reed-solomon` · **Date**: 2026-07-23 · **Scope**: adversarial verification of the
mathematics (not novelty, not style) of the persistent-stratum claims in
`notes/2026-07-22-c498-prs-redundancy-six.md`.

All verification code was written from scratch for this review (own finite-field tables, own
Gaussian elimination, own binary-form gcd, own PGL2 action); it shares nothing with the Rust
generator or the Python replay. Scripts live in the session scratchpad
`/tmp/claude-1000/-home-tavis-src-othello-rust/dafc425d-27b5-4511-8837-b4e56e329094/scratchpad/c498/`
(`ffutil.py`, `run_census.py`, `run_defscan.py`, `run_orbits_stratum.py`, `run_orbits_full.py`);
key numerical outputs are reproduced below. Field models used here (GF(8) via x^3+x+1, GF(9) via
x^2+1, GF(16) via x^4+x+1, GF(25) via x^2+2, GF(27) via x^3+2x+1) were chosen independently; all
verified quantities are model-independent.

Conventions fixed for this review: a quintic syndrome is f = (a_0..a_5); its Hankel matrix is the
2x5 matrix with rows (a_0..a_4), (a_1..a_5); the kernel lives in binary quartics
c = (c_0..c_4), c_k the coefficient of s^{4-k}t^k. A point c is in ker H_f iff f is orthogonal
(plain coefficient dot product) to s*C and t*C, hence ker H_f contains Q*Sym^2 iff f is orthogonal
to the 4-dimensional space Q*Sym^3. PGL2 acts on syndrome points through the NRC-preserving
Veronese lift, i.e. the transpose of the coefficient substitution matrix.

Summary of verdicts:

| Claim | Statement | Verdict |
|---|---|---|
| 1 | Ledger correction, d <= 2 | VERIFIED (caveat on "persists at every redundancy") |
| 2 | Stratum count q(q+1)^2/2, fibres q and q+1, census gcd-2 column | VERIFIED |
| 3 | Tangent orbit law, char-5 split, q=25 26+624 | VERIFIED |
| 4 | Sigma fibre torus law and table consistency | VERIFIED |
| 5 | Frobenius fusion p = +-2 mod 5 | VERIFIED WITH CAVEAT |
| 6 | Symmetric-cube quadric L0 L2 - L1^2 | VERIFIED |

---

## Claim 1 — Ledger correction: gcd degree d <= 2, quadratic persistent factor

**Verdict: VERIFIED**, with one caveat on the scope of "persists at every redundancy".

Re-derivation. At redundancy r the syndrome is a binary (r-1)-ic f = (a_0..a_{r-1}); the Hankel
matrix is 2x(r-1); its kernel W lies in binary (r-2)-forms, a space of dimension r-1, so
dim W >= (r-1) - 2 = r-3, with equality iff the two Hankel rows are independent. If every member
of W is divisible by a fixed form g of degree d, then h -> g*h is an injection from the cofactor
space {h : g*h in W} onto W, and cofactors are (r-2-d)-forms, a space of dimension r-1-d. Hence

    r-3 = dim W <= r-1-d,  so  d <= 2.

This is exactly the report's argument and it is correct. The r-3 lower bound needs row
independence; at r = 6 my scans confirm that every deep point in every scanned field has kernel
dimension exactly 3 ("kernel dim hist among deep: {3: ...}" for q = 7, 8, 9, 11, 13, 16), so the
dichotomy "dim 3 with d <= 2" covers the whole deep set in the verified range.

Numerical confirmation at r = 6: the gcd-degree histogram over the deep set is supported on
degrees {0, 2} only, in every scanned field (q = 7, 8, 9, 11, 13, 16). No deep point has gcd
degree 1. (Degree 1 is allowed by the inequality but does not occur: a degree-1 gcd t-r means
W = (t-r)*Sym^3 exactly, which contains (t-r) times a split squarefree cubic avoiding r, a
totally split squarefree quartic; so gcd-1 points are never deep. This step is implicit in the
report and holds.)

Caveat. The sentence "the tangent/sigma-secant stratum persists at every redundancy through a
quadratic common factor" does not follow from the inequality alone; the inequality only bounds d.
Persistence (nonemptiness and deepness of the gcd-2 locus at every r) follows from the same
apolarity dimension count (f orthogonal to Q*Sym^{r-3} is a codimension-(r-2) condition, leaving a
projective line of candidates) plus the equivalence "deep iff no totally split squarefree kernel
member" at that redundancy, which the report proves only at r = 6 (and cites C491 at r = 5). As a
statement about the corrected ledger entry this is fine; as an all-r theorem it is a (very
plausible) sketch, not a proof in this document.

## Claim 2 — Persistent-stratum count q(q+1)^2/2 and census gcd-2 column

**Verdict: VERIFIED** (re-derived; brute-force confirmed at q = 7, 8, 9, 11, 13, 16; definitional
agreement confirmed element-for-element at q = 7 and q = 8).

Re-derivation of the bundle count. PGL2-classes of binary quadratics up to scalar: squares of
linear forms (q+1 of them, one per point of P^1), irreducible quadratics (q(q-1)/2), split
squarefree quadratics ((q+1)q/2). A gcd-2 point over a split quadratic Q = l1*l2 is never deep
(Q times a split squarefree quadratic avoiding the two roots is a totally split squarefree
member; such a cofactor exists for all q >= 4). Over a square or irreducible Q, no kernel member
is squarefree-split (all are divisible by Q), so every such point is deep. With fibre sizes q
over each square and q+1 over each irreducible:

    q*(q+1) + [q(q-1)/2]*(q+1) = q(q+1)*[1 + (q-1)/2] = q(q+1)^2/2.

The arithmetic is correct, and the orbit inventory of quadratics used (q+1 squares, q(q-1)/2
irreducible, split classes excluded) is the correct one.

Fibre sizes re-derived: ker H_f contains Q*Sym^2 iff f is orthogonal to Q*Sym^3 (4-dim), so the
candidates over each Q form a projective line (q+1 points). Since Q*Sym^2 is 3-dimensional and
ker H_f has dimension 3 whenever the Hankel rows are independent, "kernel contains Q*Sym^2 and
rows independent" forces kernel = Q*Sym^2, gcd exactly Q. Over an irreducible Q all q+1 line
points survive; over a square exactly one degenerates (e.g. over Q = s^2 the line is
{[a4 e_4 + a5 e_5]} and the point [e_5] has a zero Hankel row, kernel dimension 4, gcd degree 1),
leaving q.

Brute force (independent full P^5 scan, deep = no totally split squarefree kernel member; command
`python3 run_census.py <q>`):

| q  | deep    | gcd-2  | trivial | sq fibres  | irr fibres  | split-gcd deep |
|---:|--------:|-------:|--------:|:-----------|:------------|:---------------|
| 7  | 5,376   | 224    | 5,152   | {7: 8}     | {8: 21}     | none           |
| 8  | 5,037   | 324    | 4,713   | {8: 9}     | {9: 28}     | none           |
| 9  | 2,250   | 450    | 1,800   | {9: 10}    | {10: 36}    | none           |
| 11 | 1,584   | 792    | 792     | {11: 12}   | {12: 55}    | none           |
| 13 | 1,820   | 1,274  | 546     | {13: 14}   | {14: 78}    | none           |
| 16 | 2,312   | 2,312  | 0       | {16: 17}   | {17: 120}   | none           |

Every entry matches the report's census table (deep, gcd-2, trivial-gcd columns) and the formula
q(q+1)^2/2 (224, 324, 450, 792, 1274, 2312). Every square-gcd fibre has exactly q points, every
irreducible-gcd fibre exactly q+1, and no deep point has split gcd. The q = 16 row also
independently confirms "trivial-gcd points = 0" at the first field where the report claims the
exceptional stratum vanishes. The remaining table rows (q = 17..27 full-space totals) were not
re-scanned here (P^5 sizes up to 14.9M; outside this review's budget); for q = 19, 25, 27 the
persistent-stratum sizes 3800, 8450, 10584 were confirmed by direct stratum construction (below),
which equals the table's deep count under the report's exceptional-zero claim.

Definitional cross-check ("deep = outside all spans of 4 distinct points of the quintic NRC
{(1,t,...,t^5)} u {e_5}"): command `python3 run_defscan.py <q>` marks the union of all
C(q+1,4) four-point spans directly and compares with the Hankel-based deep set.

- q = 7: marked 14,232 of 19,608; deep(def) = 5,376; sets equal element-for-element: True.
- q = 8: marked 32,412 of 37,449; deep(def) = 5,037; sets equal element-for-element: True.

## Claim 3 — Tangent (rational-square) orbit law and the characteristic-5 split

**Verdict: VERIFIED** (orbit sizes, stabilizers, the q = 25 split 26+624, and the claimed
binomial mechanism all confirmed by direct computation).

Independent construction of the whole gcd-2 stratum (via f orthogonal to Q*Sym^3, filtered to
gcd exactly Q) followed by PGL2 orbit closure under three generators, with stabilizer orders from
orbit-stabilizer (all orbit sizes verified to divide q^3-q). Command
`python3 run_orbits_stratum.py <q>`. Tangent (square-gcd) orbits found:

| q  | tangent orbits (size, stab)  | claim (p != 5): (q(q+1), q-1)  |
|---:|:-----------------------------|:-------------------------------|
| 9  | (90, 8)                      | (90, 8) ok                     |
| 16 | (272, 15)                    | (272, 15) ok                   |
| 19 | (380, 18)                    | (380, 18) ok                   |
| 25 | (26, 600) + (624, 25)        | char 5: (q+1, q(q-1)) + (q^2-1, q) = (26, 600)+(624, 25) ok |
| 27 | (756, 26)                    | (756, 26) ok                   |

Full-deep-set runs (`run_orbits_full.py`) additionally confirm (56, 6) at q = 7, (72, 7) at
q = 8, (132, 10) at q = 11, (182, 12) at q = 13. So the tangent fibre is one Borel-transitive
orbit of size q(q+1) with stabilizer order q-1 in every scanned field with p != 5, and splits as
26 + 624 exactly at q = 25.

Mechanism check. Over Q = s^2, the candidate line is [a4 e_4 + a5 e_5]; excluding the degenerate
[e_5] the fibre is {[e_4 + x e_5] : x in F_q}, matching the report's normal fibre. Direct
computation of the unipotent action (matrix [[1,0],[b,1]] acting through the Veronese lift):

- q = 7: x -> x + 5b exactly (checked b = 1, 2, 3 on x = 0, 1, 4; e.g. b=2, x=4 -> 0 = 4+10 mod 7).
- q = 25: the same unipotent fixes every fibre point x (checked x = 0, 1, 2, 7) — the
  translation coefficient is the binomial coefficient 5 = C(5,1), zero in characteristic 5.

So in char != 5 the unipotent radical is transitive on the fibre coordinate (one Borel orbit),
while in char 5 the Borel acts only through the torus, fixing x = 0 (the [e_4] point, which is
indeed the representative of the 26-point orbit) and acting transitively on x != 0
(24 points x 26 fibres = 624). The claimed mechanism is exactly what happens.

## Claim 4 — Sigma fibre: nonsplit torus acting via z -> z^5

**Verdict: VERIFIED** (group theory re-derived; fibre-level and orbit-level numbers confirmed at
q = 9 and q = 19; single-orbit case confirmed at q = 7, 8, 11, 13, 16, 25, 27; census table
consistency confirmed at all eleven q).

Group theory re-derivation. The PGL2-stabilizer of an irreducible quadratic Q is the dihedral
group of order 2(q+1): the nonsplit torus T (cyclic, order q+1) extended by an involution acting
on T as z -> z^{-1}. If T acts on the (q+1)-point fibre through z -> z^5 (i.e. through the
subgroup T^5), its orbits are the cosets of T^5. If 5 does not divide q+1, T^5 = T and T is
already transitive; adding the involution, the point stabilizer has order 2, and the global orbit
is (q(q-1)/2 quadratics) x (q+1) = q(q^2-1)/2 with stabilizer 2. If 5 | q+1, T^5 has index 5,
T/T^5 = C_5, and inversion identifies the classes as {0}, {+-1}, {+-2}: fibre orbits of sizes
(q+1)/5, 2(q+1)/5, 2(q+1)/5, giving global orbits q(q^2-1)/10 (stab 10), q(q^2-1)/5 (stab 5),
q(q^2-1)/5 (stab 5). The arithmetic q = 9: fibre sizes 10/5 = 2, 4, 4 and q = 19: 4, 8, 8 is
correct.

Direct mechanism computation at q = 9 (script inline; enumerated PGL2(9), 720 elements): for an
irreducible Q the setwise stabilizer of its fibre has order 20 = 2(q+1); its order-10 cyclic
subgroup T induces a permutation of order exactly 2 on the 10-point fibre (i.e. T acts through a
quotient of order 2 = |T^5|, exactly the z -> z^5 picture); the T-orbits are five 2-element sets
(the cosets of T^5); the full dihedral stabilizer has fibre orbits of sizes [2, 4, 4]. All as
claimed.

Orbit-level confirmation (stratum construction + orbit closure):

- q = 9:  sigma orbits (72, 10), (144, 5), (144, 5); 72 = 9*80/10, 144 = 9*80/5.
- q = 19: sigma orbits (684, 10), (1368, 5), (1368, 5); 684 = 19*360/10, 1368 = 19*360/5.
  Per-fibre traces: 684/171 = 4 and 1368/171 = 8, the claimed fibre sizes 4, 8, 8.
- 5 not dividing q+1: single sigma orbit (q(q^2-1)/2, 2) confirmed at q = 7 (168, 2),
  8 (252, 2), 11 (660, 2), 13 (1092, 2), 16 (2040, 2), 25 (7800, 2), 27 (9828, 2).

Census-table consistency for every q (persistent orbits from the law + report's exceptional
counts vs the table's PGL2 column):

| q  | tangent | sigma | persistent | exceptional | sum | table | ok |
|---:|--------:|------:|-----------:|------------:|----:|------:|:---|
| 7  | 1       | 1     | 2          | 18          | 20  | 20    | ok |
| 8  | 1       | 1     | 2          | 11          | 13  | 13    | ok |
| 9  | 1       | 3     | 4          | 4           | 8   | 8     | ok |
| 11 | 1       | 1     | 2          | 2           | 4   | 4     | ok |
| 13 | 1       | 1     | 2          | 1           | 3   | 3     | ok |
| 16 | 1       | 1     | 2          | 0           | 2   | 2     | ok |
| 17 | 1       | 1     | 2          | 0           | 2   | 2     | ok |
| 19 | 1       | 3     | 4          | 0           | 4   | 4     | ok |
| 23 | 1       | 1     | 2          | 0           | 2   | 2     | ok |
| 25 | 2       | 1     | 3          | 0           | 3   | 3     | ok |
| 27 | 1       | 1     | 2          | 0           | 2   | 2     | ok |

(5 | q+1 exactly at q = 9, 19 in range; p = 5 exactly at q = 25.) For q <= 16 the totals and the
gcd-2/trivial split were reproduced by my own full scans and full-deep orbit closures (20, 13, 8,
4, 3, 2 orbits with exceptional 18, 11, 4, 2, 1, 0); for q = 17, 19, 23, 25, 27 the persistent
part is independently proven above and the exceptional-zero part rests on the report's exhaustive
generator (not re-scanned here).

## Claim 5 — Frobenius fusion on T/T^5

**Verdict: VERIFIED WITH CAVEAT.**

Re-derivation. Field Frobenius x -> x^p restricts to the norm-one torus T inside F_{q^2}^* and
is the p-power map, hence multiplication by p on the cyclic quotient T/T^5 = C_5. On the
inversion classes {0}, {+-1}, {+-2}: if p = +-1 mod 5 each class is preserved; if p = +-2 mod 5
then {+-1} <-> {+-2} swap, so the last two sigma orbits fuse under PGammaL2 and the first
(class {0}) never moves. Tangent orbits: the char-5 fixed point [e_4] is Frobenius-stable and
orbit sizes 26 != 624 forbid fusion; in char != 5 there is a single tangent orbit. So "tangent
orbits never fuse" is correct.

Computational confirmation:

- q = 9 (p = 3 = -2 mod 5): stratum orbit Frobenius permutation: the two 144-orbits swap, the
  72-orbit and the 90 tangent orbit are fixed; persistent PGL 4 -> PGammaL 3. Full deep set:
  PGL2 orbits 8 -> PGammaL2 classes 5 (the four exceptional orbits, sizes 180, 180, 720, 720,
  fuse in pairs), matching the table row 8 / 5 exactly.
- q = 8: PGL 13 -> PGammaL 7 (both persistent orbits Frobenius-fixed; fusion happens only among
  the exceptional orbits), matching the table.
- q = 16, 25, 27: all persistent orbits Frobenius-fixed, PGammaL = PGL (2, 3, 2), matching the
  table (at these q either the sigma fibre is unsplit or, at q = 25, only the never-fusing
  tangent split is present).
- q = 7, 11, 13, 19, 23: prime fields, Frobenius trivial, PGammaL = PGL, consistent
  (19 = -1 mod 5 also makes the law's prediction "no fusion" vacuously consistent).

Caveat. Within the census range the fusion law is genuinely exercised only at q = 9 (the single
non-prime field with 5 | q+1). The p = +-1 branch is never tested non-trivially: p = 1 mod 5
makes p^m + 1 = 2 mod 5 for all m, so 5 never divides q+1 there, and p = -1 mod 5 needs odd
m > 1 (first instance q = 19^3 = 6859), far outside the census. The abstract derivation
(Frobenius is the p-power map on T, hence multiplication by p on T/T^5) is sound and simple, so
I consider the law correct; but as an empirical matter the census confirms only the p = -2 mod 5
case (q = 9) plus trivial ones. Note also that for p = 1 mod 5 the fusion statement is vacuous
(the sigma fibre never splits in those characteristics), which the report does not remark.

## Claim 6 — Symmetric-cube equation and the quadric L0 L2 - L1^2 = 0

**Verdict: VERIFIED** (symbolically, over Z, hence over every field).

With g = d0 s^3 + d1 s^2 t + d2 s t^2 + d3 t^3, L_j(g) = sum_{i=0}^{3} a_{i+j} d_i (j = 0, 1, 2),
and the quartic g*(u s + v t) with coefficients c_k = u d_k + v d_{k-1}, sympy confirms the two
Hankel equations sum_k a_{k+j} c_k = 0 (j = 0, 1) are identically

    E0 = u L0(g) + v L1(g),    E1 = u L1(g) + v L2(g),

i.e. the 2x2 system [[L0, L1], [L1, L2]] (u, v)^T = 0 (`uv run --with sympy`; both differences
simplify to 0 exactly). Hence a nonzero (u, v) exists iff L0 L2 - L1^2 = 0, so

    {cubics g : g divides some member of W = ker H_f} = {L0 L2 - L1^2 = 0},

which is precisely the image of the trisecant surface in Sym^3(P^1) = P^3 (a trisecant triple
(t1, t2, t3) corresponds to the cubic with those roots dividing a net member). Both directions
hold: containment is the forward computation, and conversely a singular 2x2 symmetric matrix has
a nontrivial kernel vector (u, v), giving the member g*(u s + v t) of W. The degenerate case
L0 = L1 = L2 = 0 (every g*(linear) in W) still lies on the quadric, so the set-level equality is
exact.

Side check of the report's rank-three remark: the L_j are linear forms in (d0..d3); when they are
independent the quadric L0 L2 - L1^2 in P^3 is a rank-3 cone. Spot check on the trinomial
representative f = (0,0,0,1,0,0): L0 = d3, L1 = d2, L2 = d1 — independent, rank-3 cone, as
stated.

---

## Referee notes on issues found (none load-bearing)

1. Claim 1's "persists at every redundancy" is a corollary sketch, not a proof, beyond r = 6
   (see caveat above). The d <= 2 bound itself is airtight.
2. Claim 5's fusion law is empirically anchored at a single field (q = 9) inside the census; the
   abstract argument carries the general case.
3. The report's fibre statement "over a rational square its fibre has q points" silently
   discards one degenerate point of the (q+1)-point candidate line (the point with dependent
   Hankel rows, gcd degree 1). This is correct but unstated; my computation confirms exactly one
   such degeneration per square fibre and none per irreducible fibre.
4. Everything else checked — counts, orbit sizes, stabilizer orders, fibre traces, Frobenius
   behavior, table consistency at all eleven fields, and both symbolic identities — agrees with
   the report exactly.

## Cross-check against the frozen certificate

The frozen `notes/2026-07-22-c498-prs-deep-hole-census.json` orbit-size multisets agree with my
independently computed orbits at the three law-critical fields: q = 9 gives
{72, 90, 144, 144, 180, 180, 720, 720}, q = 19 gives {380, 684, 1368, 1368}, q = 25 gives
{26, 624, 7800} — identical to the sizes found by my own stratum/full-deep orbit closures above.

## Replay commands

From the scratchpad directory listed above:

```sh
python3 run_census.py 7           # also 8, 9, 11, 13, 16 (full P^5 scans)
python3 run_defscan.py 7          # definition-vs-Hankel agreement; also 8
python3 run_orbits_full.py 7      # full deep-set PGL2/PGammaL2 orbits; also 8, 9, 11, 13
python3 run_orbits_stratum.py 9   # stratum construction + orbit law; also 16, 19, 25, 27
uv run --with sympy python3 ...   # claim-6 identity (inline script, reproduced in session log)
```

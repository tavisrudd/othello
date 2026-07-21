# C442 / M2 — Fable review: claim 3 verified in the golden frame, with new structure

**Lane**: `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** independent review and musing for the M2 evidence bundle. This is a review note, not
the certificate. No manuscript, Lean, or freeze file is edited here.

**Verdict (question E): AMBER — claim 3 is CONFIRMED, exhibited directly in the golden six-arc
frame, but M0's frozen binary-form model cannot carry it; M2 must certify against an amended
(extended) M0 freeze.** The falsifier ("singletons are not the reductions") did not trigger: the
two C406 singletons ARE the two prime-reductions of one char-0 antipodal matching — of the golden
six-arc's matching, not of the frozen binary form's. Both halves of that sentence are now verified
by direct computation, not inference.

## 1. Verification of the load-bearing facts

All of Opus's computations reproduce exactly (reran `explore_m2c.py`, `explore_m2d.py`,
`bridge.py`, `sheets.py`), and every check below is my own independent construction
(`fable_verify.py`, `fable_verify2.py`, `fable_verify3.py`, `fable_verify4.py`, same scratchpad
directory; exact Fraction arithmetic in Q(phi) throughout, no floats, no recalled formulas).

| # | fact                                                                                   | result |
|:--|:---------------------------------------------------------------------------------------|:-------|
| a | char-0 vertex-pair A5-orbits have sizes exactly 6/30/30; only the 6 is a matching       | PASS   |
| b | binary frame: reduce_pi and reduce_pibar of the antipodal matching coincide             | PASS   |
| b'| stronger: the reduced Klein A5 is the IDENTICAL subgroup of PGL_2(11) at both primes    | PASS   |
| b"| mechanism: sigma(S)=S^2, sigma(T) in A5 — Galois normalizes the char-0 Klein A5         | PASS   |
| c | a5(8) != a5(4), each order 60, intersection order 12 (common A4)                        | PASS   |
| c'| unique invariant matchings of a5(8)/a5(4) are exactly C406 base / J-mate                | PASS   |
| c"| base = frozen `coxeter_invariant_matching` [[0,1],[2,5],[3,7],[4,9],[6,8],[10,inf]]     | PASS   |
| d | pair-orbit sizes under a5(8) and a5(4) mod 11 are again 6/30/30 (uniqueness downstairs) | PASS   |

The base/J-mate lists are grounded in the frozen Gate-1 scout JSON
(`notes/2026-07-20-c406-matching-orbit-scout.json`, key `coxeter_invariant_matching`, H3 row) and
re-derived independently as the unique invariant matchings; the label system (index i = parameter
x = i, index 11 = inf, via `C399.conic_parameterization(11)`) is the one C406's checker itself
consumes (`notes/2026-07-20-c406-matching-module.py` lines 454-458), so the comparisons are not
circular and not frame-mismatched.

## 2. The crux, exhibited: one golden object, two reductions

This is the test the brief asked for, and it passes. Constructed in exact Q(phi) arithmetic:

- The projective closure of the reflections in `roots(phi)` (the H3 root axes with tau = phi,
  literally C379's formulas read in char 0) has order exactly 60 and permutes the golden six-arc
  `six_points(phi)` — C379's a5(tau)/six-arc formulas ARE a char-0 golden object; reduction
  phi -> 8 gives exactly `c379.a5(8)` element-by-element, and phi -> 4 gives exactly `c379.a5(4)`.
- The antipodal matching in this frame is the polar pairing: each of the 6 vertex axes cuts the
  invariant conic x^2+y^2+z^2 = 0 in a conjugate point-pair; by A5-invariance plus orbit count
  6/30/30 this is the unique invariant matching. The pairing data (six-arc + polarity) is
  Z[phi]-rational, so its reduction at each prime is well defined without leaving the frozen ring.
- **Reduction at pi (phi -> 8): the six polar pairs are disjoint, cover all 12 conic points, and
  equal C406's base matching {0,1}{2,5}{3,7}{4,9}{6,8}{10,inf} exactly. Reduction at pibar
  (phi -> 4): they equal the J-mate {0,10}{1,inf}{2,7}{3,5}{4,8}{6,9} exactly.**
- sigma carries the entire golden frame to the conjugate frame: sigma(six-arc_phi) =
  six-arc_{1-phi}, disjoint from the golden one; sigma(A5_phi) = A5_{1-phi}, intersection the
  common A4 of order 12; and reduce_pi(sigma(g)) = reduce_pibar(g) element-wise. So
  sigma(a5(8)-side) = a5(4)-side is the right mechanism, exactly as Opus proposed.

So claim 3 is not merely "consistent": the single char-0 golden antipodal matching with the two
required reductions exists and is exhibited. Meanwhile the frozen binary form is sheet-blind by
theorem, not by accident: its A5 is normalized by the full Galois group (b"), hence the reduced
group (b') and its unique invariant matching (b) are literally prime-independent. M0's own
hardening note ("the sheet bit lives entirely in the A5 embedding, never in the vertex/root set")
already said this; M2 has now upgraded it from hedge to proof.

## 3. New structure found during review (all computed, exact)

These go beyond the brief; each is a PASS in `fable_verify2.py` / `fable_verify3.py` /
`fable_verify4.py`.

1. **The Galois swap is the shadow of a RATIONAL rotation.** The 90-degree coordinate rotation
   R_z = [[0,-1,0],[1,0,0],[0,0,1]] (entries in Z, det 1) maps the golden six-arc onto the
   conjugate six-arc, the golden H3 roots onto the conjugate roots, and conjugates the golden A5
   onto sigma(A5); R_z^2 = diag(-1,-1,1) lies in the common A4. Mod 11, R_z acts on x-labels as
   the Mobius map (x+10)/(x+1) with det = 2, a nonsquare — an outer element in the same
   transporter coset as C406's J = [[10,7],[2,1]] (verified: R_z-bar conjugates the a5(8)-action
   to the a5(4)-action, sends base to J-mate, and R_z-bar composed with J^{-1} lands in the
   a5(4)-permutation group). Spin-side reading: R_z lifts to the quaternion 1+k of reduced norm 2,
   and every icosahedral rotation lifts to a unit icosian of norm 1, so the whole golden-to-
   conjugate transporter coset has spinor norm 2 modulo squares. The det-nonsquare character of J
   is the mod-11 image of that char-0 invariant. Nothing about the swap ELEMENT is special to
   characteristic 11.
2. **What IS purely char-11.** Two things, now cleanly separated: (i) the collision — in char 0
   the golden and conjugate icosahedra have disjoint 12-point vertex sets on the conic (verified:
   no common conic point), while mod either prime both reduce onto the SAME P^1(F_11) (the q=h+1
   conic phase); (ii) the finite closure — the two reduced A5s generate exactly PSL_2(11) (order
   660, verified by closure), while the char-0 pair generates an infinite group. The outer swap is
   NOT generated by the two sheets; it enters only through the rational/spinor layer above.
3. **A reciprocity law for sheet fidelity: the auxiliary symbol (2/p).** At any split prime p of
   Q(sqrt5), the two Galois-conjugate A5-reductions are exchanged by R_z-bar, whose det class is
   the class of 2 mod p. Hence the two sheets are PSL_2(p)-DISTINCT iff 2 is a nonsquare mod p
   (p = +-3 mod 8). Verified at p = 11, 19, 29, 31, 41, 59: distinct at 11, 19, 29, 59; **FUSED
   inside PSL at p = 31 and 41.** So q = 11 is special three times over: 11 splits in Q(sqrt5)
   (the bit exists), 2 is a nonsquare mod 11 (the bit is PSL-visible as the sheet bit), and
   q = h+1 (the vertex sets collide). Note p = 31 — the H4/600-cell cliffhanger prime — is a
   fusion prime at the H3 level.
4. **The six-arc DESCENDS to Q.** The full PGL_3(F_11)-stabilizer of the reduced six-arc has
   order exactly 60 (so the char-0 stabilizer is exactly A5 and the transporter search is
   complete); among the 60 transporters u: sigma(arc) -> arc, descent data with u sigma(u) = 1
   exist (10 of them; scalar classes 1 and -4). Constructive Hilbert 90 then produces an explicit
   h and an explicit sigma-stable sextuple X_Q = h^{-1}(six-arc) with a rational conic Gram
   matrix — an unambiguous Q-rational model of the configuration. The exhibited Q-form has
   rational symmetry group of order 6 (an S3); other descent classes may give other forms. So the
   sheet bit is NOT a field-of-definition obstruction for the configuration: the object lives over
   Q; what does not exist over Q is a golden LABELING of it (equivalently, a canonical prime above
   11) — precisely C417's impossibility, now with the sharpest possible boundary.
5. **The rational skeleton of the golden pair is octahedral (B3 inside H3).** The compound of the
   two conjugate six-arcs (12 axes) is stabilized by the order-24 group generated by the common A4
   and R_z — a projective S4, the cube group, all rational. This is forced: finite subgroups of
   SO_3(Q) top out at S4, so the largest sheet-blind symmetry of the golden configuration is
   exactly the silver-case group. Additionally each golden axis is perpendicular to exactly one
   conjugate axis; this perpendicularity bijection is sigma-stable, hence reduces
   prime-independently — a canonical char-0 pairing between the two sheets' axis systems, a
   natural candidate germ for M5's gluing certificate.
6. **Why two frames must coexist (structural, not a computation).** Over Q(sqrt5) the binary
   icosahedral group 2.A5 has its 2-dimensional representation obstructed at both real places
   (quaternionic Schur index 2), so A5 has no split P^1 model over Q(sqrt5); its natural K-home is
   the anisotropic conic frame, and the split P^1 (binary form) frame lives over Q(zeta5), where
   the FULL cyclotomic Galois group normalizes the Klein A5 — which is exactly why that frame is
   sheet-blind. Reduction mod the split prime splits the quaternion algebra and lands the
   anisotropic frame inside split PGL_2(F_11): the char-11 gluing is, in one phrase, the splitting
   of the icosahedral quaternion obstruction at 11. This deserves to be said in the paper; it
   turns the two-frame bookkeeping from an embarrassment into the mechanism.

## 4. Rulings on the brief's questions

**A. Opus's resolution is correct, and now stronger than proposed.** The tension is a real
frame/object mismatch, not a falsification. The golden-frame form of claim 3 is verified by direct
construction of the char-0 object and both reductions (section 2). sigma(a5(8)) = a5(4) is the
right mechanism and is verified at char 0, not only through reduced formulas. Claim 4 survives
with re-scoped wording (see B and E); claim 5 is untouched (M3's business) and gains a consistency
argument: a Galois-odd integral tensor is a sqrt5-multiple of a rational one, and sqrt5 reduces to
4 vs 7 = -4 at the two primes, so sign covariation is automatic once M3 proves the lift.

**B. "J IS Gal(Q(sqrt5)/Q)" is imprecise in two ways, one of which matters.** (i) Canonicity: J
is well defined only as the outer coset modulo the golden A5 — any transporter differs by an A5
element; C406's specific Mobius matrix is a convenient representative, nothing more. The coset
does carry a canonical char-0 invariant: spinor norm 2. (ii) Provenance: the swap element is not
characteristic-11 at all — it is the shadow of the rational rotation R_z. What is char-11 is the
collision and the finite closure (section 3.2). Correct formulation: reduction at 11 intertwines
sigma with the outer coset J.A5 of PGL_2(11); the intertwining element can be taken to be the
reduction of a single rational rotation, and its det class (nonsquare, = image of spinor norm 2)
is why the swap is outer. Claim 4 should say the PGL_2(11)-orbit structure (both sheets on one
line, 22 matchings in one orbit) is the char-11 gluing; it should NOT say or imply the swap
element only exists mod 11.

**C. M0 does not need repair; it needs an addendum, and M2 cannot go GREEN without it.** The
binary form remains the right integral model of the vertex set (M1 consumed it correctly, and its
sheet-independence is a feature there). But M2's spec reads "the reductions at pi and pibar of
that ONE antipodal matching" with the antecedent being M0's frozen model, and in that frame the
statement is false-by-coincidence (the two reductions are equal). The sheet-carrying object — the
golden six-arc, its a5(tau) reflection formulas, the invariant conic, and the polar-pair
matching — is already frozen de facto in C379's replay module; an M0 addendum should promote it to
a co-equal frozen object (same JSON discipline), state the two-frame theorem (rational frame
sheet-blind by Galois-normalization; golden frame sheet-faithful), and record the bridge. That is
a convention EXTENSION, not a convention change: nothing frozen becomes wrong, and M1's
certificate is untouched.

**D. Clause (iii)/T1: no inconsistency; certify the covariation as a composition.** "sigma fixes
M0-binary but negates mu_3" compares statements in different frames. In the sheet-blind frame the
matching is fixed and mu_3 is not even definable without importing the sheet labels. In the golden
frame sigma moves the matching (base <-> J-mate) and simultaneously flips the sheet labeling, and
C406 (GREEN) already proves the outer coset negates mu_3. Composing: switching sqrt5 = 4 to
sqrt5 = 7 swaps which sheet contains the reduction of the golden matching AND negates mu_3 under
the induced relabeling — the two bits flip together. The clean certificate statement: **the
oriented invariant "mu_3 with epsilon = +1 on the sheet containing the reduction of the golden
antipodal matching" is independent of the choice of prime above 11.** That is a canonical,
convention-free pairing, certifiable now as a corollary of C406 plus M2's sections 1-2; an
optional direct replay evaluating sign(mu_3) under both labelings would be a cheap
belt-and-suspenders addition, not a prerequisite.

**E. Verdict AMBER, with the corrected claim-3 wording below.** GREEN-as-frozen is unavailable
because the frozen frame falsifies the literal sentence; FALSIFIER is wrong because the intended
mathematical content is true and exhibited. Suggested paper-facing wording for the closing
theorem's claim 3 (and the co-statement that replaces the current claim 4 sentence):

> Let S be the golden six-arc in P^2 over Q(sqrt5) — the vertex-axis arc of the icosahedron —
> with its invariant anisotropic conic; the polar pairing of S on the 12 conic points is the
> unique A5-invariant perfect matching (the antipodal matching). Reduction at the two primes
> above 11 carries this one golden object to the two singleton depth fibres: pi gives the base
> matching with stabilizer a5(8), pibar gives its J-mate with stabilizer a5(4), and the
> nontrivial element sigma of Gal(Q(sqrt5)/Q) exchanges the two reductions. The exchange is
> implemented over Q by a single rational rotation of spinor norm 2, whose reduction is an outer
> element of PGL_2(11) precisely because 2 is a nonsquare mod 11; the two sheets themselves
> generate only PSL_2(11). Klein's rational binary form carries the same 12 vertices over Q, but
> its A5 is normalized by the full Galois group, so its reduction is prime-independent: the
> rational vertex model is sheet-blind, and the sheet bit lives exactly in the golden
> A5-embedding.

## 5. Doors opened (musings; no allocation implied)

Ranked by expected paper yield:

1. **The (2/p) sheet-fidelity law** (section 3.3). "One golden object, two elevens" gains an
   arithmetic leg: the bit exists at split primes, and is PSL-visible exactly when 2 is a
   nonsquare mod p. The natural composite condition (p splits in Q(sqrt5), 2 nonsquare mod p) is
   a Chebotarev class in the biquadratic field Q(sqrt2, sqrt5) — the silver and golden fields
   jointly governing H3's sheet story is very much in the trinity's spirit. And the cliffhanger
   prime 31 is a FUSION prime at the H3 level: the H4 door opens at a prime where the H3 bit
   degenerates. That deserves a bounded follow-up before the cliffhanger paragraph is written.
2. **Q-descent of the six-arc** (section 3.4). C417's impossibility now has its exact boundary:
   the configuration descends to Q, the golden labeling does not. This kills in advance the
   referee objection "the arc is simply not defined over Q" and sharpens the paper's central
   sentence. Classifying the Q-forms (the descent classes; the exhibited one has S3 rational
   symmetry; a pentagonal D5 form plausibly exists among the others) is a small self-contained
   task with a pretty payoff.
3. **B3 inside H3, and the B3 disanalogy** (sections 3.5, 3.6). The rational skeleton of the
   golden pair is the cube group — the silver case is literally the sheet-blind core of the
   golden case. But the naive transfer of M2's mechanism to B3 fails: for B3 the GROUP (S4) is
   rational and sheet-blind while the FORM (7 sqrt2 middle coefficient) is silver — the bit's
   carrier dualizes from the group-embedding to the form/labeling (and the spin cover). M4 must
   be specified against this, not by copying the H3 template.
4. **The perpendicularity pairing** (section 3.5) as M5's germ: a sigma-stable, hence
   prime-independent, canonical bijection between the two sheets' axis systems, available before
   any char-11 choice. M5's gluing statement may factor through it.
5. **Claim-4 hygiene**: the decomposition "PGL_2(11) = (two Galois sheets generating PSL) plus
   (shadow of the rational spinor-norm-2 swap)" is a sharper and more defensible sentence than
   "purely characteristic-11 gluing", and the collision statement (disjoint char-0 vertex sets
   forced onto one P^1(F_11) at q = h+1) is the part that genuinely has no char-0 avatar.

## 6. Reproducibility and boundary

My scripts are session scratch (`fable_verify.py`, `fable_verify2.py`, `fable_verify3.py`,
`fable_verify4.py` under the session scratchpad), run from the repository root with
`uv run python3 <path>`; they consume only the frozen committed artifacts (C379 replay, C399,
C406 scout JSON, C440/C441 modules) and print PASS/FAIL per check. They are review evidence, not
the certificate: the M2 bundle should re-implement (not copy) the section-1 and section-2 checks
as committed artifacts under the crowns lane's discipline, and fold in the golden-frame freeze per
ruling C. Trusted boundary: exact rational and Q(phi) Fraction arithmetic, exact prime-field
arithmetic, and the frozen conventions of C399/C406/C440/C441; group closures are computed, not
assumed; the descent argument additionally uses standard Galois descent for closed subschemes of
P^2 with the period-2/period-3 triviality of the relevant Brauer obstruction, and constructive
Hilbert 90 is exhibited rather than cited. The (2/p) statements are verified at the six listed
primes plus the icosian spinor-norm argument; the law at all split primes follows from the
transporter-coset argument but only the listed primes are machine-checked here.

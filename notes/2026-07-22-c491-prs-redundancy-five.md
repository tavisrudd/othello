# C491 — deep holes of projective Reed–Solomon codes at redundancy five: PRS(q−4)

**Lane:** `reed-solomon` · **Date:** 2026-07-22

Task card: `notes/reed-solomon-tasks/c491-prs-redundancy-five.md`. Entry-gate literature audit
(verdict NOT PRE-EMPTED): `2026-07-22-c491-prs-redundancy-five-literature-audit.md` with search
log `2026-07-22-c491-prs-literature-audit-searchlog.md`.

## Summary

Let q ≥ 7 be a prime power and PRS(q−4) the projective Reed–Solomon code of length q+1 and
dimension q−4 (redundancy five); its parity-check columns are the q+1 rational points of the
quartic normal rational curve C ⊂ PG(4,q).

1. **Covering-radius gate, unconditional (Theorem 0).** ρ(PRS(q−4)) = 4 for every prime power
   q ≥ 7, both parities — by Seroussi–Roth's range k ≥ ⌊(q−1)/2⌋ for completeness of the normal
   rational curve, which covers k = q−4 exactly when q ≥ 7, with the even-q exceptions
   k ∈ {2, q−2} never applying. The redundancy-five classification below is therefore a theorem,
   not conditional on the MDS conjecture (the 2019 seed paper's framing for general k is
   conjectural; its own k = q−3 case is closed by the same argument).
2. **Deep-hole criterion (Lemmas 1–3, characteristic-free).** A syndrome point f = (a0:…:a4) off
   C is a deep hole iff the pencil of binary cubics annihilated by the 2×4 Hankel matrix of f has
   **no totally split squarefree member**. The classification becomes the arithmetic of a
   degree-3 rational map φ_f: P¹ → P¹.
3. **Classification (Theorem 8).** For every prime power q ≥ 23 — proved by the fiber-square
   Weil argument for q ≥ 41 and by exhaustive census for 23 ≤ q ≤ 49 — and also for q = 16, the
   deep holes of PRS(q−4) are exactly:
   - **T (tangent):** the q²+q points on tangent lines of C off C (= Zhang–Wan–Kaipa I.4+I.5);
   - **S (σ-secant):** the q(q+1)(q−1)/2 rational points of secant lines joining conjugate pairs
     of C(F_{q²}) (= Zhang–Wan–Kaipa I.6);
   - **O⁺** (only when q ≡ 2 mod 3): the q(q+1)/2 intersection points Osc(t₁)∩Osc(t₂) of
     osculating planes at distinct rational curve points — the PGL₂-orbit of x²y²;
   - **O⁻** (only when q ≡ 1 mod 3): the q(q−1)/2 rational intersection points of osculating
     planes at conjugate pairs of C(F_{q²});
   - **char 3 replacements for O±:** the single PGL₂-**fixed nucleus point** n = (0:0:1:0:0)
     (in char 3 all osculating planes of C are concurrent at n) and the **wild family W**: one
     orbit of size (q²−1)/2 with stabilizer of order 2q, represented by n − a·ν(∞) with −a a
     nonsquare — an Artin–Schreier family with no tame analogue.
   For q ∈ {7, 8, 9, 11, 13, 17, 19} there are in addition finitely many **sporadic orbits**
   (exhaustively listed below); for no other q ≤ 49 do sporadics exist, and for q ≥ 41 they are
   impossible. Total deep-hole class counts (adding sporadics at the seven listed fields):

   | q | closed form | e.g. |
   |---|---|---|
   | q ≡ 1 (mod 3), char ≠ 3 | q²(q+3)/2                | q=49: 62426 |
   | q ≡ 2 (mod 3)           | q(q+1)(q+2)/2            | q=32: 17952 |
   | char 3                  | (q³+3q²+q+1)/2           | q=27: 10949 |

4. **Novelty.** Redundancy five is the first redundancy at which deep holes beyond the
   tangent/σ-secant families exist, and the first at which the inventory depends on arithmetic
   (q mod 3; a square class in char 3) rather than geometry alone. The families O±, the char-3
   nucleus/wild families, the sporadic tables, and the completeness theorem are new to our
   knowledge (audit caveat: MathSciNet not covered); T and S and the covering-radius inputs are
   Zhang–Wan–Kaipa's and Seroussi–Roth's respectively, and the binary-quartic orbit toolkit is
   Kaipa–Patanker–Pradhan's.
5. **Mechanism.** Deepness is exceptional-cover arithmetic for φ_f: pencils with a common factor
   give T/S; geometrically cyclic φ_f are deep exactly when the order-3 deck transformations are
   Frobenius-twisted (tame: Kummer/Rédei-torus twist = the q mod 3 conditions; wild char 3:
   irrational Artin–Schreier kernel = the square-class condition); geometric-monodromy-S₃ maps
   always have a split member for q ≥ 41 because the fiber-square curve Y_f (bidegree (2,2),
   arithmetic genus 1, absolutely irreducible) has too many rational points not to produce one.

## 1. Conventions

V = F_q⁵, coordinates (a0,…,a4); PG(4,q) = P(V). C: ν(t) = (1,t,t²,t³,t⁴), ν(∞) = e4 — the
columns c₅(t) of the parity check G₅ of PRS(q−4) in [ZWK, §II]. Binary cubics are written
c = c₃T³ + c₂T²U + c₁TU² + c₀U³; the root t corresponds to the factor T − tU, the root ∞ to U.
Hasse derivatives: ν^[j](t) = (C(i,j)t^{i−j})_i, binomials reduced mod p; at ∞ use the reversed
chart. Osc(t) = span(ν(t), ν^[1](t), ν^[2](t)). GL₂ acts on V by the substitution (divided-power)
representation M_g with M_g[k][l] = [s^l] (αs+β)^k(γs+δ)^{4−k}, the unique linear action with
M_g ν(t) ∼ ν(g·t); this is [ZWK, Def. II.8]'s g ↦ g₅ and PAut(PRS(q−4)) = PGL₂(F_q) acts on
syndromes through it [ZWK, Lem. II.9]. The semilinear group is PΓL₂ = PGL₂ ⋊ ⟨Frobenius⟩,
Frobenius acting coordinatewise in this basis.

Caution used throughout: in characteristics 2 and 3 the representation V is **not** isomorphic to
Sym⁴ (some C(4,i) vanish; [KPP, App. A]), so the "formal quartic" Σ a_iT^iU^{4−i} read off the
coordinates does not transform by substitution and its factorization pattern is **not** an orbit
invariant there. All invariants below are defined through the Hankel pencil, which is intrinsic
in every characteristic.

Deep-hole classes are identified with points of P⁴(F_q) by the projective-syndrome bijection
[ZWK, Def. II.1–II.3, Lem. II.2]: given ρ = 4, a syndrome point is a deep-hole class iff it lies
on no plane spanned by 3 distinct points of C. All point counts count syndrome points, as in
ZWK; orbit inventories are listed separately.

## 2. The covering-radius gate

**Theorem 0.** For every prime power q ≥ 7, ρ(PRS(q−4)) = 4.

*Proof.* By Dür's criterion [ZWK, Lem. II.4], ρ ∈ {4,5} with ρ = 4 iff the q+1 points of the
quartic NRC form a complete arc. Seroussi–Roth prove completeness for all k ≥ ⌊(q−1)/2⌋ with no
parity hypothesis [ZWK, §II-A: "The conjecture is true if k ⩾ ⌊(q−1)/2⌋ from the work of Seroussi
and Roth [13]"], and the conjectural statement's only exceptions are q even with k ∈ {2, q−2}.
Now q−4 ≥ ⌊(q−1)/2⌋ ⟺ q ≥ 7, and q−4 ∉ {2, q−2} for every prime power q ≥ 7 (q−4 = 2 forces
q = 6). Explicitly q = 7: k = 3 = ⌊6/2⌋; q = 8: k = 4 ≥ 3 and 4 ∉ {2,6}. ∎

The census additionally verifies ρ ≤ 4 directly (every point of PG(4,q) lies on a 4-column span)
for q ≤ 16, and T ≠ ∅ gives ρ ≥ 4 at every q.

## 3. The Hankel criterion

For f = (a0,…,a4) let H(f) = [[a0,a1,a2,a3],[a1,a2,a3,a4]], and say c ∈ ker H(f) if
Σ_j c_j a_{i+j} = 0 for i = 0,1 (c_j the coefficient of T^jU^{3−j}).

**Lemma 1 (span ⟺ Hankel; characteristic-free).** For distinct t₁,t₂,t₃ ∈ P¹(F_q) and
c = Π(T − t_iU) (factor U for ∞): f ∈ span(ν(t₁),ν(t₂),ν(t₃)) ⟺ c ∈ ker H(f).

*Proof.* (⇐) For finite t_i, c ∈ ker H(f) says (a_i) satisfies the order-3 recurrence with
characteristic polynomial c(T,1) on both length-4 windows; the solution space of that recurrence
on 5-windows has dimension 3 and contains the geometric sequences ν(t_i), which are independent
by Vandermonde; so it equals their span and contains f. With t₃ = ∞, c = U(T−t₁U)(T−t₂U) imposes
the order-2 recurrence on indices 0..3 only; its 5-window solution space is spanned by ν(t₁),
ν(t₂), e4 = ν(∞), again Vandermonde-independent. (⇒) Each ν(t_i) satisfies the recurrence. No
binomial coefficients occur; the argument is field-free. ∎

**Lemma 1′ (confluent refinement).** For s ≠ t in P¹(F_q):
(T−tU)²(T−sU) ∈ ker H(f) ⟺ f ∈ span(ν(t), ν^[1](t), ν(s)); (T−tU)³ ∈ ker H(f) ⟺ f ∈ Osc(t).

*Proof.* Same recurrence argument with the confluent Vandermonde basis: for a repeated root t of
multiplicity m the Hasse-derivative vectors ν^[j](t), j < m, span the corresponding solutions,
and the confluent Vandermonde determinant is a product of differences of distinct roots, hence
nonzero in every characteristic (Hasse derivatives, not iterated d/dt, make this work in small
characteristic). At ∞ use the reversed chart. ∎

**Lemma 2 (pencil).** H(f) has rank 1 iff f ∈ C; for f off C, L(f) := ker H(f) is exactly a
pencil of cubics, and f ↦ L(f) is PΓL₂-equivariant (substitution action on cubics).

*Proof.* Rank ≤ 1 means the rows (a0..a3), (a1..a4) are proportional, i.e. (a_i) is a geometric
progression — f = ν(t) — or the degenerate chains a0 = … = 0 ending in f = ν(∞). Equivariance:
M_g ν(t) ∼ ν(gt) plus Lemma 1 identify ker H(M_g f) with the substitution image of ker H(f);
coordinatewise Frobenius likewise. ∎

**Lemma 3 (criterion).** Given ρ = 4, a point f off C is a deep hole iff no member of L(f) is
squarefree and totally split over F_q. ∎ (Immediate from Lemmas 1–2.)

## 4. Stratification and the classification proof

Let g(f) = gcd of the members of L(f) (degree 0, 1, or 2).

**Lemma 4 (gcd 2).** If deg g = 2 then L(f) = g·⟨T,U⟩ and:
(i) g split squarefree ⟺ f on a rational secant (coset weight 2, not deep);
(ii) g irreducible ⟺ f ∈ **S**: every member has an irreducible quadratic factor — DEEP;
(iii) g = (T−tU)² ⟺ f ∈ **T** (tangent line at t, off C): every member has a repeated factor —
DEEP. Conversely S and T points have these pencils by Lemma 1′. The counts q(q²−1)/2 and q²+q
are [ZWK, Thms I.4–I.6] and hold in every characteristic (verified by census for all 19 fields;
in char 2 the tangent lines meet the invariant nucleus line ⟨e1,e3⟩ in q+1 distinct points, one
per tangent, so the count is unchanged). ∎

**Lemma 5 (gcd 1, never deep for q ≥ 8; all characteristics).** Let g = T − t₀U and W = residual
pencil of quadratics without common root. If the induced degree-2 map ψ is separable, its deck
involution ι is rational (a quadratic extension is Galois), so the graph of ι carries q+1
rational pairs (t, ιt); at most 2 are fixed points, at most 4 lie over the ≤ 2 branch values,
and at most 2 involve a root of the unique member through t₀ — for q ≥ 8 a surviving pair gives
the split squarefree member (T−t₀U)(T−tU)(T−ιtU). If ψ is inseparable (char 2), W is the unique
2-dimensional space of squares ⟨T²,U²⟩, and the window equations force f = ν(t₀) ∈ C — no such
deep hole exists. [q = 7 closed by census.] ∎

**Setup (gcd 0).** X = {(s,t): C_s(t) = 0} ⊂ P¹×P¹ has bidegree (1,3), is absolutely irreducible
(a decomposition would need a component of bidegree (0,·), i.e. an identically vanishing member),
has arithmetic genus 0, hence is smooth and ≅ P¹; the pencil parameter gives a degree-3 morphism
φ_f: P¹ → P¹. By Lemma 1′, (T−tU)³ ∈ L(f) ⟺ f ∈ Osc(t) ⟺ t is totally ramified for φ_f.
Define the fiber-square curve Y_f: c₁(t₁)c₂(t₂) − c₂(t₁)c₁(t₂) = (T₁U₂ − T₂U₁)·G, Y_f = V(G) of
bidegree (2,2), arithmetic genus 1. A rational point of Y off the diagonal over a squarefree
member exhibits two distinct rational roots of a cubic whose third root is then rational: a
split member.

**Lemma 6 (cyclic stratum).** Suppose φ_f is geometrically cyclic (deck group C₃ generated by ρ).
(1) f is DEEP ⟺ ρ is irrational. If ρ is irrational (so Frobenius swaps ρ ↔ ρ²) and t, ρ(t) were
both rational, applying Frobenius gives ρ²(t) = ρ(t), so t is a fixed point and the pair is
diagonal — no split member exists, at every q. If ρ is rational its graph has q+1 rational
pairs; removing ≤ 2 fixed points and ≤ 6 pairs over the ≤ 2 branch values leaves a split-member
witness for q ≥ 8 [q = 7: census].
(2) The stratum has three shapes.
  (a) **tame** (char ≠ 3): exactly two totally ramified points t₁ ≠ t₂ (Riemann–Hurwitz), the
      pair Frobenius-stable, and f is the single point Osc(t₁) ∩ Osc(t₂) (normalize {0,∞}:
      ⟨e0,e1,e2⟩ ∩ ⟨e2,e3,e4⟩ = ⟨e2⟩, in every characteristic). ρ fixes t₁,t₂ with multiplier a
      primitive cube root of unity ζ. If the pair is rational (**O⁺**, orbit of e2 ↔ x²y²,
      size q(q+1)/2, stabilizer dihedral of order 2(q−1)): Frobenius fixes t₁,t₂ and maps
      ζ ↦ ζ^q, so ρ is rational ⟺ q ≡ 1 (mod 3); DEEP ⟺ q ≡ 2 (mod 3). If the pair is conjugate
      (**O⁻**, size q(q−1)/2, stabilizer of order 2(q+1)): Frobenius swaps the fixed points and
      inverts the multiplier, so ρ is rational ⟺ q ≡ 2 (mod 3); DEEP ⟺ q ≡ 1 (mod 3).
      Equivalently: O⁺ is governed by the cube map on F_q^× (bijective iff 3 ∤ q−1), O⁻ by
      multiplication-by-3 on the norm-one torus of order q+1 (bijective iff 3 ∤ q+1).
  (b) **char 3, nucleus:** ν^[2](t) = (0,0,C(2,2),C(3,2)t,C(4,2)t²) = (0,0,1,3t,6t²) ≡ e2 for
      every t (and at ∞), so **all osculating planes are concurrent at n = ⟨e2⟩** — the char-3
      analogue of the conic nucleus at degree p+1. n is PGL₂-fixed (M_g e2 = α²e2 on the Borel;
      the orbit is a single point, census-confirmed at q = 9, 27), its pencil is ⟨T³,U³⟩ = all
      cubes of linear forms (char 3), so **n is DEEP** unconditionally. The tame case (a) cannot
      occur in char 3 (a separable cyclic cover of degree p is wild), and the only pencil all of
      whose members are cubes is n's: the O± families degenerate to the nucleus.
  (c) **char 3, wild:** φ separable, one totally ramified point, wlog ∞ (U³ ∈ L(f), f ∈ Osc(∞)).
      Normalizing the second generator to T³ + αT²U + βTU², deck translations t ↦ t+κ exist iff
      α = 0 with κ² = −β; the stratum is the family f_a = e2 − a·e4 = (0,0,1,0,−a) with pencil
      ⟨U³, T³ + aTU²⟩, whose affine members are the separable polynomials z³ + az + s. DEEP ⟺
      the additive map z ↦ z³ + az is bijective on F_q ⟺ its kernel is irrational ⟺ **−a is a
      nonsquare** (family **W**); for −a a square, 3-root fibers exist and f_a is not deep.
      The stabilizer of f_a is {t ↦ ±t + β} of order 2q: e2 is invariant and e4 = ν(∞) is fixed
      by the affine group, so M_g f_a = α²e2 − aα⁴e4 ∼ f_a ⟺ α² = 1. Hence W is a single orbit
      of size (q³−q)/(2q) = (q²−1)/2 — one deep point for each pair (osculating point t, the
      nonsquare parameter class). [Census: 40 at q=9, 364 at q=27, single orbits.]
(3) If φ is separable and not geometrically cyclic its geometric monodromy is S₃. ∎

**Lemma 7 (S₃ stratum, empty for q ≥ 41).** If φ_f is separable with geometric monodromy S₃,
then L(f) has a split squarefree member.

*Proof.* Y_f is absolutely irreducible: components over F̄_q correspond to orbits of the
geometric monodromy on ordered pairs of distinct roots, and S₃ is transitive on them. Its
arithmetic genus is 1, so geometric genus g ≤ 1 and Aubry–Perret give
#Y(F_q) ≥ q+1 − 2g√q − (p_a − g) ≥ q − 2√q. Discard ≤ 4 diagonal points (Y·Δ = 4; Δ ⊄ Y by
separability) and ≤ 24 points over branch values (the different of φ has degree 4 between
genus-0 curves in every characteristic, so ≤ 4 branch values, each under ≤ 6 ordered pairs).
Since q − 2√q > 28 for q ≥ 41, a witnessing pair survives. ∎

**Theorem 8 (classification).** For every prime power q with q = 16 or q ≥ 23, the deep holes of
PRS(q−4) are exactly T ∪ S ∪ [O⁺ if q ≡ 2 mod 3] ∪ [O⁻ if q ≡ 1 mod 3] ∪ [{n} ∪ W if char 3],
pairwise disjoint, with totals q²(q+3)/2, q(q+1)(q+2)/2, (q³+3q²+q+1)/2 as tabulated in the
Summary. For q ∈ {7,8,9,11,13,17,19} the deep holes are these families together with the
sporadic orbits of §5 (exhaustively certified); no other deep holes exist at any q ≤ 49, and
none beyond the families for q ≥ 41.

*Proof.* Lemmas 3–7 partition the points off C by gcd degree and, at gcd 0, by the
inseparable/cyclic/S₃ trichotomy; each stratum's verdict is proved above for q ≥ 41 (Lemma 7)
and q ≥ 8 (Lemmas 5, 6(1)), and the census (§8) decides every point of PG(4,q) exhaustively for
all 19 prime powers 7 ≤ q ≤ 49, in particular all q ≤ 37 not covered by Lemma 7 — with two
independent implementations agreeing on every field. Disjointness: the families have distinct
pencil signatures (gcd type; cube-member configuration). Counts: T, S from [ZWK]; O± are single
orbits (PGL₂ is transitive on rational and on conjugate point-pairs, and the intersection point
is unique); nucleus and W from Lemma 6(2b,c). ∎

## 5. Orbit inventories under PGL₂ and PΓL₂ (census-certified)

Family orbit structure (all fields verified; stabilizer orders in parentheses):

- **T:** odd char: one orbit of size q²+q (stab q−1). Char 2 (p | k): two orbits, sizes q+1
  (stab q²−q; the nucleus-line points, one per tangent line) and q²−1 (stab q) — matching
  [ZWK, Lem. II.10(3),(5)] for m = 5 ≡ 1 mod 2.
- **S:** point stabilizer 2·gcd(4, q+1) generically. Char 2: one orbit of size (q³−q)/2
  (stab 2). q ≡ 1 mod 4: two orbits of size (q³−q)/4 (stab 4). q ≡ 3 mod 4: three orbits, sizes
  (q³−q)/8, (q³−q)/8, (q³−q)/4 (stabs 8, 8, 4). [The rotation torus of the pair-stabilizer acts
  on the q+1 rational points of the line through the degree-4 representation, leaving a
  gcd(4, q+1)-fold ambiguity.]
- **O⁺:** one orbit, size q(q+1)/2, stab 2(q−1). **O⁻:** one orbit, size q(q−1)/2, stab 2(q+1).
  (These are the Δ=0 orbits G·X²Y² and G·(X²−εY²)² of [KPP, Lem. 5.3] in char ≥ 5.)
- **char 3:** nucleus n: orbit size 1 (stab = PGL₂). W: one orbit, size (q²−1)/2, stab 2q.
- Frobenius fixes every family setwise; PΓL fusion occurs only among sporadics (below).

**Sporadic orbits** (complete list, census-certified; each with zero split members — sizes and
stabilizer orders under PGL₂; "osc" = number of rational osculating points of the pencil):

| q | sporadic orbits: size (stab) | total | PΓL fusion |
|---|---|---|---|
| 7  | 28 (12), 112 (3), 168 (2), 168 (2), 168 (2) | 644 | none (prime field) |
| 8  | 252 (2) ×3 | 756 | the three fuse into one PΓL orbit |
| 9  | 180 (4), 360 (2) ×2 | 900 | the two 360s fuse |
| 11 | 330 (4), 660 (2) | 990 | none |
| 13 | 182 (12), 546 (4) | 728 | none |
| 17 | 1224 (4) | 1224 | none |
| 19 | 570 (12) | 570 | none |

All sporadics have pencil gcd 1 and lie in the S₃ stratum (Lemma 7's regime, below its bound);
the stab-12 orbits at q = 7, 13, 19 (all q ≡ 1 mod 3) have pencils with no linear-times-
irreducible members at all — extra symmetry consistent with special j-invariant strata. Their
detailed member statistics are in the census JSON.

## 6. Invariant atlas and comparison algorithm

Given f ∈ P⁴(F_q):
1. rank H(f) = 1 ⟹ f ∈ C (weight ≤ 1).
2. Else compute L(f) = ker H(f) and its gcd:
   - gcd split quadratic ⟹ weight 2. gcd = ℓ² ⟹ **T** (deep). gcd irreducible ⟹ **S** (deep).
   - gcd degree 1 ⟹ weight 3, not deep (Lemma 5).
   - gcd 1: locate cube members over F_{q²}:
     two cube points ⟹ **O⁺/O⁻** by pair rationality, deep by q mod 3 (char ≠ 3);
     char 3: pencil ⟨T³,U³⟩ ⟹ nucleus (deep); one cube point with translation normal form
     α = 0 ⟹ **W**, deep ⟺ −a nonsquare; otherwise S₃ ⟹ not deep for q ≥ 41 / q = 16 /
     23 ≤ q ≤ 49; for q ∈ {7,…,19} compare against the certified sporadic orbit list (orbit
     membership via canonical minimal-index representative under the group generators).
3. Char ≥ 5 labels: J(f) = 0 cuts the secant variety (S ∪ secants ∪ C), I = J = 0 the tangent
   developable (T ∪ C), Δ = I³ − J² = 0 ⊇ O± [KPP §3, Lem. 5.3]; deep holes with Δ ≠ 0 exist
   only among sporadics (q ≤ 19). In char 2/3 use only the pencil invariants (the coordinate
   "quartic" is not Sym⁴-covariant there).

## 7. Positioning

- [ZWK] = Zhang–Wan–Kaipa, IEEE-IT 2020 (arXiv:1901.05445): redundancy ≤ 4 classification; the
  announced k = q−4 sequel has not appeared (audit 2026-07-22). Their families are exactly T, S;
  Theorem 0 sharpens the covering-radius premise for k = q−4 from conjectural to unconditional
  via their own cited Seroussi–Roth range.
- [KPP] = Kaipa–Patanker–Pradhan (arXiv:2312.07118v3): PGL₂(q)-orbits of binary quartics,
  char ≠ 2,3 — cited for the Δ=0 orbit inventory (O± normal forms and stabilizers) and the
  invariant dictionary; not re-derived. Kamenetsky's thesis anticipated the quartic orbit counts
  over F_p [KPP, Rem. 5.12]. Their deferred char-2/3 quartic classification is partially
  advanced here on the deep-hole-relevant strata (nucleus concurrency; W normal form).
- The nucleus concurrency of osculating hyperplanes for NRCs of degree p+1 in characteristic p
  parallels the classical conic nucleus (q even); we did not locate a use of it in deep-hole
  contexts; it drives the entire char-3 answer here.
- Adjacent but distinct: Gu–Wang–J. Zhang (arXiv:2509.08526) classify deep holes of twisted RS
  codes including a k = q−4 case — different code family (audit, finding 1).
- To our knowledge (MathSciNet gap recorded in the audit), the exceptional-cover mechanism for
  deep holes, the O±/nucleus/W families, the sporadic tables, and Theorem 8 are new.

## 8. Evidence

All computations are exhaustive over their stated domains; no randomness; fixed field moduli
(GF(8): t³=t+1; GF(9): t²=−1; GF(16): t⁴=t+1; GF(25): t²=2; GF(27): t³=t−1; GF(32): t⁵=t²+1;
GF(49): t²=3).

- `2026-07-22-c491-prs-deep-hole-census.py` — primary generator (plane-marking over all
  C(q+1,3) column triples; PGL₂ orbit BFS with runtime-verified generator matrices; Frobenius
  fusion; per-orbit pencil statistics; V1 ρ≤4 check for q ≤ 16; V2 constructive
  tangent/σ-secant containment; V3 Hankel cross-check at q = 7, 11).
  Regenerate: `python3 notes/2026-07-22-c491-prs-deep-hole-census.py` (repo root; rewrites the
  JSON; deterministic).
- `2026-07-22-c491-prs-deep-hole-census.json` — canonical certificate: per q ∈ {7,8,9,11,13,16,
  17,19,23,25,27,29,31,32,37,41,43,47,49}: deep-hole count, family counts, complete PGL₂ orbit
  inventory (representative, size, stabilizer, pencil statistics, Frobenius image), PΓL count.
- `2026-07-22-c491-prs-deep-hole-replay.py` — independent implementation (Fable-authored vs
  Opus-authored generator; per-point Hankel-pencil test — a different algorithm exercising
  Lemmas 1–3 directly — plus independent constructions of T, S, O±, nucleus, W and the R1–R4
  checks described in its header).
  Replay: `python3 notes/2026-07-22-c491-prs-deep-hole-replay.py` (repo root; reads the JSON;
  exit 0 iff all checks pass). Result: `ALL REPLAY CHECKS PASS` on all 19 fields.
- Hashes: `2026-07-22-c491-prs-redundancy-five.sha256` (bundle manifest, committed together).

What the computation certifies: for each of the 19 listed fields, the exact deep-hole set of
PRS(q−4) in PG(4,q), its family partition, and its PGL₂/PΓL₂ orbit inventory, by two independent
programs whose outputs agree pointwise (R1) and orbitwise (R2). What it does not certify:
anything for q > 49 (there Theorem 8 rests on Lemmas 4–7) or for the excluded degenerate
parameters q < 7. Negative statements ("no sporadics at q = 16, 23 ≤ q ≤ 49") are exhaustive
searches of PG(4,q) with the stop condition "all points classified".

## 9. NRC bridge ledger (tool observatory for the punctured-NRC / Cheng–Murray programme)

**Dimension-free, proved in strongest safe form (the proofs of Lemmas 1, 1′, 2 never use r=5):**
- Redundancy-r Hankel criterion: f ∈ P^{r−1} lies in the span of r−2 distinct columns of the
  degree-(r−1) NRC iff the corresponding split squarefree degree-(r−2) form lies in the kernel
  of the 2×(r−1) Hankel of f; the kernel is an (r−3)-dimensional linear system for f off the
  curve; Hasse confluence handles osculating flags; the substitution action is equivariant.
- Deep-hole criterion at any redundancy: no split squarefree member in that linear system.
- gcd-stratification recursion: a degree-d common factor reduces to the system one redundancy
  down; the top stratum (degree r−3 gcd) reproduces ZWK's T/S families uniformly at every r.
- Char-p nucleus: for the NRC of degree p+1 in PG(p+1, p^m), ν^[2] is constant, all osculating
  planes concur, and the nucleus is a PGL₂-fixed deep hole (the argument only uses
  C(p,2) ≡ C(p+1,2) ≡ 0 mod p).
**Quartic / rank-five accidents (provably do not scale):**
- The kernel being a pencil (single trigonal curve X, fiber-square Y, deck trichotomy,
  exceptional-cover arithmetic) is specific to r = 5; at r ≥ 6 the system is ≥ 2-dimensional.
- Osc ∩ Osc a single point is the dimension count 2+2−4 in PG(4).
- No Gale self-duality anywhere (needs n = 2r = 10).
**Exact next falsifiable lemma (r = 6, quintic NRC in PG(5,q)):** the Hankel kernel of a generic
point is a *net* of binary quartics; conjecture: there is an explicit q₁ such that for q ≥ q₁
every net of binary quartics with trivial gcd whose incidence surface
{(s,t) ∈ net×P¹: member_s(t)=0} is "non-exceptional" contains a totally split squarefree member,
with exceptional nets classified by positive-dimensional analogues of the O±/W loci. The natural
attack replaces Aubry–Perret on the (2,2) fiber-square curve by Lang–Weil on the fiber-square
surface; the redundancy-six census (this generator, q ≤ 16, minutes of runtime) would test it
directly and is the concrete next gate for any arbitrary-redundancy allocation.

## 10. Mystery ledger

Settled during the ej closeout:
- *Why census excess at q=27 is tiny (365) while the naive wild count is (q³−q)/2:* the wild
  orbit's stabilizer is 2q, not 2 — translations stabilize e2 − a·e4 because e2 is invariant and
  e4 = ν(∞) is translation-fixed; orbit (q²−1)/2. Settled in Lemma 6(2c) after an initial
  transposed-convention miscalculation; the census and replay agree.
- *The single size-1 excess orbit in char 3:* the nucleus concurrency ν^[2] ≡ e2 (Lemma 6(2b)).
- *"Factor type" anomalies in the orbit labels (e.g. O⁻ showing split types):* the coordinate
  quartic is not Sym⁴-covariant in char 2/3, and in odd char differs from the intrinsic quartic
  by binomial rescaling; labels via the pencil are used instead.
Open, with owners/gates:
- **Sporadic vanishing threshold:** Lemma 7 proves emptiness for q ≥ 41, but sporadics already
  vanish at q = 16 and all 23 ≤ q ≤ 37. The gap is the slack in the (4 + 24)-point bookkeeping
  and in Aubry–Perret; sharpening to the true threshold (23? 21?) is a bounded, purely
  curve-theoretic question — unallocated, no current consumer.
- **Structure of sporadics:** the stab-12 sporadic orbits at q = 7, 13, 19 (exactly the sporadic
  prime fields ≡ 1 mod 3) have pencils with no linear×irreducible members; a uniform
  description (plausibly equianharmonic/j = 0 pencils with arithmetically degenerate S₃ image)
  is not established. Certified data suffices for the classification; the pattern is logged in
  the discovery track for possible promotion.
- **PΓL fusion at q = 8:** the three sporadic 252-orbits form one Frobenius orbit — consistent
  with a Gal(F_8/F_2)-torsor structure on a cubic-twist parameter; not derived. Data-complete,
  derivation open.
No other unexplained features remain: every census number above is either derived in §§2–5 or
explicitly listed as sporadic certified data.

## Lifecycle

Acceptance vs the task card: covering-radius premise settled unconditionally (stronger than
required); complete semilinear orbit classification with explicit invariant formulas,
exceptional strata (O±, nucleus, W, sporadics), canonical comparison algorithm (§6), literature
positioning (§7, plus the standing audit), atomic evidence with independent replay (§8); NRC
bridge ledger with a falsifiable next lemma (§9). The 2019-announced case is hereby closed on
the mathematical side available to this repository.

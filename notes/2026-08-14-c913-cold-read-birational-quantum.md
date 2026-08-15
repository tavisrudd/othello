# C913 cold read: birational and quantum content of the cubic-stabilization manuscript

Referee role: birational geometry / quantum cohomology. Cold read, independent verification.
Manuscript: `papers/cubic-stabilization-irrationality/`. Assigned frozen commit `b3b463ecc`; the
abstract was re-read at `44f7ec0c2` (see item 8b).

Read in full: `sections/01-introduction.tex`, `02-point-row.tex`, `03-simple-wall.tex`,
`04-ordinary-flop.tex`, `05-incomplete-gamma.tex`, `06-fourier-boundary.tex`,
`07-two-wall-criterion.tex`, `08-scope.tex`, `08-global-transport.tex` from
`def:finite-dual-cyclic-rees` to the end, plus (for context only) `08-global-transport.tex`
lines 1--215 and 324--360 and 433--463, and the current abstract in
`cubic_stabilization_irrationality.tex`.

Sources consulted directly (shared cache, `/tmp/persistent/tavis/lit-search/`):
Gu--Yu--Yu arXiv:2508.15770 (pp. 22--25, 31--36, 37, 42--44, 54--55), Lee--Lin--Qu--Wang
arXiv:1401.7097 (Theorem 0.1.1 and surrounding text), Shen--Shoemaker arXiv:2502.08762
(Theorems 1.1, 1.2, 1.4 and abstract), Coates--Iritani--Jiang arXiv:1410.0024 (Theorems 6.1,
6.3, Remarks 6.4--6.6, non-equivariant-limit passages), Woodward QK II arXiv:1408.5864
(Example 5.23), Woodward QK III arXiv:1408.5869 (Example 9.15 header and framing text only).
Not consulted: Iritani arXiv:1906.00801, Aleshkin--Liu, Gonzalez--Woodward, RSSW, Cai,
Wlodarczyk. Taken as given per instructions: the derived appendix and everything in
`08-global-transport.tex` before `def:finite-dual-cyclic-rees` (`def:gauged-admissible`,
`prop:support-collapse`, `thm:tailwise-derived`, `prop:clutching-tail-holonomicity`).

---

## Required repairs (do these before circulation)

**R1. Pin the z-independence of the receiver coordinate in (G3)/(G4).**
The induction in `thm:simple-wall-point-column` closes only because `m c_m [p_+]` in
`eq:first-point-tail-coefficient` has z-degree zero. That fact is *not* among the four pinned
Gu--Yu--Yu inputs. It is true --- Gu--Yu--Yu Corollary 4.19 gives
`τ_X(θ) ∈ H^*(X)⟦C^∨_{X,N}, θ⟧`, with no z, and `τ_X(θ)|_{θ=Ŝ=0} = 0` --- but as the
proposition is currently pinned, a referee cannot check it. If `c_m` were allowed z-degree
≥ 1 the top-z-power cancellation the proof rules out could occur (`m v_{m,d}` against
`m c_m^{(d+1)}[p_+]`). Add to (G3) or (G4): "the receiver coordinate `τ_+(θ)` lies in
`H^*(X_+)⟦C^∨,θ⟧` and vanishes at `θ = q_w = 0` [GuYuYu, Cor. 4.19, p. 36]".

**R2. Stop asserting that `conj:gamma-window` implies the two hypotheses.**
Section 8 is correct and explicit --- "It is motivation rather than a proof" --- but the
introduction states the implication flatly ("That conjecture implies both threshold
hypotheses, by the Euler orthogonality above"), `08-scope.tex` item (7) calls it "the cleanest
implying statement we know", and the new abstract says "implies them". Change all three to the
conditional ("would imply", "we expect it to imply"). See item 5 for the two concrete gaps in
the sketch.

**R3. Repair the separation step in the sketch of implication.**
"nondegeneracy of the flat pairing on the window span then separates the two" does not follow
as written. Orthogonality `V_t ⊥ K̃` plus nondegeneracy on the *whole* span gives
`K̃ ∩ V_t = 0` only if `K̃ + V_t` is the whole span. Either add the spanning hypothesis, or
assume nondegeneracy of the Euler pairing on the wall-supported part, or say plainly that this
step is unproved.

**R4. Fix the abstract's "unconditional" framing (paragraphs 2 and 3).**
"The endpoint contrast and the transport mechanism are unconditional", followed by a third
paragraph saying "What is not proved is the comparison across thresholds", together assert
that gauged-admissibility is proved. It is not: `08-scope.tex` item (5) and the paragraph after
`def:gauged-admissible` state that the proper-DM master-stack, obstruction-theory,
stable-equals-semistable, and numerical-separation clauses are assumptions, and that "no
existing theorem asserts this for an arbitrary Wlodarczyk completion". Paragraph 1 does grant
gauged-admissibility, so the abstract contradicts itself rather than the body. Suggested fix:
"unconditional given gauged-admissibility, and independent of the threshold hypotheses", and
name gauged-admissibility again in paragraph 3.

**R5. Re-attribute the semiorthogonal decomposition.**
`hyp:one-wall-sectorial`(b) says "the wall functors in the Shen--Shoemaker semiorthogonal
decomposition". Shen--Shoemaker's own Theorem 1.1 attributes the standard-flip SOD to
Belmans--Fu--Raedschelders ("This was later extended to standard flips by
Belmans--Fu--Raedschelders [7]"). Write "the semiorthogonal decomposition of
Belmans--Fu--Raedschelders used by Shen--Shoemaker".

**R6. Rewrite the invocation of Shen--Shoemaker inside the proof of `cor:simple-wall-rank`.**
"Shen--Shoemaker's oriented Gamma asymptotics identify these supported classes with the wall
blocks on the chosen common sector \cite{ShenShoemaker}" reads as an unconditional citation,
but that identification is precisely clause (b) of `hyp:one-wall-sectorial`. Cite the
hypothesis, not the source. (The closing paragraph of Section 3 already says the right thing;
the proof text undercuts it.)

Optional repairs are collected at the end.

---

## Item-by-item verdicts

### 1. `thm:simple-wall-point-column` (induction; use of (G3)) --- CONFIRMED, subject to R1

Judged text: `sections/03-simple-wall.tex` lines 8--153.

*Does the induction kill the whole wall-parameter tail?* Yes, given R1. I re-derived the
coefficient equation. With `FT_{X_+}(a_p) = [p_+] + Σ_{k>0} q_w^k v_k` and
`τ_+(q_w) = f(q_w)·1 + η(q_w)`, the `q_w^m` coefficient of the operator
`(z q∂_q + D⋆_{τ_+} + (q∂_qτ_+)⋆_{τ_+})` applied to `FT_{X_+}(a_p)` is
`(zm·id + D∪−)v_m + m c_m [p_+]` exactly as displayed, because: (i) `D∪[p_+] = 0` by degree;
(ii) all `v_k` with `k < m` vanish by the inductive hypothesis, so every positive-`q_w`-order
product term acting on them drops; (iii) positive-wall quantum corrections and `η⋆` annihilate
`[p_+]` --- correct, since the only Novikov variable retained is `S_{F_0}`, whose positive
multiples are classes on the contracted extremal ray, so every effective curve in those classes
lies in the exceptional locus and the moduli does not dominate `X_+`; the divisor and bulk
insertions do not disturb that support argument. Then with `v_m ∈ H^*(X_+)[z]` of z-degree `d`
and `c_m` a scalar, the `z^{d+1}` coefficient is `m v_{m,d} = 0`, contradiction; so `v_m = 0`
and then `c_m = 0`. The base case `m = 1` is vacuous. So the tail and the unit part of the
receiver coordinate both die. The only load-bearing unstated input is the z-freeness of `c_m`
(R1).

*Is (G3) used within its hypotheses?* Yes. I checked both clauses against the source.
Gu--Yu--Yu Lemma 5.10 (p. 43) reads: "Given `α ∈ H^*_{C^*}(W)` such that `α|_{F_0}` as a
polynomial in `λ` has degree `deg_λ(α|_{F_0}) ≤ r_{F_0,−} − 1`, we have
`FT_{X_−}(α)|_{Q_W=θ=0} = κ_{X_−}(α)`" --- the manuscript's degree condition and specialization
are copied correctly. Both applications satisfy it trivially: `a_p|_{F_0} = 0` and
`(λ a_p)|_{F_0} = 0`. Lemma 5.8 (p. 42) gives the positive-side expansion
`FT_{X_+}(α)|_{Q_W=0,θ=0} = κ_{X_+}(α) + Σ_{k>0} f_{+,k}(α)S_{F_0}^k` with
`f_{+,k}(α) ∈ H^*(X_±)[z]`, matching the manuscript's (G3) including the polynomiality in `z`
that the induction needs. (Note the source's negative-side expansion runs in `S_{F_0}^{−k}`;
the manuscript never uses that form, correctly, because Lemma 5.10 truncates it.)

*Base change.* Proposition 5.9 states `FT_{X_−}` and `Ψ_+` are `R̃`-module isomorphisms and
Proposition 5.2 gives finite freeness of the completion; base change of an isomorphism of
`R̃`-modules along `R̃ → R̃/(Q_W, θ)` is an isomorphism, so the deduction "`λ a_p` is zero in
the specialized completed source" is legitimate. The specialization `Q_W = θ = 0` with the
wall variable retained is Gu--Yu--Yu's own operation (Lemmas 5.8, 5.10). Both `FT_{X_−}` and
`Ψ_+` are defined on the *same* module `QDM_{C^*}(W)^{∧,La}_{X_−}` (proof of Prop. 5.9), so
`FT_{X_+}(λ a_p) = 0` follows.

*(G4) is accurate and, in fact, exact.* Gu--Yu--Yu Proposition 4.14(2) gives
`F_X ∘ λ = (z λ_Ŝ∂_Ŝ + κ_X(λ)) ∘ F_X`, and the displayed pullback connection just before
Proposition 4.21 is `∇_{ξŜ∂_Ŝ} = ξŜ∂_Ŝ + z^{−1}(κ_X(ξ)⋆_{τ_X}) + z^{−1}((ξŜ∂_Ŝ τ_X)⋆_{τ_X})`.
Multiplying by `z` reproduces `eq:positive-fourier-connection` term for term. Since the
operator contains no `∂_θ`, specializing `θ = 0` in the identity is legitimate.

*(G1) and (G2).* (G1) matches Theorem 6.2 (pp. 54--55) exactly, including the range
`j = 0,…,ν−1` with `ν = r_− − r_+`, the pairing intertwining, and the wall quotient (their
`M^0`; the manuscript writes `S`). (G2) is substantively right but the locator is loose: what
Lemma 3.27 (pp. 24--25) states is existence and uniqueness of `α` with `κ_{X_+}(α) = α_+`,
`κ_{X_−}(α) = φ_2(α_+)` and `deg_λ(α|_{F_0}) ≤ r_{F_0,+} − 1`. Two small steps are silently
taken: (a) `φ_2([p_+]) = [p_-]` for a common-open point (true: pull back to the common blowup
and push down); (b) the sentence "its proof identifies `a_p|_{F_0} = f(λ)`" is not displayed in
the proof of Lemma 3.27; Gu--Yu--Yu state the corresponding fact only later, in the proof of
(3.31) on p. 26 ("recall from the proof of Lemma 3.27 that if `α_1|_{P(N_{F_0,+})} = f(h_+)`
... then `φ_2(α_1)|_{P(N_{F_0,−})} = f(−h_−)`"). The conclusion `a_p|_{F_0} = 0` is correct
--- `[p_+]` restricts to zero on the disjoint locus `P(N_{F_0,+})` --- but the pin should cite
p. 26 as well.

*Exposition gap (optional):* the proof never says `Φ = Ψ_+ ∘ FT_{X_−}^{-1}`, which is what
converts `FT_{X_+}(a_p) = [p_+]` and `FT_{X_−}(a_p) = [p_-]` into
`pr_{X_+}Φ([p_-]) = [p_+]`. One sentence fixes it.

*`cor:simple-wall-rank`:* the algebra is fine (a connection-intertwining decomposition carries
the `ζ_6` generalized eigenspace to the direct sum of the summands' `ζ_6` parts, and the row
vanishes on the wall summands by Euler orthogonality), but see R5 and R6 for how the
Shen--Shoemaker input is cited. Shen--Shoemaker's abstract and Theorem 1.4 do support the
weaker description used in the introduction ("identify Gamma asymptotic classes at an extremal
specialization").

### 2. `thm:ordinary-flop-point-row` --- CONFIRMED with two wording defects

Judged text: `sections/04-ordinary-flop.tex` lines 33--96.

*Minimal-transverse-degree argument.* Complete. The transverse constant term vanishes for the
reason given: at transverse degree zero every nonconstant stable map has pure extremal class,
lies in the exceptional locus, and misses `p`, so every descendant invariant with the point
insertion vanishes for arbitrary bulk insertions; `Γ̂ ch(O_p)` is a scalar multiple of `[p]`
and the scalars agree on the two sides since `dim Y = dim Y'`; the graph correspondence sends
`[p]` to `[p']`. The minimum over positive `D`-degrees exists because `D` is an integral
pullback of an ample class, so `D·β ∈ Z_{>0}` on the transverse part. The convolution terms
drop by minimality. The operator `(D·β)id + z^{−1}(D∪−)` is invertible because `D∪` is
nilpotent and `D·β ≠ 0`.

*Divisor axiom on the hybrid ring.* Valid. At transverse degree zero the corrections to `D⋆`
have pure extremal class `β = dℓ ≠ 0`, and the divisor axiom contributes the factor
`D·dℓ = 0` for every insertion pattern, including bulk insertions; degree-zero classes with
four or more insertions vanish. So the extremal correction series is identically zero term by
term, hence its analytic continuation to `U` is zero, hence `D⋆_q = D∪` on all of `U`. The
continuation does not weaken the axiom, because the axiom is applied before summing.

*"Jointly flat".* Used inconsistently, though harmlessly for this theorem. The proof defines
`δ` as flat for *both* the z- and Novikov-direction connections but uses only the
Novikov-direction equation. The z-direction claim is where the real content sits and it is not
argued: Lee--Lin--Qu--Wang Theorem 0.1.1 gives an isomorphism of *big quantum rings* after
analytic continuation, with the Poincare pairing preserved by `F = [Γ̄_f]_*`; that yields the
`τ`- and Novikov-direction connections directly, but `∇_{z∂z}` additionally needs
`F μ = μ' F` and `F(c_1(Y)) = c_1(Y')`. Both are standard for ordinary flops (degree-preserving
motive correspondence; crepancy) but neither is stated or cited. `cor:ordinary-flop-packet`
depends on exactly this ("preserves the quantum connection, grading, first Chern class, and
Poincare pairing. It therefore transports the complete z=0 formal type"), so the citation
belongs there.

*Coefficient field.* "the coefficient recursion below is taken after extension to `C((z))`" is
the wrong field: Gamma-framed flat sections live in `C[[z^{-1}]]` after the `z^{−μ}z^{ρ}`
factors are stripped. Nothing breaks --- the operator is invertible over any ring containing
`z^{-1}` --- but the sentence should say so.

*Scope of what is claimed.* Correctly limited. Lee--Lin--Qu--Wang say explicitly "Theorem 0.1.1
does not hold for descendants", and the manuscript's theorem *is* a descendant-level statement
about one column; the proof rightly obtains it by direct support vanishing plus flatness rather
than by quoting the source, and the closing paragraph plus `08-scope.tex` item (2) say so.
`eq:flop-novikov-inversion` (`q' = q^{−1}`, `F(ℓ) = −ℓ'`) and the hybrid analytic/formal setup
match the source's "analytic in `q_ℓ` while remaining formal in other Novikov variables".

### 3. Countermodels and the two-wall criterion --- CONFIRMED

*`prop:incomplete-gamma`* (`sections/05-incomplete-gamma.tex`). I verified every computation.
`y_1 = z^α e^{−1/z}` solves the second row (`(z^α e^{−1/z})' = (α/z + z^{−2})y_1`); with
`Γ(s,x) = ∫_x^∞ t^{s−1}e^{−t}dt` and `s = 1−α`, `x = 1/z`, one gets
`d/dz Γ(1−α,1/z) = z^{α−2}e^{−1/z}`, which is the first row. Formal monodromy of the second
factor is `e^{2πiα} = ζ_6` at `α = 1/6`; the first factor is the trivial line, monodromy one.
The hyperbolic doubling works: with `B = diag(A, −A^t)` and `J` the off-diagonal identity
blocks, `B^tJ + JB = 0`, and `M = diag(S, S^{−t})` satisfies `M^tJM = J`. The
`Q[N]/(N^3)` tensor commutes with the jump. The confluence family is right too: substituting
`z → z/t` gives exactly the displayed matrix, and the two exponential factors `1` and
`e^{−t/z}` collide at `t = 0`. One wording defect: "Analytic continuation of the incomplete
Gamma function adds a nonzero multiple of the complete Gamma value" describes the *monodromy*
of `Γ(s,x)` in `x`, not the Stokes jump; the Stokes statement that follows is correct but the
justifying sentence conflates the two. Optional fix.

*`prop:punctual-corner`* (`sections/06-fourier-boundary.tex`). Verified: the differential
shadow `(∂_x + 1 + α/x)∂_x g = 0` holds for `g = Γ(1−α,x)` (direct computation); the Weyl
automorphism `x_i ↦ −∂_{τ_i}`, `∂_{x_i} ↦ τ_i` exchanges `D_x/D_x(∂_{x_1},∂_{x_2}) = O_{A^2}`
with `δ_{00}`; `τ_i` acts locally nilpotently on `δ_{00}`, so inverting either kills it.

*Does the prose claim what the countermodels prove?* Yes, and it is unusually careful. The
remark after `prop:incomplete-gamma` states it is "an analytic no-go theorem, not a geometric
counterexample", and the last sentence of Section 6 says retaining the boundary object is
"necessary, not that its support alone proves the desired vanishing". The introduction's
summary ("Boundary support in Fourier coordinates therefore points in the opposite direction
from the desired rank conclusion") is loose but not false.

*Section 7.* The separation of proved from hypothesized is correct. `thm:rank-zero-target` is
one line of linear algebra from `hyp:rank-zero-target` and is presented as such. The
`μ_{00}(B_corner) = 0` numerical test is explicitly labelled "not proved here". The
dimension-two obstruction is verified: with `r = e_1^*`, `A = e_1⊗e_2^*`, `A^2 = 0` and
`id = (id+A)(id−A)` while both factors have target `e_1` with `r(e_1) = 1` --- so a vanishing
total correction does not force factorwise rank-zero targets. The distinction between output
support `Y×D` and source support `D×Y`, and the word "complete" in the hypothesis, are both
correctly flagged as load-bearing. `rem:what-remains` states the gap accurately. No
overstatement found in this section.

### 4. The two threshold hypotheses --- CONFIRMED as falsifiable and non-circular in the strict sense, but see the caveat

Judged text: `08-global-transport.tex` lines 703--871.

*Falsifiability.* Both hypotheses are existential statements over identified objects (a local
domain `U_j` in the Fourier variable with fixed oriented cuts, a marked finite locally free
Rees module `(K_j, r_j)` on `U_j × S` with named structure, an oriented path `γ_j`; at a zero
mode, a marked meromorphic family `M_j` with named strictness and local-freeness properties).
Falsifying them means exhibiting a threshold at which no such object exists. That is a
well-posed mathematical statement, so the manuscript's claim that they are "independently
falsifiable marked irregular-connection statements" is fair.

*Does the zero-mode hypothesis say what the prose claims?* Yes. The prose in the introduction
("the zero-mode specialization must identify the entire adjacent row-generated cyclic module
with its reduced nearby-cycle realization") and in `08-scope.tex` item (7) match
`eq:zero-mode-specialization`: `sp_j^± : K̃_j^± → K_j^±` strict isomorphisms in `C_N(S)`, where
`K̃_j^±` is the row-generated cyclic module on the adjacent tail and `K_j^±` is the saturation
of the row orbit inside `ψ_t^red M_j`. The claim "Preservation of primary support is a
consequence, not part of the hypotheses" is literally true --- but nearly vacuous, since any
isomorphism intertwining formal monodromy preserves every primary projection by functional
calculus. That is worth saying out loud in the paper rather than presenting it as a
meaningful separation.

*Circularity.* Not circular in the logical sense. The hypotheses posit maps of Rees--Stokes
modules with strictness, deck equivariance, Stokes-filtration compatibility, frame rigidity,
and Artin-level compatibility; the conclusion is a Boolean about primary projections. The
manuscript's own defence ("The primary Boolean does not imply marked threshold compatibility.
Equality of the zero or nonzero primary projections supplies neither a horizontal map of Rees
modules nor compatibility with Stokes filtrations, deck actions, boundary germs, or the Artin
inverse system") is correct: the implication runs one way only. The caveat a referee should
record is different and should be stated by the authors, not left to the reader: the
hypotheses are a *threshold-local form of the conclusion plus structure*, so the residual
mathematical content of `thm:birational-point-primary` is the global architecture (one
cobordism, finitely many thresholds per Artin level, endpoint identification, inverse system),
not the transport itself. The new abstract's "Given those maps the transport is linear algebra"
concedes exactly this, and that is the right posture; the introduction should say it too.

*Unverified inside the hypotheses.* One clause of `hyp:marked-threshold-wall` is stronger than
"parallel transport": `Φ_j T_j^- = T_j^+ Φ_j` requires the formal monodromy to be flat along
`γ_j`, which is plausible for the posited integrable family but is an additional demand, not a
consequence of transport. Not a defect, since it is a hypothesis; worth an explicit remark.

### 5. `conj:gamma-window` and its sketch of implication --- OVERSTATED (implication asserted), with two identified gaps

Judged text: `08-global-transport.tex` lines 880--915, plus `01-introduction.tex` lines 154--164
and `08-scope.tex` item (7).

The conjecture itself is stated precisely and is credibly new. The sketch, however, does not
establish the implication, and two specific things are missing.

(a) *Nondegeneracy step is invalid as written.* "wall-supported generation makes `V_t(M_j)`
Euler-orthogonal to the row-generated module, and nondegeneracy of the flat pairing on the
window span then separates the two". From `V_t ⊥ K̃` alone, an element `x ∈ K̃ ∩ V_t` is
orthogonal to `K̃ + V_t`, not to the whole span; concluding `x = 0` needs
`K̃ + V_t = ` the window span (or nondegeneracy on one of the two pieces), which the conjecture
does not assert. This is R3.

(b) *Monodromy stability of the orthogonality is not addressed.* The cyclic module is generated
by `{g(rT^k)}`, i.e. by the deck-and-monodromy orbit of the marked row, not by the row alone.
Euler orthogonality is asserted for the skyscraper of the common-open point. To get
orthogonality for the whole orbit one needs the wall-supported span to be stable under `T` and
`G` and the pairing to be compatible with `T`. Plausible, but unstated.

(c) *The structural clauses are untouched by the sketch.* Finite local freeness, strictness of
the Rees--Stokes saturations, preservation of the Stokes filtration, deck equivariance,
commutation with input and bulk derivatives, and compatibility over the Artin inverse system
are all part of the two hypotheses and get no argument at all in the sketch. So even with (a)
and (b) repaired, "implies" is not earned; "is the cleanest statement we know that would plausibly
imply" is.

Section 8's own framing ("It is motivation rather than a proof, and nothing later in the paper
depends on it") is accurate. The introduction, `08-scope.tex`, and the abstract are not. R2.

### 6. `rem:verification-status`: the two toric calibrations --- MIXED (one CONFIRMED and independently re-derived, one CONFIRMED as to the cited content but with an understated limit; one component UNVERIFIED)

Judged text: `08-global-transport.tex` lines 924--989.

*The `Bl_p P^2` calibration: CONFIRMED, and I re-derived it.* Woodward QK II Example 5.23 does
give exactly the stated presentation --- "`X = C^4` and `G = (C^×)^2` acting with weights
`(1,0), (1,0), (1,1), (0,1)`", with `ν = (1,2)` giving `P^2` and `ν = (2,1)` giving the blowup.
The manuscript's chamber maps are right: in the `P^2` chamber `x_4` is gauge-fixed so
`(x,y) ↦ (H,0)`; in the blowup chamber the toric divisors force `D_1 = D_2 = x = H−E`,
`D_3 = x+y = H`, `D_4 = y = E`, which is consistent with the intersection numbers
`(H−E)^2 = 0`, `H^2 = 1`, `E^2 = −1`. Hence `x(x+y) ↦ H^2` and `↦ (H−E)·H`, the point class in
both chambers. I also checked the vanishing on the wall: the wall is the ray spanned by the
weight `(1,1)`, the intermediate fixed stratum has stabilizer `ker(x+y) = {(t,t^{−1})}`, and
restriction sends `x ↦ λ`, `y ↦ −λ`, so `x(x+y) ↦ λ(λ−λ) = 0`. So the example really is an
instance of `def:gauged-admissible`(iv) / (G2). The manuscript's own limits on it are stated
correctly and generously: nonneutral direction, calibrates conventions only, and the
reduction-in-stages comparison with Woodward's clutching tails is missing.
*Citation-scope defect:* `\cite[Example~5.23]{WoodwardQKII}` is attached to the sentence about
`x(x+y)`, which the source does not contain. Move the citation to the presentation sentence.

*Woodward's `I`-function identification: partially confirmed.* Woodward QK III Example 9.15 does
exist and is titled "Localized gauged graph potential for toric quotients", and the surrounding
text describes the result as the generalization of Givental's `I`-function. The manuscript says
Woodward "identifies the localized gauged graph potential with Givental's `I`-function", which
is slightly stronger than "generalization of". I did not read the example's displayed formula.
Note also the paper's acknowledgement of "a missing circle-equivariant term in Example 9.15";
the manuscript pins v7, which presumably carries the correction, but a referee would want the
version note to say so.

*The Coates--Iritani--Jiang crepant-wall gauge carries the marked point row: CONFIRMED as to the
cited content and as to the computation.* I read Theorems 6.1 and 6.3 (arXiv:1410.0024). Theorem
6.3 states, verbatim: `∇_-` and `∇_+` are gauge-equivalent via `Θ`; `Θ` is homogeneous of degree
zero, `Gr_+∘Θ = Θ∘Gr_-` with `Gr_± = z∂_z + E_± + μ_±`; `Θ` preserves the orbifold Poincare
pairing in the form `(Θ(y,−z)α, Θ(y,z)β) = (α,β)` --- which is precisely the manuscript's flat
pairing convention; and "`Θ s(E)(τ_-(y),z) = s(FM(E))(τ_+(y),z)` for all `E ∈ K^0_T(X_-)`". The
manuscript's one-line computation
`r_{X_+,p'}(Θv) = [Θv, Θ s(O_p)) = [v, s(O_p)) = r_{X_-,p}(v)` is therefore valid, given that
`FM(O_p) = O_{p'}` for `p` in the common open --- which is right, since the kernel is the common
toric blow-up (CIJ §6.3) and the correspondence is an isomorphism near `p`.

Two caveats on the *stated limits*, which I judge understated:
- CIJ work with `Q` specialized to 1 (Theorem 6.1: "without Novikov variables, i.e. with `Q`
  specialized to 1"). `08-scope.tex` item (8) makes a point of the fact that the paper's own
  construction never evaluates a Novikov variable at a nonzero complex number. The calibration
  therefore lives in a setting the paper's own framework excludes. Worth one sentence.
- The manuscript says "After taking the non-equivariant specialization", which is needed because
  `O_p` for a non-fixed point is not an equivariant class. CIJ do discuss non-equivariant limits,
  but the passages I found assert it for `U` and `FM` (Theorem 6.1: "the symplectic
  transformation `U` has a well-defined non-equivariant limit, since the Fourier--Mukai
  transformation itself can be defined non-equivariantly") and for the equivariant quantum
  cohomology of the GIT quotients. The manuscript's computation uses `Θ` (Theorem 6.3). Either
  cite the place where `Θ`'s non-equivariant limit is established, or route the argument through
  `U` via Remark 6.4.
- More substantively, the second calibration paragraph lists only two limits (no inverse-system
  comparison for an arbitrary projective master; no reduced nearby-cycle assertion at a zero
  mode). The *same* frame-comparison gap flagged for the first calibration applies here and is
  not repeated: CIJ's `Θ` compares two chamber quantum connections along a path in the global
  Kahler moduli, not two boundary germs of Woodward clutching tails in a gauged affine
  direction in the fixed common input-and-derivative frame. Recommend repeating the caveat.
  Related: a crepant toric wall is the case the Section 4 ordinary-flop theorem already covers,
  so this calibration is evidence about the neutral non-zero-mode mechanism only, which the
  remark does say.

*UNVERIFIED:* the Iritani citation ("one global Landau--Ginzburg Brieskorn module whose chamber
completions are the toric quantum `D`-modules and, for weak-Fano toric blowups, identifies its
sectorial decomposition with the Gamma-framed ambient and residual `K`-groups",
`\cite[Theorems~1.3, 7.25, 7.31 and 7.33]{IritaniToricGlobal}`). I did not open
arXiv:1906.00801. This is a four-locator claim doing real work in the first calibration
paragraph and should be checked by someone.

### 7. `thm:birational-point-primary` and `lem:finite-threshold-gluing` --- CONFIRMED given the hypotheses, with one unaddressed technical point

Judged text: `08-global-transport.tex` lines 1063--1127, with `lem:cyclic-row-support`
(lines 991--1008).

*Does the conclusion follow?* Yes, and essentially immediately. `eq:marked-threshold-map` gives
an invertible `Φ_j` with `Φ_j T_j^- = T_j^+ Φ_j` and `Φ_j(r_j^-) = r_j^+`; polynomial functional
calculus then gives `Φ_j(r_j^- e_λ(T_j^-)) = r_j^+ e_λ(T_j^+)` as displayed, so the primary row
vanishes on one side iff on the other. At a zero-mode threshold the composite
`(sp^+)^{-1}∘Φ_j∘sp^-` is again an isomorphism intertwining formal monodromy, so the same
applies. Finitely many thresholds per Artin level gives a finite composite. The endpoint step is
`lem:cyclic-row-support`.

*Separatedness step.* Legitimate as a piece of logic. "Because the Artin inverse system is
separated, a projected row is nonzero exactly when it survives at some finite level" is the
correct reading of separatedness (`∩_N ker(M → M_N) = 0`), and combined with the level-wise
equivalence it gives both implications. The word "separated" is imported from the hypotheses
("compatible over the complete separated inverse system of Artin quotients"), so it is assumed
rather than proved --- which is consistent, since the endpoint modules are by construction
energy-completed. I see no illegitimate step here.

*One unaddressed technical point.* `lem:cyclic-row-support` is stated and proved for a finite
dimensional vector space over a field (Bezout projector onto a generalized eigenspace), but it
is applied to finite locally free modules over a local Artin coefficient algebra `R_N`, and the
Bezout/primary decomposition over `R_N` needs the characteristic polynomial to factor into
coprime factors there (Hensel over a local Artin ring with residue field `C` supplies this, but
it is not said). Likewise `e_λ(T)` must be compatible with the Artin reduction maps for the
level-wise Booleans to assemble. Both are believable; neither is argued. Optional repair: state
the lemma over `R_N` or add a sentence.

### 8. Introduction and scope --- MIXED

**8a. `01-introduction.tex` and `08-scope.tex`: accurate except for the conjecture claim.**
The conditionality is stated consistently and repeatedly: `thm:intro-cubic-conditional` and
`thm:intro-birational-conditional` both name gauged-admissibility and both hypotheses;
`rem:endpoint-only` correctly narrows the quantification and correctly explains why the
universal quantifier over maps cannot be dropped; the paragraph on the three standing
assumptions splits gauged-admissibility clause by clause and says plainly that "no existing
theorem supplies it for an arbitrary Wlodarczyk completion"; `08-scope.tex` item (7) says "No
instance is proved here for a general geometric threshold"; item (2) correctly refuses to claim
descendant invariance from Lee--Lin--Qu--Wang; item (4) correctly says the countermodels are
not asserted to arise from smooth projective quantum connections. The three-level description of
where Euler orthogonality recurs ("conditional on its sectorial hypothesis ... verified but
linear and toric ... conjectural") is an accurate self-assessment.
The one overstatement is the conjecture implication (R2). Two minor wording defects: "its
wall-frequency derivative" for what is multiplication by `λ` (line 190), and the
dimension-four/no-primitive-sixth-packet argument in lines 48--63, which rests on the companion
paper `RuddEpilogue` and which I did not verify (out of scope).

**8b. The rewritten abstract (`44f7ec0c2`): OVERSTATED in paragraphs 2 and 3.**
I re-read the current three-paragraph abstract. Paragraph 1 is accurate and names both
gauged-admissibility and the two hypotheses as granted. Paragraph 3 is good and unusually
frank ("Given those maps the transport is linear algebra"), except that it repeats the
conjecture-implies claim (R2). The defect is the pairing of paragraph 2's opening --- "The
endpoint contrast and the transport mechanism are unconditional" --- with paragraph 3's "What
is not proved is the comparison across thresholds". Read together they assert that
gauged-admissibility is proved, which contradicts `08-scope.tex` item (5) and the discussion
after `def:gauged-admissible`. See R4. I did not judge the endpoint/Cai claims in paragraph 2
(Section 9 is outside my scope).

---

## Optional repairs

1. Say `Φ = Ψ_+ ∘ FT_{X_-}^{-1}` in the proof of `thm:simple-wall-point-column`.
2. Add the p. 26 locator for the `a_p|_{F_0} = f(λ)` step in (G2), and note the `φ_2([p_+]) = [p_-]`
   step.
3. In Section 4, cite the standard facts that the ordinary-flop graph correspondence preserves
   cohomological degree and `c_1`, at `cor:ordinary-flop-packet` where they are used; and either
   drop "jointly flat" or prove the z-direction half.
4. Replace `C((z))` by `C[[z^{-1}]]`, or say "any coefficient ring containing `z^{-1}`", in
   Section 4.
5. In `prop:incomplete-gamma`, separate the monodromy of `Γ(1−α,x)` from the Stokes jump; the
   present sentence justifies the latter with the former.
6. State `lem:cyclic-row-support` over `R_N`, or add the Hensel/coprimality sentence.
7. Note that "Preservation of primary support is a consequence, not part of the hypotheses"
   is a consequence by one line of functional calculus, so that no reader mistakes it for a
   substantive weakening.
8. Repeat the common-frame caveat in the Coates--Iritani--Jiang paragraph, and note the `Q = 1`
   specialization.

## Coverage summary

| Item | Verdict | Basis |
|------|---------|-------|
| 1. `thm:simple-wall-point-column`, (G1)--(G4) | CONFIRMED subject to R1 | re-derived the induction; checked Gu--Yu--Yu Thm 6.2, Lem 3.27, Lem 5.8, Lem 5.10, Prop 5.2, Prop 5.9, Prop 4.14(2), Prop 4.21 and Cor 4.19 in the source |
| 2. `thm:ordinary-flop-point-row` | CONFIRMED, two wording defects | re-derived support vanishing, minimality, divisor axiom, invertibility; checked LLQW Thm 0.1.1 |
| 3. countermodels and Section 7 | CONFIRMED | recomputed every displayed identity in Sections 5--7 |
| 4. the two threshold hypotheses | CONFIRMED falsifiable and non-circular | close reading; caveat about their strength recorded |
| 5. `conj:gamma-window` + sketch | OVERSTATED, two gaps | close reading; gaps at nondegeneracy and monodromy stability |
| 6. `rem:verification-status` | MIXED; `Bl_pP^2` and CIJ CONFIRMED, Iritani UNVERIFIED | re-derived the toric example; read CIJ Thms 6.1/6.3 and Woodward QK II Ex. 5.23; did not open arXiv:1906.00801 |
| 7. `thm:birational-point-primary` + lemma | CONFIRMED given hypotheses; separatedness legitimate | close reading |
| 8a. introduction and scope | accurate except R2 | close reading against the body |
| 8b. rewritten abstract | OVERSTATED (paras 2--3) | re-read at `44f7ec0c2` |

Not reached, and left unjudged: the Iritani global-mirror locators; Section 9 and the Cai
endpoint; the derived appendix and the pre-`def:finite-dual-cyclic-rees` gauged-localization
machinery (taken as given per instructions); the dimension-four claim in the introduction that
rests on the companion paper.

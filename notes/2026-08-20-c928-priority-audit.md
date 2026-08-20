# C928 priority audit: integral middle cohomology of the cubic-threefold theta divisor

**Date:** 2026-08-20

**Verdict:** partial overlap, with a surviving integral theorem.  Kraemer
already proves the rational decomposition-theorem formula for the blow-up.
No checked source computes the integral lattice `IH^3(Theta,Z)`, its
extension by `H^3(X,Z)`, the mod-two glue, the index-`2^10` saturation, or
the rank-ten free escape lattice.  The general integral-Lefschetz framework
is now in the literature and must be cited as the nearest algebraic
predecessor; C928's exterior-algebra argument is presented as the elementary
degree-three specialization needed by the geometry, not as a new general
theory.

This audit supersedes the all-clear `NOT FOUND` language in
`notes/2026-08-12-c908-h3-lattice-priority-audit.md`.  That audit had only
abstract-level access to Kraemer and Artebani--Kloosterman--Pacini and no
full-text access to Beauville.

## Exact pre-emption

Kraemer's Corollary 6 states, for the blow-up
`pi: Theta-tilde -> Theta`, that

\[
R\pi_*\mathbf C_{\widetilde\Theta}[4]
 \simeq IC_\Theta\oplus
 \mathbf C_0[2]\oplus\mathbf C_0\oplus\mathbf C_0[-2].
\]

It also obtains Euler characteristics `81` for the resolution and `78` for
the intersection complex.  Therefore neither the rational skyscraper
decomposition nor the resulting rational Betti-number correction is a C928
novelty claim.

What survives is genuinely different: C928 works integrally in odd middle
degree and identifies

\[
IH^3(\Theta,\mathbf Z)\cong H^3(\widetilde\Theta,\mathbf Z)
\]

as a rank-130 lattice, including its nonsplit extension, its image in
`wedge^5 H^1(J,Z)`, and its free rank-ten quotient.  The decomposition theorem
does not supply these integral extension data.

## Full-text source audit

### Beauville 1982

- **Source:** Arnaud Beauville, *Les singularites du diviseur Theta de la
  jacobienne intermediaire de l'hypersurface cubique dans P4*, LNM 947
  (1982), pp. 190--208.
- **Access/version:** author-hosted PDF, cached 2026-08-20 as
  `BEAUVILLE:LNM947-theta-singularities`; 19 pages, 8,068 extracted words;
  SHA-256
  `4596f46edfdf9b69fd295581119faf814ad67a1e3d87592aa0146aaf225ea90a`.
- **Read depth:** full text.
- **Relevant content:** the theta divisor has a unique ordinary triple
  point, its tangent cone is the affine cone over the cubic threefold, the
  Fano difference map has degree six, and the blow-up/normalization geometry
  used in C928 is established.
- **Boundary:** no integral or rational cohomology computation of the
  blow-up, no intersection-cohomology lattice, and no exterior-lattice
  saturation statement.

### Kraemer 2016

- **Source:** Thomas Kraemer, *Cubic threefolds, Fano surfaces and the
  monodromy of the Gauss map*, Manuscripta Math. 149 (2016), arXiv:1501.00226.
- **Access/version:** arXiv PDF cached as `arXiv:1501.00226`; 10 pages, 5,273
  extracted words; SHA-256
  `bad27e7b9eee618e83259d392d706e0738756fa57cd33f021641c2f1b4fed9f6`.
- **Read depth:** full text.
- **Relevant content:** Corollary 6 gives exactly the rational/complex
  decomposition above; the paper uses it to compute `chi(IC_Theta)=78` and
  then the `E_6` Tannaka group.  Remark 7 also records characteristic-cycle
  multiplicity six at the singular point.
- **Boundary:** no integral cohomology, no integral extension or gluing map,
  and no image/escape lattice.

### Artebani--Kloosterman--Pacini 2004

- **Source:** Michela Artebani, Remke Kloosterman, Marco Pacini, *A new model
  for the theta divisor of the cubic threefold*, arXiv:math/0403245.
- **Access/version:** arXiv PDF cached as `arXiv:math/0403245`; 21 pages,
  15,597 extracted words; SHA-256
  `85b1dc5fa83f1d36f94e76aa8e32b07e7650b12177204f98aa8e569ade6024be`.
- **Read depth:** full text.
- **Relevant content:** a birational model of the quotient by `-1` via plane
  quartics with even theta characteristics; it reviews the degree-six
  Fano/double-six geometry.
- **Boundary:** no integral cohomology of `Theta` or its blow-up and no
  lattice calculation of the C928 type.

### Faulkner Valiente--Miller Eismeier 2025

- **Source:** Analisa Faulkner Valiente and Mike Miller Eismeier, *A
  Lefschetz decomposition over Z, and applications*, arXiv:2507.00844.
- **Access/version:** arXiv PDF cached as `arXiv:2507.00844`; 30 pages, 16,892
  extracted words; SHA-256
  `3a3ef5208198526fdfcdeaabc00abbae77650b2015bce5806cce92e3d8a0ac91`.
- **Read depth:** full text.
- **Relevant content:** Theorem 2.9 constructs an integral,
  `Sp(2g,Z)`-equivariant Lefschetz filtration on exterior powers; Corollary
  2.10 computes wedge and contraction on associated gradeds; Theorem 3.1
  computes central hard-Lefschetz cokernels.  The proof of Proposition 3.7
  also uses the pair-free decomposition of Lee--Packer.
- **Boundary:** it does not state the C928 off-central map
  `Theta wedge - : wedge^3 Lambda -> wedge^5 Lambda`, its degree-five
  saturation, or its cubic-threefold realization.  It nevertheless supplies
  the correct modern predecessor framework.  The paper should cite it before
  giving the short complete-graph incidence proof of the exact specialization.

## Sources inherited from the C908 audit

The earlier audit read Clemens--Griffiths (1972), the modern moduli-space
realization of the blow-up (Bayer et al.), the smooth-theta primitive
cohomology paper of Izadi--Tamas--Wang, and nearby cubic-threefold moduli
papers.  None contains the C928 integral lattice.  Their exact read depths
and cache data remain recorded in
`notes/2026-08-12-c908-h3-lattice-priority-audit.md`; they were not re-opened
for this delta audit.

## Bounded novelty extraction

The rational decomposition's pre-emption leaves three nearby candidates:

1. **Integral `IH^3` lattice (retained).**  Cheap test: search within all four
   full texts for integral cohomology, `H^3`, wedge-cube, saturation, and
   index terminology.  Result: no matching theorem; Kraemer's calculation is
   explicitly over `C` and records no extension data.
2. **Exact exterior-lattice saturation (retained as a lemma, not the paper's
   headline).**  Cheap test: compare the map and degrees against Theorem 3.1
   of Faulkner Valiente--Miller Eismeier.  Result: their displayed cokernel
   theorem is central (`wedge^{g-k} -> wedge^{g+k}`), whereas C928 needs the
   off-central `wedge^3 -> wedge^5` map at `g=5`.  Their filtration is the
   general context, so only the exact specialization and geometric use are
   claimed.
3. **Integral behavior outside degree three (not pursued).**  The link Gysin
   sequence contains a factor-three Euler map and may have torsion phenomena,
   but this is not needed for the current theorem and has not passed a source
   or proof audit.

Kraemer's future-work direction concerns Gauss-map monodromy and Weyl groups;
Faulkner Valiente--Miller Eismeier ask about analogous cokernels for general
integral Kahler manifolds.  Neither is a cleaner C928 deliverable than the
integral `IH^3` lattice already proved, so no new task ID is opened.

## Coverage and confidence

- **Primary full texts opened in this delta audit:** four.
- **Search coverage:** exact-title/author searches, the prior C908 keyword
  audit, and full-text term sweeps of the four sources above.
- **Not covered:** MathSciNet and zbMATH citation graphs; Google Scholar was
  not used.  No exhaustive forward-citation closure is claimed.
- **Calibrated conclusion:** `PARTIAL OVERLAP / SURVIVING INTEGRAL RESULT`,
  not an absolute priority claim.  The rational corollary is prior art; the
  checked corpus contains no integral middle-lattice theorem matching C928.

## Paper-facing claim boundary

The abstract and introduction may claim an integral computation of
`IH^3(Theta,Z)` and of the image/escape lattices.  They must cite Kraemer for
the rational decomposition and Faulkner Valiente--Miller Eismeier for the
integral Lefschetz framework.  They must not claim the first computation of
rational intersection cohomology, a new general integral Lefschetz
decomposition, or an exhaustive literature priority result.

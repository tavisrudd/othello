# C519 literature delta — universal residual discriminant

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Verdict:** no priority claim made

## Opening summary

This delta positions the obstruction theorem proved in C519.  It does not assert that the binary
cubic discriminant, its twisted-cubic geometry, or its modular reductions are new.  It asks only
whether the existing PRS source spine already supplies the characteristic-two
Artin--Schreier replacement needed to continue the arbitrary-redundancy argument.

**Full-text count:** five coding/splitting sources are reused at full-text depth from the
C512/C516 audits: Zhang--Wan--Kaipa, Kaipa, Wu--Ding--Chen, Xu, and Wang.  Ball--Lavrauw is also
read at full-text depth from the shared cache for the normal-rational-curve background.  The fresh
binary-cubic search results below were inspected at abstract/metadata depth only.  No read depth is
inferred from cache presence.

**Verdict.** The classical sources support the characteristic-zero discriminant and twisted-cubic
language, often while explicitly excluding characteristics two and three.  The reused coding
sources do not provide C519's residual four-contraction pullback or the required
characteristic-two Artin--Schreier root-compatible classification.  Because C519 stops at that
obstruction and makes no absence-based novelty claim, this is a positioning delta rather than a
NOT-PRE-EMPTED verdict.

## Reused pinned coverage

- Zhang--Wan--Kaipa, `arXiv:1901.05445`, DOI `10.1109/TIT.2019.2940962` —
  **read depth: full text**, reused from C491/C498.
- Kaipa, `arXiv:1612.05447`, DOI `10.1109/TIT.2017.2706677` —
  **read depth: full text**, reused from C491/C498.
- Wu--Ding--Chen, `arXiv:2312.05534` — **read depth: full text**, reused from C498.
- Xu, DOI `10.1051/wujns/2023281015` — **read depth: full text**, reused from C498.
- Tianhao Wang, *Splitting of Polynomial Families via Galois Theory*,
  `arXiv:2606.12810v1` — **read depth: full text**, all sections, reused from C512; cache key
  `arXiv:2606.12810`, SHA-256
  `5dd4e19544335ebc2c75a184074e94adb91b78331930b5e8a643ae606021a107`.
- Simeon Ball and Michel Lavrauw, *Arcs in finite projective spaces*,
  `arXiv:1908.10772` — **read depth: full text**, especially Section 3 on normal rational curves;
  cache key `arXiv:1908.10772`, SHA-256
  `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.
- Gmainer--Havlicek, *Nuclei of Normal Rational Curves*, `arXiv:1304.0088` —
  **read depth: partial**, abstract and Theorem 1, reused from C498/C512; cache SHA-256
  `da688c01e3953319ef93f17e1676fedf0470c590a0a348a853dabb11209526d0`.

The C516 audit already places `PRS(q-8)` inside the three-graph coding screen owned by C498.
C519 introduces no new coding-family classification, so those forward trees were not rerun one
day later.

## Fresh object search

The exact web-index queries run on 2026-07-23 were:

```text
site:arxiv.org binary cubic discriminant characteristic 2 tangent developable twisted cubic
site:projecteuclid.org binary cubic invariant characteristic two discriminant
site:cambridge.org modular invariant theory binary cubic characteristic 2 discriminant
```

The closest results were:

- Peter J. Olver, *Classical Invariant Theory*, Chapter 2, DOI
  `10.1017/CBO9780511623660.003` — **read depth: abstract/metadata only**.  The metadata describes
  the standard cubic/quartic invariant and discriminant treatment; it does not license a statement
  about divided powers in characteristics two or three.
- P. E. Newstead, *Invariants of pencils of binary cubics* —
  **read depth: abstract/metadata only**, Cambridge Core.  Its displayed scope assumes an
  algebraically closed field of characteristic different from two and three, so it is not a source
  for the modular pullback.
- Marcus Slupinski and Robert J. Stanton, *The special symplectic structure of binary cubics*,
  `arXiv:0906.4309` — **read depth: abstract/metadata only**.  Its abstract likewise assumes
  characteristic different from two and three.
- A recent complex-representation treatment, *Cohomological integrality for weakly symmetric
  representations of reductive groups* — **read depth: abstract/metadata only**, Cambridge Core.
  The searchable text displays the same divided-coefficient cubic invariant over
  \(\mathbf C\); it is background for the formula, not the modular scheme.

No promoted source was characterized beyond what its accessible metadata stated.  The search also
returned arithmetic papers on integral binary cubics and cubic congruences; they were discarded at
metadata depth because they do not concern modular divided-power discriminant schemes or PRS
Hankel pullbacks.

## Attribution and coverage

The report attributes no originality to:

- the integral cubic-discriminant formula;
- the twisted cubic and its tangent developable;
- the characteristic-two Kummer/Artin--Schreier distinction;
- normal-rational-curve nuclei; or
- the frozen C491/C498/C509/C513/C516 carrier theorems.

Its evidence-backed internal claim is narrower: applying the integral residual formula to the
four-contraction map makes every characteristic-two pullback a square, and explicit calibration
witnesses show this is larger than the frozen PRS carrier union.

Coverage:

- **Pinned PRS coding forward trees:** reused from C498/C516.
- **Splitting-family framework:** reused from C512.
- **Fresh binary-cubic object search:** covered by the three verbatim queries above at
  abstract/metadata depth.
- **zbMATH Open:** not refreshed because no absence-based novelty verdict is made.
- **MathSciNet:** NOT COVERED because institutional authentication is unavailable.
- **Google Scholar:** not used because automated access is blocked.

Any future paper-facing claim that the characteristic-two Artin--Schreier carrier classification
is new will require a new audit after that classification exists.  C519 does not make that claim.

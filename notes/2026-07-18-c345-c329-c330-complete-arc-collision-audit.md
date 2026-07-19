# C345: C329/C330 complete-arc collision audit

**Lane:** `crowns`

**Date:** 2026-07-18

**Verdict:** `NARROW-EXACT-COUNT`

## Signed decision

C329 and C330 are internally consistent and do not contradict Bastioni--Micheli,
Bartoli--Micheli, or Korchmaros--Nagy--Szonyi. The apparent collision came from reading “a curve
can produce a complete `m`-arc” as “the curve points are already complete.” The cited theorems
instead begin with the full rational point set of an irreducible degree-`m` curve and, in the
general programme, explicitly add exceptional points. C329 is a selected `2Q+Q+Q` subset of three
members of a reducible conic pencil in characteristic two and proves only that it is a `2`-arc.
C330's failure of completeness is therefore permitted, not contradictory.

The broad “new obstruction type” and “sharp counterexample to the generic complete-arc theorem”
headlines stop. The surviving claim is narrower and exact: within the four constant-height
`F`-carrier architecture, all finite secant directions are the union of seven explicit reciprocal
images, so at most `7Q-2` of the `Q^2` required infinity directions are covered and at least
`Q^2-7Q+2` are not. Korchmaros--Nagy--Szonyi already establish the general phenomenon that holes of
a curve-derived `(k,n)`-arc can localize in a proper subgeometry; C330 contributes a different
architecture, an exact line-at-infinity locus, and a quantitative count.

This verdict releases the C329/C330 consistency gate for C336, C337, C340, C347, and C348, subject
to each task's own theorem and novelty gates.

## Condition-by-condition comparison: Bastioni--Micheli

The pinned full text is arXiv:2303.13670v1, SHA-256
`f5eb03dab26f3cc701d9917db70d85409629174fc5ac279c59bbca1505517c40`.

| condition actually used | Bastioni--Micheli | C329 analogue | consequence |
|---|---|---|---|
| basic object | A planar irreducible projective curve `C/F_q` of degree `m`; Theorem 4.1 starts from all of `C(F_q)`. | `A` is four selected `F`-coset layers in `PG(2,E)`, lying on three conics; it is not the full rational locus of one irreducible curve. | Hypothesis fails at the object level. |
| arc parameter | The maximum allowed collinearity is the same `m` as `deg C`; the main generic theory is stated for `m>=3`. | C329 is a `2`-arc, while the reducible carrier union has degree six. | Degree/arc-parameter identification fails. |
| singularities | Theorem 4.1 permits singularities only on the line at infinity. | The reduced carrier union has pairwise intersection at `[0:0:1]`, but is reducible; treating this as one curve does not restore irreducibility. | No transfer of the theorem. |
| Gauss map | `C` must be birational to its dual through the Gauss map. This bounds affine bitangents and is generic only away from characteristic two (Remark 3.4). | A reducible pencil union has no single birational Gauss map of the required kind; the ambient characteristic is two. | Genericity hypothesis fails twice. |
| tangent ramification | Away from the finitely many bitangent and inflection tangents, each projection has ramification index at most two at one place, forcing symmetric monodromy. | C329's four collision maps have degrees `2,2,5,5` on the coincidence slice and are controlled by trace gates plus an `S5 x S5` compositum, not one degree-`m` projection. | The Galois covers are different, despite a shared Chebotarev motif. |
| characteristic/inflections | The sharp `O(m^5)` form assumes `p>m`. Theorem 4.5 relaxes this only by adding `mT` points for all inflection tangents. | `p=m=2`; there is no imported bound on the inflection set of the reducible carrier union. | Neither version applies. |
| field-size gate | `q>c(m)` makes the relevant degree-`m` projection split for every nonexceptional external point. | `Q>=2^45` makes four collision fibers nonsplit for one fresh skeleton over `E=GF(Q^2)`. | The quantifiers and desired splitting behaviour are opposite. |
| conclusion | There exists an exceptional set `S`, `|S|=O(m^5)` or `mT+O(m^5)`, such that `C(F_q) union S` is complete. The proof separately adds points on exceptional tangents and the line at infinity. | C329 adds no completion set and C330 proves that its selected arc is incomplete. | Even a hypothetical applicable theorem would not say the unaugmented set is complete. |
| Artin--Schreier application | Theorem 5.5 assumes odd characteristic, `m>p`, squarefree `f`, `f != z^p-z`, and `f' notin F_q[x^p]`. | C329 is characteristic two and its collision covers, not its carrier union, are Artin--Schreier trace covers. | The named application is not a specialization of C329. |

## Condition-by-condition comparison: Bartoli--Micheli

The pinned full text is arXiv:2007.00911v1, SHA-256
`9260cc30ea6400f559c5ec74710cea2b2695ce6885e825318e171ed0e4e77384`.

| condition actually used | Bartoli--Micheli | C329 analogue | consequence |
|---|---|---|---|
| construction input | Full rational points of an irreducible degree-`m` curve, followed by a small exceptional set on bad projection lines. | A selected subset of a reducible three-conic carrier. | No object-level match. |
| general examples | The rational model `y=x^m` assumes `p` does not divide `m(m-1)`; the higher-genus models use odd characteristic, squarefree `g`, a prime `r`, and explicit divisibility exclusions. | `p=2`, arc parameter two, and constant-height conic layers. | Every displayed construction family differs. |
| monodromy/projection | For an external point, the degree-`m` line projection must have geometric and arithmetic group `S_m`; Chebotarev supplies a totally split `m`-secant. | C329 requires absence of rational points in four collision fibers so that no third point appears on a secant. | Same tool family, opposite incidence goal. |
| completion step | Their `Gamma` is placed on a controlled union of exceptional lines; completeness belongs to the augmented set. | C330 studies the unaugmented four-layer set and finds an entire infinity carrier of holes. | No contradiction. |
| headline range | The explicit asymptotic constructions target fixed `m>=8` (all but finitely many `m` in Theorem 5.3); the paper's introduction treats `m=2` as a separate mature theory and cites `O(q^(3/4))` explicit complete arcs. | C329 has `m=2`, size `4 sqrt(q)`, and is explicitly incomplete. | It neither improves nor conflicts with their complete-`m`-arc size results. |

## Condition-by-condition comparison: Korchmaros--Nagy--Szonyi

The pinned full text is arXiv:2302.10162v1, SHA-256
`32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`.

| condition actually used | Korchmaros--Nagy--Szonyi | C329/C330 analogue | consequence |
|---|---|---|---|
| candidate point set | Full rational point set `Omega(C)` of an absolutely irreducible degree-`n` curve with no linear component and a transversal `n`-secant. | Selected points on a reducible conic pencil; `n=2`. | Their completeness criterion does not apply. |
| concrete curves | Hermitian and rational BKS curves of degree `q+1`; the important secants are `(q+1)`-secants. | Three conics and ordinary secants. | Neither concrete family specializes to C329. |
| extension range | Hermitian curve in `PG(2,q^(2r))`; BKS curve in `PG(2,q^r)` with `q` odd and stated restrictions on `r`. | Quadratic extension `E/F` in characteristic two. | Base characteristic and extension exponent differ. |
| splitting group | Projection closures have `PGL(2,q)` monodromy; Hasse--Weil produces transversal `(q+1)`-secants. | C329 uses additive trace covers and `S5 x S5` for forbidden triple fibers. | No shared load-bearing hypothesis. |
| localized holes | For the rational BKS curve and odd `r`, Theorem 7.5 identifies the uncovered points exactly as `PG(2,q)\Omega`; adding them completes the arc. | C330 identifies `U_infinity={ [0:1:m] : m notin D_fin(A) }`, of size at least `Q^2-7Q+2`. | Localization in a proper subgeometry is prior phenomenon; the exact line locus and count are distinct. |
| small `n=2` boundary | The introduction explicitly separates `n=2`, cites the established theory, and notes the best explicit small complete arcs then known have size `O(q^(3/4))`. | C329 supplies a structured `4sqrt(q)` incomplete arc. | No complete-arc record or sharpness conclusion follows. |

## Independent C329/C330 replay

The adjacent pure-Python checker constructs canonical polynomial-basis models of
`GF(64)/GF(8)` and `GF(1024)/GF(32)`. These are representative odd-tower architectures, not claimed
to meet C329's enormous nonconstructive `Q>=2^45` witness threshold.

For both `Delta_R=0` and a nonzero representative `Delta_R`, the checker independently:

1. enumerates every unordered pair of the four layers and computes its projective direction from
   the point coordinates;
2. constructs the seven reciprocal images from C330's displayed formula by a separate code path;
3. requires exact set equality, checks `|D_fin|<=7Q-2`, and emits the first explicit missing `m`;
4. evaluates all `2Q^2` repair--repair--seed parameter pairs on the coincidence slice and compares
   the direct determinant with `q(Gamma+z^2+qz)`; and
5. evaluates all `2Q^2` seed--seed--repair parameter pairs, including the `p=0` deletion, and
   compares determinant vanishing with the reciprocal collision map.

The exact results are:

| `Q` | `Delta_R` type | exact `|D_fin|` | `7Q-2` | uncovered finite directions |
|---:|---|---:|---:|---:|
| 8 | coincidence | 40 | 54 | 24 |
| 8 | nonzero | 37 | 54 | 27 |
| 32 | coincidence | 197 | 222 | 827 |
| 32 | nonzero | 209 | 222 | 815 |

The first missing direction is `m=0` in all four canonical fixtures. Across 4,352 collision-map
cases there are zero determinant/identity mismatches and zero forbidden `p=0` collisions. The
support audit has exactly 20 layer multisets: C312--C315 own the 16 one- and two-layer types, and
C316--C329's four finite maps own the four three-distinct-layer types. Thus C329's logical
no-three-collinear interface is exhaustive. The computation deliberately does not manufacture an
explicit large-field C329 arc: its existence remains C329's proof-only Chebotarev theorem.

Regenerate from `/home/tavis/src/othello` with

    python3 notes/2026-07-18-c345-c329-c330-complete-arc-collision-audit.py \
      --output notes/2026-07-18-c345-c329-c330-complete-arc-collision-audit.json

and replay the canonical output and hashes with

    python3 notes/2026-07-18-c345-c329-c330-complete-arc-collision-audit.py --check

The script is 10,147 bytes, SHA-256
`8a0ab1d674beba9f9448e7c8e5cab998569cad915869721cf5a76b0eac01745c`; the canonical JSON is
3,005 bytes, SHA-256 `d7433bdd3dcfacd9989a409c11809fe1f95f46f3d208b4a92bfb2abc57c7afc6`.
The direct point-pair enumeration and the seven-image construction are independent internal
implementations; likewise, determinant evaluation is independent of the reduced collision maps.

## Forward-citation and correction closure

- Bastioni--Micheli is published as *J. Algebra* 638 (2024), 238--254,
  DOI `10.1016/j.jalgebra.2023.09.027`. The publisher lists two citing papers. The on-topic forward
  paper located is Bartoli--Korchmaros--Timpanella, *Complete `(k,q+1)`-arcs in
  `PG(2,F_(q^6))` from the Hermitian curve*, *J. Algebraic Combin.* (2025),
  DOI `10.1007/s10801-025-01456-w`; it remains in the irreducible-curve/large-secant regime.
- Bartoli--Micheli is published in *Combinatorica* 42 (2022), 673--700,
  DOI `10.1007/s00493-021-4712-5`. The 2023--2025 forward thread found above cites and extends its
  curve-projection method, not the C330 carrier architecture.
- Korchmaros--Nagy--Szonyi is published in *JCTA* 204 (2024), 105851,
  DOI `10.1016/j.jcta.2023.105851`. The journal version and zbMATH author record agree with the
  theorem statements used here. No correction or erratum was located for any of the three papers.
- Exact-title, DOI, forward-citation, and zbMATH searches were run on 2026-07-18. A public
  MathSciNet result page exposing forward references was not available, so this is not represented
  as subscription-database exhaustiveness. That limitation does not affect the consistency verdict,
  which follows from the primary theorem hypotheses themselves.

An initial unrestricted display of the external leverage scan produced 10,548 tokens and was
discarded as a command-shaping failure. Every load-bearing literature statement above was instead
rechecked against the three pinned full texts and bounded primary-source searches.

## Claim language after C345

Use:

> The C329 construction is a structured incomplete `2`-arc on a reducible three-conic carrier.
> Its finite secant directions admit seven exact reciprocal images, leaving at least
> `Q^2-7Q+2` explicitly localized holes at infinity. This is compatible with the curve-derived
> complete-`m`-arc programme because its irreducibility, full-rational-locus, Gauss-map, and
> augmentation hypotheses do not hold here.

Do not use “counterexample to Bastioni--Micheli,” “new phenomenon that curve-derived arc holes
localize,” or “complete arc of size `4sqrt(q)`.”

## Vibe check

Decisive and healthy. The feared contradiction is absent for elementary hypothesis reasons, and
the independent replay confirms the exact geometry. The price is rhetorical, not mathematical:
C330 is a sharp architecture-specific count rather than a new generic obstruction paradigm.

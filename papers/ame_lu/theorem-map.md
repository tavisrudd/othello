# Theorem adoption map

This map controls which source results may appear as manuscript theorems.
“Adopted” means mathematically available for drafting; publication readiness
still depends on the claim, evidence, literature, and prose gates.

| Source | Candidate manuscript result | Status | Exact boundary | Evidence type |
|---|---|---|---|---|
| C374 | Clebsch `AME(6,11)` is LC- and LU-inequivalent to every six-point GRS AME class | adopted | `q=11`, arbitrary party permutation | conceptual dictionary plus exact LC and marginal-moment certificates |
| C396 | `z` classifies projective and monomial-code classes in the admitted non-GRS pencil; over odd prime fields it also classifies LC classes | adopted with C571 correction | classical quotient over every odd finite field; quantum LC statement only over odd prime fields because Frobenius is an additional extension-field Clifford | symbolic invariant theory plus exact finite checks |
| C397 | logical-Clifford phase and exact `q=13` arbitrary-LU separation | adopted, to split into two manuscript results | fixed-party kernel theorem over odd prime fields; party-moving normalizer only when an isoduality is present; explicit `q=13` collision pair | conceptual kernel proof plus exact four-copy contractions |
| C402 | one marginal moment uniformly separates every good non-GRS H3 reduction from the GRS locus | adopted | every odd good non-GRS H3 reduction | geometric concurrency formula and exact permutation lemma |
| C546 | H3 pentad orientation is uniformly LC-forgettable | adopted as boundary/remark | every odd reduction in its stated domain | explicit integral isoduality and local Fourier lift |
| C548 | rank-drop scheme is `(z-2)(9z-4)=0` | adopted after paper-local evidence import | admitted pencil with stated exceptional characteristics | exact symbolic computation and group-orbit certificates |
| C550 | transport sheaf derives the divisor and multiplicities | adopted | exact domain and corrections stated in C550 | cycle-cover algebra and double-coset geometry |
| C559 | every fixed-copy LU contraction is generically constant on each irreducible component of an algebraic equal-phase code family | adopted as a mechanism boundary | regular constant-dimension generator chart; every fixed copy degree; stable diagram basis when local dimension is at least the copy degree | direct contraction-rank and generic-minor proof |
| C560/C609 | every LU intertwiner between equal-phase CSS states of linear `[2m,m,m+1]_q` MDS codes is LC; the associated `[[2m-1,1,m]]_q` code has no transversal non-Clifford logical unitary; hence `LU iff LC iff z` on the admitted six-party pencil | adopted version-1 headline package | every prime power and \(m\geq2\) whenever the MDS code exists; C396's odd admitted domain for the `z` classification | MDS shortening plus diagonal Weyl-correlation tensor rigidity; Choi correspondence for the transversal corollary |

## Stable source labels

- `thm:dictionary`: six-arc/MDS/CSS/AME dictionary.
- `thm:lc-pencil`: LC classification by `z`.
- `thm:lu-h3-grs`: uniform H3/GRS LU separation.
- `thm:logical-phase`: split-torus versus `SL_2(q)` logical phase.
- `thm:q13-lu`: exact four-copy `q=13` separator.
- `thm:transport-divisor`: transport-sheaf divisor and multiplicities.
- `thm:fixed-copy-boundary`: generic constancy of fixed-copy contractions.
- `thm:lu-lc-rigidity`: all-MDS/CSS LU-intertwiner rigidity.
- `cor:transversal-clifford`: transversal non-Clifford no-go for the associated quantum MDS code.
- `cor:lu-lc-pencil`: `LU iff LC iff z` on the admitted odd pencil.

## Frozen theorem hierarchy

1. **Headline package (`thm:lu-lc-rigidity`,
   `cor:transversal-clifford`).** For every prime power `q`, every
   `m≥2`, and every pair of linear `[2m,m,m+1]_q` MDS codes, every LU
   intertwiner of the associated equal-phase CSS states is LC.  The
   associated `[[2m-1,1,m]]_q` quantum MDS code therefore admits no
   transversal non-Clifford logical unitary.
2. **Classification corollary (`cor:lu-lc-pencil`).** On C396's admitted
   odd-prime-field non-GRS pencil, projective, monomial-code, LC, and LU
   equivalence are all equivalent to equality of `z`. Over extension
   fields, Frobenius already identifies unequal `z` values.
3. **Operational phase theorem (`thm:logical-phase`).** The fixed-party
   logical group is `SL_2(q)` on the GRS locus and the split torus off it,
   over odd prime fields.  A party-moving isoduality, when
   present, extends the torus to its normalizer.
4. **Explicit LU witnesses.** C402's marginal moment uniformly separates
   good H3 reductions from GRS; C397's four-copy scalar resolves its q=13
   collision.
5. **Mechanism boundary.** C559 proves generic constancy of fixed-copy
   scalar contractions; C548/C550 identify and explain the exceptional
   divisor of one useful four-copy certificate.

## Frozen boundary table

| Result | Field/domain | Included exceptions | Excluded boundary |
|---|---|---|---|
| LU-intertwiner rigidity and transversal no-go | every prime power `q`, every `m≥2`, and every existing linear `[2m,m,m+1]_q` MDS/CSS state; associated `[[2m-1,1,m]]_q` encoder for the corollary | none | nonlinear orthogonal arrays, non-MDS/non-CSS AME tensors, and transversal gates of other quantum-code families |
| Pencil classification by `z` | projective/monomial over odd finite fields; LC/LU only over odd prime fields on the admitted non-GRS locus | Frobenius covariance over extension fields is explicit but not classified | zeros of `2t(t-1)BG`, the GRS boundary, and full extension-field Clifford classification |
| Logical-Clifford phase | odd-prime-field six-arcs | characteristic-17/31 symmetry jumps retain the phase | characteristic two, extension-field full Clifford kernels, and non-stabilizer AME tensors |
| Uniform H3/GRS LU separator | odd good non-GRS H3 reductions | characteristic five is the proved GRS transition | bad or GRS reductions |
| q=13 four-copy separator | the two exact q=13 classes in C397's collision bucket | exact party orbit included | no completeness claim beyond the pair |
| Four-copy divisor | C548's admitted pencil | characteristic seven merges the two reduced components; 11/13/41 are ramification phenomena | characteristics 3/5 are boundary coincidences |
| Fixed-copy generic constancy | each irreducible component of a regular constant-dimension generator chart; every fixed copy number; stable diagram basis for `q` at least that number | rank-jump strata remain detectable; the dense open need not have a point over a small base field | no growing-with-`q` degree bound |

## Deliberate exclusions

- No global LU--LC conjecture.
- No classification of arbitrary minimal-support AME tensors.
- No claim that `z=2,4/9` are LU-orbit exceptions.
- No claim that four copies are a globally minimal invariant degree.
- No new holographic-code construction or tensor-network performance claim.
- No novelty wording before C562 closes the claim-specific audit.

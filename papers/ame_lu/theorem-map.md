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
| C560/C609 | every LU intertwiner between equal-phase CSS states of linear `[2m,m,m+1]_q` MDS codes is LC; the associated `[[2m-1,1,m]]_q` code has no transversal non-Clifford logical unitary; hence `LU iff LC iff z` on the admitted six-party pencil | adopted as a specialization of C649 | every prime power and \(m\geq2\) whenever the MDS code exists; C396's odd admitted domain for the `z` classification | MDS shortening gives an explicit realization of C649's supported-label bijection; Choi correspondence for the transversal corollary |
| C649 | every LU intertwiner between arbitrary additive stabilizer `AME(2m,q)` states is factorwise Clifford; every associated stabilizer-QMDS encoder conversion is Clifford on all physical and logical factors | adopted headline package | every prime power `q=p^e` and every `m≥2`; standard additive Weyl system; the Bell-pair boundary `m=1` is excluded sharply | AME no-small-support condition, supported-label cardinality squeeze, full-Weyl diagonal-axis recovery, and Choi correspondence |
| C614 | transversal conversions between any two associated encoders are Clifford factor by factor; product-unitary automorphisms are projectively finite; the odd-prime even-length GRS tower has exact projective transversal logical group `F_q^2 ⋊ SL_2(q)` | adopted higher-\(m\) application package | conversion and finiteness for every prime power and existing `[2m,m,m+1]` code; exact GRS group for odd prime `q` and `2m≤q+1` | Choi correspondence, finiteness of the projective Clifford group, and explicit GRS dual-multiplier unipotents |
| C622 | the exact odd-prime fixed-party projective transversal group is `F_q^2 ⋊ SL_2(q)` exactly for diagonally isodual `[2m,m,m+1]_q` MDS codes and `F_q^2 ⋊ T` otherwise | adopted intrinsic phase boundary | every odd prime `q`, every `m≥2`, and every existing linear `[2m,m,m+1]_q` MDS code | arbitrary-length diagonal-multiplier lemma, block converse, complete logical-Pauli fiber, and duality-shear propagation |
| C631 | the diagonal multiplier space between two exact half-dimensional MDS codes has dimension at most one; the code-to-dual space gives an exact nullity test and a unique projective witness | adopted as the intrinsic coding-theoretic phase test | every finite field and exact linear `[2m,m,m+1]` MDS pair; Clifford-group consequence remains odd-prime | full-support shortening argument and kernel-checked multiplier-space, reconstruction, uniqueness, and ratio theorems |
| C619 | the GRS propagation maps satisfy the `SL_2(q)` relations exactly; over odd fields the Weil lift splits the scalar extension on the linear factor, while the full affine one-qudit extension is non-split by the Weyl commutator | adopted lift-boundary audit | odd prime `q`, generalized and extended GRS tower; no claim about splitting the realized party-permutation extension | explicit conjugation formula, finite-field Heisenberg--Weil representation, and the nontrivial Pauli commutator |
| C624/C629 | the realized party-permutation extensions split in twelve concrete pencil, GRS, enhanced-symmetry, and \(H_3\) rows; on every listed non-GRS/\(H_3\) row, odd party motion inverts `T` and gives `N(T)` | adopted as a computed structural corollary | exactly the twelve rows listed in `cor:computed-party-splitting`; \(N(T)/T\cong C_2\), but the determinant-one Weyl lift has \(J^2=-I\), so the linear torus-normalizer extension is not asserted to split; no all-good-reduction or arbitrary-six-arc splitting claim | exhaustive exact local-symplectic enumeration, normalized factor sets, explicit party-extension complements and cochains; abstract splitting consequences and the separate \(J\)-matrix relations kernel checked, concrete complements certificate checked |
| Clebsch-rigidity/C731 | the Clebsch equal-phase AME state has 120 covering-radius \(X\)-syndromes on twelve conic rays, exactly one minimum representative on each three-party support, and one \(C_{10}\times A_5\) monomial orbit, while its nonconic defining arc forces the fixed-party split-torus phase | adopted as a worked example after referee red team | \(q=11\); generalized-\(X\) sector only; projective syndrome coordinates; \(A_5\) is the monomial quotient rather than the full party-moving image; no arbitrary weight-three correction, Hamiltonian, or Golden-operator claim | direct coset-state/stabilizer-syndrome proof, cited Clebsch deep-hole theorem, and composition with `thm:logical-phase`; no new computation |
| C633 | each field-automorphism exponent has exact diagonal and Gale divisors; the explicit Gale multiplier, same-exponent sector disjointness, and automorphism equivariance of `G,A,B,z` hold on the admitted non-GRS pencil | adopted scalar extension-field structure | every odd finite field and every field automorphism; no full additive-Clifford orbit classification | unconditional ring and field algebra in `ExtensionFieldPencil`; the two representation-theoretic bridges needed for the orbit theorem remain named hypotheses |

## Stable source labels

- `thm:dictionary`: six-arc/MDS/CSS/AME dictionary.
- `thm:lc-pencil`: LC classification by `z`.
- `thm:lu-h3-grs`: uniform H3/GRS LU separation.
- `thm:logical-phase`: split-torus versus `SL_2(q)` logical phase.
- `prop:clebsch-x-syndrome`: Clebsch covering-radius \(X\)-syndrome conic and nonconic fixed-party phase.
- `rem:clebsch-x-syndrome-boundary`: fixed-party, \(X\)-only, projective-coordinate, and monomial-versus-party boundaries.
- `lem:six-arc-self-association`: fixed-label diagonal isoduality iff the six-arc lies on a conic.
- `thm:q13-lu`: exact four-copy `q=13` separator.
- `thm:transport-divisor`: transport-sheaf divisor and multiplicities.
- `thm:fixed-copy-boundary`: generic constancy of fixed-copy contractions.
- `thm:lu-lc-rigidity`: arbitrary-additive stabilizer-AME LU-intertwiner rigidity.
- `lem:pauli-phase-correction`: product-Pauli correction of a Clifford lift
  that carries one stabilizer Lagrangian to another.
- `prop:stabilizer-ame-support`: exact \(q^2\) supported-label group and bijective local projections on every half-plus-one marginal.
- `prop:full-weyl-marginal` and `cor:full-weyl-cover`: reusable full-Weyl marginal and cover criteria forcing every local intertwiner to be Clifford.
- `cor:transversal-clifford`: transversal non-Clifford no-go for the associated quantum MDS code.
- `cor:discrete-lu-symmetry`: continuous closed scalar-torus short exact sequences, a closed Hausdorff discrete intrinsic Clifford quotient, finite scalar-torus component covers, finite discrete fixed-party and party-permuted quotients, and the exact extension through the realized party-permutation subgroup.  `AutomorphismExactSequence` supplies the exact sequence.  `NonabelianExtensionInvariant` supplies its section-free outer action, normalized factor set, nonabelian associativity and change-of-section laws, and the equivalence between factor-set trivializability and a homomorphic splitting.  The principal new terminals are `genericPartyPermutationOuterAction`, `genericPartyPermutationFactorSet_associativity`, `genericPartyPermutationFactorSet_change`, and `genericPartyPermutationFactorSet_trivializable_iff_splits`.
- `prop:diagonal-multiplier-line`: field-generic full support, one-dimensionality, scalar self-multiplier, exact code-to-dual nullity test, and canonical projective witness.
- `prop:frobenius-sector-divisors`: exact diagonal and Gale divisors, explicit Gale multiplier, same-exponent disjointness, and field-automorphism equivariance on the admitted non-GRS pencil.
- `cor:diagonal-isodual-transversal-group`: exact `F_q^2 ⋊ SL_2(q)` versus `F_q^2 ⋊ T` fixed-party transversal dichotomy for odd-prime half-dimensional MDS codes, with a coherent Weil lift on the isodual branch's linear `SL_2(q)` factor and a Heisenberg obstruction to splitting its full affine one-qudit scalar extension.
- `cor:computed-party-splitting`: exact splitting and parity action for the twelve C624 party-permutation examples; C629 formalizes the consequences of a supplied complement, while the concrete complements remain certificate checked.
- `cor:six-arc-fixed-party-group`: exact projective fixed-party logical group `F_q^2 ⋊ SL_2(q)` on the GRS six-arc locus and `F_q^2 ⋊ T` off it.
- `cor:lu-lc-pencil`: `LU iff LC iff z` on the admitted odd pencil.

## Frozen theorem hierarchy

1. **Headline package (`thm:lu-lc-rigidity`,
   `cor:transversal-clifford`).** For every prime power `q`, every
   `m≥2`, and every pair of additive stabilizer `AME(2m,q)` states, every
   LU intertwiner is LC.  Every tensor-product conversion between the
   associated stabilizer `[[2m-1,1,m]]_q` quantum-MDS encoders is
   Clifford on every physical and logical factor.
2. **Higher-\(m\) operational corollaries
   (`cor:diagonal-isodual-transversal-group`, `cor:discrete-lu-symmetry`).**  Over odd
   prime fields, diagonal isoduality is exactly the condition for the
   projective transversal group to be `F_q^2 ⋊ SL_2(q)`; otherwise it is
   `F_q^2 ⋊ T`.  Every state in the general family has finite projective
   product-unitary automorphism group.
3. **Classification corollary (`cor:lu-lc-pencil`).** On C396's admitted
   odd-prime-field non-GRS pencil, projective, monomial-code, LC, and LU
   equivalence are all equivalent to equality of `z`. Over extension
   fields, Frobenius already identifies unequal `z` values.
4. **Operational phase theorem (`thm:logical-phase`,
   `cor:six-arc-fixed-party-group`,
   `cor:computed-party-splitting`).** The fixed-party logical symplectic image is
   `SL_2(q)` on the GRS locus and the split torus off it, over odd prime
   fields.  Including logical Paulis, the exact projective groups are
   `F_q^2 ⋊ SL_2(q)` and `F_q^2 ⋊ T`.  In the twelve computed
   party-permutation examples the extension splits; odd motion on every
   listed non-GRS/H3 row extends the torus to its normalizer.
5. **Explicit LU witnesses.** C402's marginal moment uniformly separates
   good H3 reductions from GRS; C397's four-copy scalar resolves its q=13
   collision.
6. **Mechanism boundary.** C559 proves generic constancy of fixed-copy
   scalar contractions; C548/C550 identify and explain the exceptional
   divisor of one useful four-copy certificate.

## Frozen boundary table

| Result | Field/domain | Included exceptions | Excluded boundary |
|---|---|---|---|
| LU-intertwiner rigidity and transversal no-go | every prime power `q=p^e`, every `m≥2`, and every additive stabilizer `AME(2m,q)` state; associated stabilizer `[[2m-1,1,m]]_q` encoder for the corollary | arbitrary stabilizer phases and non-`\(\F_q\)`-linear additive label groups | `m=1`, nonstabilizer AME tensors, and transversal gates of other quantum-code families |
| Exact diagonal-isodual transversal logical group | odd prime `q`, `m≥2`, and a linear `[2m,m,m+1]_q` MDS code | `F_q^2 ⋊ SL_2(q)` iff `SC=C^\perp` for nonsingular diagonal `S`, and `F_q^2 ⋊ T` otherwise; includes non-GRS diagonally isodual codes | extension-field full Clifford groups, party-moving enlargements, and non-product physical implementations |
| Diagonal-multiplier phase test | every finite field and exact linear `[2m,m,m+1]` MDS pair | multiplier nullity zero or one; every nonzero multiplier has full support and a unique projective class | no generator-matrix/Veronese or higher-\(m\) codimension claim |
| Pencil classification by `z` and extension-field sector algebra | projective/monomial over odd finite fields; LC/LU only over odd prime fields on the admitted non-GRS locus | every field-automorphism exponent has exact diagonal/Gale divisors, explicit Gale multiplier, same-exponent disjointness, and `z`-equivariance | zeros of `2t(t-1)BG`, the GRS boundary, and full extension-field Clifford classification |
| Logical-Clifford phase | odd-prime-field six-arcs | characteristic-17/31 symmetry jumps retain the phase | characteristic two, extension-field full Clifford kernels, and non-stabilizer AME tensors |
| Computed party-extension splitting | the twelve C624 prime-field pencil, GRS, enhanced-symmetry, and H3 rows | every listed extension splits; odd motion gives `N(T)` on the non-GRS/H3 rows | no uniform splitting theorem for arbitrary six-arcs, all H3 reductions, or extension fields |
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

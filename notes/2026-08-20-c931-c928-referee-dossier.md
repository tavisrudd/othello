# C931 -- sealed named-referee dossier for C928

**Prepared:** 2026-08-20

**Status:** dossier sealed; no report has yet been generated

**Object:** `papers/blown-up-theta-lattice/`
**Paper:** *The Integral Middle Cohomology of the Theta Divisor of a Cubic
Threefold*

## 1. Purpose and isolation boundary

This dossier prepares an adversarial referee simulation for the closed C928
paper.  It names plausible experts from public professional evidence, records
the literature that makes each expert relevant, assigns disjoint proof
surfaces, and fixes a common verdict protocol.  It does **not** contact any
person, attribute an opinion to them, or imitate their voice.  A later report
will be an expertise-conditioned cold read, not a claim about what the named
individual would say.

The first-pass referee may see only:

1. the frozen PDF identified below;
2. the common public-source pack in Section 10;
3. that referee's packet in Section 7; and
4. the common report form in Section 8.

The first-pass referee may not see C908/C928 research notes, proof
certificates, priority audits, handoffs, previous model conversations, proposed
repairs, this dossier's other packets, or another referee's report.  In
particular, the reports must independently notice the distinction between an
abstractly split exact sequence and nontrivial simultaneous lattice glue.

No manuscript, bibliography, PDF, metadata, or mirror edit is authorized by
this phase.  Reports are frozen before an editor synthesis is run.  Repairs, if
any, begin only from an adopted-finding ledger.

## 2. Frozen review surface

- Authority commit: `ac04f826c179b53a599d95b4bac7534ba6a900a1`
  (`Close C928 theta lattice paper`).
- PDF: `papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf`.
- PDF SHA-256:
  `3822f928217df38e4ed3f4feb687d9036637dbc751bda3f792906df1196e36e5`.
- Extent: 8 A4 pages.
- Source gate at closure: `make check` passed.
- Worktree check at dossier construction: no tracked or untracked change below
  `papers/blown-up-theta-lattice/`.

Any change to the PDF hash invalidates all reports and requires a fresh batch.
Line references should use printed page, displayed equation, theorem, and
section labels rather than mutable source line numbers.

## 3. What the paper claims

Let \(X\) be a smooth cubic threefold, \((J,\Theta)\) its principally
polarized intermediate Jacobian, and
\(M=\operatorname{Bl}_0\Theta\).  With
\(\Lambda=H^1(J,\mathbf Z)\), the paper claims:

1. an abstractly split exact sequence of free groups
   \[
   0\to\bigwedge^3\Lambda\xrightarrow{b^*}H^3(M,\mathbf Z)
     \xrightarrow{e^*}H^3(X,\mathbf Z)\to0;
   \]
2. the saturated Gysin image
   \[
   b_*H^3(M,\mathbf Z)
   =L\bigwedge^3\Lambda+\theta^{[2]}\wedge\Lambda,
   \qquad
   \operatorname{Sat}(\operatorname{im}L)/\operatorname{im}L
   \simeq\Lambda/2\Lambda;
   \]
3. a canonical fibre-product placement of \(H^3(M,\mathbf Z)\) inside the
   Gysin image and \(H^3(X,\mathbf Z)\), controlled by the integral cylinder
   isomorphism \(y:H^3(X,\mathbf Z)\simeq\Lambda\);
4. Smith factors \(1^{110},2^{10}\) for
   \(L:\bigwedge^3\Lambda\to\bigwedge^5\Lambda\);
5. a free rank-ten degree-five escape lattice whose exceptional image is
   exactly its doubled sublattice; and
6. the integral identification
   \(IH^3(\Theta,\mathbf Z)\simeq H^3(M,\mathbf Z)\).

The proof has five load-bearing interfaces:

- the link/Gysin/Mayer--Vietoris calculation and singular weak Lefschetz;
- an integral symplectic-basis block decomposition, with the unsigned
  vertex--edge incidence matrix of \(K_{g-1}\);
- clean exceptional restriction for the blown-up Fano difference map;
- the divided-power Pontryagin endpoint and cylinder adjunction; and
- integral duality plus the degree-three truncation description of the
  intersection complex.

Three readings are expressly outside the claim:

- the sequence of abelian groups is **not** claimed to be nonsplit; the
  arithmetic is in simultaneous \((b_*,e^*)\)-glue;
- the full degree-six Fano transfer is **not** claimed to surject; only ten
  endpoint lifts are used; and
- no integral decomposition-theorem statement is made outside degree three.

## 4. Editorial route

### Default simulation standard: *Proceedings of the AMS*

The paper is an eight-page, self-contained specialist theorem.  The journal's
public scope is shorter research articles, at most 15 printed pages, that are
correct, new, significant, well written, and of interest to a substantial
mathematical audience.  This is the best first simulation because it forces a
clean answer to the real editorial question: does the integral lattice and its
geometric glue rise above a technically correct special-case computation?

### Stretch standard: *Algebraic Geometry*

The journal publicly asks for first-class research in algebraic geometry and
related fields, with high quality and originality.  This is an intentionally
hard ceiling test.  The manuscript would need the cubic/Fano geometry,
integral Lefschetz calculation, and intersection-cohomology consequence to be
seen as one conceptual result rather than three stitched computations.

### Specialist fallback standard: *Manuscripta Mathematica*

Kraemer's closest rational predecessor appeared there.  This is a topical fit,
but it is not used as a lower correctness standard.  Before a real submission,
the current scope and board must be rechecked and an actual conflict screen
performed.

No handling editor is nominated here.  Managing and subject assignments
change, and naming one without a verified current subject portfolio would add
false precision.  The editorial packet below is instead assigned to a named
whole-paper expert.

## 5. Ranked named slate

The rank is by fit to this paper, not prestige.  "Source-adjacent" means the
person authored a work on which the paper materially relies or against which
novelty is measured; it calls for extra adversarial framing, not exclusion.

| Rank | Candidate | Public basis for fit | Relevant literature | Assigned pressure | Caution |
|---:|---|---|---|---|---|
| 1 | **Sebastian Casalaina-Martin**, Professor, University of Colorado Boulder | Official profile lists curves, abelian varieties, cubic threefolds, and moduli | with R. Friedman, *Cubic threefolds and abelian varieties of dimension five*; *Singularities of the Prym theta divisor*; with R. Laza, *The moduli space of cubic threefolds via degenerations of the intermediate Jacobian* | Cubic/theta singularity and Fano-resolution geometry | Not source-adjacent to a cited proof, but unusually close to the exact geometric object |
| 2 | **Olivier Debarre**, Professor of algebraic geometry, ENS/Université Paris Cité | Official/public institutional pages identify abelian varieties and higher-dimensional algebraic geometry as specialties | *Minimal Cohomology Classes and Jacobians*; *Complex Tori and Abelian Varieties*; current notes *Two or Three Things I Know About Abelian Varieties* | Minimal class, Albanese/Fano, divided powers, and Pontryagin endpoint | Whole-field authority; availability for an actual short-paper report is unknown |
| 3 | **Laurenţiu Maxim**, Professor, University of Wisconsin--Madison | Official page lists topology of hypersurface singularities, intersection homology, and perverse sheaves | *Intersection Homology & Perverse Sheaves: with Applications to Singularities*, especially Deligne-sheaf, decomposition, and hypersurface chapters | Integral link calculation and \(IH^3\) identification | Not a cubic-threefold specialist; packet must remain on coefficients and local topology |
| 4 | **Mike Miller Eismeier**, Assistant Professor, University of Vermont | Official profile/current site and research page; algebraic topology and integral Lefschetz work | with A. Faulkner Valiente, *A Lefschetz decomposition over \(\mathbf Z\), and applications* | General-\(g\) saturation, Smith factors, naturality, and novelty versus the integral filtration | Strongly source-adjacent: coauthor of the nearest general framework |
| 5 | **Thomas Krämer**, incoming Professor of Complex Algebraic Geometry, University of Hamburg (winter 2026--27; previously Chemnitz/HU Berlin) | Official university pages identify abelian varieties, Hodge theory, topology, and representation theory | *Cubic threefolds, Fano surfaces and the monodromy of the Gauss map*; *Perverse sheaves on semiabelian varieties* | Rational predecessor, decomposition-theorem boundary, and priority/significance | Strongly source-adjacent: author of the exact rational predecessor cited by the paper |
| 6 | **Claire Voisin**, CNRS Directrice de recherche, IMJ-PRG; Collège de France emerita | Official pages identify algebraic/Kähler geometry, topology, Hodge theory, Chow groups, and cubic hypersurfaces | *A remark on the Abel--Jacobi morphism for the cubic threefold*; *On the universal \(CH_0\) group of cubic hypersurfaces*; work on integral Hodge classes | Whole-paper significance and editorial ceiling | Use only for an editorial synthesis/alternate, not as a substitute for packet-level checking |

### Focused alternates

| Primary packet | Alternate | Why | Literature anchor / caution |
|---|---|---|---|
| Cubic/Fano | **Arnaud Beauville** | Author of the foundational theta-singularity and degree-six difference-map source | *Les singularités du diviseur Theta...*; maximally source-adjacent |
| Integral topology/IH | **Greg Friedman**, TCU | Integral/PID intersection homology, Mayer--Vietoris, and duality | *Singular Intersection Homology*; *Generalizations of intersection homology and perverse sheaves with duality over the integers* |
| Integral lattice | **Analisa Faulkner Valiente**, entering MIT doctoral study in 2026 | Coauthor of the exact nearest integral-Lefschetz source | Technically exact fit but currently predoctoral and source-adjacent; use as a specialist check, not the sole external referee |
| Editorial/cubic topology | **Claire Voisin** | Broad integral topology, Abel--Jacobi, and cubic expertise | Listed above; no claim of availability |

The default independent batch is Casalaina-Martin / Maxim / Debarre / Miller
Eismeier / Krämer.  Voisin supplies the later editorial-ceiling packet.  The
alternates are replacements, not extra votes, unless a primary report exposes
a genuinely cross-disciplinary dispute.

## 6. Conflict and fit screen

This is a simulation roster, not a submission recommendation form.  Public
sources cannot establish all real conflicts.  Before any actual journal
submission, the author must screen recent coauthorship, institutional overlap,
advisor/student relationships, active collaboration, financial ties, and
personal conflicts under that journal's policy.

Known structural cautions:

- Beauville, Clemens--Griffiths, Krämer, and Faulkner Valiente--Miller
  Eismeier are authors of load-bearing or nearest-prior sources.  Proximity is
  useful for an adversarial simulation but must not be described as support.
- Casalaina-Martin is exceptionally close to the cubic-theta recognition
  problem and may weight geometric context more heavily than the integral
  lattice novelty.  The packet therefore demands explicit separation of
  correctness and significance.
- Maxim and Friedman have the right integral-IH expertise but are not assigned
  the Fano/Pontryagin identities.
- Faulkner Valiente's exact topical fit does not by itself make a predoctoral
  researcher an appropriate sole referee for a real submission.
- No private views, availability, or willingness to referee are inferred.

## 7. Sealed referee packets

Each packet begins with the frozen PDF and the common sources, but only the
listed question set.  Every adverse finding must quote a theorem/equation/page,
state the exact missing implication, and distinguish a proof gap from a request
for exposition or citation.

### Packet G -- cubic theta divisor and Fano geometry

**Persona basis:** Sebastian Casalaina-Martin.  **Alternate:** Arnaud
Beauville.

Check:

1. Does the manuscript use the classical description correctly: unique
   ordinary triple point, tangent cone \(X\), smooth blow-up, exceptional
   normal bundle \(\mathcal O_X(-1)\), degree-six Fano difference map, and
   \([F]=\theta^{[3]}\)?
2. Is the lift
   \(Y=\operatorname{Bl}_\Delta(F\times F)\to M\) stated at the strength
   actually supplied by the classical model?
3. Does \(q^{-1}(X)=P\) with multiplicity one follow from the degree
   comparison given, or is a local/Cartier argument missing?
4. Is \(q^*e_*=j_*p^*\) justified integrally with the orientations and normal
   bundles in play?
5. Does the clean-restriction formula really yield ten integral endpoint
   lifts, without assuming surjectivity of the full degree-six transfer?
6. Are the Albanese embedding and the identification of the exceptional
   divisor with the universal line used with consistent factor order and
   sign?

Deliver one of: no geometric defect; a local repair with exact text needed; or
a fatal break in the endpoint-lift construction.

### Packet T -- local topology and integral intersection cohomology

**Persona basis:** Laurenţiu Maxim.  **Alternate:** Greg Friedman.

Check:

1. Recompute the circle-bundle Gysin sequence for
   \(K=S(\mathcal O_X(-1))\), including the \(\mathbf Z/3\) in \(H^4(K)\).
2. Verify every zero and injection used in the pair and Mayer--Vietoris
   sequences.  In particular, determine whether
   \(H^3(M)\simeq H^3(U)\) and
   \(\ker e^*=b^*H^3(\Theta)\) follow with integral coefficients.
3. Check the precise integral singular weak-Lefschetz statement used to
   identify \(H^3(\Theta,\mathbf Z)\) with \(H^3(J,\mathbf Z)\).  Flag if the
   cited relative-homotopy theorem gives only a different range or requires an
   unrecorded hypothesis.
4. Check that the degree-three Deligne-sheaf truncation for an isolated
   singularity in a complex fourfold gives
   \(IH^3(\Theta,\mathbf Z)=H^3(U,\mathbf Z)\) for the manuscript's
   normalization and perversity.
5. Decide whether torsion or lower/upper-middle coefficient issues can alter
   the asserted natural map from ordinary to intersection cohomology.
6. Confirm that the manuscript appropriately refuses an integral
   decomposition-theorem claim in the even degrees affected by multiplication
   \(h\mapsto3\ell\).

Do not accept a rational argument as an integral proof.  State coefficient,
perversity, and shift conventions explicitly.

### Packet A -- abelian variety, cylinder, and Pontryagin endpoint

**Persona basis:** Olivier Debarre.

Check:

1. Verify the integral cylinder isomorphism
   \(\pi_*p^*:H^3(X,\mathbf Z)\to H^1(F,\mathbf Z)\) at the cited
   Clemens--Griffiths location and the deduction that its adjoint on free
   lattices is unimodular.
2. Verify the use of the Albanese map and Poincaré duality to identify
   \(H^3(F)/\mathrm{tors}\) with \(\Lambda\), including any hidden torsion or
   sign convention.
3. Recompute
   \(\xi\star\theta^{[3]}=\pm\theta^{[2]}\wedge y(\xi)\) from the addition
   correspondence.  Check degree, factorial, divided-power integrality, and
   whether inversion on the first factor introduces a degree-dependent sign
   not absorbed by one global definition of \(y\).
4. Check that \([F]=\theta^{[3]}\) is used in the correct cohomological
   normalization.
5. Check the projection formulas for \(b_*q_*\mu^*\) and the relation
   \(b_*b^*\alpha=\theta\wedge\alpha\).
6. Decide whether the fibre-product coset is canonical after the chosen global
   sign, and whether the word "canonical" should be weakened anywhere.

The packet must separately verdict the endpoint identity and the geometric
identification of its \(y\)-coordinate.

### Packet L -- integral symplectic Lefschetz lattice

**Persona basis:** Mike Miller Eismeier.  **Technical alternate:** Analisa
Faulkner Valiente.

Check:

1. Verify that the singleton/full-pair occupancy decomposition is an integral
   direct sum and exhausts all degree-three and degree-five monomials relevant
   to \(L_3\).
2. Recompute the Smith form of the unsigned incidence map
   \(U_n:\mathbf Z^n\to\mathbf Z^{\binom n2}\) for every \(n=g-1\ge3\).
   Check the claimed unit \((n-1)\)-minor and determinant-two \(n\)-minor,
   including the edge case \(n=3\).
3. Check that the all-edge vector generates the complete saturation quotient,
   not merely a visible order-two subgroup.
4. Check that there are exactly \(2g\) independent defective blocks and that
   the remaining blocks are primitive.
5. Verify
   \(\operatorname{Sat}(L_3\bigwedge^3\Lambda)
   =L_3\bigwedge^3\Lambda+\theta^{[2]}\wedge\Lambda\), the injectivity of
   \(L_3\) for \(g\ge4\), and the natural isomorphism
   \(\Lambda/2\Lambda\to\operatorname{Sat}/\operatorname{im}\).
6. Compare the theorem precisely with Faulkner Valiente--Miller Eismeier:
   identify whether the Smith multiplicities or divided-power representatives
   are already an immediate named specialization, and what citation language
   would then be required.

No finite computer certificate is available to this packet.  The verdict must
rest on the structural proof as printed.

### Packet P -- closest prior art and decomposition boundary

**Persona basis:** Thomas Krämer.

Check:

1. Compare the manuscript's rational statement with Corollary 6 of
   *Cubic threefolds, Fano surfaces and the monodromy of the Gauss map*.
2. Verify the shifts and three skyscraper summands in
   \(R\sigma_*\mathbf Q_M[4]\), and whether "the same argument works over
   \(\mathbf Q\)" is justified.
3. Determine exactly which ranks and rational decompositions were already
   forced by that result and which integral data remain new.
4. Test the manuscript's novelty language against the integral Lefschetz
   filtration paper and the classical Fano/theta sources.  Do not accept an
   unqualified firstness claim.
5. Decide whether the mod-two fibre-product glue and doubled escape lattice are
   genuinely not recoverable from the rational decomposition.
6. Check whether another obvious source is missing for integral intersection
   cohomology of isolated theta singularities or for the relevant symplectic
   exterior-power Smith form.

Return a claim-by-claim priority table: prior, immediate corollary, or surviving
new content.  A literature absence is "not found in the reviewed sources," not
proof of global novelty.

### Packet E -- whole-paper editorial ceiling

**Persona basis:** Claire Voisin.

This packet is run only after G/T/A/L/P are frozen, but it receives the original
PDF and public sources first, not their reports.  It asks:

1. Is there one coherent theorem, and is the integral glue the correct headline?
2. Is the result significant enough for the *Proceedings* standard?  Is it
   credible at the *Algebraic Geometry* stretch standard?
3. Are the hypotheses, naturality, and limitations visible without reconstructing
   the development history?
4. Does the paper correctly distinguish its integral contribution from
   Krämer's rational decomposition and the general integral Lefschetz
   framework?
5. Are any proof transitions too compressed for an eight-page paper, even if
   likely correct?
6. Give an editorial decision independent of the eventual synthesis.

## 8. Common cold-read report form

Each report must contain, in this order:

1. **Verdict:** A / B / C / D from the scale below.
2. **Claim map:** one sentence for each main theorem/corollary in the packet.
3. **Major findings:** numbered; each gives location, assertion, exact failure
   or verification, severity, and smallest adequate remedy.
4. **Minor findings:** notation, attribution, convention, or exposition only.
5. **Literature boundary:** what the assigned public sources do and do not
   establish.
6. **Confidence:** high / medium / low for each major finding, with the source
   or calculation supporting it.
7. **Publication recommendation:** default and stretch venue separately.

Verdict scale:

- **A -- accept:** no mathematical repair; optional polish only.
- **B -- minor revision:** theorem survives; all required repairs are local and
  do not change a proof mechanism or headline.
- **C -- major revision:** central result may survive, but a load-bearing
  implication, coefficient convention, or priority boundary must be rebuilt or
  materially expanded.
- **D -- reject in present form:** a headline theorem is false, unsupported by
  the stated mechanism, or substantially pre-empted.

The referee must not average uncertainties into a confident verdict.  If a
claim cannot be checked from the allowed material, it is recorded as an
explicit verification debt with the missing source named.

## 9. Acceptance matrix and synthesis rule

| Gate | Owning packet | Pass condition |
|---|---|---|
| Classical cubic/Fano model | G | Blow-up/difference-map geometry and multiplicity-one exceptional restriction are valid at the stated integral strength |
| Integral topology | T | Link, pair, Mayer--Vietoris, weak Lefschetz, and degree-three IC truncation all work with \(\mathbf Z\)-coefficients |
| Endpoint glue | A | Cylinder adjoint and Pontryagin formula produce ten unimodularly parametrized lifts with the printed coset |
| Lattice theorem | L | General-\(g\) saturation, Smith factors, generators, and naturality follow structurally |
| Dual escape | A + L | Annihilator argument yields a free rank-ten quotient and exceptional image exactly \(2E_M\) |
| Priority | P | Rational and general integral predecessors are fully credited; surviving contribution is not overstated |
| Editorial value | E | The surviving integral result is coherent and significant at the named venue standard |

Synthesis rules:

1. Reports are frozen before comparison.
2. A finding is adopted only with a manuscript location and a reproducible
   source/calculation.
3. A source-author's assertion has no extra weight; the evidence controls.
4. Conflicting findings trigger a narrowly scoped adjudication packet that
   sees the disputed passages and sources, not the other referees' rhetoric.
5. Any adopted C or D on a load-bearing gate blocks submission.
6. Repairs produce a new PDF hash and a fresh, focused rerun; old A/B verdicts
   do not automatically transfer.

## 10. Public source pack and read ledger

### Full-text mathematical sources already verified

| Source | Use in batch | Access / cache record | Read depth |
|---|---|---|---|
| A. Beauville, *Les singularités du diviseur Theta de la jacobienne intermédiaire de l'hypersurface cubique dans P4* (1982) | singularity, blow-up, degree-six Fano geometry | `BEAUVILLE:LNM947-theta-singularities`; SHA-256 `4596f46edfdf9b69fd295581119faf814ad67a1e3d87592aa0146aaf225ea90a` | full text, 19 pp. |
| C. H. Clemens and P. A. Griffiths, *The intermediate Jacobian of the cubic threefold* (1972) | integral cylinder map, Fano minimal class, Albanese/intermediate Jacobian | `10.2307/1970801`; SHA-256 `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60` | full text, 77 pp.; targeted §§2, 11 |
| T. Krämer, *Cubic threefolds, Fano surfaces and the monodromy of the Gauss map* (2016) | rational decomposition and closest object-level predecessor | `arXiv:1501.00226`; SHA-256 `bad27e7b9eee618e83259d392d706e0738756fa57cd33f021641c2f1b4fed9f6` | full text, 10 pp.; Cor. 6 targeted |
| A. Faulkner Valiente and M. Miller Eismeier, *A Lefschetz decomposition over Z, and applications* (2025) | nearest general integral exterior-Lefschetz framework | `arXiv:2507.00844`; SHA-256 `3a3ef5208198526fdfcdeaabc00abbae77650b2015bce5806cce92e3d8a0ac91` | full text, 30 pp.; filtration and Hard-Lefschetz applications targeted |
| M. Artebani, R. Kloosterman, M. Pacini, *A new model for the theta divisor of the cubic threefold* (2004) | independent geometric model / missing-prior-art check | `arXiv:math/0403245`; SHA-256 `85b1dc5fa83f1d36f94e76aa8e32b07e7650b12177204f98aa8e569ade6024be` | full text, 21 pp. |
| O. Debarre, *Minimal Cohomology Classes and Jacobians* (1993/95) | minimal-class normalization and abelian-variety context | `arXiv:alg-geom/9301002`; SHA-256 `975fbc7f4a31b67e2e38e97364e9314b0060404f4c7a904d6ad5ca2a90ae4486` | full text, 14 pp. |

These cache files are public-source copies, not internal C928 notes.  The
frozen PDF and exact cache records form the reproducibility boundary.

### Convention/reference sources

| Source | Relevant content | Read depth for dossier |
|---|---|---|
| M. Goresky and R. MacPherson, *Stratified Morse Theory*, Part II §1.2 | relative homotopy / singular weak Lefschetz | citation and targeted convention inherited from manuscript audit; full book not cached |
| L. Maxim, *Intersection Homology & Perverse Sheaves* (Springer GTM 281, 2019) | Deligne sheaf, perversity, decomposition package, hypersurface singularities | official description, contents, and available introduction metadata; packet must verify the precise degree-three convention |
| G. Friedman, *Singular Intersection Homology* (Cambridge, 2020) | integral chain model, Mayer--Vietoris, products, Poincaré duality | official description and table of contents; alternate packet source |
| S. Casalaina-Martin and R. Friedman, *Cubic threefolds and abelian varieties of dimension five* (JAG 14, 2005) | recognition of intermediate Jacobians by a unique triple point | abstract and bibliographic metadata |
| C. Voisin, *A remark on the Abel--Jacobi morphism for the cubic threefold* (2013) | cubic-threefold Abel--Jacobi context | bibliographic/full-text cache available under `DOI:10.1016/j.crma.2012.12.002`; targeted use only |

### Public role and venue evidence

- Casalaina-Martin, CU Boulder profile:
  <https://www.colorado.edu/math/sebastian-casalaina-martin>.
- Debarre, official publications and institutional profile:
  <https://perso.imj-prg.fr/olivier-debarre/publications/> and
  <https://www.iufrance.fr/les-membres-de-liuf/membre/1080.html>.
- Maxim, UW--Madison profile:
  <https://people.math.wisc.edu/~lmaxim/>.
- Miller Eismeier, UVM profile and research page:
  <https://www.uvm.edu/cems/mathstat/profile/mike-miller-eismeier> and
  <https://sites.google.com/view/millereismeier/research>.
- Krämer, TU Chemnitz appointment and Hamburg incoming listing:
  <https://www.tu-chemnitz.de/tu/pressestelle/aktuell/13126> and
  <https://www.math.uni-hamburg.de/en/forschung/bereiche/ad.html>.
- Voisin, IMJ-PRG and Collège de France profiles:
  <https://webusers.imj-prg.fr/~claire.voisin/> and
  <https://www.college-de-france.fr/en/chair/claire-voisin-algebraic-geometry-statutory-chair>.
- Friedman, TCU profile:
  <https://faculty.tcu.edu/gfriedman/>.
- Faulkner Valiente, Barnard 2026 fellowship/profile notice:
  <https://barnard.edu/news/record-breaking-number-barnard-students-and-alumnae-awarded-nsf-graduate-research-fellowships>.
- *Proceedings of the AMS* scope:
  <https://www.ams.org/aboutproc>.
- *Algebraic Geometry* scope and board:
  <https://ems.press/journals/ag> and
  <https://ems.press/journals/ag/editorial-board>.

Role pages were checked on 2026-08-20.  They support field and current-role
selection only; they do not imply endorsement, availability, or absence of a
private conflict.

## 11. Batch order and output paths

Run and freeze the reports independently in this order only for operational
clarity:

1. `c931-c928-referee-G-cubic-fano.md`
2. `c931-c928-referee-T-integral-IH.md`
3. `c931-c928-referee-A-abelian-endpoint.md`
4. `c931-c928-referee-L-integral-lattice.md`
5. `c931-c928-referee-P-priority.md`
6. `c931-c928-referee-E-editorial.md`
7. `c931-c928-referee-synthesis.md`

All files belong under `notes/2026-08-20-c931-*`.  The editor synthesis gets
the six frozen reports, the frozen PDF, and this dossier.  It produces an
adopt/reject ledger, a venue verdict, and a minimal rerun plan.  It does not
edit the paper.

## 12. Dossier verdict

The paper is ready for a meaningful referee batch.  The theorem is compact,
but no single generic algebraic geometer is an adequate stress test: its risk
is concentrated at the four interfaces between integral local topology,
symplectic Smith theory, Fano correspondences, and perverse-sheaf
normalization.  The five primary packets isolate those interfaces, while the
editorial packet tests whether the surviving result is valuable enough to
publish rather than merely correct.

The most important anti-bias control is the source-adjacency rule.  Krämer and
Miller Eismeier are included because they are best placed to detect
pre-emption, not because citation creates presumed approval.  Conversely, a
novelty objection from either must identify an actual theorem or immediate
specialization in the public source.

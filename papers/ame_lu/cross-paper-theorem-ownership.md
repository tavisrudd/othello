# Cross-paper theorem ownership

This internal ledger freezes the one-owner rule for the split of the combined
AME--LU manuscript. The combined baseline identities are:

- public paper tree `2ada0216f5176543f8e7612f38e0cba62e4406bf81a36a6593a55288ea3d98cd`;
- formal-companion tree `b030f559acc08ef110f5a1bbbe29f1b84c19541fab44b191703dcc827d5b4bc9`;
- monorepo checkpoint `3400ff6ed6056b0a5ef52512619b30dae3adafa4`.

“Paper I” means `papers/ame_lu`; “Paper II” means
`papers/mds_css_transversal_groups`. A label listed in a row keeps that label
unless a later editorial pass records an explicit successor label. The
baseline-label column records the labels from the frozen combined source.

| Successor paper and label(s) | Source report(s) | Conceptual proof location | Computation/certificate | Literature audit and permitted wording | Lean declaration/gate | Other paper | Frozen baseline label(s) |
|---|---|---|---|---|---|---|---|
| Paper I: `lem:diagonal-axes`, `prop:marginal-axes` | C560, C649 | exact-rigidity section, tensor-axis core | none | C562/C647; credit Rains, Van den Nest--Dehaene--De Moor, Harshman/Kruskal; no firstness | tensor-axis declarations; future `AMEStabilizerRigidity` gate | Paper II cites only the resulting rigidity theorem | same two labels |
| Paper I: `prop:stabilizer-ame-support`, `prop:full-weyl-marginal`, `cor:full-weyl-cover` | C649 | stabilizer support geometry | none | C649/C647; “to our knowledge” only at the all-prime-power arbitrary-additive scope | `StabilizerAMESupport`, full-Weyl criterion; Paper I gate | Paper II cites as part of the imported theorem, not separately | same three labels |
| Paper I: `thm:lu-lc-rigidity`, `lem:pauli-phase-correction` | C649, C642 | exact rigidity and stabilizer-character correction | none | C562/C647; qualified scope, no “first” | exact cores and `StabilizerDictionary`; Paper I gate, with state/density composition honestly manuscript-only | Paper II states precise cited inputs | same two labels |
| Paper I: `thm:atlas-classification` | C649/C734 | minimum-support atlas and holonomy section | none | C647; operator-pushing ancestry credited | support profile and `HolonomyCentralizer`; Paper I gate | Paper II uses six-party holonomies locally, without reproving atlas completeness | same label |
| Paper I: `prop:partial-weyl-marginal`, `lem:recognition-group`, `cor:recognition-generation` | C804/C807 | Paper I appendix on partial-Weyl recognition | none | C807; qubit theorem fully conceded, arbitrary-dimension/intermediate-subgroup wording only | none; manuscript only | omitted | same three labels |
| Paper I: `lem:minimal-support-charts`, `cor:css-recognition`, `rem:arbitrary-dimension` | C804/C807 | same recognition appendix | none | C807; no priority claim at dimension two | none; manuscript only | omitted | same three labels |
| Paper I: `cor:transversal-clifford` | C609/C613/C649 | encoder/Choi consequence | none | C647; established transversal constructions credited | `EncoderTransversal` Choi/Clifford cores; Paper I gate | Paper II cites as the exclusion half of its exact-group theorem | same label |
| Paper I: `cor:discrete-lu-symmetry`, `rem:local-phase-torus` | C615/C617/C602 | exact projective automorphism groups | none | C647 and C775; Wirthmüller/Tan scope conceded | `AutomorphismExactSequence`; Paper I gate | Paper II restates only the group-extension notation needed by its appendix | same two labels |
| Paper I: `lem:local-generator-isometry`, `lem:product-lie`, `thm:two-uniform-discrete`, `rem:discreteness-prior-art`, `rem:two-uniform-not-clifford`, `rem:fisher-isotropy` | C774--C777 | two-uniform appendix | none | C775; Wirthmüller, Tan, Słowik--Sawicki--Maciążek, Braunstein--Caves credited; scoped “to our knowledge” only | `Multipartite` covers algebraic core; Paper I gate | omitted | same six labels |
| Paper I: `thm:two-uniform-stability`, `prop:stability-region`, `cor:approximate-decomposition`, `cor:two-unitary-gauge` | C774--C776/C795 | quantitative appendix | none | C775; no metrology or self-testing novelty claim | conditional decomposition interface only; Paper I gate | omitted | same four labels |
| Paper I: `lem:tracial-agreement`, `lem:site-contraction`, `thm:k-uniform-stability`, `cor:k-uniform-region`, `prop:region-ceiling` | C786/C795 | uniformity-order appendix | none | C775/C795; natural-strength claim, no optimality wording | manuscript only | omitted | same five labels |
| Paper I: `prop:half-splitting`, `lem:cut-transversal`, `thm:budget-free-stability` | C796 | alternate quantitative appendix | none | no separate novelty claim | manuscript only | omitted | same three labels |
| Paper I: `lem:quantitative-axes`, `prop:quantitative-intertwiner` | C581/C795 | quantitative intertwiner section | none | C581/C775; Auddy--Yuan framework credited | manuscript only | omitted | same two labels |
| Paper I: `lem:collective-support-energy`, `thm:aggregate-global-rounding` | C830 | alternative-rounding appendix | none | no optimality claim | manuscript only | omitted | same two labels |
| Paper I: `lem:quantitative-cleaning-commutator`, `lem:nested-weyl-rounding`, `thm:cleaning-global-rounding` | C833/C835 | principal quantitative body | none | Pastawski--Yoshida exact obstruction credited; local claim limited to leakage estimate, Fourier rounding, and AME composition | manuscript only | omitted | same three labels |
| Paper I: `lem:stabilizer-overlap-gap`, `cor:uniform-separation`, `thm:explicit-threshold`, `prop:robust-linear-atlas` | C786/C795/C838 | rounding closure and robust-atlas section | none | stabilizer overlap stated as standard; no threshold optimality claim | overlap/robust conclusions manuscript only | omitted | same four labels |
| Paper II: `thm:dictionary` | C374/C590/C591 | MDS--CSS and six-arc dictionary | inherited C374 checks | standard AME--MDS sources cited; no novelty claim | `Dictionary`, `StabilizerDictionary`; future `MDSCSSTransversalGeometry` gate | Paper I derives its general encoder corollary without this linear dictionary | same label |
| Paper II: `prop:diagonal-multiplier-line`, `cor:diagonal-isodual-transversal-group` | C619/C622/C631 | diagonal-isoduality and exact-group section | none | C647; established isometry-dual/GRS/Weil work credited, contribution stated as exact iff boundary, no firstness | `DiagonalIsoduality` unconditional, `EncoderTransversal` carrier interface; Paper II gate | omitted except Paper I supplies cited rigidity/no-go | same two labels |
| Paper II: `lem:six-arc-self-association`, `thm:logical-phase`, `cor:six-arc-fixed-party-group` | C397/C619/C622 | six-point logical-phase section | C397 replay for finite six-point inputs | C594/C647; classical self-association and quantum-code constructions credited | `LogicalPhase` conditional carrier interface; Paper II gate | omitted | same three labels |
| Paper II: `thm:lc-pencil`, `cor:lu-lc-pencil` | C396/C571/C640 | non-GRS pencil section | exact quotient and holonomy certificates | C562/C647; no independent priority claim, prime-field correction mandatory | `PencilClassification` algebra and conditional terminal; Paper II gate | omitted | same two labels |
| Paper II: `prop:frobenius-sector-divisors` | C623/C633/C640 | extension-field subsection | no finite premise | no full orbit-classification or priority claim | `ExtensionFieldPencil` unconditional scalar declarations; Paper II gate | omitted | same label |
| Paper II: `lem:coset-syndrome-charts`, `prop:clebsch-x-syndrome`, `rem:clebsch-x-syndrome-boundary` | C731/C732/C734 | Clebsch worked application | no new computation; C624 row reused | companion Clebsch theorem gets conic/count/orbit credit; only quantum interpretation and conjunction claimed | `SyndromeGeometry` core; Paper II gate | omitted | same three labels |
| Paper II: `thm:fixed-copy-boundary` | C559/C580 | scalar-blindness section | none | no priority claim | manuscript only | omitted | same label |
| Paper II: `lem:conic-matchings`, `thm:lu-h3-grs` | C374/C402 | scalar-certificates appendix | H3 marginal certificate and independent replay | bounded source audit retained; no broad separation claim | `MarginalMoment` finite core and conditional interface; Paper II gate | omitted | same two labels |
| Paper II: `thm:q13-lu` | C397/C568 | scalar-certificates appendix | exact four-copy certificate and independent replay | no priority or global minimal-copy claim | `FourCopyContraction` conditional terminal; Paper II gate | omitted | same label |
| Paper II: `thm:transport-divisor` | C548/C550/C569 | transport appendix | determinant/rank/orbit certificates and replays | no independent priority claim | `TransportDivisor` algebra plus explicit bridge inputs; Paper II gate | omitted | same label |
| Paper II: `cor:computed-party-splitting` | C624/C629 | party-extension appendix | twelve complete complement certificates | C647; no arbitrary-row splitting claim | `PartyExtensionSplitting` consequences after supplied complement; Paper II gate | Paper I omits the census and factor-set appendix | same label |

The internal evidence files, figures, and formal terminals follow the same
owner assignments. Paper II owns the complete existing computational package.
Paper I owns no copy of that package after its later trim. The combined source
remains untouched until Paper II has passed its independent build and replay.

# C930 second independent referee pass

**Lane:** `cubic-threefolds`

**Scope:** phase-1 proof memo only, strictly \(m=1\); no manuscript edits

## Verdict

**PASS.**  The repaired occurrence-indexed marker theorem is type-correct, and
the atomic direct-QDM proof and the conditional framed-sixth proof are literal
specializations of it.  No blocker, major, or minor finding remains.

The review was independent and used the C907 solver dossier as its source map.
It ran three bounded rounds: the repaired theorem, the Milnor/notation pass,
and the final proof-order change.

## Closed findings

1. The common theorem consumes marker-level comparison certificates.  It does
   not demand equality of framed block multisets.
2. Every correction retains its actual occurrence
   \(\omega_j=(\beta,Z,j,\varsigma_j,\chi_j)\).  The reconstruction parameter
   \(\varsigma_j\) and numerical Novikov specialization \(\chi_j\) are
   distinct; auxiliary divisor-character variables are a temporary faithful-
   extension adapter, not part of the ledger index.
3. The free symmetric-monoidal groupoid
   \(\operatorname{Sym}^{\sqcup}(\Pi_{\mathcal T})\) is separated from its
   commutative monoid of components
   \(\mathcal L_{\mathcal T}=\pi_0\operatorname{Sym}^{\sqcup}(\Pi_{\mathcal T})\).
   The comparison and center-null congruences live on the monoid.
4. The bottom-left object in the descent square is explicitly an object-set
   quotient by birational equivalence.  No localization category is asserted.
5. Iritani's \(q_{\mathrm{exc}}\), Iritani--Koto's \(q_{\mathrm{fib}}\), and
   the cubic variable \(q\) are distinct.  The source variables
   \(Q,\widetilde Q,Q_Z\) and the projective-bundle convention
   \(p=c_1(\mathcal O_{\mathbf P(V)}(1))\) are recorded at their interfaces.
   The cubic square root is \(\kappa=(3q)^{1/2}\), leaving \(r\) for bundle
   rank.
6. Hirzebruch surfaces are direct; only ruled surfaces over positive-genus
   curves use 5.7R, and only residual nonminimal nonruled surfaces use 5.7T.
7. The chemical formula enters through the generalized probe-indexed compiler,
   not by substitution into the QDM block carrier.

## Exposition and diagrams

The memo now gives the one-blowup model before the abstract record.  Theorem A
and its telescope proof follow the five provider fields immediately; the
\(K_w/J_{w,n}\) quotient and descent square then give the categorical form of
the same proof.  A compact notation table serves algebraic-geometry,
quantum-cohomology, and category-theory readers without adding another proof
overview.

Both `amscd` diagrams compile together under TeX Live 2025.  The occurrence-
indexed descent square is type-correct, and the normalized cubic fork is
restricted to the one local cubic exponent frame on which both arrows exist.

## Source convention check

The notation pass checked Iritani, *Quantum cohomology of blowups*,
arXiv:2307.13555v3 (cached SHA-256 `c16f56b2...a934b`), and Iritani--Koto,
*Quantum cohomology of projective bundles*, arXiv:2307.03696v4 (cached SHA-256
`5139f8e0...57624`), together with the current epilogue conventions.  This was
a notation and hypothesis-interface check, not a new literature or priority
claim.

## Phase boundary

The phase-1 memo is ready to govern phase 2.  C930 remains active pending the
author's decision whether and how to refound the manuscript.  No manuscript,
mirror, or Lean source was changed.

# C847 — Paper II theorem-only cold and adversarial read

**Lane:** `ame-lu`
**Verdict:** `MINOR`

## Result

The 22-page *Diagonal Isoduality and Transversal Clifford Groups of
MDS--CSS Codes* survives its cold reconstruction at the level of its headline
theorem.  The diagonal-multiplier space is indeed zero- or one-dimensional,
the nullity-one and nullity-zero fixed-party projective transversal carriers
are exactly
\(\mathbb F_q^2\rtimes\mathrm{SL}_2(q)\) and
\(\mathbb F_q^2\rtimes T\), and the finite six-point calculations are
applications rather than premises of that all-length dichotomy.

The paper is not yet a `GO` because one secondary theorem uses a companion-paper
atlas result that the introduction expressly omits from its list of imported
conclusions, and the split left six stale or unsupported hard-coded equation
references.  These are bounded manuscript corrections.  They do not alter the
main statement, proof mechanism, paper architecture, evidence package, formal
boundary, or one-way dependence on Paper I.

No manuscript, Lean source, release manifest, standalone repository, formal
repository, or remote was changed in this task.

## Independent reconstruction of the headline theorem

### The multiplier line

For \(s\ne0\) in
\(\mathcal D(E,F)=\{s:\operatorname{diag}(s)E\subseteq F\}\), a multiplier
with at most \(m\) nonzero coordinates would send a codeword nonzero at one of
those coordinates to a nonzero word of \(F\) of weight at most \(m\), contrary
to \(d(F)=m+1\).  Hence the multiplier has at least \(m+1\) nonzero
coordinates.  Its kernel on \(E\) is supported on at most the remaining
\(m-1\) coordinates, so \(d(E)=m+1\) makes the kernel zero.  Equal dimensions
then give \(\operatorname{diag}(s)E=F\).  A zero coordinate of \(s\) would
force the corresponding coordinate functional to vanish on all of the MDS
code \(F\), which is impossible.  Thus every nonzero multiplier has full
support.

Two independent multipliers would have a nonzero linear combination vanishing
in a selected coordinate.  Full support excludes this, so the space has
dimension at most one.  For \(E=F\), the all-ones multiplier supplies the
unique scalar line.  Taking \(F=C^\perp\) proves the zero/one nullity test and
identifies nullity one with diagonal isoduality.  This argument is valid over
any field; the odd-prime and \(m\ge2\) hypotheses enter later through the
one-qudit Clifford carrier and the imported stabilizer-AME theorem.

### The nullity-zero carrier

A fixed-party product Clifford has local symplectic blocks
\(F_i=(\alpha_i\ \beta_i;\gamma_i\ \delta_i)\).  Preservation of
\(L_C=C_X\oplus C_Z^\perp\) gives the four diagonal-multiplier inclusions in
equation (3.1).  If an input block is nondiagonal, then one of the global
diagonals \(D_\beta,D_\gamma\) is nonzero, and the multiplier-line proposition
produces a nonsingular diagonal equivalence \(C\simeq C^\perp\).  Therefore
nullity zero forces every input block to be diagonal.  The self-multiplier line
makes its diagonal entries coordinate-independent, and determinant one makes
them \(a,a^{-1}\).  Conversely the common blocks
\(\operatorname{diag}(a,a^{-1})\) preserve the CSS label space.  The exact
linear image is consequently the split torus \(T\).

### The nullity-one carrier

For a witness \(S=\operatorname{diag}(s_i)\) with \(SC=C^\perp\), the lower
and upper blocks in equation (3.3) act by
\((c,h)\mapsto(c,h+\lambda Sc)\) and
\((c,h)\mapsto(c+\mu S^{-1}h,h)\).  They preserve the CSS label space, and the
imported stabilizer-character correction turns these label symmetries into
state-ray symmetries.  At any input coordinate they realize all lower and upper
elementary unipotents, hence all of \(\mathrm{SL}_2(q)\).  Choi transposition is
an automorphism of that group, and physical Pauli representatives supply the
translation fiber \(\mathbb F_q^2\).  The imported encoder no-go excludes every
product-unitary logical action outside the one-qudit Clifford group.  Thus the
projective carrier is exactly
\(\mathbb F_q^2\rtimes\mathrm{SL}_2(q)\).

The propagated ratios \(s_i/s_j\) are intrinsic because the multiplier line is
projectively unique.  The coherent odd-field Weil lift applies only to the
linear \(\mathrm{SL}_2(q)\) factor.  The nontrivial Weyl commutator prevents a
homomorphic lift of the projective translation group, so the affine lift is
the Heisenberg extension rather than a scalar splitting.  The manuscript keeps
this distinct from the separate party-permutation extension.

## Adversarial hypothesis and converse audit

- **MDS hypotheses:** both distance \(m+1\) and equal dimension \(m\) are used
  exactly where needed in the multiplier proof.  Nondegeneracy of coordinate
  projections follows from the MDS condition.
- **Odd prime:** the theorem correctly restricts the exact one-qudit carrier to
  an odd prime field.  Over extension fields the full local Clifford action is
  \(\operatorname{Sp}_{2e}(\mathbb F_p)\), and the paper explicitly declines
  the stronger classification.
- **Fixed party:** the main theorem, abstract, Section 5, Figure 1, and the
  verification scope all distinguish the fixed-party group from transported
  encoder views and party-moving extensions.
- **Existence versus exclusion:** diagonal isoduality constructs all
  symplectic generators; imported phase correction supplies state rays;
  imported encoder rigidity supplies the only exclusion step.  No converse is
  inferred from the finite pencil or computed party rows.
- **GRS versus intrinsic:** the Reed--Solomon dual formula gives examples on
  the nullity-one branch, but evaluation structure is not used in the
  all-length theorem.
- **Six-point evidence:** Section 3 contains no finite census or certificate
  premise.  The verification section states explicitly that the certificate
  layer supports only the displayed six-point applications.

## Required bounded corrections

1. **State the actual atlas import.**  In
   `sections/01-introduction.tex:73-87`, the sentence “We use only these stated
   conclusions” lists rigidity, encoder no-go, and phase correction, but
   `sections/04-pencil-classification.tex:105-167` also uses Paper I's
   minimum-support atlas: projection of every four-support plane to a local
   Weyl plane is an isomorphism, the minimum-support planes generate the full
   label group, and atlas equivalence is the LC converse.  Add a compact
   imported proposition with the companion-paper citation, or cite and state
   precisely the needed clauses at their use.  This preserves the one-way
   dependency and closes Theorem 4.1 without importing internal ledgers.
2. **Repair the atlas proof locators.**  At
   `sections/04-pencil-classification.tex:110`, equation (4.2) is the scalar
   relation for \(y(t),y(u)\), not minimum-support generation.  At line 120,
   equation (4.4) is the holonomy definition that follows, not the support
   projection isomorphism.  Replace both hard-coded references by the imported
   atlas proposition or a local lemma.
3. **Remove or replace four stale split references.**  The state formula cited
   as (1.1) at `sections/02-geometry-ame-dictionary.tex:84-87` is unnumbered;
   `sections/04-pencil-classification.tex:29-30` cites nonexistent (1.3) even
   though \(A,B,z\) were just defined locally; and the “operator tensor (3.2)”
   at `sections/06-lu-invariants.tex:57-63` and
   `sections/10-scalar-certificates.tex:191-198` points instead to diagonal
   isoduality.  Use labels and `\eqref` where an equation is genuinely needed;
   otherwise name the four-party reduced-operator family in words.
4. **Give Paper I a reader-resolvable citation before release.**  The current
   bibliography entry records only “Companion preprint” and the frozen combined
   source-tree hash.  That is enough for internal provenance but not a stable
   scholarly locator.  Add the public preprint or repository locator when the
   release identity exists.  This is a release-order gate, not a theorem defect.

## Figure, PDF, and trust boundary

The existing PDF is 22 pages.  A full-page contact sweep found no clipping,
overlap, malformed float, or visibly broken reference/citation layout.  The
build log contains no overfull/underfull box, LaTeX/package warning, undefined
reference, or undefined citation diagnostic.

Figure 1 is legible at publication size and communicates the two nullity
branches quickly.  The dashed descent from the torus branch to
\(\mathbb F_q^2\rtimes N(T)\) is visually subordinate; its edge label and
caption restrict it to realized odd party motion in computed non-GRS rows and
say that it need not fix the encoder input.  The figure therefore passes the
comprehension and fixed-party falsehood probes.  Moving the finite row below the
headline branches remains an editorial choice, not a required correction.

The trust statement is honest and correctly layered.  It marks the multiplier
line and exact dichotomy as manuscript proofs with no finite premise, the
six-point claims as deterministic exact-arithmetic replays, the exact carrier
formalization as conditional at its remaining bridges, and the future semantic
gate/content-addressed manifest as scheduled rather than present.  It also
states the prime-field, fixed-party, product-implementation, stabilizer, and
code-family boundaries.

## Extra-juice and Tao closeout

The cheap structural gain is to eliminate hard-coded equation numbers from the
correction rather than merely renumbering them.  The split exposed that these
references were carrying mathematical responsibility without semantic labels.
An imported atlas proposition with a stable label would simultaneously repair
the proof dependency, the two false locators, and the introduction's ownership
statement.

The strongest skeptical question is whether the exact-group theorem quietly
uses the six-point holonomy census to prove its converse.  Reconstructing
Section 3 from the CSS label equations answers no: the all-length construction
uses only diagonal duality, and exclusion uses only Paper I's encoder theorem.
The holonomy census first enters the pencil's LC classification in Section 4.
No theorem-strengthening or scope change is justified by this read.

## Mystery ledger

- **Settled — why nullity cannot exceed one:** full support of every nonzero
  multiplier makes any two independent multipliers impossible by coordinate
  cancellation.
- **Settled — whether the six-point certificates hide inside the exact group:**
  they do not; the proof closes before the pencil is introduced.
- **Settled — whether the two lift statements conflict:** the Weil lift splits
  the linear factor, while the Heisenberg commutator obstructs the projective
  affine translation section.
- **Open editorial gate — exact atlas import:** Paper I proves the needed
  support-generation and atlas-equivalence clauses, but Paper II must state or
  cite them at the use site.  The next manuscript correction owns this gate.
- **Open release gate — companion locator:** the public Paper I identity must be
  substituted for the internal frozen-tree note before release.

No genuine mathematical mystery remains in the headline diagonal-isodual
fixed-party group theorem.

## Acceptance

`MINOR`.  Apply the four bounded corrections above, rebuild warning-free, and
repeat the affected-page/source-reference sweep.  No new theorem, computation,
certificate, Lean edit, release-manifest change, standalone operation, or
remote action is needed to reach `GO`.

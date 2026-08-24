# C678 complete-ports cold referee read: round 1

Status: **BLOCK**

Source commit: `89c6face1cde63d83c4782938e15d155dcba55cb`

PDF SHA-256: `bec4501164a40900ebf3474d3879fab080610541f80e4b49ec2c52be2f297ad9`

This is a private synthesis of isolated PDF-only reads. The storage/coding,
matroid/reliability, and finite-geometry/formal readers did not receive task
reports, prior findings, proposed fixes, or this dossier. The adjacent-field
and visual-navigation pass was performed separately. No manuscript source was
edited during the reads.

## Release decision

The manuscript is not ready for a second blind round. The general port,
transfer, reliability, and pointed-Tutte spine appears viable, but two printed
claims cannot simultaneously be accepted:

1. The MDS reconstruction theorem and its positive-density corollary include
   the full-space MDS code, which is a direct counterexample.
2. The completed cubic--axis rows in the body disagree with the completed
   field-nine data in Appendix A; the appendix data instead have the length and
   formulas of the uncompleted configuration.

The cubic exact-row proof and the public trust boundary also need material
completion before re-review.

## Principal proof mechanisms

- **Exact weighted-functional transfer, PDF pp. 4--5,
  `thm:transfer`.** The block-functional decomposition cleanly separates the
  pointed cost `mu_x`, the other-block cost `lambda`, and the persistent
  zero-functional sector `z_x`. The theorem retains singleton functional
  supports that an ordinary outer-support distance would miss.
- **Quartic--nucleus harmonic family, PDF pp. 13--14,
  `thm:quartic`.** The finite-completion, infinity, and zero-sum branches are
  handled coherently. Circuit minimality, the five-point section bound, and
  the harmonic-orbit convention support the stated Steiner port.
- **Matroid/reliability bridge, PDF pp. 8--12.** Deletion--contraction,
  pivotal differentiation, the blocker expansion, the cheapest-radius
  transform, and the Las Vergnas specialization use consistent signs and
  directions. The filtration example independently reproduces the printed
  successful-set counts and distinct curves.

## First confidence drop

**PDF p. 1, `thm:mds-reconstruction`.** “Positive-dimensional `[n,k]` MDS”
allows `k=n`. For `C=F_q^n`, one has `C^perp=0`, so the empty coefficient port
already spans the dual at radius zero. The claimed reconstruction radius
`rho_x(C)=k=n` is false. The common-core argument silently uses `n-k>0`.

## Required findings

### 1. Mathematical error: proper-code hypothesis

Locations: PDF pp. 1--3 and p. 6; `thm:mds-reconstruction` and
`cor:mds-fingerprints`.

Require `1 <= k < n`, or state and propagate a separate full-space case. In the
full-space case `I^perp=0`, so Definition 3 gives `z_x(I)=infinity`, not
`2(k+1)`. Synchronize the introduction, proof, corollary, result spine, and
formal statement map.

Falsification: substitute `C=F_q^n`. The dual and every coefficient port are
zero, so reconstruction occurs at radius zero.

### 2. Internal contradiction: completed cubic rows

Locations: PDF pp. 13 and 16; `thm:cubic` and Appendix A.1.

The body states that the completed `[2q+2,4,q]_q` configuration has uniform
rows

- cubic coordinate: `((q-1)/2, q-1)`;
- axis coordinate: `((5q-3)/6, 2q-3)`.

At `q=9` these are `(4,8)` and `(7,15)` on 20 coordinates. Appendix A.1 calls
its object completed but reports `(4,7)`, `(6,12)`, and `(7,13)` with
multiplicities `9,9,1`, totaling 19 coordinates. Those values have the length
and formulas of the uncompleted `T_q \sqcup L_q` configuration. Identify the
computed object precisely, reconcile or replace the rows, and give the
certificate or replay evidence before the strict field-nine example is used.

Falsification: direct substitution of `q=9` into the body formulas contradicts
the appendix table and its coordinate count.

### 3. Missing proof: cubic exact inventory

Location: PDF pp. 12--13; `thm:cubic`.

The phrases “Vandermonde determinants classify” and “shifted-inverse
complement lemma” currently carry load-bearing work. State and prove the
missing complement lemma, including infinity and characteristic-three cases;
display the circuit-classifying determinants; give the matching relabelings
and pairings; and derive the restored-infinity rows separately. Exact
coordinatewise values should not depend on an unnamed lemma or an implicit
finite census.

### 4. Scope: necessity of the persistent obstruction

Location: PDF pp. 5--6 and the abstract/conclusion; `thm:prescribed`.

The `z_x` inequality is necessary and sufficient for eventual bounded block
confinement in the fixed-inner, linear-concatenation regime with outer dual
distance tending to infinity. The paper does not show that it is necessary
for arbitrary positive-density realizations by asymptotically good families.
Qualify every phrase saying it “precisely controls positive-density
realization” by the theorem's construction and hypotheses.

### 5. Formal correspondence and reproducibility

Location: PDF pp. 15--16; Appendix A and A.1.

The trust categories and axiom footprint are internally consistent, but the public paper
does not provide a release-grade audit path. It needs the exact public module
closure, Lean/toolchain identity, replay entry point, and a statement-to-
declaration/certificate map for the main MDS and geometric theorems. The
field-nine witness needs its five multipliers, inner matrix or canonical
coordinate definition, artifact hash, and replay command. Explain explicitly
how the Singer-regularity hypothesis is discharged for the concrete instance.
Remove the reader-facing phrase “this private draft.”

### 6. Degenerate repair convention

Locations: PDF p. 2 and p. 8; `def:complete-port`, `prop:port-invariants`, and
`thm:failure-leading-term`.

State a global nondegenerate-target/nonempty-clutter convention or handle the
empty-repair case explicitly. Availability, transversal-minus-one tolerance,
blocker size, and the leading failure expansion otherwise have edge cases that
are undefined or misleading.

### 7. Exposition: one conceptual diagram

Locations: introduction through Sections 2--3.

Add one proof-spine diagram showing

`inner coefficient port -> block-functional cost -> confinement gate ->`
`positive-density copies`,

with support, normalized coefficients, and probability/reliability shown as
the three transported or derived views. Mark the fixed-inner linear-
concatenation regime, radius bound, and outer-dual-distance hypothesis on the
arrows or in the caption. This diagram has a genuine navigation job: it makes
the multi-stage correspondence visible before the dense proof and gives later
sections a stable callback. Red-team it against all hypotheses and do not let
it imply arbitrary-family necessity.

An incidence sketch contrasting cubic--axis and quartic--nucleus ports is
optional. It should be deferred until the cubic object and completed rows are
reconciled; otherwise it risks encoding the current contradiction.

## Lens decisions

- **Coding/storage: MAJOR.** Coefficient ports contain represented data absent
  from the generic MDS support clutter. In the declared scalar model,
  coefficients determine the decoder and weighted transfer cost; they do not
  reduce helper count, scalar accesses, or scalar download. The paper mostly
  keeps locality, availability, bandwidth, access, MAP, and capacity distinct.
- **Matroid/reliability: MINOR within this lens.** The polynomial identities,
  perspective direction, substitutions, and filtration separation passed.
  The global MDS edge case remains a required correction.
- **Finite geometry/formal: MAJOR.** The quartic flagship passed attempted
  checks. The cubic rows are internally contradictory and their exact proof is
  incomplete at referee resolution. Appendix A is a useful private trust
  sketch, not yet a standalone reproducibility boundary.
- **Adjacent-field/visual: MAJOR.** The object and intended mechanism are
  recoverable by page 2, but confidence drops at the false edge case and again
  at the compressed cubic proof. A single proof-spine diagram would materially
  improve navigation.

## Safe-skip map

- A reader of the transfer/realization spine may skip Sections 4--6 after
  retaining what is transported, but Appendix A is not skippable for formal or
  finite-evidence claims.
- A geometry reader may skip the reliability and pointed-Tutte development,
  but not the geometric inventories or their completeness arguments.
- The finite determinant ledger in the pointed-Tutte example is skippable once
  its represented witness is accepted.
- Section 6 and Appendix A.1 are not safely skippable while the cubic strict
  weighted-transfer example is advertised.

## Reopen gate

Rebuild from a clean source commit only after all required findings are
resolved. Freeze the new PDF and hash, then send it to a fresh isolated panel
that has not seen this report. Public repository creation, DOI deposition,
tagging, and pushing remain separate author actions.

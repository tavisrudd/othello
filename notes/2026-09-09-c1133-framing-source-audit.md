# C1133 — rank-three framing source audit

**Date:** 2026-09-09. **Lane:** `cubic-threefolds`.
**Verdict:** Proposition 2.1 of the cited v1 is false as written for rank three.
This is a bounded statement-level finding; it does not establish that the paper's
main moduli theorem is false.

## Source and read depth

Kontsevich–Szabó, *Moduli of atoms of complex projective varieties*,
`arXiv:2607.22074v1`, 24 July 2026. **Read depth: partial** — introduction,
Section 2 including Proposition 2.1 and its proof, and the opening of Section 3
through Proposition 3.1's argument (cached extraction lines 1–415).
Access: shared PDF/text cache, key `arXiv:2607.22074`.
PDF SHA-256: `2986902b3281489b47c6a36a63e356b8265910542d09ac69c7239ffc9f615ec9`.
The official arXiv abstract/history page was also consulted. No claim about an
unread revised or published version is made. Full-text source count: **0**.

The source was found in the 23-member Semantic Scholar forward-citation set of
`arXiv:2508.05105`, not in the supplied packet bibliography. Its statement is
relevant to the packet's optional corrected rank-three lattice.

## Explicit counterexample

Use the source's sign convention (
abla=d+K(z),dz) and gauge law
(K^G=G^{-1}KG+G^{-1}G'). Put
[
N=E_{12}+E_{23},qquad H=E_{31},qquad G=I+zH.
]
Here (H^2=HNH=0), so (G^{-1}=I-zH). Start with
(K_0=N/z^2). Direct multiplication gives
[
K=K_0^G=rac{N}{z^2}+rac{E_{21}-E_{32}}z+E_{31}.
]
Thus the pole order is exactly two, its leading coefficient is the regular
upper-triangular nilpotent Jordan block, and its (z^{-1}) coefficient has
nonzero entries below the diagonal. These meet the three hypotheses of
Proposition 2.1 and contradict its conclusion.

Regular singularity is explicit, rather than inferred from eigenvalues.
For (S=operatorname{diag}(1,z,z^2)),
[
K_0^S=rac{N+operatorname{diag}(0,1,2)}z.
]
Consequently (T=G^{-1}S) is a meromorphic frame making (K^T) logarithmic.
In the source's definition this proves regular singularity. Equivalently,
(e^{N/z}=I+N/z+N^2/(2z^2)) is a meromorphic fundamental matrix of (d+K_0dz),
and applying (G^{-1}) transports it.

## The nonresonant version also fails

To rule out an explanation based on trivial or repeated monodromy, replace
(K_0) by (N/z^2+D/z), where
(D=operatorname{diag}(1/7,2/7,3/7)). The same regular gauge gives
[
K=rac Nz^2+rac{D+E_{21}-E_{32}}z+rac97E_{31}.
]
Its logarithmic frame (G^{-1}S) has residue
(N+D+operatorname{diag}(0,1,2)), with eigenvalues
(1/7,9/7,17/7). Under the source's connection convention, monodromy has
three distinct eigenvalues (e^{-2\pi i/7},e^{-4\pi i/7},e^{-6\pi i/7}),
all different from one. A monodromy eigenbasis at (z=1) supplies its required
flag. Thus even the introduction's distinct, nonunit monodromy conditions do
not rescue Proposition 2.1 in this frame.

## Why the distinction matters here

Upper triangularity of the first residue coefficient in an arbitrary original
Jordan frame is stronger than existence of a regular logarithmic lattice.
A first-order regular gauge can change that coefficient by ([N,H]), including
its subdiagonal entries. The source's rank-three-and-higher scalar-reduction
argument does not justify ignoring those cancellations. Its rank-two argument
is not refuted by this example.

The packet explicitly applies a first-order correction before its rank-three
shearing. This counterexample supports the need to distinguish those two
operations; it is not a proof of the packet's full optional appendix. It also
provides no counterexample to its rank-two construction, numerical classification,
or Hodge conservation. Do not cite Proposition 2.1 as a shortcut to the appendix's
normalization step. Keep the correction and its change-of-frame proof explicit.

## Exact replay and trust boundary

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-09-09-c1133-framing-counterexample.py
```

The standard-library checker uses exact `Fraction` Laurent matrices and the
linear-algebra operations in `2026-09-09-c1133-independent-checks.py`. It checks
both gauge inverses, both complete Laurent identities and both logarithmic
lattice identities. Its adjacent JSON is canonical. Script/output hashes and
byte counts, including the imported helper, are in the framing manifest.
The displayed hand derivation independently proves the witness; no geometric
QDM realization is claimed or required to refute this general proposition.

## EJ+TT and Mystery ledger

The closeout pass asked whether the source's nonresonance could remove the
counterexample. The second witness settles that question negatively. It also
separates the rank-two result from the rank-three failure.

Open: the source's main moduli theorem may admit a repair; no verdict on that
larger result is established here. C1133 needs only an accurate comparison with
the packet's normalization and formal-germ proof, not a replacement theory of
moduli of connections. This finding was sought during the framing audit and is
a task-owned deliverable, not an incidental discovery-track promotion.

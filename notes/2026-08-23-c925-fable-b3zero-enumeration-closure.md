# The Fano b3=0 tail is closed: all 59 Mori--Mukai families with h^{1,2}=0 carry only semisimple ledger blocks

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Completes residue §5.1 of
`2026-08-23-c925-fable-mm224-projective-bundle-closure.md`: the enumeration
of the \(b_3=0\) Mori--Mukai classification against the closure criteria.
The full 59-row table with per-family provenance is
`notes/cubic-threefolds-tasks/c925-fable-b3zero-enumeration.md`; the
\(h^{1,2}\) roster is machine-read from the fanography source data
(`c925-fanography-h12-source.yaml`, sha256
`a5c769b0fc4ab284669bf7328789a35f9ddff94638767eaa04620e42a43d1c6f`, from
`pbelmans/fanography` commit `d2122e727a963b58befe8f23bd7bfb90cbe68ce8`)
with eight spot-checks; constructions are quoted line-by-line from the
cached CCGK text (arXiv:1303.3288).

## 1. The closure class

**Definition.**  Call a smooth projective variety \(Y\) *ledger-closed* if
the Levelt/formal block data of its quantum connection over the coefficient
field of any formal bulk curve based at the punctured small locus —
including Iritani's large-radius curves — consists of semisimple blocks
only.

**Lemma (closure properties).**  The class of ledger-closed varieties
contains every variety whose small quantum algebra (even part) is étale at
one point of its Novikov torus (anchor lemma,
`2026-08-23-c925-fable-gs-carrier-blowup-chains.md` §1, whose proof is
dimension-free), and is closed under:

1. **blow-up** along a point or a smooth rational curve in a ledger-closed
   base (Iritani arXiv:2307.13555 Theorem 5.18(1): the decomposition
   commutes with \(\nabla_{z\partial_z}\), and the point and
   rational-curve summands are semisimple as in the chain proposition);
2. **projectivization** \(\mathbf P(V)\) of any vector bundle over a
   ledger-closed base (Iritani--Koto arXiv:2307.03696 Theorem 5.1, items
   (1)-(2): the decomposition into \(\varsigma_j^*\mathrm{QDM}(B)\)
   summands intertwines the full connection and pairing);
3. **product with a ledger-closed factor** (in the cases used here,
   \(S\times\mathbf P^1\), via the chain presentation over
   \(\mathbf P^2\times\mathbf P^1\) of the blow-up-chains note §2 — no
   separate product theorem is invoked).

The base need not be étale at a point itself: the induction invariant is
ledger-closedness, so chains over the bundle-closed MM 2-24, or bundles
over chains, are covered.  This strengthens the chain proposition, whose
base hypothesis was étale-at-a-point.

## 2. Theorem

**Every one of the 59 Mori--Mukai deformation families of smooth Fano
threefolds with \(h^{1,2}=0\) is ledger-closed.**  Hence no \(b_3=0\) Fano
threefold carrier anywhere in the telescope can contribute a marked block
or triple.

*Proof structure (per the table):*

| criterion | count | closed by |
| --- | --- | --- |
| rank one (\(\mathbf P^3\), \(Q^3\), \(V_5\), \(V_{22}\)) | 4 | étale certificates, `...gs-carrier-rank-one.md` |
| toric | 17 | toric sweep étale certificates, `...toric-b3zero-levelt-sweep.md` |
| product \(S\times\mathbf P^1\) (\(\rho\ge6\)) | 5 | chains over \(\mathbf P^2\times\mathbf P^1\), blow-up-chains note §2 |
| blow-up chain over a closed base | 30 | Lemma item 1, iterated |
| homogeneous (flag, MM 2-32) | 1 | étale certificate, blow-up-chains note §3 |
| projective bundle (MM 2-24, 3-24) | 2 | Lemma item 2 (2-24: `...mm224-projective-bundle-closure.md`; 3-24 \(=W\times_{\mathbf P^2}\mathbf F_1\) is the flag's \(\mathbf P^1\)-bundle pulled back over the toric \(\mathbf F_1\)) |

The two families flagged as potential escapees on the first pass, 3-8 and
3-17, are both blow-ups of 2-34 (\(\mathbf P^1\times\mathbf P^2\), toric)
along smooth rational curves, by the Mori--Mukai extremal-contraction data
and by direct derivations with exact \((-K)^3\) cross-checks (24 and 36);
3-17 is independently a non-split \(\mathbf P^1\)-bundle over
\(\mathbf P^1\times\mathbf P^1\) and 3-8 independently a blow-up of the
bundle-closed 2-24 along a smooth conic fibre — the one row that exercises
the strengthened base hypothesis.  Membership of each blow-up centre in
the smooth-rational-curve class is automatic from \(b_3=0\)
(\(b_3(\mathrm{Bl}_CV)=b_3(V)+2g(C)\)) plus smoothness of the member, as
in the chain proposition.  Every chain in the table bottoms out in a
rank-one, toric, or homogeneous base; no row is unclassified.  \(\square\)

Per-member scope: rows closed through blow-down or bundle structures use
the Mori--Mukai classification's per-family extremal-contraction data
(contraction types are constant across each deformation family), so the
closure applies to every smooth member, matching the per-member statements
of the earlier notes.

## 3. What this does and does not close

With this note the **(GS-carrier) obligation is discharged for the entire
Fano \(b_3=0\) tail**: toric, rank-one, chains, products, homogeneous,
bundles — all 59 families, every smooth member.  The remaining residue of
the \(m=2\) programme's tail is exactly one item:

- **Non-Fano carriers** not presented as chains or projective bundles over
  ledger-closed bases.  Open as before; the structural irregular-Hodge
  lead remains the candidate uniform closure.  Note the closure-class
  lemma is not Fano-restricted, so any non-Fano carrier that *is* such a
  chain or bundle is already covered; what is missing is a structure
  theorem for the carriers the telescope can actually emit.

A caught bookkeeping hazard, recorded so it is not re-tripped: CCGK's
rank-4 section labels are offset by one from the standard/fanography
labels from MM4-3 onward (they reinstate the family Mori--Mukai initially
missed as their MM4-2, where fanography appends it as 4-13); the verified
13-row dictionary with an independent \((-K)^3\) cross-check is in the
enumeration table.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The \(b_3=0\) roster is 59 of 105; classification covers all 59 with zero escapees after audit. | enumeration table, checksums. |
| settled | 3-8 and 3-17 close twice over (chain over toric 2-34; and bundle-closed routes), with exact degree cross-checks. | table audit section. |
| settled | CCGK rank-4 labels are shifted by one against fanography from 4-3 on. | dictionary in the table. |
| open, observation | 3-17's bundle \(\mathcal E\) is non-split with \(c_1=(1,1)\)-type twist data; together with 2-24's \(\ker(\mathcal O^3\to\mathcal O(2))\) these are the only two non-split-bundle presentations in the tail — both over del Pezzo bases of degree \(\ge8\).  Curiosity only; both families are closed regardless. | no gate. |
| open | Non-Fano non-chain/non-bundle carriers; irregular-Hodge lead. | §3, the sole remaining tail item. |

No manufactured mysteries: the tail residue is now a single named item.

# C925: the type-I1 permutation-resolution bound eleven is method-optimal

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-24

## Result

Let \(H\cong C_2\times S_3\) be the type-\(I_1\) Galois image of the
quartic del Pezzo generic fibre in Tschinkel--Zhang Proposition 5.1, and let
\(M=\operatorname{Pic}(\bar S)\) be its rank-six integral Picard lattice.
Among direct stable-permutation identities
\[
 M\oplus P\cong P',
\]
with \(P,P'\) permutation \(H\)-lattices, one has
\[
 \operatorname{rank}P'\ge11.
\]
Tschinkel--Zhang's displayed type-\(I_3\) identity restricts to type
\(I_1\) with ranks \(5\) and \(11\), so equality occurs.  Therefore their
uniform stabilization bound eleven cannot be improved for the explicit
type-\(I_1\) cubic merely by replacing their permutation resolution with a
smaller one.

This is a method-optimality theorem, not a lower bound on the intrinsic
stable-rationality level.  The successor report
`2026-08-24-c925-type-i1-level-ten-rationality.md` supplies exactly the
nonlinear operation omitted here and proves rationality at ten.  This result
by itself proves neither rationality nor irrationality of
\(X\times\mathbf P^m\) for any \(m<11\).

## Proof

Tschinkel--Zhang Lemma 4.2 gives a unimodular basis
\(b_1,\ldots,b_{11}\) in
\[
 M\oplus\mathbf Z\{w_0,w_1,w_2,q_0,q_1\}
\]
which the type-\(I_3\) generators permute.  The exact basis matrix has
determinant \(-1\).  Conjugating the two displayed permutation matrices by
this basis matrix recovers an integral block-diagonal action on the old
basis, with a rank-six Picard block and the displayed rank-five permutation
block.

The resulting order-24 group has exactly one order-12 subgroup with element
order profile
\[
 \#(1,2,3,6)=(1,7,2,2),
\]
hence the required \(C_2\times S_3\) subgroup.  Direct enumeration of all
subsets closed under multiplication gives ten conjugacy classes of
subgroups, and therefore ten transitive permutation \(H\)-sets.

Every pair \((P,P')\) with \(\operatorname{rank}P' < 11\) and the necessary
rational character identity
\[
 \chi_M+\chi_P=\chi_{P'}
\]
is then a nonnegative combination of these ten transitive characters.  The
exhaustion contains exactly fourteen candidates: target ranks seven through
ten occur with counts \(1,1,5,7\).

Each candidate fails integrally.  Write \(\Delta_g=g-I\).  For every
candidate, reduction modulo two or three gives two modules on which one of
the group-algebra elements
\[
 \Delta_g\Delta_h\qquad\text{or}\qquad \Delta_g+\Delta_h
\]
has different matrix rank.  An integral equivariant isomorphism would reduce
to an isomorphism over every finite field and would conjugate every such
group-algebra element, preserving its rank.  Thus all fourteen candidates
are impossible.  The rank-seven character mirage has a separate integral
check: the determinant polynomial of every equivariant comparison has 153
terms and content nine, so it can never be unimodular.

The rank-11 identity from Lemma 4.2 supplies the matching upper bound.

## Exact certificate

Artifacts:

- `notes/cubic-threefolds-tasks/c925-i1-permutation-resolution-check.py`,
  16,466 bytes, SHA-256
  `3ffe1915482661b22a5dc43e0482ee8879d685b51ad785127f109ebcd13d5af3`;
- `notes/cubic-threefolds-tasks/c925-i1-permutation-resolution-check.json`,
  8,993 bytes, SHA-256
  `a719905c950ab282ce9df4252fd0a6436132470d0f83130ef27c0289fd02a412`.

Replay from the repository root with SymPy 1.14.0:

```text
uv run --with sympy==1.14.0 python3 \
  notes/cubic-threefolds-tasks/c925-i1-permutation-resolution-check.py \
  --check-certificate \
  notes/cubic-threefolds-tasks/c925-i1-permutation-resolution-check.json
```

The computation is deterministic.  It exhausts all 2,048 subsets containing
the identity to verify the subgroup list, all permutation-character
combinations with target rank at most ten, and all pairs of group elements
until a modular rank obstruction is found for each candidate.  It uses no
random search.  The rank-seven determinant-content calculation is an
independent invariant within the same implementation; there is no second
implementation.  The trusted inputs are exactly the two generator
permutations and the eleven basis vectors displayed in Tschinkel--Zhang
Lemma 4.2.

## Source and read depth

No source was read at full-text depth for this focused result.

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — Section 2 through Proposition 2.3, Section 4
  through Lemma 4.2 and the "Levels of stable rationality" paragraph, and
  Section 5.1 through Proposition 5.1.  Shared-cache key
  `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The tempting rank-seven character identity is not integral; its determinant form has content nine. | Exact determinant polynomial. |
| settled | No target rank seven, eight, nine, or ten occurs in any direct stable-permutation identity for the type-\(I_1\) Picard lattice. | Fourteen-candidate exhaustion and modular rank obstructions. |
| settled | Rank eleven is attained and is optimal within this method. | Tschinkel--Zhang Lemma 4.2 plus the lower bound above. |
| settled by successor | A nonlinear birational construction lowers the actual stabilization bound to ten. | Projectivized-torsor scalar quotient; `../2026-08-24-c925-type-i1-level-ten-rationality.md`. |
| open | Is \(X\times\mathbf P^2\) irrational? | C925's primary quantum/decorated-ledger gate remains unchanged. |

## Effect on the four-hour goal

The published eleven cannot be lowered by optimizing the same permutation
resolution.  The successor projectivized-torsor argument bypasses this
restriction and lands ten; see the report linked above.

# (GS-carrier) propagates through blow-up chains: the b3=0 tail closes for every chain over a closed base, and the flag threefold closes explicitly

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Continues the pointwise programme of
`2026-08-23-c925-fable-b3zero-tail-a2-reduction.md` §3 and
`2026-08-23-c925-fable-gs-carrier-rank-one.md`: after the toric and
rank-one slices, the remaining \(b_3=0\) carriers were non-toric
\(\rho\ge2\) Fanos and non-Fano carriers.  This note closes all blow-up
chains over already-closed bases — Fano or not — and the flag threefold.

## 1. Upgraded anchor lemma

**Lemma.**  Let \(Y\) be a smooth projective threefold whose small quantum
algebra (even part) is étale at one point of its Novikov torus (e.g. all
Novikov variables \(=1\)).  Then the ledger of \(Y\)'s quantum connection —
its Levelt/formal block data over the coefficient field of **any** formal
bulk curve based at any point of the punctured small locus, including
Iritani's large-radius curves over \(\mathbf C((q^{-1/s}))\)-type fields —
consists of semisimple blocks only.

*Proof.*  The trace-form discriminant of the small algebra is an element of
\(\mathbf C[q^{\pm1/s}]\); étale-ness at one point makes it nonzero, hence
a unit in every coefficient field of the small locus, in particular in
\(\mathbf C((q^{-1/s}))\).  A bulk curve adds corrections in the maximal
ideal of a complete local ring over that field with residue the small
algebra; the discriminant stays a unit (Hensel), so the algebra over the
curve's fraction field is étale and every multiplication operator, in
particular \(E\star\), is semisimple there.  \(\square\)

This repairs a loose phrase in the tail-reduction report §2, which anchored
at "the special fibre of the accumulated curve": the correct and stronger
statement is that one étale point makes the discriminant generically
nonzero on the whole small locus, which is what the large-radius fields see.

## 2. Blow-up chains

**Proposition.**  Let \(X\) be a smooth projective threefold obtained from a
base \(Y\) by an iterated blow-up along points and smooth rational curves,
where \(Y\) satisfies the Lemma's hypothesis.  Then the ledger of \(X\) over
the coefficient field of its Iritani bulk curves is a sum of semisimple
blocks; in particular \(X\) carries no marked block or triple.  If \(X\) is
a \(b_3=0\) Fano threefold expressed as a blow-up chain over such a \(Y\),
the hypothesis on the centres is automatic: \(b_3(\mathrm{Bl}_CV)=b_3(V)+2g(C)\),
so \(b_3(X)=0\) forces every centre curve in the chain to be rational and
every intermediate base to have \(b_3=0\).

*Proof.*  Induct along the chain using Iritani's decomposition
(arXiv:2307.13555, Theorem 5.18), which is an isomorphism of modules
commuting with \(\nabla_{z\partial_z}\) (part (1)), so the ledger of the
blow-up over its field is the disjoint union of the summands' ledgers.  The
point summands are rank one.  A rational-curve summand is
\(\varsigma^*\mathrm{QDM}(\mathbf P^1)\): since \(\mathbf P^1\) has no even
bulk directions beyond unit and divisor, the string and divisor equations
reduce the shifted connection to the small one with rescaled Novikov
variable, whose \(E\star\) has separable minimal polynomial
\(\lambda^2-4\tilde q\) with \(\tilde q\) a unit — semisimple over any of
the (possibly ramified) coefficient fields.  The base summand is
\(\tau^*\mathrm{QDM}(Y')\) along a bulk curve of the previous stage \(Y'\),
semisimple by the induction hypothesis and the Lemma.  A direct sum of
semisimple blocks is semisimple blockwise; coincidences of exponentials
across summands merge simple sheets into blocks with vanishing nilpotent
part, which are unmarked by definition.  \(\square\)

**Coverage.**  Together with the toric sweep and the rank-one discharge,
this closes every \(b_3=0\) Fano threefold that the Mori--Mukai
constructions present as a blow-up chain over \(\mathbf P^3\), \(Q^3\),
\(V_5\), \(V_{22}\), or a toric base — the lines, conics, twisted cubics
and quartics, and point centres of the rank-2 and rank-3 lists — and every
product \(S\times\mathbf P^1\) with \(S\) a del Pezzo surface, since
\(\mathrm{Bl}_{\{p\}\times\mathbf P^1}(\mathbf P^2\times\mathbf P^1)
=\mathrm{Bl}_p\mathbf P^2\times\mathbf P^1\) exhibits these as chains over
the toric \(\mathbf P^2\times\mathbf P^1\) with section centres; that
covers in particular every Fano threefold of Picard rank \(\ge6\).  The
Proposition is not restricted to Fano \(X\), so non-Fano telescope
carriers that are chains over closed bases are closed by the same
statement.

## 3. The flag threefold, explicitly

MM 2-32, the \((1,1)\) divisor in \(\mathbf P^2\times\mathbf P^2\), is the
flag threefold \(\mathrm{Fl}(1,2;\mathbf C^3)\) — homogeneous, primitive
(not a blow-up chain), non-toric.  In the Givental--Kim presentation
\(QH^*(\mathrm{Fl}_3)=\mathbf C[x_1,x_2,x_3,q_1,q_2]/
(e_1,\,e_2+q_1+q_2,\,e_3+q_2x_1+q_1x_3)\), the canonical point
\(q_1=q_2=1\) gives \(e_1=0\), \(e_2=-2\), \(e_3=x_2\); eliminating,
\(x_2^3-3x_2=0\) and each of the three values leaves a separable quadratic
for the ordered pair \((x_1,x_3)\): six distinct reduced points.  The
independent trace-form computation on the six-dimensional quotient gives
determinant \(93312\ne0\).  Both routes: **étale**, so the Lemma applies
and MM 2-32 is closed.

Certificate: `notes/cubic-threefolds-tasks/c925-fable-flag-threefold-etale.py`
(sha256 `088254a48f562aa4640090b7709ce3ba5bc5f8ed1871e74dacc4a74829db59e4`),
output `c925-fable-flag-threefold-etale-output.txt` (sha256
`4f2869662246113220ac8216cbb55d74ca764edbbbbf57f47b8b1d9c8526d28c`); replay
`uv run --with sympy python3 notes/cubic-threefolds-tasks/c925-fable-flag-threefold-etale.py`
(about two seconds; the quotient dimensions 6/6 and the reduced-point count
are asserted).

## 4. Residue of the tail after this note

1. **Primitive non-toric \(b_3=0\) Fanos that are neither chains nor
   homogeneous.**  The identified concrete case is MM 2-24, the
   \((1,2)\) divisor in \(\mathbf P^2\times\mathbf P^2\) — a conic bundle
   over \(\mathbf P^2\) with cubic discriminant, \(h^{1,2}=0\).  The period
   pipeline cannot certify it (\(\rho=2\): the anticanonical-cyclic part
   need not exhaust \(H^{\mathrm{even}}\)); the natural sources for its
   small quantum products are Ciolli's computations for low-rank Fano
   threefolds or a quantum-Lefschetz/Birkhoff evaluation of its
   two-parameter \(I\)-function.  A complete enumeration of the \(b_3=0\)
   Mori--Mukai families against the chain criterion (which constructions
   bottom out only in closed bases) still needs the classification table
   read against §2 — queued; 2-24 is the only primitive so far identified
   that no argument here reaches.
2. **Non-Fano carriers not presented as chains over closed bases.**  Open
   as before; the structural irregular-Hodge lead remains the candidate
   uniform closure.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | One étale point closes the whole small locus and every bulk curve over it (upgraded Hensel lemma). | §1; repairs the "special fibre" phrasing of the tail-reduction report. |
| settled | Blow-up chains propagate ledger semisimplicity; \(b_3=0\) makes the rational-centre hypothesis automatic; covers all \(S\times\mathbf P^1\) and every \(\rho\ge6\) Fano. | §2, via Iritani 5.18(1). |
| settled | MM 2-32 (flag threefold) étale by two independent exact routes. | §3, certificate. |
| open, reduced | MM 2-24 and the completion of the \(b_3=0\) Mori--Mukai enumeration against the chain criterion. | §4.1. |
| open | Non-Fano non-chain carriers; irregular-Hodge structural lead. | §4.2, unchanged. |

No manufactured mysteries: the tail is now two named residues.

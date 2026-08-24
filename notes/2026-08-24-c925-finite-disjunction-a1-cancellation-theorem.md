# C925: a finite-disjunction birational A1-cancellation theorem

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Theorem

Let \(X/\mathbf Q\) be either explicit Tschinkel--Zhang cubic threefold in
Propositions 5.1--5.2, and put

\[
Y_i=X\times\mathbf P^i,\qquad i=1,2,3.
\]

Using the \(m=1\) irrationality theorem and the uniform C925 level-four
rationality theorem,

\[
\boxed{\text{at least one of }Y_1,Y_2,Y_3\text{ is nonrational over }
\mathbf Q\text{ while }Y_i\times\mathbf A^1\text{ is rational}.} \tag{1}
\]

The same assertion holds after base change to \(\mathbf C\). Thus the two
theorems together settle the existential form of birational
\(\mathbf A^1\)-cancellation in the negative for smooth projective varieties.
They do not yet identify which of the three displayed varieties is the
counterexample.

## Proof

Define over \(\mathbf Q\)

\[
s=s_{\mathbf Q}(X)=\min\{m\ge0:X\times\mathbf P^m\text{ is rational}\}.
\]

The \(m=1\) theorem over \(\mathbf C\) implies that
\(X\times\mathbf P^1\) is nonrational over \(\mathbf Q\): a
\(\mathbf Q\)-rational parametrization would remain rational after base
change.  The uniform OADP quotient theorem gives
\(X\times\mathbf P^4\) rational over \(\mathbf Q\). Therefore

\[
s\in\{2,3,4\}. \tag{2}
\]

Put \(i=s-1\). Minimality makes \(Y_i\) nonrational. On function fields,

\[
\mathbf Q(Y_i\times\mathbf A^1)
 =\mathbf Q(X)(t_1,\ldots,t_i,u)
 \cong\mathbf Q(X)(t_1,\ldots,t_s), \tag{3}
\]

and the last field is purely transcendental by the definition of \(s\).
Thus \(Y_i\times\mathbf A^1\) is rational. Equation (2) gives exactly the
three candidates in (1).

The complex statement follows either by repeating the minimal-threshold
argument over \(\mathbf C\), or by base-changing the rational side of (3)
and using the complex \(m=1\) lower bound.

## Constructive strength

Tschinkel--Zhang write immediately before Section 5:

> “It remains open to construct a nonrational variety \(X\) such that
> \(X\times\mathbf A^1\) is rational.”

Equation (1) proves the corresponding existential statement and confines
the witness to three varieties given by explicit equations.  It is a finite
disjunction, not an identified witness: deciding \(m=2\) or \(m=3\) selects
the first counterexample.  Accordingly the safe headline is

\[
\boxed{\text{existence with a three-element explicit candidate list},}
\]

not “an explicit single counterexample.”

## Exact threshold certificate

- `notes/cubic-threefolds-tasks/c925-finite-cancellation-disjunction-check.py`,
  SHA-256
  `05d74c899bbb3a2d7b1ad013fe81509c9466254bd1cbf92dbfac77d0c4c37ba8`;
- `notes/cubic-threefolds-tasks/c925-finite-cancellation-disjunction-check.json`,
  SHA-256
  `df06d643b51a08eb214f5d0981c7b76938c40fb64107a279788cfa31d0e719c4`.

Replay:

    python3 \
      notes/cubic-threefolds-tasks/c925-finite-cancellation-disjunction-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-finite-cancellation-disjunction-check.json

The checker exhausts \(s=2,3,4\) and verifies the index and function-field
bookkeeping.  It is a regression witness for the finite implication, not
independent evidence for either geometric premise.

## Evidence and priority boundary

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1, dated August 21,
  2026. **Read depth: full for the quoted boundary and relevant argument** —
  introduction, Sections 2--5, especially the “Levels of stable rationality”
  paragraph and Propositions 5.1--5.2. PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
- The only DOI currently registered for that manuscript is the DataCite
  arXiv DOI `10.48550/arXiv.2608.20029`; a Crossref and OpenAlex check on
  August 24, 2026 found no publisher DOI.
- A bounded August 24 screen of arXiv and OpenAlex for the exact birational
  \(\mathbf A^1\)-cancellation formulation found no intervening result. This
  supports priority language only relative to the source's August 21 open
  statement and that bounded screen; it is not a substitute for a full
  historical literature audit.
- The geometric premises are documented separately in the local \(m=1\)
  proof packet and
  `notes/2026-08-24-c925-uniform-level-four-rationality.md`.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Existential birational \(\mathbf A^1\)-cancellation | Minimal threshold \(s\in\{2,3,4\}\). |
| settled | Smooth projective candidate list | \(X\times\mathbf P^i\), \(1\le i\le3\). |
| open | Identified counterexample | Equivalent to locating \(s(X)\). |
| open | Full priority claim | Requires a broader historical audit than the bounded current screen. |

**Resume line:** go C925 cubic-threefolds — the \(m=1/m=4\) sandwich gives
existence of birational A1 cancellation with three explicit candidates;
locate \(s\in\{2,3,4\}\) through the intrinsic type-\(I_1\) Cox quotient.

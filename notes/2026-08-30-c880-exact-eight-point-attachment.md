# C880: exact eight-point attachment complexity

## Result

The eight-point attachment constant is

\[
g(8)=17.
\]

Here (g(8)) is the least number of triples of eight known points whose
alignment answers determine one new point's attachment for every two-graph.
The previous certified interval was (15\le g(8)\le17).

The lower bound is a finite theorem with proof traces, not a timeout. Exact
cardinality 15 and exact cardinality 16 are both UNSAT. Exact cardinality 17 is
SAT, and its family is independently replayed by the public Rust attachment
checker. Since separation is monotone under adding triples, the two UNSAT
decisions exclude every family of size at most 16.
In fact the (k=16) decision alone is load-bearing: any smaller separating
family can be padded to size 16. The (k=15) trace is retained as a consistency
check against the previous lower-bound frontier.

## Exact reduction

For each nontrivial attachment cut (S\mid \bar S), form a graph whose vertices
are the crossing point-pairs. A triple meeting both sides joins the two crossing
pairs that share its minority point. A selected triple family separates the
cut exactly when this graph is non-bipartite. A graph is non-bipartite exactly
when it contains an odd-cardinality Eulerian subgraph.

The CNF has selection variables (x_t) and, for every cut, witness variables
(y_{S,t}). It enforces

- (y_{S,t}\Rightarrow x_t);
- even (y)-degree at every crossing-pair vertex; and
- odd total (y)-cardinality for every cut.

The XORs use linear Tseitin chains. Sinz counters impose the exact requested
cardinality. Point transitivity fixes triple `0 = (0,1,2)`, after which a full
lex-leader over its (S_3\times S_5) stabilizer retains one representative of
every orbit. The 27,139 previously certified inclusion-minimal context masks of
weight at most 16 are added as redundant propagation clauses. Removing them
does not change the semantics; the full cutwise parity system remains present.

Both (k=15) and (k=16) compile to 60,880 variables and 322,844 clauses.
The generator also has a direct universal-context mode, which eliminates the
Eulerian witnesses and emits all 2,122,240 cut-colouring clauses. That is an
independent formulation for future solver comparisons; the compact parity CNF
is the proof-producing formulation used here.

## Certificates and independent replay

Kissat 4.0.4 returned UNSAT for (k=15) and (k=16), emitting binary DRAT.
`drat-trim` independently verified both traces:

| exact size | CNF SHA-256 | proof bytes | core input clauses | core lemmas | resolution steps | verdict |
|---:|---|---:|---:|---:|---:|---|
| 15 | `dcb428f8f7171607807fbf00a9ffa9c71af7cf0f7862993421da249c239b5046` | 48,712,406 | 38,554 | 428,171 | 11,640,506 | `VERIFIED` |
| 16 | `d734536f7797e9554ba0dd7fb4bf29fc2dc53cbc1efb60d63ed42c868bc1e948` | 131,410,187 | 85,389 | 1,645,125 | 46,593,312 | `VERIFIED` |

The compact tracked certificates are compressed DRAT artifacts named in the
adjacent manifest. The manifest records compressed and uncompressed hashes,
byte counts, solver/checker revisions, and the exact 17-triple witness.

The (k=17) SAT witness found in the same encoding has triple indices

```text
0,5,9,10,24,25,35,45,46,48,49,50,51,52,53,54,55
```

and the independent public Rust checker returns
`points=8 selected=17 separates=true`. The older, differently shaped
17-triple witness remains an additional independent upper-bound certificate.

## Reproduction

Working directory for every command below:
`/home/tavis/src/othello`.

Generate either lower-bound CNF (replace `K` by 15 or 16):

```bash
python ergodis-private/python/c880_alignment_sat.py \
  --bound K --lower K \
  --masks notes/2026-08-19-c880-cpb-masks-m8w16.json \
  --lex-symmetry --cnf c880-kK.cnf
```

Solve while streaming the proof to disk, then replay the tracked compressed
certificate without materializing an uncompressed copy:

```bash
/home/tavis/.cache/ergodis-external/kissat/build/kissat \
  --quiet c880-kK.cnf c880-kK.drat > c880-kK.model
zstd -dc notes/2026-08-30-c880-g8-kK.drat.zst | \
  /home/tavis/.cache/ergodis-external/drat-trim/drat-trim c880-kK.cnf
```

The expected solver exit code is 20 and the replay terminates with
`s VERIFIED`. Unit-check the XOR, counter, and lex-leader primitives with:

```bash
PYTHONPATH=ergodis-private/python \
  python -m unittest -v test_c880_alignment_sat
```

Generate and replay the upper bound with `--bound 17 --lower 17`, then:

```bash
python ergodis-private/python/c880_alignment_sat.py \
  --bound 17 --model c880-k17.model --result c880-k17-witness.json
cd papers/complete-repair-ports/ergodis
ERGODIS_ALIGNMENT_MODEL=/home/tavis/src/othello/c880-k17.model \
  ./target/release/examples/alignment_attachment
```

## Trusted boundary

The result trusts the cut-graph characterization, the elementary odd-Eulerian
characterization of non-bipartiteness, the deterministic CNF generator, the
previously certified low-weight mask artifact, Kissat's DRAT emission, and
`drat-trim`'s proof checking. The low-weight masks are redundant, so a defect in
that artifact could only make the CNF stronger; their validity is nevertheless
load-bearing for equisatisfiability and is covered by their earlier exhaustive
certificate. The upper bound crosses implementations: the SAT model is decoded
in Python and replayed by the Rust cut-graph checker.

This result settles only the finite attachment constant (g(8)). It does not
settle C880's conference-matrix counting question, the (8\le n\le18)
adaptive/nonadaptive comparison, or the asymptotic nonadaptive lower constant.

## Mystery ledger

- **Settled:** the missing eight-point attachment constant is 17, not 15 or 16.
- **Settled:** the old memory pathology was representational. The exact CNF is
  6.3 MiB, and the proof search uses tens of MiB rather than a (2^{27}) state
  table.
- **Settled:** the effective theorem-driven combination is low-weight context
  clauses plus exact Eulerian parity witnesses plus semantic symmetry.
- **Not settled:** a short human counting proof of the 17 lower bound. The
  present lower bound is proof-producing finite computation.
- **Not settled:** the remaining, separate open items on the C880 task card.

## EJ / TT closeout

**EJ.** The conclusion is stated only in its finite domain. UNSAT is backed by
replayable proof traces, the upper witness crosses implementations, and the
reduction does not promote a timeout or a partial mask family into a theorem.

**TT.** The transitivity and lex-leader reductions preserve at least one member
of every solution orbit; exact-cardinality search is sound because separation
is monotone; every cut is represented once; every parity witness is forced to
be both Eulerian and odd. Exhaustive unit tests cover the three custom CNF
primitives. No manuscript text was changed.

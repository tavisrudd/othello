# C272: N1 continuation-graph-rigidity manuscript

**Lane:** `continuation`

**Verdict:** `MANUSCRIPT DRAFT; N1-ONLY BOUNDARY PRESERVED`

## Deliverable

The working manuscript is
`papers/continuation-graph-rigidity/continuation_graph_rigidity.tex`. It is a
self-contained short paper whose headline is the proved stable-range theorem

\[
\operatorname{Aut}(G_K)=\operatorname{Stab}_{\mathrm{P\Gamma L}(3,q)}(K),
\qquad q\ge 13,
\]

for a four-point projective frame `K` in `PG(2,q)`. The manuscript includes:

- the continuation graph's linear-hypergraph and nonlinear-code models;
- intrinsic recovery of tangent traces and their selected-centre classes;
- the exact one-, two-, and three-point obstructions;
- the four-coordinate frame normal form;
- complete punctured-isotopy and shifted-isotopy proofs forcing Frobenius;
- the `M_(0,5)` and cross-ratio-graph prior-art boundary; and
- the open extremal parameters `m(k)` and `r(k)`.

Ruling D3 is preserved literally. Full continuation-complex reconstruction is
absent from the abstract and contribution statement and appears only in a
scope-and-open-problems remarks section. That section explicitly places the
completion mechanism beside the Bruck--Batten--Beutelspacher--Metsch corpus and
retains the Drake--Sane/Metsch full-text diligence gate.

## Exact scope

The draft claims the uniform theorem only for prime powers `q>=13`. It records
the extra `q=5` symmetry and leaves `q=7,8,9,11` unclassified. It does not claim
that the graph reconstructs every ambient line for a general arc, that the
small-order boundary is complete, or that reconstruction determines any game
value. The Lean formalization remains C273.

## Validation

Run from the repository root:

```text
git diff --check -- papers/continuation-graph-rigidity
perl -ne 'while(/\\cite(?:\[[^]]*\])?\{([^}]*)\}/g){for(split /,/, $1){$c{$_}=1}} while(/\\bibitem\{([^}]*)\}/g){$b{$1}=1} END{for(sort keys %c){print "missing citation: $_\n" unless $b{$_}} for(sort keys %b){print "unused bibliography: $_\n" unless $c{$_}}}' papers/continuation-graph-rigidity/continuation_graph_rigidity.tex
awk '/\\begin\{/{b++} /\\end\{/{e++} END{print "begin markers=" b ", end markers=" e}' papers/continuation-graph-rigidity/continuation_graph_rigidity.tex
```

The whitespace check is clean, every citation key has one bibliography entry
and every bibliography entry is used, and the source has `31` begin markers and
`31` end markers. The environment has no `latexmk`, `pdflatex`, `tectonic`,
`chktex`, or `lacheck`; PDF compilation is therefore not claimed. That is a
release-stage check, not part of this manuscript-draft task.

## Consumer-ready interface

C295 may consume the theorem statement, graph convention, stable range, and
exception boundary from this report and the manuscript read-only. Its general
intrinsic reconstruction work must still supply recovery beyond automorphism
equality. The bounded q=11 pilot remains outside the stable range.

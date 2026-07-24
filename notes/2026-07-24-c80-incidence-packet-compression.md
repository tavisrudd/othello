# C80 — opponent-marked incidence packet compression

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-24.

## Verdict

The q=17 strict-overload response DAG has a clean, equivariant bulk packet,
but the packet does **not** prove uniform escape-root membership.

For a positive-overload state `S` and a marked legal opponent move `o`, define

```text
Rmax(S,o) =
  argmin { Ω(S+o+p) : p is a legal reply to S+o }.
```

Equivalently, `Rmax` is the set of replies giving the largest total overload
drop from `S`.  It is defined entirely by the marked residual incidence
hypergraph.  Every incidence isomorphism carrying `(S,o)` to `(S',o')`
carries `Rmax(S,o)` to `Rmax(S',o')`, because it preserves legality and
`Ω`.

Exact replay of the already-certified `K_Ω` DAG gives:

| domain | certified edges | `Rmax` contains a lower-`K_Ω` reply |
| --- | ---: | ---: |
| q=11, all 135 raw P on-conic roots | 2,720 | 2,720 |
| q=13, all five frozen P roots | 355 | 355 |
| q=17, all five frozen P roots | 17,355 | 16,857 |

The q=17 failures are confined to the head: 401 edges at selected size four
and 97 at selected size six.  From selected size eight onward,
`Rmax` covers all 16,857 tested certified edges.  An out-of-sample q=19
probe on the kernel root `{15,16,17,18}` reproduces the split:

| selected size | certified edges | `Rmax` covered |
| ---: | ---: | ---: |
| 4 | 148 | 116 |
| 6 | 7,423 | 7,140 |
| 8 | 21,743 | 21,743 |

This is the requested opponent-marked incidence compression **for the tested
bulk**, not the requested uniform theorem.  The naive claim
`Rmax` always contains a lower-kernel reply is already false on 498 q=17
head transitions and 315 transitions in the stated q=19 probe.

## 1. Why this is an incidence packet

Let `L(S)` be the legal-point set and let `A(S)` be the lines carrying no
fixed or selected point, hence still having residual capacity two.  Then

```text
Ω(S) = Σ_{ell in A(S)} max(0, |L(S)∩ell| - 2).
```

For a marked pair `(o,p)`, every term of `Ω(S+o+p)` is determined by:

- the active capacity-two lines through `o` or `p`;
- the legal points removed on each other active line by the new secants; and
- the resulting active-line legal loads.

Thus `Rmax` uses no P/N value, Grundy number, coordinate ordering, or
recursive-kernel membership.  The packet is set-valued, so the proof
quantifier has the useful form

```text
for every opponent o, there exists p in Rmax(S,o) ...
```

rather than committing to a value-blind point selector.

If this existential clause held recursively down to `Y_NK`, ordinary
induction on `Ω` would prove membership in `K_Ω`, hence P.  The finite replay
proves that implication on the listed DAG portions.  It does not prove the
existential clause for arbitrary odd q or arbitrary descendants.

## 2. The head obstruction is not one missing tie-break

Five elementary fallback packets were tested on the 498 q=17 `Rmax`
failures.  They maximize, separately:

1. legal points killed by the reply;
2. overload mass on active lines through the reply;
3. the number of overloaded lines through the reply;
4. the largest active-line load through the reply; or
5. the legal load on the opponent--reply line.

The best individual fallback is item 5, covering 393/498 failures.  The
union of all five covers 486/498.  Twelve transitions evade every one of
these maxima.  In each of those twelve, the lower-kernel reply is unique;
the certificate records the selected conic parameters, selected intruders,
marked opponent, reply, and incidence score.

The complete seven-coordinate marked score used in the audit is

```text
(Ω drop,
 legal kills,
 overload mass through reply,
 overloaded-line count through reply,
 maximum line load through reply,
 negative target legal count,
 opponent--reply line legal load).
```

Across the q=17 head failures it has 3,964 distinct vectors:

```text
388 kernel-pure, 3,551 nonkernel-pure, 25 mixed.
```

Every one of the 498 transitions has a kernel reply in a locally pure score
class, and also one whose vector is kernel-pure over this finite q=17
domain.  That is not an algebraic compression: it is a 388-row,
q-specific lookup table, and 25 exact score collisions remain value-mixed.
Promoting it would repeat the static-fingerprint error already excluded by
C75.

## 3. What the replay proves—and does not

The strongest proved finite statement is:

> On the selected q=11/q=13/q=17 strict-kernel DAGs, maximal overload drop
> is a complete response packet except at the q=17 size-four and size-six
> head.  On the tested q=19 root DAG it is complete at selected size eight,
> but not at sizes four or six.

The selected-size-eight boundary is empirical.  It is not asserted for
every eight-cap, every kernel state, every q=19 root, or every odd field.
The q=19 scope is exactly one root and the chosen strict-kernel DAG through
selected size eight.

There is also a useful quantifier warning.  On every certified q=11/q=13/q=17
edge, the marked opponent move alone already decreases `Ω` (minimum observed
drops `9,1,1`).  Therefore strict descent often places no restriction on the
reply; the reply must still carry game value.  In the q=19 head probe,
29/29,314 opponent moves have zero immediate drop, so this simplification is
not uniform.  In neither case does maximizing an incidence loss prove that
the target is P: impartial-game value is not monotone under deletion of
options.

Consequently C82 remains gated.  `Rmax` is countable and equivariant, but
the missing theorem is exactly the existence of a lower-kernel member in
the packet, plus a separate rule for the head.

## 4. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Generate and check:

```text
python3 rust/scripts/c80_incidence_packet_mine.py
python3 rust/scripts/c80_incidence_packet_mine.py --check
```

Evidence bundle:

- script: `rust/scripts/c80_incidence_packet_mine.py`,
  18,178 bytes,
  SHA-256
  `98f00b5e1dab408153aef55525abae8831b2e6a1f3b641e9604fabefee09daad`;
- output: `notes/2026-07-24-c80-incidence-packet-mine.json`,
  45,660 bytes,
  SHA-256
  `d873e1b2b7a57fa69185ebcacd16e39d20109d80cee6a1e3bf9c5a9be2268e84`;
- strict-kernel implementation:
  `rust/scripts/c80_strict_overload_kernel.py`,
  SHA-256
  `444ee995dd84cd6c8702a16688e133cea46c0ae10e65511c9f2fc1db68a5e206`;
- frozen q=13/q=17 input:
  `notes/data/c20-q13-q17-states.jsonl.gz`,
  SHA-256
  `952f189cc37bac36026238d75bccffb7feb560644582bf8c6373789a98f43f4d`.

The computation is deterministic and `--check` requires byte-for-byte
identity.  It independently recomputes every local incidence score, but it
does not independently reimplement `K_Ω`; kernel labels and response DAGs
come from the previously checked strict-kernel implementation.  Exact cap
minimax is not used by this mining pass.  The q=19 root is supplied
explicitly and is not claimed to represent the other twelve frozen q=19
roots.

## `ej` + `tt` closeout

The cheap upgrade is the head/bulk decomposition.  The first packet tested
is not merely high-coverage: it is exact on all tested q=11/q=13 edges, all
tested q=17 edges from size eight onward, and all size-eight edges in the
q=19 out-of-sample probe.  That makes a constrained exchange lemma a sharper
target than another global feature sweep.

The Tao-style quantifier is set-valued and orbit-compatible:

```text
∀ marked opponent o, ∃ p in Rmax(S,o) with lower-kernel target.
```

The next proof attempt should ask for an exchange or orbit-intersection
argument establishing this statement on a structurally defined bulk family,
not for a canonical maximizing point.  Separately, canonicalize the twelve
q=17 residual head exceptions under the marked-state stabilizer.  If they
collapse to one or two transport orbits, the head can be stated as a small
algebraic packet; if not, the 388-vector growth is an early falsifier.

No free uniform membership proof emerges from the packet: the exact
P-preservation clause remains unexplained, and deletion/maximal-load
monotonicity cannot supply it.

## Mystery ledger

- **[SETTLED finite] Is there a natural opponent-marked incidence packet in
  the q=17 kernel?** Yes: `Rmax`; it covers 97.1% of all certified q=17
  edges and every tested edge from selected size eight onward.
- **[SETTLED negative] Does `Rmax` prove escape-root membership by itself?**
  No: 498 q=17 head transitions and 315 transitions in the stated q=19
  probe have no lower-kernel maximal-drop reply.
- **[SETTLED negative] Do elementary incidence-maximizing fallbacks close
  the q=17 head?** No: their union misses twelve transitions.
- **[OPEN — C80] Why does the tested bulk admit `Rmax` responses?** Exact
  evidence gap: no exchange, orbit-intersection, or residual-hypergraph
  theorem turns maximal overload drop into lower-kernel membership.
- **[OPEN — C80] Why selected size eight?** It may reflect a genuine
  rank-three residual threshold or only the chosen finite DAGs.  The gate is
  a canonical all-root q=19 head/bulk replay followed by an isomorphism-level
  statement; no universal eight-cap claim is licensed.
- **[OPEN — C80] What are the twelve q=17 exceptions intrinsically?** The
  certificate gives coordinates and unique replies, but their
  marked-stabilizer orbit count is not yet computed.
- **[OPEN — C82, still gated] Can the packet be counted uniformly?** `Rmax`
  is equivariant and incidence-defined, but counting is useless until C80
  proves the packet contains a lower-kernel response and supplies the head
  packet.

## Vibe

This is a real compression and a useful falsifier, but not the crown.  The
bulk has become a single clean existential packet; the remaining danger is
concentrated exactly where game value is most rigid, in the first two
exchanges.

go C80 cap canonicalize the twelve q17 marked-head exceptions and prove or
falsify a bulk exchange lemma for the maximal-overload-drop packet

# C926 — mod-11 completeness certificate for the conference node count

**Lane:** `clebsch` (Paper V, `papers/chordal-conference-reconstruction/`)
**Date:** 2026-08-20
**Status:** delivered; manuscript untouched by explicit user instruction, so the
strengthening is proposed below rather than applied.

## What is certified

Over \(\F_{11}\), let \(c_B\) be the tracked \(A_5\)-invariant conference
triangle cubic on \(\PP(A_0)=\PP^4\) and let \(J=(\partial_0c_B,\dots,\partial_4c_B)\)
be its Jacobian ideal. Then:

1. \(\operatorname{Proj}(\F_{11}[x_0,\dots,x_4]/J)\) is zero-dimensional of
   degree six;
2. it has exactly six \(\F_{11}\)-rational points, namely the frame points
   \(p_a=[\mathbf 1-6e_a]\), \(a=0,\dots,5\); and
3. the Hessian of \(c_B\) has rank four at each of them, so each is an ordinary
   node and carries local multiplicity one.

Degree six against six multiplicity-one points leaves no residue. Hence the
singular scheme of \(\{c_B=0\}\) is exactly those six reduced ordinary nodes,
and this survives base change to \(\overline{\F}_{11}\), because the singular
subscheme is cut by the partials and commutes with field extension. This is the
completeness half that Proposition *Nodes persist in characteristic eleven*
(`prop:nodes-mod-eleven`) does not supply: that proposition proves each \(p_a\)
is an ordinary node and isolated, not that nothing else is singular.

The delegated step is the Gröbner dimension-and-degree computation alone. The
reduction that turns it into the geometric statement is written above and is
human.

**Control, same computation on the chordal sheet cubic \(h\):** the singular
scheme of \(\{h=0\}\) has projective dimension one, degree four, and Hilbert
polynomial \(4d+1\) — the Hilbert polynomial of a rational normal quartic
curve. An isolated point beside that curve would raise the constant term, so
the control independently confirms mod 11 what Lemma `lem:hankel-singular-locus`
proves structurally: the chordal singular locus carries no isolated point. The
non-isomorphism argument of Proposition `prop:nodes-mod-eleven` therefore rests
on two mutually independent legs.

## Exact numbers

| quantity | conference cubic \(c_B\) | chordal cubic \(h\) |
|---|---|---|
| reduced Gröbner basis size (degrevlex)  | 15                        | 8                       |
| Hilbert numerator over \((1-t)^5\)      | \(1-5t^2+11t^4-19t^6+16t^7-4t^8\) | \(1-5t^2+3t^3+7t^4-10t^5+5t^6-t^7\) |
| numerator after dividing by \((1-t)^k\) | \(k=4\); \(1+4t+5t^2-4t^4\) | \(k=3\); \(1+3t+t^2-2t^3+t^4\) |
| projective dimension                     | 0                         | 1                       |
| projective degree                        | 6                         | 4                       |
| eventual Hilbert polynomial              | \(6\)                     | \(4d+1\)                |
| \(\F_{11}\)-rational singular points     | 6                         | 12                      |
| Hessian ranks at those points            | 4, 4, 4, 4, 4, 4          | 3 (twelvefold)          |

The six conference singular points in augmentation coordinates
\((y_0,\dots,y_4)\), each normalized to leading entry one, are
\((1,1,1,1,1)\), \((1,1,1,1,6)\), \((1,1,1,6,1)\), \((1,1,6,1,1)\),
\((1,2,2,2,2)\), \((1,6,1,1,1)\); the program checks that this set equals
\(\{[\mathbf 1-6e_a]\}\) computed from the formula.

The chordal Hessian rank three at all twelve rational points is the expected
corank-two behaviour along a curve of singularities, not a separate claim.

## Bundle

All four files are tracked; the first three are new.

| path | bytes | SHA-256 |
|---|---|---|
| `papers/chordal-conference-reconstruction/verification/evidence/conference_node_completeness.py`   | 22798 | `18fa8652b3256f6e7756edb26cd633af935984e16d1fb601f7953f1bbe259f67` |
| `papers/chordal-conference-reconstruction/verification/evidence/conference_node_completeness.json` | 8073  | `2d3621207f01f0243d50b0a22d24d13add9f1e56c6a7a08129fb23f5376bcf4e` |
| `papers/chordal-conference-reconstruction/verification/evidence/conference_node_completeness.sing` | 2195  | `9c888b3e865aeb71f988b886f97923583f9f8635fb1e09afe630c83d4997fb2f` |
| `papers/chordal-conference-reconstruction/verification/evidence/paper_ii_chordal_axis.json` (input) | 11079 | `3dfa23bfc71bbe87fae1d51c7656a57dbf6cfcb86ac537b41120d2d76465afc1` |

Certificate schema: `paper-v-conference-node-completeness-v1`, verdict
`EXACTLY_SIX_REDUCED_NODES`.

## Replay

From `papers/chordal-conference-reconstruction/`:

```sh
make evidence                                    # both checkers; the new one prints
                                                 # CHECK OK (EXACTLY_SIX_REDUCED_NODES)
nix shell nixpkgs#python3 -c python3 \
  verification/evidence/conference_node_completeness.py --check
nix shell nixpkgs#python3 -c python3 \
  verification/evidence/conference_node_completeness.py --write   # regenerate
```

Independent computer-algebra replay, not part of `make check` because it needs
Singular:

```sh
cd papers/chordal-conference-reconstruction/verification/evidence
nix shell nixpkgs#singular --command Singular -q conference_node_completeness.sing
```

Recorded output on 2026-08-20 (Singular 4.4.1):

```
conference dim/deg:        1   // dimension (proj.) = 0   // degree (proj.) = 6
conference radical dim/deg:1   // dimension (proj.) = 0   // degree (proj.) = 6
chordal dim/deg:           2   // dimension (proj.) = 1   // degree (proj.) = 4
```

The radical line is an extra fact the Python checker does not compute: the
radical has the same degree six, so the conference singular scheme is reduced
on Singular's own reckoning as well as by the multiplicity-one argument.

## Independence and trust boundary

Three separate cross-checks sit inside the bundle, so no single implementation
carries the result alone.

- The conference cubic is rebuilt inside the new checker from a
  pentagon-normalized order-six conference matrix \(B\) with \(B^2=5I\), and the
  axis permutation \((0,1,2,3,5,4)\) carries its triangle cubic onto the tracked
  `conference_triangle_cubic` of `paper_ii_chordal_axis.json` on the nose. The
  new program therefore does not inherit the older program's isotypic-projection
  route.
- The Hilbert function is computed twice in degrees three through six: once by
  counting standard monomials against the initial-ideal staircase, and once by
  row-reducing the graded pieces of the Jacobian ideal with no Gröbner input at
  all. Both give \(10,6,6,6\) for the conference cubic and \(13,17,21,25\) for
  the chordal cubic.
- The Buchberger run self-checks: every Jacobian generator and every S-pair
  reduces to zero against the returned basis (`groebner_basis_verified`).
- Singular's own engine reproduces both dimension-and-degree pairs.

Trusted boundary: exact integer arithmetic modulo 11 in the Python standard
library, plus, for the optional replay, Singular's Gröbner and
primary-decomposition code. Nothing here is floating point and nothing is
random.

## What this does not certify

- Nothing in characteristic zero. The rational node count of
  \cite{RuddRigidity2026} is a separate, already published statement; this
  computation neither replays nor depends on it.
- Nothing about the other members of the invariant pencil. Only \(c_B\) and the
  chordal sheet cubic \(h\) were computed.
- Nothing about the manuscript's other claims. `make check` was already green,
  and this adds a second evidence terminal to it without touching any existing
  one.

## Proposed manuscript strengthening (not applied)

The manuscript was left untouched. If the exactness is wanted in the paper, the
smallest correct change is a remark after `prop:nodes-mod-eleven`, keeping that
proposition's structural argument as the load-bearing one:

> **Remark (completeness of the node count).** Proposition \ref{prop:nodes-mod-eleven}
> exhibits six nodes and does not by itself exclude further singular points. The
> stronger statement is that the singular scheme of \(c_B=0\) is exactly these
> six reduced points, over \(\overline{\F}_{11}\) as well. Its one delegated
> step is a Gröbner dimension-and-degree computation: the paper-owned checker
> `verification/evidence/conference_node_completeness.py` returns Hilbert
> numerator \(1-5t^2+11t^4-19t^6+16t^7-4t^8\) for the conference Jacobian ideal
> over \(\F_{11}\) in the degree-reverse-lexicographic order, divisible by
> \((1-t)^4\) with quotient \(1+4t+5t^2-4t^4\); the projective scheme is
> therefore finite of degree six. Six distinct singular points with rank-four
> Hessian account for that degree with multiplicity one each, so nothing else
> is singular and the scheme is reduced. The same run gives the chordal
> Jacobian scheme Hilbert polynomial \(4d+1\), which leaves no room for an
> isolated point beside the rational normal quartic.

Two smaller consequential edits would follow if that remark lands: the sentence
in Section *Paper II placement* could read "exactly six ordinary nodes" where it
now reads "six ordinary nodes", and the abstract could say "exactly six isolated
nodes". Both are optional; no argument in the paper uses exactness, so the
current text stays correct without them.

The verification appendix would also need one sentence naming the second
checker, its schema `paper-v-conference-node-completeness-v1`, and its accepted
terminal line `CHECK OK (EXACTLY_SIX_REDUCED_NODES)`, since that appendix
currently describes `make evidence` as returning a single verdict.

## Mystery ledger

- **Settled by this pass.** Whether reduction modulo 11 could acquire extra
  singular points beyond the six rational ones: it cannot; the degree is exactly
  six. This was the only reason the node count had been weakened from "exactly
  six" to "isolated nodes" when the citation to \cite{RuddRigidity2026} was
  removed in `f34fefd15`.
- **Open, small, no owner needed.** The Hilbert numerator
  \(1-5t^2+11t^4-19t^6+16t^7-4t^8\) is not the numerator of a complete
  intersection, which is expected — five quadrics in five variables cutting a
  degree-six scheme cannot be one — but its shape has not been matched against a
  known resolution of the six-node configuration. The six nodes are a frame in
  \(\PP^4\), so the ideal is a well-studied object and a structural reading is
  likely available; nothing in Paper V needs it.
- **Not a mystery.** The chordal control's twelve rational singular points are
  just the \(\F_{11}\)-points of the rational normal quartic, already recorded
  in `paper_ii_chordal_axis.json`.

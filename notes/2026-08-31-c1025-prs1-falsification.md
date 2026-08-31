# C1025 — Testing Conjecture PRS-1 outside its sampled region

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** in progress (written incrementally)

Predecessors: `notes/2026-08-31-c1024-incidence-threshold.md` (which raised the
sampling-artifact risk and proposed the `(17,7)` test), and
`notes/2026-08-31-c1018-prs-deephole-conjecture.md` §6 (Conjecture PRS-1 and its
verified domain).  Notation is theirs.

## Part 1, step 1 — the premise, settled first

C1024 §6 item 2 recorded the `(17, m=7)` cell at `q = 29` as out of budget and
attributed the fix to a claim of mine: *"the Hankel rank is bounded by `M` by
construction on a stratum, here 3"*.  Gate 2 of this task required proving that
before using it.

**The claim is false, and not marginally — the rank is generically full.**

Sampling stratum points uniformly and computing `rank H^{(j)}_s` for every `j`:

| carrier | `d` | `M` | ranks `j = 1 … d` | max rank | apolar degree `e` |
|---|---:|---:|---|---:|---:|
| `(9, m=3)`, `{1,4,7}`, `q=13`   | 8  | 3 | `2,3,4,5,4,3,2,1` | **5** | 5 |
| `(11, m=4)`, `{1,5,9}`, `q=13`  | 10 | 3 | `2,3,4,5,6,5,4,3,2,1` | **6** | 6 |
| `(17, m=7)`, `{1,8,15}`, `q=29` | 16 | 3 | `2,3,4,5,6,7,8,9,8,7,6,5,4,3,2,1` | **9** | 9 |

In every case the rank is exactly `min(j+1, d-j+1)` — the largest it can be for
a matrix of that shape — and the apolar degree is exactly `⌈(d+1)/2⌉`, the
generic value.  A stratum point is apolar-*generic*; it is special as a point of
`PG(d,q)`, not as a source of rank deficiency.  200, 50 and 30 samples
respectively, identical profile every time.

### What is actually true, and why it does not help

There *is* real structure, just not the structure I claimed.

> **Proposition (block decomposition).**  Let `s` lie on the stratum
> `{ s_i = 0 unless i ≡ a (mod m) }` of `PG(d,q)`, with compressed coefficient
> vector `g` of length `M`.  After permuting rows and columns by residue class
> mod `m`, `H^{(j)}_s` is block diagonal with `m` blocks: block `c` has columns
> `{u ∈ [0,j] : u ≡ c}` and rows `{v ∈ [0,d-j] : v ≡ a-c}`, and its entries are
> the `g` themselves.  Hence
> `rank H^{(j)}_s = Σ_c rank(B_c)` with
> `rank(B_c) ≤ min(|cols_c|, |rows_c|, M)`.

*Proof.*  `H[v][u] = s_{u+v}`, nonzero only when `u+v ≡ a (mod m)`, so `u ≡ c`
forces `v ≡ a-c`: entries vanish off those row/column pairings, giving the block
form.  Within block `c`, `u + v` runs through `I` and the entry is the
corresponding `g`.  Each `B_c` is a submatrix of a Hankel matrix of `g`, whose
rank is at most its length `M`. ∎

> **Corollary (the `M` bound is vacuous).**  On an `a = b = 1` carrier stratum,
> `d = 2 + m(M-1)`, and for every `j` and `c`,
> `min(|cols_c|, |rows_c|) ≤ ⌈min(j+1, d-j+1)/m⌉ ≤ ⌈(d+1)/(2m)⌉ =
> ⌈(M-1)/2 + 3/(2m)⌉ < M` for all `M ≥ 2`, `m ≥ 2`.
> So the constraint `rank(B_c) ≤ M` is **never active**: every block already has
> fewer than `M` rows or columns.

That is the whole story.  The blocks are genuinely there, but they are *too
small* for the `M` bound to constrain anything, so the bound I proposed is not
merely unproved, it is vacuous by a counting argument.  And summing the honest
per-block bound gives

```text
Σ_c min(|cols_c|, |rows_c|)  =  min(j+1, d-j+1) − O(m),
```

because the blocks partition the rows and columns nearly evenly — so the block
decomposition can improve on the generic rank bound by at most `m`, a term
independent of `q` and swamped by everything else.

**Verdict on Part 1: no usable a-priori rank bound exists on a stratum.**  Per
the task's instruction 3, I stop there rather than weakening the claim to fit
the code.  Rank was never the bottleneck in any case — the bottleneck is the
search for a split squarefree element of the kernel, and a full-rank kernel is
the worst case for that search too.

### Method note: the recurring pattern

This is the second time in this thread that a plausible claim of mine needed
checking before use — C1023's Lemma 1 turned out to be essentially Sylvester's
theorem, caught only at the end of that task; this rank bound turned out to be
vacuous, caught before any code was written.  The common failure is asserting a
structural bound from the *shape* of the situation ("the support is sparse, so
the rank must be small") without doing the one computation that tests it.  The
correction that worked both times is mechanical and cheap: before building on a
claim, spend one probe on the smallest instance where it could fail.  Both
catches came from the gate, not from my own re-reading, which is worth noting
about where to place gates in future tasks.

# OEIS submission draft — sum-free achievement game on Z_n

**DRAFT for the user to review and submit** (not submitted). Data + b-file are machine-generated from
`sumfree-solver/` (validated against the Python brute solver for n≤44; multiplier-quotient Rust
solver for the tail). The proven outcome law is in
[sumfree-game-theorem](2026-07-04-sumfree-game-theorem.md).

Companion b-file: `2026-07-04-sumfree-bfile.txt` (n=1..61; upload as the OEIS b-file).

---

### %N (Name)

Sprague–Grundy value of the sum-free achievement game on Z_n: two players alternately add an element
to a subset of Z_n keeping it sum-free (no a+b=c, a=b allowed), last player to move wins; a(n) is the
Grundy value of the empty starting position.

### %O (Offset)

`1` (first term is a(1) = 0).

### %S %T %U (Data)  — first 61 terms

```
0, 1, 1, 2, 0, 0, 0, 2, 1, 1, 0, 0, 0, 2, 2, 3, 0, 0, 0, 2, 1, 3, 0, 0, 0, 2, 1,
2, 0, 0, 0, 3, 1, 1, 0, 0, 0, 1, 1, 2, 0, 0, 0, 2, 1, 2, 0, 0, 0, 1, 1, 2, 0, 0,
0, 2, 1, 3, 0, 0, 0
```

### %C (Comments)

- A "sum-free set" in Z_n is a subset A with no solution of a+b=c (a,b,c in A, a=b allowed, so 2a in
  A is forbidden). Terminal positions of the game are exactly the maximal sum-free sets of Z_n
  (cf. the Cameron–Erdős maximal-sum-free-set counting problem). This is hypergraph Node-Kayles on
  the Schur 3-uniform hypergraph of Z_n. The element 0 is never playable (0+0=0).
- Outcome law (proved): for n >= 5, a(n) = 0 if and only if n == 0, 1, or 5 (mod 6); equivalently the
  second player wins iff n is congruent to 0, 1, or 5 mod 6. The first player wins iff n == 2, 3, 4
  (mod 6). (For n <= 4: a(1)=0, a(2)=a(3)>0, a(4)>0.)
- The Grundy values a(n) themselves are NOT eventually periodic — only the outcome (whether a(n)=0)
  is periodic mod 6. Values through n=61 lie in {0,1,2,3}.
- Proof sketch: the second player wins by a "mirror" (copying) strategy — negation x -> -x when
  gcd(n,6)=1, and translation x -> x + n/2 when 6 | n. The negation mirror has two obstructions,
  the fixed point n/2 (present iff 2|n) and the pair {n/3, 2n/3} (present iff 3|n); n mod 6 counts
  them, which determines the outcome. First player wins (one obstruction) by opening on it; second
  player wins (zero or two obstructions) by mirroring.

### %e (Example)

n=5: from the empty set the first player must move; every line of play ends with the second player
making the last move, so a(5)=0 (second-player win). n=8: a(8)=2 (first-player win).

### %Y (Cross-references)

Related deletion/achievement games and the maximal-sum-free-set counting problem. (If the graph
cousin — Node-Kayles on the quadratic-residue Cayley graph Cay^+(Z_p, QR) = Paley_p — is submitted,
cross-reference it here.)

### %K (Keywords)

`nonn` (nonnegative), `more` (more terms welcome). Consider `nice` (clean outcome law). Not `easy`
(each term is a game solve). The outcome-indicator sequence [a(n)=0?] could be a separate `easy`
companion entry (characteristic function of n == 0,1,5 mod 6).

### %A (Author)

Tavis Rudd (submitter), Jul 04 2026.

---

**Submission checklist for the user:**
1. Review the %N wording (OEIS prefers concise; the comment carries the detail).
2. Upload `2026-07-04-sumfree-bfile.txt` as the b-file (rename to `bXXXXXX.txt` after A-number
   assignment).
3. Decide keywords (`nice` is a maintainer call — leave it off the initial submission).
4. Optionally extend the b-file: the Rust solver in `sumfree-solver/` continues past n=61 (even n
   are the slow ones; n=62,64 need more time/memory). Re-run to lengthen before submitting if desired.
5. Optionally submit the companion outcome-indicator sequence (1 if n==0,1,5 mod 6 else 0) and/or the
   Paley graph game sequence.

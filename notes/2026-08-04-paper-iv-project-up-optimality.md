# Paper IV project-up cross-orbital optimality

**Lane:** `clebsch`
**Scope:** read-only exploration of the Paper-IV octahedral--toric bridge; no manuscript claim

## Verdict

Let (X=G/S_4) and (Y=G/D_{24}), each of size (91), for
(G=\operatorname{PGL}(2,13)).  The seven (G)-orbitals in (X\times Y)
are canonically distinguished by

\[
 (|\operatorname{Stab}(x)\cap\operatorname{Stab}(y)|,
   |\operatorname{supp}(x)\cap\operatorname{supp}(y)|),
\]

with signatures and degrees

\[
 (1,1)_{24},(1,3)_{24},(2,0)_{12},(2,1)_{12},
 (2,4)_{12},(6,0)_4,(8,4)_3.
\]

For every nonempty sum (R) of these seven binary orbital matrices, the
checker computes (\ker R\).  Among all (127) sums, the largest minimum
distance is (28), and the largest dimension at distance (28) is (15).
It is attained by

\[
 \boxed{\ker(C+J)=[91,15,28]_2},
\]

where (C) is the cubic (D_8)-orbital with signature ((8,4)) and (J)
is the all-ones matrix.  Its even subcode is

\[
 \ker C=[91,14,28]_2.
\]

The fourteen masks with nullity (14) all have the same kernel, and the
fourteen masks with nullity (15) all have the same kernel.  The next
smallest kernels have exact parameters among
([91,28,14]), ([91,28,12]), ([91,29,13]), and ([91,29,12]).
Every remaining kernel has dimension at least (40), where the binary
Hamming bound already gives distance at most (26).

Thus the cubic (D_8)-correspondence is optimal throughout the complete
binary cross-commutant, rather than only among the seven individual
orbitals.  This is a bounded statement about these (127) matrices, not a
claim of optimality among all binary length-(91) codes.

## Exact computation

The Python checker constructs (G), the two (91)-element support orbits,
and all vertex stabilizers from the tracked Paper-IV normal forms.  It labels
each cross-pair by the displayed two invariants, verifies that the seven
relations partition (X\times Y), and exhausts all nonzero orbital sums.
Binary row reduction gives a canonical basis for every kernel.  Equal bases
are deduplicated before enumeration.

There is one distinct kernel in dimensions (14) and (15), and two each
in dimensions (28) and (29).  The adjacent dependency-free Rust helper
Gray-enumerates all

\[
 2^{14},2^{15},2^{28},2^{28},2^{29},2^{29}
\]

words.  The Python implementation independently enumerates the complete
weight distributions in dimensions (14) and (15) and checks the same
minimum distances.  The larger four enumerations have no second full
implementation; their independent checks are canonical Gaussian bases,
exact mask multiplicities, total enumerated-word counts, and the exhibited
minimum-word counts.  Dimensions at least (40) are excluded from improving
distance (28) by an exact integer Hamming-volume calculation, not by
sampling.

## Replay and trust boundary

From the repository root:

```sh
python3 notes/2026-08-04-paper-iv-project-up-optimality.py --check
sha256sum -c notes/2026-08-04-paper-iv-project-up-optimality.sha256
```

The run is deterministic, uses no randomness, compiles the adjacent Rust
helper with the host `rustc -O`, and takes about five seconds on the present
host.  Its load-bearing mathematical inputs are
`papers/q13-passant-code/verification/verify_minimum_geometry.py` and
`notes/2026-08-04-c682-paper-iv-orbit-correspondence.py`.  The certificate is
canonical sorted JSON.  Compiler correctness, the Python and Rust runtimes,
and the two imported geometric constructors remain trusted.

The computation does not identify the new code in code tables, determine its
full automorphism group, or prove a coordinate-free description of its
seventy-eight minimum words.  Those are separate literature and structural
questions.

# C294 B1: exact one-port boundary-game semantics

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** B1 passed; the finite interface below is the input contract for B2

## Conclusion

A rooted attachment is not summarized by a tuple of standalone nimbers. Its exact one-port
summary is a finite, recursively interned transition DAG. A live node records:

1. what is left when an external move deletes the port but retains the attachment root;
2. what is left when the context plays the port and deletes the root;
3. every port-preserving attachment move, labelled by the nimber of the closed pieces it detaches
   and by the successor live node; and
4. every port-killing attachment move, labelled by the nimber it leaves after killing the port.

Equality of these DAGs is a congruence for gluing to every finite one-port Node--Kayles context.
This is the causal datum missing from
`(g(T), g(T-root), g(T-N[root]))`: mex has forgotten which port-preserving option leads to which
future boundary game.

## Closed and live states

All graphs below are finite and simple, and `g(X)` denotes the Node--Kayles Grundy value of `X`.
Closed states have no boundary port. They are represented exactly, for composition purposes, by
their nimber; disjoint closed states combine by xor.

A live state is either the empty attachment `0` or a rooted graph `A=(T,r)`. The only edge from
the context to `T` will be the edge from its distinguished port `b` to `r`. In C294 the initial
attachments and every nonempty rooted successor are trees, but the definition and proof do not
need acyclicity.

For a nonempty `A=(T,r)`, define two external-death values

```text
free(A) = g(T),       cut(A) = g(T-r).
```

`free` applies when a move elsewhere deletes `b` without selecting it, so `r` survives and all of
`T` becomes closed. `cut` applies when the context selects `b`, so `r` is deleted and `T-r`
becomes closed. Put `free(0)=cut(0)=0`.

## Option-labelled transition DAG

For each move `v != r` in `T`, let `F=T-N_T[v]`.

- If `r` survives, let `R` be the component of `F` containing `r` and let `D=F-R`. This is the
  port-preserving transition `(g(D), I(R,r))`.
- If `r` does not survive, the port is still live but the attachment is gone. This is the
  port-preserving transition `(g(F), I(0))`.

Playing `r` is qualitatively different: it deletes the shared port `b`. It is the port-killing
transition labelled `g(T-N_T[r])`. Thus the exact interface is defined recursively by

```text
I(0) = (free=0, cut=0, preserve={}, kill={})

I(T,r) = (
  free = g(T),
  cut = g(T-r),
  preserve = { (closed_offset(v), I(live_successor(v))) : v in T-r },
  kill = { g(T-N_T[r]) }
).
```

The braces denote sets: duplicate options do not affect mex. The recursion is finite because
every successor has fewer vertices. Retaining `kill` as a set makes the schema usable for a
future generalized one-port state with several boundary-adjacent legal moves; for the present
rooted attachment it is a singleton. Closed offsets stay on transitions rather than being xored
into a live-node label, because they must combine with the actual current context value.

This is the smallest causal, history-free interface needed by the one-port recurrence: it retains
no vertex names or attachment topology beyond recursively distinct successors. No claim is made
that it is the minimum-cardinality quotient among all contextually equivalent games.

## Contexts and gluing

An admissible one-port context is a finite graph `H` with a distinguished vertex `b`, vertex
disjoint from `T`. It may contain arbitrary core edges, closed components, and other attachments
at `b`. Glue `A=(T,r)` to `(H,b)` by adding the sole cross-edge `b--r`; gluing `0` returns `H`.
Write the result as `H *_b A`.

Allowing arbitrary `H` is important. In particular, another attachment sharing `b` is simply
part of the context. A move at its root can kill `b`, and the selected attachment then contributes
its current `free` value. No response is allowed to anticipate that event: the successor used is
the one reached by the actual preceding moves.

Define exact contextual nimber equivalence by

```text
A ==_ctx A'  iff  g(H *_b A) = g(H *_b A')
                       for every admissible (H,b).
```

Contextual P/N equivalence is the corresponding equality of zero versus nonzero values. Nimber
equivalence is deliberately the B2 target because it remains valid after xor with closed
components; P/N equivalence alone does not.

## Replacement theorem

**Theorem (one-port replacement).** If `I(A)=I(A')`, then `A ==_ctx A'`. Consequently either
attachment may replace the other at one or several ports without changing the Grundy value or the
P/N outcome of the whole graph.

**Proof.** Fix `(H,b)` and compare the option nimbers of the two glued games. Strong induction on
the total number of vertices in the compared contexts and attachments covers five exhaustive move
classes.

1. A context move at `b` leaves `H-N_H[b]` and contributes `cut(A)`.
2. A context move at a neighbour of `b` deletes `b` without deleting `r`; the detached attachment
   contributes `free(A)`.
3. Any other context move leaves `b` live and gives a smaller context glued to the unchanged live
   interface.
4. A port-preserving attachment move contributes its recorded closed offset, xored with the value
   of `H` glued to its recorded successor interface.
5. A port-killing attachment move leaves `H-b` (the other neighbours of `b` survive) and contributes
   its recorded kill nimber.

Equal interfaces give equal `free` and `cut` values and equal labelled transition sets. The
induction hypothesis equates every smaller live successor, so the two positions have the same set
of option nimbers. Their mex values are equal. Replacing several attachments follows one at a
time, treating all unreplaced attachments as part of `H`. QED.

Notice the two different context residues in the proof: selecting `b` leaves `H-N_H[b]`, whereas
selecting `r` leaves `H-b`. Identifying these histories would be another unsound quotient.

## Why the 15/19-vertex witness is separated

The corrected component checker replaces every rooted tree at a core vertex by the old triple and
then canonicalizes the same exact core skeleton. Its first conflict consists of the 15- and
19-vertex masks

```text
(2256223630000138, 3477912251120222208)  with nimber 4
(4423952646187,    3482415833567723520)  with nimber 1.
```

Thus the two graphs have the same core and the same multiset of old triples at corresponding core
vertices, but their option-nimber sets differ. If all corresponding rooted attachments had equal
interfaces `I`, repeated application of the replacement theorem would force the whole graphs to
have equal nimbers, contradicting `4 != 1`. Hence at least one paired attachment is distinguished
by a port-preserving successor or its closed offset even though its three projected mex values
agree. This separates the mandatory witness using the already independently checked values; no
larger enumeration is needed for B1. B2 should emit the first differing interned node as a
diagnostic, but locating that node is not an additional semantic choice.

## Exact representation for B2

B2 must intern the following canonical records using unbounded nonnegative integers for nimbers:

```text
Node {
  free: Nim,
  cut: Nim,
  preserve: sorted_unique list of (closed_offset: Nim, child: NodeId),
  kill: sorted_unique list of Nim
}
```

`NodeId 0` is exactly `(0,0,[],[])`. Nonempty nodes are built bottom-up. A node ID is only an
implementation reference: canonical equality is equality of the full record after child IDs have
themselves been canonically interned. Stable output should assign IDs bottom-up by transition
height and then lexicographically by `(free,cut,preserve,kill)`, or serialize structural hashes
with a collision-check against the complete records.

At a core vertex, the attachment label is the sorted multiset of its incident attachment `NodeId`s;
it is not the xor of their values, because they still share the live port. The exact core topology,
path words, and these labels form the B2 candidate key. The checker must first confirm that the
two recorded witness masks receive different keys, then run the q=3 and bounded q=5 gluing gate.
Any merger with unequal exact nimbers is a falsifier of either the implementation or the proposed
one-port schema and must be minimized before proceeding to B3.

## Boundary

The theorem proves sound replacement, not useful compression: the interned DAG may retain nearly
as many classes as rooted-tree isomorphism. It does not determine a hard `PGL2(5)` follower,
establish a finite interface uniformly in `q`, or justify a larger state cap. Those are later
gates. B2's task is first to measure this exact congruence on q=3 and the already bounded q=5
prefix, with an independent replay of the witness separation and merger check.

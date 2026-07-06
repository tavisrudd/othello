#!/usr/bin/env python3
"""
r3=2 lift (main sum-free conjecture Z3^2 x Z_p = P, p>=7):

Reduction (proven, this session): root nimber = mex{ n_socle, n_coprime, n_mixed }
over the 3 first-move orbits, so P  <=>  each of the 3 openings is N  <=>  each
opening has a P-reply {s,t}=*0. The mixed opening's P-reply can be the socle
element, so everything collapses to TWO P-position lemmas:

  Lemma A  {socle,   mixed} = {(0,1,0),(1,0,1)} = *0   (certifies socle & mixed)
  Lemma B  {coprime, mixed} = {(0,0,1),(0,1,1)} = *0   (certifies coprime)

This tool uses the Go `grundy` engine as an oracle to extract Bob's (2nd player)
winning-reply function from a P-position {s,t}: for each legal Alice move a, the
set of Bob replies b with {s,t,a,b}=*0. We then test whether a single (possibly
board-dependent) involution a<->b explains Bob's strategy = the mirror we need.

Usage: python3 2026-07-06-r32-reply-mirror.py <p> <s coords> <t coords>
  e.g. python3 2026-07-06-r32-reply-mirror.py 7 0,1,0 1,0,1
"""
import sys, subprocess, itertools, os

GRUNDY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "sumfree-go", "grundy")

def parse(s):  # "0,1,0" -> (0,1,0)
    return tuple(int(x) for x in s.split(","))

def main():
    p = int(sys.argv[1])
    mods = (3, 3, p)
    s = parse(sys.argv[2])
    t = parse(sys.argv[3])
    elems = [e for e in itertools.product(*[range(m) for m in mods]) if any(e)]  # nonzero

    def add(a, b):
        return tuple((a[i] + b[i]) % mods[i] for i in range(3))

    def sumfree(S):
        Sset = set(S)
        for x in S:
            for y in S:
                if add(x, y) in Sset:
                    return False
        return True

    def legal_moves(board):
        B = set(board)
        out = []
        for m in elems:
            if m in B:
                continue
            if sumfree(list(B) + [m]):
                out.append(m)
        return out

    def coordstr(e):
        return ",".join(str(x) for x in e)

    def preplies(board):
        """Bob's *0-replies to `board` (the moves b making {board,b}=*0)."""
        start = ";".join(coordstr(e) for e in board)
        r = subprocess.run([GRUNDY, ",".join(map(str, mods)),
                            "--start", start, "--children", "--preply"],
                           capture_output=True, text=True)
        outs = []
        for line in r.stdout.splitlines():
            line = line.strip()
            if line.startswith("PREPLY ") and not line.startswith("PREPLY-COUNT"):
                outs.append(parse(line.split(None, 1)[1]))
        return set(outs)

    # verify {s,t} = *0
    st_gr = subprocess.run([GRUNDY, ",".join(map(str, mods)),
                            "--start", f"{coordstr(s)};{coordstr(t)}"],
                           capture_output=True, text=True).stdout
    gval = [l for l in st_gr.splitlines() if "GRUNDY=" in l]
    print(f"p={p}  s={s} t={t}  {gval[0].strip() if gval else '?'}")

    A = legal_moves([s, t])
    print(f"legal Alice moves from {{s,t}}: {len(A)}")

    # Bob's reply function: for each Alice move a, the set of *0-replies b
    reply = {}
    for a in A:
        b_set = preplies([s, t, a])
        reply[a] = b_set

    # Test: is there an involution phi: A -> A with b=phi(a) a valid Bob reply
    # AND phi(b)=a (a is a valid reply to b)? Look for a consistent pairing.
    paired = {}
    unpaired = []
    for a in A:
        # candidate partners = Bob replies to a that are themselves in A and
        # whose Bob-reply set contains a (mutual)
        cands = [b for b in reply[a] if b in reply and a in reply.get(b, set())]
        if cands:
            paired[a] = cands
        else:
            unpaired.append(a)

    print(f"\nAlice moves with a MUTUAL *0-partner (a<->b both reply to each other): {len(paired)}/{len(A)}")
    print(f"Alice moves with NO mutual partner (fixed/problem set): {len(unpaired)}")
    if unpaired:
        print("  problem-set moves:", " ".join(coordstr(a) for a in unpaired))

    # Show the reply-set sizes distribution
    from collections import Counter
    sizes = Counter(len(reply[a]) for a in A)
    print("reply-set size histogram (a -> #Bob *0-replies):", dict(sorted(sizes.items())))

    # Print a compact table of a -> reply set (first few) for eyeballing structure
    print("\n a  ->  Bob's *0-replies")
    for a in A:
        bs = " ".join(coordstr(b) for b in sorted(reply[a]))
        print(f"  {coordstr(a):8s} -> {bs}")

if __name__ == "__main__":
    main()

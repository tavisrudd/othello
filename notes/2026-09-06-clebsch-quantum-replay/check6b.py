import sys
import os
import subprocess
from math import comb
sys.path.insert(0, "/tmp/claude-1000/-home-tavis-src-othello-rust/"
                   "936bbcce-b386-4c99-97f5-4318b618ed8d/scratchpad/"
                   "clebsch-replay")
from common import gmat, A11_CLAIM

HERE = os.path.dirname(os.path.abspath(__file__))
G = gmat(11)
inp = "11 22\n" + "\n".join(" ".join(str(x) for x in r) for r in G) + "\n"
with open(os.path.join(HERE, "g11.txt"), "w") as fh:
    fh.write(inp)

out = subprocess.run([os.path.join(HERE, "enum11")], input=inp,
                     capture_output=True, text=True, check=True)
B = [0] * 23
for line in out.stdout.strip().splitlines():
    w, v = line.split()
    B[int(w)] = int(v)

n = 22
A = [0] * (n + 1)
for w in range(n + 1):
    A[w] = B[w] - sum(comb(n - j, w - j) * A[j] for j in range(w))

print("B_w =", B)
print("A_w =", A)
tot = sum(A)
print("sum A_w =", tot, "== 11^11:", tot == 11 ** 11)
claim = [A11_CLAIM.get(w, 0) for w in range(n + 1)]
print("matches claimed table:", A == claim)
if A != claim:
    print("  diffs (w: computed, claimed):",
          {w: (A[w], claim[w]) for w in range(n + 1) if A[w] != claim[w]})
print("min nonzero weight:", min(w for w in range(1, n + 1) if A[w]))
print("all A_w >= 0:", all(a >= 0 for a in A))

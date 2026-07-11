# Coding/MDS cross-field sweep — replay scripts

Backing computations for
[`notes/2026-07-11-codex-coding-mds-cross-field-sweep.md`](../../2026-07-11-codex-coding-mds-cross-field-sweep.md).
Moved out of `/tmp` (tmpfs = RAM on this box) on 2026-07-11 so the load-bearing
COMPUTED-EXACT evidence survives a reboot. Hashes below are frozen; re-run from
`/home/tavis/src/othello`.

| Script | sha256 | Backs | Key output |
|---|---|---|---|
| `q9_pgl_orbit_seed.py` | `377a5d20…0fcc0d` | §1.5 full-orbit seed | `n=19 rank=4 d=8`; rows `(ν,τ)=(4,7),(6,12),(7,13)`; `minimal_circuits=[(3,120),(4,84)]`; `robust=19/19` |
| `twisted_cubic_gate.py` | `1f24b90f…51a3e4e` | §2 recovery spectrum | `q=11`: `N=15,18,19` all `ν=3`, `τ=5,6,6`; `N=22 τ=5` vs `N=18 τ=6` (τ non-monotone in N) |
| `r3_frob_arrangement.py` | `4c92124c…8063b4` | §5 Frobenius-marked arrangement | `s=7` mixed unmarked bucket with `legal∈{30,32}` (Frobenius marking essential) |

Full hashes:

```text
377a5d207853d12e77479ea3768f3bc784e656bc38ef360c60f062ac230fcc0d  q9_pgl_orbit_seed.py
1f24b90f41d17c8328c278ebc8e57e481b508fe96590fc8855112fb0551a3e4e  twisted_cubic_gate.py
4c92124c2e515180e3bc5a14d4e25c16ee000f8eb18d43dc06ffc9ca918063b4  r3_frob_arrangement.py
```

Replay:

```sh
cd /home/tavis/src/othello
python3 notes/scripts/2026-07-11-coding-mds-sweep/q9_pgl_orbit_seed.py
python3 notes/scripts/2026-07-11-coding-mds-sweep/twisted_cubic_gate.py 5 7 11
python3 notes/scripts/2026-07-11-coding-mds-sweep/r3_frob_arrangement.py
sha256sum notes/scripts/2026-07-11-coding-mds-sweep/*.py
```

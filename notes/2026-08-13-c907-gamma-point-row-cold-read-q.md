# Gamma point-row cold read Q: simple VGIT wall

Date: 2026-08-13

Frozen authority commit:
`f73bcb4f837eed0aa8d512567b70c74534b1f61a`

Frozen PDF SHA-256:
`ed5c6c5d98ab158164e4885e8fc3734060b5fa724290b78658a20dbf9e2bd8b8`

Packet: Section 3 and the cited Gu--Yu--Yu source loci. The reader received
no internal research notes, prior reports, or proposed repairs.

Verdict: **MINOR**.

## Earliest unsupported implication

Immediately after (3.8), the draft says:

> The point class `[p_+]` satisfies the same equation.

The later assertion that Gu--Yu--Yu Lemma 5.13 supplies no unit correction is
not supported by that lemma. If the pulled-back receiver coordinate is

`tau_+(S) = f(S) 1 + eta(S)`,

Fourier covariance contains `(S d_S tau_+) star`. Exceptional support kills
the positive-degree part `eta(S)` on the point, but a unit term contributes
`S f'(S)[p_+]`.

## Smallest repair identified by the reader

Use the polynomiality in `z` from Gu--Yu--Yu Lemma 5.8. At the first order
`m` containing a unit correction `c S^m`, covariance gives

`(z m id + D cup -) v_m + m c [p_+] = 0`.

A highest-`z`-degree comparison forces `v_m=0`, then `c=0`. A simultaneous
induction kills both the unit correction and the ambient tail. The theorem
appears to survive after replacing the appeal to Lemma 5.13 by this argument.

## Downstream surface to re-read

- abstract full-wall-parameter claim;
- introduction Theorem 1.1 and its proof sketch;
- Theorem 3.1 and equations (3.8)--(3.9);
- Warning 3.2;
- Corollary 3.4;
- Scope item (1).

Strongest passage: the use of Lemma 5.10 on `lambda a_p`, finite freeness,
the negative Fourier isomorphism, and base change.

Highest-friction passage: the sentence saying Lemma 5.13 supplies no unit
correction.

Source checked: Gu--Yu--Yu, arXiv:2508.15770, cached PDF SHA-256
`9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`.

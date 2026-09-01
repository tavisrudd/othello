#!/usr/bin/env python3
"""C1029 — build deliberately broken certificates and confirm the independent checker rejects.

A checker never shown rejecting anything has not been tested.  Each mutant below attacks one
layer of the certificate; every one must be rejected, and the driver reports which check caught
it.  Mutants that touch the witness file also rewrite `witness_sha256` and `witness_count`, so
that the deeper structural check is what fires rather than the hash binding — except for the
`tampered-witness-file` mutant, which exists precisely to exercise the hash binding.

Usage:
    uv run --with sympy --with numpy python3 c1029_break.py <cert.txt> --out-dir DIR
"""

from __future__ import annotations

import argparse
import hashlib
import shutil
import subprocess
import sys
from pathlib import Path

CHECKER = Path(__file__).with_name("c1029_check.py")


def read_cert(path: Path) -> list[str]:
    return path.read_text().splitlines()


def hdr_value(lines: list[str], key: str) -> str:
    for ln in lines:
        if ln.startswith(key + " "):
            return ln.split(None, 1)[1]
    raise SystemExit(f"header {key} not found")


def set_hdr(lines: list[str], key: str, value: str) -> list[str]:
    return [f"{key} {value}" if ln.startswith(key + " ") else ln for ln in lines]


def family_block(lines: list[str], name: str) -> int:
    for i, ln in enumerate(lines):
        p = ln.split()
        if p and p[0] == "family" and p[2] == name:
            return i
    raise SystemExit(f"family {name} not found")


def first_family_of_tier(lines: list[str], tier: int) -> int:
    for i, ln in enumerate(lines):
        p = ln.split()
        if p and p[0] == "family" and int(p[1]) == tier:
            return i
    raise SystemExit(f"no tier-{tier} family")


def refresh_witness_binding(lines: list[str], wpath: Path) -> list[str]:
    raw = wpath.read_bytes()
    n = len([ln for ln in raw.decode().splitlines() if ln.strip()])
    lines = set_hdr(lines, "witness_sha256", hashlib.sha256(raw).hexdigest())
    lines = set_hdr(lines, "witness_count", str(n))
    return lines


def build_mutants(cert: Path, out: Path) -> list[tuple[str, str, Path]]:
    """returns (mutant name, the layer it attacks, cert path)"""
    base = read_cert(cert)
    wit_name = hdr_value(base, "witness_file")
    wit_src = cert.parent / wit_name
    out.mkdir(parents=True, exist_ok=True)
    mutants: list[tuple[str, str, Path]] = []

    def emit(name: str, attacks: str, lines: list[str], wit_lines: list[str] | None = None):
        d = out / name
        d.mkdir(parents=True, exist_ok=True)
        wp = d / wit_name
        if wit_lines is None:
            shutil.copyfile(wit_src, wp)
        else:
            wp.write_text("".join(f"{l}\n" for l in wit_lines))
        cp = d / cert.name
        cp.write_text("".join(f"{l}\n" for l in lines))
        mutants.append((name, attacks, cp))

    wit_lines = [l for l in wit_src.read_text().splitlines() if l.strip()]

    # 1. subtly wrong identity: bump one coefficient of C in a tier-1 family by 1
    m = list(base)
    i = family_block(m, "n13mod24")
    row = m[i + 3].split()
    row[2] = str(int(row[2]) + 1)
    m[i + 3] = " ".join(row)
    emit("wrong-identity", "layer 1: symbolic identity", m)

    # 2. missing residue class: delete a tier-1 family outright
    m = list(base)
    i = family_block(m, "n145mod168")
    del m[i : i + 4]
    m = set_hdr(m, "tier1_families", str(int(hdr_value(m, "tier1_families")) - 1))
    emit("missing-class", "layer 1: covering of Z/840", m)

    # 3. class widened past what the polynomials prove: halve a tier-2 family's modulus
    m = list(base)
    i = first_family_of_tier(m, 2)
    p = m[i].split()
    mod = int(p[3])
    p[3] = str(mod // 2)
    p[4] = str(int(p[4]) % (mod // 2))
    m[i] = " ".join(p)
    emit("widened-class", "layer 1: identity ties A,B,C to (m, r)", m)

    # 4. positivity broken: A(tmin) = 0 for the `even` family, i.e. a 1/0 term
    m = list(base)
    i = family_block(m, "even")
    p = m[i].split()
    p[5] = "0"
    m[i] = " ".join(p)
    emit("zero-denominator", "layer 1: positivity", m)

    # 5. a witness that does not satisfy the equation
    m = list(base)
    w = list(wit_lines)
    f = w[0].split()
    f[2] = str(int(f[2]) + 2)
    w[0] = " ".join(f)
    (out / "_tmp").mkdir(parents=True, exist_ok=True)
    tmp = out / "_tmp" / wit_name
    tmp.write_text("".join(f"{l}\n" for l in w))
    emit("bad-witness", "layer 2: witness equation", refresh_witness_binding(m, tmp), w)

    # 6. a missing witness, with count and hash updated to match, so that the completeness
    #    check is what fires rather than the hash binding
    m = list(base)
    w = wit_lines[1:]
    tmp.write_text("".join(f"{l}\n" for l in w))
    emit("missing-witness", "composition: residual completeness", refresh_witness_binding(m, tmp), w)

    # 7. witness file edited without updating the certificate's hash
    m = list(base)
    w = list(wit_lines)
    f = w[-1].split()
    f[2] = str(int(f[2]) + 4)
    w[-1] = " ".join(f)
    emit("tampered-witness-file", "binding: witness sha256", m, w)

    # 8. a tier-2 family dropped, so the primes it absorbed have nothing left
    m = list(base)
    i = first_family_of_tier(m, 2)
    del m[i : i + 4]
    m = set_hdr(m, "tier2_families", str(int(hdr_value(m, "tier2_families")) - 1))
    emit("dropped-ladder-family", "composition: residual completeness", m)

    # 9. range claimed beyond what the witness list supports
    m = set_hdr(list(base), "range_hi", str(int(hdr_value(base, "range_hi")) * 2))
    emit("overclaimed-range", "composition: residual completeness", m)

    # 10. a class the identities are *believed* to cover, declared exceptional without witnesses
    m = set_hdr(list(base), "exceptional", hdr_value(base, "exceptional") + " 481")
    emit("extra-exceptional-class", "composition: residual completeness", m)

    shutil.rmtree(out / "_tmp", ignore_errors=True)
    return mutants


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("cert", type=Path)
    ap.add_argument("--out-dir", type=Path, required=True)
    args = ap.parse_args()

    mutants = build_mutants(args.cert, args.out_dir)
    print(f"built {len(mutants)} mutants under {args.out_dir}\n")

    rows = []
    ok = True
    # the unmutated certificate must still be accepted
    r = subprocess.run(
        [sys.executable, str(CHECKER), str(args.cert), "--expect", "accept"],
        capture_output=True, text=True,
    )
    rows.append(("(control) unmutated", "-", "ACCEPTED" if r.returncode == 0 else "FAILED", ""))
    ok &= r.returncode == 0

    for name, attacks, path in mutants:
        r = subprocess.run(
            [sys.executable, str(CHECKER), str(path), "--expect", "reject"],
            capture_output=True, text=True,
        )
        reason = ""
        for line in r.stdout.splitlines():
            if line.strip().startswith("- "):
                reason = line.strip()[2:]
                break
        rows.append((name, attacks, "REJECTED" if r.returncode == 0 else "NOT CAUGHT", reason))
        ok &= r.returncode == 0

    w0 = max(len(x[0]) for x in rows)
    w1 = max(len(x[1]) for x in rows)
    w2 = max(len(x[2]) for x in rows)
    print(f"{'mutant'.ljust(w0)}  {'layer attacked'.ljust(w1)}  {'verdict'.ljust(w2)}  first reason")
    print(f"{'-' * w0}  {'-' * w1}  {'-' * w2}  {'-' * 60}")
    for a, b, c, d in rows:
        print(f"{a.ljust(w0)}  {b.ljust(w1)}  {c.ljust(w2)}  {d[:110]}")
    print()
    print("ALL MUTANTS CAUGHT" if ok else "SOME MUTANTS SLIPPED THROUGH")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

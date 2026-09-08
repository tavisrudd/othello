"""Replay both exact residue computations and verify tracked bytes."""
import hashlib
import subprocess
import sys
from pathlib import Path

root = Path(__file__).resolve().parent / "universal-residue"
for line in (root / "SHA256SUMS").read_text().splitlines():
    digest, name = line.split("  ", 1)
    if hashlib.sha256((root / name).read_bytes()).hexdigest() != digest:
        raise RuntimeError("residue checksum mismatch: " + name)
for name, output in [("derive.py", "derive.json"), ("check_indicial.py", "check_indicial.json")]:
    result = subprocess.run([sys.executable, str(root / name)], check=True, capture_output=True)
    if result.stdout != (root / output).read_bytes():
        raise RuntimeError("residue replay mismatch: " + name)
print("universal residue and independent indicial replay: ok")

#!/usr/bin/env python3
"""Independent replay adapter for the first recursive-normal-form merger."""

import json
import os
import subprocess
import sys
import tempfile


graph_text = sys.stdin.read()
if len(sys.argv) not in (2, 3):
    raise SystemExit("usage: ... --emit-graph | replay.py PRIMARY_JSON [OUTPUT]")

with open(sys.argv[1], encoding="utf-8") as source:
    certificate = json.load(source)
collision = certificate["first_cross_exact_hit"]
if collision is None:
    raise SystemExit("primary certificate contains no cross-exact merger")
if certificate["value_conflicts"] != 0:
    raise SystemExit("primary certificate reports a value conflict")

adapter = {"first_cross_exact_full_hit": collision}
checker = os.path.join(
    os.path.dirname(__file__),
    "2026-07-17-c294-b3-multi-piece-live-replay.py",
)
with tempfile.NamedTemporaryFile("w", encoding="utf-8") as temporary:
    json.dump(adapter, temporary)
    temporary.flush()
    replay = subprocess.run(
        [sys.executable, checker, temporary.name],
        input=graph_text,
        text=True,
        capture_output=True,
        check=True,
    )
result = json.loads(replay.stdout)
result["primary_quotient_classes"] = certificate["quotient_classes"]
result["normal_form_classes"] = certificate["normal_form_classes"]
result["quotient_class_reduction"] = certificate["quotient_class_reduction"]

output = sys.stdout
if len(sys.argv) == 3:
    output = open(sys.argv[2], "w", encoding="utf-8")
json.dump(result, output, sort_keys=True, separators=(",", ":"))
output.write("\n")
if output is not sys.stdout:
    output.close()

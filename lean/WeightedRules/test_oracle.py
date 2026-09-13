"""Replay the native ABI adapter and its input rejection boundary.

Run with Python from the Lean package root and ERGODIS_RULE_LIBRARY configured.
The retained certificate is a byte-parity reference, not proof authority.
"""
import json
import os
from pathlib import Path
import tempfile
import unittest

from oracle import LIMIT, certificate

HERE = Path(__file__).resolve().parent


class OracleAdapter(unittest.TestCase):
    def test_native_certificate(self):
        result = certificate(HERE / "fixtures/distance.json", os.environ["ERGODIS_RULE_LIBRARY"])
        self.assertEqual(result + b"\n", (HERE / "fixtures/distance.certificate.json").read_bytes())

    def test_improved_distances_against_floyd_warshall(self):
        infinity = 2**32 - 1
        for name in ("distance.json", "distance-improved.json", "distance-improved-twice.json",
                     "chain-distance.json", "chain-distance-improved.json"):
            with self.subTest(source=name):
                path = HERE / "fixtures" / name
                source = json.loads(path.read_text())
                n = source["domain"]
                edges = [[infinity] * n for _ in range(n)]
                origins = []
                for fact in source["facts"]:
                    if fact["relation"] == "edge":
                        a, b = fact["tuple"]
                        edges[a][b] = min(edges[a][b], fact["cost"])
                    else:
                        self.assertEqual(fact["relation"], "dist")
                        origins.append((fact["tuple"][0], fact["cost"]))
                paths = [row.copy() for row in edges]
                for i in range(n):
                    paths[i][i] = 0
                for middle in range(n):
                    for a in range(n):
                        for b in range(n):
                            paths[a][b] = min(paths[a][b], infinity,
                                              paths[a][middle] + paths[middle][b])
                distances = [min([infinity] + [cost + paths[a][b] for a, cost in origins])
                             for b in range(n)]
                result = json.loads(certificate(path, os.environ["ERGODIS_RULE_LIBRARY"]))
                self.assertEqual(result["values"], [v for row in edges for v in row] + distances + [0])

    def test_source_rejection(self):
        source = json.loads((HERE / "fixtures/distance.json").read_text())
        source["schema"] = "unsupported"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "source.json"
            path.write_text(json.dumps(source))
            with self.assertRaisesRegex(ValueError, "module operation 1 failed"):
                certificate(path, os.environ["ERGODIS_RULE_LIBRARY"])
            path.write_bytes(b" " * (LIMIT + 1))
            with self.assertRaisesRegex(ValueError, "source exceeds byte limit"):
                certificate(path, os.environ["ERGODIS_RULE_LIBRARY"])


if __name__ == "__main__":
    unittest.main()

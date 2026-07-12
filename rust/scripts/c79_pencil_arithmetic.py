#!/usr/bin/env python3
"""C79: arithmetic quotients of C74 maximum-pencil outcome sets."""

from __future__ import annotations

from collections import Counter, defaultdict
import argparse
import os

from c73_secant_algebra import DATA, PRIME_FILES, analyze, parse
from c74_line_pencil import INF, line_product_data, mobius_zero_inf
from c77_pencil_value_probe import chi, mul_order, rows_for


def polynomial_coefficients(roots, q):
    coefficients = [1]
    for root in roots:
        out = [0] * (len(coefficients) + 1)
        for i, coefficient in enumerate(coefficients):
            out[i] = (out[i] - root * coefficient) % q
            out[i + 1] = (out[i + 1] + coefficient) % q
        coefficients = out
    return tuple(coefficients)


def arithmetic_features(a, forbidden, u_values, marked_u_values, f_role, q):
    inverse_a = pow(a, -1, q)
    ratios = tuple(sorted(b * inverse_a % q for b in forbidden))
    inverse_ratios = tuple(sorted(pow(ratio, -1, q) for ratio in ratios))

    def oriented(rs):
        coefficients = polynomial_coefficients(rs, q)
        coefficient_characters = tuple(chi(value, q) for value in coefficients)
        weights = [chi(1 - ratio, q) for ratio in rs]
        moments = tuple(
            sum(weight * pow(ratio, degree, q) for ratio, weight in zip(rs, weights)) % q
            for degree in range(len(rs))
        )
        moment_characters = tuple(chi(value, q) for value in moments)
        cross_characters = Counter(chi(left - right, q) for i, left in enumerate(rs)
                                   for right in rs[i + 1:])
        reciprocal_characters = Counter(chi(left * right - 1, q)
                                        for i, left in enumerate(rs)
                                        for right in rs[i + 1:])
        order_gaps = tuple(sorted(mul_order((1 - ratio) % q, q) for ratio in rs))
        return {
            "coeff-char": coefficient_characters,
            "moments": moments,
            "moment-char": moment_characters,
            "cross-char": tuple(sorted(cross_characters.items())),
            "reciprocal-char": tuple(sorted(reciprocal_characters.items())),
            "order-gaps": order_gaps,
            "exact-ratios": rs,
        }

    forward = oriented(ratios)
    inverse = oriented(inverse_ratios)
    features = {}
    for name in forward:
        features[name] = min(forward[name], inverse[name])
    features["character-battery"] = (
        features["coeff-char"], features["moment-char"],
        features["cross-char"], features["reciprocal-char"],
    )
    features["all-arithmetic"] = (
        features["character-battery"], features["order-gaps"],
    )
    orbit = []
    for invert in (False, True):
        us = tuple(pow(value, -1, q) for value in u_values) if invert else u_values
        center = pow(a, -1, q) if invert else a
        for scale in range(1, q):
            orbit.append((
                tuple(sorted(scale * value % q for value in us)),
                scale * scale * center % q,
            ))
    features["full-pencil-orbit"] = min(orbit)
    marked_orbit = []
    for invert in (False, True):
        marked = tuple((role, pow(value, -1, q) if invert else value)
                       for role, value in marked_u_values)
        center = pow(a, -1, q) if invert else a
        endpoint_roles = ("candidate", f_role) if invert else (f_role, "candidate")
        for scale in range(1, q):
            marked_orbit.append((endpoint_roles,
                tuple(sorted((role, scale * value % q) for role, value in marked)),
                scale * scale * center % q,
            ))
    features["marked-pencil-orbit"] = min(marked_orbit)
    return features


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("qs", nargs="*", type=int, default=[11, 13, 17, 19])
    args = parser.parse_args()

    for q in args.qs:
        _rows, pencils = rows_for(q)
        records = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
        feature_rows = defaultdict(list)
        pencil_rows = []
        for _q, cls, key, d, rows in pencils:
            u_values, _products, _d = line_product_data(records[cls], key)
            u_values = tuple(u_values)
            record = records[cls]
            f, w = key
            f0 = 0 if f == "0" else f
            f_role = "burned" if f0 in (0, INF) else "selected"
            marked_frame = [("burned", 0), ("burned", INF)] + [
                ("selected", value) for value in record["tframe"]
            ]
            marked_u_values = tuple(
                (role, mobius_zero_inf(value, f0, w, q))
                for role, value in marked_frame if value != f0
            )
            forbidden = tuple(sorted(set(range(1, q)) - {row["a"] for row in rows}))
            enriched = []
            for row in rows:
                features = arithmetic_features(
                    row["a"], forbidden, u_values, marked_u_values, f_role, q
                )
                enriched.append((row["a"], row["value"], features))
                for name, feature in features.items():
                    feature_rows[name].append((feature, row["value"], cls, key, row["a"]))
            pencil_rows.append((cls, key, d, enriched))

        print(f"PENCIL-ARITHMETIC q={q} pencils={len(pencil_rows)}")
        for name, rows in sorted(feature_rows.items()):
            by_feature = defaultdict(list)
            for feature, value, cls, key, a in rows:
                by_feature[feature].append((value, cls, key, a))
            pure_p = {feature for feature, values in by_feature.items()
                      if all(value == "P" for value, _cls, _key, _a in values)}
            covered_rows = sum(feature in pure_p and value == "P"
                               for feature, value, _cls, _key, _a in rows)
            covered_pencils = sum(any(
                value == "P" and features[name] in pure_p
                for _a, value, features in enriched
            ) for _cls, _key, _d, enriched in pencil_rows)
            print("PENCIL-ARITHMETIC-FEATURE "
                  f"name={name} types={len(by_feature)} pure-p-types={len(pure_p)} "
                  f"covered-p-rows={covered_rows} covered-pencils={covered_pencils}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

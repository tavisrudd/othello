"""Deliberately invalid oracle responses for the Lean rejection controls.

These are adversarial data, not certificates. The zero-valued self-loop is fixed
but unsupported; accepting it would violate leastness in information order.
"""
import json
import sys

mode = sys.argv[1]
response = dict(schema="finite-min-plus-certificate.v1", source_id=[0] * 32,
                scalar_count=1, rounds=1, values=[0])
if mode == "schema":
    response["schema"] = "unknown"
elif mode == "coverage":
    response["values"] = []
elif mode == "rounds":
    response["rounds"] = 2
elif mode == "range":
    response["values"] = [2**32]
elif mode == "identity":
    response["source_id"] = [256] * 32
elif mode == "exit":
    sys.exit(7)
elif mode == "valid":
    response["values"] = [2**32 - 1]
elif mode == "unsupported":
    pass
else:
    raise ValueError("unknown rejection control")
print(json.dumps(response))

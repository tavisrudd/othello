#!/usr/bin/env python3
"""Harmless host-capability probe for the C225 systemd user-service adapter.

This script never invokes Lean or lean-build-queue.py.  It creates only uniquely named transient
user units containing ``c225-probe`` and cleans each exact unit in ``finally`` blocks.  Its stdout
is one bounded JSON object; command diagnostics are retained only as bounded JSON fields.
"""

from __future__ import annotations

import json
import os
import pwd
import shutil
import signal
import subprocess
import sys
import time
import uuid
from pathlib import Path
from typing import Any


PREFIX = "othello-lean-c225-probe"
WAIT_TIMEOUT = 10.0
POLL_INTERVAL = 0.05
MAX_DIAGNOSTIC = 1000
SHOW_PROPERTIES = (
    "Id",
    "LoadState",
    "Transient",
    "InvocationID",
    "ActiveState",
    "SubState",
    "Result",
    "ExecMainCode",
    "ExecMainStatus",
    "KillMode",
    "SendSIGKILL",
    "TimeoutStopUSec",
)


class ProbeFailure(RuntimeError):
    pass


def require_tool(name: str) -> str:
    path = shutil.which(name)
    if path is None:
        raise ProbeFailure(f"required executable is unavailable: {name}")
    # Keep the absolute symlink spelling: on NixOS, coreutils applets use argv[0] dispatch and
    # resolving e.g. /run/current-system/sw/bin/sleep to the multicall binary changes semantics.
    return os.path.abspath(path)


def bounded(value: str) -> str:
    value = value.strip()
    if len(value) <= MAX_DIAGNOSTIC:
        return value
    return value[:MAX_DIAGNOSTIC] + "...<truncated>"


def run(command: list[str], *, timeout: float = WAIT_TIMEOUT) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        timeout=timeout,
        check=False,
    )


def unit_name(label: str) -> str:
    return f"{PREFIX}-{label}-{uuid.uuid4().hex}.service"


def systemctl(systemctl_path: str, *arguments: str) -> subprocess.CompletedProcess[str]:
    return run([systemctl_path, "--user", *arguments])


def cleanup_unit(systemctl_path: str, unit: str) -> None:
    # Both operations are exact-name and idempotent for an already garbage-collected unit.
    systemctl(systemctl_path, "stop", unit)
    systemctl(systemctl_path, "reset-failed", unit)


def show_unit(systemctl_path: str, unit: str) -> dict[str, str] | None:
    command = [systemctl_path, "--user", "show", unit]
    command.extend(f"--property={name}" for name in SHOW_PROPERTIES)
    result = run(command)
    if result.returncode != 0:
        return None
    properties: dict[str, str] = {}
    for line in result.stdout.splitlines():
        key, separator, value = line.partition("=")
        if separator:
            properties[key] = value
    if properties.get("Id") != unit or properties.get("LoadState") == "not-found":
        return None
    return properties


def transient_command(
    systemd_run_path: str,
    unit: str,
    executable: str,
    arguments: list[str],
) -> list[str]:
    return [
        systemd_run_path,
        "--user",
        "--wait",
        "--quiet",
        "--service-type=exec",
        "--expand-environment=no",
        f"--unit={unit.removesuffix('.service')}",
        f"--description=C225 harmless capability probe {unit}",
        f"--working-directory={Path.cwd().resolve()}",
        "--setenv=OTHELLO_LEAN_C225_PROBE=1",
        "--property=KillMode=mixed",
        "--property=SendSIGKILL=yes",
        "--property=TimeoutStopSec=120s",
        executable,
        *arguments,
    ]


def completed_case(
    systemd_run_path: str,
    systemctl_path: str,
    label: str,
    executable: str,
    arguments: list[str],
) -> dict[str, Any]:
    unit = unit_name(label)
    try:
        result = run(transient_command(systemd_run_path, unit, executable, arguments))
        properties = show_unit(systemctl_path, unit)
        return {
            "unit": unit,
            "client_returncode": result.returncode,
            "client_stderr": bounded(result.stderr),
            "properties": properties,
        }
    finally:
        cleanup_unit(systemctl_path, unit)


def waiter_loss_case(
    systemd_run_path: str,
    systemctl_path: str,
    sleep_path: str,
) -> dict[str, Any]:
    unit = unit_name("waiter-loss")
    client = subprocess.Popen(
        transient_command(systemd_run_path, unit, sleep_path, ["2"]),
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    try:
        deadline = time.monotonic() + WAIT_TIMEOUT
        active: dict[str, str] | None = None
        last: dict[str, str] | None = None
        while time.monotonic() < deadline:
            last = show_unit(systemctl_path, unit)
            if last is not None and last.get("ActiveState") == "active":
                active = last
                break
            if client.poll() is not None:
                _, client_stderr = client.communicate(timeout=2)
                raise ProbeFailure(
                    "waiter-loss systemd-run exited before the unit became active: "
                    f"rc={client.returncode}, stderr={bounded(client_stderr)}, properties={last}"
                )
            time.sleep(POLL_INTERVAL)
        if active is None:
            raise ProbeFailure(
                f"timed out waiting for the waiter-loss unit to become active; properties={last}"
            )
        client.terminate()
        _, client_stderr = client.communicate(timeout=WAIT_TIMEOUT)
        after_client_exit = show_unit(systemctl_path, unit)
        if after_client_exit is None or after_client_exit.get("ActiveState") != "active":
            raise ProbeFailure("service did not remain active after the systemd-run client exited")

        deadline = time.monotonic() + WAIT_TIMEOUT
        final: dict[str, str] | None = after_client_exit
        while time.monotonic() < deadline:
            final = show_unit(systemctl_path, unit)
            if final is None or final.get("ActiveState") != "active":
                break
            time.sleep(POLL_INTERVAL)
        else:
            raise ProbeFailure("waiter-loss service did not finish independently")

        return {
            "unit": unit,
            "client_returncode": client.returncode,
            "client_stderr": bounded(client_stderr),
            "active_properties": active,
            "properties_after_client_exit": after_client_exit,
            "final_properties": final,
        }
    finally:
        if client.poll() is None:
            client.terminate()
            try:
                client.communicate(timeout=2)
            except subprocess.TimeoutExpired:
                client.kill()
                client.communicate(timeout=2)
        cleanup_unit(systemctl_path, unit)


def validate(results: dict[str, Any]) -> None:
    if results["success"]["client_returncode"] != 0:
        raise ProbeFailure("successful service did not propagate exit 0")
    if results["nonzero"]["client_returncode"] != 7:
        raise ProbeFailure("failing service did not propagate exit 7")

    for label in ("nonzero", "signal"):
        properties = results[label]["properties"]
        if properties is None:
            raise ProbeFailure(f"{label} unit was not inspectable after failure")
        if properties.get("Id") != results[label]["unit"]:
            raise ProbeFailure(f"{label} unit identity mismatch")
        if properties.get("Transient") != "yes" or not properties.get("InvocationID"):
            raise ProbeFailure(f"{label} unit lacks transient invocation identity")
        if properties.get("ActiveState") != "failed":
            raise ProbeFailure(f"{label} unit did not retain failed state")
        if properties.get("KillMode") != "mixed":
            raise ProbeFailure(f"{label} unit did not retain KillMode=mixed")
        if properties.get("SendSIGKILL") != "yes":
            raise ProbeFailure(f"{label} unit did not retain SendSIGKILL=yes")
        if properties.get("TimeoutStopUSec") != "2min":
            raise ProbeFailure(f"{label} unit did not retain TimeoutStopSec=120s")

    nonzero = results["nonzero"]["properties"]
    if nonzero.get("Result") != "exit-code" or nonzero.get("ExecMainStatus") != "7":
        raise ProbeFailure("nonzero service properties do not record exit status 7")
    signaled = results["signal"]["properties"]
    if signaled.get("Result") != "signal" or signaled.get("ExecMainStatus") != str(signal.SIGKILL):
        raise ProbeFailure("signaled service properties do not record SIGKILL")
    if results["signal"]["client_returncode"] != 255:
        raise ProbeFailure("signaled service did not return systemd-run's signal code 255")

    failed_exec = results["failed_exec"]
    if failed_exec["client_returncode"] != 1:
        raise ProbeFailure("Type=exec failure did not return the systemd-run client error code 1")
    if failed_exec["properties"] is not None:
        raise ProbeFailure("Type=exec failure unexpectedly retained a loaded unit")
    if "Failed to find executable" not in failed_exec["client_stderr"]:
        raise ProbeFailure("Type=exec failure did not provide the expected bounded diagnostic")

    waiter = results["waiter_loss"]
    if waiter["active_properties"].get("Id") != waiter["unit"]:
        raise ProbeFailure("waiter-loss active unit identity mismatch")
    if waiter["properties_after_client_exit"].get("ActiveState") != "active":
        raise ProbeFailure("waiter-loss service was not active after client exit")


def main() -> int:
    report: dict[str, Any] = {"format": 1, "probe": "c225-systemd-user", "ok": False}
    try:
        systemd_run_path = require_tool("systemd-run")
        systemctl_path = require_tool("systemctl")
        sh_path = require_tool("sh")
        true_path = require_tool("true")
        sleep_path = require_tool("sleep")
        account = pwd.getpwuid(os.geteuid()).pw_name

        manager = systemctl(systemctl_path, "show", "--property=Version")
        if manager.returncode != 0:
            raise ProbeFailure(f"user manager is unavailable: {bounded(manager.stderr)}")

        results = {
            "success": completed_case(systemd_run_path, systemctl_path, "success", true_path, []),
            "nonzero": completed_case(
                systemd_run_path, systemctl_path, "nonzero", sh_path, ["-c", "exit 7"]
            ),
            "signal": completed_case(
                systemd_run_path, systemctl_path, "signal", sh_path, ["-c", "kill -KILL $$"]
            ),
            "failed_exec": completed_case(
                systemd_run_path,
                systemctl_path,
                "failed-exec",
                "/nonexistent/othello-c225-probe",
                [],
            ),
            "waiter_loss": waiter_loss_case(systemd_run_path, systemctl_path, sleep_path),
        }
        report["results"] = results
        validate(results)
        report.update(
            {
                "ok": True,
                "effective_user": account,
                "manager_version": manager.stdout.partition("=")[2].strip(),
                "command_surface": {
                    "systemd_run": systemd_run_path,
                    "systemctl": systemctl_path,
                    "options": [
                        "--user",
                        "--wait",
                        "--quiet",
                        "--service-type=exec",
                        "--expand-environment=no",
                        "--unit",
                        "--description",
                        "--working-directory",
                        "--setenv",
                    ],
                    "properties": {
                        "KillMode": "mixed",
                        "SendSIGKILL": "yes",
                        "TimeoutStopSec": "120s",
                    },
                },
            }
        )
        return 0
    except (OSError, ProbeFailure, subprocess.SubprocessError) as error:
        report["error"] = bounded(str(error))
        return 1
    finally:
        json.dump(report, sys.stdout, sort_keys=True, separators=(",", ":"))
        sys.stdout.write("\n")


if __name__ == "__main__":
    raise SystemExit(main())

"""Launch, attach to, and query an Ergodis campaign from a notebook.

A campaign is the long-running control plane: it owns a private run directory,
serves the control socket, and records an append-only ledger.  Ordinary
seconds-scale solves do not need one; a campaign is for a search you intend to
watch and steer.
"""

from __future__ import annotations

import json
import os
import signal
import subprocess
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterator

from .control import ControlError, Manifest, send_full, send_request
from .paths import binary

LEDGER_NAME = "ledger.jsonl"

# A controlled search binds its own watcher datagram socket *inside* the run
# directory, as `watch-<pid>-<counter>.sock`.  Unix socket paths are capped at
# 108 bytes, so a run directory buried under a long path makes the search fail
# at startup with an opaque "controller rejected a safe-point operation".  The
# reserve below covers the longest watcher name.
_SUN_PATH_LIMIT = 107
_WATCHER_NAME_RESERVE = 32
MAX_RUN_DIR_LENGTH = _SUN_PATH_LIMIT - _WATCHER_NAME_RESERVE


def check_run_dir_length(run_dir: os.PathLike[str] | str) -> None:
    """Raise if a run directory is too deep for the watcher socket to bind."""
    resolved = str(Path(run_dir).absolute())
    if len(resolved) > MAX_RUN_DIR_LENGTH:
        raise ControlError(
            f"run directory path is {len(resolved)} bytes, over the "
            f"{MAX_RUN_DIR_LENGTH} a controlled search can use: a search binds "
            f"its watcher socket inside the run directory and Unix socket paths "
            f"are capped at 108 bytes. Choose a shorter path, for example under "
            f"$XDG_RUNTIME_DIR.\n  {resolved}"
        )


@dataclass
class LedgerEvent:
    """One durable campaign event: `{seq, epoch, kind, synopsis, plan}`.

    `kind` is an open string.  More kinds exist than any one run emits, so
    consumers must not switch exhaustively on it.
    """

    seq: int
    epoch: int
    kind: str
    synopsis: str
    plan: str | None = None

    @classmethod
    def from_json(cls, document: dict[str, Any]) -> "LedgerEvent":
        return cls(
            seq=document.get("seq", 0),
            epoch=document.get("epoch", 0),
            kind=document.get("kind", ""),
            synopsis=document.get("synopsis", ""),
            plan=document.get("plan"),
        )


class LedgerTail:
    """Incremental reader over a campaign ledger.

    The campaign flushes on every append, so a byte offset is a sound cursor and
    the file can be read while the run is live.  A partially written final line
    is left in the buffer and completed on the next read.
    """

    def __init__(self, path: os.PathLike[str] | str) -> None:
        self.path = Path(path)
        self._offset = 0
        self._partial = b""

    def read(self) -> list[LedgerEvent]:
        """Return every event appended since the last call."""
        if not self.path.exists():
            return []
        with self.path.open("rb") as handle:
            handle.seek(self._offset)
            chunk = handle.read()
            self._offset = handle.tell()
        if not chunk:
            return []
        buffer = self._partial + chunk
        lines = buffer.split(b"\n")
        self._partial = lines.pop()
        events = []
        for line in lines:
            if line.strip():
                events.append(LedgerEvent.from_json(json.loads(line)))
        return events


@dataclass
class Campaign:
    """A live campaign: its manifest, its process when we started it, and ops."""

    manifest: Manifest
    process: subprocess.Popen[bytes] | None = None
    _ledger: LedgerTail = field(init=False)

    def __post_init__(self) -> None:
        self._ledger = LedgerTail(self.manifest.run_dir / LEDGER_NAME)

    # -- construction --------------------------------------------------------

    @classmethod
    def attach(cls, run_dir: os.PathLike[str] | str) -> "Campaign":
        """Attach to a campaign someone else started, by its run directory."""
        return cls(manifest=Manifest.read(run_dir))

    @classmethod
    def launch(
        cls,
        data: os.PathLike[str] | str,
        run_dir: os.PathLike[str] | str,
        socket_path: os.PathLike[str] | str | None = None,
        ledger_max_bytes: int | None = None,
        response_max_bytes: int | None = None,
        trace_max_bytes: int | None = None,
        timeout: float = 30.0,
    ) -> "Campaign":
        """Start `ergodis-campaign` on a frozen feature batch and wait for it.

        The run directory must not already exist; the campaign creates it mode
        0700.  The manifest arrives on the process's stdout as a single JSON
        line, which is also what tells us the socket is ready to accept.

        The path length is checked up front: a controlled search binds a watcher
        socket inside the run directory, and a path too long for `sun_path`
        surfaces much later as an unexplained safe-point rejection.
        """
        check_run_dir_length(run_dir)
        command = [
            str(binary("ergodis-campaign")),
            "--data",
            str(data),
            "--run-dir",
            str(run_dir),
        ]
        if socket_path is not None:
            command += ["--socket", str(socket_path)]
        if ledger_max_bytes is not None:
            command += ["--ledger-max-bytes", str(ledger_max_bytes)]
        if response_max_bytes is not None:
            command += ["--response-max-bytes", str(response_max_bytes)]
        if trace_max_bytes is not None:
            command += ["--trace-max-bytes", str(trace_max_bytes)]

        process = subprocess.Popen(
            command, stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        assert process.stdout is not None
        line = process.stdout.readline()
        if not line:
            stderr = process.stderr.read().decode() if process.stderr else ""
            raise ControlError(f"campaign did not start: {stderr.strip()}")
        campaign = cls(manifest=Manifest.from_json(json.loads(line)), process=process)

        deadline = time.monotonic() + timeout
        while True:
            try:
                campaign.status()
                return campaign
            except ControlError:
                if time.monotonic() > deadline:
                    raise
                time.sleep(0.05)

    # -- operations ----------------------------------------------------------

    def request(
        self, op: str, args: dict[str, Any] | None = None, max_bytes: int = 16 * 1024
    ) -> dict[str, Any]:
        """Send any control op.  Use this for ops without a method here."""
        return send_request(self.manifest, op, args, max_bytes)

    def capabilities(self) -> dict[str, Any]:
        return self.request("capabilities")

    def status(self) -> dict[str, Any]:
        """Health, row count, active plans, watchers, and solver-reported state."""
        return self.request("status")

    def feature_ceiling(self) -> dict[str, Any]:
        return self.request("feature-ceiling")

    def note(self, text: str) -> dict[str, Any]:
        """Write an operator annotation into the ledger.

        Notes interleave with machine events, so a later timeline reads as one
        record of what the search did and what a person observed while it ran.
        """
        return self.request("note", {"text": text})

    def candidate_try(self, plan: dict[str, Any]) -> dict[str, Any]:
        """Evaluate a candidate plan against the batch without activating it."""
        return self.request("candidate-try", {"plan": plan})

    def epoch(self) -> int:
        """The campaign's current plan epoch.

        Every activation bumps it, and the ops that change the active set take
        it as a compare-and-swap guard so two steerers cannot both think they
        installed the newest plan.
        """
        return send_full(self.manifest, "noop")["epoch"]

    def candidate_apply(
        self, plan: dict[str, Any], expect_epoch: int | None = None
    ) -> dict[str, Any]:
        """Evaluate and activate a plan; a live search picks it up at its next
        safe point by swapping a preallocated arena.

        `expect_epoch` defaults to the epoch read immediately before the call,
        which is right for a single steerer.  Pass the epoch you actually saw
        when something else may be steering the same run, so a stale activation
        is rejected rather than silently overwriting.
        """
        if expect_epoch is None:
            expect_epoch = self.epoch()
        return self.request(
            "candidate-apply", {"plan": plan, "expect_epoch": expect_epoch}
        )

    def candidate_deactivate(
        self, name: str, expect_epoch: int | None = None
    ) -> dict[str, Any]:
        """Deactivate a named plan under the same epoch guard as activation."""
        if expect_epoch is None:
            expect_epoch = self.epoch()
        return self.request(
            "candidate-deactivate", {"plan": name, "expect_epoch": expect_epoch}
        )

    def evolve_start(self, args: dict[str, Any]) -> dict[str, Any]:
        return self.request("evolve-start", args)

    def evolve_status(self) -> dict[str, Any]:
        return self.request("evolve-status")

    def evolve_cancel(self) -> dict[str, Any]:
        return self.request("evolve-cancel")

    def exceptional(self, args: dict[str, Any] | None = None) -> dict[str, Any]:
        return self.request("exceptional", args)

    # -- ledger --------------------------------------------------------------

    def new_events(self) -> list[LedgerEvent]:
        """Events appended since the previous call on this object."""
        return self._ledger.read()

    def events(self) -> list[LedgerEvent]:
        """Every event in the ledger, from the beginning, without disturbing the
        incremental cursor."""
        return LedgerTail(self.manifest.run_dir / LEDGER_NAME).read()

    def follow(
        self, interval: float = 0.25, stop_when_finished: bool = True
    ) -> Iterator[LedgerEvent]:
        """Yield ledger events as they are appended.

        Stops when the campaign process exits, so this terminates on its own for
        a campaign this session launched.
        """
        while True:
            events = self.new_events()
            for event in events:
                yield event
            if stop_when_finished and not self.alive():
                for event in self.new_events():
                    yield event
                return
            if not events:
                time.sleep(interval)

    # -- lifecycle -----------------------------------------------------------

    def alive(self) -> bool:
        if self.process is not None:
            return self.process.poll() is None
        return self.manifest.alive()

    def shutdown(self, timeout: float = 10.0) -> None:
        """Ask the campaign to stop, then make sure it did.

        The `shutdown` op is the clean path.  A campaign we did not start gets
        the op only; we do not signal a process this session does not own.
        """
        try:
            self.request("shutdown")
        except ControlError:
            pass
        if self.process is None:
            return
        try:
            self.process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            self.process.send_signal(signal.SIGTERM)
            self.process.wait(timeout=timeout)

    def __enter__(self) -> "Campaign":
        return self

    def __exit__(self, *_exception: object) -> None:
        if self.process is not None:
            self.shutdown()

"""Live monitoring of a campaign and its search, rendered in a notebook cell.

The display is one updating HTML block: the run's provenance header, the latest
progress snapshot, the counters that changed since the previous snapshot, and
the tail of the ledger.  Everything it shows already exists in the run
directory, so the same view works after the fact on a finished run.

Progress snapshots are collected as they arrive and left on the monitor, so the
cell after the monitor can analyze the run without re-reading anything.
"""

from __future__ import annotations

import html
import time
from dataclasses import dataclass, field
from typing import Any

from .campaign import Campaign, LedgerEvent
from .solve import Solve


def _format_number(value: Any) -> str:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        return html.escape(str(value))
    if isinstance(value, int):
        return f"{value:,}"
    return f"{value:,.3f}"


def flatten(record: dict[str, Any], prefix: str = "") -> dict[str, Any]:
    """Flatten one nested progress snapshot into scalar columns.

    A snapshot is `{schema, elapsed_ms, applied_epoch, notified_epoch, solver}`
    with the live counters inside `solver`, so the interesting numbers are one
    level down and have to be lifted before they can be shown or plotted.
    """
    flat: dict[str, Any] = {}
    for key, value in record.items():
        name = f"{prefix}{key}"
        if isinstance(value, dict):
            flat.update(flatten(value, f"{name}."))
        else:
            flat[name] = value
    return flat


def _table(rows: list[tuple[str, Any]]) -> str:
    cells = "".join(
        f"<tr><td style='padding:1px 12px 1px 0;opacity:0.7'>{html.escape(str(key))}</td>"
        f"<td style='padding:1px 0;font-variant-numeric:tabular-nums'>{_format_number(value)}</td></tr>"
        for key, value in rows
    )
    return f"<table style='border-collapse:collapse;font-size:90%'>{cells}</table>"


@dataclass
class Monitor:
    """Follows a campaign, and optionally a search, until the search finishes."""

    campaign: Campaign
    solve: Solve | None = None
    events: list[LedgerEvent] = field(default_factory=list)
    progress: list[dict[str, Any]] = field(default_factory=list)
    ledger_tail: int = 8
    _handle: Any = field(init=False, default=None)

    # -- rendering -----------------------------------------------------------

    def header_rows(self) -> list[tuple[str, Any]]:
        manifest = self.campaign.manifest
        return [
            ("problem", manifest.problem),
            ("run id", manifest.run_id),
            ("presentation", manifest.presentation_hash[:16] + "..."),
            ("code commit", manifest.code_commit),
            ("run dir", str(manifest.run_dir)),
        ]

    def state_rows(self) -> list[tuple[str, Any]]:
        rows: list[tuple[str, Any]] = []
        try:
            status = self.campaign.status()
        except Exception as error:  # the campaign may be shutting down
            return [("campaign", f"unavailable: {error}")]
        rows.append(("campaign", "running" if self.campaign.alive() else "stopped"))
        for key in ("health", "rows", "plans", "outcome_classes", "watchers", "ledger_bytes"):
            if key in status:
                rows.append((key.replace("_", " "), status[key]))
        if status.get("solver") is not None:
            rows.append(("solver", "attached"))
        if self.solve is not None:
            rows.append(("search", "running" if self.solve.alive() else "finished"))
        rows.append(("progress snapshots", len(self.progress)))
        return rows

    def latest_progress_rows(self) -> list[tuple[str, Any]]:
        if not self.progress:
            return []
        latest = flatten(self.progress[-1])
        previous = flatten(self.progress[-2]) if len(self.progress) > 1 else {}
        rows: list[tuple[str, Any]] = []
        for key, value in latest.items():
            if key == "schema":
                continue
            if isinstance(value, (int, float)) and not isinstance(value, bool):
                delta = value - previous.get(key, value) if key in previous else 0
                shown = f"{value:,}" if isinstance(value, int) else f"{value:,.3f}"
                if delta:
                    shown += f"  (+{delta:,})" if delta > 0 else f"  ({delta:,})"
                rows.append((key, shown))
            else:
                rows.append((key, value))
        return rows

    def ledger_rows(self) -> str:
        recent = self.events[-self.ledger_tail :]
        if not recent:
            return "<div style='opacity:0.6'>no events yet</div>"
        cells = "".join(
            f"<tr><td style='padding:1px 10px 1px 0;opacity:0.6'>{event.seq}</td>"
            f"<td style='padding:1px 10px 1px 0'><code>{html.escape(event.kind)}</code></td>"
            f"<td style='padding:1px 0'>{html.escape(event.synopsis)}</td></tr>"
            for event in recent
        )
        return f"<table style='border-collapse:collapse;font-size:90%'>{cells}</table>"

    def _render(self) -> Any:
        from IPython.display import HTML

        progress_block = ""
        if self.progress:
            progress_block = (
                "<div style='margin-top:10px'><b>latest progress snapshot</b>"
                f"{_table(self.latest_progress_rows())}</div>"
            )
        return HTML(
            "<div style='font-family:ui-monospace,SFMono-Regular,Menlo,monospace'>"
            f"<div><b>Ergodis campaign</b></div>{_table(self.header_rows())}"
            f"<div style='margin-top:10px'><b>state</b></div>{_table(self.state_rows())}"
            f"{progress_block}"
            f"<div style='margin-top:10px'><b>ledger</b></div>{self.ledger_rows()}"
            "</div>"
        )

    # -- driving -------------------------------------------------------------

    def poll(self) -> None:
        """Collect whatever is new without redrawing."""
        self.events.extend(self.campaign.new_events())
        if self.solve is not None:
            self.progress.extend(self.solve.new_progress())

    def show(self) -> None:
        """Draw once, creating the updating display."""
        from IPython.display import display

        self.poll()
        self._handle = display(self._render(), display_id=True)

    def update(self) -> None:
        self.poll()
        if self._handle is None:
            self.show()
        else:
            self._handle.update(self._render())

    def watch(
        self,
        interval: float = 0.5,
        timeout: float | None = None,
        stop_when_finished: bool = True,
    ) -> "Monitor":
        """Refresh the display until the search finishes or `timeout` elapses.

        Interrupting the cell stops the loop and leaves the collected snapshots
        on the monitor; it does not stop the search, which keeps running under
        its campaign until you stop it explicitly.
        """
        self.show()
        deadline = None if timeout is None else time.monotonic() + timeout
        try:
            while True:
                time.sleep(interval)
                self.update()
                finished = self.solve is not None and not self.solve.alive()
                if stop_when_finished and finished:
                    self.update()
                    break
                if stop_when_finished and self.solve is None and not self.campaign.alive():
                    break
                if deadline is not None and time.monotonic() > deadline:
                    break
        except KeyboardInterrupt:
            self.update()
        return self

    # -- afterwards ----------------------------------------------------------

    def progress_frame(self) -> Any:
        """The collected progress snapshots as a flat pandas DataFrame.

        One row per snapshot, the `solver` counters lifted to columns, so
        `frame.plot(x="elapsed_ms", y="solver.states")` works directly.
        """
        import pandas

        return pandas.DataFrame([flatten(record) for record in self.progress])

    def event_frame(self) -> Any:
        import pandas

        return pandas.DataFrame(
            [
                {
                    "seq": event.seq,
                    "epoch": event.epoch,
                    "kind": event.kind,
                    "synopsis": event.synopsis,
                    "plan": event.plan,
                }
                for event in self.events
            ]
        )

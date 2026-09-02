#!/usr/bin/env python3

import io
from pathlib import Path
import unittest
from unittest.mock import AsyncMock, patch

from ergodis_client import (
    ExternalProposalSession,
    ProposalFailure,
    ProposalTicket,
    ProposalTicketView,
    Session,
)
from ergodis_provider import ProviderFailure, ProviderRunner


def view(
    state: str,
    *,
    claim: dict[str, object] | None = None,
    execute_by_ms: int = 2_000,
) -> ProposalTicketView:
    result: dict[str, object] = {
        "ticket_key": "b" * 64,
        "ticket": {
            "spec": {
                "deadlines": {"execute_by_ms": execute_by_ms},
                "max_return_bytes": 64,
            },
            "status": {"state": state},
        },
        "usage": {},
    }
    if claim is not None:
        result["claim"] = claim
    return ProposalTicketView.from_result(result)


def ticket() -> ProposalTicket:
    client = Session(Path.cwd(), Path("unused.sock"), "run", "nonce")
    session = ExternalProposalSession(client, "session", "a" * 64, {}, {})
    return ProposalTicket(session, view("queued"))


class ProviderRunnerTest(unittest.IsolatedAsyncioTestCase):
    async def test_success_uses_deadline_and_streamed_completion(self) -> None:
        proposal = ticket()
        started = view("running", claim={"kind": "started", "attempt": 0})
        ready = view("ready")
        seen = []

        async def call(invocation):
            seen.append(invocation)
            return io.BytesIO(b"proposal")

        with (
            patch.object(
                ProposalTicket,
                "claim_async",
                new=AsyncMock(return_value=started),
            ),
            patch.object(
                ProposalTicket,
                "complete_async",
                new=AsyncMock(return_value=ready),
            ) as complete,
        ):
            outcome = await ProviderRunner(clock_ms=lambda: 1_000).run(proposal, call)
        self.assertEqual(outcome, ready)
        self.assertEqual(seen[0].remaining_ms, 1_000)
        self.assertEqual(seen[0].attempt, 0)
        self.assertEqual(complete.await_args.args[0], 0)

    async def test_deferred_ticket_sleeps_once_without_polling(self) -> None:
        proposal = ticket()
        deferred = view(
            "retry-wait", claim={"kind": "deferred", "not_before_ms": 1_250}
        )
        provider_deferred = view(
            "queued", claim={"kind": "provider-deferred", "retry_at_ms": 1_500}
        )
        terminal = view("terminal-failure", claim={"kind": "terminal"})
        sleeps = []

        async def sleep(delay: float) -> None:
            sleeps.append(delay)

        async def unused(_invocation):
            raise AssertionError("terminal ticket must not invoke provider")

        with patch.object(
            ProposalTicket,
            "claim_async",
            new=AsyncMock(side_effect=[deferred, provider_deferred, terminal]),
        ) as claim:
            outcome = await ProviderRunner(clock_ms=lambda: 1_000, sleep=sleep).run(
                proposal, unused
            )
        self.assertEqual(outcome, terminal)
        self.assertEqual(sleeps, [0.25, 0.5])
        self.assertEqual(claim.await_count, 3)

    async def test_provider_retry_after_is_reported_and_daemon_action_drives_loop(
        self,
    ) -> None:
        proposal = ticket()
        started = view("running", claim={"kind": "started", "attempt": 2})
        retry = view("retry-wait")
        terminal = view("terminal-failure", claim={"kind": "terminal"})

        async def call(_invocation):
            raise ProviderFailure(
                ProposalFailure.PROVIDER_RATE_LIMIT, retry_after_ms=750
            )

        with (
            patch.object(
                ProposalTicket,
                "claim_async",
                new=AsyncMock(side_effect=[started, terminal]),
            ),
            patch.object(
                ProposalTicket,
                "report_failure_async",
                new=AsyncMock(return_value=retry),
            ) as report,
        ):
            outcome = await ProviderRunner(clock_ms=lambda: 1_000).run(proposal, call)
        self.assertEqual(outcome, terminal)
        self.assertEqual(
            report.await_args.args, (2, ProposalFailure.PROVIDER_RATE_LIMIT)
        )
        self.assertEqual(report.await_args.kwargs, {"provider_retry_after_ms": 750})

    async def test_expired_execution_is_reported_without_calling_backend(self) -> None:
        proposal = ticket()
        started = view(
            "running",
            claim={"kind": "started", "attempt": 0},
            execute_by_ms=1_000,
        )
        terminal = view("terminal-failure")
        called = False

        async def call(_invocation):
            nonlocal called
            called = True
            return io.BytesIO()

        with (
            patch.object(
                ProposalTicket,
                "claim_async",
                new=AsyncMock(return_value=started),
            ),
            patch.object(
                ProposalTicket,
                "report_failure_async",
                new=AsyncMock(return_value=terminal),
            ) as report,
        ):
            outcome = await ProviderRunner(clock_ms=lambda: 1_000).run(proposal, call)
        self.assertEqual(outcome, terminal)
        self.assertFalse(called)
        self.assertEqual(report.await_args.args, (0, ProposalFailure.EXECUTION_TIMEOUT))


if __name__ == "__main__":
    unittest.main()

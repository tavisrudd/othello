#!/usr/bin/env python3

import unittest

from asg_session_waste_audit import (
    Event,
    call_subject,
    capped_report,
    command_flags,
    extract_origin_prompt,
    normalized_call,
    transcript_events,
)


class WasteAuditTests(unittest.TestCase):
    def test_review_origin_survives_flattened_markers(self) -> None:
        text = (
            "The following is the Codex agent history ... >>> TRANSCRIPT START "
            "[1] user: go alt-orbits-repair lane [2] assistant: Starting."
        )
        self.assertEqual(extract_origin_prompt(text), "go alt-orbits-repair lane")

    def test_transcript_events_bound_result_at_next_marker(self) -> None:
        content = """\
[53] tool exec call: {"cmd":"ps -eo pid,args"}
[54] tool exec result: Script completed
Output: {"original_token_count":428418,"output":"large"}
[55] assistant: done
"""
        events = transcript_events("review", [{"role": "user", "content": content}])
        self.assertEqual([(event.tool, event.kind) for event in events], [("exec", "call"), ("exec", "result")])
        self.assertEqual(events[1].reported_tokens, 428418)
        self.assertNotIn("done", events[1].text)

    def test_wait_normalization_removes_dynamic_handle_and_duration(self) -> None:
        first = Event("s", 1, "wait", "call", '{"cell_id":"40","yield_time_ms":1000,"max_tokens":2000}')
        second = Event("s", 2, "wait", "call", '{"cell_id":"99","yield_time_ms":30000,"max_tokens":2000}')
        self.assertEqual(normalized_call(first), normalized_call(second))

    def test_command_flags_detect_known_waste_shapes(self) -> None:
        event = Event("s", 1, "exec", "call", '{"cmd":"ps -eo pid,args; rg --files .."}')
        self.assertEqual(command_flags(event), {"poll", "broad-output-risk"})
        self.assertEqual(call_subject(event), "ps -eo pid,args; rg --files ..")

    def test_json_report_sections_are_capped(self) -> None:
        report = {
            "parameters": {},
            "summary": {},
            "sessions": [1, 2, 3],
            "repeated_calls": [1, 2, 3],
            "repeated_nonwait_calls": [1, 2, 3],
            "flagged_patterns": [1, 2, 3],
            "largest_results": [1, 2, 3],
        }
        bounded = capped_report(report, 2)
        self.assertTrue(all(len(bounded[key]) == 2 for key in report if isinstance(report[key], list)))


if __name__ == "__main__":
    unittest.main()

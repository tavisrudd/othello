Read *all* of `../AGENTS.md` before doing anything else in this repository.  Reading it is a
startup barrier: the command that reads it must contain no search, status check, build, or other
repository operation.  Interpret it first, then issue a separate command that follows its rules.

If the user says `go`, `go C<id>`, or just `C<id>` (for example, `go C123`), treat it as a task/lane
routing instruction.  Follow the routing rules in `../AGENTS.md`; never discover the task with a
repository-wide search or a search for the bare numeric portion of the ID.

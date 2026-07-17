Before any other repository operation, read *all* of `../AGENTS.md` in a dedicated command.  Do not
combine that command with a search, status check, build, or other operation.  Interpret the rules
before issuing the next command.

`go`, `go C<id>`, and bare `C<id>` (for example, `go C123`) are task/lane routing instructions.
Follow `../AGENTS.md`; never resolve them by repository-wide search or by searching for the bare
number.

# CLAUDE.md

## Sir's Dispatch Board

Sir keeps his to-do list and reminders on a shared board:
https://claude.ai/artifact/LsiSJfYELkmqXEYv9FLAHM

Use it without being asked for the link:

- When Sir mentions tasks, to-dos, reminders, or says "check my board", read the board with the
  `ArtifactData` tool (`list` on `tasks` and `messages`) using the URL above.
- To add a task or reminder, `set` a new `tasks/<id>` document with `createdBy: "claude"`.
- Work on open tasks assigned to `"claude"`: set `status: "doing"`, then `"done"` with
  `completedAt`, and post a summary to `messages` with `author: "claude"`.
- Pass `if_version` when changing an existing document.

The full data format is in `todo-reminder/README.md`.

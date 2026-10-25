# Dispatch Board

A to-do list and reminder board shared between Sir and Claude.

**Live board:** https://claude.ai/artifact/LsiSJfYELkmqXEYv9FLAHM

`index.html` is the page source. It is hosted as a claude.ai artifact, and its tasks and notes
live in the artifact's database, not in this repo.

## For Claude

When asked to "check the board", use the `ArtifactData` tool with the URL above:

1. `list` the `tasks` collection and the `messages` collection.
2. Work on open tasks where `assignee` is `"claude"`. Set `status: "doing"` while working
   and `status: "done"` with `completedAt` when finished.
3. Reply in `messages` with `author: "claude"`, and set `taskId` when the note is about a task.
4. To add a task or reminder for Sir, `set` a new `tasks/<id>` document with `createdBy: "claude"`.

Use ISO 8601 timestamps with an offset. Pass `if_version` when you change an existing document.

### Schema

```
tasks/<id> {
  title: string,
  notes: string,
  assignee: "sir" | "claude",
  status: "open" | "doing" | "done",
  priority: "high" | "normal" | "low",
  due: ISO string | null,
  remindAt: ISO string | null,
  reminded: boolean,          // set true once the reminder is dismissed
  tags: string[],
  createdBy: "sir" | "claude",
  createdAt, updatedAt: ISO string,
  completedAt: ISO string | null
}

messages/<id> {
  author: "sir" | "claude",
  body: string,
  taskId: string | null,
  model: string | null,
  createdAt: ISO string
}
```

## Updating the page

Change `index.html`, then republish it to the same artifact URL with the Artifact tool,
passing `url` so the link and data are kept.

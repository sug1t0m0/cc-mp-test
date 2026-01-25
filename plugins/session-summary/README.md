# Session Summary Plugin

Summarize and export your Claude Code sessions. Track learnings, decisions, and progress across any project.

## Installation

### Option 1: Install from local directory (for development)

```bash
claude --plugin-dir ./session-summary
```

### Option 2: Install to user scope (recommended for daily use)

```bash
# Add to your personal plugin collection
/plugin install session-summary@your-marketplace
```

## Commands

### `/session-summary:summary`

Generate a structured summary of the current session.

**Output includes:**
- Session overview (date, duration, context)
- What was accomplished
- Key decisions made
- Problems solved
- Files changed
- Next steps
- Open questions

**Example:**
```
/session-summary:summary
```

### `/session-summary:export`

Export the session summary to a markdown file.

**Features:**
- Saves to `.claude-sessions/` directory
- Auto-generates filename with timestamp
- Optional custom title via arguments

**Examples:**
```
/session-summary:export
/session-summary:export feature-authentication
```

**Output location:** `.claude-sessions/session-YYYY-MM-DD-HHMMSS.md`

### `/session-summary:learnings`

Extract TIL (Today I Learned) insights from the session.

**Captures:**
- New knowledge discovered
- Gotchas and pitfalls
- Best practices identified
- Useful commands and snippets
- Reusable code patterns

**Example:**
```
/session-summary:learnings
```

## Use Cases

1. **End of day review**: Run `/session-summary:export` before closing Claude Code
2. **Knowledge capture**: Use `/session-summary:learnings` after solving tricky problems
3. **Handoff documentation**: Generate summaries when passing work to teammates
4. **Personal log**: Build a searchable history of your development sessions

## Tips

- Run `summary` first to preview, then `export` if you want to save
- Use descriptive arguments with `export` to make files easier to find later
- The `.claude-sessions/` folder can be gitignored or committed based on your preference

## Directory Structure

```
session-summary/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── summary.md
│   ├── export.md
│   └── learnings.md
└── README.md
```

## License

MIT

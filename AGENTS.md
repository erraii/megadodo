# Megadodo

Build an Ekşi Sözlük style collaborative dictionary for the international 42 community.
The upstream Django project is a candidate foundation; inspect and run it before adapting it.

## Product decisions
- Public product name: Megadodo. Use English for the user interface and public branding.

- Topics can cover any subject. Do not limit writing to school or programming.
- No mandatory campus, category, or tag selection for topics or entries.
- Shared topics across campuses; local subjects can name their place naturally.
- Writer accounts must eventually be created through verified 42 OAuth identity.
- Public identity is a separately chosen nickname. Do not expose the 42 identity by default.
- Do not silently restrict access to one campus or currently active students.
- Prioritize topics, entries, search, nicknames, ownership checks, and basic moderation.

## Current state

- The existing interface prototype uses sample data and browser drafts only.
- Prototype reference: https://forty-two-sozluk.eraycakiray.chatgpt.site
- This checkout is the Django candidate, not the source of that prototype.
- Real 42 OAuth and a production deployment are not implemented by the development kit.

## Development workflow

- Read docs/local-development.md and docs/UPSTREAM.md first.
- Inspect existing code and dependency locks before changing architecture or versions.
- Work on a task branch with a small, complete scope. Avoid unrelated refactors.
- Check git status before edits; preserve user changes and the upstream license/history.
- Use the upstream Python constraint and lockfile. Do not regenerate locks just to make installation pass.
- Prefer a documented local Docker Compose setup with a persistent database and code reload.
- Bind local application ports to 127.0.0.1. Keep databases and Redis internal to the Compose network.
- Store actual local secrets in ignored .local or .env files. Commit placeholder examples only.
- Never print secret files or tokens. Explain errors without requesting secret values in chat.
- Local admin/test users are for development, not an alternative public registration flow.
- Report what changed, which commands actually passed, and what remains unverified.
- Use focused checks appropriate to the change. Never claim browser or OAuth verification without running it.

## Future 42 login

- Authorization: https://api.intra.42.fr/oauth/authorize
- Token exchange: https://api.intra.42.fr/oauth/token
- Identity: https://api.intra.42.fr/v2/me
- Request public scope; link accounts using the stable numeric 42 id and a unique database constraint.
- Implement unpredictable single-use state bound to the browser; exchange codes server-side.
- Keep client secrets and provider tokens out of the browser, repository, and public profiles.
- App credentials and a registered exact redirect URI are needed for live verification.

## First task

Read docs/FIRST_TASK.md. Complete and document the local development runtime before adding product features.

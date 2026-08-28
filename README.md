# PR #9451 backend-first evidence

Exact reviewed SHA: `49640522938f0a9c9edb97d95fd572bdee8184ef`.

Caption: the terminal recording shows git/PR provenance, representative code
diffs, and a live deterministic backend run proving reward provenance,
atomic PCD/session persistence, BQ-derived realistic fake-LLM CC-to-L4, and
organic resume behavior. The recording bookends the run with the same SHA and
a clean worktree.

![Exact-head backend proof](https://github.com/jleechanorg/pr9451-evidence-20260827/releases/download/backend-4964052/pr9451_backend_evidence.gif)

[Download MP4](https://github.com/jleechanorg/pr9451-evidence-20260827/releases/download/backend-4964052/pr9451_backend_evidence.mp4)

## Clean-computer reproduction

Use the pinned [clean-computer recipe](https://gist.github.com/jleechan2015/1fbf66f77c3276b24b7b11aa4a5891f3).

Expected result: six successful partitions totaling 274 tests plus 11
subtests, an exact `/health.git_commit` match, and exit 0. These deterministic
tests use realistic BQ-derived external-boundary fixtures; they do not claim
native Gemini compliance or real Firestore proof.

## Integrity

Run `shasum -a 256 -c checksums.sha256`. The claim map is in
`metadata.json`; the raw terminal stream is `pr9451_backend_evidence.cast`.

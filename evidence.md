# PR #9451 evidence claim map

This bundle is tied to product commit
`49640522938f0a9c9edb97d95fd572bdee8184ef` on
`fix/level-up-pcd-backend-main`. It reports deterministic backend-first evidence
only. It does not claim that a native Gemini call, Firestore, or browser UI was
exercised.

## M1 - backend contract and deterministic execution

Primary evidence: `pr9451_backend_evidence.cast`, partitions M1, M2A, M2B,
M2C, and the checked-in runner `pr9451_backend_evidence.sh`.

The recorded partitions run prompt/structured-contract, reward-source,
stale-replay, atomic-persistence, auto-apply end-to-end, and organic-resume
suites using the repository's realistic external-boundary fixtures. Results
are M1 `62 passed`, M2A `9 passed`, M2B `104 passed, 11 subtests`, and M2C
`96 passed`: 271 tests plus 11 subtests. The corresponding source fixtures and
associated BQ row identities and hashes are described in `bq_provenance/`;
this public bundle does not claim raw-byte equivalence to private BQ prose.

## M2 - level-up lifecycle and resume behavior

Primary evidence: `pr9451_backend_evidence.cast`, partitions M2A-M2C, with
`mvp_site/tests/test_end2end/test_level_up_auto_apply_end2end.py` and
`testing_mcp/core/test_level_up_organic_resume_unit.py` named in the runner.

These are deterministic tests of the backend's PCD/session persistence and
resume behavior. The fixtures model the external LLM boundary; they are not a
claim that Gemini independently emitted the contract.

## M3 - execution provenance

Primary evidence: `pr9451_backend_evidence.cast`, its provenance bookends and
M3A-M3B partitions. The
recording shows the pre-test and post-test SHA, branch, PR head, and clean
worktree check. M3A records `3 passed`; M3B records a real local-server
`/health.git_commit` equal to the exact product SHA. `metadata.json` records
the exact merge base and diff stat. Native-provider proof remains a separate
follow-up gate.

## Integrity and scope

Run `shasum -a 256 -c checksums.sha256` after obtaining the published bundle.
`artifacts/collection_log.txt` records how the bundle was collected. The BQ
artifact contains metadata and SHA-256 values only; private prompt and response
prose is intentionally absent.

## Claim to artifact map

| Claim | File | Key fields or section |
|---|---|---|
| Model boundary and structured ingress pass | `run.json` | `scenarios[0]` |
| Golden CC-to-L4 and choice amendment pass | `run.json` | `scenarios[1]` |
| Reward atomicity and resume partitions pass | `run.json` | `scenarios[2:4]` |
| Exact-head server handshake passes | `pr9451_backend_evidence.cast` | `M3A`, `M3B`, final SHA check |
| Raw commands, full diff, tests, and process linkage | `artifacts/terminal_transcript.txt` | `GATE 0A-C`, `M1-M3B` |
| Associated BQ row identity/provider metadata | `bq_provenance/result.json` | `rows[].hashes` |

## Evidence integrity

All six scenarios passed with empty `errors` arrays. The bundle uses one root
`checksums.sha256` layer. No live campaign IDs exist for deterministic fixtures;
their `campaign_id` values explicitly record that limitation.

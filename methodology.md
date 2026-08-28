# Evidence methodology

## Scope

The target is PR #9451 at exact product SHA
`49640522938f0a9c9edb97d95fd572bdee8184ef`. This package certifies only the
backend-first deterministic gate that was actually recorded. Native Gemini,
real Firestore, and browser claims are explicitly out of scope.

## Collection

The runner records repository provenance, the full PR commit log and diff, PR
identity, and six focused test/health partitions. It verifies that the SHA before and after
execution is identical and that `git status --porcelain` is empty. The
terminal stream is retained as an asciinema cast and rendered media.

## Test layers

The fixtures are realistic external-boundary request/response shapes derived
from raw BQ gameplay-streaming observations. The deterministic tests exercise
the backend reducer, reward-source attribution, stale-source handling, session
persistence, auto-apply flow, and organic resume flow. They do not replace the
later native Gemini and local-server gates: a fake response can prove backend
behavior only when the response satisfies the agreed contract.

## BQ provenance and privacy

`bq_provenance/query.sql` records the bounded parameterized lookup associated
with the checked-in golden fixtures. `bq_provenance/result.json` records only
campaign/request IDs, timestamps, agent/provider/model labels, event type, and
SHA-256 values. Raw prompt and response text is not copied into this public
bundle. Therefore this artifact proves row identity and provider attribution,
not byte equivalence between private BQ content and the checked-in fixtures.
The result preserves both rows for the duplicated VYEL request ID rather than
silently choosing one.

## Limitations

The recorded run does not include a native provider call, a live Firestore
readback, or browser interaction. It does include a real local-server health
response tied to the tested SHA. The omitted layers must be collected
separately before making their corresponding claims.

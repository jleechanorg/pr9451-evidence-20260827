#!/bin/bash
set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"
EXPECTED_SHA="49640522938f0a9c9edb97d95fd572bdee8184ef"
cd "$REPO_ROOT"

echo "PR #9451 backend-first exact-head evidence"
echo "Recorded: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
echo
echo "GATE 0: EXACT GIT AND LIVE PR IDENTITY"
echo "PWD: $(pwd)"
echo "GIT ROOT: $(git rev-parse --show-toplevel)"
HEAD_SHA=$(git rev-parse HEAD)
echo "HEAD: $HEAD_SHA"
echo "UPSTREAM: $(git rev-parse '@{upstream}')"
echo "PR HEAD: $(gh pr view 9451 --json headRefOid --jq .headRefOid)"
test "$HEAD_SHA" = "$EXPECTED_SHA"
test "$(git rev-parse '@{upstream}')" = "$EXPECTED_SHA"
test "$(gh pr view 9451 --json headRefOid --jq .headRefOid)" = "$EXPECTED_SHA"
test -z "$(git status --porcelain)"
echo "PASS: exact head aligned and worktree clean"
echo
echo "GATE 0A: FULL PR COMMIT LOG"
git --no-pager log --oneline origin/main..HEAD
echo
echo "GATE 0B: FULL PR DIFF"
git --no-pager diff --no-color origin/main...HEAD
echo
echo "GATE 0C: LIVE PR STATUS"
gh pr view 9451 --json url,state,isDraft,headRefOid,baseRefName,mergeable
echo
echo "M1: MODEL BOUNDARY AND STRUCTURED INGRESS"
./vpython -m pytest -q \
  mvp_site/tests/test_structured_fields_utils.py \
  mvp_site/tests/test_agents_levelup_v2_routing.py \
  mvp_site/tests/test_prompt_assembly_routing.py \
  mvp_site/tests/test_levelup_prompt_full_sheet.py
echo
echo "M2A: BQ-DERIVED GOLDEN CC TO L4 WITH CHOICE AMENDMENT"
./vpython -m pytest -q \
  mvp_site/tests/test_end2end/test_level_up_auto_apply_end2end.py
echo
echo "M2B: REWARD PROVENANCE AND ATOMIC PERSISTENCE"
./vpython -m pytest -q \
  mvp_site/tests/test_rewards_box_issue_8020.py \
  mvp_site/tests/test_rev_ovr3z_stale_rewards.py \
  mvp_site/tests/test_level_up_session_atomic_persistence.py
echo
echo "M2C: ORGANIC HARNESS RESUME CONTRACT"
WORLDAI_DEV_MODE=true ./vpython -m pytest -q \
  testing_mcp/core/test_level_up_organic_resume_unit.py
echo
echo "M3A: SERVER SHA HANDSHAKE CONTRACT"
./vpython -m pytest -q mvp_site/tests/test_testing_server_utils.py
echo
echo "M3B: REAL LOCALSERVER HEALTH RESPONSE"
SERVER_PID=$(lsof -tiTCP:8049 -sTCP:LISTEN | head -1)
test -n "$SERVER_PID"
echo "SERVER PID: $SERVER_PID"
echo "SERVER PORT: 8049"
echo "SERVER COMMAND: $(ps -p "$SERVER_PID" -o command=)"
SERVER_CWD=$(lsof -a -p "$SERVER_PID" -d cwd -Fn | sed -n 's/^n//p')
echo "SERVER CWD: $SERVER_CWD"
test "$SERVER_CWD" = "$REPO_ROOT"
test "$(git -C "$SERVER_CWD" rev-parse HEAD)" = "$EXPECTED_SHA"
curl -fsS http://127.0.0.1:8049/health | ./vpython -c \
  'import json,sys; d=json.load(sys.stdin); print(json.dumps(d, sort_keys=True)); assert d["git_commit"] == "49640522938f0a9c9edb97d95fd572bdee8184ef"'
echo "PASS: /localserver reports exact expected SHA"
echo
echo "FINAL EXACT-HEAD CHECK"
POST_SHA=$(git rev-parse HEAD)
echo "PRE:  $HEAD_SHA"
echo "POST: $POST_SHA"
test "$HEAD_SHA" = "$POST_SHA"
test -z "$(git status --porcelain)"
echo "PASS: SHA unchanged and worktree clean"

#!/bin/bash
set -euo pipefail

REPO_ROOT="/Users/jleechan/projects/worktree_exp_not_saving"
cd "$REPO_ROOT"

echo "PR #9451 backend-first evidence"
echo "Recorded: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
echo
echo "1. GIT PROVENANCE"
HEAD_SHA=$(git rev-parse HEAD)
echo "HEAD SHA: $HEAD_SHA"
echo "Branch: $(git branch --show-current)"
echo "Merge-base: $(git merge-base HEAD origin/main)"
echo "PR head: $(gh pr view 9451 --json headRefOid --jq .headRefOid)"
echo
echo "2. COMMIT LOG"
git log --oneline -8
echo
echo "3. KEY DIFFS"
git diff --stat origin/main...HEAD | tail -20
git diff origin/main...HEAD -- mvp_site/structured_fields_utils.py | head -50
git diff origin/main...HEAD -- mvp_site/rewards_engine.py | head -80
echo
echo "4. PR STATUS"
gh pr view 9451 --json number,title,url,headRefName,state --jq .
echo
echo "5. LIVE TEST EXECUTION"
./vpython -m pytest -q \
  mvp_site/tests/test_rewards_box_issue_8020.py \
  mvp_site/tests/test_rev_ovr3z_stale_rewards.py \
  mvp_site/tests/test_level_up_session_atomic_persistence.py \
  mvp_site/tests/test_end2end/test_level_up_auto_apply_end2end.py \
  testing_mcp/core/test_level_up_organic_resume_unit.py
echo
echo "6. POST-TEST SHA VERIFICATION"
POST_SHA=$(git rev-parse HEAD)
echo "Pre-test SHA:  $HEAD_SHA"
echo "Post-test SHA: $POST_SHA"
test "$HEAD_SHA" = "$POST_SHA"
test -z "$(git status --porcelain)"
echo "SHA MATCH; worktree clean"

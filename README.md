# PR #9451 backend-first evidence

Exact reviewed SHA: `2449644e46763c928e93ef1f85c790afcd03c201`.

Caption: the terminal recording shows git/PR provenance, representative code
diffs, and a live deterministic backend run proving reward provenance,
atomic PCD/session persistence, BQ-derived realistic fake-LLM CC-to-L4, and
organic resume behavior. The recording bookends the run with the same SHA and
a clean worktree.

![Exact-head backend proof](https://github.com/jleechanorg/pr9451-evidence-20260827/releases/download/backend-2449644/pr9451_backend_evidence.gif)

[Download MP4](https://github.com/jleechanorg/pr9451-evidence-20260827/releases/download/backend-2449644/pr9451_backend_evidence.mp4)

## Clean-computer reproduction

```bash
git clone https://github.com/jleechanorg/worldarchitect.ai.git
cd worldarchitect.ai
git checkout 2449644e46763c928e93ef1f85c790afcd03c201
python3 -m venv venv
venv/bin/pip install -r mvp_site/requirements.txt
./vpython -m pytest -q \
  mvp_site/tests/test_rewards_box_issue_8020.py \
  mvp_site/tests/test_rev_ovr3z_stale_rewards.py \
  mvp_site/tests/test_level_up_session_atomic_persistence.py \
  mvp_site/tests/test_end2end/test_level_up_auto_apply_end2end.py \
  testing_mcp/core/test_level_up_organic_resume_unit.py
```

Expected result: exit 0 with all selected tests passing. These deterministic
tests use realistic BQ-derived external-boundary fixtures; they do not claim
native Gemini compliance or real Firestore proof.

## Integrity

Run `shasum -a 256 -c checksums.sha256`. The claim map is in
`metadata.json`; the raw terminal stream is `pr9451_backend_evidence.cast`.

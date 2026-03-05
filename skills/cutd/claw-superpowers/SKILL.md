---
name: superpowers
description: >
  Agentic software development methodology — 13 integrated skills for
  disciplined AI-assisted development covering brainstorming, planning,
  TDD, debugging, code review, git worktrees, and branch management.
metadata:
  openclaw:
    emoji: "⚡"
---

# Superpowers

Disciplined, systematic approach to AI-assisted software development. 13 integrated skills covering the full development lifecycle.

## The 7-Step Workflow

1. **Brainstorm** — Design before implementation (Section 2)
2. **Plan** — Write detailed implementation plan (Section 3)
3. **Execute** — Implement with subagents or batches (Sections 4-6)
4. **Test** — TDD throughout: RED-GREEN-REFACTOR (Section 7)
5. **Debug** — Systematic root cause analysis when needed (Section 8)
6. **Review** — Code review after each task (Section 10)
7. **Finish** — Branch completion and integration (Section 12)

## How to Use

Apply the relevant section based on your current task:

| Task | Section |
|------|---------|
| Starting new work | Section 2 (Brainstorming) → Section 3 (Writing Plans) |
| Implementing a plan (this session) | Section 5 (Subagent-Driven Development) |
| Implementing a plan (separate session) | Section 4 (Executing Plans) |
| Multiple independent problems | Section 6 (Dispatching Parallel Agents) |
| Writing or fixing code | Section 7 (Test-Driven Development) |
| Bug, test failure, unexpected behavior | Section 8 (Systematic Debugging) |
| About to claim work is done | Section 9 (Verification Before Completion) |
| After completing work | Section 10 (Code Review) |
| Need isolated workspace | Section 11 (Using Git Worktrees) |
| Ready to merge/integrate | Section 12 (Finishing a Development Branch) |
| Creating new skills | Section 13 (Writing Skills) |

**Skill priority:** Process skills first (brainstorming, debugging), then implementation skills.

**Skill types:**
- **Rigid** (TDD, debugging, verification): Follow exactly. Don't adapt away discipline.
- **Flexible** (patterns, worktrees): Adapt principles to context.

---

## 1. Using Superpowers

**Rule:** Check for applicable sections BEFORE any response or action. Even a 1% chance a section might apply means you should check.

**Process:**
1. User message received
2. Check: might any section apply?
   - Yes → Follow that section
   - No → Respond directly
3. If about to plan: check Section 2 (Brainstorming) first

**Priority order:**
1. Process sections first (brainstorming, debugging)
2. Implementation sections second

**User instructions say WHAT, not HOW.** "Add X" or "Fix Y" doesn't mean skip workflows.

---

## 2. Brainstorming

**Use before:** Any creative work — creating features, building components, adding functionality, or modifying behavior.

<HARD-GATE>
Do NOT write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.
</HARD-GATE>

### Checklist

1. **Explore project context** — check files, docs, recent commits
2. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
3. **Propose 2-3 approaches** — with trade-offs and your recommendation
4. **Present design** — in sections scaled to complexity, get user approval after each section
5. **Write design doc** — save to `docs/plans/YYYY-MM-DD-<topic>-design.md` and commit
6. **Transition to implementation** — follow Section 3 (Writing Plans)

### Process

- Ask one question at a time. Prefer multiple choice.
- Propose 2-3 approaches with trade-offs. Lead with your recommendation.
- Present design sections incrementally. Get approval after each.
- Cover: architecture, components, data flow, error handling, testing.
- Apply YAGNI ruthlessly.

### After Design Approval

Write validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`, commit, then follow Section 3 (Writing Plans).

---

## 3. Writing Plans

**Use when:** You have a spec or requirements for a multi-step task, before touching code.

Write comprehensive implementation plans with bite-sized tasks. Assume the implementer has zero context. Document exact file paths, complete code, exact commands with expected output.

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

### Plan Header Template

Every plan MUST start with:

    # [Feature Name] Implementation Plan
    > **For agent:** REQUIRED: Use Section 4 or Section 5 to implement this plan.
    **Goal:** [One sentence]
    **Architecture:** [2-3 sentences]
    **Tech Stack:** [Key technologies]

### Task Granularity

Each step is one action:
- "Write the failing test" — step
- "Run it to verify it fails" — step
- "Implement minimal code to pass" — step
- "Run tests to verify pass" — step
- "Commit" — step

### Task Structure

    ### Task N: [Component Name]
    **Files:** Create/Modify/Test with exact paths
    **Step 1:** Write failing test (with complete code)
    **Step 2:** Run test, verify fails (exact command + expected output)
    **Step 3:** Write minimal implementation (complete code)
    **Step 4:** Run test, verify passes (exact command + expected output)
    **Step 5:** Commit (exact git commands)

### Execution Handoff

After saving plan, offer:
1. **Subagent-Driven (this session)** — follow Section 5
2. **Parallel Session (separate)** — follow Section 4

---

## 4. Executing Plans

**Use when:** You have a written implementation plan to execute in a separate session with review checkpoints.

### Process

1. **Load and review plan** — Read critically, raise concerns before starting
2. **Execute batch** — Default first 3 tasks. For each: mark in_progress → follow steps exactly → run verifications → mark completed
3. **Report** — Show what was implemented, verification output. Say: "Ready for feedback."
4. **Continue** — Apply feedback, execute next batch, repeat
5. **Complete** — After all tasks verified, follow Section 12 (Finishing a Development Branch)

### Rules

- Follow plan steps exactly
- Don't skip verifications
- Between batches: report and wait
- **STOP executing when:** hit a blocker, plan has gaps, instruction unclear, verification fails repeatedly
- Ask for clarification rather than guessing
- Never start implementation on main/master without explicit consent

### Integration

- REQUIRED: Set up workspace with Section 11 (Git Worktrees) before starting
- After all tasks: follow Section 12 (Finishing a Development Branch)

---

## 5. Subagent-Driven Development

**Use when:** Executing implementation plans with independent tasks in the current session. Fresh subagent per task + two-stage review.

### Process

1. **Read plan, extract all tasks** with full text and context. Create task list.
2. **Per task:**
   a. Dispatch implementer subagent (provide full task text + context, don't make them read plan file)
   b. If subagent asks questions → answer clearly before proceeding
   c. Subagent implements, tests, commits, self-reviews
   d. Dispatch spec reviewer subagent → verify code matches spec
   e. If issues → implementer fixes → re-review until ✅
   f. Dispatch code quality reviewer subagent
   g. If issues → implementer fixes → re-review until ✅
   h. Mark task complete
3. **After all tasks:** Dispatch final code reviewer for entire implementation
4. **Complete:** Follow Section 12 (Finishing a Development Branch)

### Implementer Subagent Prompt

Provide: full task text, context (where it fits), working directory. Tell them:
- Implement exactly what task specifies
- Write tests (TDD if task says to)
- Commit work
- Self-review: completeness, quality, YAGNI, testing
- Report: what implemented, test results, files changed, concerns

### Spec Reviewer Prompt

Provide: full task requirements, implementer's report. Tell them:
- Do NOT trust the implementer's report — read actual code
- Check: missing requirements, extra/unneeded work, misunderstandings
- Report: ✅ spec compliant or ❌ issues with file:line references

### Code Quality Reviewer Prompt

Use code review template (see Section 10). Provide: BASE_SHA, HEAD_SHA, description.
- Only dispatch after spec compliance passes
- Returns: Strengths, Issues (Critical/Important/Minor), Assessment

### Rules

- Never start on main/master without consent
- Never skip reviews (spec OR quality)
- Spec review BEFORE code quality review
- Don't dispatch parallel implementation subagents (conflicts)
- Don't move to next task with open review issues
- If subagent fails → dispatch fix subagent, don't fix manually

---

## 6. Dispatching Parallel Agents

**Use when:** 2+ independent tasks that can be worked on without shared state or sequential dependencies.

### When to Use

- 3+ test files failing with different root causes
- Multiple subsystems broken independently
- Each problem can be understood without context from others
- No shared state between investigations

**Don't use when:** Failures are related, need full system context, or agents would interfere.

### Pattern

1. **Identify independent domains** — group failures by what's broken
2. **Create focused agent tasks** — each gets: specific scope, clear goal, constraints, expected output format
3. **Dispatch in parallel** — one agent per domain
4. **Review and integrate** — read summaries, verify no conflicts, run full test suite

### Agent Prompt Structure

Good prompts are: focused (one problem domain), self-contained (all context needed), specific about output (what to return).

- ❌ Too broad: "Fix all the tests"
- ✅ Specific: "Fix agent-tool-abort.test.ts — 3 failures listed below"
- ❌ No constraints: agent might refactor everything
- ✅ Constrained: "Do NOT change production code" or "Fix tests only"

---

## 7. Test-Driven Development

**Use when:** Implementing any feature or bugfix, before writing implementation code.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

### The Iron Law

    NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST

Write code before the test? Delete it. Start over. No exceptions:
- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Don't look at it
- Delete means delete

### RED — Write Failing Test

Write one minimal test showing what should happen.
- One behavior per test
- Clear descriptive name
- Real code (no mocks unless unavoidable)

### Verify RED

**MANDATORY. Never skip.**

Run test. Confirm: fails (not errors), expected failure message, fails because feature missing.

### GREEN — Minimal Code

Write simplest code to pass the test. Don't add features, refactor, or "improve" beyond the test.

### Verify GREEN

**MANDATORY.**

Run test. Confirm: passes, other tests still pass, output pristine.

### REFACTOR

After green only: remove duplication, improve names, extract helpers. Keep tests green. Don't add behavior.

### Verification Checklist

Before marking work complete:
- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass
- [ ] Output pristine (no errors, warnings)
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered

### Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Need to explore first" | Fine. Throw away exploration, start with TDD. |
| "TDD will slow me down" | TDD faster than debugging. |
| "Already manually tested" | Ad-hoc ≠ systematic. No record, can't re-run. |
| "Deleting X hours is wasteful" | Sunk cost fallacy. Keeping unverified code is debt. |

### Red Flags — STOP and Start Over

Code before test. Test after implementation. Test passes immediately. Rationalizing "just this once."

**All mean: Delete code. Start over with TDD.**

---

## 8. Systematic Debugging

**Use when:** Any bug, test failure, or unexpected behavior — before proposing fixes.

**Core principle:** ALWAYS find root cause before attempting fixes.

### The Iron Law

    NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST

### Phase 1: Root Cause Investigation

1. **Read error messages carefully** — don't skip. Read stack traces completely. Note line numbers, file paths.
2. **Reproduce consistently** — exact steps, every time. Not reproducible → gather more data, don't guess.
3. **Check recent changes** — git diff, recent commits, new dependencies, config changes.
4. **Gather evidence in multi-component systems** — log data at each component boundary. Run once to see WHERE it breaks. Then investigate that component.
5. **Trace data flow** — where does bad value originate? Trace up the call stack to the source. Fix at source, not symptom.

### Phase 2: Pattern Analysis

1. Find working examples of similar code in the codebase
2. Compare: what's different between working and broken?
3. List every difference, however small
4. Understand dependencies and assumptions

### Phase 3: Hypothesis and Testing

1. Form single hypothesis: "X is root cause because Y"
2. Make SMALLEST possible change to test it
3. One variable at a time
4. Didn't work → new hypothesis. DON'T add more fixes on top.

### Phase 4: Implementation

1. Create failing test reproducing the bug (Section 7: TDD)
2. Implement single fix addressing root cause
3. Verify: test passes, no other tests broken
4. **If 3+ fixes failed:** STOP. Question the architecture. Discuss with your human partner.

### Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple" | Simple issues have root causes too. |
| "Emergency, no time" | Systematic is FASTER than thrashing. |
| "Just try this first" | First fix sets the pattern. Do it right. |
| "I see the problem" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+) | 3+ failures = architectural problem. |

---

## 9. Verification Before Completion

**Use when:** About to claim work is complete, fixed, or passing — before committing or creating PRs.

**Core principle:** Evidence before claims, always.

### The Iron Law

    NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE

### The Gate

Before claiming ANY status:
1. **IDENTIFY:** What command proves this claim?
2. **RUN:** Execute the full command (fresh, complete)
3. **READ:** Full output, check exit code, count failures
4. **VERIFY:** Does output confirm the claim?
5. **ONLY THEN:** Make the claim

### What Counts as Verification

| Claim | Requires | NOT Sufficient |
|-------|----------|----------------|
| Tests pass | Test output: 0 failures | Previous run, "should pass" |
| Build succeeds | Build: exit 0 | Linter passing |
| Bug fixed | Test original symptom | Code changed, assumed fixed |
| Requirements met | Line-by-line checklist | Tests passing |

### Red Flags

Using "should", "probably", "seems to". Expressing satisfaction before verification. Trusting agent success reports. Relying on partial verification.

**Run the command. Read the output. THEN claim the result.**

---

## 10. Code Review

**Use when:** Completing tasks, implementing major features, before merging, or when receiving review feedback.

### Part 1: Requesting Review

**Mandatory after:** each task in subagent-driven development, major features, before merge.

**How to request:**
1. Get git SHAs: `BASE_SHA=$(git rev-parse HEAD~1)`, `HEAD_SHA=$(git rev-parse HEAD)`
2. Dispatch code-reviewer subagent with the template below
3. Act on feedback: fix Critical immediately, fix Important before proceeding, note Minor for later

**Code Reviewer Template:**

    You are reviewing code changes for production readiness.
    Review {WHAT_WAS_IMPLEMENTED} against {PLAN_OR_REQUIREMENTS}.
    Git range: {BASE_SHA}..{HEAD_SHA}

    Check: code quality, architecture, testing, requirements, production readiness.

    Output format:
    ### Strengths — what's well done (be specific)
    ### Issues
    #### Critical (Must Fix) — bugs, security, data loss
    #### Important (Should Fix) — architecture, missing features, test gaps
    #### Minor (Nice to Have) — style, optimization
    For each: file:line, what's wrong, why it matters, how to fix
    ### Assessment — Ready to merge? [Yes/No/With fixes]

### Part 2: Receiving Feedback

**Response pattern:** READ → UNDERSTAND → VERIFY → EVALUATE → RESPOND → IMPLEMENT

**Rules:**
- Never say "You're absolutely right!" or "Great point!" (performative)
- Restate the technical requirement or just fix it
- If ANY item is unclear: STOP, clarify ALL items before implementing any
- Implement in order: blocking → simple → complex. Test each fix individually.
- Push back when: suggestion breaks functionality, reviewer lacks context, violates YAGNI, technically incorrect

**When feedback is correct:**
- DO: "Fixed. [Brief description]" or just fix it in code
- DON'T: "Thanks for catching that!" / performative agreement

---

## 11. Using Git Worktrees

**Use when:** Starting feature work that needs isolation or before executing implementation plans.

### Directory Selection (priority order)

1. Check existing: `.worktrees/` (preferred) or `worktrees/`
2. Check `AGENTS.md` for preference
3. Ask user: `.worktrees/` (project-local, hidden) or `~/.config/superpowers/worktrees/<project>/` (global)

### Safety Verification

For project-local directories: verify directory is in `.gitignore` before creating worktree.

    git check-ignore -q .worktrees 2>/dev/null

If NOT ignored: add to `.gitignore`, commit, then proceed.

### Creation Steps

1. Create worktree: `git worktree add "$path" -b "$BRANCH_NAME"`
2. Run project setup (auto-detect: `npm install` / `cargo build` / `pip install` / `go mod download`)
3. Run tests to verify clean baseline
4. Report: location, test results, ready status

### Rules

- Never create worktree without verifying it's ignored (project-local)
- Never skip baseline test verification
- Never proceed with failing tests without asking
- Follow directory priority: existing → AGENTS.md → ask

---

## 12. Finishing a Development Branch

**Use when:** Implementation is complete, all tests pass, ready to integrate.

### Process

1. **Verify tests pass** — if failing, stop. Cannot proceed.
2. **Determine base branch** — `git merge-base HEAD main`
3. **Present exactly 4 options:**
   1. Merge back to base-branch locally
   2. Push and create a Pull Request
   3. Keep the branch as-is
   4. Discard this work
4. **Execute choice**
5. **Cleanup worktree** (for options 1, 2, 4 only)

### Option Details

| Option | Merge | Push | Keep Worktree | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | Yes | - | - | Yes |
| 2. Create PR | - | Yes | Yes | - |
| 3. Keep as-is | - | - | Yes | - |
| 4. Discard | - | - | - | Yes (force) |

### Rules

- Never proceed with failing tests
- Always verify tests on merged result (option 1)
- Require typed "discard" confirmation (option 4)
- Don't force-push without explicit request

---

## 13. Writing Skills

**Use when:** Creating new skills, editing existing skills, or verifying skills work.

### What is a Skill?

A reusable reference guide for proven techniques, patterns, or tools. NOT narratives about how you solved a problem once.

### SKILL.md Structure

    ---
    name: skill-name-with-hyphens
    description: "Use when [specific triggering conditions]"
    ---

Sections: Overview → When to Use → Core Pattern → Quick Reference → Common Mistakes

### The Iron Law (Same as TDD)

    NO SKILL WITHOUT A FAILING TEST FIRST

Test with subagent pressure scenarios. Watch agents fail without skill (RED). Write minimal skill (GREEN). Close loopholes (REFACTOR).

### Key Rules

- Description: "Use when..." — triggering conditions ONLY, never summarize workflow
- Name: verb-first, active voice (`condition-based-waiting` not `async-test-helpers`)
- One excellent example beats many mediocre ones
- Flowcharts only for non-obvious decisions
- Keep inline unless reference >100 lines
- Test BEFORE deploying. No exceptions.

### Skill Creation Checklist

**RED:** Create pressure scenarios → run WITHOUT skill → document baseline failures
**GREEN:** Write skill addressing specific failures → run WITH skill → verify compliance
**REFACTOR:** Find new rationalizations → add counters → re-test until bulletproof

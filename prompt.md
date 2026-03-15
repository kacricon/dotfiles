Study specs/README.md
Pick an implementation plan that is not done on the list, according to what you judge as being the priority or correct order. Study the selected implementation plan and the related spec.
Pick the most important thing to do — your task is to implement then to validate that this functionality works.

IMPORTANT:
    - Always read the code before trusting a spec. If the spec's "Current State" diverges from the code, update the spec first.
    - Update the implementation plan when the task is done.
    - If new things were discovered during execution, update the spec as well.
    - You may implement missing functionality if required (but study the specs before doing so).
    - You may add temporary logging as needed for troubleshooting if needed.
    - Run the spec's verification commands to confirm the changes work.
    - If verification fails, troubleshoot and fix. If you cannot resolve it, commit what you have, document the failure in the spec.
    - If something is ambiguous and you cannot determine the right approach from the specs or code, document the ambiguity in the spec and move on — do not guess.
    - If you discover a concern that doesn't belong in the current spec, create a new spec in specs/ following the existing format, add it to specs/README.md, and note the dependency — but don't implement it in this session unless it blocks the current task.
    - Commit and push when you are done.

EXIT PROTOCOL — as your very last action, write a sentinel file to signal the loop controller:
    - Task completed successfully: run `echo COMPLETE > .claude/loop-sentinel`
    - Stuck and cannot proceed: run `echo STUCK > .claude/loop-sentinel`
    - All specs fully implemented: run `echo IN-SPEC > .claude/loop-sentinel`
    A PostToolUse hook will detect this file and exit the session automatically. The sentinel file write MUST be your absolute last action — do nothing after it.

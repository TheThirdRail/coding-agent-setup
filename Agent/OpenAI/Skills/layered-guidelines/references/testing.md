# Testing And Verification

Use this lane when implementing, fixing, refactoring, reviewing, or claiming completion.

## Guidelines

- Add or update tests for meaningful behavior changes when a test framework exists.
- For bugs, reproduce the failure with a test when practical before fixing it.
- For refactors, preserve behavior and verify affected paths before and after when practical.
- Run the narrowest relevant check available: targeted test, type check, lint, build, browser check, screenshot, or manual inspection.
- Report failing or skipped checks honestly, including the shortest safe recovery path when useful.
- Do not claim fixed, complete, or working unless relevant checks were run, or clearly state what remains unverified.
- Do not mark work complete while critical checks fail.
- For UI changes, verify visible behavior through an appropriate browser, preview, screenshot, or manual inspection path when available.

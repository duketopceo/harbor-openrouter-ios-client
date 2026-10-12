# Roadmap

Program roadmap, 2026-10-11. Extends the open plan in
[`docs/plans/2026-09-22-001-harbor-ios-hardening-plan.md`](docs/plans/2026-09-22-001-harbor-ios-hardening-plan.md) (U1-U4 keep their IDs). Related open PRs: #5 (that plan), #6 (AGENTS.md), #7 (`Color` shadowing fix in `Design.swift`).

**Build status:** cannot be built on this Linux machine (no iOS SDK, SwiftUI/Security unavailable). Only a syntax check was possible: `swiftc -parse` over all 19 files exits 0 (Swift 6.4). That proves nothing about types.

## Now

### P1 - Make the project buildable (status: missing)
Evidence: no `.xcodeproj` or `Package.swift`.
- **Difficulty:** medium (Xcode project must be created on a Mac, or hand-written `project.pbxproj`, or XcodeGen `project.yml`).
- **Feasibility:** needs a Mac or macOS CI; xtool (SwiftPM + Linux) can build iOS apps but SwiftUI previews and Keychain paths need verifying.
- **Simpler alternative:** a `Package.swift` with a pure-Swift `HarborCore` library (Models + OpenRouterService, no SwiftUI/Security) so `swift test` runs on Linux and CI needs no macOS runner for the logic tests; Views and Keychain stay in the app target.

### U1 - Unit tests (existing plan)
- **Difficulty:** medium. **Feasibility:** needs `URLSession` stubbing; on Linux needs `FoundationNetworking`. Keychain tests need a real Apple platform.
- **Simpler alternative:** test decoding and service logic first behind a small `HTTPClient` protocol; skip Keychain tests until a Mac runner exists.

### P2 - Check HTTP status in `OpenRouterService`
Evidence: `fetchModels`/`fetchCredits` ignore the response status. This is behaviour, so it is a roadmap unit and not changed in this docs pass.
- **Difficulty:** easy. **Feasibility:** none. **Simpler alternative:** none; it is the minimal fix and gives U4's error matrix real states.

## Next

### U2 - Xcode CI (existing plan)
- **Difficulty:** medium. **Feasibility:** public repo, hosted macOS runners work; depends on P1.
- **Simpler alternative:** run only `swift test` on Linux for `HarborCore` first.

### P3 - Contrast fix for `faint`
`#6b7280` fails AA on black and on `surface`; `#7c8493` gives 5.58 / 5.02 / 4.62 on black / surface / elevated. One line in `Design.swift`, held back because PR #7 edits the same file and the app cannot be built or screenshotted here.
- **Difficulty:** easy. **Feasibility:** merge #7 first. **Simpler alternative:** use `muted` for captions and delete `faint`.

### U3 / U4 - Release docs, error matrix (existing plan)
- **Difficulty:** easy / easy. **Feasibility:** U3 needs the owner's TestFlight-vs-App-Store decision.
- **Simpler alternative:** fold U4 into `DESIGN.md` as one table.

## Later

### P4 - ToS review of the "match OpenRouter's look" decision
- **Difficulty:** medium (non-engineering). **Feasibility:** README cites ToS section 12; needs a human or legal read.
- **Simpler alternative:** adopt the monochrome Harbor identity as its own (the new mark already does) and drop references to matching their site.

### P5 - Chat persistence and streaming polish
- **Difficulty:** hard. **Feasibility:** SwiftData on iOS 17+. **Simpler alternative:** keep stateless chat; delete nothing now.

### Simplification candidates
`scripts/luke-index-watcher.py` and `INDEX.md` are repo-grounding tooling, not app code; `ContentView.swift` (29 lines) vs `RootView.swift` (16 lines) look like overlapping root views: check which is live before deleting either.

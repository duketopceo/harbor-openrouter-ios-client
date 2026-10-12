# Plan: harbor-openrouter-ios-client → 10/10

**Date:** 2026-09-22 · **Status:** proposed · **Depth:** lightweight
**Origin:** repo scorecard pass — engineering rigor 7, docs 5.

## Problem frame

Harbor is a native SwiftUI iOS client for OpenRouter (BYOK, key in iOS Keychain, no
backend). The README already argues the product case well (good as a personal/power-user
tool; crowded as a product). But with **19 files, zero tests, and zero CI**, every
change to networking, models, or Keychain handling is unverified — exactly the code that
must not break in a credentials-handling app.

## Scope

**In:** XCTest unit tests (models, services, Keychain wrapper), Xcode CI, release docs,
error-handling matrix.
**Out:** new features (model switching UI, widgets, etc.), App Store submission itself,
any backend or key-proxying.

## Implementation units

### U1 — Unit test target
**Files:** `HarborTests/` (new): `ModelDecodingTests.swift`, `OpenRouterServiceTests.swift`,
`KeychainTests.swift`; test fixtures under `HarborTests/Fixtures/`
- Model decoding: OpenRouter `/models` and chat-completion JSON fixtures → decoded
  structs; malformed payloads decode to a typed error, never a crash.
- Service: stubbed `URLSession` — chat completion success, 401 (invalid key), 429
  (rate limit), 500, network timeout.
- Keychain wrapper: save/load/delete round-trip (mock or ephemeral keychain).
**Test scenarios:** 401 → surfaces "key invalid" state (not a generic error); 429 →
surfaces retry-later state; empty models list → empty state UI, no crash; malformed JSON
→ typed decode error.

### U2 — Xcode CI
**Files:** `.github/workflows/ios.yml` (new)
- `xcodebuild build` + `xcodebuild test` on a macOS runner with an iOS Simulator
  destination, on push + PR.
**Test scenarios:** n/a (workflow config) — verify by opening a trivial PR and watching
it run.

### U3 — Release docs
**Files:** `docs/RELEASE.md` (new)
- Versioning scheme, TestFlight checklist, the "never ship as OpenRouter" naming guard,
  API key rotation guidance for users.
**Test scenarios:** n/a — review criterion: a release could be cut from the doc alone.

### U4 — Error-handling matrix
**Files:** `DESIGN.md` (extend) or `docs/ERRORS.md` (new)
- Every network/API failure mode mapped to its UI state (from U1 scenarios).

## Key decisions

- **XCTest** (native) — no third-party test deps in a credentials-handling app.
- BYOK-only forever: no Harbor backend, no key proxying, no markup on API spend.
- Tests stub at the `URLSession` boundary — no live OpenRouter calls in CI.

## Assumptions / open questions

- Distribution: TestFlight-only vs. App Store — owner's call; docs should record it.
- Whether the existing `scripts/luke-index-watcher.py` stays or is unrelated tooling
  (leave as-is; out of scope).

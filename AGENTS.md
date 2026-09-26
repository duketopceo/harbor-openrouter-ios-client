# AGENTS.md — Harbor

Unofficial native iOS client for OpenRouter. 595 lines of Swift across 13
files. Read this before changing anything: the two facts below make the repo
look buildable when it is not, and both fail silently.

## The repo does not build, and there is nothing to build it with

There is **no Xcode project, no workspace, and no `Package.swift`**:

```
$ git ls-files | grep -iE 'xcodeproj|xcworkspace|Package.swift|\.pbxproj|Podfile|project.yml|Tuist'
  NONE
```

So there is no scheme to run, no target to build, and `xcodebuild` has nothing
to point at. If you add a project file you are making an architectural decision
the README explicitly defers ("Repo is a stub until Cursor on-demand can land
the SwiftUI skeleton"). Don't, unless asked.

## It does not compile either

The one gate that is available is a parse check, and it passes:

```
$ swiftc -parse $(find Harbor -name '*.swift')
$ echo $?
0
```

A full typecheck does **not** pass, and the reason is a real bug, not a
toolchain artefact:

```
$ swiftc -typecheck $(find Harbor -name '*.swift') 2>&1 | grep -cE '^Harbor/.*error:'
8
$ swiftc -typecheck $(find Harbor -name '*.swift') 2>&1 | grep -E '^Harbor/.*error:' | sed 's/.*error: //' | sort | uniq -c
   8 'HarborDesign.Color' cannot be constructed because it has no accessible initializers
```

`Harbor/Design.swift` nests an `enum Color` inside `enum HarborDesign`. Inside
that scope the name `Color` resolves to `HarborDesign.Color` — the enum itself
— instead of `SwiftUI.Color`. `HarborDesign.Color` has no cases and no
initializers, hence the error on every token.

There are **14** `Color(hex:)` call sites but the compiler reports **8**
diagnostics — it caps duplicate errors of this shape. Do not read "8" as "8
broken lines".

The fix is to disambiguate all 14 call sites, e.g.
`SwiftUI.Color(hex: 0x000000)`. One qualifier per line, no behaviour change.
Verified: 8 errors → 1, and the single survivor is
`'navigationBarDrawer(displayMode:)' is unavailable in macOS`, which is an
iOS-only API compiled against the macOS SDK (see the note below), not a repo
defect.

Until that lands, `swiftc -parse` is the only honest gate. Do not report this
repo as "building" or "green" on the basis of a parse.

Note that `swiftc -typecheck` on a Mac targets the **macOS** SDK, not iOS, so
treat it as a linter for shadowing and name-resolution bugs, not as proof the
app compiles for its real target. iOS-only APIs will error spuriously — for
example `.searchable(placement: .navigationBarDrawer(displayMode:))` in
`Harbor/Views/ModelPickerView.swift:31` is marked
`@available(macOS, unavailable)` by the SDK itself. The absence of an
`#if os(iOS)` guard there is correct for an iOS-only app with no deployment
target set; do not add one to silence a macOS typecheck.

## Design tokens are contract, not suggestion

`DESIGN.md` is a reconstruction of OpenRouter's 2026 Bauhaus refresh and is the
source of truth for every value in `Harbor/Design.swift`. The two must not
drift. `Design.swift` is currently 14 `Color(hex:)` constants and 5
`Font.system` constants that mirror the `Dark (default)` and `Type` tables in
`DESIGN.md` exactly.

If you change a hex in `Design.swift`, change the table in `DESIGN.md` in the
same commit. If you find a mismatch, that is a bug in one of the two — say
which, do not silently pick one.

`DESIGN.md` also records the rules the README states: no drop shadows, hairline
borders, near-black canvas, colour reserved for status. Dark and light are
distinct environments, **not** inverted palettes.

## Legal and identity constraints — these are not stylistic

From the README's own ToS analysis (OpenRouter ToS, 2026-08-31):

- **§7** — do not resell API access and do not build a competing service. A
  BYOK client is fine; a proxy or a markup is not. Do not scrape the Site.
- **§12** — OpenRouter's visual design, graphics and logo are their Materials.
  Match the *look*; do not use their logo or wordmark, and do not imply
  official status.
- The app display name is **Harbor**. It must never ship as "OpenRouter".
- Any App Store listing must stay clearly unofficial.

There is no Harbor backend, by design. `OpenRouterService` talks directly to
`https://openrouter.ai/api/v1` and sends the user's own key. Adding a proxy
server to this app would violate §7 and is out of scope.

## Keychain invariants

`Harbor/Services/Keychain.swift` is the only place the API key is persisted.

- Service `ai.harbor.app`, account `apiKey`. Both are load-bearing — changing
  either orphans every stored key on every device with no migration.
- `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` is deliberate. Do not
  "improve" it to `AfterFirstUnlock` or `WhenUnlocked`; `ThisDeviceOnly` is what
  keeps the key off iCloud Keychain and off restored backups.
- The setter is **delete-then-add**, not `SecItemUpdate`, and setting an empty
  value deletes the item. That is intentional so the accessibility attribute is
  always rewritten. Converting it to an update path silently keeps a stale
  attribute.
- The key is held in memory on `@Observable var apiKey: String` for the session.
  That is a real exposure surface — avoid logging `OpenRouterService`, and never
  put the key in a `print`, a `UserDefaults` key, or an error message.

`HTTP-Referer` is hardcoded to `https://github.com/duketopceo/harbor`, which
GitHub redirects to this repo. It still resolves, but the name is stale.

## Layout

```
Harbor/
  HarborApp.swift              @main entry
  RootView.swift               top-level switch on key presence
  ContentView.swift            the main screen
  Design.swift                 tokens — mirrors DESIGN.md
  Models/OpenRouter.swift      Codable wire types (snake_case keys, no mapping)
  Services/Keychain.swift      key persistence
  Services/OpenRouterService.swift  @Observable, URLSession, all network I/O
  Views/                       ChatView, CreditsView, ModelPickerView, ...
```

`Models/OpenRouter.swift` uses the API's snake_case field names verbatim
(`context_length`, `top_provider`, `total_credits`). There is no
`CodingKeys` mapping. If you add a model, match the wire format directly and do
not "tidy" the names — there is no decoder strategy configured to absorb it.

`@Observable` requires iOS 17 / macOS 14. There is no `@available` fallback
anywhere, which is consistent with there being no deployment target set yet.

## `INDEX.md` is generated — do not hand-edit it

`INDEX.md` is produced by `scripts/luke-index-watcher.py` and must be
regenerated after non-trivial changes:

```bash
python scripts/luke-index-watcher.py           # regenerate
python scripts/luke-index-watcher.py --check   # exit 1 if stale
```

`--check` currently **fails** on this repo — `INDEX.md` was last synced
2026-09-10 and the tree has moved since. That is pre-existing, not something
your change caused. Regenerating it produces a large diff; keep it in its own
commit so it does not obscure the real change.

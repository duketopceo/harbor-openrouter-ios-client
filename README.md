<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/brand/wordmark-dark.svg">
    <img alt="Harbor" src="assets/brand/wordmark.svg" height="64">
  </picture>
</p>

**Unofficial** native iOS client for [OpenRouter](https://openrouter.ai). Not affiliated with, endorsed, or sponsored by OpenRouter, Inc.

BYOK only. Key lives in iOS Keychain. Requests go to `https://openrouter.ai/api/v1`. No Harbor backend, no markup, no resale of API access.

App display name: **Harbor**. Never ship as "OpenRouter".

## Is this a good idea?

**Yes as a personal/power-user tool.** OpenRouter has no first-party iOS app. Luke already lives in OpenRouter (`a0-openrouter-spend`, `openrouter_usage`, `openrouter-demos`) and would use this for model switching, spend, and chat on a phone.

**Crowded as a product.** App Store already has unofficial clients: Sleek BYOK, Oqta, RouterChat. Late unless Harbor is the one that *looks* like the 2026 OpenRouter site, shows credits/usage honestly, and stays local-first.

### Who

- OpenRouter power users with an existing key
- Indie hackers who refuse a ChatGPT-only app
- People checking credits/limits on the go

### What for

Chat, model picker, streaming, credits/usage. Not a competing aggregator.

### Risks (ToS, 2026-08-31)

- §7: do not resell API access or develop a competing service. BYOK client is fine; a proxy/markup is not. No scraping the Site.
- §12: visual interfaces, graphics, and design are OpenRouter Materials. Match the *look* in `DESIGN.md`. Do not use their logo, OR mark, or claim official status.
- App Store listing must stay clearly unofficial.

## Status

SwiftUI sources for a chat view, model picker, credits view and Keychain-backed key entry exist under `Harbor/` (19 files). There is **no Xcode project or Swift package yet**, so the app does not build, and there are no tests or CI. Building needs a Mac with the iOS SDK; on Linux only a syntax check (`swiftc -parse`) is possible. See [ROADMAP.md](ROADMAP.md).

## How it works
```text
ConnectKeyView -> Keychain (this-device-only, when unlocked) -> OpenRouterService
   -> https://openrouter.ai/api/v1  (/models, /credits, chat)  -> ChatView / ModelPickerView / CreditsView
```
No Harbor backend sits in between.

## Screenshots
TODO: needs a Mac or simulator build (see Status).

## Quick start
Not available until the project file exists (ROADMAP P1). Planned: open `Harbor.xcodeproj`, run on a simulator, paste an OpenRouter key on the connect screen.

## Design and brand
[DESIGN.md](DESIGN.md). The logo in `assets/brand/` is a proposal pending owner sign-off.

## Contributing
Issues and PRs welcome. Never ship under the name "OpenRouter"; keep BYOK-only.

## Licence
See [LICENSE](LICENSE).

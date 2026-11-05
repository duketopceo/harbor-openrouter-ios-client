# Landscape: native OpenRouter clients

Written 2026-10-11 from one round of web searches plus the code. The README's own competitor list (Sleek BYOK, Oqta, RouterChat) predates this and was not re-verified except RouterChat.

## Others in the space
- **RouterChat**: native iPhone/iPad client; its store listing says the OpenRouter key is kept in the device Keychain, chats/settings can sync through iCloud, and it supports sign-in with OpenRouter or an API key. [listing](https://mwm.ai/apps/routerchat/6776368852).
- **openchat** (open source): SwiftUI + SwiftData, Keychain key storage, iOS 17+. [GitHub](https://github.com/eliasfloreteng/openchat).
- **OpenRouter's own BYOK feature**: lets users attach provider keys to OpenRouter; a different thing from a client storing an OpenRouter key. [OpenRouter blog](https://openrouter.ai/blog/bring-your-own-api-keys).
- **Aiyo** (Android, open source): BYOK chat client on OpenRouter. [F-Droid mirror](https://apt.izzysoft.de/fdroid/index/apk/com.beradeep.aiyo?repo=main).

## What they do better
Shipped and on the App Store; persistence (SwiftData / iCloud); OAuth sign-in as an alternative to pasting a key. Harbor has no chat persistence and no error states beyond a string.

## What users expect
Key stays in the Keychain, streaming chat, model search with prices, visible credit balance, clear "unofficial" labelling.

## What is unique here
The product bet in the README: credits/usage shown plainly, local-first, no backend, and a visual identity aimed at the OpenRouter site's look. That last point is the riskiest: the README quotes ToS section 12 (OpenRouter Materials include design), so "match the look" needs a legal read before App Store submission.

## Findings from reading the code
- No Xcode project or `Package.swift` exists, so the repo cannot be built as-is (PR #6 records this).
- `OpenRouterService` decodes responses without checking the HTTP status, so a 401 surfaces as a decode error string.
- `HTTP-Referer` is `https://github.com/duketopceo/harbor`, not this repo's name.
- `HarborDesign.Color.faint` (`#6b7280`) is 4.34:1 on black and 3.91:1 on `surface`: below WCAG AA (4.5) for small text. Used for captions in `ModelRow` and `CreditsView`.
- The README status paragraph ("repo is a stub") is out of date: 19 Swift files exist.

# DESIGN.md — Harbor (unofficial)

Reconstructed visual system for a native iOS client that should *feel* like OpenRouter's 2026 site (brand refresh 2026-07-13, Bauhaus / form-follows-function). Not an official OpenRouter document. Do not ship their logo or wordmark.

Verify tokens against live CSS on https://openrouter.ai before pixel-pushing. OpenRouter's Materials stay theirs (§12).

## Principles

- Near-black canvas, white type, almost no color except status.
- Hairline borders, no drop shadows.
- Dark and light are distinct environments, not inverted palettes.
- Brand voltage is white, not a colored logo bar.
- Data (models, prices, latency) is typographic, not illustrated.

## Dark (default)

| Token | Hex | Use |
|---|---|---|
| bg | `#000000` | canvas |
| surface | `#111111` | cards |
| surface-elevated | `#1a1a1a` | nested |
| text | `#ffffff` | headlines |
| text-body | `#d4d4d4` | body |
| text-muted | `#9ca3af` | captions, links |
| text-faint | `#6b7280` | fine print |
| border | `#1f1f1f` | 1px hairline |
| border-strong | `#2a2a2a` | inputs, rows |
| on-brand | `#000000` | text on white CTA |
| success | `#22c55e` | model online |
| danger | `#ef4444` | model down |
| warning | `#fbbf24` | highlight |
| info | `#3b82f6` | rare info |

White CTA on black. Links are gray, hover/press to white. No colored brand.

## Type

Geometric grotesque, system fallback: SF Pro for UI, SF Mono for prices/tokens/model IDs.

- Display 28–34 / semibold — screen titles
- Title 20 / semibold — model name
- Body 16 / regular — chat
- Caption 13 / regular — credits, latency
- Mono 13 — `$ / 1M`, token counts

## Layout (iOS)

- Chat: black canvas, composer hairline, assistant bubbles on `surface`, user on `surface-elevated`.
- Model picker: full-height sheet, search, rows with name + provider + price in mono. Emerald/rose dot for up/down.
- Credits: one number, large, white. Secondary: remaining / used, no charts.
- Onboarding: paste key, white button "Connect". No OAuth required for v1 (key-in-Keychain).

## Mark

Harbor uses a distinct unofficial mark: a simple gap in a circle (a harbor mouth), not an OR monogram. Never the OpenRouter logo.

## Program pass (2026-10-11)

Status: audit and proposal. No app code was changed because the app cannot be built or screenshotted on this machine.

**Direction name:** Harbor Mouth (monochrome, hairline, one gap).

**Logo proposal** (owner signs off): `assets/brand/` holds an SVG of the existing `HarborMark` geometry (300 degree arc, round caps), a dark variant and a wordmark. It is monochrome by design and is not the OpenRouter logo.

**Contrast audit** (WCAG, computed):

| Pair | Ratio | AA text (4.5) |
|---|---|---|
| text-muted `#9ca3af` on bg | 8.27 | pass |
| text-body `#d4d4d4` on surface | 12.74 | pass |
| text `#ffffff` on surface-elevated | 17.4 | pass |
| danger `#ef4444` on surface | 5.02 | pass |
| success `#22c55e` on bg | 9.22 | pass |
| text-faint `#6b7280` on bg | 4.34 | **fail** |
| text-faint `#6b7280` on surface | 3.91 | **fail** |

Proposed `faint` replacement: `#7c8493` (5.58 on bg, 5.02 on surface, 4.62 on elevated). Tracked as ROADMAP P3.

**Motion:** none beyond SwiftUI defaults; respect Reduce Motion for any streaming-text animation.

**Note on section 12:** the README quotes OpenRouter ToS section 12 on design materials; the "feel like OpenRouter" principle above should be reviewed (ROADMAP P4).
